Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E67A28F47D
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388063AbgJOOLX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:11:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38108 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388046AbgJOOLX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:11:23 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602771081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jHGeCEqUZmG9i31fmtOcSWjMjHsE69IPNjR8XX1HdXM=;
        b=0wxTtnry4mHe4O0b1PKyoPle0wbzA3kctap99mXkqVg5VaLNi2Pd2gqaHwYPyMuHJYID1b
        bHTq20CKpuoTolEwIF1fhJCBWnsNJiXZeZyeZvPJmgKkFZj49IhFE6cleg//xVJQazGrwe
        OZQErMXe6dnR6wUxvMBokSFD5MBRIvkfdA26CQpgOjjgY+tgFnpLdqQfIfNrM5sZQ/paw+
        2uFhPhHGTGdZgYq5RBb2/uwCh1I0USdly7UowvMF257NYgkiV6qqfmwJBGHE3MHwjEmmJo
        rftwSMVc6XNnPsFJrcTQynAlZJ8f1Z6h9003VkwLwJw7sARmNIjNCX8plRJMlA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602771081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jHGeCEqUZmG9i31fmtOcSWjMjHsE69IPNjR8XX1HdXM=;
        b=MRTkE0lotfUsMH30PfGTyJxCAOuDNsVjiF61lwK3wk/E+lWFViycaHN4oIrMW0IhZOuzuE
        YOGtG4YtY+PbD1DA==
To:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 4/5] x86: wire up TIF_NOTIFY_SIGNAL
In-Reply-To: <20201015131701.511523-5-axboe@kernel.dk>
References: <20201015131701.511523-1-axboe@kernel.dk> <20201015131701.511523-5-axboe@kernel.dk>
Date:   Thu, 15 Oct 2020 16:11:20 +0200
Message-ID: <87o8l3a8af.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 15 2020 at 07:17, Jens Axboe wrote:
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -808,7 +808,10 @@ void arch_do_signal(struct pt_regs *regs, unsigned long ti_work)
>  {
>  	struct ksignal ksig;
>  
> -	if (get_signal(&ksig)) {
> +	if (ti_work & _TIF_NOTIFY_SIGNAL)
> +		tracehook_notify_signal();
> +
> +	if ((ti_work & _TIF_SIGPENDING) && get_signal(&ksig)) {
>  		/* Whee! Actually deliver the signal.  */
>  		handle_signal(&ksig, regs);
>  		return;

Instead of adding this to every architectures signal magic, we can
handle TIF_NOTIFY_SIGNAL in the core code:

static void handle_singal_work(ti_work, regs)
{
	if (ti_work & _TIF_NOTIFY_SIGNAL)
        	tracehook_notify_signal();

        arch_do_signal(ti_work, regs);
}

      loop {
      		if (ti_work & (SIGPENDING | NOTIFY_SIGNAL))
                	handle_signal_work(ti_work, regs);
      }

Hmm?

Thanks,

        tglx
