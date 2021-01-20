Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCB92FC759
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 03:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbhATCAp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 21:00:45 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41066 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbhATCAk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 21:00:40 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1l22mp-0092wV-9L; Tue, 19 Jan 2021 18:59:55 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1l22mo-00B0pL-8x; Tue, 19 Jan 2021 18:59:54 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Alexey Gladkov <gladkov.alexey@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
        <116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
        <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
        <20210118194551.h2hrwof7b3q5vgoi@example.org>
        <CAHk-=wiNpc5BS2BfZhdDqofJx1G=uasBa2Q1eY4cr8O59Rev2A@mail.gmail.com>
        <20210118205629.zro2qkd3ut42bpyq@example.org>
        <87eeig74kv.fsf@x220.int.ebiederm.org>
Date:   Tue, 19 Jan 2021 19:58:44 -0600
In-Reply-To: <87eeig74kv.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
        message of "Tue, 19 Jan 2021 19:57:36 -0600")
Message-ID: <878s8o74iz.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1l22mo-00B0pL-8x;;;mid=<878s8o74iz.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/T2B95TMqxtikO/3YyPpBrhK2ILrwugMw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.7 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong,
        XM_B_SpammyWords autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4896]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Gladkov <gladkov.alexey@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 484 ms - load_scoreonly_sql: 0.11 (0.0%),
        signal_user_changed: 11 (2.3%), b_tie_ro: 9 (1.9%), parse: 1.06 (0.2%),
         extract_message_metadata: 13 (2.7%), get_uri_detail_list: 1.79 (0.4%),
         tests_pri_-1000: 14 (2.9%), tests_pri_-950: 1.29 (0.3%),
        tests_pri_-900: 1.10 (0.2%), tests_pri_-90: 150 (30.9%), check_bayes:
        148 (30.5%), b_tokenize: 9 (1.8%), b_tok_get_all: 9 (1.9%),
        b_comp_prob: 3.1 (0.6%), b_tok_touch_all: 123 (25.4%), b_finish: 0.92
        (0.2%), tests_pri_0: 281 (58.0%), check_dkim_signature: 0.78 (0.2%),
        check_dkim_adsp: 2.8 (0.6%), poll_dns_idle: 0.75 (0.2%), tests_pri_10:
        2.2 (0.5%), tests_pri_500: 7 (1.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH v3 1/8] Use refcount_t for ucounts reference counting
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Alexey Gladkov <gladkov.alexey@gmail.com> writes:
>
>> On Mon, Jan 18, 2021 at 12:34:29PM -0800, Linus Torvalds wrote:
>>> On Mon, Jan 18, 2021 at 11:46 AM Alexey Gladkov
>>> <gladkov.alexey@gmail.com> wrote:
>>> >
>>> > Sorry about that. I thought that this code is not needed when switching
>>> > from int to refcount_t. I was wrong.
>>> 
>>> Well, you _may_ be right. I personally didn't check how the return
>>> value is used.
>>> 
>>> I only reacted to "it certainly _may_ be used, and there is absolutely
>>> no comment anywhere about why it wouldn't matter".
>>
>> I have not found examples where checked the overflow after calling
>> refcount_inc/refcount_add.
>>
>> For example in kernel/fork.c:2298 :
>>
>>    current->signal->nr_threads++;                           
>>    atomic_inc(&current->signal->live);                      
>>    refcount_inc(&current->signal->sigcnt);  
>>
>> $ semind search signal_struct.sigcnt
>> def include/linux/sched/signal.h:83  		refcount_t		sigcnt;
>> m-- kernel/fork.c:723 put_signal_struct 		if (refcount_dec_and_test(&sig->sigcnt))
>> m-- kernel/fork.c:1571 copy_signal 		refcount_set(&sig->sigcnt, 1);
>> m-- kernel/fork.c:2298 copy_process 				refcount_inc(&current->signal->sigcnt);
>>
>> It seems to me that the only way is to use __refcount_inc and then compare
>> the old value with REFCOUNT_MAX
>>
>> Since I have not seen examples of such checks, I thought that this is
>> acceptable. Sorry once again. I have not tried to hide these changes.
>
> The current ucount code does check for overflow and fails the increment
> in every case.
>
> So arguably it will be a regression and inferior error handling behavior
> if the code switches to the ``better'' refcount_t data structure.
>
> I originally didn't use refcount_t because silently saturating and not
> bothering to handle the error makes me uncomfortable.
>
> Not having to acquire the ucounts_lock every time seems nice.  Perhaps
> the path forward would be to start with stupid/correct code that always
> takes the ucounts_lock for every increment of ucounts->count, that is
> later replaced with something more optimal.
>
> Not impacting performance in the non-namespace cases and having good
> performance in the other cases is a fundamental requirement of merging
> code like this.

So starting with something easy to comprehend and simple, may make it
easier to figure out how to optimize the code.

Eric

