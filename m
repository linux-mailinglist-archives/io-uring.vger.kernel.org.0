Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395213EF516
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 23:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhHQVj5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 17:39:57 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:32900 "EHLO
        mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbhHQVj5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 17:39:57 -0400
X-ASG-Debug-ID: 1629236359-0fb3b00bc411c20001-k4Lu3k
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id Ay0aCx67Gi3c4LJt; Tue, 17 Aug 2021 17:39:19 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
        bh=CwgGQbJnAx7e81R8CCBmcM3i0wXVlb0O/n3+HhzHIIo=;
        h=Content-Language:Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; b=lXI5kzRsraQZKx5
        m/5NRRxeRPuYy/PZPjofZM7qHDKZ7dCnjSFZhsLx/MuHjoYvaunKTJdKvpBI5IpYkn8YOnWRUr8aW
        h7pNB2NcRElMIEyeseUBXZH26eVkucNPIb8oBYnAYpBqeyH72CnMQO6V/rM49zvfZTLSNcJTOl+K5
        Qk=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate Pro SMTP 6.2.14)
  with ESMTPS id 11075885; Tue, 17 Aug 2021 17:39:19 -0400
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
 <87eeda7nqe.fsf@disp2133>
 <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
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
From:   Tony Battersby <tonyb@cybernetics.com>
Message-ID: <3168284a-0b52-7845-07b1-a72bdfed915c@cybernetics.com>
Date:   Tue, 17 Aug 2021 17:39:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <84640f18-79ee-d8e4-5204-41a2c2330ed8@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1629236359
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 1690
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/17/21 5:28 PM, Jens Axboe wrote:
>
> Another approach - don't allow TWA_SIGNAL task_work to get queued if
> PF_SIGNALED has been set on the task. This is similar to how we reject
> task_work_add() on process exit, and the callers must be able to handle
> that already.
>
> Can you test this one on top of your 5.10-stable?
>
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 07afb5ddb1c4..ca7c1ee44ada 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -602,6 +602,14 @@ void do_coredump(const kernel_siginfo_t *siginfo)
>  		.mm_flags = mm->flags,
>  	};
>  
> +	/*
> +	 * task_work_add() will refuse to add work after PF_SIGNALED has
> +	 * been set, ensure that we flush any pending TIF_NOTIFY_SIGNAL work
> +	 * if any was queued before that.
> +	 */
> +	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
> +		tracehook_notify_signal();
> +
>  	audit_core_dumps(siginfo->si_signo);
>  
>  	binfmt = mm->binfmt;
> diff --git a/kernel/task_work.c b/kernel/task_work.c
> index 1698fbe6f0e1..1ab28904adc4 100644
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -41,6 +41,12 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
>  		head = READ_ONCE(task->task_works);
>  		if (unlikely(head == &work_exited))
>  			return -ESRCH;
> +		/*
> +		 * TIF_NOTIFY_SIGNAL notifications will interfere with
> +		 * a core dump in progress, reject them.
> +		 */
> +		if ((task->flags & PF_SIGNALED) && notify == TWA_SIGNAL)
> +			return -ESRCH;
>  		work->next = head;
>  	} while (cmpxchg(&task->task_works, head, work) != head);
>  
>
Doesn't compile.  5.10 doesn't have TIF_NOTIFY_SIGNAL.

Tony Battersby

