Return-Path: <io-uring+bounces-12598-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gJEdJrDwrmkWKQIAu9opvQ
	(envelope-from <io-uring+bounces-12598-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 17:09:20 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 105E523C790
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 17:09:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7AF94303F571
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 16:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0183BFE2A;
	Mon,  9 Mar 2026 16:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8I2Pte2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2784263C8C
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 16:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773072305; cv=none; b=DisP6E4yYXk9q7Vh3e1wOwpfAycsfu4rmh9BocYEcI3LXa3ea/cy5z538c1MA/+xnKiGxK2Irro6oCdHf/6GP8YTNqsO+DLXLLHdtj1ePFMVA6lilBdf4nKelYD5PV/ntOgDYCd9KNmY3Alj44y1PooQgmdW9JLG0CfCd31OQVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773072305; c=relaxed/simple;
	bh=oezbWe1Mwmj/U6y8xX56mH6bGdQMZMxQ/PwcZg0DHsM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TINr8bNTQ1ktKlcg9H2NFDUIjHm9Xm8p5zvAn3sLd6KV77bA4+xzO8Kbh8VNumsoIn9Ribcfr6msrZSKiElObcpYjh5cCx++95n0kqmeao+JozsMtbVFTXJ0dK3pRDkQHHGjY58lASYW+gBSBtSrUktgXX4xHB2Q/dnhbePwIdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8I2Pte2; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6611e4aefdcso8736709a12.3
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 09:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1773072302; x=1773677102; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3pK89JpHY7IheX5DoQRfoN3JFln9h2sA0qQyaAmpA60=;
        b=F8I2Pte2q4YJzqORE0PsURaaj26rqn2Fx0W5ux/cTTRw0Nk2SiGlhMZuAUF9gkaHaY
         0RFyhpvA90HroFRHDrXen1+Ndni0j8H96UiSKBVQIKaoYkmr4Cmx9Rv41/LxXIMheV7n
         aURrmmCzZrfN0fTofqBBy+lN6ZwN9Ct+RvKcY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773072302; x=1773677102;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3pK89JpHY7IheX5DoQRfoN3JFln9h2sA0qQyaAmpA60=;
        b=Qor1FL8x4MP5PMcjizHiyUoqMepj1sR2MEkHiFr6/KqEi1SSXTInzEyfRZHIPwbO9T
         Q6XSfz0igkn1CwXioJHk1u+SgRU+jVnV7F9GWO+HkYmb/5CHUhts3Jx2YwrhjFtMnQGS
         lwRzfvkjEyjZdekoQ03niUZuarIWGYSBo3Xkl7QtEOZTu8jQhMs9tFB450Bx1gqKzXZl
         zp22EsHbsJGXOh6bZZEz6l5zVw/UlTlAqHDSv8AOjNu8345ngSRou9DblpvcoPKvVTCP
         k7l5RD4sHitkvUaUiZxCN7HWfYOrEK129qPHiKpxaZMZfYylP03RaGQbVcBFt1EAUEwx
         XK3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVqXlDKhAZdmBajpTirR0BpnHcZynE9+c1on4AamsUj5XYNKDAJbceMMc1e1gUevJUlF1FsAZPnEA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfUpGmFZTuubjND906s1vCu1HufPamNuN7luiwQwudUBkV4i2t
	CS7tSF6j0M2vvu7RCv9jhTXGv7A9CrYSroU8TUV5l+hhHCSuKIhUmChnhRbXV2ySFwebAldMCcO
	h9YAOpbY=
X-Gm-Gg: ATEYQzxrokf9ChS4aTS6yZKNKt55bKkvwbPONpA69AnmX5NIu/3GaZzs8+4lBkI2Ds2
	WtY6oY5nM6RLbX0dIZjffhpQ3EHhwU0+ho29eV0Fo0Oy9pWBxavRwpagz125Gqs3+6dE3mxpOMO
	81/t7fF0XrNl4P/4CawCsM2oyL/Bs8qQaorLrlKmN6/Ap/D08Ur9Jrg38/o8ZKIfzVyYFuvyLJp
	1IQGP0yjhqpQTEKc/oPvvBqouqhE9aGe1I0m1c8VhgCot6ht1IFP9E430vSWUBxAPldAoQndkt5
	m4I7/hFjExldWFN1RBjW9wcoZciK9MWN3/27aWmI0jimuANJfmn6wWeg6yb6360eaEqZ8PkiA82
	Y7GqlRuIg2o7lMPdRYPe90+Nh6KeBusmKv1t+Yp7dUUEppY2DpMGTNjH4Cc+HTAY9mo0DXTG6/u
	lYDE1RD6lDP60GJdaGznTL3yQzrCpADOWTtgflqYiXQDiyEbmXyxkuELCAyNo6UeWD2uzwFBo=
X-Received: by 2002:a17:907:7209:b0:b96:e3db:9e04 with SMTP id a640c23a62f3a-b96e3dbb24dmr307327866b.53.1773072301427;
        Mon, 09 Mar 2026 09:05:01 -0700 (PDT)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b942f18baadsm401796366b.67.2026.03.09.09.04.59
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 09:04:59 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b886fc047d5so1925053066b.3
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 09:04:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXvSiFQqhcMc728pAkauNycVwoOXQbI/qohC5PCc/xCqEDZxYslaCQJhMlmjdWRfwsnzWliyEwpiA==@vger.kernel.org
X-Received: by 2002:a17:907:9620:b0:b93:89cd:2bbc with SMTP id
 a640c23a62f3a-b942e05c8f0mr627392866b.56.1773072299563; Mon, 09 Mar 2026
 09:04:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260309062759.482210-1-naup96721@gmail.com> <959a75c9-4de5-42d1-8f43-636f4aab5df8@kernel.dk>
In-Reply-To: <959a75c9-4de5-42d1-8f43-636f4aab5df8@kernel.dk>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Mon, 9 Mar 2026 09:04:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi-24g2yzRTHwJ-kD1RqK0TvuPBr0VzvuQVVzR83ddgsw@mail.gmail.com>
X-Gm-Features: AaiRm51qKes9ig_1trfFn7pCb3ntBnyQ9LcYHSKqTbem0S-sskiArfH4wJpIJbI
Message-ID: <CAHk-=wi-24g2yzRTHwJ-kD1RqK0TvuPBr0VzvuQVVzR83ddgsw@mail.gmail.com>
Subject: Re: [PATCH v1] io_uring/register.c: fix NULL pointer dereference in io_register_resize_rings
To: Jens Axboe <axboe@kernel.dk>
Cc: Hao-Yu Yang <naup96721@gmail.com>, security@kernel.org, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 105E523C790
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12598-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[torvalds@linuxfoundation.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.982];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,linuxfoundation.org:dkim]
X-Rspamd-Action: no action

