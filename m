Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9978E3F06FA
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 16:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239554AbhHROrJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 10:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238799AbhHROrH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 10:47:07 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCC7C061764
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 07:46:33 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d17so1909486plr.12
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 07:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qXzjfbGAZVCj6QW9wqbn9inaUOG8fQZNbV0kpPuNxx0=;
        b=Lu2O8omEZVQDTWjESwBuZ+lf1zjRjIByR6Cs9riuDZ3w+cgt769dUF7Zevnrfaeh3V
         6SvlWSJTbDeoyOGtPIPJKSZhfYhv0qGij0lqO7H+5W9GOo6r4u9lSnOnIzaoS9NU/LDb
         x0RT1MxNKqjfJvtnKE6W3OptjH5RWYzwW6N1uO+4OqDc5P57P/e127DmlKop3dOQR6Hl
         Em5CkDOMsII/1VtxyY+6lUxKNXcFpI5WQsMuWYdREgL8/7TniSAYig45A3qGQMeVxgZu
         eYuh749M7iSpA6UBMZZkXpCEuF14BDq+NbURHFVaEGjxLMqR7ugt63k8KfXkIxi8l7z6
         o3kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qXzjfbGAZVCj6QW9wqbn9inaUOG8fQZNbV0kpPuNxx0=;
        b=tmwQFoyj0moL5R2D3c8eFM6SO1NQT0KUa7Yp6L5NwP2W4Ig6YLiq7LC9y71tPaq2mV
         lsvx3CAYgBUCDCw+krG348oPHp12Bt4MEIs3kTXgCHCscmC2uxZmRcy38PrnvVEyNmWl
         BBEyPbSQ979O0OwKEc8nbXmoo7ZIK7gFssOPVP94F6fgEtj+y/pLjulj1kJn4hI4Q7ux
         /yTyoyDAh/1shrIFwxd71bf3sL2DSiNjrE/SSU0rCuzSCSpcq2BDxyB+Ma1+Z88G8SPA
         84YHwUQQwwH4j9cDg2cjCucXg2ncvorXwROjs4BsxwUqK6IpjIrcciO/5w18a3CSzCO2
         rWRA==
X-Gm-Message-State: AOAM530u3ENBUhP+fo+fKEzf/RZ4oALX5Epfr9/FgDbFV36G4EzzWGfp
        rWuFokm3fkyLK3Ju2jekpDvlCQ==
X-Google-Smtp-Source: ABdhPJylCghWDfRMk3LEy2Q0liijBW1FCSA7PeHn+t5IVu5O8IgcIWLjOrUuIVZ7233b08IzPXyPqg==
X-Received: by 2002:a17:902:7282:b029:12c:75a0:faa5 with SMTP id d2-20020a1709027282b029012c75a0faa5mr7646785pll.35.1629297992628;
        Wed, 18 Aug 2021 07:46:32 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y2sm130003pjl.6.2021.08.18.07.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 07:46:32 -0700 (PDT)
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
To:     Tony Battersby <tonyb@cybernetics.com>,
        Olivier Langlois <olivier@trillion01.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
 <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
 <87y2bh4jg5.fsf@disp2133>
 <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
 <87sg1p4h0g.fsf_-_@disp2133> <20210614141032.GA13677@redhat.com>
 <87pmwmn5m0.fsf@disp2133>
 <4d93d0600e4a9590a48d320c5a7dd4c54d66f095.camel@trillion01.com>
 <8af373ec-9609-35a4-f185-f9bdc63d39b7@cybernetics.com>
 <9d194813-ecb1-2fe4-70aa-75faf4e144ad@kernel.dk>
 <b36eb4a26b6aff564c6ef850a3508c5b40141d46.camel@trillion01.com>
 <0bc38b13-5a7e-8620-6dce-18731f15467e@kernel.dk>
 <24c795c6-4ec4-518e-bf9b-860207eee8c7@kernel.dk>
 <05c0cadc-029e-78af-795d-e09cf3e80087@cybernetics.com>
 <b5ab8ca0-cef5-c9b7-e47f-21c0d395f82e@kernel.dk>
 <84640f18-79ee-d8e4-5204-41a2c2330ed8@kernel.dk>
 <3168284a-0b52-7845-07b1-a72bdfed915c@cybernetics.com>
 <a56b633c-b88b-dfe8-11da-fcb3853a2edf@kernel.dk>
 <16ded7e5-1f44-1c51-5759-35f835115665@cybernetics.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <90c35bf6-bf65-c997-1823-36c509cf72b1@kernel.dk>
