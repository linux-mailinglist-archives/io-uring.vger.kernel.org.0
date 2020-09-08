Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CF2261821
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 19:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731733AbgIHRtJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 13:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731222AbgIHRtG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 13:49:06 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E24C061573
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 10:49:05 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b6so249159iof.6
        for <io-uring@vger.kernel.org>; Tue, 08 Sep 2020 10:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ZNp1tC7FGYnR93LoeRP53k8Vq6vUHOWVJlI0MHfXLnw=;
        b=cIJYcvyMmWC6CvAhUjxy55gA9XDQQfereR4T203nDT30azJzcwOlDpOPva0emt9sbD
         WhkgKwJ8JMo9cOe4Oj6Enu7eiecV4HaKg6eRQ2rMPcpci/9iOfrGAZ2dr8kmiLZqYny7
         Kg0XFduD1m/Tf/1I58RjAJNEICGzp6Hybg9jiNUY2pmHrHgrz/Sun9CuyNpZWGDjvTui
         Sh1ONhfuhncGUWUzkrS0KOd2t9i2+Bjyy+J4Dv6mkOZEzfbPqpNV56GtANfHCkX5aMny
         CGl7wD0AFLIvEb8shxW3toO7XdZV5eNHXndU1FOfCq0KBQu6RGWaZkP5O86eMY11jtYO
         ZeMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ZNp1tC7FGYnR93LoeRP53k8Vq6vUHOWVJlI0MHfXLnw=;
        b=fNKHooY91G1FAA5aioWIqsKGNJ+k7UArJd37OSrSyj2Y1/j54vNbuMXOyVzbb15oN9
         JvWYNZMIgTfgqY23kKNTuJH0h2hqtAOabtbZjCxhTrlBEJ4WTupEelMmM+ZFRI15fDpW
         oOmVAfxDD2QBa1Z3kkidxXeD1SgxgW6p/irjKJL/Xdmfh9/bMCFWfn6uSy6nXzL6hAA1
         Y237BLFt/RQ4J6slwj8K4+HBSyDs8uJarNEnIGBZiGUQKdh7+/UqCKJnep4FcqAnWxcj
         rwltvGW00s5P2UICaEhQUUyfxD2jHE+WzSXxgf5ZfUukqr8FF7WBwJW0UiesvNzL9Cdi
         jYAQ==
X-Gm-Message-State: AOAM532bpeTQ/NOPBXYEngzE0gLaaFOGofLwBmOMuDpuuF8QiQf2lgkL
        CqVxWGVmBYySUoRWMYdI0DwSyP1Sjlw8gACE
X-Google-Smtp-Source: ABdhPJw2F/UCoeyOnSDQ6Gf1Hr4SUbNthEkZ+WU8aP+FrEgNVSMKXSfB9URQ8q1IUn6S3hPncjT4dA==
X-Received: by 2002:a02:a04d:: with SMTP id f13mr101250jah.112.1599587343997;
        Tue, 08 Sep 2020 10:49:03 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o15sm9703349ilc.41.2020.09.08.10.49.03
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 10:49:03 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring: cap SQ submit size for SQPOLL with
 multiple rings
Message-ID: <6f4d634f-8b00-3f81-70b2-fb610ffdb793@kernel.dk>
Date:   Tue, 8 Sep 2020 11:49:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In the spirit of fairness, cap the max number of SQ entries we'll submit
for SQPOLL if we have multiple rings. If we don't do that, we could be
submitting tons of entries for one ring, while others are waiting to get
service.

The value of 8 is somewhat arbitrarily chosen as something that allows
a fair bit of batching, without using an excessive time per ring.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e21a7a9c6a59..ef86aa2a577d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6687,7 +6687,7 @@ enum sq_ret {
 };
 
 static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
-				  unsigned long start_jiffies)
+				  unsigned long start_jiffies, bool cap_entries)
 {
 	unsigned long timeout = start_jiffies + ctx->sq_thread_idle;
 	struct io_sq_data *sqd = ctx->sq_data;
@@ -6755,6 +6755,10 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 		io_ring_clear_wakeup_flag(ctx);
 	}
 
+	/* if we're handling multiple rings, cap submit size for fairness */
+	if (cap_entries && to_submit > 8)
+		to_submit = 8;
+
 	mutex_lock(&ctx->uring_lock);
 	if (likely(!percpu_ref_is_dying(&ctx->refs)))
 		ret = io_submit_sqes(ctx, to_submit, ctx->ring_file, ctx->ring_fd);
@@ -6789,6 +6793,7 @@ static int io_sq_thread(void *data)
 	start_jiffies = jiffies;
 	while (!kthread_should_stop()) {
 		enum sq_ret ret = 0;
+		bool cap_entries;
 
 		/*
 		 * Any changes to the sqd lists are synchronized through the
@@ -6801,6 +6806,8 @@ static int io_sq_thread(void *data)
 		if (unlikely(!list_empty(&sqd->ctx_new_list)))
 			io_sqd_init_new(sqd);
 
+		cap_entries = !list_is_singular(&sqd->ctx_list);
+
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			if (current->cred != ctx->creds) {
 				if (old_cred)
@@ -6814,7 +6821,7 @@ static int io_sq_thread(void *data)
 				task_unlock(current);
 			}
 
-			ret |= __io_sq_thread(ctx, start_jiffies);
+			ret |= __io_sq_thread(ctx, start_jiffies, cap_entries);
 
 			io_sq_thread_drop_mm();
 		}
-- 
2.28.0

-- 
Jens Axboe

