Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A12B72321F
	for <lists+io-uring@lfdr.de>; Mon,  5 Jun 2023 23:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjFEVUn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Jun 2023 17:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbjFEVUl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Jun 2023 17:20:41 -0400
Received: from 66-220-144-179.mail-mxout.facebook.com (66-220-144-179.mail-mxout.facebook.com [66.220.144.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E2E100
        for <io-uring@vger.kernel.org>; Mon,  5 Jun 2023 14:20:39 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
        id 73BA069921B8; Mon,  5 Jun 2023 14:20:22 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org,
        netdev@vger.kernel.org, kuba@kernel.org, olivier@trillion01.com
Subject: [PATCH v14 8/8] io_uring: add prefer busy poll to register and unregister napi api
Date:   Mon,  5 Jun 2023 14:20:09 -0700
Message-Id: <20230605212009.1992313-9-shr@devkernel.io>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230605212009.1992313-1-shr@devkernel.io>
References: <20230605212009.1992313-1-shr@devkernel.io>
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
 include/uapi/linux/io_uring.h |  3 ++-
 io_uring/napi.c               | 10 +++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

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
index b1a3ed9d1c2e..8ec016899539 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -217,16 +217,18 @@ void io_napi_free(struct io_ring_ctx *ctx)
 int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 {
 	const struct io_uring_napi curr =3D {
-		.busy_poll_to =3D ctx->napi_busy_poll_to,
+		.busy_poll_to 	  =3D ctx->napi_busy_poll_to,
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
@@ -245,13 +247,15 @@ int io_register_napi(struct io_ring_ctx *ctx, void =
__user *arg)
 int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 {
 	const struct io_uring_napi curr =3D {
-		.busy_poll_to =3D ctx->napi_busy_poll_to,
+		.busy_poll_to 	  =3D ctx->napi_busy_poll_to,
+		.prefer_busy_poll =3D ctx->napi_prefer_busy_poll
 	};
=20
 	if (arg && copy_to_user(arg, &curr, sizeof(curr)))
 		return -EFAULT;
=20
 	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
+	WRITE_ONCE(ctx->napi_prefer_busy_poll, false);
 	return 0;
 }
=20
--=20
2.39.1

