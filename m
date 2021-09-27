Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4344199D4
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 19:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhI0RCC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 13:02:02 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:45400 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbhI0RCC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 13:02:02 -0400
Received: from in02.mta.xmission.com ([166.70.13.52]:58068)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mUtzL-00B3CH-DM; Mon, 27 Sep 2021 11:00:23 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:59490 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mUtzK-00F5dO-F2; Mon, 27 Sep 2021 11:00:23 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <8b218623-7ce8-cef0-9f70-2e5aa2aeb70d@kernel.dk>
Date:   Mon, 27 Sep 2021 12:00:16 -0500
In-Reply-To: <8b218623-7ce8-cef0-9f70-2e5aa2aeb70d@kernel.dk> (Jens Axboe's
        message of "Mon, 27 Sep 2021 10:58:03 -0600")
Message-ID: <87r1da6jj3.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mUtzK-00F5dO-F2;;;mid=<87r1da6jj3.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19khlOinl1NzhVjK3KQnwWPuovzEzbI5zc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4781]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 392 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 10 (2.6%), b_tie_ro: 9 (2.3%), parse: 0.80 (0.2%),
         extract_message_metadata: 17 (4.3%), get_uri_detail_list: 1.16 (0.3%),
         tests_pri_-1000: 37 (9.6%), tests_pri_-950: 1.22 (0.3%),
        tests_pri_-900: 0.94 (0.2%), tests_pri_-90: 123 (31.5%), check_bayes:
        121 (30.9%), b_tokenize: 5 (1.3%), b_tok_get_all: 5 (1.4%),
        b_comp_prob: 1.70 (0.4%), b_tok_touch_all: 105 (26.9%), b_finish: 1.22
        (0.3%), tests_pri_0: 179 (45.8%), check_dkim_signature: 0.73 (0.2%),
        check_dkim_adsp: 3.5 (0.9%), poll_dns_idle: 0.89 (0.2%), tests_pri_10:
        4.4 (1.1%), tests_pri_500: 14 (3.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] io-wq: exclusively gate signal based exit on get_signal() return
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> io-wq threads block all signals, except SIGKILL and SIGSTOP. We should not
> need any extra checking of signal_pending or fatal_signal_pending, rely
> exclusively on whether or not get_signal() tells us to exit.
>
> The original debugging of this issue led to the false positive that we
> were exiting on non-fatal signals, but that is not the case. The issue
> was around races with nr_workers accounting.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Fixes: 87c169665578 ("io-wq: ensure we exit if thread group is exiting")
> Fixes: 15e20db2e0ce ("io-wq: only exit on fatal signals")
> Reported-by: Eric W. Biederman <ebiederm@xmission.com>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index c2360cdc403d..5bf8aa81715e 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -584,10 +584,7 @@ static int io_wqe_worker(void *data)
>  
>  			if (!get_signal(&ksig))
>  				continue;
> -			if (fatal_signal_pending(current) ||
> -			    signal_group_exit(current->signal))
> -				break;
> -			continue;
> +			break;
>  		}
>  		last_timeout = !ret;
>  	}
