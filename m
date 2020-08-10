Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0672411AD
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 22:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgHJUZw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 16:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgHJUZv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 16:25:51 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74F2C061787
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 13:25:51 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f10so5677670plj.8
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 13:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RRLcm95D7HwMHaQnVWovL6Jt789Auw0R/IxjYUIgfDI=;
        b=jIn+6dVX0w6H1UkPp5bq5zh8cKwk6cgHdlGreLxuRjrDnHNacJ3LPEa29/bA4Xsbt4
         n7rZd7hq9bDILOditfdn9ZyW6YNUqf8SPUoS1k+4mIozPv6ZwSkzxDHgaxzc8Dvp5OIk
         KtJmXANS/zNbdksrYadq3n/gm8o0rxMvc6KL0yxdWp6K8Bd7FPTlJl2Ku4ao40vBqg6E
         kJs1BTpGD8V5uQfEtShDsSjYYVeqU+jhxHFhG/XqYTIXkk7DBffhPxXKo1zkJlJokM7y
         Sz8WTaLQuKi34Ix8E4NCGfThA166KSwN6nFDSe3FYNn7m6+wlB2O6yRGRz6KuCawLjlh
         eV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RRLcm95D7HwMHaQnVWovL6Jt789Auw0R/IxjYUIgfDI=;
        b=sEUTRzkVzTg1ZLfjYTE7rDLC814PoPRRDsl+v0gFb22ovMXX/a0dL3p8lIIGYWUxze
         YxVaz5/Ida1ZXCG83m8o6HMAbBq9w+Uj0x1SeNPOxavEdJR2ZjHkfUkR9qeNQ06VPV2t
         TWJ9pE33QYwGcd4WeBgD1ndrOgPsmg9JFMfsp5oDmRlzXmKDFDvjnHS4QA/iXabG5KS6
         O8CCpK1//3az1eY0VipIW7nzPIpA4ZDSZFzRpBYiLYvEuy8aiWm/quPH2Qa1NcaD3HIy
         SuUaK/lPMTJ3kUxhEKngKThn4p3DBSanrFhzQQIlihjQjuVeO6si2n8je2a1vqPAsiP/
         5kpw==
X-Gm-Message-State: AOAM533hCEAyJ/47t2JnOIPB/SJ3InVYVKg6HH3Z9fmvCkVTvxHj94CX
        o/uVo6hcg+cZge5qJLLDWYMmEQ==
X-Google-Smtp-Source: ABdhPJzNkt4Nzse2R+VrHUxk9eshJpjIXsfDLUFSztzOeH4EaCdRt7ZtsITBM2udJ2RqyRVPhbr/Nw==
X-Received: by 2002:a17:90a:1a02:: with SMTP id 2mr973622pjk.95.1597091151271;
        Mon, 10 Aug 2020 13:25:51 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e20sm375038pjr.28.2020.08.10.13.25.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 13:25:50 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
From:   Jens Axboe <axboe@kernel.dk>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org,
        Josef <josef.grieb@gmail.com>, Oleg Nesterov <oleg@redhat.com>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net>
 <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk>
 <20200810201213.GB3982@worktop.programming.kicks-ass.net>
 <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk>
Message-ID: <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
Date:   Mon, 10 Aug 2020 14:25:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/20 2:13 PM, Jens Axboe wrote:
>> Would it be clearer to write it like so perhaps?
>>
>> 	/*
>> 	 * Optimization; when the task is RUNNING we can do with a
>> 	 * cheaper TWA_RESUME notification because,... <reason goes
>> 	 * here>. Otherwise do the more expensive, but always correct
>> 	 * TWA_SIGNAL.
>> 	 */
>> 	if (READ_ONCE(tsk->state) == TASK_RUNNING) {
>> 		__task_work_notify(tsk, TWA_RESUME);
>> 		if (READ_ONCE(tsk->state) == TASK_RUNNING)
>> 			return;
>> 	}
>> 	__task_work_notify(tsk, TWA_SIGNAL);
>> 	wake_up_process(tsk);
> 
> Yeah that is easier to read, wasn't a huge fan of the loop since it's
> only a single retry kind of condition. I'll adopt this suggestion,
> thanks!

Re-write it a bit on top of that, just turning it into two separate
READ_ONCE, and added appropriate comments. For the SQPOLL case, the
wake_up_process() is enough, so we can clean up that if/else.

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=49bc5c16483945982cf81b0109d7da7cd9ee55ed

-- 
Jens Axboe

