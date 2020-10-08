Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FE3287579
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 15:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgJHNxe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 09:53:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729823AbgJHNxd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 09:53:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602165212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pk7ZZAadddESqYB+VY4XdoDBtWSd1nh1D4Je1J3dXys=;
        b=akNKYzlzqfxgwsJULHL3AhpWbjYKm+FYTrbhmjk2ieeVpKOcF/dpLTY5/lStWyt7u5WAun
        0H2MzkLGgsVZX+sVlaKHk7f03l7+GiZz7qh3/DoJllHqIZ8F0XWPFYDMr1nzyfswxYtkoL
        agxUwjaOYkOFYQw7aYR0jy66zslg8I0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-ovluvz7vOjC0IwSS9V3JPA-1; Thu, 08 Oct 2020 09:53:30 -0400
X-MC-Unique: ovluvz7vOjC0IwSS9V3JPA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AECDD18C9F42;
        Thu,  8 Oct 2020 13:53:28 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.132])
        by smtp.corp.redhat.com (Postfix) with SMTP id 3F50660BFA;
        Thu,  8 Oct 2020 13:53:27 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  8 Oct 2020 15:53:28 +0200 (CEST)
Date:   Thu, 8 Oct 2020 15:53:26 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 4/6] kernel: add support for TIF_NOTIFY_SIGNAL
Message-ID: <20201008135325.GG9995@redhat.com>
References: <20201005150438.6628-1-axboe@kernel.dk>
 <20201005150438.6628-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005150438.6628-5-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/05, Jens Axboe wrote:
>
>  static inline int signal_pending(struct task_struct *p)
>  {
> +#ifdef TIF_NOTIFY_SIGNAL
> +	/*
> +	 * TIF_NOTIFY_SIGNAL isn't really a signal, but it requires the same
> +	 * behavior in terms of ensuring that we break out of wait loops
> +	 * so that notify signal callbacks can be processed.
> +	 */
> +	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)))
> +		return 1;
> +#endif
>  	return task_sigpending(p);
>  }

perhaps we can add test_tsk_thread_mask() later...

>  static inline void restore_saved_sigmask_unless(bool interrupted)
>  {
> -	if (interrupted)
> +	if (interrupted) {
> +#ifdef TIF_NOTIFY_SIGNAL
> +		WARN_ON(!test_thread_flag(TIF_SIGPENDING) &&
> +			!test_thread_flag(TIF_NOTIFY_SIGNAL));
> +#else
>  		WARN_ON(!test_thread_flag(TIF_SIGPENDING));
> -	else
> +#endif
> +	} else {
>  		restore_saved_sigmask();
> +	}

I'd suggest to simply do

	-	WARN_ON(!test_thread_flag(TIF_SIGPENDING));
	+	WARN_ON(!signal_pending(current);


> --- a/kernel/entry/kvm.c
> +++ b/kernel/entry/kvm.c
> @@ -8,6 +8,9 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
>  	do {
>  		int ret;
>  
> +		if (ti_work & _TIF_NOTIFY_SIGNAL)
> +			tracehook_notify_signal();

Can't really comment this change, but to me it would be more safe to
simply return -EINTR.

Or perhaps even better, treat _TIF_NOTIFY_SIGNAL and _TIF_SIGPENDING
equally:

	-	if (ti_work & _TIF_SIGPENDING) {
	+	if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
			kvm_handle_signal_exit(vcpu);
			return -EINTR;

Oleg.

