Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8206C32F35A
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 20:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhCETA4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 14:00:56 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:36916 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhCETAz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 14:00:55 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lIFgx-00CiFB-SR; Fri, 05 Mar 2021 12:00:52 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lIFgw-004vC7-Kp; Fri, 05 Mar 2021 12:00:51 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org
References: <20210219171010.281878-1-axboe@kernel.dk>
        <20210219171010.281878-10-axboe@kernel.dk>
        <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org>
        <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
Date:   Fri, 05 Mar 2021 13:00:51 -0600
In-Reply-To: <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk> (Jens Axboe's
        message of "Thu, 4 Mar 2021 06:05:31 -0700")
Message-ID: <m1h7lp1l3w.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lIFgw-004vC7-Kp;;;mid=<m1h7lp1l3w.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+2dXJjit4ktSlvoUKLDcVx4NQMdMxkyxA=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMNoVowels,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4996]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 435 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 3.6 (0.8%), b_tie_ro: 2.5 (0.6%), parse: 0.68
        (0.2%), extract_message_metadata: 10 (2.3%), get_uri_detail_list: 1.38
        (0.3%), tests_pri_-1000: 11 (2.6%), tests_pri_-950: 1.01 (0.2%),
        tests_pri_-900: 0.81 (0.2%), tests_pri_-90: 130 (29.8%), check_bayes:
        127 (29.2%), b_tokenize: 6 (1.3%), b_tok_get_all: 8 (1.8%),
        b_comp_prob: 1.65 (0.4%), b_tok_touch_all: 110 (25.2%), b_finish: 0.60
        (0.1%), tests_pri_0: 268 (61.5%), check_dkim_signature: 0.40 (0.1%),
        check_dkim_adsp: 1.93 (0.4%), poll_dns_idle: 0.09 (0.0%),
        tests_pri_10: 1.60 (0.4%), tests_pri_500: 6 (1.4%), rewrite_mail: 0.00
        (0.0%)
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 3/4/21 5:23 AM, Stefan Metzmacher wrote:
>> 
>> Hi Jens,
>> 
>>> +static pid_t fork_thread(int (*fn)(void *), void *arg)
>>> +{
>>> +	unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
>>> +				CLONE_IO|SIGCHLD;
>>> +	struct kernel_clone_args args = {
>>> +		.flags		= ((lower_32_bits(flags) | CLONE_VM |
>>> +				    CLONE_UNTRACED) & ~CSIGNAL),
>>> +		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
>>> +		.stack		= (unsigned long)fn,
>>> +		.stack_size	= (unsigned long)arg,
>>> +	};
>>> +
>>> +	return kernel_clone(&args);
>>> +}
>> 
>> Can you please explain why CLONE_SIGHAND is used here?
>
> We can't have CLONE_THREAD without CLONE_SIGHAND... The io-wq workers
> don't really care about signals, we don't use them internally.
>
>> Will the userspace signal handlers executed from the kernel thread?
>
> No
>
>> Will SIGCHLD be posted to the userspace signal handlers in a userspace
>> process? Will wait() from userspace see the exit of a thread?
>
> Currently actually it does, but I think that's just an oversight. As far
> as I can tell, we want to add something like the below. Untested... I'll
> give this a spin in a bit.

How do you mean?  Where do you see do_notify_parent being called?

It should not happen in exit_notify, as the new threads should
be neither ptraced nor the thread_group_leader.  Nor should
do_notify_parent be called from wait_task_zombie as PF_IO_WORKERS
are not ptraceable.  Nor should do_notify_parent be called
reparent_leader as the PF_IO_WORKER is not the thread_group_leader.
Non-leader threads always autoreap and their exit_state is either 0
or EXIT_DEAD.

Which leaves calling do_notify_parent in release_task which is perfectly
appropriate if the io_worker is the last thread in the thread_group.

I can see modifying eligible_child so __WCLONE will not cause wait to
show the kernel thread.  I don't think wait_task_stopped or
wait_task_continued will register on PF_IO_WORKER thread if it does not
process signals but I just skimmed those two functions when I was
looking.

It definitely looks like it would be worth modifying do_signal_stop so
that the PF_IO_WORKERs are not included.  Or else modifying the
PF_IO_WORKER threads to stop with the rest of the process in that case.

Eric

> diff --git a/kernel/signal.c b/kernel/signal.c
> index ba4d1ef39a9e..e5db1d8f18e5 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1912,6 +1912,10 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
>  	bool autoreap = false;
>  	u64 utime, stime;
>  
> +	/* Don't notify a parent task if an io_uring worker exits */
> +	if (tsk->flags & PF_IO_WORKER)
> +		return true;
> +
>  	BUG_ON(sig == -1);
>  
>   	/* do_notify_parent_cldstop should have been called instead.  */