Date:   Wed, 18 Aug 2021 08:46:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <16ded7e5-1f44-1c51-5759-35f835115665@cybernetics.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/18/21 8:37 AM, Tony Battersby wrote:
> On 8/17/21 6:05 PM, Jens Axboe wrote:
>> On 8/17/21 3:39 PM, Tony Battersby wrote:
>>> On 8/17/21 5:28 PM, Jens Axboe wrote:
>>>> Another approach - don't allow TWA_SIGNAL task_work to get queued if
>>>> PF_SIGNALED has been set on the task. This is similar to how we reject
>>>> task_work_add() on process exit, and the callers must be able to handle
>>>> that already.
>>>>
>>>> Can you test this one on top of your 5.10-stable?
>>>>
>>>>
>>>> diff --git a/fs/coredump.c b/fs/coredump.c
>>>> index 07afb5ddb1c4..ca7c1ee44ada 100644
>>>> --- a/fs/coredump.c
>>>> +++ b/fs/coredump.c
>>>> @@ -602,6 +602,14 @@ void do_coredump(const kernel_siginfo_t *siginfo)
>>>>  		.mm_flags = mm->flags,
>>>>  	};
>>>>  
>>>> +	/*
>>>> +	 * task_work_add() will refuse to add work after PF_SIGNALED has
>>>> +	 * been set, ensure that we flush any pending TIF_NOTIFY_SIGNAL work
>>>> +	 * if any was queued before that.
>>>> +	 */
>>>> +	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
>>>> +		tracehook_notify_signal();
>>>> +
>>>>  	audit_core_dumps(siginfo->si_signo);
>>>>  
>>>>  	binfmt = mm->binfmt;
>>>> diff --git a/kernel/task_work.c b/kernel/task_work.c
>>>> index 1698fbe6f0e1..1ab28904adc4 100644
>>>> --- a/kernel/task_work.c
>>>> +++ b/kernel/task_work.c
>>>> @@ -41,6 +41,12 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
>>>>  		head = READ_ONCE(task->task_works);
>>>>  		if (unlikely(head == &work_exited))
>>>>  			return -ESRCH;
>>>> +		/*
>>>> +		 * TIF_NOTIFY_SIGNAL notifications will interfere with
>>>> +		 * a core dump in progress, reject them.
>>>> +		 */
>>>> +		if ((task->flags & PF_SIGNALED) && notify == TWA_SIGNAL)
>>>> +			return -ESRCH;
>>>>  		work->next = head;
>>>>  	} while (cmpxchg(&task->task_works, head, work) != head);
>>>>  
>>>>
>>> Doesn't compile.  5.10 doesn't have TIF_NOTIFY_SIGNAL.
>> Oh right... Here's one hacked up for the 5.10 TWA_SIGNAL setup. Totally
>> untested...
>>
>> diff --git a/fs/coredump.c b/fs/coredump.c
>> index c6acfc694f65..9e899ce67589 100644
>> --- a/fs/coredump.c
>> +++ b/fs/coredump.c
>> @@ -603,6 +603,19 @@ void do_coredump(const kernel_siginfo_t *siginfo)
>>  		.mm_flags = mm->flags,
>>  	};
>>  
>> +	/*
>> +	 * task_work_add() will refuse to add work after PF_SIGNALED has
>> +	 * been set, ensure that we flush any pending TWA_SIGNAL work
>> +	 * if any was queued before that.
>> +	 */
>> +	if (signal_pending(current) && (current->jobctl & JOBCTL_TASK_WORK)) {
>> +		task_work_run();
>> +		spin_lock_irq(&current->sighand->siglock);
>> +		current->jobctl &= ~JOBCTL_TASK_WORK;
>> +		recalc_sigpending();
>> +		spin_unlock_irq(&current->sighand->siglock);
>> +	}
>> +
>>  	audit_core_dumps(siginfo->si_signo);
>>  
>>  	binfmt = mm->binfmt;
>> diff --git a/kernel/task_work.c b/kernel/task_work.c
>> index 8d6e1217c451..93b3f262eb4a 100644
>> --- a/kernel/task_work.c
>> +++ b/kernel/task_work.c
>> @@ -39,6 +39,12 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
>>  		head = READ_ONCE(task->task_works);
>>  		if (unlikely(head == &work_exited))
>>  			return -ESRCH;
>> +		/*
>> +		 * TWA_SIGNAL notifications will interfere with
>> +		 * a core dump in progress, reject them.
>> +		 */
>> +		if ((task->flags & PF_SIGNALED) && notify == TWA_SIGNAL)
>> +			return -ESRCH;
>>  		work->next = head;
>>  	} while (cmpxchg(&task->task_works, head, work) != head);
>>  
>>
> Tested with 5.10.59 + backport 06af8679449d + the patch above.  That
> fixes it for me.  I tested a couple of variations to make sure.
> 
> Thanks!
> 
> Tested-by: Tony Battersby <tonyb@cybernetics.com>

Great, thanks for testing! The 5.10 version is a bit uglier due to how
TWA_SIGNAL used to work, but it's the most straight forward backport of
the other version I sent.

-- 
Jens Axboe

