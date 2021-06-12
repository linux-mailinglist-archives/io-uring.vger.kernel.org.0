Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E8F3A4FBF
	for <lists+io-uring@lfdr.de>; Sat, 12 Jun 2021 18:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhFLQ3h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 12 Jun 2021 12:29:37 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:38561 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbhFLQ3h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 12 Jun 2021 12:29:37 -0400
Received: by mail-pg1-f178.google.com with SMTP id t17so5074030pga.5
        for <io-uring@vger.kernel.org>; Sat, 12 Jun 2021 09:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MQ1mPpuRuVxBspdvy6UzAnzpaI1Bxq3sd+5iifYVq6M=;
        b=X1c1dzhdcdE+0uP5L4BSVnCnYq5Podggz2EG34RYS8+w2Ggp6ZGGj4wzWuoyVVzZnP
         z69HttbHn0Bx/ntjUOHEwgY1REmy/VrDtHTD0s/N6hu4w3yV3AJ05eAoVZfW7soX10dX
         asFe552tpzR1D74iZpoxDbDf/x//1LJZkpNQaoAOrDrM2i8hIExDOBXCqxhrjchmXHDC
         BQS1bqsoLyGLwmukVEilDkksMmP3CCdlMrwo8rIzc1NKJ2tRBw9tnQmFq0qW9z57JcXw
         2iWjOcdz6e+nVFdSAfl6oecl9h36QWbVak5hYYnZBXCJvNRUTW4YyFQN3/EvQzpJr2CG
         vLzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MQ1mPpuRuVxBspdvy6UzAnzpaI1Bxq3sd+5iifYVq6M=;
        b=Xa2QIuPQoGOB7mTJ7ozeOtk7UOqg8kqff38R/CMlTZvPez2P1q3pwDlWSwfY2OpGNx
         eOak6KGxwthU0CmJOMOnh+HaQPRzpznfmV/kK802k509Ssq8R1mZ2qCrabRm8X5tnKv5
         eCp21MjcxXzpK4yxGLdRwjcCDUTfAgy7DErHeCnglqWt+oqPhbPs8WtAPQz4QWwUDWYl
         WkmMU+X5gX45I1TnuJYePsz+y+nGXlPvTyS4qPQeL7bloCPhHIdnkgYwf8wl82M2FMX+
         g5md84iHwcI2Oad98m6vgWatlUFk1pAy0PA7c+eTOUPQzHgaQdnK2CI6r6O6QLJgc4gl
         lu0g==
X-Gm-Message-State: AOAM532rQ2FJ1HG6mK4vfPNm+bQfXHq/7fkV37tDhS6jZn52b35IGvcm
        ruDW8+LVXKv3c6rv/e1rWWly+A==
X-Google-Smtp-Source: ABdhPJyy1n778pYdAk3+Hs5II6u5ygH2NnqoKQwbqwRgPrpopuaXT7omTPwdMCEDxqfglx6JblgSRQ==
X-Received: by 2002:aa7:9706:0:b029:2f2:4481:1e17 with SMTP id a6-20020aa797060000b02902f244811e17mr13862002pfg.53.1623515197779;
        Sat, 12 Jun 2021 09:26:37 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id w79sm8603030pff.21.2021.06.12.09.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jun 2021 09:26:37 -0700 (PDT)
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
To:     Olivier Langlois <olivier@trillion01.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
 <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
 <87h7i694ij.fsf_-_@disp2133>
 <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
 <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
 <87eeda7nqe.fsf@disp2133>
 <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
 <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
 <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
 <87y2bh4jg5.fsf@disp2133>
 <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
 <87sg1p4h0g.fsf_-_@disp2133>
 <9628ac27c07db760415d382e26b5a0ced41f5851.camel@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0fce1bd7-172c-84c6-915f-9cc2a45543a9@kernel.dk>
Date:   Sat, 12 Jun 2021 10:26:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9628ac27c07db760415d382e26b5a0ced41f5851.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/21 8:36 AM, Olivier Langlois wrote:
> On Thu, 2021-06-10 at 15:11 -0500, Eric W. Biederman wrote:
>>
>> Olivier Langlois has been struggling with coredumps being incompletely
>> written in
>> processes using io_uring.
>>
>> Olivier Langlois <olivier@trillion01.com> writes:
>>> io_uring is a big user of task_work and any event that io_uring made
>>> a
>>> task waiting for that occurs during the core dump generation will
>>> generate a TIF_NOTIFY_SIGNAL.
>>>
>>> Here are the detailed steps of the problem:
>>> 1. io_uring calls vfs_poll() to install a task to a file wait queue
>>>    with io_async_wake() as the wakeup function cb from
>>> io_arm_poll_handler()
>>> 2. wakeup function ends up calling task_work_add() with TWA_SIGNAL
>>> 3. task_work_add() sets the TIF_NOTIFY_SIGNAL bit by calling
>>>    set_notify_signal()
>>
>> The coredump code deliberately supports being interrupted by SIGKILL,
>> and depends upon prepare_signal to filter out all other signals.   Now
>> that signal_pending includes wake ups for TIF_NOTIFY_SIGNAL this hack
>> in dump_emitted by the coredump code no longer works.
>>
>> Make the coredump code more robust by explicitly testing for all of
>> the wakeup conditions the coredump code supports.  This prevents
>> new wakeup conditions from breaking the coredump code, as well
>> as fixing the current issue.
>>
>> The filesystem code that the coredump code uses already limits
>> itself to only aborting on fatal_signal_pending.  So it should
>> not develop surprising wake-up reasons either.
>>
>> v2: Don't remove the now unnecessary code in prepare_signal.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
>> Reported-by: Olivier Langlois <olivier@trillion01.com>
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  fs/coredump.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/coredump.c b/fs/coredump.c
>> index 2868e3e171ae..c3d8fc14b993 100644
>> --- a/fs/coredump.c
>> +++ b/fs/coredump.c
>> @@ -519,7 +519,7 @@ static bool dump_interrupted(void)
>>          * but then we need to teach dump_write() to restart and clear
>>          * TIF_SIGPENDING.
>>          */
>> -       return signal_pending(current);
>> +       return fatal_signal_pending(current) || freezing(current);
>>  }
>>  
>>  static void wait_for_dump_helpers(struct file *file)
> 
> Tested-by: Olivier Langlois <olivier@trillion01.com>

Thanks Olivier and Eric for taking care of this. I've been mostly
offline for more than a week, back at it next week.

-- 
Jens Axboe

