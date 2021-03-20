Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC3D342FB1
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 22:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhCTVjx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 17:39:53 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59372 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhCTVjU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Mar 2021 17:39:20 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lNjJV-00GTxI-D8; Sat, 20 Mar 2021 15:39:17 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lNjJU-0003bJ-Nq; Sat, 20 Mar 2021 15:39:17 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Stefan Metzmacher <metze@samba.org>
References: <20210320153832.1033687-1-axboe@kernel.dk>
        <20210320153832.1033687-2-axboe@kernel.dk>
        <m1eeg9bxyi.fsf@fess.ebiederm.org>
        <CAHk-=wjLMy+J20ZSBec4iarw2NeSu5sWXm6wdMH59n-e0Qe06g@mail.gmail.com>
Date:   Sat, 20 Mar 2021 16:38:12 -0500
In-Reply-To: <CAHk-=wjLMy+J20ZSBec4iarw2NeSu5sWXm6wdMH59n-e0Qe06g@mail.gmail.com>
        (Linus Torvalds's message of "Sat, 20 Mar 2021 10:56:36 -0700")
Message-ID: <m1czvt8q0r.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lNjJU-0003bJ-Nq;;;mid=<m1czvt8q0r.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/AWshnne4DuXHRMb8VAzfaz8DFr1tOQqI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,XMNoVowels,XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 382 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 10 (2.5%), b_tie_ro: 8 (2.1%), parse: 0.79 (0.2%),
         extract_message_metadata: 15 (3.9%), get_uri_detail_list: 1.37 (0.4%),
         tests_pri_-1000: 32 (8.5%), tests_pri_-950: 1.66 (0.4%),
        tests_pri_-900: 1.22 (0.3%), tests_pri_-90: 75 (19.7%), check_bayes:
        73 (19.1%), b_tokenize: 7 (1.8%), b_tok_get_all: 7 (1.8%),
        b_comp_prob: 2.4 (0.6%), b_tok_touch_all: 53 (13.8%), b_finish: 1.28
        (0.3%), tests_pri_0: 228 (59.7%), check_dkim_signature: 0.86 (0.2%),
        check_dkim_adsp: 2.3 (0.6%), poll_dns_idle: 0.71 (0.2%), tests_pri_10:
        2.3 (0.6%), tests_pri_500: 13 (3.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/2] signal: don't allow sending any signals to PF_IO_WORKER threads
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sat, Mar 20, 2021 at 9:19 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> The creds should be reasonably in-sync with the rest of the threads.
>
> It's not about credentials (despite the -EPERM).
>
> It's about the fact that kernel threads cannot handle signals, and
> then get caught in endless loops of "if (sigpending()) return
> -EAGAIN".
>
> For a normal user thread, that "return -EAGAIN" (or whatever) will end
> up returning an error to user space - and before it does that, it will
> go through the "oh, returning to user space, so handle signal" path.
> Which will clear sigpending etc.
>
> A thread that never returns to user space fundamentally cannot handle
> this. The sigpending() stays on forever, the signal never gets
> handled, the thread can't do anything.
>
> So delivering a signal to a kernel thread fundamentally cannot work
> (although we do have some threads that explicitly see "oh, if I was
> killed, I will exit" - think things like in-kernel nfsd etc).

I agree that getting a kernel thread to receive a signal is quite
tricky.  But that is not what the patch affects.

The patch covers the case when instead of specifying the pid of the
process to kill(2) someone specifies the tid of a thread.  Which implies
that type is PIDTYPE_TGID, and in turn the signal is being placed on the
t->signal->shared_pending queue.  Not the thread specific t->pending
queue.

So my question is since the signal is delivered to the process as a
whole why do we care if someone specifies the tid of a kernel thread,
rather than the tid of a userspace thread?

Eric
