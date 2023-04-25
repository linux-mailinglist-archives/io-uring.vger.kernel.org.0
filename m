Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E28E6EE774
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 20:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbjDYSTK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Apr 2023 14:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbjDYSTJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Apr 2023 14:19:09 -0400
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810C97D85
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 11:19:08 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
        id 27EC1442E9D3; Tue, 25 Apr 2023 11:18:55 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v10 5/5] io_uring: add prefer busy poll to register and unregister napi api
Date:   Tue, 25 Apr 2023 11:18:45 -0700
Message-Id: <20230425181845.2813854-6-shr@devkernel.io>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230425181845.2813854-1-shr@devkernel.io>
References: <20230425181845.2813854-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the napi prefer busy poll setting to the register and
unregister napi api. When napi is unregistered and arg is specified,
both napi settings: busy poll timeout and the prefer busy poll setting
are copied into the user structure.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/io_uring.h | 3 ++-
 io_uring/napi.c               | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 278c1a9de78c..16d17d6ab7f7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -656,7 +656,8 @@ struct io_uring_buf_reg {
 /* argument for IORING_(UN)REGISTER_NAPI */
 struct io_uring_napi {
 	__u32	busy_poll_to;
-	__u32	pad;
+	__u8	prefer_busy_poll;
+	__u8	pad[3];
 	__u64	resv;
 };
=20
diff --git a/io_uring/napi.c b/io_uring/napi.c
index 56a4754efcfb..ca12ff5f5611 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -207,15 +207,17 @@ int io_register_napi(struct io_ring_ctx *ctx, void =
__user *arg)
 {
 	const struct io_uring_napi curr =3D {
 		.busy_poll_to =3D ctx->napi_busy_poll_to,
+		.prefer_busy_poll =3D ctx->napi_prefer_busy_poll
 	};
 	struct io_uring_napi napi;
=20
 	if (copy_from_user(&napi, arg, sizeof(napi)))
 		return -EFAULT;
-	if (napi.pad || napi.resv)
+	if (napi.pad[0] || napi.pad[1] || napi.pad[2] || napi.resv)
 		return -EINVAL;
=20
 	WRITE_ONCE(ctx->napi_busy_poll_to, napi.busy_poll_to);
+	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi.prefer_busy_poll);
=20
 	if (copy_to_user(arg, &curr, sizeof(curr)))
 		return -EFAULT;
@@ -235,6 +237,7 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void =
__user *arg)
 {
 	const struct io_uring_napi curr =3D {
 		.busy_poll_to =3D ctx->napi_busy_poll_to,
+		.prefer_busy_poll =3D ctx->napi_prefer_busy_poll
 	};
=20
 	if (arg) {
@@ -243,6 +246,7 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void =
__user *arg)
 	}
=20
 	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
+	WRITE_ONCE(ctx->napi_prefer_busy_poll, false);
 	return 0;
 }
=20
--=20
2.39.1

