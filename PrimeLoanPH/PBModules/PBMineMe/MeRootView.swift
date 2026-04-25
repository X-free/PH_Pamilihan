//
//  MeRootView.swift
//  PrimeLoanPH
//

import SwiftUI
import UIKit

private struct PBMRemoteMenuIcon: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> UIImageView {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        PPTools.pb_loadRemoteIcon(uiView, url: urlString, placeholder: "icon_ID")
    }
}

struct MeRootView: View {
    @ObservedObject var viewModel: MeViewModel
    var onStatTap: (Int) -> Void
    var onRowTap: (MeMenuRow) -> Void
    var onRefreshAsync: () async -> Void

    private let cardCorner: CGFloat = 16
    private let horizontal: CGFloat = 16
    /// Apply / Repayment / Finished 与竖向分隔线统一行高，便于垂直居中对齐
    private let statRowHeight: CGFloat = 56
    /// 头像外圈尺寸；中心落在白卡片顶边（centerY == card.top）
    private let avatarOuterSize: CGFloat = 88
    /// 头像（profile）顶边距 safe area 顶部
    private let profileIconTopFromSafe: CGFloat = 22

    var body: some View {
        ZStack(alignment: .top) {
            backgroundLayer
            scrollWithOptionalRefresh
        }
    }

    @ViewBuilder
    private var scrollWithOptionalRefresh: some View {
        let content = ScrollView {
            VStack(spacing: 0) {
                profileCard
                regulatoryFooter
                    .padding(.top, 20)
                    .padding(.bottom, 28)
            }
        }
        if #available(iOS 15.0, *) {
            content.refreshable {
                await onRefreshAsync()
            }
        } else {
            content
        }
    }

    private var backgroundLayer: some View {
        GeometryReader { geo in
            let h = geo.size.height * 0.32
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [
                        Color(UIColor.pbColorBackHexStr("#FFE082")),
                        Color(UIColor.pbColorBackHexStr("#FBF6E7"))
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: max(h, 200))
                Color(UIColor.pbColorBackHexStr("#FBF6E7"))
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
        }
    }

    private var profileCard: some View {
        let avatarHalf = avatarOuterSize / 2
        return ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: cardCorner, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)

            VStack(spacing: 0) {
                // 卡片顶边到手机号：盖住头像下半区 + 间距
                Color.clear
                    .frame(height: avatarHalf + 8)

                Text(viewModel.phoneDisplay)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(UIColor.pbColorBackHexStr("#262626")))

                statRow
                    .padding(.horizontal, 8)
                    .padding(.top, 8) // 相对原 20 上移 12pt
                    .padding(.bottom, 16)

                Divider()
                    .background(Color(UIColor.pbColorBackHexStr("#E8E8E8")))

                menuList
            }
            .padding(.horizontal, 4)
            .padding(.top, 0)
            .padding(.bottom, 8)

            // profile icon：几何中心落在白卡片顶边（与旧版「压在顶边」设计一致）
            avatarView
                .offset(y: -avatarHalf)
        }
        .padding(.horizontal, horizontal)
        // 顶边距 safe top 22 + 半头像高度，使头像顶 = safe+22 且中心压在卡片顶边
        .padding(.top, profileIconTopFromSafe + avatarOuterSize / 2)
    }

    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(Color(UIColor.pbColorBackHexStr("#E3F2FD")))
                .frame(width: avatarOuterSize, height: avatarOuterSize)
            Image("rpiofileicon")
                .resizable()
                .scaledToFill()
                .frame(width: avatarOuterSize - 8, height: avatarOuterSize - 8)
                .clipShape(Circle())
        }
        .frame(width: avatarOuterSize, height: avatarOuterSize)
    }

    private var statRow: some View {
        HStack(alignment: .center, spacing: 0) {
            statColumn(value: viewModel.statApply, title: "Apply", index: 0)
            thinDivider
            statColumn(value: viewModel.statRepay, title: "Repayment", index: 1)
            thinDivider
            statColumn(value: viewModel.statFinished, title: "Finished", index: 2)
        }
        .frame(height: statRowHeight)
    }

    private var thinDivider: some View {
        Rectangle()
            .fill(Color(UIColor.pbColorBackHexStr("#E8E8E8")))
            .frame(width: 1 / UIScreen.main.scale)
            .frame(maxHeight: .infinity)
    }

    private func statColumn(value: String, title: String, index: Int) -> some View {
        Button {
            onStatTap(index)
        } label: {
            VStack(alignment: .center, spacing: 6) {
//                Text(value)
//                    .font(.system(size: 22, weight: .bold))
//                    .foregroundColor(Color(UIColor.pbColorBackHexStr("#262626")))
//                    .multilineTextAlignment(.center)
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(Color(UIColor.pbColorBackHexStr("#8C8C8C")))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .buttonStyle(.plain)
    }

    private var menuList: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.menuRows.enumerated()), id: \.offset) { idx, row in
                menuRow(row)
                if idx < viewModel.menuRows.count - 1 {
                    Divider()
                        .background(Color(UIColor.pbColorBackHexStr("#F0F0F0")))
                        .padding(.leading, 52)
                }
            }
        }
    }

    private func menuRow(_ row: MeMenuRow) -> some View {
        Button {
            onRowTap(row)
        } label: {
            HStack(spacing: 12) {
                PBMRemoteMenuIcon(urlString: row.iconURL)
                    .frame(width: 28, height: 28)
                Text(row.title)
                    .font(.system(size: 16))
                    .foregroundColor(Color(UIColor.pbColorBackHexStr("#262626")))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(UIColor.pbColorBackHexStr("#CCCCCC")))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var regulatoryFooter: some View {
        Image("roup19900371")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: UIScreen.main.bounds.width - horizontal * 2)
            .padding(.horizontal, horizontal)
    }
}
