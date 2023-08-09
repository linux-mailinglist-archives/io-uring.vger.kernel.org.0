Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D0E7764BB
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 18:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjHIQK0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 12:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjHIQK0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 12:10:26 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10281FCC
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 09:10:25 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1bbadf9ed37so57645ad.0
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 09:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691597425; x=1692202225;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSeEx/QOnQcky3hnjIF2nuiSrJfFfAKj29QrnWm9zN8=;
        b=08/PZPD5RHflivu2utIFV52MG4uo5KB51g5wokqobHF6YjeFiZ10NcFBV/NQoFuX+J
         b9wj9Ia5tz2ODYarOid7cFc5tIqIcP1jzqs2Yid7SkReCYIsdg3i9bqHHItpCCMfIEOt
         SdpUstEZo5tmS4nSm8d53vhC2+I3fgv3UlfNi++A2U3q/IpAc03ZJewMhD/TS5P9a6Pr
         nngYEwPaWEhY8+k+fHo/PZnGo8szoMibTDQOx/bTCPb1iTgXgj5uCHvcnCASMLE2enFr
         RLHBliM/JBdyBPj3T6sOZHFoUxrwVDxAcpw/dBOj+Wp7hl5fSTG8y+Q1vmbzwctktgtg
         L/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691597425; x=1692202225;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mSeEx/QOnQcky3hnjIF2nuiSrJfFfAKj29QrnWm9zN8=;
        b=iIiHP7hf5MU5dqpmtLxjO2qZUaW1SoHtbw4VCGj8k/orTd2XgSWun9QhMOfQhYYnS/
         YZFjZ0iUSZnzTQju+RfwZ9JE6waCVLGfBdvnoaWZwHfNGEO0ZGfvwmT+BxesPMs3I938
         VW1A7ijCg6enJXq17AEFfRdqLpE8DSGABD1dtkqHF87OBE1bPW+AwEZ4/IfroxqWDIAp
         SHVHoWHhszvZpYxPFpgNkQHNd3bZV+VpaHv7H8g5LT4WdeRRsRoraaudAqX/lP2hSSTC
         +zp7FZdeNDYeOoDaI4Homz3X+a7b8Rr4iIIvpMgR/N0xlnuuNjYsDL2dCazWZfV4KL56
         EZEA==
X-Gm-Message-State: AOJu0Yw/0oL1tZOHGdnqrOFkyX/iWP2FMnqXXEzwnrzotzNllwmkgtYy
        OadSueiru03JUcxATo88DNC2eh8K2tq0KHJLDNg=
X-Google-Smtp-Source: AGHT+IG4VuF9LcR/Xm7wPGJr37PvsnKT6UuLGJNWqkw003pipHffRd9FhTvpU/S0veQAlzSXH/coFw==
X-Received: by 2002:a17:902:cec9:b0:1b8:aded:524c with SMTP id d9-20020a170902cec900b001b8aded524cmr3889783plg.1.1691597424901;
        Wed, 09 Aug 2023 09:10:24 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v3-20020a170902d68300b001b86dd825e7sm11412016ply.108.2023.08.09.09.10.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 09:10:24 -0700 (PDT)
Message-ID: <81b0e0d1-d0e8-449d-bc6d-0f1e4bdde96f@kernel.dk>
Date:   Wed, 9 Aug 2023 10:10:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: cleanup 'ret' handling in io_iopoll_check()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We return 0 for success, or -error when there's an error. Move the 'ret'
variable into the loop where we are actually using it, to make it
clearer that we don't carry this variable forward for return outside of
the loop.

While at it, also move the need_resched() break condition out of the
while check itself, keeping it with the signal pending check.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2e1e4598c5c1..3b7da8efbe97 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1631,7 +1631,6 @@ static __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 {
 	unsigned int nr_events = 0;
-	int ret = 0;
 	unsigned long check_cq;
 
 	if (!io_allowed_run_tw(ctx))
@@ -1657,6 +1656,8 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		return 0;
 
 	do {
+		int ret = 0;
+
 		/*
 		 * If a submit got punted to a workqueue, we can have the
 		 * application entering polling for a command before it gets
@@ -1685,16 +1686,18 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 				break;
 		}
 		ret = io_do_iopoll(ctx, !min);
-		if (ret < 0)
-			break;
-		nr_events += ret;
-		ret = 0;
+		if (unlikely(ret < 0))
+			return ret;
 
 		if (task_sigpending(current))
 			return -EINTR;
-	} while (nr_events < min && !need_resched());
+		if (need_resched())
+			break;
 
-	return ret;
+		nr_events += ret;
+	} while (nr_events < min);
+
+	return 0;
 }
 
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts)

-- 
Jens Axboe

