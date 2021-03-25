Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A28349B3D
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 21:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhCYUuV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 16:50:21 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36240 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhCYUuB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 16:50:01 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPWvY-007dw1-5f; Thu, 25 Mar 2021 14:50:00 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPWvX-007lPx-DU; Thu, 25 Mar 2021 14:49:59 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
References: <20210325164343.807498-1-axboe@kernel.dk>
        <m1ft0j3u5k.fsf@fess.ebiederm.org>
        <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
        <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
        <3a1c02a5-db6d-e3e1-6ff5-69dd7cd61258@kernel.dk>
        <m1zgyr2ddh.fsf@fess.ebiederm.org> <20210325204014.GD28349@redhat.com>
Date:   Thu, 25 Mar 2021 15:48:59 -0500
In-Reply-To: <20210325204014.GD28349@redhat.com> (Oleg Nesterov's message of
        "Thu, 25 Mar 2021 21:40:15 +0100")
Message-ID: <m135wj0xj8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lPWvX-007lPx-DU;;;mid=<m135wj0xj8.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+s4dSqXk5VKFAiX0d5kYypYa8oLuycJ/k=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,T_TooManySym_04,XMNoVowels,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
        *  0.0 T_TooManySym_04 7+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 238 ms - load_scoreonly_sql: 0.18 (0.1%),
        signal_user_changed: 12 (4.9%), b_tie_ro: 10 (4.1%), parse: 1.10
        (0.5%), extract_message_metadata: 3.4 (1.4%), get_uri_detail_list:
        0.95 (0.4%), tests_pri_-1000: 4.1 (1.7%), tests_pri_-950: 1.34 (0.6%),
        tests_pri_-900: 0.97 (0.4%), tests_pri_-90: 49 (20.5%), check_bayes:
        47 (20.0%), b_tokenize: 4.8 (2.0%), b_tok_get_all: 6 (2.5%),
        b_comp_prob: 1.83 (0.8%), b_tok_touch_all: 32 (13.6%), b_finish: 0.71
        (0.3%), tests_pri_0: 143 (60.2%), check_dkim_signature: 0.57 (0.2%),
        check_dkim_adsp: 2.7 (1.1%), poll_dns_idle: 1.23 (0.5%), tests_pri_10:
        1.84 (0.8%), tests_pri_500: 13 (5.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 03/25, Eric W. Biederman wrote:
>>
>> So looking quickly the flip side of the coin is gdb (and other
>> debuggers) needs a way to know these threads are special, so it can know
>> not to attach.
>
> may be,
>
>> I suspect getting -EPERM (or possibly a different error code) when
>> attempting attach is the right was to know that a thread is not
>> available to be debugged.
>
> may be.
>
> But I don't think we can blame gdb. The kernel changed the rules, and this
> broke gdb. IOW, I don't agree this is gdb bug.

My point would be it is not strictly a regression either.  It is gdb not
handling new functionality.

If we can be backwards compatible and make ptrace_attach work that is
preferable.  If we can't saying the handful of ptrace using applications
need an upgrade to support processes that use io_uring may be
acceptable.

I don't see any easy to implement path that is guaranteed to work.

Eric



