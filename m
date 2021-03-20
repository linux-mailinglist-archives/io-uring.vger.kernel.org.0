Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7554B342E52
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 17:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCTQUK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 12:20:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34810 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhCTQTi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Mar 2021 12:19:38 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lNeK7-00FJur-86; Sat, 20 Mar 2021 10:19:35 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lNeK4-0002L4-Py; Sat, 20 Mar 2021 10:19:34 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        Stefan Metzmacher <metze@samba.org>
References: <20210320153832.1033687-1-axboe@kernel.dk>
        <20210320153832.1033687-2-axboe@kernel.dk>
Date:   Sat, 20 Mar 2021 11:18:29 -0500
In-Reply-To: <20210320153832.1033687-2-axboe@kernel.dk> (Jens Axboe's message
        of "Sat, 20 Mar 2021 09:38:31 -0600")
Message-ID: <m1eeg9bxyi.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lNeK4-0002L4-Py;;;mid=<m1eeg9bxyi.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18CIZY+/GAkzRU0WK1K+zdRzn1Dnv8x+DQ=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa08.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,XMNoVowels,XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4981]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1748 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 14 (0.8%), b_tie_ro: 12 (0.7%), parse: 0.95
        (0.1%), extract_message_metadata: 16 (0.9%), get_uri_detail_list: 1.02
        (0.1%), tests_pri_-1000: 24 (1.4%), tests_pri_-950: 1.30 (0.1%),
        tests_pri_-900: 1.10 (0.1%), tests_pri_-90: 1502 (85.9%), check_bayes:
        1500 (85.8%), b_tokenize: 4.7 (0.3%), b_tok_get_all: 6 (0.4%),
        b_comp_prob: 1.77 (0.1%), b_tok_touch_all: 1482 (84.8%), b_finish:
        1.20 (0.1%), tests_pri_0: 176 (10.1%), check_dkim_signature: 0.48
        (0.0%), check_dkim_adsp: 2.3 (0.1%), poll_dns_idle: 0.81 (0.0%),
        tests_pri_10: 2.3 (0.1%), tests_pri_500: 7 (0.4%), rewrite_mail: 0.00
        (0.0%)
Subject: Re: [PATCH 1/2] signal: don't allow sending any signals to PF_IO_WORKER threads
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> They don't take signals individually, and even if they share signals with
> the parent task, don't allow them to be delivered through the worker
> thread.

This is silly I know, but why do we care?

The creds should be reasonably in-sync with the rest of the threads.

There are other threads that will receive the signal, especially when
you worry about group_send_sig_info.  Which signal sending code paths
are actually a problem.

> Reported-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  kernel/signal.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index ba4d1ef39a9e..730ecd3d6faf 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -833,6 +833,9 @@ static int check_kill_permission(int sig, struct kernel_siginfo *info,
>  
>  	if (!valid_signal(sig))
>  		return -EINVAL;
> +	/* PF_IO_WORKER threads don't take any signals */
> +	if (t->flags & PF_IO_WORKER)
> +		return -EPERM;
>  
>  	if (!si_fromuser(info))
>  		return 0;
