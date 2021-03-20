Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3828342E54
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 17:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCTQXb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 12:23:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52648 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhCTQW6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Mar 2021 12:22:58 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lNeNL-00GCXC-Ei; Sat, 20 Mar 2021 10:22:55 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lNeNJ-0002he-EZ; Sat, 20 Mar 2021 10:22:55 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        Stefan Metzmacher <metze@samba.org>
References: <20210320153832.1033687-1-axboe@kernel.dk>
        <20210320153832.1033687-3-axboe@kernel.dk>
Date:   Sat, 20 Mar 2021 11:21:50 -0500
In-Reply-To: <20210320153832.1033687-3-axboe@kernel.dk> (Jens Axboe's message
        of "Sat, 20 Mar 2021 09:38:32 -0600")
Message-ID: <m1sg4paj8h.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lNeNJ-0002he-EZ;;;mid=<m1sg4paj8h.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/+h0JpbIOkzwR65kAwE6l72a6ANjW34k0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa08.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,XMNoVowels,XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4970]
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
X-Spam-Timing: total 1411 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 16 (1.1%), b_tie_ro: 14 (1.0%), parse: 0.98
        (0.1%), extract_message_metadata: 16 (1.1%), get_uri_detail_list: 1.35
        (0.1%), tests_pri_-1000: 22 (1.5%), tests_pri_-950: 1.32 (0.1%),
        tests_pri_-900: 1.18 (0.1%), tests_pri_-90: 1181 (83.7%), check_bayes:
        1179 (83.5%), b_tokenize: 4.5 (0.3%), b_tok_get_all: 7 (0.5%),
        b_comp_prob: 2.0 (0.1%), b_tok_touch_all: 1159 (82.1%), b_finish: 1.68
        (0.1%), tests_pri_0: 159 (11.3%), check_dkim_signature: 0.46 (0.0%),
        check_dkim_adsp: 2.9 (0.2%), poll_dns_idle: 1.29 (0.1%), tests_pri_10:
        3.4 (0.2%), tests_pri_500: 7 (0.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/2] signal: don't allow STOP on PF_IO_WORKER threads
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> Just like we don't allow normal signals to IO threads, don't deliver a
> STOP to a task that has PF_IO_WORKER set. The IO threads don't take
> signals in general, and have no means of flushing out a stop either.

At first glance this seems safe.  This is before we count all of the
threads, and it needs to be a non io_uring thread.

Further we can change this decision later if necessary, as this is not
really exposed to userspace.

But please tell me why is it not the right thing to have the io_uring
helper threads stop?  Why is it ok for that process to go on consuming
cpu resources in a non-stoppable way.

Eric


> Reported-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  kernel/signal.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 730ecd3d6faf..b113bf647fb4 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2349,6 +2349,10 @@ static bool do_signal_stop(int signr)
>  
>  		t = current;
>  		while_each_thread(current, t) {
> +			/* don't STOP PF_IO_WORKER threads */
> +			if (t->flags & PF_IO_WORKER)
> +				continue;
> +
>  			/*
>  			 * Setting state to TASK_STOPPED for a group
>  			 * stop is always done with the siglock held,
