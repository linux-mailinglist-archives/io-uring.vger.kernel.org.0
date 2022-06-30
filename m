Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0534F561DD9
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 16:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbiF3O1s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 10:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237145AbiF3O1E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 10:27:04 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C64C7973C
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:10:38 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q9so27507979wrd.8
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H4SsgCkYXgMSXMIuOsgii3aYKII1EkRzCdnOHhT3qC8=;
        b=BV2FnbcmM4Mjs6KasC52DTqhsnFPJiZlwyiI5L89Bf5KszNv7c338FX5cRYwRNBsII
         RI7T/EMqEBhAh0fNXE+QkBiOzqTnwW2Zl88cZMWDPebuoQVDIqJ0RV/Mv0vJpKRUxERC
         UgS+a7GvlLYuyghod/mCKh4sYzVMAM012DU7N8K9PLUXqXPSiozQL//8AyZGAb8ZVvw0
         8+DovIta9Hk8ayEwfRNMCZmfh/Yi/zCUJAcoCFp9F9rHLRNKHUXqi9FhyH2BxeOGxl8F
         4XrEQ0FdUPwnPgDv4TpYFqnwqzWoKvSnjkM2fMv70WZwjA0b55wW6fQh0OsIi7yfwCXN
         ARYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H4SsgCkYXgMSXMIuOsgii3aYKII1EkRzCdnOHhT3qC8=;
        b=A3sPQXAKvUXn78Hfm2MDIaUKY9we1Wro3qtA3zQyB0DTKqk77jpqo+OVE/+i/RoMT0
         ++R/88ggaSgCqGCjeBUj5JLOkK94vkuRTZixPMb+3X9J28nhmT9HdYS56ZoLIpDG4AgC
         f0M5Zzn7To23fXPmf4TGx7Psap8puce6wjMVhdPXF8bI20kPGnskP/q7LAHnBWifog3C
         7gESS1P7fUyGhByc689NDxtSsKQ98M59AQoRUdn7R697hko9HsftKs/dxu7gaobhdP79
         ggKVwqYV5gOsuWeyZh2Pn02Tu4qfqwVwsmYAb/oPu6q/KUHe+jd/KxsN0M1F+bvUk1WK
         DRmw==
X-Gm-Message-State: AJIora92/+p8q5GUK87HcKVYM69GtcRMZO4vACvbtSegbTTWBWfyJ6f1
        gDLL1VME6GCuwg+spmHAK/3cfl7oiQBN4w==
X-Google-Smtp-Source: AGRyM1uko/ms+YlZNdOsDf0t598R+D+Wr+HbY/IFKYLwnibWeAxRYX3HISfGL1F1ogwtTvjwF4xZqw==
X-Received: by 2002:adf:ec82:0:b0:21d:20a1:3f6b with SMTP id z2-20020adfec82000000b0021d20a13f6bmr8606582wrn.394.1656598220690;
        Thu, 30 Jun 2022 07:10:20 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-232-9.dab.02.net. [82.132.232.9])
        by smtp.gmail.com with ESMTPSA id e12-20020a5d530c000000b002185d79dc7fsm19476789wrv.75.2022.06.30.07.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 07:10:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next] io_uring: use proper type for io_sr_msg msg_flags
Date:   Thu, 30 Jun 2022 15:10:07 +0100
Message-Id: <c057314898a95409bf96e3ffdcdce01288436608.1656592432.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
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

Network takes unsigned for msg flags, so use the right type for
struct io_sr_msg::msg_flags. And move io_sr_msg::flags to get rid of
internal padding, we'll need more space in the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 19a805c3814c..72c81d973651 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -52,10 +52,10 @@ struct io_sr_msg {
 		struct user_msghdr __user	*umsg;
 		void __user			*buf;
 	};
-	int				msg_flags;
+	unsigned			msg_flags;
+	unsigned			flags;
 	size_t				len;
 	size_t				done_io;
-	unsigned int			flags;
 };
 
 #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
-- 
2.36.1

