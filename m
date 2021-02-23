Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AB7322564
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 06:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhBWFbc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 00:31:32 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56542 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhBWFbb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 00:31:31 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lEQHU-007ZbE-T2; Mon, 22 Feb 2021 22:30:45 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lEQHU-0002ip-7f; Mon, 22 Feb 2021 22:30:44 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Alexey Gladkov <gladkov.alexey@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Alexey Gladkov <legion@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <cover.1613392826.git.gladkov.alexey@gmail.com>
        <CAHk-=wjsmAXyYZs+QQFQtY=w-pOOSWoi-ukvoBVVjBnb+v3q7A@mail.gmail.com>
Date:   Mon, 22 Feb 2021 23:30:26 -0600
In-Reply-To: <CAHk-=wjsmAXyYZs+QQFQtY=w-pOOSWoi-ukvoBVVjBnb+v3q7A@mail.gmail.com>
        (Linus Torvalds's message of "Sun, 21 Feb 2021 14:20:00 -0800")
Message-ID: <m1im6jl5al.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lEQHU-0002ip-7f;;;mid=<m1im6jl5al.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/DYsNs7fzMb4RYxpfKS0P+rI9c6VJVdTw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4991]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 363 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 4.7 (1.3%), b_tie_ro: 3.3 (0.9%), parse: 1.03
        (0.3%), extract_message_metadata: 11 (3.0%), get_uri_detail_list: 1.26
        (0.3%), tests_pri_-1000: 4.5 (1.3%), tests_pri_-950: 1.05 (0.3%),
        tests_pri_-900: 0.91 (0.3%), tests_pri_-90: 124 (34.3%), check_bayes:
        121 (33.4%), b_tokenize: 4.6 (1.3%), b_tok_get_all: 7 (1.8%),
        b_comp_prob: 1.65 (0.5%), b_tok_touch_all: 105 (29.0%), b_finish: 0.78
        (0.2%), tests_pri_0: 203 (55.9%), check_dkim_signature: 0.36 (0.1%),
        check_dkim_adsp: 8 (2.1%), poll_dns_idle: 0.21 (0.1%), tests_pri_10:
        2.6 (0.7%), tests_pri_500: 7 (2.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v6 0/7] Count rlimits in each user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Feb 15, 2021 at 4:42 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>>
>> These patches are for binding the rlimit counters to a user in user namespace.
>
> So this is now version 6, but I think the kernel test robot keeps
> complaining about them causing KASAN issues.
>
> The complaints seem to change, so I'm hoping they get fixed, but it
> does seem like every version there's a new one. Hmm?

I have been keeping an eye on this as well, and yes the issues are
getting fixed.

My current plan is to aim at getting v7 rebased onto -rc1 into a branch.
Review the changes very closely.  Get some performance testing and some
other testing against it.  Then to get this code into linux-next.

If everything goes smoothly I will send you a pull request next merge
window.  I have no intention of shipping this (or sending you a pull
request) before it is ready.

Eric
