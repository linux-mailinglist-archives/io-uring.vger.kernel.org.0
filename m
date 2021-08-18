Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874203F0726
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 16:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239619AbhHROx7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 10:53:59 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:42376 "EHLO
        mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239422AbhHROx7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 10:53:59 -0400
X-Greylist: delayed 923 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Aug 2021 10:53:59 EDT
X-ASG-Debug-ID: 1629297477-0fb3b00bc417930001-k4Lu3k
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id gjZEXC8G7LNH6CcL; Wed, 18 Aug 2021 10:37:57 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
        bh=ynC0n0o/MwJWWEMvZa3oMfrOfT4CVlX4ADdSMbZ7FK0=;
        h=Content-Language:Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; b=W379zB+e4BIwXjP
        VVB7AqIjHy2zCqvJIE2I/xkZUTHbg1EbGNNk2YHqhLDqXXtJcJ5/dlTYqiwteMAU9nLzZ5P+yFS1L
        WqIYz2o5Sq2IcdZF/UKlelXt4UyU0ZrNuaZVaekBF8ZQt+6TkoyJGRMS+FrY9jERc9yIzAFaw8IeC
        Mg=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate Pro SMTP 6.2.14)
  with ESMTPS id 11076811; Wed, 18 Aug 2021 10:37:57 -0400
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
To:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] coredump: Limit what can interrupt coredumps
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
 <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
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
From:   Tony Battersby <tonyb@cybernetics.com>
Message-ID: <16ded7e5-1f44-1c51-5759-35f835115665@cybernetics.com>
Date:   Wed, 18 Aug 2021 10:37:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <a56b633c-b88b-dfe8-11da-fcb3853a2edf@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1629297477
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 3597
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/17/21 6:05 PM, Jens Axboe wrote:
> On 8/17/21 3:39 PM, Tony Battersby wrote:
>> On 8/17/21 5:28 PM, Jens Axboe wrote:
>>> Another approach - don't allow TWA_SIGNAL task_work to get queued if
>>> PF_SIGNALED has been set on the task. This is similar to how we reject
>>> task_work_add() on process exit, and the callers must be able to handle
>>> that already.
>>>
>>> Can you test this one on top of your 5.10-stable?
>>>
>>>
>>> diff --git a/fs/coredump.c b/fs/coredump.c
>>> index 07afb5ddb1c4..ca7c1ee44ada 100644
>>> --- a/fs/coredump.c
>>> +++ b/fs/coredump.c
>>> @@ -602,6 +602,14 @@ void do_coredump(const kernel_siginfo_t *siginfo)
>>>  		.mm_flags = mm->flags,
>>>  	};
>>>  
>>> +	/*
>>> +	 * task_work_add() will refuse to add work after PF_SIGNALED has
>>> +	 * been set, ensure that we flush any pending TIF_NOTIFY_SIGNAL work
>>> +	 * if any was queued before that.
>>> +	 */
>>> +	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
>>> +		tracehook_notify_signal();
>>> +
>>>  	audit_core_dumps(siginfo->si_signo);
>>>  
>>>  	binfmt = mm->binfmt;
>>> diff --git a/kernel/task_work.c b/kernel/task_work.c
>>> index 1698fbe6f0e1..1ab28904adc4 100644
>>> --- a/kernel/task_work.c
>>> +++ b/kernel/task_work.c
>>> @@ -41,6 +41,12 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
>>>  		head = READ_ONCE(task->task_works);
>>>  		if (unlikely(head == &work_exited))
>>>  			return -ESRCH;
>>> +		/*
>>> +		 * TIF_NOTIFY_SIGNAL notifications will interfere with
>>> +		 * a core dump in progress, reject them.
>>> +		 */
>>> +		if ((task->flags & PF_SIGNALED) && notify == TWA_SIGNAL)
>>> +			return -ESRCH;
>>>  		work->next = head;
>>>  	} while (cmpxchg(&task->task_works, head, work) != head);
>>>  
>>>
>> Doesn't compile.  5.10 doesn't have TIF_NOTIFY_SIGNAL.
> Oh right... Here's one hacked up for the 5.10 TWA_SIGNAL setup. Totally
> untested...
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index c6acfc694f65..9e899ce67589 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -603,6 +603,19 @@ void do_coredump(const kernel_siginfo_t *siginfo)
>  		.mm_flags = mm->flags,
>  	};
>  
> +	/*
> +	 * task_work_add() will refuse to add work after PF_SIGNALED has
> +	 * been set, ensure that we flush any pending TWA_SIGNAL work
> +	 * if any was queued before that.
> +	 */
> +	if (signal_pending(current) && (current->jobctl & JOBCTL_TASK_WORK)) {
> +		task_work_run();
> +		spin_lock_irq(&current->sighand->siglock);
> +		current->jobctl &= ~JOBCTL_TASK_WORK;
> +		recalc_sigpending();
> +		spin_unlock_irq(&current->sighand->siglock);
> +	}
> +
>  	audit_core_dumps(siginfo->si_signo);
>  
>  	binfmt = mm->binfmt;
> diff --git a/kernel/task_work.c b/kernel/task_work.c
> index 8d6e1217c451..93b3f262eb4a 100644
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -39,6 +39,12 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
>  		head = READ_ONCE(task->task_works);
>  		if (unlikely(head == &work_exited))
>  			return -ESRCH;
> +		/*
> +		 * TWA_SIGNAL notifications will interfere with
> +		 * a core dump in progress, reject them.
> +		 */
> +		if ((task->flags & PF_SIGNALED) && notify == TWA_SIGNAL)
> +			return -ESRCH;
>  		work->next = head;
>  	} while (cmpxchg(&task->task_works, head, work) != head);
>  
>
Tested with 5.10.59 + backport 06af8679449d + the patch above.  That
fixes it for me.  I tested a couple of variations to make sure.

Thanks!

Tested-by: Tony Battersby <tonyb@cybernetics.com>

