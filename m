Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7852039C8
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2020 16:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgFVOnu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Jun 2020 10:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbgFVOnu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Jun 2020 10:43:50 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56704C061573
        for <io-uring@vger.kernel.org>; Mon, 22 Jun 2020 07:43:49 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x11so7666355plo.7
        for <io-uring@vger.kernel.org>; Mon, 22 Jun 2020 07:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zeHebwAoza4TySfNP6Ifr8iNFRIwFIIcIRaLwE06VCM=;
        b=XScrkZbHh9nJF1p6emVjyAmaAhrwfxNEmeXqRtFZZrz0fIww7ERbJw8SVnYUnVdchu
         93+rsQfElOh5sgvunqNCo6fd5ZsKazVnsaK1lVPOOOaxBs/LhWhrrX8F2/A+g3Jfofyo
         AMP+Ofk7ZxxFfbhv0RQQ7W++GWitz/bFNbWIPX7GNGbTAws46eFihH73/lUNsFyjsa8v
         WTmjunTl9HaeqtElyPopSH8gz/pXfRUWTTXhGbikK2T2ol0aFlBe7Rv1fP8pLn33Lgb5
         hO0CjOEZxet5Whu8lDDxtYMqInp1rIrhi0foCARCK7CQa/qfmQT5YlOjnygD6H/6Ylqt
         Qg9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zeHebwAoza4TySfNP6Ifr8iNFRIwFIIcIRaLwE06VCM=;
        b=U6npJr32RC/E+bnHGXA5DoQFZ6GEowJUA6XtWje1A9dq471xjDPiR2PGrku2QGKkPb
         Wa865onm06kTi2WrmwAnZweQ3wNQvEubnawAmhwIOd7/Xd/4Q4IRAq9n7+SKVesiQsUD
         f5+ZRnJu5gnszuVujqSVuoPhxqSMFCZoyIg3+xZxL59ANQulCNqtiPIrXojg1dG0iwlZ
         crdW/hBiCFnILLWp7PncSjS1s8/C1inKap+bv9WVErCe+WCK5Ut26Q1/y2SlVuTemQkr
         2nC09xCmB/GtlHVdMUIUtL4YP3JrajOH9dV9LgR5rAvd7fcs9kgqx4GQgP2aHw8Z5fhm
         2YNA==
X-Gm-Message-State: AOAM532/PFh/UF44JEZfVrKgiqQtm2zVc/p1HCZPzbxYMCU3Fibs5vjn
        Ykjp+iyIwJB79quBPM44aKeD/ZHNhbU=
X-Google-Smtp-Source: ABdhPJzl2UXhPmalqsRp6rWlejgSCjUvIEWX6kortmI3+puDai8AZumiiNvC99dBHAXa0dW7Q5ea2Q==
X-Received: by 2002:a17:902:7045:: with SMTP id h5mr19862255plt.151.1592837028775;
        Mon, 22 Jun 2020 07:43:48 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o2sm13272886pjp.53.2020.06.22.07.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 07:43:48 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix io_sq_thread no schedule when busy
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Dust.li@linux.alibaba.com
References: <a932f437e5337cbfb42db660473fa55fa7aff9f6.1592805001.git.xuanzhuo@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <45326999-ddb2-b363-619f-71d2425a184c@kernel.dk>
Date:   Mon, 22 Jun 2020 08:43:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a932f437e5337cbfb42db660473fa55fa7aff9f6.1592805001.git.xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/21/20 11:50 PM, Xuan Zhuo wrote:
> When the user consumes and generates sqe at a fast rate,
> io_sqring_entries can always get sqe, and ret will not be equal to -EBUSY,
> so that io_sq_thread will never call cond_resched or schedule, and then
> we will get the following system error prompt:
> 
> rcu: INFO: rcu_sched self-detected stall on CPU
> or
> watchdog: BUG: soft lockup-CPU#23 stuck for 112s! [io_uring-sq:1863]
> 
> This patch adds a check after io_submit_sqes. If io_sq_thread does not call
> cond_resched or schedule for more than HZ/2, it will call them.

This looks reasonable. It'd be easier if we could just cond_resched() after
the call unconditionally, but that would not drop the mm.

But maybe we can just drop the timeout and just rely on need_resched()
for this, ala the below?

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c686061c3762..955d0765f302 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6248,7 +6248,7 @@ static int io_sq_thread(void *data)
 		 * If submit got -EBUSY, flag us as needing the application
 		 * to enter the kernel to reap and flush events.
 		 */
-		if (!to_submit || ret == -EBUSY) {
+		if (!to_submit || ret == -EBUSY || need_resched()) {
 			/*
 			 * Drop cur_mm before scheduling, we can't hold it for
 			 * long periods (or over schedule()). Do this before
@@ -6264,7 +6264,7 @@ static int io_sq_thread(void *data)
 			 * more IO, we should wait for the application to
 			 * reap events and wake us up.
 			 */
-			if (!list_empty(&ctx->poll_list) ||
+			if (!list_empty(&ctx->poll_list) || need_resched() ||
 			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
 			    !percpu_ref_is_dying(&ctx->refs))) {
 				if (current->task_works)

-- 
Jens Axboe

