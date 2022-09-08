Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94655B1CBF
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 14:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiIHMWw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 08:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbiIHMWs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 08:22:48 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7CC127570
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 05:22:39 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bj12so37540341ejb.13
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 05:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=yUvpV3mjVhkBX7spqb4A/4OznVW615tmAtfHpse7uww=;
        b=OVfSI6Vs8AauwJc+3e6qlOXJrdaj6KxAz2mDk+eC3FLIM5pmV6yAZ/x/Kui03Ol8Pi
         HpTVpsAqHPuXNNPc1LrI5KpSmcqXtVRSPfCGf3g3lmyKsV7+8JrMP06YEv4RkUimOhpS
         AH7KGaT642khRfTFmAMnuATphmWHlVPxl+azJTruKm6QkIkqOeHSd3SPNwmZfm4ZFtl3
         +HCH7drUJXE8cqMlR21/1F7xRppDyZUc7kUlOY+ZCU+dzdioA+Q/Y5q0ghXIR1c8y7GY
         RR6HyLMVku5i2m4JTLvVXH+kcRsojY+pYhg3l6PRMEOOCnYAeeeDBDsPq6aGN3i45fZ8
         SlkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=yUvpV3mjVhkBX7spqb4A/4OznVW615tmAtfHpse7uww=;
        b=Qvh71t8ijMxtJKFEkoFLDBylqmBIxYl+EQe3XgzC+lsritgL0t0NK1hf/Bs0D6Ixry
         0NIRv/WOenEeZqEfMnylPW5EbXNEmguKI+MCOpCDiIld8xLi6bWCFUEm4u2DzFeIe1FC
         0GadzX6sXZUnzBQWjMF7rTLDb2TpigihFc6sBzFew9ovrqicGo8B9LdsCXQKT7ylvw03
         gVjLt5/bEE4bUdVEaa5Dz9SLTfrl+3ZX7nLrqJlKaWnEQ/7HH78uVFDM9mY1Nq2uJRH+
         UKyEGiEZlY8CJlHfIQ736TMIzwGRPLKcPgOqWUtIe+uvMU++xmz6wL9gDaYImKlDCNAp
         SQcg==
X-Gm-Message-State: ACgBeo1gzd0E7PyAaVHgPrKBTlpxRMUIiwI7RSL5Jdt/1aPWTmojfIJY
        /OaA75xKV1BvWBkTmjjMB4YcXNdv2Yc=
X-Google-Smtp-Source: AA6agR5SJxhlL8qXo/DyGzkpGM6O6/jV5MiyqykwrK4aM9Gs5OZ6akuz4qFQCmFlxBXGPymcT7ksmg==
X-Received: by 2002:a17:907:3186:b0:777:3fe7:4659 with SMTP id xe6-20020a170907318600b007773fe74659mr1067929ejb.336.1662639757840;
        Thu, 08 Sep 2022 05:22:37 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090653c900b0074a82932e3bsm1191791ejo.77.2022.09.08.05.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:22:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/8] io_uring/net: use async caches for async prep
Date:   Thu,  8 Sep 2022 13:20:30 +0100
Message-Id: <b9a2264b807582a97ed606c5bfcdc2399384e8a5.1662639236.git.asml.silence@gmail.com>
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

send/recv have async_data caches but there are only used from within
issue handlers. Extend their use also to ->prep_async, should be handy
with links and IOSQE_ASYNC.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   | 16 +++++++++++++---
 io_uring/opdef.c |  2 ++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 0bba804a955d..fa54a35191d7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -126,8 +126,8 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
-static struct io_async_msghdr *io_recvmsg_alloc_async(struct io_kiocb *req,
-						      unsigned int issue_flags)
+static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req,
+						  unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_cache_entry *entry;
@@ -148,6 +148,12 @@ static struct io_async_msghdr *io_recvmsg_alloc_async(struct io_kiocb *req,
 	return NULL;
 }
 
+static inline struct io_async_msghdr *io_msg_alloc_async_prep(struct io_kiocb *req)
+{
+	/* ->prep_async is always called from the submission context */
+	return io_msg_alloc_async(req, 0);
+}
+
 static int io_setup_async_msg(struct io_kiocb *req,
 			      struct io_async_msghdr *kmsg,
 			      unsigned int issue_flags)
@@ -156,7 +162,7 @@ static int io_setup_async_msg(struct io_kiocb *req,
 
 	if (req_has_async_data(req))
 		return -EAGAIN;
-	async_msg = io_recvmsg_alloc_async(req, issue_flags);
+	async_msg = io_msg_alloc_async(req, issue_flags);
 	if (!async_msg) {
 		kfree(kmsg->free_iov);
 		return -ENOMEM;
@@ -217,6 +223,8 @@ int io_sendmsg_prep_async(struct io_kiocb *req)
 {
 	int ret;
 
+	if (!io_msg_alloc_async_prep(req))
+		return -ENOMEM;
 	ret = io_sendmsg_copy_hdr(req, req->async_data);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
@@ -504,6 +512,8 @@ int io_recvmsg_prep_async(struct io_kiocb *req)
 {
 	int ret;
 
+	if (!io_msg_alloc_async_prep(req))
+		return -ENOMEM;
 	ret = io_recvmsg_copy_hdr(req, req->async_data);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 04693e4a33c7..c6e089900394 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -146,6 +146,7 @@ const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.ioprio			= 1,
+		.manual_alloc		= 1,
 		.name			= "SENDMSG",
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
@@ -163,6 +164,7 @@ const struct io_op_def io_op_defs[] = {
 		.pollin			= 1,
 		.buffer_select		= 1,
 		.ioprio			= 1,
+		.manual_alloc		= 1,
 		.name			= "RECVMSG",
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
-- 
2.37.2

