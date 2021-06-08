Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F56F3A00E0
	for <lists+io-uring@lfdr.de>; Tue,  8 Jun 2021 20:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbhFHSsh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 8 Jun 2021 14:48:37 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51682 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235218AbhFHSqc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Jun 2021 14:46:32 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lqgiL-00Aarv-Er; Tue, 08 Jun 2021 12:44:37 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lqgiJ-00Dp3E-9h; Tue, 08 Jun 2021 12:44:37 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Olivier Langlois <olivier@trillion01.com>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Marco Elver <elver@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
References: <E1lqLo6-00ENqW-TB@mx03.mta.xmission.com>
        <8735ttggm4.fsf@disp2133>
        <9d07e2bb220ba4aa3a407a88cdd5c59f1f8eaf4b.camel@trillion01.com>
Date:   Tue, 08 Jun 2021 13:44:29 -0500
In-Reply-To: <9d07e2bb220ba4aa3a407a88cdd5c59f1f8eaf4b.camel@trillion01.com>
        (Olivier Langlois's message of "Tue, 08 Jun 2021 13:43:54 -0400")
Message-ID: <87a6o0dwmq.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1lqgiJ-00Dp3E-9h;;;mid=<87a6o0dwmq.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18Z1vEayPVPH23Jy8IIIvoSQaDCfRFhn90=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong,XM_B_Unicode
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  0.0 XM_B_Unicode BODY: Testing for specific types of unicode
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Olivier Langlois <olivier@trillion01.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1567 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (0.7%), b_tie_ro: 9 (0.6%), parse: 1.13 (0.1%),
         extract_message_metadata: 15 (1.0%), get_uri_detail_list: 3.8 (0.2%),
        tests_pri_-1000: 11 (0.7%), tests_pri_-950: 1.27 (0.1%),
        tests_pri_-900: 1.04 (0.1%), tests_pri_-90: 123 (7.8%), check_bayes:
        120 (7.6%), b_tokenize: 12 (0.8%), b_tok_get_all: 14 (0.9%),
        b_comp_prob: 7 (0.5%), b_tok_touch_all: 82 (5.2%), b_finish: 0.91
        (0.1%), tests_pri_0: 604 (38.6%), check_dkim_signature: 0.60 (0.0%),
        check_dkim_adsp: 2.6 (0.2%), poll_dns_idle: 785 (50.1%), tests_pri_10:
        2.2 (0.1%), tests_pri_500: 794 (50.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] signal: Set PF_SIGNALED flag for io workers during a group exit
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Olivier Langlois <olivier@trillion01.com> writes:

> On Mon, 2021-06-07 at 22:49 -0500, Eric W. Biederman wrote:
>> We added the check just a little while ago.  I am surprised it shows up
>> in any book.  What is the Bovett & Cesati book?
>
> It is an O'Reilly book named 'Understanding the Linux Kernel'. It is
> quite old (2005) and covers kernel 2.6 but surprisingly it did age very
> well and it is still very useful today.
>
> For instance, the discussed feature about exit_mm() sync mecanism, when
> the book has been published, the struct core_state was not existing and
> its members were straight into mm_struct.
>
> I would think that beside this detail, not much has changed since then
> in the general concepts... 
>> 
>> The flag PF_SIGNALED today is set in exactly one place, and that
>> is in get_signal.  The meaning of PF_SIGNALED is that do_group_exit
>> was called from get_signal.  AKA your task was killed by a signal.
>> 
>> The check in exit_mm() that tests PF_SIGNALED is empirically testing
>> to see if all of the necessary state is saved on the kernel stack.
>> That state is the state accessed by fs/binfmt_elf.c:fill_note_info.
>> 
>> The very good description from the original change can be found in
>> the commit 123cbec460db ("signal: Remove the helper
>> signal_group_exit").
>
> thx for sharing the link. Help to improve my kernel understanding is
> always very appreciated. However, I am clueless about where to look to
> retrieve it:
> $ git show 123cbec460db --
> fatal: bad revision '123cbec460db'
>
> is it supposed to be found in the master branch or this a commit prior
> 2005?

Sigh.  I don't know how that happened.  The commit I posted is something
on my development branch.  That was commit was supposed to be
77f6ab8b7768 ("don't dump the threads that had been already exiting when
zapped.")

>> 
>> For alpha it is has the assembly function do_switch_stack been called
>> before your code path was called in the kernel.
>> 
>> Since io_uring does not have a userspace  I don't know if testing
>> for PF_SIGNALED is at all meaningful to detect values saved on the
>> stack.
>> 
>> I suspect io_uring is simply broken on architectures that need
>> extra state saved on the stack, but I haven't looked yet.
>> 
>> 
>> > So I am not sure if the synchronizatin MUST be applied to io_workers
>> > or not but the proposed patch is making sure that it is applied in
>> > all cases if it is needed.
>> 
>> That patch is definitely wrong.  If anything the check in exit_mm
>> should be updated.
>
> with your explanation, if the only purpose of the synchronization is to
> make sure that the task stack register is pointing on its kernel stack
> to be able to dump its user hardware context, it is not needed for io-
> worker tasks since they never exit the kernel.

Not true.  The registers will be copied into the coredump if PF_SIGNALED
is set.  Similarly if ptrace reads the process's registers.  If those
registers are not at the expected place on the stack then random stack
contents will be copied to userspace resulting in an information leak.

If it was just coredumps I would say clearing PF_SIGNALED or something
equivalent is the way to go.  However since it is also ptrace as well
it looks something io_uring tasks need to handle just to so they are not
a special case.

Just to be technical PF_SIGNALED isn't the synchronization.  The
synchronization is noticing that mm->core_state is set under mmap_lock,
and causing all such tasks to decrement a count.  When the count goes to
zero the coredump is started because it knows all of the tasks that need
to be have stopped and are waiting for their state to be read.

> I think that this is the confirmation that I wanted to get from the
> patch code review because this point wasn't 100% clear to me (and I was
> having issues getting a core dump generated properly when using
> io_uring. I found the culprit of that issue. This isn't the problem
> described in this patch but I thought that the current problem despite
> not being the one responsible for my coredump issue could still have
> some merit).
>
> the doubt was coming from the fact that io-worker tasks are almost
> userspace tasks except that they never escape the kernel and the
> observation that it is the first type of task that could theoritically
> exit from a group_exit without having their PF_SIGNALED bit set.

Which is fine.  The code today considers such tasks as tasks
that have logically exited before the coredump started.

>> Can you share which code paths in io_uring exit with a
>> fatal_signal_pending and don't bother to call get_signal?
>
> Yes. One was provided as part of the description of this patch:
> io_wqe_worker() (fs/io-wq.c)
>
> and
> io_sq_thread() (fs/io_uring.c)
> is another example
>
> and possibly all the other future threads created with
> create_io_thread() will share the same pattern.
>
> They all enter an while loop and contain 1 or many other break points
> beside getting a signal.
>
> imho, it is quite exceptional situation but it could happen that those
> threads exit with a pending signal.
>
> Before 5.13, when io-wq had a second type of io thread (io-mgr), there
> was a real chance of that happening by a race condition between the io-
> mgr setting the wq state bit IO_WQ_BIT_EXIT upon receiving a SIGKILL
> and its io-workers threads exiting their while loop.
>
>
> but with io-mgr removal in 5.13, this risk is now gone...
>
> I have first offered a patch to io_uring to call get_signal() one last
> time before exiting:
> https://lore.kernel.org/io-uring/6b67bd40815f779059f7f3d3ad22f638789452b1.camel@trillion01.com/T/#t
>
> but discussing with Jens made me realize that it wasn't the right place
> to do this because:
> 1. Interrupts aren't disabled and the task can be preemted even after
> this last get_signal() call.
> 2. If that is something needed, it was the bad place to do it because
> you would have to repeat it for all the current existing io_threads and
> the future ones too.
>
> but again, after your explanations, this might not be required at all
> after all...

Eric
