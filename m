Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040DB400881
	for <lists+io-uring@lfdr.de>; Sat,  4 Sep 2021 01:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350662AbhICX5K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 19:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350621AbhICX5J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 19:57:09 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10607C061575
        for <io-uring@vger.kernel.org>; Fri,  3 Sep 2021 16:56:09 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 2so716394pfo.8
        for <io-uring@vger.kernel.org>; Fri, 03 Sep 2021 16:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=+qjg6/4xd233wLTwbDqYSheyeOMovSg43YRfkrL9iPY=;
        b=mNNTMJblHXIp4el24VfUxVJrg3HI8OE41sFY1umbOgXw+iuYISasXQPjPTxwHxDpx8
         pNpNCSLZ4oW4A54bDnpC9q3+gkkoj1WCX6u2SYAtdQkWfsFEknj9B0Q+/zLq7ETpOI1L
         truhBvgoPu16TH6r9rmfX6yihlYE/KHkfqtcODi/9FbmIte5gP+0Ic/Uh497FOq2V1Vu
         I25nb577fjj8LWHoA16yEcr4cNp/n5AoCTlh0sWZ3OEhScJ/jr6F3KwdsTK2UvksYyFk
         B5/89HIRuq5psgtCYGrnICFZhUgA64v85PDq5er4OmCRrKxfLu+K1auyD7ubKrxWTSkw
         ZtZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=+qjg6/4xd233wLTwbDqYSheyeOMovSg43YRfkrL9iPY=;
        b=OiuEBWvl5MTi+tulN9vVGNsM6cYAWMZTCvm1k4kgG8fZneqyshauxQ4TDE43UANWYZ
         C+AylpHPqM5KS7yk6n6N/mLBHMn5WaVHbNQmzvyERTSFTN+mqJ5VgonWVLJH+QOOl8fm
         KjnjTFN168fPWCkgR0atxX2i/MBtzwC9IE9T+X6k0ncBvkRhqe082MiL/8446DM9rylR
         oOqmjVB+8T2pdUqRYPxp3VGneOo+cfaDvaU/eL6x5lUDCfkJhiOtZ5BcAvKPcoywJSQ6
         vkhTUHyUUsSklJjCEAswQKhbOSHy+SPGfamNkGvHfxGosaRSW/ruPGifGepPfeSiCvsM
         1fRw==
X-Gm-Message-State: AOAM532wT7vi1oOTRSJHDM5YYyzhR7a8Ooex/Xu0XiCkKCE7dn3B4wCs
        0iRS8Q0T6DjG8RnVUR8aBSN1/adWZEe6BA==
X-Google-Smtp-Source: ABdhPJz5zogMta6gIcZAjg4qpUMjGmb0r5Vsx5brJDwwKI1vD/NTUQQyf7fpqH7d1Ng7QtmsW7fQqQ==
X-Received: by 2002:a65:5948:: with SMTP id g8mr1298723pgu.51.1630713367989;
        Fri, 03 Sep 2021 16:56:07 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id ds15sm307326pjb.19.2021.09.03.16.56.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 16:56:07 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: io_uring_complete() trace should take an integer
Message-ID: <0bbe6ed5-728a-e117-be95-282e5b0318a2@kernel.dk>
Date:   Fri, 3 Sep 2021 17:56:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It currently takes a long, and while that's normally OK, the io_uring
limit is an int. Internally in io_uring it's an int, but sometimes it's
passed as a long. That can yield confusing results where a completions
seems to generate a huge result:

ou-sqp-1297-1298    [001] ...1   788.056371: io_uring_complete: ring 000000000e98e046, user_data 0x0, result 4294967171, cflags 0

which is due to -ECANCELED being stored in an unsigned, and then passed
in as a long. Using the right int type, the trace looks correct:

iou-sqp-338-339     [002] ...1    15.633098: io_uring_complete: ring 00000000e0ac60cf, user_data 0x0, result -125, cflags 0

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index e4e44a2b4aa9..0dd30de00e5b 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -295,14 +295,14 @@ TRACE_EVENT(io_uring_fail_link,
  */
 TRACE_EVENT(io_uring_complete,
 
-	TP_PROTO(void *ctx, u64 user_data, long res, unsigned cflags),
+	TP_PROTO(void *ctx, u64 user_data, int res, unsigned cflags),
 
 	TP_ARGS(ctx, user_data, res, cflags),
 
 	TP_STRUCT__entry (
 		__field(  void *,	ctx		)
 		__field(  u64,		user_data	)
-		__field(  long,		res		)
+		__field(  int,		res		)
 		__field(  unsigned,	cflags		)
 	),
 
@@ -313,7 +313,7 @@ TRACE_EVENT(io_uring_complete,
 		__entry->cflags		= cflags;
 	),
 
-	TP_printk("ring %p, user_data 0x%llx, result %ld, cflags %x",
+	TP_printk("ring %p, user_data 0x%llx, result %d, cflags %x",
 			  __entry->ctx, (unsigned long long)__entry->user_data,
 			  __entry->res, __entry->cflags)
 );

-- 
Jens Axboe

