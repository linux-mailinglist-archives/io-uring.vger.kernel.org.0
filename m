Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6068869D7DF
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 02:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbjBUBHJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 20:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbjBUBHI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 20:07:08 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B2321A0E
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:03 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id p3-20020a05600c358300b003e206711347so2026458wmq.0
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pDVStzJ29cUMYfFVfAm67LRJPivRqwrBt7LnrDp5v3k=;
        b=l7eOQLP+NUN61QDOLnENuuk5TJ/lzFRa7hEsPLwUkMK8SJh1C1BDh62KYwXSLFJ4ZA
         4xFDXnZ243p6jiksbAkKmqvQI2OTFaIe6uItTuP9x2XcailXWbfpwg+632svLCcy84yA
         htAmIOj14RMuerGNWgwJ62jRFCGh1A7ZgUAEuuBkpv4XuGxTGXKoiYnjaOK/y4HwbuAD
         BWsjeSAvX8/LFlXn4UsdNwS9vAgOZAuMmrDuov6pcy59lbFYeZFwmVcfIWFpx8Fe3OrN
         UFnGXChGifmt5pEjAQri635j98j6rpaOm3slbLfD72JfVY6cp5Q/KfJIo1WuD87lWJFb
         ZqIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pDVStzJ29cUMYfFVfAm67LRJPivRqwrBt7LnrDp5v3k=;
        b=vVKWlgyI+slVi/3Ikyj2UmatM4PP50iQa7TAutQcV8qeOj0B48R5eCDvueZHxoHVmD
         lv4+vUXMRUy59FObjvly+q3GMTyUKaOyiklmkEyMQOPiYwDkEU19GzyMjXJ4BPqnarrl
         7ZnnD4DlNsoceFzfhCkmETP3q7vfu1FzMzhUR+PA6uI7FpYsG31cCP8vF97igJOweEQR
         lYQcnPS/Lhq650ChEt3DMYTMxMCojDh/11C2qTp5x4sjCB33AihLqrLMVfXNi8gmZtHm
         Wi/nAu/2hATQChUIjcPKT85OmMIfVHs4NqjEtx5gjiTJT6FGNbJqws0PkkYpb1YFnk5L
         pEhw==
X-Gm-Message-State: AO0yUKU1jtNaooYR2AWQuNInR8MfzLUBeCRf+cMNaUoM2onyphdJTLdV
        bvV81II3JQGshE4QLY/HX1lRXmmXOXo=
X-Google-Smtp-Source: AK7set/eafs8FdCfBInBou/ji8RFUpJt6l7XNROEhhbwLLvBDfLJCgINTKRJOBMPuAErWFGY94Nnqw==
X-Received: by 2002:a05:600c:1609:b0:3e2:1592:ccf5 with SMTP id m9-20020a05600c160900b003e21592ccf5mr11349612wmn.8.1676941621855;
        Mon, 20 Feb 2023 17:07:01 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id k17-20020a7bc411000000b003dfee43863fsm2092469wmi.26.2023.02.20.17.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 17:07:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/7] send: improve buffer iteration
Date:   Tue, 21 Feb 2023 01:05:53 +0000
Message-Id: <d2d1c90856ce4f511eed5c7ffd7d829215f67f3a.1676941370.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1676941370.git.asml.silence@gmail.com>
References: <cover.1676941370.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 2e30e49..e663be7 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -484,6 +484,7 @@ static int test_inet_send(struct io_uring *ring)
 	struct sockaddr_storage addr;
 	int sock_client = -1, sock_server = -1;
 	int ret, j, i;
+	int buf_index;
 
 	for (j = 0; j < 32; j++) {
 		bool ipv6 = j & 1;
@@ -510,20 +511,19 @@ static int test_inet_send(struct io_uring *ring)
 			sock_server = tmp_sock;
 		}
 
-		for (i = 0; i < 4096; i++) {
+		for (i = 0; i < 1024; i++) {
 			bool regbuf;
 
-			conf.buf_index = i & 3;
+			conf.use_sendmsg = i & 1;
+			conf.poll_first = i & 2;
 			conf.fixed_buf = i & 4;
 			conf.addr = (i & 8) ? &addr : NULL;
 			conf.cork = i & 16;
 			conf.mix_register = i & 32;
 			conf.force_async = i & 64;
-			conf.use_sendmsg = i & 128;
-			conf.zc = i & 256;
-			conf.iovec = i & 512;
-			conf.long_iovec = i & 1024;
-			conf.poll_first = i & 2048;
+			conf.zc = i & 128;
+			conf.iovec = i & 256;
+			conf.long_iovec = i & 512;
 			conf.tcp = tcp;
 			regbuf = conf.mix_register || conf.fixed_buf;
 
@@ -539,10 +539,6 @@ static int test_inet_send(struct io_uring *ring)
 				if (conf.addr && !has_sendmsg)
 					continue;
 			}
-			if (conf.buf_index == BUF_T_LARGE && !tcp)
-				continue;
-			if (!buffers_iov[conf.buf_index].iov_base)
-				continue;
 			if (tcp && (conf.cork || conf.addr))
 				continue;
 			if (conf.mix_register && (!conf.cork || conf.fixed_buf))
@@ -554,13 +550,23 @@ static int test_inet_send(struct io_uring *ring)
 			if (msg_zc_set && !conf.zc)
 				continue;
 
-			ret = do_test_inet_send(ring, sock_client, sock_server, &conf);
-			if (ret) {
-				fprintf(stderr, "send failed fixed buf %i, conn %i, addr %i, "
-					"cork %i\n",
-					conf.fixed_buf, client_connect, !!conf.addr,
-					conf.cork);
-				return 1;
+			for (buf_index = 0; buf_index < ARRAY_SIZE(buffers_iov); buf_index++) {
+				size_t len = buffers_iov[buf_index].iov_len;
+
+				if (!buffers_iov[buf_index].iov_base)
+					continue;
+				if (!tcp && len > 4 * page_sz)
+					continue;
+
+				conf.buf_index = buf_index;
+				ret = do_test_inet_send(ring, sock_client, sock_server, &conf);
+				if (ret) {
+					fprintf(stderr, "send failed fixed buf %i, "
+							"conn %i, addr %i, cork %i\n",
+						conf.fixed_buf, client_connect,
+						!!conf.addr, conf.cork);
+					return 1;
+				}
 			}
 		}
 
-- 
2.39.1

