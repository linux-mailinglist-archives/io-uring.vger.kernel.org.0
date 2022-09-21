Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7B65BFCDD
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiIULVE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiIULUx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:20:53 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4DC77569
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:50 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id g3so9261195wrq.13
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=YMalNKBBvx+Fi+YBMCJ2+mo3jcLmAL8upLLfTrb8yzY=;
        b=EHTadEuz6t74qCV9AIVIeWtyhUrkAp4mNPNuUOHEIoOqsdTBb6Ge78WnGMLcEYAhff
         jcmKyrWZx78JighWtWlbUIxa+J5WzP9BPvo40vtuAuuFSRXHYByTOIFDqmib254BdCiJ
         VeOTponjASU4zme9t5rDh8LjdMNTPnqUeLiOfFTLda5T3pfxTR5sUID/q8kfDgZn5BYf
         xyC5wD8NLh4yUdJglY26Vq8GNUyKnnUHGKU/Qb/hfU+STaEj/PufkDGpntZyGbc+RirP
         3Oq/on7N8vWGe8WO89ebSPQKNIa6CJYarDgX6GY2fUhqod0cjMJUt5KvX/aNu4tGA1aD
         ZEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=YMalNKBBvx+Fi+YBMCJ2+mo3jcLmAL8upLLfTrb8yzY=;
        b=lzehhwIN9gbAUkDgUou36yEdtJ/d2F3C2YfxUuCzRHexR5MUJuEm63TXa9rzJ1Hpmj
         NfJRpA8TF34zOA5Es5J2YICrEKEr88Zi+FE+oRx2kx4k9Gd+2yQA5BSH5/udoY2k0GhG
         CQMb99cd010CL8xyowFZM8wvRlLty2amHNHdFeWuoxEcckCpC7cDhLvI5yWIIlsbrq7b
         vyjuv3GcA0bY5StQoLBBYBssp7cVQdcAsQjRlviAziSVH3wJHCdUARMemUIs9ydkNDRb
         QZMtwHkc++iPQKxg2RNe4QFvhj4OWr5RzMon0uFDaiGYxLkqsQHE0jDRqNo8Rzchdv9g
         Teag==
X-Gm-Message-State: ACrzQf3weWvWfT7CJTkbfW51ODYPj1vJW8dIUUjY519QdaHzZePP4FGy
        bPev7+sMU2CcsiAYoaWTOOEr4os+qPM=
X-Google-Smtp-Source: AMsMyM4mBkmr1H4dHxVA+mjDWtAtxniLgSsAuRr0HNgYg8yHuiV5LObMbM8FRbXcC2iscV6YqEEhbQ==
X-Received: by 2002:a05:6000:1090:b0:228:a963:3641 with SMTP id y16-20020a056000109000b00228a9633641mr17162201wrw.289.1663759248793;
        Wed, 21 Sep 2022 04:20:48 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id s17-20020a5d6a91000000b00228da845d4dsm2206732wru.94.2022.09.21.04.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:20:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 7/9] io_uring/net: rename io_sendzc()
Date:   Wed, 21 Sep 2022 12:17:52 +0100
Message-Id: <265af46829e6076dd220011b1858dc3151969226.1663668091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663668091.git.asml.silence@gmail.com>
References: <cover.1663668091.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Simple renaming of io_sendzc*() functions in preparatio to adding
a zerocopy sendmsg variant.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   | 6 +++---
 io_uring/net.h   | 6 +++---
 io_uring/opdef.c | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index aa2c819cd85d..06c132edfd91 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -904,7 +904,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
-void io_sendzc_cleanup(struct io_kiocb *req)
+void io_send_zc_cleanup(struct io_kiocb *req)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 
@@ -913,7 +913,7 @@ void io_sendzc_cleanup(struct io_kiocb *req)
 	zc->notif = NULL;
 }
 
-int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1022,7 +1022,7 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 	return ret;
 }
 
-int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
+int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct sockaddr_storage __address;
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
diff --git a/io_uring/net.h b/io_uring/net.h
index 488d4dc7eee2..337541f25b79 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -56,9 +56,9 @@ int io_connect_prep_async(struct io_kiocb *req);
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
 
-int io_sendzc(struct io_kiocb *req, unsigned int issue_flags);
-int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-void io_sendzc_cleanup(struct io_kiocb *req);
+int io_send_zc(struct io_kiocb *req, unsigned int issue_flags);
+int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+void io_send_zc_cleanup(struct io_kiocb *req);
 void io_send_zc_fail(struct io_kiocb *req);
 
 void io_netmsg_cache_free(struct io_cache_entry *entry);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 8fb4d98c9f36..36590f9ab37b 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -496,10 +496,10 @@ const struct io_op_def io_op_defs[] = {
 		.manual_alloc		= 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
-		.prep			= io_sendzc_prep,
-		.issue			= io_sendzc,
+		.prep			= io_send_zc_prep,
+		.issue			= io_send_zc,
 		.prep_async		= io_send_prep_async,
-		.cleanup		= io_sendzc_cleanup,
+		.cleanup		= io_send_zc_cleanup,
 		.fail			= io_send_zc_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
-- 
2.37.2

