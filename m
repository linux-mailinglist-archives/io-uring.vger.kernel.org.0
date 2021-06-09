Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7C73A1E48
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 22:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhFIUui (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 16:50:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41652 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhFIUuh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 16:50:37 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lr57x-0047Td-GP; Wed, 09 Jun 2021 14:48:41 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lr57w-00GdK0-Er; Wed, 09 Jun 2021 14:48:41 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov\>" <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
        <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
        <87h7i694ij.fsf_-_@disp2133>
        <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
Date:   Wed, 09 Jun 2021 15:48:33 -0500
In-Reply-To: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
        (Linus Torvalds's message of "Wed, 9 Jun 2021 13:33:36 -0700")
Message-ID: <8735tq9332.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lr57w-00GdK0-Er;;;mid=<8735tq9332.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/dApkXvfoeT8AzOo9n3ZROV6GlGoBin10=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 383 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 4.4 (1.2%), b_tie_ro: 2.9 (0.8%), parse: 1.15
        (0.3%), extract_message_metadata: 14 (3.6%), get_uri_detail_list: 1.98
        (0.5%), tests_pri_-1000: 19 (4.9%), tests_pri_-950: 1.16 (0.3%),
        tests_pri_-900: 0.82 (0.2%), tests_pri_-90: 92 (23.9%), check_bayes:
        90 (23.5%), b_tokenize: 5 (1.3%), b_tok_get_all: 7 (1.8%),
        b_comp_prob: 1.58 (0.4%), b_tok_touch_all: 73 (19.2%), b_finish: 0.78
        (0.2%), tests_pri_0: 238 (62.2%), check_dkim_signature: 0.39 (0.1%),
        check_dkim_adsp: 2.7 (0.7%), poll_dns_idle: 1.25 (0.3%), tests_pri_10:
        2.7 (0.7%), tests_pri_500: 8 (2.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Jun 9, 2021 at 1:17 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>
>> In short the coredump code deliberately supports being interrupted by
>> SIGKILL, and depends upon prepare_signal to filter out all other
>> signals.
>
> Hmm.
>
> I have to say, that looks like the core reason for the bug: if you
> want to be interrupted by a fatal signal, you shouldn't use
> signal_pending(), you should use fatal_signal_pending().
>
> Now, the fact that we haven't cleared TIF_NOTIFY_SIGNAL for the first
> signal is clearly the immediate cause of this, but at the same time I
> really get the feeling that that coredump aborting code should always
> had used fatal_signal_pending().
>
> We do want to be able to abort core-dumps (stuck network filesystems
> is the traditional reason), but the fact that it used signal_pending()
> looks buggy.
>
> In fact, the very comment in that dump_interrupted() function seems to
> acknowledge that signal_pending() is all kinds of silly.
>
> So regardless of the fact that io_uring does seem to have messed up
> this part of signals, I think the fix is not to change
> signal_pending() to task_sigpending(), but to just do what the comment
> suggests we should do.

It looks like it would need to be:

static bool dump_interrupted(void)
{
	return fatal_signal_pending() || freezing();
}

As the original implementation of dump_interrupted 528f827ee0bb
("coredump: introduce dump_interrupted()") is deliberately allowing the
freezer to terminate the core dumps to allow for reliable system
suspend.

>
> But also:
>
>> With the io_uring code comes an extra test in signal_pending
>> for TIF_NOTIFY_SIGNAL (which is something about asking a task to run
>> task_work_run).
>
> Jens, is this still relevant? Maybe we can revert that whole series
> now, and make the confusing difference between signal_pending() and
> task_sigpending() go away again?
>
>                Linus
