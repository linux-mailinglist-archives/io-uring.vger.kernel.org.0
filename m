Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5F41A28D0
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 20:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbgDHSsK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 14:48:10 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44907 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729414AbgDHSsK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 14:48:10 -0400
Received: by mail-pg1-f193.google.com with SMTP id n13so2290266pgp.11
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 11:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=60ZM4mPQS5JO2tdxiZ7aNVm30iaxUJzcOvgTRMztmaw=;
        b=rxlkTeuzCoxZ7Zfdv5oWOofJ7/Dc6eTycTrWHZqIGbth6iJqisb2QUcUHfqpSUSmFb
         dQnnUd1YdVyvgqCk8hfGGYNNH7ckC52dwNLlK6ZZcN06K3s2lE7mDdPDarXFN/6knzTr
         j+aTIw5RyN4XkuI3GK7mUmHhNH/VAJ7HwOMPUh0HXFglyYqQlHbNSSA+Zn/8I+uI5yIe
         bfIE3EZ6+dVppnqr0RTT4xvgxfjLMpWEh0qPFTx7hl+vy2zRP6A9cTkc/DDmtTs6Kvc3
         ObGBMZQXo0Uh8a9myRVt4m9qclOSiksFbV290LGgIlC223QyagOg/y8eW/e6+THkrWer
         LRIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=60ZM4mPQS5JO2tdxiZ7aNVm30iaxUJzcOvgTRMztmaw=;
        b=WRrTpbGiW3MoOuK5M4655gvV45yqFof3g6W8njLu34rrX3wRPSbWb4wtxBkc05Gzx6
         n4U38M3dzETLCo7HxV9M+4/Js+Rhj+R3huEBByfFdycB5EEJ/1HkvmRYnquZDAKXtXlC
         GzmjVLRUQWlVBc2aa+4XzoTDzHXD7RVsyl3dQDPECsWjOzZGcmz7BTEEUW3N+5R6a2nj
         bVcCgRwEOc0RmAM8FH3ydnknbiD6CIaQTymft0eZxl+CQjXiyC7TUJSlb0cQExVt/5Wt
         Edo0vWAqrnQiYdpWL3IRz9zCX7jyJjse8k3Sbi2ZT9TjgpI2vB3iBEBL7Th3nJC/JJlX
         Pu9A==
X-Gm-Message-State: AGi0PubnWwzjZ/LGY2AYmgRNN8BrMRYt4oVtZpjP4D2DOW4eLYL647PT
        Z3GUPcgcYV5ojwe/mrkc7+8Zug==
X-Google-Smtp-Source: APiQypJ+VGw10ufslCfLwOexfvsQNsbDwYc9A7XjPptZJD+3wC2EYEgXSPTYjayWbAXY/NKe0pxr3g==
X-Received: by 2002:a62:4ec4:: with SMTP id c187mr9385838pfb.223.1586371684934;
        Wed, 08 Apr 2020 11:48:04 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c8::12dd? ([2620:10d:c090:400::5:607f])
        by smtp.gmail.com with ESMTPSA id p4sm17138100pfg.163.2020.04.08.11.48.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 11:48:04 -0700 (PDT)
Subject: Re: [PATCH 4/4] io_uring: flush task work before waiting for ring
 exit
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        Peter Zijlstra <peterz@infradead.org>
References: <20200407160258.933-1-axboe@kernel.dk>
 <20200407160258.933-5-axboe@kernel.dk> <20200407162405.GA9655@redhat.com>
 <20200407163816.GB9655@redhat.com>
 <4b70317a-d12a-6c29-1d7f-1394527f9676@kernel.dk>
 <20200408184049.GA25918@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a31dfee4-8125-a3c1-4be6-bd4a3f71b301@kernel.dk>
Date:   Wed, 8 Apr 2020 11:48:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200408184049.GA25918@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/20 11:40 AM, Oleg Nesterov wrote:
> Jens, I am sorry. I tried to understand your explanations but I can't :/
> Just in case, I know nothing about io_uring.
> 
> However, I strongly believe that
> 
> 	- the "task_work_exited" check in 4/4 can't help, the kernel
> 	  will crash anyway if a task-work callback runs with
> 	  current->task_works == &task_work_exited.
> 
> 	- this check is not needed with the patch I sent.
> 	  UNLESS io_ring_ctx_wait_and_kill() can be called by the exiting
> 	  task AFTER it passes exit_task_work(), but I don't see how this
> 	  is possible.
> 
> Lets forget this problem, lets assume that task_work_run() is always safe.
> 
> I still can not understand why io_ring_ctx_wait_and_kill() needs to call
> task_work_run().
> 
> On 04/07, Jens Axboe wrote:
>>
>> io_uring exit removes the pending poll requests, but what if (for non
>> exit invocation), we get poll requests completing before they are torn
>> down. Now we have task_work queued up that won't get run,
>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> this must not be possible. If task_work is queued it will run, or we
> have another bug.
> 
>> because we
>> are are in the task_work handler for the __fput().
> 
> this doesn't matter...
> 
>> For this case, we
>> need to run the task work.
> 
> This is what I fail to understand :/

Actually debugging this just now to attempt to get to the bottom of it.
I'm running with Peter's "put fput work at the end at task_work_run
time" patch (with a head == NULL check that was missing). I get a hang
on the wait_for_completion() on io_uring exit, and if I dump the
task_work, this is what I get:

dump_work: dump cb
cb=ffff88bff25589b8, func=ffffffff812f7310	<- io_poll_task_func()
cb=ffff88bfdd164600, func=ffffffff812925e0	<- some __fput()
cb=ffff88bfece13cb8, func=ffffffff812f7310	<- io_poll_task_func()
cb=ffff88bff78393b8, func=ffffffff812b2c40

and we hang because io_poll_task_func() got queued twice on this task
_after_ we yanked the current list of work.

I'm adding some more debug items to figure out why this is, just wanted
to let you know that I'm currently looking into this and will provide
more data when I have it.

-- 
Jens Axboe

