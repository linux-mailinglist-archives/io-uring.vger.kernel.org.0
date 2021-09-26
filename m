Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B5D418649
	for <lists+io-uring@lfdr.de>; Sun, 26 Sep 2021 06:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhIZEdg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Sep 2021 00:33:36 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34680 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhIZEdg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 26 Sep 2021 00:33:36 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:42062)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mULpW-008rNV-Sb; Sat, 25 Sep 2021 22:31:58 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:41290 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mULpW-001XuQ-0E; Sat, 25 Sep 2021 22:31:58 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>
References: <fb81a0f6-0a9d-6651-88bc-d22e589de0ee@kernel.dk>
        <CAHk-=whi3UxvY1C1LQNCO9d2xzX5A69qfzNGbBVGpRE_6gv=9Q@mail.gmail.com>
Date:   Sat, 25 Sep 2021 23:31:35 -0500
In-Reply-To: <CAHk-=whi3UxvY1C1LQNCO9d2xzX5A69qfzNGbBVGpRE_6gv=9Q@mail.gmail.com>
        (Linus Torvalds's message of "Sat, 25 Sep 2021 16:05:07 -0700")
Message-ID: <87ee9cdkk8.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mULpW-001XuQ-0E;;;mid=<87ee9cdkk8.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19rQQSvfyHdX0VvDGSye5iX42+aTQ1cp9g=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.1 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,XMSubMetaSxObfu_03,XMSubMetaSx_00 autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4997]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
        *  1.0 XMSubMetaSx_00 1+ Sexy Words
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 336 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 11 (3.2%), b_tie_ro: 9 (2.8%), parse: 0.84 (0.2%),
         extract_message_metadata: 14 (4.3%), get_uri_detail_list: 1.35 (0.4%),
         tests_pri_-1000: 25 (7.4%), tests_pri_-950: 1.20 (0.4%),
        tests_pri_-900: 0.94 (0.3%), tests_pri_-90: 52 (15.5%), check_bayes:
        51 (15.2%), b_tokenize: 6 (1.7%), b_tok_get_all: 7 (2.1%),
        b_comp_prob: 1.99 (0.6%), b_tok_touch_all: 33 (9.9%), b_finish: 0.77
        (0.2%), tests_pri_0: 219 (65.1%), check_dkim_signature: 0.46 (0.1%),
        check_dkim_adsp: 2.9 (0.9%), poll_dns_idle: 1.24 (0.4%), tests_pri_10:
        1.98 (0.6%), tests_pri_500: 7 (2.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [GIT PULL] io_uring fixes for 5.15-rc3
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sat, Sep 25, 2021 at 1:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> - io-wq core dump exit fix (me)
>
> Hmm.
>
> That one strikes me as odd.
>
> I get the feeling that if the io_uring thread needs to have that
> signal_group_exit() test, something is wrong in signal-land.
>
> It's basically a "fatal signal has been sent to another thread", and I
> really get the feeling that "fatal_signal_pending()" should just be
> modified to handle that case too.
>
> Because what about a number of other situations where we have that
> "killable" logic (ie "stop waiting for locks or IO if you're just
> going to get killed anyway" - things like lock_page_killable() and
> friends)
>
> Adding Eric, Oleg and Al to the participants, so that somebody else can pipe up.
>
> That piping up may quite possibly be to just tell me I'm being stupid,
> and that this is just a result of some io_uring thread thing, and
> nobody else has this problem.
>
> It's commit 87c169665578 ("io-wq: ensure we exit if thread group is
> exiting") in my tree.
>
> Comments?

I agree it smells.

It smells that there needs to be a test after get_signal returns with a
signal from an io_uring thread.

As I recall io-wq threads block all signals except for SIGSTOP and
SIGKILL.  The signal SIGSTOP is never returned from get_signal.  So at
a first glance every return from get_signal should be SIGKILL and thus
fatal.

So I don't understand why there needs to be a test at all after
get_signal.

Further the SIGKILL should have been delivered by get_signal so it
should not be pending so I am not certain when fatal_signal_pending.

Can someone please explain commit 15e20db2e0ce ("io-wq: only exit on
fatal signals") to me?

What signals is get_signal returning to be delivered to userspace that
are not fatal and that are ok to ignore?

I think I am missing something.

Eric
