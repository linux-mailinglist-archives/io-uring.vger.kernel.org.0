Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E45C342E5C
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 17:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhCTQ1z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 12:27:55 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36330 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhCTQ1i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Mar 2021 12:27:38 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lNeRs-00FKYa-PS; Sat, 20 Mar 2021 10:27:37 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lNeRs-00036F-1S; Sat, 20 Mar 2021 10:27:36 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com
References: <20210320153832.1033687-1-axboe@kernel.dk>
Date:   Sat, 20 Mar 2021 11:26:32 -0500
In-Reply-To: <20210320153832.1033687-1-axboe@kernel.dk> (Jens Axboe's message
        of "Sat, 20 Mar 2021 09:38:30 -0600")
Message-ID: <m14kh5aj0n.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lNeRs-00036F-1S;;;mid=<m14kh5aj0n.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19zror9kzthLCxE3e77LWrSLBp4IIqBOdU=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4872]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 469 ms - load_scoreonly_sql: 0.10 (0.0%),
        signal_user_changed: 12 (2.7%), b_tie_ro: 11 (2.3%), parse: 1.24
        (0.3%), extract_message_metadata: 16 (3.3%), get_uri_detail_list: 2.5
        (0.5%), tests_pri_-1000: 15 (3.2%), tests_pri_-950: 1.33 (0.3%),
        tests_pri_-900: 1.14 (0.2%), tests_pri_-90: 90 (19.1%), check_bayes:
        88 (18.8%), b_tokenize: 9 (1.9%), b_tok_get_all: 9 (2.0%),
        b_comp_prob: 3.1 (0.7%), b_tok_touch_all: 62 (13.2%), b_finish: 1.15
        (0.2%), tests_pri_0: 309 (65.9%), check_dkim_signature: 0.88 (0.2%),
        check_dkim_adsp: 3.5 (0.8%), poll_dns_idle: 1.07 (0.2%), tests_pri_10:
        4.1 (0.9%), tests_pri_500: 16 (3.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHSET 0/2] PF_IO_WORKER signal tweaks
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> Hi,
>
> Been trying to ensure that we do the right thing wrt signals and
> PF_IO_WORKER threads, and I think there are two cases we need to handle
> explicitly:
>
> 1) Just don't allow signals to them in general. We do mask everything
>    as blocked, outside of SIGKILL, so things like wants_signal() will
>    never return true for them. But it's still possible to send them a
>    signal via (ultimately) group_send_sig_info(). This will then deliver
>    the signal to the original io_uring owning task, and that seems a bit
>    unexpected. So just don't allow them in general.
>
> 2) STOP is done a bit differently, and we should not allow that either.
>
> Outside of that, I've been looking at same_thread_group(). This will
> currently return true for an io_uring task and it's IO workers, since
> they do share ->signal. From looking at the kernel users of this, that
> actually seems OK for the cases I checked. One is accounting related,
> which we obviously want, and others are related to permissions between
> tasks. FWIW, I ran with the below and didn't observe any ill effects,
> but I'd like someone to actually think about and verify that PF_IO_WORKER
> same_thread_group() usage is sane.

They are helper threads running in kernel space.  Allowing the ordinary
threads not to block.  Why would same_thread_group be a problem?

I don't hate this set of patches.   But I also don't see much
explanation why the changes are the right thing semantically.

That makes me uneasy.  Because especially the SIGSTOP changes feels like
it is the wrong thing semantically.  The group_send_sig_info change
simply feels like it is unnecessary.

Like we are maybe playing whak-a-mole with symptoms rather than make
certain these are the right fixes for the symptoms.

Eric

> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index 3f6a0fcaa10c..a580bc0f8aa3 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -667,10 +667,17 @@ static inline bool thread_group_leader(struct task_struct *p)
>  	return p->exit_signal >= 0;
>  }
>  
> +static inline
> +bool same_thread_group_account(struct task_struct *p1, struct task_struct *p2)
> +{
> +	return p1->signal == p2->signal
> +}
> +
>  static inline
>  bool same_thread_group(struct task_struct *p1, struct task_struct *p2)
>  {
> -	return p1->signal == p2->signal;
> +	return same_thread_group_account(p1, p2) &&
> +			!((p1->flags | p2->flags) & PF_IO_WORKER);
>  }
>  
>  static inline struct task_struct *next_thread(const struct task_struct *p)
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 5f611658eeab..625110cacc2a 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -307,7 +307,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
>  	 * those pending times and rely only on values updated on tick or
>  	 * other scheduler action.
>  	 */
> -	if (same_thread_group(current, tsk))
> +	if (same_thread_group_account(current, tsk))
>  		(void) task_sched_runtime(current);
>  
>  	rcu_read_lock();
