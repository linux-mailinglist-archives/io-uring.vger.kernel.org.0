Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86A1342998
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 02:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCTBVK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 21:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhCTBUz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 21:20:55 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D875BC061760
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 18:20:54 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id m7so4829878pgj.8
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 18:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C5qhWR+cFpmky5lO19AfC0ixNdrCMKqZi7+8hdG1SoM=;
        b=SkNCVbEJtUbrX0fkc0Wcx4GUFqojme+gVFg6RNoyD7dlm330gQKUpfLEa+KXmEZ+Ka
         sJZun6egQ8T6J/Y9OYsq7uCogqFY07XNjh6dk4WRiW6Zo6+azcC9i+ROVyYkxv5mHLql
         tNB7pC+zk764Wbbtfbt4bWe3uR45OLGwr632a9tfCrqAFi2OofLcPjK9Z8aNiYtuCiYU
         3/hWTJgVibXvLCH4wpdIQUCwCwRFWQSRC0xkJMQbErIJ6KX3tH5UNd/kVKq3jUX77BDz
         /dQYxJCbcpZxSuiSH329WLvlSdau6v+W4GQFr3JsPCsquqYXlDczUtXhaYS4OI7QDN/9
         EmOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C5qhWR+cFpmky5lO19AfC0ixNdrCMKqZi7+8hdG1SoM=;
        b=YcGyILoHVAsgQD8NjIUbIuFBCHbBc6SRJK4Jo///SbaWS+oz+06LL0i/DIefLJQb5E
         6ILygF4pWxjjnvRi1K+QuH/EkomX5a+lSTddem+hh5sQlC9gd89z1h6Cqw3ExiopOxn9
         RILGRuKhUFyk/KpwiWk1bLKiS1L8iF5u63qmOobKcSx80ZsEX/HYm5rDnLaSfqlEl+sN
         sBm92kY210apy0ZH+Fo/1vQ5VNdnIolegEiO2wsTDVBOEE2oOUHhj7rppR55wBkzRnFD
         6NOBEAhOHE5Libew4+EfV0ZMqvuc3V62/7TsH55yoR9LU/g7+TuJwQk5PFN6xS1HWLC+
         IRYA==
X-Gm-Message-State: AOAM532eDEH91xbIUyckH+6T1ftnjCDyN7GSnHb9dBVkx0Hwr0xsIPzO
        pXqn8nfwIUiXWcUEdxP2Gy3oJf9FC2Dlcw==
X-Google-Smtp-Source: ABdhPJytHDn8MqlvXwQujdQAOist0M9J7aBDl6qRAGjpfFwywaaKP+/iZJ1NSzlRzbgYnr6krS9Brw==
X-Received: by 2002:a05:6a00:c93:b029:20d:1b8e:cfaa with SMTP id a19-20020a056a000c93b029020d1b8ecfaamr11619355pfv.48.1616203253852;
        Fri, 19 Mar 2021 18:20:53 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w22sm6273303pfi.133.2021.03.19.18.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 18:20:53 -0700 (PDT)
Subject: Re: Problems with io_threads
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <d1a8958c-aec7-4f94-45f8-f4c2f2ecacff@samba.org>
 <F3B6EA77-99D1-4424-85AC-CFFED7DC6A4B@kernel.dk>
 <85472dbd-7113-fe2b-fe0e-100d8fc34860@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1213a929-30f2-592d-86a2-ddcf84139940@kernel.dk>
Date:   Fri, 19 Mar 2021 19:20:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <85472dbd-7113-fe2b-fe0e-100d8fc34860@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/19/21 6:25 PM, Stefan Metzmacher wrote:
> Am 20.03.21 um 00:46 schrieb Jens Axboe:
>> On Mar 19, 2021, at 5:27 PM, Stefan Metzmacher <metze@samba.org> wrote:
>>>
>>> ﻿Hi Jens,
>>>
>>> as said before I found some problems related to
>>> the new io_threads together with signals.
>>>
>>> I applied the diff (at the end) to examples/io_uring-cp.c
>>> in order to run endless in order to give me time to
>>> look at /proc/...
>>>
>>> Trying to attach gdb --pid to the pid of the main process (thread group)
>>> it goes into an endless loop because it can't attach to the io_threads.
>>>
>>> Sending kill -STOP to the main pid causes the io_threads to spin cpu
>>> at 100%.
>>>
>>> Can you try to reproduce and fix it? Maybe same_thread_group() should not match?
>>
>> Definitely, I’ll go over this shortly and make sure we handle (and ignore) signals correctly. 
> 
> Thanks! Also a kill -9 to a io_thread kills the application.

OK, this I believe should take care of it - ignore STOP specifically for
PF_IO_WORKER, and disallow any signal sent to a worker.

diff --git a/kernel/signal.c b/kernel/signal.c
index ba4d1ef39a9e..b113bf647fb4 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -833,6 +833,9 @@ static int check_kill_permission(int sig, struct kernel_siginfo *info,
 
 	if (!valid_signal(sig))
 		return -EINVAL;
+	/* PF_IO_WORKER threads don't take any signals */
+	if (t->flags & PF_IO_WORKER)
+		return -EPERM;
 
 	if (!si_fromuser(info))
 		return 0;
@@ -2346,6 +2349,10 @@ static bool do_signal_stop(int signr)
 
 		t = current;
 		while_each_thread(current, t) {
+			/* don't STOP PF_IO_WORKER threads */
+			if (t->flags & PF_IO_WORKER)
+				continue;
+
 			/*
 			 * Setting state to TASK_STOPPED for a group
 			 * stop is always done with the siglock held,

-- 
Jens Axboe

