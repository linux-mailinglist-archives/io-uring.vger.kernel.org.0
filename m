Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4913E349A54
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 20:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhCYTeu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 15:34:50 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52784 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhCYTep (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 15:34:45 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPVki-008Fxh-5l; Thu, 25 Mar 2021 13:34:44 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPVkh-0000za-GY; Thu, 25 Mar 2021 13:34:43 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com, metze@samba.org
References: <20210325164343.807498-1-axboe@kernel.dk>
Date:   Thu, 25 Mar 2021 14:33:43 -0500
In-Reply-To: <20210325164343.807498-1-axboe@kernel.dk> (Jens Axboe's message
        of "Thu, 25 Mar 2021 10:43:41 -0600")
Message-ID: <m1ft0j3u5k.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lPVkh-0000za-GY;;;mid=<m1ft0j3u5k.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18mfvkY8hIovTxtqn4/JaJ6qC3aJXoeS3A=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa08.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,T_TooManySym_04,XMNoVowels,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4945]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_04 7+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 316 ms - load_scoreonly_sql: 0.08 (0.0%),
        signal_user_changed: 16 (5.1%), b_tie_ro: 13 (4.2%), parse: 0.92
        (0.3%), extract_message_metadata: 13 (4.1%), get_uri_detail_list: 1.45
        (0.5%), tests_pri_-1000: 16 (4.9%), tests_pri_-950: 1.32 (0.4%),
        tests_pri_-900: 1.12 (0.4%), tests_pri_-90: 77 (24.3%), check_bayes:
        75 (23.7%), b_tokenize: 5 (1.7%), b_tok_get_all: 8 (2.5%),
        b_comp_prob: 2.6 (0.8%), b_tok_touch_all: 53 (16.9%), b_finish: 1.24
        (0.4%), tests_pri_0: 172 (54.5%), check_dkim_signature: 0.52 (0.2%),
        check_dkim_adsp: 3.0 (0.9%), poll_dns_idle: 1.33 (0.4%), tests_pri_10:
        2.9 (0.9%), tests_pri_500: 12 (3.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> Hi,
>
> Stefan reports that attaching to a task with io_uring will leave gdb
> very confused and just repeatedly attempting to attach to the IO threads,
> even though it receives an -EPERM every time. This patchset proposes to
> skip PF_IO_WORKER threads as same_thread_group(), except for accounting
> purposes which we still desire.
>
> We also skip listing the IO threads in /proc/<pid>/task/ so that gdb
> doesn't think it should stop and attach to them. This makes us consistent
> with earlier kernels, where these async threads were not related to the
> ring owning task, and hence gdb (and others) ignored them anyway.
>
> Seems to me that this is the right approach, but open to comments on if
> others agree with this. Oleg, I did see your messages as well on SIGSTOP,
> and as was discussed with Eric as well, this is something we most
> certainly can revisit. I do think that the visibility of these threads
> is a separate issue. Even with SIGSTOP implemented (which I did try as
> well), we're never going to allow ptrace attach and hence gdb would still
> be broken. Hence I'd rather treat them as separate issues to attack.

A quick skim shows that these threads are not showing up anywhere in
proc which appears to be a problem, as it hides them from top.

Sysadmins need the ability to dig into a system and find out where all
their cpu usage or io's have gone when there is a problem.  I general I
think this argues that these threads should show up as threads of the
process so I am not even certain this is the right fix to deal with gdb.

Eric
