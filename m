Return-Path: <io-uring+bounces-6118-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0846A1BD8C
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 21:33:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54C553A163E
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 20:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7F9F1ADC8F;
	Fri, 24 Jan 2025 20:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UAGgOlHX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0526B193073;
	Fri, 24 Jan 2025 20:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737750810; cv=none; b=SNvCVo+8fmf/+0FfOSdxX+Q3Y2o7dm3vhlU2RgtWtQ0LU1xESzehv2TXRjj0y971LRCH/8WpFtsIGFtBY8pdBG8NbNA24Wywy2zy9Jjdg6QY4qY9JLsbVLPO7pANI2gwEdvm5j6LV5qIg3P4p2VCgKOMXc+z2NjbMSogpYZTYa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737750810; c=relaxed/simple;
	bh=s93EMZD4m3gkZOXEJ3DW4gx8xDCIov5mMjLNEBYfBFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B53d/bzRZk+lCgkg2qh8dDBEPCUmufMauOF/kKwKf7yEZBS5mgK0eFI++A3KZbKbrvgNMaWIiJrMXERlk2ljYP5/ErvfvKSeU/R6ORfw6l1kbjs7vmBieuPZUjPCku72GCNMQoJz5nhGFWa1EAYKo5yVwPBVaH0r53IDfJKbcUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UAGgOlHX; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aaef00ab172so418624466b.3;
        Fri, 24 Jan 2025 12:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737750807; x=1738355607; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=msOjWPCAw9ERGmFTcL2VnbWPOioG/2+WNCrXcGF3mYg=;
        b=UAGgOlHXmT08wfogTnAvWJYkvX8vx0yydZWUkO0xNFL66jknm1Lmb0llipP0vmRHyJ
         9XpQPf5jicRsYLcTjXibly5DvnW09ZuQgriJKH37baGep5M8pUFHgkGsPngmYeopo6Jl
         DYtY94YxpHfsZYR76NhWAgDLtkCkyh8w3osTK6XjgRcwd3Eh1w9AOEKHe7msAgjcMpoj
         0bRqnSW8zwbF58Y5n/4HzkLvpgM3fjenaFQ/NhukfJEm3bqey3p0BjOkCQq82vUaOOET
         nitbtKFnP85RBgayqLvpw0/ivxEnGJJzTz77VT7Lp8fk3Xv2cTQ9KsTebOI4q21U97+Q
         Nk/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737750807; x=1738355607;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=msOjWPCAw9ERGmFTcL2VnbWPOioG/2+WNCrXcGF3mYg=;
        b=QXM5/T49MORFyWvHoAWjhAwejE4Gy32/lTuHD/QJ3h1q84kIaBPL4e0HDg63NnFeAC
         i1UFtc3Y5etbuXKg3rIXh9lD4ii5SYlFZgiOVPTZ3jLJzKBhnPC5z+3FYIcs0dvG758m
         /G5OL5N2kjUsq9rpDAl5QeAV30pqObjgLxy47vNvduVi5e5aSP4IpAZCLuGY6mJIHmHT
         KsH5DleDSnQMIbDAAEi8BGGpfRd0sxoD39Hyv3v5UKhdhuFSHtwVERp09LVPVrcOlMSP
         kFqP37xmBZU87/A1e37QDC8F6eGF17IkvwrGrqOx49XfaW4iK2FpXiCdG/fegOgyJKea
         dFQg==
X-Forwarded-Encrypted: i=1; AJvYcCX8AJ5HTcIBkJUn8zfFKnX+mNt5EgI4W1vHnxyiiPXyXI6M3W+SSslOFX5qCFrZeyn5uliypuD29JvKKKnP@vger.kernel.org, AJvYcCXwsGbDijB6BBKtK4seQ6oHLY4bdhPG9tnwKWXVCrlOt7DLEYnVaLlZMi6iKztpUgnv7jtGU38a1w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxIdKKAbTrX1KviBUuCmZ7AYJxa05AvaOHP4szq5xrC+GDaHpKt
	RZuU2lvhzlfpAcYisuvJrxX8LVa7t5XSUujTOxi3d/hOPh3yZYQo3HMkgAS/
X-Gm-Gg: ASbGncsyyzhD/zmY8VSXUj+aR2nzlNC6VjjdOvY517y1hUoyXqpLEqKG73xklqaTsTv
	uc/9tTG54dmnWFG1jT6mmbvZxmIvbuuGSj+gfQEJxItQ2ueKyBSa691oJ7czF4CUJg9K37XirJE
	rOmgZ3YJ+7zC9hm6ZuC6Avi2EjJNtc66N+SNPxSnhbc5ueZMeEkiSy+cpY0ZB2PGGRRVb89xoB+
	cCt9TZMr8ww9mi+n7NsNThCwNKv0rEGwg5/N9SSxyK55lJhBryJEpQ2qwMZuxL9i3epDYhA+E+4
	B4Tg1rkxELf2i9TBBp7GdNTV8UJfwbo/F78oMA==
