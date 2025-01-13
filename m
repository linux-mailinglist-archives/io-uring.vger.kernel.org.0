Return-Path: <io-uring+bounces-5841-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2702CA0B8CF
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 14:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40589163855
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 13:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B172C22F171;
	Mon, 13 Jan 2025 13:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u9qwcy7l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8B222A4F7
	for <io-uring@vger.kernel.org>; Mon, 13 Jan 2025 13:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736776475; cv=none; b=kpQf0eQFqPIBBjQHoIan291V3TtDiUmsUGroksKH+ELvFMHQat4LUbEtrHbQ0xJV1b2i81DzizA9jaTkRg4VPZCEAL4cLjVP1p9H7Z/1qASVwlvR1OxteNDfYAk2wUJQvjA7LRiBiNqoQ9NIQ7oCm1YhV67ZY/or33xle7we9ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736776475; c=relaxed/simple;
	bh=HHFv1l0aM5txuojCi6xCb8QcOtSAtrcdSm9XHQLM2OE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ELZpRoodaXuOX7wdCfGrtVw2U1AgFR5d7togsW6KzIeEvKc6zAFK6EKCAko5t77fFDpOQBJvsKh/nMT9XKACnmQJYzjA71Uc5T89cuI1c3dW/NgSJ+py9W48pI76bK+liPpj6YKEkQGRkclBq+wbx7SfCxrB77pJOmBBNuNQnbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u9qwcy7l; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d442f9d285so7142a12.1
        for <io-uring@vger.kernel.org>; Mon, 13 Jan 2025 05:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736776472; x=1737381272; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HHFv1l0aM5txuojCi6xCb8QcOtSAtrcdSm9XHQLM2OE=;
        b=u9qwcy7lqLzwkfsSMHe1pq5jpLpWci4feR6xfydnd0Yt90+LIX+7ZMQ8aeTXRAgerY
         T730wIDRfXzGUzrVGEBYrKtfbYWTfxD4N6/2qNzI5Vu03h9GdGvZGt+5C+di1Aus3tMK
         F4WIiKhcEb+OBLzGKnBbJaihqjuFdcXycz6CcX88OWWVCziX6U9wKZwBo64WAmDxf6fg
         gHmVVeHf0Ue+BxRY0s/KDpoXWPdxuJ7G/iaaeQpUMLr5Hgv6z6tTP0IjKgwCTX9OqbHE
         PUHbw9sA+WdEDFl7ejI9wpoFx95Kl4p8s7G5jESRgVterrBExknTAZw7fI9ItjT5Z+pS
         oo0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736776472; x=1737381272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HHFv1l0aM5txuojCi6xCb8QcOtSAtrcdSm9XHQLM2OE=;
        b=QSoIN+mkaUDV84+dS42la0akyJa5xnE8tNMbATXkoQRfYmsaw6E2XD16gC0gFl8Vqo
         c/JKOLH4Gh78p1mnityMRW3lE8T10bx7U8FexGY1sV5Ruzih4pPIjjVT/5q5Msa+wrH5
         cOb1/cC2/5FI33Y5MAOP6COU7D8X9XiIj87h6udUCrMkAoH4VeVaQOcsRpBOLupKpAMI
         lvwQ+0BQOIFu6UyqoUMhqzj12J0h4aZ4dpijWp39OGLuEX9z2A2F+vWq+jopcXkybAB3
         BTif2hDY+kRwrul4qY9V1Lu9jJk/uPPXXfNIYTVXbIqQhmFOhP+bBLBGuVuhM+F3FR/T
         dEWA==
X-Forwarded-Encrypted: i=1; AJvYcCXt1Q4zmzs+CAvw1gnK2KZZJAcBkfickhykCULsC6q4Y3GnplpTv/J9XnHKGxzqwKsYUasXX5hvdw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwO6beIGCNrIRPn4Uo+XwruCreNegL69+bZCj9Ja/j8HYgDYzYo
	QCqzVF5LToctMUNYIeuYEO0GFESCt8TgWm/xBXJTJIGT/ulHWKEp8SpdwbcFOPelGZwC8s2ExtD
	LNrKSEimkXDDQuibCYs+AN1uSHBXBsyg+hoZA
