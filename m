Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512C034B02D
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 21:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhCZUas (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 16:30:48 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57498 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhCZUar (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 16:30:47 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPt6M-00A4fH-HK; Fri, 26 Mar 2021 14:30:39 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPt6J-00B7ep-ME; Fri, 26 Mar 2021 14:30:38 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326155128.1057078-1-axboe@kernel.dk>
        <20210326155128.1057078-3-axboe@kernel.dk>
Date:   Fri, 26 Mar 2021 15:29:36 -0500
In-Reply-To: <20210326155128.1057078-3-axboe@kernel.dk> (Jens Axboe's message
        of "Fri, 26 Mar 2021 09:51:15 -0600")
Message-ID: <m1wntty7yn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lPt6J-00B7ep-ME;;;mid=<m1wntty7yn.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19vqmGiyer57AEM9hR7ONnpmC199gaFPKM=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa05.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMNoVowels,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4997]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 2329 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 9 (0.4%), b_tie_ro: 7 (0.3%), parse: 0.83 (0.0%),
        extract_message_metadata: 11 (0.5%), get_uri_detail_list: 1.15 (0.0%),
        tests_pri_-1000: 4.5 (0.2%), tests_pri_-950: 1.21 (0.1%),
        tests_pri_-900: 0.93 (0.0%), tests_pri_-90: 253 (10.9%), check_bayes:
        251 (10.8%), b_tokenize: 6 (0.3%), b_tok_get_all: 147 (6.3%),
        b_comp_prob: 3.7 (0.2%), b_tok_touch_all: 91 (3.9%), b_finish: 1.32
        (0.1%), tests_pri_0: 2037 (87.4%), check_dkim_signature: 0.72 (0.0%),
        check_dkim_adsp: 4.6 (0.2%), poll_dns_idle: 0.26 (0.0%), tests_pri_10:
        2.1 (0.1%), tests_pri_500: 7 (0.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/7] io_uring: handle signals for IO threads like a normal thread
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> We go through various hoops to disallow signals for the IO threads, but
> there's really no reason why we cannot just allow them. The IO threads
> never return to userspace like a normal thread, and hence don't go through
> normal signal processing. Instead, just check for a pending signal as part
> of the work loop, and call get_signal() to handle it for us if anything
> is pending.
>
> With that, we can support receiving signals, including special ones like
> SIGSTOP.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io-wq.c    | 24 +++++++++++++++++-------
>  fs/io_uring.c | 12 ++++++++----
>  2 files changed, 25 insertions(+), 11 deletions(-)
>
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index b7c1fa932cb3..3e2f059a1737 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -16,7 +16,6 @@
>  #include <linux/rculist_nulls.h>
>  #include <linux/cpu.h>
>  #include <linux/tracehook.h>
> -#include <linux/freezer.h>
>  
>  #include "../kernel/sched/sched.h"
>  #include "io-wq.h"
> @@ -503,10 +502,16 @@ static int io_wqe_worker(void *data)
>  		if (io_flush_signals())
>  			continue;
>  		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
> -		if (try_to_freeze() || ret)
> +		if (signal_pending(current)) {
> +			struct ksignal ksig;
> +
> +			if (fatal_signal_pending(current))
> +				break;
> +			if (get_signal(&ksig))
> +				continue;
                        ^^^^^^^^^^^^^^^^^^^^^^

That is wrong.  You are promising to deliver a signal to signal
handler and them simply discarding it.  Perhaps:

			if (!get_signal(&ksig))
                        	continue;
			WARN_ON(!sig_kernel_stop(ksig->sig));
                        break;


Eric
