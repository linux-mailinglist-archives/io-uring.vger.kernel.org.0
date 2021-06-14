Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354B43A6BFB
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 18:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbhFNQkE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 12:40:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55700 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234785AbhFNQj5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 12:39:57 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lspb0-00E2ye-8I; Mon, 14 Jun 2021 10:37:54 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lspaz-00Bj3q-9Z; Mon, 14 Jun 2021 10:37:53 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov\>" <asml.silence@gmail.com>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
        <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
        <87eeda7nqe.fsf@disp2133>
        <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
        <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
        <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
        <87y2bh4jg5.fsf@disp2133>
        <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
        <87sg1p4h0g.fsf_-_@disp2133> <20210614141032.GA13677@redhat.com>
Date:   Mon, 14 Jun 2021 11:37:45 -0500
In-Reply-To: <20210614141032.GA13677@redhat.com> (Oleg Nesterov's message of
        "Mon, 14 Jun 2021 16:10:33 +0200")
Message-ID: <87o8c8tnae.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lspaz-00Bj3q-9Z;;;mid=<87o8c8tnae.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/3JGSdnkn820cAjJpiknzinMIfCCMTwAM=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 431 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 4.6 (1.1%), b_tie_ro: 3.1 (0.7%), parse: 1.13
        (0.3%), extract_message_metadata: 4.2 (1.0%), get_uri_detail_list: 2.0
        (0.5%), tests_pri_-1000: 3.1 (0.7%), tests_pri_-950: 1.13 (0.3%),
        tests_pri_-900: 0.90 (0.2%), tests_pri_-90: 148 (34.4%), check_bayes:
        146 (34.0%), b_tokenize: 6 (1.3%), b_tok_get_all: 7 (1.7%),
        b_comp_prob: 1.85 (0.4%), b_tok_touch_all: 129 (29.9%), b_finish: 0.77
        (0.2%), tests_pri_0: 250 (57.9%), check_dkim_signature: 0.38 (0.1%),
        check_dkim_adsp: 2.4 (0.6%), poll_dns_idle: 0.94 (0.2%), tests_pri_10:
        2.9 (0.7%), tests_pri_500: 7 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> Eric, et al, sorry for delay, I didn't read emails several days.
>
> On 06/10, Eric W. Biederman wrote:
>>
>> v2: Don't remove the now unnecessary code in prepare_signal.
>
> No, that code is still needed. Otherwise any fatal signal will be
> turned into SIGKILL.
>
>> --- a/fs/coredump.c
>> +++ b/fs/coredump.c
>> @@ -519,7 +519,7 @@ static bool dump_interrupted(void)
>>  	 * but then we need to teach dump_write() to restart and clear
>>  	 * TIF_SIGPENDING.
>>  	 */
>> -	return signal_pending(current);
>> +	return fatal_signal_pending(current) || freezing(current);
>>  }
>
>
> Well yes, this is what the comment says.
>
> But note that there is another reason why dump_interrupted() returns true
> if signal_pending(), it assumes thagt __dump_emit()->__kernel_write() may
> fail anyway if signal_pending() is true. Say, pipe_write(), or iirc nfs,
> perhaps something else...

The pipe_write case is a good case to consider.  In general filesystems
are only allowed to stop if fatal_signal_pending.  It is an ancient
unix/posix thing.

> That is why zap_threads() clears TIF_SIGPENDING. Perhaps it should clear
> TIF_NOTIFY_SIGNAL as well and we should change io-uring to not abuse the
> dumping threads?

I would very much like some clarity on TIF_NOTIFY_SIGNAL.  At the very
least it would be nice if it could get renamed TIF_NOTIFY_TASK_WORK.
I don't know what it has to do with signals.

> Or perhaps we should change __dump_emit() to clear signal_pending() and
> restart __kernel_write() if it fails or returns a short write.

Given that the code needs to handle pipes that seems a reasonable thing
to do.  Note.  All of the blocking of new signals in prepare_signal
is still in place.  So only a SIGKILL can come in set TIF_SIGPENDING.

So I would say that the current fix is correct (and safe to backport).
But still requires some magic in prepare_signal until we do more.

I don't understand the logic with well enough of adding work to
non-io_uring threads with task_work_add to understand why that happens
in the first place.

There are a lot of silly corners here.  Yes please let's keep on
digging.

Eric

