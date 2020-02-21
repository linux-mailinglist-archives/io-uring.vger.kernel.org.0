Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1DA168825
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 21:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgBUUNr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 15:13:47 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45755 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgBUUNq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 15:13:46 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so1512112pgk.12
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 12:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D4MqZjCgIRJ32aKvZqN6fuWuw8dg74xkhwsaZmpVTeY=;
        b=nnh8LAlNkhaIgNAfjCq1JY7jf+l4Vk59i2kVd+cryv8KImKKImQST2TaMz0rFLY8jf
         8PS+3MQWYqH8b9qhVzkoNUGwO06axg2aGJBjsxTuUIgWnt0QxPa8o9SzOZ1t96fyg+t2
         hvTiZwyDjO57yjtXWLmtVaIvqxzILo6YpzmoLPY7/o11P9cRQnhPZuN7MDisJHHu9zo3
         ajbKBROmk1vqXeOhVwSt3FmcBtIMcMIeHLFmirSfsHWupy0OGrX1k9Upbp9oJvAdANzy
         xGh/Tdt2JdgVTlN+vAmgeNCHkVl1VlW/W8WZGo+VnzaqSD1pZaTuEM75ZcEV6xS7QbY/
         FTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D4MqZjCgIRJ32aKvZqN6fuWuw8dg74xkhwsaZmpVTeY=;
        b=EE/VDm47j1UCt0/hpBJzRw3Yaub4mHJ968SzkoQksgSYKRHXhIfhrB0XLKBWt36F9O
         0XlikXNkr0j2qVS7Mi3NJM+XIVE4jrHH0eAZaR+PEy1DVgFGjJK3uFq5/sRE3hd+AW5+
         rnVKRAsvEM3XcEMWlLc2vALYiVg7jBP1WkZeG0E6HEilrSx7ZJkmJVzDkkx5PODgA7qD
         QGuFCYtOdJmbB4HsXsBd1DtkwHmAMbni1wPMhc0Kn0dtpsaqlXSJ+Syhe3H7I6abJF98
         odB95FQfe8X0ZzsdhlBRuqliAoDJUdw9bH+zlr8HonFrGrmh3RQdrf0htY2z8zSHBZx8
         wIGg==
X-Gm-Message-State: APjAAAWg+8CB9iE9ROtXlbKEFiN/5DO2M92d5JnDO0Rj7zurgT3jtDEk
        xbgRNpB5B7KTPrvhwGXUiSMlNiT/GBs=
X-Google-Smtp-Source: APXvYqzbtHFSPxfubBP1ll1nskTQ/+1Q6JPYrsTuK+Ja4Bmw7Oldirn1AE6cPqwpl/TCl1pR8qCeyA==
X-Received: by 2002:a62:6842:: with SMTP id d63mr39528560pfc.113.1582316024441;
        Fri, 21 Feb 2020 12:13:44 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:91ff:e31e:f68d:32a9? ([2605:e000:100e:8c61:91ff:e31e:f68d:32a9])
        by smtp.gmail.com with ESMTPSA id d73sm3707697pfd.109.2020.02.21.12.13.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 12:13:43 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <20200221104740.GE18400@hirez.programming.kicks-ass.net>
 <7e8d4355-fd2c-b155-b28c-57fd20db949d@kernel.dk>
 <20200221162354.GZ14897@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <149b3b2f-0bb1-076b-0aa7-920a21a62f81@kernel.dk>
Date:   Fri, 21 Feb 2020 12:13:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221162354.GZ14897@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/20 9:23 AM, Peter Zijlstra wrote:
> On Fri, Feb 21, 2020 at 06:49:16AM -0800, Jens Axboe wrote:
> 
>>> Jens, what exactly is the benefit of running this on every random
>>> schedule() vs in io_cqring_wait() ? Or even, since io_cqring_wait() is
>>> the very last thing the syscall does, task_work.
>>
>> I took a step back and I think we can just use the task work, which
>> makes this a lot less complicated in terms of locking and schedule
>> state. Ran some quick testing with the below and it works for me.
>>
>> I'm going to re-spin based on this and just dump the sched_work
>> addition.
> 
> Aswesome, simpler is better.

Agree!

>> @@ -5392,6 +5392,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>>  						TASK_INTERRUPTIBLE);
>>  		if (io_should_wake(&iowq, false))
>>  			break;
>> +		if (current->task_works) {
>> +			task_work_run();
>> +			if (io_should_wake(&iowq, false))
>> +				break;
>> +			continue;
>> +		}
> 
> 		if (current->task_works)
> 			task_work_run();
> 		if (io_should_wake(&iowq, false);
> 			break;
> 
> doesn't work?

Yeah it totally does, I'll make that change. Not sure what I was
thinking there.

>>  		schedule();
>>  		if (signal_pending(current)) {
>>  			ret = -EINTR;
> 
> 
> Anyway, we need to be careful about the context where we call
> task_work_run(), but afaict doing it here should be fine.

Right, that's the main win over the sched in/out approach. On clean
entry to a system call we should be fine, I added it for
io_uring_enter() as well. We're not holding anything at that point.

-- 
Jens Axboe

