Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DCA34B0BE
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 21:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhCZUp6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 16:45:58 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:57778 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhCZUpb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 16:45:31 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPtKk-000Pbs-Mm; Fri, 26 Mar 2021 14:45:30 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPtKj-00B9Pu-LG; Fri, 26 Mar 2021 14:45:30 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326155128.1057078-1-axboe@kernel.dk>
        <20210326155128.1057078-5-axboe@kernel.dk>
Date:   Fri, 26 Mar 2021 15:44:30 -0500
In-Reply-To: <20210326155128.1057078-5-axboe@kernel.dk> (Jens Axboe's message
        of "Fri, 26 Mar 2021 09:51:17 -0600")
Message-ID: <m1y2e9wspd.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lPtKj-00B9Pu-LG;;;mid=<m1y2e9wspd.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+pZfoEW05NiGjUuq71rJ/mKC4+c30eHWI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,T_XMDrugObfuBody_14,XMNoVowels,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
        *  0.2 T_XMDrugObfuBody_14 obfuscated drug references
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 404 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 3.5 (0.9%), b_tie_ro: 2.3 (0.6%), parse: 0.96
        (0.2%), extract_message_metadata: 16 (3.9%), get_uri_detail_list: 1.64
        (0.4%), tests_pri_-1000: 29 (7.3%), tests_pri_-950: 1.37 (0.3%),
        tests_pri_-900: 1.15 (0.3%), tests_pri_-90: 155 (38.5%), check_bayes:
        154 (38.1%), b_tokenize: 8 (2.0%), b_tok_get_all: 6 (1.5%),
        b_comp_prob: 2.1 (0.5%), b_tok_touch_all: 135 (33.5%), b_finish: 0.62
        (0.2%), tests_pri_0: 185 (45.7%), check_dkim_signature: 0.38 (0.1%),
        check_dkim_adsp: 2.1 (0.5%), poll_dns_idle: 0.69 (0.2%), tests_pri_10:
        1.71 (0.4%), tests_pri_500: 7 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 3/7] kernel: stop masking signals in create_io_thread()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> This is racy - move the blocking into when the task is created and
> we're marking it as PF_IO_WORKER anyway. The IO threads are now
> prepared to handle signals like SIGSTOP as well, so clear that from
> the mask to allow proper stopping of IO threads.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  kernel/fork.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index d3171e8e88e5..ddaa15227071 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1940,8 +1940,14 @@ static __latent_entropy struct task_struct *copy_process(
>  	p = dup_task_struct(current, node);
>  	if (!p)
>  		goto fork_out;
> -	if (args->io_thread)
> +	if (args->io_thread) {
> +		/*
> +		 * Mark us an IO worker, and block any signal that isn't
> +		 * fatal or STOP
> +		 */
>  		p->flags |= PF_IO_WORKER;
> +		siginitsetinv(&p->blocked, sigmask(SIGKILL)|sigmask(SIGSTOP));
> +	}
>  
>  	/*
>  	 * This _must_ happen before we call free_task(), i.e. before we jump
> @@ -2430,14 +2436,8 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
>  		.stack_size	= (unsigned long)arg,
>  		.io_thread	= 1,
>  	};
> -	struct task_struct *tsk;
>  
> -	tsk = copy_process(NULL, 0, node, &args);
> -	if (!IS_ERR(tsk)) {
> -		sigfillset(&tsk->blocked);
> -		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL));
> -	}
> -	return tsk;
> +	return copy_process(NULL, 0, node, &args);
>  }
>  
>  /*
