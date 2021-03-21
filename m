Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC07C343324
	for <lists+io-uring@lfdr.de>; Sun, 21 Mar 2021 16:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhCUPTi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 11:19:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45064 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhCUPTi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 11:19:38 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lNzrb-00GZ5Z-KT; Sun, 21 Mar 2021 09:19:35 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lNzra-00Br8z-LF; Sun, 21 Mar 2021 09:19:35 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, criu@openvz.org
References: <20210320153832.1033687-1-axboe@kernel.dk>
        <m14kh5aj0n.fsf@fess.ebiederm.org>
        <CAHk-=whyL6prwWR0GdgxLZm_w-QWwo7jPw_DkEGYFbMeCdo8YQ@mail.gmail.com>
        <CAHk-=wh3DCgezr5RKQ4Mqffoj-F4i47rp85Q4MSFRNhrr8tg3w@mail.gmail.com>
        <m1im5l5vi5.fsf@fess.ebiederm.org>
        <907b36b6-a022-019a-34ea-58ce46dc2d12@kernel.dk>
Date:   Sun, 21 Mar 2021 10:18:32 -0500
In-Reply-To: <907b36b6-a022-019a-34ea-58ce46dc2d12@kernel.dk> (Jens Axboe's
        message of "Sat, 20 Mar 2021 16:53:06 -0600")
Message-ID: <m135wo5yd3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lNzra-00Br8z-LF;;;mid=<m135wo5yd3.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX191AMJYua9SEZ0DxWiZe5VjyU7pO5yBwVA=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa08.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        XM_B_SpammyWords,XM_Body_Dirty_Words autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4989]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
        *  1.0 XM_Body_Dirty_Words Contains a dirty word
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 443 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 15 (3.4%), b_tie_ro: 13 (3.0%), parse: 1.13
        (0.3%), extract_message_metadata: 20 (4.5%), get_uri_detail_list: 3.0
        (0.7%), tests_pri_-1000: 32 (7.3%), tests_pri_-950: 1.33 (0.3%),
        tests_pri_-900: 1.35 (0.3%), tests_pri_-90: 65 (14.8%), check_bayes:
        63 (14.3%), b_tokenize: 8 (1.9%), b_tok_get_all: 13 (3.0%),
        b_comp_prob: 4.2 (0.9%), b_tok_touch_all: 32 (7.1%), b_finish: 1.37
        (0.3%), tests_pri_0: 293 (66.1%), check_dkim_signature: 0.60 (0.1%),
        check_dkim_adsp: 3.0 (0.7%), poll_dns_idle: 1.37 (0.3%), tests_pri_10:
        2.1 (0.5%), tests_pri_500: 8 (1.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHSET 0/2] PF_IO_WORKER signal tweaks
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 3/20/21 4:08 PM, Eric W. Biederman wrote:
>> 
>> Added criu because I just realized that io_uring (which can open files
>> from an io worker thread) looks to require some special handling for
>> stopping and freezing processes.  If not in the SIGSTOP case in the
>> related cgroup freezer case.
>> 
>> Linus Torvalds <torvalds@linux-foundation.org> writes:
>> 
>>> On Sat, Mar 20, 2021 at 10:51 AM Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>>
>>>> Alternatively, make it not use
>>>> CLONE_SIGHAND|CLONE_THREAD at all, but that would make it
>>>> unnecessarily allocate its own signal state, so that's "cleaner" but
>>>> not great either.
>>>
>>> Thinking some more about that, it would be problematic for things like
>>> the resource counters too. They'd be much better shared.
>>>
>>> Not adding it to the thread list etc might be clever, but feels a bit too scary.
>>>
>>> So on the whole I think Jens' minor patches to just not have IO helper
>>> threads accept signals are probably the right thing to do.
>> 
>> The way I see it we have two options:
>> 
>> 1) Don't ask PF_IO_WORKERs to stop do_signal_stop and in
>>    task_join_group_stop.
>> 
>>    The easiest comprehensive implementation looks like just
>>    updating task_set_jobctl_pending to treat PF_IO_WORKER
>>    as it treats PF_EXITING.
>> 
>> 2) Have the main loop of the kernel thread test for JOBCTL_STOP_PENDING
>>    and call into do_signal_stop.
>> 
>> It is a wee bit trickier to modify the io_workers to stop, but it does
>> not look prohibitively difficult.
>> 
>> All of the work performed by the io worker is work scheduled via
>> io_uring by the process being stopped.
>> 
>> - Is the amount of work performed by the io worker thread sufficiently
>>   negligible that we don't care?
>> 
>> - Or is the amount of work performed by the io worker so great that it
>>   becomes a way for an errant process to escape SIGSTOP?
>> 
>> As the code is all intermingled with the cgroup_freezer.  I am also
>> wondering creating checkpoints needs additional stopping guarantees.
>
> The work done is the same a syscall, basically. So it could be long
> running and essentially not doing anything (eg read from a socket, no
> data is there), or it's pretty short lived (eg read from a file, just
> waiting on DMA).
>
> This is outside of my domain of expertise, which is exactly why I added
> you and Linus to make some calls on what the best approach here would
> be. My two patches obviously go route #1 in terms of STOP. And fwiw,
> I tested this:
>
>> To solve the issue that SIGSTOP is simply broken right now I am totally
>> fine with something like:
>> 
>> diff --git a/kernel/signal.c b/kernel/signal.c
>> index ba4d1ef39a9e..cb9acdfb32fa 100644
>> --- a/kernel/signal.c
>> +++ b/kernel/signal.c
>> @@ -288,7 +288,8 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
>>  			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
>>  	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
>>  
>> -	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
>> +	if (unlikely(fatal_signal_pending(task) ||
>> +		     (task->flags & (PF_EXITING | PF_IO_WORKER))))
>>  		return false;
>>  
>>  	if (mask & JOBCTL_STOP_SIGMASK)
>
> and can confirm it works fine for me with 2/2 reverted and this applied
> instead.
>
>> Which just keeps from creating unstoppable processes today.  I am just
>> not convinced that is what we want as a long term solution.
>
> How about we go with either my 2/2 or yours above to at least ensure we
> don't leave workers looping as schedule() is a nop with sigpending? If
> there's a longer timeline concern that "evading" SIGSTOP is a concern, I
> have absolutely no qualms with making the IO threads participate. But
> since it seems conceptually simple but with potentially lurking minor
> issues, probably not the ideal approach for right now.


Here is the signoff for mine.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Yours misses the joining of group stop during fork.  So we better use
mine.

As far as I can see that fixes the outstanding bugs.

Jens can you make a proper patch out of it and send it to Linus for
-rc4?  I unfortunately have other commitments and this is all I can do
for today.

Eric
