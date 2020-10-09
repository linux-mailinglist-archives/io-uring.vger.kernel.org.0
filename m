Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E586288BBC
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 16:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388812AbgJIOnh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 10:43:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388799AbgJIOng (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 10:43:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602254615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2YtzdHcUrgnGAZg77pGxmadi1QZznT8bseJbL6oBoTA=;
        b=Bca5jZRU+n3uZsy6/2R9NB+DznscqeO1eKaJ6cmTWQpa3zdTzSaRdALwpn/rCRALyY0DJC
        ttPRZZ4Q9Cn6RQGghwfpdWGV37qj6eR7R4nrmT9newJOALq1QAudb36cMUoJnvp7VOyZ3k
        4ZlH/lxoHgPUJLvxFvtUCC/RRIjiaGk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-oHku6ZAIMKCXoavSg-EiLg-1; Fri, 09 Oct 2020 10:43:33 -0400
X-MC-Unique: oHku6ZAIMKCXoavSg-EiLg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0123D80401F;
        Fri,  9 Oct 2020 14:43:32 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.195.138])
        by smtp.corp.redhat.com (Postfix) with SMTP id 6B3656EF75;
        Fri,  9 Oct 2020 14:43:30 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri,  9 Oct 2020 16:43:31 +0200 (CEST)
Date:   Fri, 9 Oct 2020 16:43:29 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 3/4] kernel: add support for TIF_NOTIFY_SIGNAL
Message-ID: <20201009144328.GB14523@redhat.com>
References: <20201008152752.218889-1-axboe@kernel.dk>
 <20201008152752.218889-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008152752.218889-4-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Once again, I am fine with this patch, just a minor comment...

On 10/08, Jens Axboe wrote:
>
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -808,7 +808,10 @@ void arch_do_signal(struct pt_regs *regs)
>  {
>  	struct ksignal ksig;
>
> -	if (get_signal(&ksig)) {
> +	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
> +		tracehook_notify_signal();
> +
> +	if (task_sigpending(current) && get_signal(&ksig)) {

I suggested to change arch_do_signal() because somehow I like it this way ;)

And because we can easily pass the "ti_work" mask to arch_do_signal() and
avoid test_thread_flag/task_sigpending.

Hmm. I just noticed that only x86 uses arch_do_signal(), so perhaps you can
add this change to this patch right now? Up to you.



On the other hand, we could add

	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
		tracehook_notify_signal();

	if (!task_sigpending(current))
		return 0;

at the start of get_signal() instead. Somehow I don't really like this, but
this way we do need less changes in arch-dependant code. Again, up to you.

Oleg.

