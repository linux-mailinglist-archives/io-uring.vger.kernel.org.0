Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79FC3A33D5
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 21:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhFJTUk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 15:20:40 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:41622 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbhFJTUj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 15:20:39 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lrQCQ-00FsdR-8k; Thu, 10 Jun 2021 13:18:42 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lrQCP-001tUZ-2E; Thu, 10 Jun 2021 13:18:41 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov\>" <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
        <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
        <87h7i694ij.fsf_-_@disp2133>
        <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
        <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
        <87eeda7nqe.fsf@disp2133>
        <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
        <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
        <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
Date:   Thu, 10 Jun 2021 14:18:34 -0500
In-Reply-To: <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
        (Linus Torvalds's message of "Thu, 10 Jun 2021 12:10:20 -0700")
Message-ID: <87y2bh4jg5.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lrQCP-001tUZ-2E;;;mid=<87y2bh4jg5.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18xtx8+iTkiW74OBnQynZVJhftRQPbrcys=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.7 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong,XM_B_SpammyWords
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4996]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 600 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (1.9%), b_tie_ro: 10 (1.6%), parse: 1.01
        (0.2%), extract_message_metadata: 17 (2.8%), get_uri_detail_list: 1.62
        (0.3%), tests_pri_-1000: 16 (2.7%), tests_pri_-950: 1.18 (0.2%),
        tests_pri_-900: 1.05 (0.2%), tests_pri_-90: 328 (54.6%), check_bayes:
        318 (53.0%), b_tokenize: 6 (1.1%), b_tok_get_all: 7 (1.1%),
        b_comp_prob: 2.3 (0.4%), b_tok_touch_all: 299 (49.8%), b_finish: 0.95
        (0.2%), tests_pri_0: 214 (35.6%), check_dkim_signature: 0.50 (0.1%),
        check_dkim_adsp: 2.8 (0.5%), poll_dns_idle: 0.99 (0.2%), tests_pri_10:
        2.1 (0.3%), tests_pri_500: 7 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [CFT}[PATCH] coredump: Limit what can interrupt coredumps
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Jun 10, 2021 at 12:01 PM Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> diff --git a/kernel/signal.c b/kernel/signal.c
>> index f7c6ffcbd044..83d534deeb76 100644
>> --- a/kernel/signal.c
>> +++ b/kernel/signal.c
>> @@ -943,8 +943,6 @@ static bool prepare_signal(int sig, struct task_struct *p, bool force)
>>         sigset_t flush;
>>
>>         if (signal->flags & (SIGNAL_GROUP_EXIT | SIGNAL_GROUP_COREDUMP)) {
>> -               if (!(signal->flags & SIGNAL_GROUP_EXIT))
>> -                       return sig == SIGKILL;
>>                 /*
>>                  * The process is in the middle of dying, nothing to do.
>>                  */
>
> I do think this part of the patch is correct, but I'd like to know
> what triggered this change?
>
> It seems fairly harmless - SIGKILL used to be the only signal that was
> passed through in the coredump case, now you pass through all
> non-ignored signals.
>
> But since SIGKILL is the only signal that is relevant for the
> fatal_signal_pending() case, this change seems irrelevant for the
> coredump issue. Any other signals passed through won't matter.
>
> End result: I think removing those two lines is likely a good idea,
> but I also suspect it could/should just be a separate patch with a
> separate explanation for it.
>
> Hmm?

I just didn't want those two lines hiding any other issues we might
have in the coredumps.

That is probably better development thinking than minimal fix thinking.

I am annoyed at the moment that those two lines even exist and figure
they are the confusing root cause of the problem.  That if we had
realized all it would take was to call fatal_signal_pending || freezing
than we could have avoided a problem entirely.

Eric