X-Gm-Gg: ASbGncv6bwsD8u9wRRoWycf8p9pBvV39k5pFiXyAiTuxTBLTYiGsbNs9yd97HQ7c1Lg
	GVXRQjqnc3+jXbGsQDT6AUZ3bc20GG7daE8kGuXQ/9jhOvfqOBTUuRz29+lAC4FPBnQ==
X-Google-Smtp-Source: AGHT+IGCM2kpVYYFRV+8Jb7VUqetJ2zVEp16/VePYGAYZciOjWdpczz6Gl9OmBGGarVVsuxMIKWIBR0O9xTtOMocztE=
X-Received: by 2002:aa7:d7c6:0:b0:5d0:b501:fc77 with SMTP id
 4fb4d7f45d1cf-5d9a0ce2279mr290222a12.5.1736776471657; Mon, 13 Jan 2025
 05:54:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG48ez2HHU+vSCcurs5TsFXiEfUhLSXbEzcugBSTBZgBWkzpuA@mail.gmail.com>
 <3b78348b-a804-4072-b088-9519353edb10@kernel.dk>
In-Reply-To: <3b78348b-a804-4072-b088-9519353edb10@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Mon, 13 Jan 2025 14:53:55 +0100
X-Gm-Features: AbW1kvZuL3BZloukDQgsPemxHDOIk_YX66yS7VSHvXrfXBZ8Ja_ODL80cTzngyU
Message-ID: <CAG48ez1fudwoZgV2BntgrQCnbSU8EWXZkGBB0ALpTY+59wWwQw@mail.gmail.com>
Subject: Re: futex+io_uring: futex_q::task can maybe be dangling (but is not
 actually accessed, so it's fine)
To: Jens Axboe <axboe@kernel.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	kernel list <linux-kernel@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 11, 2025 at 4:33=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/10/25 3:26 PM, Jann Horn wrote:
> > Hi!
> >
> > I think there is some brittle interaction between futex and io_uring;
> > but to be clear, I don't think that there is actually a bug here.
> >
> > In io_uring, when a IORING_OP_FUTEX_WAIT SQE is submitted with
> > IOSQE_ASYNC, an io_uring worker thread can queue up futex waiters via
> > the following path:
> >
> > ret_from_fork -> io_wq_worker -> io_worker_handle_work ->
> > io_wq_submit_work[called as ->do_work] -> io_issue_sqe ->
> > io_futex_wait[called as .issue] -> futex_queue -> __futex_queue
> >
> > futex_q instances normally describe synchronously waiting tasks, and
> > __futex_queue() records the identity of the calling task (which is
> > normally the waiter) in futex_q::task. But io_uring waits on futexes
> > asynchronously instead; from io_uring's perspective, a pending futex
> > wait is not tied to the task that called into futex_queue(), it is
> > just tied to the userspace task on behalf of which the io_uring worker
> > is acting (I think). So when a futex wait operation is started by an
> > io_uring worker task, I think that worker task could go away while the
> > futex_q is still queued up on the futex, and so I think we can end up
> > with a futex_q whose "task" member points to a freed task_struct.
> >
> > The good part is that (from what I understand) that "task" member is
> > only used for two purposes:
> >
> > 1. futexes that are either created through the normal futex syscalls
> > use futex_wake_mark as their .wake callback, which needs the task
> > pointer to know which task should be woken.
> > 2. PI futexes use it for priority inheritance magic (and AFAICS there
> > is no way for io_uring to interface with PI futexes)
> >
> > I'm not sure what is the best thing to do is here - maybe the current
> > situation is fine, and I should just send a patch that adds a comment
> > describing this to the definition of the "task" member? Or maybe it
> > would be better for robustness to ensure that the "task" member is
> > NULLed out in those cases, though that would probably make the
> > generated machine code a little bit more ugly? (Or maybe I totally
> > misunderstand what's going on and there isn't actually a dangling
> > pointer...)
>
> Good find. And yes the io-wq task could go away, if there's more of
> them.
>
> While it isn't an issue, dangling pointers make me nervous. We could do
> something like the (totally untested) below patch, where io_uring just
> uses __futex_queue() and make __futex_queue() take a task_struct as
> well. Other callers pass in 'current'.
>
> It's quite possible that it'd be safe to just use __futex_queue() and
> clear ->task after the queue, but if we pass in NULL from the get-go,
> then there's definitely not a risk of anything being dangling.

Yeah, this looks like a nice cleanup that makes this safer, thanks!

