Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B04691428
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 00:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjBIXC0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 18:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjBIXCY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 18:02:24 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C655EBF5
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 15:02:24 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id C06186AB6779; Thu,  9 Feb 2023 15:02:01 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v8 6/7] io_uring: add api to set / get napi configuration.
Date:   Thu,  9 Feb 2023 15:01:43 -0800
Message-Id: <20230209230144.465620-7-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230209230144.465620-1-shr@devkernel.io>
References: <20230209230144.465620-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds an api to register the busy poll timeout from liburing. To be
able to use this functionality, the corresponding liburing patch is neede=
d.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/io_uring.h | 11 +++++++++++
 io_uring/io_uring.c           |  9 +++++++++
 io_uring/napi.c               | 35 +++++++++++++++++++++++++++++++++++
 io_uring/napi.h               | 13 +++++++++++++
 4 files changed, 68 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 636a4c2c1294..fe25ae92744d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -518,6 +518,10 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation *=
/
 	IORING_REGISTER_FILE_ALLOC_RANGE	=3D 25,
=20
+	/* set/clear busy poll settings */
+	IORING_REGISTER_NAPI			=3D 26,
+	IORING_UNREGISTER_NAPI			=3D 27,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -640,6 +644,13 @@ struct io_uring_buf_reg {
 	__u64	resv[3];
 };
=20
+/* argument for IORING_(UN)REGISTER_NAPI */
+struct io_uring_napi {
+	__u32	busy_poll_to;
+	__u32	pad;
+	__u64	resv;
+};
+
 /*
  * io_uring_restriction->opcode values
  */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7074379a9bd0..be501e1024bc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4283,6 +4283,15 @@ static int __io_uring_register(struct io_ring_ctx =
*ctx, unsigned opcode,
 			break;
 		ret =3D io_register_file_alloc_range(ctx, arg);
 		break;
+	case IORING_REGISTER_NAPI:
+		ret =3D -EINVAL;
+		if (!arg)
+			break;
+		ret =3D io_register_napi(ctx, arg);
+		break;
+	case IORING_UNREGISTER_NAPI:
+		ret =3D io_unregister_napi(ctx, arg);
+		break;
 	default:
 		ret =3D -EINVAL;
 		break;
diff --git a/io_uring/napi.c b/io_uring/napi.c
index 038957b46a0e..34513b284234 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -199,6 +199,41 @@ void io_napi_free(struct io_ring_ctx *ctx)
 	spin_unlock(&ctx->napi_lock);
 }
=20
+int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
+{
+	const struct io_uring_napi curr =3D {
+		.busy_poll_to =3D ctx->napi_busy_poll_to,
+	};
+	struct io_uring_napi napi;
+
+	if (copy_from_user(&napi, arg, sizeof(napi)))
+		return -EFAULT;
+	if (napi.pad || napi.resv)
+		return -EINVAL;
+
+	WRITE_ONCE(ctx->napi_busy_poll_to, napi.busy_poll_to);
+
+	if (copy_to_user(arg, &curr, sizeof(curr)))
+		return -EFAULT;
+
+	return 0;
+}
+
+int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
+{
+	const struct io_uring_napi curr =3D {
+		.busy_poll_to =3D ctx->napi_busy_poll_to,
+	};
+
+	if (arg) {
+		if (copy_to_user(arg, &curr, sizeof(curr)))
+			return -EFAULT;
+	}
+
+	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
+	return 0;
+}
+
 /*
  * io_napi_add() - Add napi id to the busy poll list
  * @req: pointer to io_kiocb request
diff --git a/io_uring/napi.h b/io_uring/napi.h
index 23a6df32805f..a5abe433c3e7 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -14,6 +14,9 @@
 void io_napi_init(struct io_ring_ctx *ctx);
 void io_napi_free(struct io_ring_ctx *ctx);
=20
+int io_register_napi(struct io_ring_ctx *ctx, void __user *arg);
+int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg);
+
 void io_napi_add(struct io_kiocb *req);
=20
 void io_napi_setup_busy_loop(struct io_ring_ctx *ctx, struct io_wait_que=
ue *iowq,
@@ -37,6 +40,16 @@ static inline void io_napi_free(struct io_ring_ctx *ct=
x)
 {
 }
=20
+static inline int io_register_napi(struct io_ring_ctx *ctx, void __user =
*arg)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int io_unregister_napi(struct io_ring_ctx *ctx, void __use=
r *arg)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void io_napi_add(struct io_kiocb *req)
 {
 }
--=20
2.30.2