X-Google-Smtp-Source: AGHT+IHvvXeAKfyUkxVzya16gkKrn7S0nF6i51r0gWyL32XeA+yVKQs3IGPSM4kG4Phzg3OG/7tWhQ==
X-Received: by 2002:a05:6402:50d4:b0:5d0:cfad:f71 with SMTP id 4fb4d7f45d1cf-5db7db2bea3mr72880269a12.32.1737750806940;
        Fri, 24 Jan 2025 12:33:26 -0800 (PST)
Received: from eldamar.lan (c-82-192-244-13.customer.ggaweb.ch. [82.192.244.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc186191ebsm1593746a12.11.2025.01.24.12.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 12:33:25 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id E261CBE2EE7; Fri, 24 Jan 2025 21:33:24 +0100 (CET)
Date: Fri, 24 Jan 2025 21:33:24 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Xan Charbonnet <xan@charbonnet.com>, 1093243@bugs.debian.org,
	Jens Axboe <axboe@kernel.dk>, Bernhard Schmidt <berni@debian.org>,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
Message-ID: <Z5P5FNVjn9dq5AYL@eldamar.lan>
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <dde09d65-8912-47e4-a1bb-d198e0bf380b@charbonnet.com>
 <Z5KrQktoX4f2ysXI@eldamar.lan>
 <fa3b4143-f55d-4bd0-a87f-7014b0fad377@gmail.com>
 <Z5MkJ5sV-PK1m6_H@eldamar.lan>
 <a29ad9ab-15c2-4788-a839-009ca6fdd00f@gmail.com>
 <df3b4c93-ea70-4b66-9bb5-b5cf6193190e@charbonnet.com>
 <8af1733b-95a8-4ac9-b931-6a403f5b1652@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8af1733b-95a8-4ac9-b931-6a403f5b1652@gmail.com>

Hi Pavel,

On Fri, Jan 24, 2025 at 06:40:51PM +0000, Pavel Begunkov wrote:
> On 1/24/25 16:30, Xan Charbonnet wrote:
> > On 1/24/25 04:33, Pavel Begunkov wrote:
> > > Thanks for narrowing it down. Xan, can you try this change please?
> > > Waiters can miss wake ups without it, seems to match the description.
> > > 
> > > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > > index 9b58ba4616d40..e5a8ee944ef59 100644
> > > --- a/io_uring/io_uring.c
> > > +++ b/io_uring/io_uring.c
> > > @@ -592,8 +592,10 @@ static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
> > >        io_commit_cqring(ctx);
> > >        spin_unlock(&ctx->completion_lock);
> > >        io_commit_cqring_flush(ctx);
> > > -    if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
> > > +    if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
> > > +        smp_mb();
> > >            __io_cqring_wake(ctx);
> > > +    }
> > >    }
> > >    void io_cq_unlock_post(struct io_ring_ctx *ctx)
> > > 
> > 
> > 
> > Thanks Pavel!  Early results look very good for this change.  I'm now running 6.1.120 with your added smp_mb() call.  The backup process which had been quickly triggering the issue has been running longer than it ever did when it would ultimately fail.  So that's great!
> > 
> > One sour note: overnight, replication hung on this machine, which is another failure that started happening with the jump from 6.1.119 to 6.1.123.  The machine was running 6.1.124 with the __io_cq_unlock_post_flush function removed completely.  That's the kernel we had celebrated yesterday for running the backup process successfully.
> > 
> > So, we might have two separate issues to deal with, unfortunately.
> 
> Possible, but it could also be a side effect of reverting the patch.
> As usual, in most cases patches are ported either because they're
> fixing sth or other fixes depend on it, and it's not yet apparent
> to me what happened with this one.

I researched bit the lists, and there was the inclusion request on the
stable list itself. Looking into the io-uring list I found
https://lore.kernel.org/io-uring/CADZouDRFJ9jtXHqkX-PTKeT=GxSwdMC42zEsAKR34psuG9tUMQ@mail.gmail.com/
which I think was the trigger to later on include in fact the commit
in 6.1.120. 

This just to give some datapoints on from where the request comes
initialy and for which problem it got tackled.

The following is just to make the regzbot aware of the regression:

#regzbot introduced: 3ab9326f93ec4471cab6f2107ecdf0cf6a8615aa
#regzbot link: https://bugs.debian.org/1093243

Regards,
Salvatore

