Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7F147F0CA
	for <lists+io-uring@lfdr.de>; Fri, 24 Dec 2021 20:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353453AbhLXTxB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Dec 2021 14:53:01 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:57062 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239476AbhLXTxA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Dec 2021 14:53:00 -0500
Received: from in01.mta.xmission.com ([166.70.13.51]:58742)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n0qcb-00GdBQ-FX; Fri, 24 Dec 2021 12:52:57 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:46092 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n0qcZ-00BbDq-RV; Fri, 24 Dec 2021 12:52:56 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
        <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
        <87h7i694ij.fsf_-_@disp2133>
        <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
        <b3e43e07c68696b83a5bf25664a3fa912ba747e2.camel@trillion01.com>
        <13250a8d-1a59-4b7b-92e4-1231d73cbdda@gmail.com>
Date:   Fri, 24 Dec 2021 13:52:24 -0600
In-Reply-To: <13250a8d-1a59-4b7b-92e4-1231d73cbdda@gmail.com> (Pavel
        Begunkov's message of "Fri, 24 Dec 2021 10:37:31 +0000")
Message-ID: <878rw9u6fb.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1n0qcZ-00BbDq-RV;;;mid=<878rw9u6fb.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19mPJmblv6WwRKHpEjF0+D8zktreABL94Q=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa01.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.7 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong,XM_B_SpammyWords
        autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4989]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Pavel Begunkov <asml.silence@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 407 ms - load_scoreonly_sql: 0.02 (0.0%),
        signal_user_changed: 4.8 (1.2%), b_tie_ro: 3.3 (0.8%), parse: 1.13
        (0.3%), extract_message_metadata: 11 (2.8%), get_uri_detail_list: 2.7
        (0.7%), tests_pri_-1000: 11 (2.7%), tests_pri_-950: 1.06 (0.3%),
        tests_pri_-900: 0.81 (0.2%), tests_pri_-90: 59 (14.5%), check_bayes:
        58 (14.2%), b_tokenize: 6 (1.5%), b_tok_get_all: 9 (2.1%),
        b_comp_prob: 2.3 (0.6%), b_tok_touch_all: 38 (9.2%), b_finish: 0.77
        (0.2%), tests_pri_0: 306 (75.1%), check_dkim_signature: 0.39 (0.1%),
        check_dkim_adsp: 2.7 (0.7%), poll_dns_idle: 1.31 (0.3%), tests_pri_10:
        2.7 (0.7%), tests_pri_500: 7 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel Begunkov <asml.silence@gmail.com> writes:

> On 12/24/21 01:34, Olivier Langlois wrote:
>> On Fri, 2021-10-22 at 15:13 +0100, Pavel Begunkov wrote:
>>> On 6/9/21 21:17, Eric W. Biederman wrote:
>>> In short, a task creates an io_uring worker thread, then the worker
>>> submits a task_work item to the creator task and won't die until
>>> the item is executed/cancelled. And I found that the creator task is
>>> sleeping in do_coredump() -> wait_for_completion()
>>>
> [...]
>>> A hack executing tws there helps (see diff below).
>>> Any chance anyone knows what this is and how to fix it?
>>>
> [...]
>> Pavel,
>>
>> I cannot comment on the merit of the proposed hack but my proposed
>> patch to fix the coredump truncation issue when a process using
>> io_uring core dumps that I submitted back in August is still
>> unreviewed!
>
> That's unfortunate. Not like I can help in any case, but I assumed
> it was dealt with by
>
> commit 06af8679449d4ed282df13191fc52d5ba28ec536
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Thu Jun 10 15:11:11 2021 -0500
>
>     coredump: Limit what can interrupt coredumps
>       Olivier Langlois has been struggling with coredumps being incompletely
> written in
>     processes using io_uring.
>     ...

I thought it had been too.

>> https://lore.kernel.org/lkml/1625bc89782bf83d9d8c7c63e8ffcb651ccb15fa.1629655338.git.olivier@trillion01.com/
>>
>> I have been using it since then I must have generated many dozens of
>> perfect core dump files with it and I have not seen a single truncated
>> core dump files like I used to have prior to the patch.
>>
>> I am bringing back my patch to your attention because one nice side
>> effect of it is that it would have avoided totally the problem that you
>> have encountered in coredump_wait() since it does cancel io_uring
>> resources before calling coredump_wait()!
>
> FWIW, I worked it around in io_uring back then by breaking the
> dependency.

I am in the middle of untangling the dependencies between ptrace,
coredump, signal handling and maybe a few related things.

Do folks have a reproducer I can look at?  Pavel especially if you have
something that reproduces on the current kernels.

As part of that I am in the process of guaranteeing all of the coredump
work happens in get_signal so nothing of io_uring or any cleanup
anywhere else runs until the coredump completes.

I haven't quite posted the code for review because it's the holidays.
But I am aiming at v5.17 or possibly v5.18, as the code is just about
ready.

Eric
