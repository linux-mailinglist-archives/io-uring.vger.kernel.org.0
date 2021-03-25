Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF14349B50
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 21:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhCYU4r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 16:56:47 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:55486 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbhCYU4Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 16:56:24 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPX1j-00GGQT-Ij; Thu, 25 Mar 2021 14:56:23 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPX1h-0003qr-PN; Thu, 25 Mar 2021 14:56:23 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
References: <20210325164343.807498-1-axboe@kernel.dk>
        <m1ft0j3u5k.fsf@fess.ebiederm.org>
        <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
        <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
        <CAHk-=wgUcVeaKhtBgJO3TfE69miJq-krtL8r_Wf_=LBTJw6WSg@mail.gmail.com>
        <20210325204430.GE28349@redhat.com>
Date:   Thu, 25 Mar 2021 15:55:21 -0500
In-Reply-To: <20210325204430.GE28349@redhat.com> (Oleg Nesterov's message of
        "Thu, 25 Mar 2021 21:44:30 +0100")
Message-ID: <m1im5fymva.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lPX1h-0003qr-PN;;;mid=<m1im5fymva.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/JsbrhQ4IeD1xkDz3HU8Jinx2474vuSMo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,T_TooManySym_04,XMNoVowels,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4995]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.0 T_TooManySym_04 7+ unique symbols in subject
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1393 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 10 (0.7%), b_tie_ro: 9 (0.6%), parse: 0.81 (0.1%),
         extract_message_metadata: 2.7 (0.2%), get_uri_detail_list: 0.93
        (0.1%), tests_pri_-1000: 3.5 (0.2%), tests_pri_-950: 1.21 (0.1%),
        tests_pri_-900: 0.99 (0.1%), tests_pri_-90: 170 (12.2%), check_bayes:
        168 (12.1%), b_tokenize: 5 (0.4%), b_tok_get_all: 6 (0.4%),
        b_comp_prob: 1.90 (0.1%), b_tok_touch_all: 151 (10.9%), b_finish: 1.02
        (0.1%), tests_pri_0: 1173 (84.2%), check_dkim_signature: 0.47 (0.0%),
        check_dkim_adsp: 2.4 (0.2%), poll_dns_idle: 0.62 (0.0%), tests_pri_10:
        2.9 (0.2%), tests_pri_500: 20 (1.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 03/25, Linus Torvalds wrote:
>>
>> The whole "signals are very special for IO threads" thing has caused
>> so many problems, that maybe the solution is simply to _not_ make them
>> special?
>
> Or may be IO threads should not abuse CLONE_THREAD?
>
> Why does create_io_thread() abuse CLONE_THREAD ?
>
> One reason (I think) is that this implies SIGKILL when the process exits/execs,
> anything else?

A lot.

The io workers perform work on behave of the ordinary userspace threads.
Some of that work is opening files.  For things like rlimits to work
properly you need to share the signal_struct.  But odds are if you find
anything in signal_struct (not counting signals) there will be an
io_uring code path that can exercise it as io_uring can traverse the
filesystem, open files and read/write files.  So io_uring can exercise
all of proc.

Using create_io_thread with CLONE_THREAD is the least problematic way
(including all of the signal and ptrace problems we are looking at right
now) to implement the io worker threads.

They _really_ are threads of the process that just never execute any
code in userspace.

Eric

