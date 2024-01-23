Return-Path: <io-uring+bounces-477-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A5B5839D75
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 00:58:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC0D41F24FF1
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 23:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD96955797;
	Tue, 23 Jan 2024 23:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="PWva0+iS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C1854735
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 23:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706054311; cv=none; b=e3HVbyHqd6Zqf+b901J1aN5dkeaZbWVx4b+LHIKDmQVmY85Hby4QAzfdd10WdjTNrahFvZOuF4H34HQxazepCDxeJJx7MBhpoUdGVyIIM1LIDf7/65nCrdFNhvFLzGVruFAX4PDxfO6OxmMGGCVvFVrFMnNN7Zr/0ENY/Dj8tyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706054311; c=relaxed/simple;
	bh=IynX6u4mvBalm/RbV4Poaqp1DBQ8ctKBACbRd1Iv/o0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PRxet9Brs1xbDi5BErCHtr9ZgqSxk/rv++e48maHg6Z0dN0RRCcfYjUFCA/Vf9d81TAiuw42C+R6khMpmR4LASB7GGRBRgw3m0biiB9c8zM+u3c0FEBkvhwZEQX36x64uSTCb2IekTnUBrbMKPp4zszGDsbG+1cReD8NcqB1PCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=PWva0+iS; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-dae7cc31151so3681711276.3
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 15:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1706054309; x=1706659109; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cL6AxRz6Xtq0xrIYdJsZbYeq0wCWJbZQUMTqfFz90ow=;
        b=PWva0+iSu4xAerRswmveUqTSosX8M1kkN3MR0vF9ZOsDezNAf/IeKNZu9tf8/09PH8
         JnDsVqPc6p1fE6kKe0IgXuL9s/rr2D3oNNkP5w7KZ21PbjOBZYehqwbJ8YkZfbiDvtA7
         0nxKM4HkeGmJ8ttd6q6RTYGq870qZYKp6NmFzQc/kCHJb1uR68B7UB97kZyP/2xhC3N6
         Ar5a/LcJ+yhyZu8nEU4DW5efxHrO8e7eaWSdnRMMaihXrN3xdh9DjtrGxgwOtwVmimwK
         b5bZXeZRTjq4HXBOs0XzIuglm7zoxtG2KadDH4sgudjRBX48/PNwCmWiyN0lKcV6BEfl
         bt1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706054309; x=1706659109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cL6AxRz6Xtq0xrIYdJsZbYeq0wCWJbZQUMTqfFz90ow=;
        b=uGibXWxLT7iHMkQ1CWBUoNYo0OqUQLf+YHLnGLekLG9xNcXvHRzG/epiKL28LB1y90
         iSOGFr3mDcl0z4kcWnhV6B3kPa93893U0zLjlzS3IWxeUZq9GsyYf6UnMjXbpUANXD6e
         WOFvD50g1TdZcGKj4w2hNTg0cgVSM1r7wGdqYxxoQnqRyXg9AV8gI9tmo8KXPzAvqUZJ
         6qyDUZXr/AWUh5t61OxcsyZBJ8AwnxqkmuHgwBeJgRHpLmGQ9RKbe+jrkE24lIB9OosE
         W25vNQc7gHYMpU1Qhok88Q4kERfRS8BIFwHwr8OWagKrs3UKO8Y9/88hL7GCAG1jhTY1
         Llag==
X-Gm-Message-State: AOJu0YxlYXkcg3GkSCwpy8/1Llg2bx1F1XqAvzD8tW/dviDlbRwz3tAr
	WXwKEZwMIDZ/UyUUKM8wUbUKoTHYr6/lmV28J75xMdiwyANqH/R6hIsQnVvsFzoeNti+usgrqJ+
	S0mXJwVBDh3gshyI15H/yqzAPCBSKTNPcku2D
X-Google-Smtp-Source: AGHT+IEaVh9ckNB9SI9jCXziUhbBHVpZnwT8uzibvDSWQZxDfVcAHLY6UJiD5wdYwnlOMVQdxM0ncF0PvMW/HeoXf3o=
X-Received: by 2002:a25:e0c3:0:b0:dc2:65ff:7948 with SMTP id
 x186-20020a25e0c3000000b00dc265ff7948mr19443ybg.0.1706054309145; Tue, 23 Jan
 2024 15:58:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240123215501.289566-2-paul@paul-moore.com> <170604930501.2065523.10114697425588415558.b4-ty@kernel.dk>
 <e785d5df-9873-46ab-8b8a-7135da6ed273@kernel.dk> <cff4ba69-cc21-4af9-8a44-503649677b9c@kernel.dk>
In-Reply-To: <cff4ba69-cc21-4af9-8a44-503649677b9c@kernel.dk>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 23 Jan 2024 18:58:18 -0500
Message-ID: <CAHC9VhTrH4+bVnQnzmmn4eJ4bMt=6wJSg7_DJ_Bo-K5AC3nBfA@mail.gmail.com>
Subject: Re: [PATCH] io_uring: enable audit and restrict cred override for IORING_OP_FIXED_FD_INSTALL
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, audit@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 5:43=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/23/24 3:40 PM, Jens Axboe wrote:
> > On 1/23/24 3:35 PM, Jens Axboe wrote:
> >>
> >> On Tue, 23 Jan 2024 16:55:02 -0500, Paul Moore wrote:
> >>> We need to correct some aspects of the IORING_OP_FIXED_FD_INSTALL
> >>> command to take into account the security implications of making an
> >>> io_uring-private file descriptor generally accessible to a userspace
> >>> task.
> >>>
> >>> The first change in this patch is to enable auditing of the FD_INSTAL=
L
> >>> operation as installing a file descriptor into a task's file descript=
or
> >>> table is a security relevant operation and something that admins/user=
s
> >>> may want to audit.
> >>>
> >>> [...]
> >>
> >> Applied, thanks!
> >>
> >> [1/1] io_uring: enable audit and restrict cred override for IORING_OP_=
FIXED_FD_INSTALL
> >>       commit: 16bae3e1377846734ec6b87eee459c0f3551692c
> >
> > So after doing that and writing the test case and testing it, it dawned
> > on me that we should potentially allow the current task creds. And to
> > make matters worse, this is indeed what happens if eg the application
> > would submit this with IOSQE_ASYNC or if it was part of a linked series
> > and we marked it async.
> >
> > While I originally reasoned for why this is fine as it'd be silly to
> > register your current creds and then proceed to pass in that personalit=
y,
> > I do think that we should probably handle that case and clearly separat=
e
> > the case of "we assigned creds from the submitting task because we're
> > handing it to a thread" vs "the submitting task asked for other creds
> > that were previously registered".
> >
> > I'll take a look and see what works the best here.
>
> Actually, a quick look and it's fine, the usual async offload will do
> the right thing. So let's just keep it as-is, I don't think there's any
> point to complicating this for some theoretically-valid-but-obscure use
> case!

Perhaps the one case where REQ_F_CREDS is our friend for FD_INSTALL ;)

> FWIW, the test case is here, and I'll augment it now to add IOSQE_ASYNC
> as well just to cover all the bases.
>
> https://git.kernel.dk/cgit/liburing/commit/?id=3Dbc576ca398661b266d3e4a4f=
5db3a9cf7f33fe62

Great, thanks!

--=20
paul-moore.com

