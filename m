Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A039162B15
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 17:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgBRQwY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 11:52:24 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40592 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgBRQwX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 11:52:23 -0500
Received: by mail-pg1-f195.google.com with SMTP id z7so11223145pgk.7
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2020 08:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o9jUUO37mafOf+GPMx0ynDJAq/xAjJFTAhGaqUALXjE=;
        b=xG+T2o5pJ+QNt8owlhGLHA0Yo7G83fng7R1g8ot/mQfaad7vh89Bcwyt7JMa1R4mQm
         SlYqajsXPMkb5JeFuaJ1a4UiUUOXHc5PwB+dII7Rkcvjv4qAXU845pRpjiOdl1auLMyj
         A2k1wiacLmzZgGp9vFmstqY4Qi8sGAhzKjQqV0Yrfqtwj4PEIFU3vMI9/yGGSuoTxjnY
         f0xeo5wHCMMQjq4Nf5BcwXhc3uSEMeXG/R0Eytd8tku7+ztXDr2iVpknhGWRlypfVquY
         rnmGpPFNn+lHhHlBrmrH5xfINX1KZpC/jxqTMrFubUsFBu5cYP6PAZtMYezFO4GrjUV7
         U9EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o9jUUO37mafOf+GPMx0ynDJAq/xAjJFTAhGaqUALXjE=;
        b=X1yLeajAD7Kmr+4Ohi8MsBMK2/F8tsFgUA2gamymNTyC6gSJiFqbZ5TrVKddX/MpSD
         +6rARRA6IzI9aGYfrsCi0w4wE73ClUlPmQP/mf0/Ha4TvaLvy04xfumkxdUgfgC3ORcd
         lqYLRcuNCuUUA9XT4DoGk7LTeXqtTyKvVrkamxPw2kwx+KGU36HSG40rFTcAAUatcyxc
         m4OM+f/mGVOeDU6ByDvZi7jsV2VQgTLZnwD1LwnfDo+TF1934nLUYKSZ7CrwZsByicBW
         Ou5OEMrO5U7spoXc7lmgeJoGbPNzg2AgRcd0TKVS9+6g33nud/gN1lKxCiWKENHLy2O3
         9ocw==
X-Gm-Message-State: APjAAAW77+HzNt6izQmgF2VY7rSxhs3LL1yojNpaW8C8S7KWo/ZQfATw
        CIBNEnRqS1+9XoiZqtpa8u/Dqw==
X-Google-Smtp-Source: APXvYqyXxolSCxRvWXWM4cOf1r1x7epofwcsrrfJabW7gwbC/NiamnZFQqb/7uE7WKe28B9bfZrWsA==
X-Received: by 2002:a63:7019:: with SMTP id l25mr23403789pgc.132.1582044741752;
        Tue, 18 Feb 2020 08:52:21 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:5924:648b:19a7:c9d0? ([2605:e000:100e:8c61:5924:648b:19a7:c9d0])
        by smtp.gmail.com with ESMTPSA id m187sm5349534pga.65.2020.02.18.08.52.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 08:52:21 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
From:   Jens Axboe <axboe@kernel.dk>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <4f5bdc83-b308-34f4-61fd-54480f84b5f3@kernel.dk>
Message-ID: <e9bb928a-13dc-71be-5f02-f24ab5027345@kernel.dk>
Date:   Tue, 18 Feb 2020 08:52:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <4f5bdc83-b308-34f4-61fd-54480f84b5f3@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/18/20 9:46 AM, Jens Axboe wrote:
> On 2/18/20 6:13 AM, Peter Zijlstra wrote:
>> Jens, I think you want something like this on top of what you have,
>> mostly it is adding sched_work_run() to exit_task_work().
> 
> It also makes it a bit cleaner, I don't like the implied task == current
> we have in a bunch of spots. Folded this in (thanks!) with minor edit:
> 
>> @@ -157,10 +157,10 @@ static void __task_work_run(struct task_struct *task,
>>   */
>>  void task_work_run(void)
>>  {
>> -	__task_work_run(current, &current->task_works);
>> +	__task_work_run(&current->task_works);
>>  }
>>  
>> -void sched_work_run(struct task_struct *task)
>> +void sched_work_run()
>>  {
>> -	__task_work_run(task, &task->sched_work);
>> +	__task_work_run(&task->sched_work);
>>  }
> 
> s/task/current for this last one.

Current series, same spot:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-task-poll

I added Oleg's patch first in the series, then rebased on top and folded
in the incremental from you. Will run some testing now, otherwise only
sporadically available today and tomorrow. Unless something major comes
up, I'll send this out for review tomorrow afternoon local time.

-- 
Jens Axboe

