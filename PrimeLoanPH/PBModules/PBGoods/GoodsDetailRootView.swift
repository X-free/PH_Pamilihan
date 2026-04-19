//
//  GoodsDetailRootView.swift
//  PrimeLoanPH
//

import SwiftUI
import UIKit

private struct GoodsRemoteIconView: UIViewRepresentable {
    let url: String
    let placeholder: String

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        PPTools.pb_loadRemoteIcon(uiView, url: url, placeholder: placeholder)
    }
}

struct GoodsDetailRootView: View {
    @ObservedObject var state: GoodsDetailViewState
    var onStepTap: (Int) -> Void
    var onAgreementTap: () -> Void
    var onAgreementToggle: () -> Void
    var onApplyTap: () -> Void

    private let cream = Color(UIColor.pbColorBackHexStr("#FBF6E7"))
    /// 与全案 `ordtopbg` 一致：高/宽 = 400/375
    private var ordtopbgHeightWidthRatio: CGFloat { 400.0 / 375.0 }

    /// 无接口文案时用不换行空格占位，避免 `Text("")` 塌高度、布局错位
    private func displayLine(_ raw: String) -> String {
        let t = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? "\u{00A0}" : t
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                backgroundLayer(width: geo.size.width)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        summaryCard
                        certifySection
                        agreementRow
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 90)
                }
                VStack {
                    Spacer()
                    applyButton
                        .padding(.horizontal, 14)
                        .padding(.bottom, geo.safeAreaInsets.bottom + 15)
                }
            }
        }
        .ignoresSafeArea(edges: [.top, .bottom])
    }

    private func backgroundLayer(width: CGFloat) -> some View {
        ZStack(alignment: .top) {
            cream
                .ignoresSafeArea(edges: [.top, .bottom])
            Image("ordtopbg")
                .resizable()
                .scaledToFill()
                .frame(width: width)
                .frame(height: width * ordtopbgHeightWidthRatio)
                .clipped()
        }
    }

    private var summaryCard: some View {
        ZStack(alignment: .top) {
            Image("GroupdetailHeader900487")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)

            VStack(spacing: 0) {
                Text(displayLine(state.productTitle))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(UIColor.pbColorBackHexStr("#262626")))
                    .padding(.top, 35)

                Text(displayLine(state.amountCaptionText))
                    .font(.system(size: 14))
                    .foregroundColor(Color(UIColor.pbColorBackHexStr("#8C8C8C")))
                    .padding(.top, 12)

                Text(displayLine(state.amountText))
                    .font(.system(size: 35, weight: .heavy))
                    .foregroundColor(Color(UIColor.pbColorBackHexStr("#262626")))
                    .padding(.top, 4)

                HStack(spacing: 0) {
                    metricCol(title: state.loanTermTitle, value: state.loanTermValue)
                    metricCol(title: state.interestRateTitle, value: state.interestRateValue)
                }
                .padding(.top, 10)

                if !state.logoURLs.isEmpty {
                    HStack(spacing: 10) {
                        ForEach(Array(state.logoURLs.prefix(4).enumerated()), id: \.offset) { _, url in
                            GoodsRemoteIconView(url: url, placeholder: "logo_Group")
                                .frame(width: 62, height: 30)
                        }
                    }
                    .padding(.top, 14)
                    .padding(.bottom, 14)
                } else {
                    Image("GroudetailLogo0450")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 12)
                        .padding(.top, 18)
                        .padding(.bottom, 14)
                }
            }
            .padding(.horizontal, 10)
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func metricCol(title: String, value: String) -> some View {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let v = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return VStack(spacing: 2) {
            Text(t)
                .font(.system(size: 12.5))
                .foregroundColor(Color(UIColor.pbColorBackHexStr("#8C8C8C")))
            Text(v)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(UIColor.pbColorBackHexStr("#262626")))
        }
        .frame(maxWidth: .infinity)
    }

    private var certifySection: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 8) {
                ForEach(Array(state.steps.enumerated()), id: \.offset) { idx, step in
                    stepRow(index: idx, step: step)
                }
            }
            .padding(10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .zIndex(2)

            Text("Certifcation conditions")
                .font(.system(size: 15.5, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 18)
                .padding(.top, 8)
                .frame(width: 305, height: 67, alignment: .topLeading)
                .background(Color(UIColor.pbColorBackHexStr("#FB6E21")))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                // 组件 top = 卡片列表 top -35
                .offset(y: -35)
                .zIndex(1)
        }
        .padding(.top, 35)
    }

    private func stepRow(index: Int, step: PPDetailValuingModel) -> some View {
        let certified = step.acknowledges == 1
        let r12 = pbGoodsDetailRatio(12)
        let r8 = pbGoodsDetailRatio(8)
        let r10 = pbGoodsDetailRatio(10)
        let r15 = pbGoodsDetailRatio(15)
        let r38 = pbGoodsDetailRatio(38)
        let pillW = pbGoodsDetailRatio(108)
        let pillH = pbGoodsDetailRatio(38)
        let pillCorner = pbGoodsDetailRatio(19)
        let pillLabelSize = pbGoodsDetailRatio(9)

        return Button {
            onStepTap(index)
        } label: {
            HStack(alignment: .center, spacing: r12) {
                VStack(alignment: .leading, spacing: r8) {
                    Text(step.age ?? "")
                        .font(.system(size: pbGoodsDetailRatio(16), weight: .bold))
                        .foregroundColor(Color(UIColor.pbColorBackHexStr("#262626")))
                    ZStack {
                        if certified {
                            RoundedRectangle(cornerRadius: pillCorner, style: .continuous)
                                .fill(Color(UIColor.pbColorBackHexStr("#EDE5D8")))
                            Text("Certified")
                                .font(.system(size: pillLabelSize, weight: .bold))
                                .foregroundColor(Color(UIColor.pbColorBackHexStr("#FB6E21")))
                        } else {
                            Image("Rectastatubg6999")
                                .resizable()
                                .scaledToFill()
                            Text("Get certified")
                                .font(.system(size: pillLabelSize, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: pillW, height: pillH)
                    .clipShape(RoundedRectangle(cornerRadius: pillCorner, style: .continuous))
                }
                Spacer(minLength: 0)
                GoodsRemoteIconView(url: step.goals ?? "", placeholder: "logo_Group")
                    .frame(width: r38, height: r38)
            }
            .padding(.leading, r12)
            .padding(.vertical, r10)
            .padding(.trailing, r15)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.pbColorBackHexStr("#F5F5F5")))
            .clipShape(RoundedRectangle(cornerRadius: pbGoodsDetailRatio(8), style: .continuous))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var agreementRow: some View {
        if state.showAgreement {
            HStack(spacing: 8) {
                Button(action: onAgreementToggle) {
                    Image(state.agreementChecked ? "signin_icon_selected" : "signin_icon_select")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(.plain)

                Text("I consent to the")
                    .font(.system(size: 13))
                    .foregroundColor(Color(UIColor.pbColorBackHexStr("#8C8C8C")))

                Button(action: onAgreementTap) {
                    Text("Privacy Agreement")
                        .font(.system(size: 13))
                        .foregroundColor(Color(UIColor.pbColorBackHexStr("#C58A4C")))
                        .underline()
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.top, 4)
        }
    }

    private var applyButton: some View {
        Button(action: onApplyTap) {
            ZStack {
                Image("Roundedrectangle")
                    .resizable()
                    .scaledToFill()
                Text(displayLine(state.applyTitle))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
        .opacity(state.applyEnabled ? 1 : 0.45)
        .disabled(!state.applyEnabled)
    }
}

/// 与 `PB_Ratio` 一致，供详情认证行尺寸换算
private func pbGoodsDetailRatio(_ x: Double) -> CGFloat {
    CGFloat(x * (UIScreen.main.bounds.width / 375.0))
}
