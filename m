Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4802A349AF2
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 21:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhCYUXC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 16:23:02 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:49264 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhCYUWf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 16:22:35 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPWUx-00GDix-Cj; Thu, 25 Mar 2021 14:22:31 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPWUw-00086p-Jg; Thu, 25 Mar 2021 14:22:31 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Stefan Metzmacher <metze@samba.org>
References: <20210325164343.807498-1-axboe@kernel.dk>
        <m1ft0j3u5k.fsf@fess.ebiederm.org>
        <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
        <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
        <3a1c02a5-db6d-e3e1-6ff5-69dd7cd61258@kernel.dk>
Date:   Thu, 25 Mar 2021 15:21:30 -0500
In-Reply-To: <3a1c02a5-db6d-e3e1-6ff5-69dd7cd61258@kernel.dk> (Jens Axboe's
        message of "Thu, 25 Mar 2021 13:46:46 -0600")
Message-ID: <m1zgyr2ddh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lPWUw-00086p-Jg;;;mid=<m1zgyr2ddh.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19McYpu4UMpmJM1/6UzapWqyVIobH1ipzY=
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
        *      [score: 0.4362]
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
X-Spam-Combo: **;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 533 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 12 (2.3%), b_tie_ro: 11 (2.0%), parse: 1.24
        (0.2%), extract_message_metadata: 17 (3.2%), get_uri_detail_list: 1.15
        (0.2%), tests_pri_-1000: 26 (4.9%), tests_pri_-950: 1.27 (0.2%),
        tests_pri_-900: 1.06 (0.2%), tests_pri_-90: 286 (53.6%), check_bayes:
        284 (53.3%), b_tokenize: 5.0 (0.9%), b_tok_get_all: 153 (28.7%),
        b_comp_prob: 2.4 (0.4%), b_tok_touch_all: 120 (22.5%), b_finish: 0.99
        (0.2%), tests_pri_0: 173 (32.5%), check_dkim_signature: 0.56 (0.1%),
        check_dkim_adsp: 2.1 (0.4%), poll_dns_idle: 0.56 (0.1%), tests_pri_10:
        2.3 (0.4%), tests_pri_500: 9 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 3/25/21 1:42 PM, Linus Torvalds wrote:
>> On Thu, Mar 25, 2021 at 12:38 PM Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>>
>>> I don't know what the gdb logic is, but maybe there's some other
>>> option that makes gdb not react to them?
>> 
>> .. maybe we could have a different name for them under the task/
>> subdirectory, for example (not  just the pid)? Although that probably
>> messes up 'ps' too..
>
> Heh, I can try, but my guess is that it would mess up _something_, if
> not ps/top.

Hmm.

So looking quickly the flip side of the coin is gdb (and other
debuggers) needs a way to know these threads are special, so it can know
not to attach.

I suspect getting -EPERM (or possibly a different error code) when
attempting attach is the right was to know that a thread is not
available to be debugged.

Eric

