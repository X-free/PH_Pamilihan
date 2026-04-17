//
//  SettingRootView.swift
//  PrimeLoanPH
//

import SwiftUI
import UIKit

struct SettingRootView: View {
    var versionText: String
    var onBack: () -> Void
    var onExit: () -> Void
    var onAccountCancellation: () -> Void

    private let cream = Color(UIColor.pbColorBackHexStr("#FBF6E7"))
    private let danger = Color(UIColor.pbColorBackHexStr("#E53935"))

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                backgroundLayer(safeTop: geo.safeAreaInsets.top)
                VStack(spacing: 0) {
                    topBar
                    headerSection
                    Spacer(minLength: 0)
                    settingsCard
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
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
                .frame(height: 260 + safeTop)
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
            Text("Setting")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color(UIColor.pbColorBackHexStr("#262626")))
            Spacer()
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 8)
        .padding(.top, 4)
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image("PamLOGO1")
                .resizable()
                .scaledToFill()
                .frame(width: 88, height: 88)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            Text("Pamilihan Peso")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(UIColor.pbColorBackHexStr("#262626")))
            Text("V \(versionText)")
                .font(.system(size: 15))
                .foregroundColor(Color(UIColor.pbColorBackHexStr("#8C8C8C")))
        }
        .padding(.top, 12)
    }

    private var settingsCard: some View {
        VStack(spacing: 0) {
            settingRow(
                leadingName: "Iconly-Curved-Logout",
                title: "Exit",
                titleColor: Color(UIColor.pbColorBackHexStr("#262626")),
                trailingName: "Gro71276435",
                action: onExit
            )
            Divider()
                .background(Color(UIColor.pbColorBackHexStr("#F0F0F0")))
            settingRow(
                leadingName: "Outline-Interface-Trash-alt",
                title: "Account cancellation",
                titleColor: danger,
                trailingName: "ro171276435",
                action: onAccountCancellation
            )
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
    }

    private func settingRow(
        leadingName: String,
        title: String,
        titleColor: Color,
        trailingName: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(leadingName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(titleColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(trailingName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 18)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
