Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D986229038F
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 12:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395539AbgJPKyY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 06:54:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2395537AbgJPKyX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 06:54:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602845662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z9HCeHX+Y5YHXx5lFh8SFKBrNHGin0lf0jgV0vHxv1s=;
        b=J86GaWMX0kXkSTt+LP0pdm1zO5PyUMUSwXeMwwkm2z1v9Dad0hh8hxPs47zTpBLjmaHzqh
        ieNqB9XCCbW79HSw9wPZcnU3W4r5w2aqECOkzpDgbtzsUi3C2xTq/JGryqjYazEPop2OC6
        o6RIGD2JGlw4T3Xj24qxk3ONPX+rdWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-tpYhCG20MMOEkAV_4Slg5g-1; Fri, 16 Oct 2020 06:54:20 -0400
X-MC-Unique: tpYhCG20MMOEkAV_4Slg5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCCF16409B;
        Fri, 16 Oct 2020 10:54:18 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.149])
        by smtp.corp.redhat.com (Postfix) with SMTP id 7F7A21972B;
        Fri, 16 Oct 2020 10:54:17 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri, 16 Oct 2020 12:54:18 +0200 (CEST)
Date:   Fri, 16 Oct 2020 12:54:16 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 4/5] x86: wire up TIF_NOTIFY_SIGNAL
Message-ID: <20201016105415.GA21989@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-5-axboe@kernel.dk>
 <87o8l3a8af.fsf@nanos.tec.linutronix.de>
 <20201015143409.GC24156@redhat.com>
 <87y2k6trzr.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2k6trzr.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16, Thomas Gleixner wrote:
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
> This is about the generic entry code. For the users of that it makes
> absolutely no sense to have that in architecture code.
>
> Something which every architecture needs to do in the exactly same way
> goes into the common code. If not, you can spare the exercise of having
> common code in the first place.
>
> Also arch_do_signal() becomes a misnomer with this new magic.

Well, to me arch_do_signal() paths should handle the signal_pending() == T
case.

But I won't argue, this is subjective.

> static void handle_signal_work(ti_work, regs)
> {
> 	if (ti_work & _TIF_NOTIFY_SIGNAL)
>         	tracehook_notify_signal();
>
>         arch_do_signal_or_restart(ti_work, regs);
> }
>
> which makes it entirely clear what this is about.

In this case I'd prefer to pass the "(ti_work & _TIF_SIGPENDING)" boolen
to arch_do_signal_or_restart().

But again, I won't argue. And to remind, we do not really need to touch
arch_do_signal() at all. We can just add

	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
		tracehook_notify_signal();

	if (!task_sigpending(current))
		return 0;

at the start of get_signal() and avoid the code duplication automatically.

Oleg.

