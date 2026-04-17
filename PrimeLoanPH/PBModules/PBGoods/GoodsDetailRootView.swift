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
    var onBack: () -> Void
    var onStepTap: (Int) -> Void
    var onAgreementTap: () -> Void
    var onAgreementToggle: () -> Void
    var onApplyTap: () -> Void

    private let cream = Color(UIColor.pbColorBackHexStr("#FBF6E7"))

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                backgroundLayer(safeTop: geo.safeAreaInsets.top)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        topBar
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

    private func backgroundLayer(safeTop: CGFloat) -> some View {
        ZStack(alignment: .top) {
            cream
                .ignoresSafeArea(edges: [.top, .bottom])
            Image("ordtopbg")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 240 + safeTop)
                .clipped()
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: onBack) {
                Image("icon_return_black")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .frame(width: 44, height: 44, alignment: .leading)

            Spacer()

            Text("Product detail")
                .font(.system(size: 15.5, weight: .medium))
                .foregroundColor(Color(UIColor.pbColorBackHexStr("#262626")))

            Spacer()
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.top, 4)
    }

    private var summaryCard: some View {
        ZStack(alignment: .top) {
            Image("GroupdetailHeader900487")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)

            VStack(spacing: 0) {
                Text(state.productTitle)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(UIColor.pbColorBackHexStr("#262626")))
                    .padding(.top, 35)

                Text("Maximum loan amount")
                    .font(.system(size: 14))
                    .foregroundColor(Color(UIColor.pbColorBackHexStr("#8C8C8C")))
                    .padding(.top, 12)

                Text(state.amountText)
                    .font(.system(size: 35, weight: .heavy))
                    .foregroundColor(Color(UIColor.pbColorBackHexStr("#262626")))
                    .padding(.top, 4)

                HStack(spacing: 0) {
                    metricCol(title: "Loan term", value: state.termText)
                    metricCol(title: "Interest rate", value: state.rateText)
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
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: 12.5))
                .foregroundColor(Color(UIColor.pbColorBackHexStr("#8C8C8C")))
            Text(value)
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
        Button {
            onStepTap(index)
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(step.age ?? "")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(UIColor.pbColorBackHexStr("#262626")))
                    ZStack {
                        Image("Rectastatubg6999")
                            .resizable()
                            .scaledToFill()
                        Text(step.acknowledges == 1 ? "Certified" : "Get certified")
                            .font(.system(size: 18 * 0.5, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(width: 108, height: 38)
                    .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
                }
                Spacer()
                GoodsRemoteIconView(url: step.goals ?? "", placeholder: "logo_Group")
                    .frame(width: 34, height: 34)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.pbColorBackHexStr("#F5F5F5")))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
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
                Text(state.applyTitle)
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
