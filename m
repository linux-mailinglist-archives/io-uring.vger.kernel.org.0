Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A71E34B0B9
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 21:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhCZUoy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 16:44:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60042 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhCZUop (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 16:44:45 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPtJz-00A5f3-2Z; Fri, 26 Mar 2021 14:44:43 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPtJy-0002C4-6V; Fri, 26 Mar 2021 14:44:42 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326155128.1057078-1-axboe@kernel.dk>
        <20210326155128.1057078-2-axboe@kernel.dk>
Date:   Fri, 26 Mar 2021 15:43:43 -0500
In-Reply-To: <20210326155128.1057078-2-axboe@kernel.dk> (Jens Axboe's message
        of "Fri, 26 Mar 2021 09:51:14 -0600")
Message-ID: <m14kgxy7b4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lPtJy-0002C4-6V;;;mid=<m14kgxy7b4.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/VwxW8Az6YjAF6RN0b0XNHN+rhgD9lWjg=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa01.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,T_TooManySym_04,XMNoVowels,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4994]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_04 7+ unique symbols in subject
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 600 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 3.3 (0.6%), b_tie_ro: 2.4 (0.4%), parse: 0.59
        (0.1%), extract_message_metadata: 7 (1.2%), get_uri_detail_list: 0.92
        (0.2%), tests_pri_-1000: 3.4 (0.6%), tests_pri_-950: 0.91 (0.2%),
        tests_pri_-900: 0.73 (0.1%), tests_pri_-90: 113 (18.9%), check_bayes:
        112 (18.7%), b_tokenize: 4.3 (0.7%), b_tok_get_all: 4.7 (0.8%),
        b_comp_prob: 1.19 (0.2%), b_tok_touch_all: 99 (16.6%), b_finish: 0.61
        (0.1%), tests_pri_0: 187 (31.1%), check_dkim_signature: 0.35 (0.1%),
        check_dkim_adsp: 1.84 (0.3%), poll_dns_idle: 267 (44.5%),
        tests_pri_10: 1.51 (0.3%), tests_pri_500: 280 (46.7%), rewrite_mail:
        0.00 (0.0%)
Subject: Re: [PATCH 1/7] kernel: don't call do_exit() for PF_IO_WORKER threads
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> Right now we're never calling get_signal() from PF_IO_WORKER threads, but
> in preparation for doing so, don't handle a fatal signal for them. The
> workers have state they need to cleanup when exiting, and they don't do
> coredumps, so just return instead of performing either a dump or calling
> do_exit() on their behalf. The threads themselves will detect a fatal
> signal and do proper shutdown.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  kernel/signal.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index f2a1b898da29..e3e1b8fbfe8a 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2756,6 +2756,15 @@ bool get_signal(struct ksignal *ksig)
>  		 */
>  		current->flags |= PF_SIGNALED;
>  
> +		/*
> +		 * PF_IO_WORKER threads will catch and exit on fatal signals
> +		 * themselves. They have cleanup that must be performed, so
> +		 * we cannot call do_exit() on their behalf. coredumps also
> +		 * do not apply to them.
> +		 */
> +		if (current->flags & PF_IO_WORKER)
> +			return false;
> +

Returning false when get_signal needs the caller to handle a signal
adds a very weird and awkward special case to how get_signal returns
arguments.

Instead you should simply break and let get_signal return SIGKILL like
any other signal that has a handler that the caller of get_signal needs
to handle.

Something like:
> +		/*
> +		 * PF_IO_WORKER have cleanup that must be performed,
> +		 * before calling do_exit().
> +		 */
> +		if (current->flags & PF_IO_WORKER)
> +			break;


As do_coredump does not call do_exit there is no reason to skip calling into
the coredump handling either.   And allowing it will remove yet another
special case from the io worker code.

>  		if (sig_kernel_coredump(signr)) {
>  			if (print_fatal_signals)
>  				print_fatal_signal(ksig->info.si_signo);

Eric