On Mon, 9 Mar 2026 at 06:11, Jens Axboe <axboe@kernel.dk> wrote:
>
> You probably want something ala:
>
> mutex_lock(&ctx->mmap_lock);
> spin_lock(&ctx->completion_lock();
> + local_irq_disable();

How could that ever work?

Irqs will happily continue on other CPUs, so disabling interrupts is
complete nonsense as far as I can tell - whether done with
spin_lock_irq() *or* with local_irq_disable()/.

So basically, touching ctx->rings from irq context in this section is
simply not an option - or the rings pointer just needs to be updated
atomically so that it doesn't matter.

I assume this was tested in qemu on a single-core setup, so that
fundamental mistake was hidden by an irrelevant configuration.

Where is the actual oops - for some inexplicable reason that had been
edited out, and it only had the call trace leading up toit? Based on
the incomplete information and the faulting address of 0x24, I'm
*guessing* that it is

        if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
                atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);

in io_req_normal_work_add(), but that may be complete garbage.

So the actual fix may be to just make damn sure that
IORING_SETUP_TASKRUN_FLAG is *not* set when the rings are resized.

But for all I know, (a) I may be looking at entirely the wrong place
and (b) there might be millions of other places that want to access
ctx->rings, so the above may be the rantings of a crazy old man.

Get off my lawn.

               Linus

