Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8AB55B1CC2
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 14:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiIHMWy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 08:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiIHMWt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 08:22:49 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470EC1316DC
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 05:22:43 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u9so37667570ejy.5
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 05:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=6CCpCBGOxRxa+KZZ3A1bwS94jvsCJ2VLNeWvIj0f7nk=;
        b=op9L9OVZMwpLPUX1sk1+w0XjzO9cCF/8tnXLcECg8EQyV/bzU9z2WHk8TaCUBMAro+
         VlsgOTEDA+sH7g3d18bxM+OIRJ+tZm3vOf31GSUP2S3rbc9Wp3WeT2eC8WIWFgMZ/WHL
         ja/m7/sR/6vmZMXZHqOumsQZxp3mv3wKmxlXcNrmTyqRal/2qVgJ4MeWgHAJUczVBNU5
         rfxDnOKYb8UpbAfPiQEME7d5atV0IAItg8xk6kCwOtnfHR0YcvZGkaty54N/kzMNL+vA
         zpyfMVRCHIg76r5A6V3zfqhYMwICOpcQR94M8rb9PCCF2Le5nLTOFZ5bGm+nxlgITx9Q
         pWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=6CCpCBGOxRxa+KZZ3A1bwS94jvsCJ2VLNeWvIj0f7nk=;
        b=MZ/HpgaCKIsNdxd7h3c6FFFUo2I1IVpN43mfEvYuHOt6QDXBoYaWHX9i3xkaKizQ1q
         qHQxftFUpjQFVxjpRMTiyEjENpTBYdEENad84tLkEq2S+BJHAh1jeg3hSsFXg/amFNzN
         o6NuyZdsLFRPCm35BpOySm4eG/o+LugQ0ECOgqJ9Rk4vxasmU/3MtI93osC02+wcC+sn
         w43g6xiHAsu3bbe2S0FxXrh2GBGy3yMlgv25bv9WOLbYFB622Xwm78aoobrI6682dNr9
         60MIcYfsY4L9TcJjrDuMupEjnVTmLMfAXQwRED2g13dXe+uF0EhL1dWHaA7CMR3vgVQP
         TP6Q==
X-Gm-Message-State: ACgBeo24QcU4mcdhGCG+TYZnqWnHgtMcRXRHOVPirON972tLMt045Bcn
        BMOTODOEGWTaok0USYpJQtdfak38Tw8=
X-Google-Smtp-Source: AA6agR7MUoEJq5S2WKSHSXllnwwUuv7ncyESn768UfZ8xDjYqAKM02yO95bSe8NfxwZCUrS4CH5KBg==
X-Received: by 2002:a17:907:6d99:b0:770:7e4c:ba15 with SMTP id sb25-20020a1709076d9900b007707e4cba15mr5777895ejc.259.1662639761401;
        Thu, 08 Sep 2022 05:22:41 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090653c900b0074a82932e3bsm1191791ejo.77.2022.09.08.05.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:22:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 8/8] io_uring/net: use io_sr_msg for sendzc
Date:   Thu,  8 Sep 2022 13:20:34 +0100
Message-Id: <408c5b1b2d8869e1a12da5f5a78ed72cac112149.1662639236.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662639236.git.asml.silence@gmail.com>
References: <cover.1662639236.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Reuse struct io_sr_msg for zerocopy sends, which is handy. There is
only one zerocopy specific field, namely .notif, and we have enough
space for it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 97778cd1306c..acafb2e3dd09 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -59,15 +59,7 @@ struct io_sr_msg {
 	unsigned			done_io;
 	unsigned			msg_flags;
 	u16				flags;
-};
-
-struct io_sendzc {
-	struct file			*file;
-	void __user			*buf;
-	unsigned			len;
-	unsigned			done_io;
-	unsigned			msg_flags;
-	u16				flags;
+	/* used only for sendzc */
 	u16				addr_len;
 	void __user			*addr;
 	struct io_kiocb 		*notif;
@@ -190,7 +182,7 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 
 int io_sendzc_prep_async(struct io_kiocb *req)
 {
-	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
+	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *io;
 	int ret;
 
@@ -890,7 +882,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 
 void io_sendzc_cleanup(struct io_kiocb *req)
 {
-	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
+	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	zc->notif->flags |= REQ_F_CQE_SKIP;
 	io_notif_flush(zc->notif);
@@ -899,7 +891,7 @@ void io_sendzc_cleanup(struct io_kiocb *req)
 
 int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
+	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *notif;
 
@@ -1009,7 +1001,7 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct sockaddr_storage __address, *addr = NULL;
-	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
+	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct msghdr msg;
 	struct iovec iov;
 	struct socket *sock;
-- 
2.37.2

