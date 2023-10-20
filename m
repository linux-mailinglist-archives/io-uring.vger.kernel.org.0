Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7257D109D
	for <lists+io-uring@lfdr.de>; Fri, 20 Oct 2023 15:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377372AbjJTNjd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Oct 2023 09:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377074AbjJTNjc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Oct 2023 09:39:32 -0400
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93F11A8
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 06:39:30 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-9b95622c620so130188366b.0
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 06:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697809169; x=1698413969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1EjyJ4uhP/CxBADjUG+qEfppqNSusPrKMcrU9qiJ+8I=;
        b=Acde6q/VFlEF3TC5vWgl+nIvLKfRExTYr763RmdqCH8E8KxjG+gK4HzFsxacaM1qt1
         Q046bYUq95/Z0BFnAFqfo4/0lJXgqKK6InZa7LX3DSLhbof60Bq6J0w1t5MrSk8oM36R
         DJIXJ8We05Uec0VvwvsXmk3GMieVjeBnPVwFDNZEbqlDBJfLdr/NWsjIs1Y9AaR/IiIH
         V/qirLC8H6ymCJpILLVisKOOc2bRjRZiZgJMeYGHKMNzQmMdLMJ15NKFVxSkpqW6cWgD
         VcupR+C8GTJ4zNuNMQaKxg5SIwQGTrrtfoJvYSQqW3Q2xqRaRL5EhwX69KfeuR8nZTeL
         UKfg==
X-Gm-Message-State: AOJu0YzZCDFEvPyFxjb+hZbzk8+4c1QLwWsHU717grOW3GwObBxlMoQN
        j5spFTr4rAs93kUmOUdVW/AzT65Yhp3tQA==
X-Google-Smtp-Source: AGHT+IHsT3EZ9LFHtBBrOM6VyzzTRUCQZKJBcELJ+7FDE58c1Ips5sghV7tFhKl2Vc7p+mwVWwaiAg==
X-Received: by 2002:a17:907:9306:b0:9b9:4509:d575 with SMTP id bu6-20020a170907930600b009b94509d575mr1653882ejc.2.1697809168775;
        Fri, 20 Oct 2023 06:39:28 -0700 (PDT)
Received: from localhost (fwdproxy-cln-004.fbsv.net. [2a03:2880:31ff:4::face:b00c])
        by smtp.gmail.com with ESMTPSA id ca9-20020a170906a3c900b009b8a4f9f20esm1512582ejb.102.2023.10.20.06.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 06:39:28 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 1/5] io_uring: uapi: Sync the {g,s}etsockopt fields
Date:   Fri, 20 Oct 2023 06:39:13 -0700
Message-Id: <20231020133917.953642-2-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231020133917.953642-1-leitao@debian.org>
References: <20231020133917.953642-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Copy the UAPI fields necessary to support the new
SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT socket
commands.

Sync the necessary bits for io_uring_sqe struct from the kernel, and
also adds the SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT
to the enum that defines the commands.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 src/include/liburing/io_uring.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 10a6ef0..a7a95a3 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -43,6 +43,10 @@ struct io_uring_sqe {
 	union {
 		__u64	addr;	/* pointer to buffer or iovecs */
 		__u64	splice_off_in;
+		struct {
+			__u32	level;
+			__u32	optname;
+		};
 	};
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
@@ -79,6 +83,7 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		__u32	optlen;
 		struct {
 			__u16	addr_len;
 			__u16	__pad3[1];
@@ -89,6 +94,7 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
 		 * this field is used for 80 bytes of arbitrary command data
@@ -721,6 +727,8 @@ struct io_uring_recvmsg_out {
 enum {
 	SOCKET_URING_OP_SIOCINQ		= 0,
 	SOCKET_URING_OP_SIOCOUTQ,
+	SOCKET_URING_OP_GETSOCKOPT,
+	SOCKET_URING_OP_SETSOCKOPT,
 };
 
 #ifdef __cplusplus
-- 
2.34.1

