Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B4F466EC9
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 01:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377936AbhLCAxE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Dec 2021 19:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377798AbhLCAxD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Dec 2021 19:53:03 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC88C06174A
        for <io-uring@vger.kernel.org>; Thu,  2 Dec 2021 16:49:40 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id x6so1701535iol.13
        for <io-uring@vger.kernel.org>; Thu, 02 Dec 2021 16:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jVXlZUdc270qJIiO0ke6GCXHxXLR9ixPUlyQJCOolsk=;
        b=ae34wnV7EZa4fqa+vvz9ZhUwzOkIMtkhtcsuZqK3rJmzu69w9+Ypl/a9RbevRCVVu9
         e03Sjj2j8SwKyGrC/TrEgmauo/CohTBB5KMRgmYo3oTNv36TAV4tH9o9wV5/ff5LsRXJ
         cG7JquJgEQHPGWvN2ljbTf2ER0Fio6i1CXuSIgLY9HcWgSqIzhttriCYhNCCuvb73z3i
         JeOH57bwVq8RobOfVuR9+4fC/nqBkn1vp23DAcB8gx/vs0bZixxDigi6dVh65JLn0Var
         aeU+AMQUxNKZA+dJkvGDS9gsjtW2tTfLFdfsfWjgdGQqb/y2bM2J45611d1RLYBJ2Tjk
         dMRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jVXlZUdc270qJIiO0ke6GCXHxXLR9ixPUlyQJCOolsk=;
        b=szzayRbCHEpgUJdV75vDVItLll70BlnpRThjJeJ6lgrwUwSWIowuZH22OZ/BSUS2NZ
         X9teHDcU47f+c3Wf775B9SVerrJAUVOf4vXO1XOrSSQQiOOv9ovTnqvFhZRFTnExxuXX
         LwUXl2w4KcJ7vrm5V9y/TFg1lrCoge7JMgQ0jKfq7MuGTDdrwRiknxcNMQkk48Rj6gQi
         DOUSE8pnZdUf6vJqJhovlgjuaE9od4Ong5LC8nu5+x9xTj7b/P2pNZi7MSPoS5KUE4+T
         XcAz7FGCO/qsB37JcIm5dX4b4CAG/2IJllFfLyle56SmgxqQnWrQeDzi+oc3fdAHg4dK
         Eu2A==
X-Gm-Message-State: AOAM532bPfCRUFXW0jCpnhVdmnZL1DBeDNKkkvHVP1CWajsP6EBeJ8Zd
        juxSj7QZsTi+s1JM9bPb8b+3Grj0kXqj1Gli
X-Google-Smtp-Source: ABdhPJzQxpBa3Kq2BIAMFiTSJN66Zl3r12ZpABFCq7qD2/L2s75xwsNyUgIcPsPMuWjG17gUduDQ9Q==
X-Received: by 2002:a05:6638:32a2:: with SMTP id f34mr20421741jav.63.1638492579908;
        Thu, 02 Dec 2021 16:49:39 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id 11sm686143ilt.63.2021.12.02.16.49.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 16:49:39 -0800 (PST)
Subject: Re: Tasks stuck on exit(2) with 5.15.6
To:     io-uring@vger.kernel.org, Florian Schmaus <schmaus@cs.fau.de>
References: <20211202165606.mqryio4yzubl7ms5@pasture>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c4c47346-e499-2210-b511-8aa34677ff2e@kernel.dk>
Date:   Thu, 2 Dec 2021 17:49:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211202165606.mqryio4yzubl7ms5@pasture>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/2/21 9:56 AM, Florian Fischer wrote:
> Hello,
> 
> I experienced stuck tasks during a process' exit when using multiple
> io_uring instances on a 48/96-core system in a multi-threaded environment,
> where we use an io_uring per thread and a single pipe(2) to pass messages
> between the threads.
> 
> When the program calls exit(2) without joining the threads or unmapping/closing
> the io_urings, the program gets stuck in the zombie state - sometimes leaving
> behind multiple <cpu>:<n>-events kernel-threads using a considerable amount of CPU.
> 
> I can reproduce this behavior on Debian running Linux 5.15.6 with the
> reproducer below compiled with Debian's gcc (10.2.1-6):

Thanks for the bug report, and I really appreciate including a reproducer.
Makes everything so much easier to debug.

Are you able to compile your own kernels? Would be great if you can try
and apply this one on top of 5.15.6.


diff --git a/fs/io-wq.c b/fs/io-wq.c
index 8c6131565754..e8f77903d775 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -711,6 +711,13 @@ static bool io_wq_work_match_all(struct io_wq_work *work, void *data)
 
 static inline bool io_should_retry_thread(long err)
 {
+	/*
+	 * Prevent perpetual task_work retry, if the task (or its group) is
+	 * exiting.
+	 */
+	if (fatal_signal_pending(current))
+		return false;
+
 	switch (err) {
 	case -EAGAIN:
 	case -ERESTARTSYS:

-- 
Jens Axboe

