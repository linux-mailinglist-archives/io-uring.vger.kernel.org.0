Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A6D29E160
	for <lists+io-uring@lfdr.de>; Thu, 29 Oct 2020 03:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgJ1Vve (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Oct 2020 17:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728153AbgJ1Vvd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Oct 2020 17:51:33 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452B2C0613D1
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 14:51:33 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id c11so998966iln.9
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 14:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V5xT/TVNJaEN5+iWNdQc+ZQaG4gZCPhnf9TiZ66aFMc=;
        b=0OZ20SAJwtEwhFAnooWd+EM+C1BJreT+JGFVuEjQ2FCq6IlFnFpbweNlMOGweIeXcK
         12yLw6FMBrlxkyh8o1mMPwHoKeLm3EYqcmUoL7xbnDf0uoSG10g8VTldzP0gz6ozUQm/
         KlnnbelMs8PCigZE71PsI6YcNxRvvT+FNRPKHH3/eudfPlTkyrUkSVyi3rFOy1m2LfeB
         AlhKZlqWkqSG2JcWdzDGNMs7NfXTXISfuvx5vSNtxzyxsxBdyDkZUH96usLP0R0rLXz9
         77YEGwX97Svf8k7Ol4iZFBfmIwPfYWLNvr2w9LjUjddvJYP5UuU5ALYV7mzdtZY4340n
         J9hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V5xT/TVNJaEN5+iWNdQc+ZQaG4gZCPhnf9TiZ66aFMc=;
        b=EvMWyoOHbqR6u/54wThrHj8pZEutiZd8GSDfh+3QqX7dK534YodeS7esNKomUr8NLF
         V7YEou2EhSlALX5yDK9Hj8czzYv0Bl5nPA8YIH+5jADn6ZbqD/CKswVq6X7Bj9BuPsuS
         WqQ+sQm3a6CgO57mAzCFBuz8SzDW6euF0iExGAvEjCB2Uf0g/1JOGt+9OS1EJmmtte6u
         B6FhEQ2eCGUeV49e9bdR+uoJCEWgb/W+0RhUPvy548aMAUmpE1xwdHp9NSsch8B0TedI
         3U57apBMkveGZ8WM4ojutjAKcdry0liDCvZi1wPOgJpPmqQWULjLSIFaK5pO+Fwg/jDv
         vTOA==
X-Gm-Message-State: AOAM530NkhLNO+NDczxZi4jlNiRHXO/oXIrKkWudMBoPso35KQ2cB2Wa
        /Bmy7jTi4o0FApvG4fo02uZToKHCQTq10Q==
X-Google-Smtp-Source: ABdhPJyxZGbwrFiWBMmAn2MSWLAucBtK1gUChIjQgOeuSgYz6/DriQVdARII6bLA0yu6RBPggRHgeA==
X-Received: by 2002:a6b:db06:: with SMTP id t6mr6131111ioc.204.1603892193673;
        Wed, 28 Oct 2020 06:36:33 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g185sm2729808ilh.35.2020.10.28.06.36.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 06:36:33 -0700 (PDT)
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogW1BBVENIXSBpby13cTogc2V0IHRhc2sgVEFTS19J?=
 =?UTF-8?Q?NTERRUPTIBLE_state_before_schedule=5ftimeout?=
To:     "Zhang, Qiang" <Qiang.Zhang@windriver.com>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20201027030911.16596-1-qiang.zhang@windriver.com>
 <bc138db4-4609-b8e6-717a-489cf2027fc0@kernel.dk>
 <BYAPR11MB2632A45DB4DA30E34D412528FF170@BYAPR11MB2632.namprd11.prod.outlook.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <32a5ce10-bdbf-57fe-4318-ce53ad47f161@kernel.dk>
Date:   Wed, 28 Oct 2020 07:36:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <BYAPR11MB2632A45DB4DA30E34D412528FF170@BYAPR11MB2632.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/27/20 8:47 PM, Zhang, Qiang wrote:
> 
> 
> ________________________________________
> 发件人: Jens Axboe <axboe@kernel.dk>
> 发送时间: 2020年10月27日 21:35
> 收件人: Zhang, Qiang
> 抄送: io-uring@vger.kernel.org; linux-kernel@vger.kernel.org
> 主题: Re: [PATCH] io-wq: set task TASK_INTERRUPTIBLE state before schedule_timeout
> 
> On 10/26/20 9:09 PM, qiang.zhang@windriver.com wrote:
>> From: Zqiang <qiang.zhang@windriver.com>
>>
>> In 'io_wqe_worker' thread, if the work which in 'wqe->work_list' be
>> finished, the 'wqe->work_list' is empty, and after that the
>> '__io_worker_idle' func return false, the task state is TASK_RUNNING,
>> need to be set TASK_INTERRUPTIBLE before call schedule_timeout func.
>>
>> I don't think that's safe - what if someone added work right before you
>> call schedule_timeout_interruptible? Something ala:
>>
>>
>> io_wq_enqueue()
>>                        set_current_state(TASK_INTERRUPTIBLE();
>>                        schedule_timeout(WORKER_IDLE_TIMEOUT);
>>
>> then we'll have work added and the task state set to running, but the
>> worker itself just sets us to non-running and will hence wait
>> WORKER_IDLE_TIMEOUT before the work is processed.
>>
>> The current situation will do one extra loop for this case, as the
>> schedule_timeout() just ends up being a nop and we go around again
> 
> although the worker task state is running,  due to the call
> schedule_timeout, the current worker still possible to be switched
> out. if set current worker task is no-running, the current worker be
> switched out, but the schedule will call io_wq_worker_sleeping func
> to wake up free worker task, if wqe->free_list is not empty.  

It'll only be swapped out for TASK_RUNNING if we should be running other
work, which would happen on next need-resched event anyway. And the miss
you're describing is an expensive one, as it entails creating a new
thread and switching to that. That's not a great way to handle a race.

So I'm a bit puzzled here - yes we'll do an extra loop and check for the
dropping of mm, but that's really minor. The solution is a _lot_ more
expensive for hitting the race of needing a new worker, but missing it
because you unconditionally set the task to non-running. On top of that,
it's also not the idiomatic way to wait for events, which is typically:

is event true, break if so
set_current_state(TASK_INTERRUPTIBLE);
					event comes in, task set runnable
check again, schedule
doesn't schedule, since we were set runnable

or variants thereof, using waitqueues.

So while I'm of course not opposed to fixing the io-wq loop so that we
don't do that last loop when going idle, a) it basically doesn't matter,
and b) the proposed solution is much worse. If there was a more elegant
solution without worse side effects, then we can discuss that.

-- 
Jens Axboe

