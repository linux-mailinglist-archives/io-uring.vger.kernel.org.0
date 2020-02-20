Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C549D166A12
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 22:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgBTVxg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 16:53:36 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37916 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgBTVxg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 16:53:36 -0500
Received: by mail-pl1-f194.google.com with SMTP id t6so2074651plj.5
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 13:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6ytNSQ/iFOAhZykhX5gecgYD5r+9jXzbzfRX1X7j2I8=;
        b=UCts0eNgQENW0jyijd6tzpwIuCzr4Y5c9PF7xj9OwqDI1TUN7ZgF2wKZ2u15ltUxYd
         LO3kUi1HAkkgH8zI973kxNz09PAqdgLkhaZ5sWzs6R1R8mHSQHqelyC3PKpy+GFknU0u
         ElRxkpq7B9OSgWjdUUaTOSoMzVm4/zsWkP+cNkZZ/suhOl0TTUbPWoLERTbiz/oeScZz
         StM7Fzt8LE0GG/S5UaN5VqINXfMbBM+i2UEBlbggJgn088gxbaGRm+uZXG2vo2vOcQyk
         TQaSXNixX/cLfVZpZXvg53YhWF6LvxxR2RzBvv6Dt5Tvp6A0JKoWgpzLdb9AyBjFXldH
         rvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6ytNSQ/iFOAhZykhX5gecgYD5r+9jXzbzfRX1X7j2I8=;
        b=HViZ2Q3slhSa7fHZ2AOtELMZQsyx4IJrd4fzElr0XvjyDrEjqti45626Q4k/BzY1YO
         VyzX1DAx/Aso4v9Sg2/3ydV2EvON2J1ErbVfTZmglPdAc/gx/O78xJ+JqMlU2S1rUr+0
         ZC8weUkhUKqHWrX88EJWyn7oRNG2SorI3pP0ofXLouyTkHNJ3qQWs+5wNcbUlvDEkZyH
         BYKalvFWcrdh6zd/j2fK8a4jxQu0oXXQAINLvB+0xrULPM2tLXM+0AA1NjYfozsFPVvJ
         nypNw2MBJhzKsta2TuJS2iA/Ac+p8pVsZZ+3bTUz+ULb3njf4fx9iHdeyi6Rlct15vMv
         bV2g==
X-Gm-Message-State: APjAAAXkkU/BJkHeeFa5PphciJpIcrYAFDIesfEZfZp93AJuLFVFrrgp
        zkJNik8uUswI3xl5eCaEtvxf8g==
X-Google-Smtp-Source: APXvYqwnmZP4tRg/HqGWcoAmI2MYMAGJtTFwoJRkmKgh7ZXGYQ0/guDR+9lfYJR2ofPJAZa8eXlHTg==
X-Received: by 2002:a17:902:6b07:: with SMTP id o7mr32342739plk.141.1582235615599;
        Thu, 20 Feb 2020 13:53:35 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1130::1006? ([2620:10d:c090:180::17d5])
        by smtp.gmail.com with ESMTPSA id 10sm528157pfu.132.2020.02.20.13.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 13:53:35 -0800 (PST)
Subject: Re: [PATCH 6/9] sched: add a sched_work list
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, glauber@scylladb.com,
        asml.silence@gmail.com
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-7-axboe@kernel.dk>
 <20200220211744.GN11457@worktop.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <42c87f4d-cf37-7240-b232-2a811c7750b8@kernel.dk>
Date:   Thu, 20 Feb 2020 13:53:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200220211744.GN11457@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 2:17 PM, Peter Zijlstra wrote:
> On Thu, Feb 20, 2020 at 01:31:48PM -0700, Jens Axboe wrote:
>> This is similar to the task_works, and uses the same infrastructure, but
>> the sched_work list is run when the task is being scheduled in or out.
>>
>> The intended use case here is for core code to be able to add work
>> that should be automatically run by the task, without the task needing
>> to do anything. This is done outside of the task, one example would be
>> from waitqueue handlers, or anything else that is invoked out-of-band
>> from the task itself.
>>
> 
> 
>> diff --git a/kernel/task_work.c b/kernel/task_work.c
>> index 3445421266e7..ba62485d5b3d 100644
>> --- a/kernel/task_work.c
>> +++ b/kernel/task_work.c
>> @@ -3,7 +3,14 @@
>>  #include <linux/task_work.h>
>>  #include <linux/tracehook.h>
>>  
>> -static struct callback_head work_exited; /* all we need is ->next == NULL */
>> +static void task_exit_func(struct callback_head *head)
>> +{
>> +}
>> +
>> +static struct callback_head work_exited = {
>> +	.next	= NULL,
>> +	.func	= task_exit_func,
>> +};
> 
> Do we really need this? It seems to suggest we're trying to execute
> work_exited, which would be an error.
> 
> Doing so would be the result of calling sched_work_run() after
> exit_task_work(). I suppose that's actually possible.. the problem is
> that that would reset sched_work to NULL and re-allow queueing works,
> which would then leak.
> 
> I'll look at it in more detail tomorrow, I'm tired...

Let me try and instrument it, I definitely hit it on task exit
but might have been induced by some earlier bugs.

-- 
Jens Axboe

