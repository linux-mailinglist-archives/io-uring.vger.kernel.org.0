Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6DB28F5B1
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 17:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389493AbgJOPSF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 11:18:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388086AbgJOPSF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 11:18:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602775083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZmIzkd5uRDI24FvTtgkvnJd3MIzG72UtYvWuNQeQTr0=;
        b=bBPbFS63o5u4w2+q2kY5KV2N5ENwEpZLO96eCa7fv8GTEZCqhMkxSR7fmd74pC2FEsx3Nu
        U+wEfhwqVbO1FRptASg1PoyV5g2AAWDX/6AvL62+rFmKGMJdrMrfWVet4QnFXlEPfT6hK2
        dJb0X1pjEE/J3/fTz9UMnzTHOwGT3dQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-bNInItiKNX-b_VsXjfsoGg-1; Thu, 15 Oct 2020 11:18:01 -0400
X-MC-Unique: bNInItiKNX-b_VsXjfsoGg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D57618BE161;
        Thu, 15 Oct 2020 15:17:59 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.193.8])
        by smtp.corp.redhat.com (Postfix) with SMTP id 31C4D73661;
        Thu, 15 Oct 2020 15:17:57 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 15 Oct 2020 17:17:59 +0200 (CEST)
Date:   Thu, 15 Oct 2020 17:17:56 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 4/5] x86: wire up TIF_NOTIFY_SIGNAL
Message-ID: <20201015151756.GK24156@redhat.com>
References: <20201015143409.GC24156@redhat.com>
 <87v9fbv8te.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9fbv8te.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15, Thomas Gleixner wrote:
>
> On Thu, Oct 15 2020 at 16:34, Oleg Nesterov wrote:
> > On 10/15, Thomas Gleixner wrote:
> >> Instead of adding this to every architectures signal magic, we can
> >> handle TIF_NOTIFY_SIGNAL in the core code:
> >>
> >> static void handle_singal_work(ti_work, regs)
> >> {
> >> 	if (ti_work & _TIF_NOTIFY_SIGNAL)
> >>         	tracehook_notify_signal();
> >>
> >>         arch_do_signal(ti_work, regs);
> >> }
> >>
> >>       loop {
> >>       		if (ti_work & (SIGPENDING | NOTIFY_SIGNAL))
> >>                 	handle_signal_work(ti_work, regs);
> >>       }
> >
> > To me this looks like unnecessary complication. We need to change
> > every architecture anyway, how can this helper help?
>
> You need to change ONE architecture because nobody else uses the common
> entry loop right now.

so we need to change other arches to use the common entry loop.

> For those who move over they have to supply
> arch_do_signal() anyway,

and this arch_do_signal() should be changed to check _TIF_SIGPENDING.



See also my replies to 3/5. I strongly disagree with CONFIG_GENERIC_ENTRY.
But even if we require CONFIG_GENERIC_ENTRY, why do we want this helper?

We can just change exit_to_user_mode_loop() to do

	if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
		if (ti_work & _TIF_NOTIFY_SIGNAL)
			tracehook_notify_signal();
		arch_do_signal(ti_work, regs);
	}

but I'd prefer to handle SIGPENDING/NOTIFY_SIGNAL in one place.

Oleg.

