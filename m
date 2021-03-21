Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42344343311
	for <lists+io-uring@lfdr.de>; Sun, 21 Mar 2021 15:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhCUOz0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 10:55:26 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:49836 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhCUOzG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 10:55:06 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lNzTs-007iGy-Fi; Sun, 21 Mar 2021 08:55:04 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lNzTr-00Bp84-2a; Sun, 21 Mar 2021 08:55:04 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Stefan Metzmacher <metze@samba.org>
References: <20210320153832.1033687-1-axboe@kernel.dk>
        <20210320153832.1033687-2-axboe@kernel.dk>
        <m1eeg9bxyi.fsf@fess.ebiederm.org>
        <CAHk-=wjLMy+J20ZSBec4iarw2NeSu5sWXm6wdMH59n-e0Qe06g@mail.gmail.com>
        <m1czvt8q0r.fsf@fess.ebiederm.org>
        <43f05d70-11a9-d59a-1eac-29adc8c53894@kernel.dk>
Date:   Sun, 21 Mar 2021 09:54:00 -0500
In-Reply-To: <43f05d70-11a9-d59a-1eac-29adc8c53894@kernel.dk> (Jens Axboe's
        message of "Sat, 20 Mar 2021 16:42:09 -0600")
Message-ID: <m18s6g5zhz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lNzTr-00Bp84-2a;;;mid=<m18s6g5zhz.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Urg+ixCg8xQilwYhLhejmznGP1MApdtk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,XMNoVowels,XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4994]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 753 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 12 (1.6%), b_tie_ro: 10 (1.4%), parse: 1.12
        (0.1%), extract_message_metadata: 21 (2.8%), get_uri_detail_list: 2.7
        (0.4%), tests_pri_-1000: 15 (2.1%), tests_pri_-950: 1.27 (0.2%),
        tests_pri_-900: 0.99 (0.1%), tests_pri_-90: 127 (16.8%), check_bayes:
        113 (15.0%), b_tokenize: 8 (1.0%), b_tok_get_all: 9 (1.2%),
        b_comp_prob: 2.9 (0.4%), b_tok_touch_all: 90 (12.0%), b_finish: 0.89
        (0.1%), tests_pri_0: 303 (40.2%), check_dkim_signature: 0.52 (0.1%),
        check_dkim_adsp: 2.4 (0.3%), poll_dns_idle: 251 (33.3%), tests_pri_10:
        3.0 (0.4%), tests_pri_500: 266 (35.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/2] signal: don't allow sending any signals to PF_IO_WORKER threads
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 3/20/21 3:38 PM, Eric W. Biederman wrote:
>> Linus Torvalds <torvalds@linux-foundation.org> writes:
>> 
>>> On Sat, Mar 20, 2021 at 9:19 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>
>>>> The creds should be reasonably in-sync with the rest of the threads.
>>>
>>> It's not about credentials (despite the -EPERM).
>>>
>>> It's about the fact that kernel threads cannot handle signals, and
>>> then get caught in endless loops of "if (sigpending()) return
>>> -EAGAIN".
>>>
>>> For a normal user thread, that "return -EAGAIN" (or whatever) will end
>>> up returning an error to user space - and before it does that, it will
>>> go through the "oh, returning to user space, so handle signal" path.
>>> Which will clear sigpending etc.
>>>
>>> A thread that never returns to user space fundamentally cannot handle
>>> this. The sigpending() stays on forever, the signal never gets
>>> handled, the thread can't do anything.
>>>
>>> So delivering a signal to a kernel thread fundamentally cannot work
>>> (although we do have some threads that explicitly see "oh, if I was
>>> killed, I will exit" - think things like in-kernel nfsd etc).
>> 
>> I agree that getting a kernel thread to receive a signal is quite
>> tricky.  But that is not what the patch affects.
>> 
>> The patch covers the case when instead of specifying the pid of the
>> process to kill(2) someone specifies the tid of a thread.  Which implies
>> that type is PIDTYPE_TGID, and in turn the signal is being placed on the
>> t->signal->shared_pending queue.  Not the thread specific t->pending
>> queue.
>> 
>> So my question is since the signal is delivered to the process as a
>> whole why do we care if someone specifies the tid of a kernel thread,
>> rather than the tid of a userspace thread?
>
> Right, that's what this first patch does, and in all honesty, it's not
> required like the 2/2 patch is. I do think it makes it more consistent,
> though - the threads don't take signals, period. Allowing delivery from
> eg kill(2) and then pass it to the owning task of the io_uring is
> somewhat counterintuitive, and differs from earlier kernels where there
> was no relationsship between that owning task and the async worker
> thread.
>
> That's why I think the patch DOES make sense. These threads may share a
> personality with the owning task, but I don't think we should be able to
> manipulate them from userspace at all. That includes SIGSTOP, of course,
> but also regular signals.
>
> Hence I do think we should do something like this.

I agree about signals.  Especially because being able to use kill(2)
with the tid of thread is a linuxism and a backwards compatibility thing
from before we had CLONE_THREAD.

I think for kill(2) we should just return -ESRCH.

Thank you for providing the reasoning that is what I really saw missing
in the patches.  The why.  And software is difficult to maintain without
the why.





Eric



