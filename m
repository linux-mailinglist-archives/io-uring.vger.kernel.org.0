Return-Path: <io-uring+bounces-4473-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A10BB9BDE09
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 05:45:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 648782843E4
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 04:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D60DF13541B;
	Wed,  6 Nov 2024 04:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C2YqnW7V"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A7118D622
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 04:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730868300; cv=none; b=inrZQMJADmBndHFXIJt5PGFNKQ0YCyxL0Y3gSsR4lm0IF/7khXlDIScBCXL2HVgG4xIcweL7hAC6CP+pLNMHBsG7BCcWnpUZqRh+WyuBjy7z0znsFDqKcwC+fvus38KUrSH4jbUWrRnCeDJSl+ToFavU8PaFRQWUySfzTay3UIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730868300; c=relaxed/simple;
	bh=LdyvcGK5ggPPw0mXer7lTISLm33Byqe+sqxIB3ZcAKA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o6cv+0d8hrzCzrVvXY/0aFZQPU3TgEVz/wv7ZwF9PjUzmXFw9mkcSBc2Lxntw9iaO07MXfzudDvhMsaCYFQ92tg92YqvbO0c49tBSY+JyOYK5fCVFEG9hpO8/6J3fQMelAt/doZk7dB5AAKDUzlipc30Z9FtaYeYhsXwa67f/Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C2YqnW7V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730868295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LdyvcGK5ggPPw0mXer7lTISLm33Byqe+sqxIB3ZcAKA=;
	b=C2YqnW7VszUMybKNk11xjRl3GoKu1ayEdayCx2Rt36SbglKof+caa+tiaeFvxBjNGVlIkZ
	vOIH0QEzo6IG3k934fV/eTw5MaEjpcyLWElJHcva29StVfQie/CobZXYcqYniuOscQVfhW
	gitIYuCfgfWbhA4CEfRHKgAjmuniL64=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-l-HS6Sw5M32OZz7regnpqw-1; Tue, 05 Nov 2024 23:44:53 -0500
X-MC-Unique: l-HS6Sw5M32OZz7regnpqw-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-84fbe9a23f9so2782234241.0
        for <io-uring@vger.kernel.org>; Tue, 05 Nov 2024 20:44:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730868293; x=1731473093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LdyvcGK5ggPPw0mXer7lTISLm33Byqe+sqxIB3ZcAKA=;
        b=nmi+xm0L9H74fFd5o2lClupEh1C/f085JYzFCtXkEGQjzBVJ8avM5p/L1Iw61+KBMY
         nXMmYRn4+mh5CBwpH6L4YGFiY29GIig44BhruUSfbRLTxkswhamaRBxkluOD2Av37wnO
         57DDYbJm5V+JiAb+/QU4S0nMP49teucKze3Vm3k0WUZQy6mM9VDEJNoPbO4mw9u0hzQb
         V73ozCYnR1WxP3hu9DbBvVPGGemc8eXArm3zsPnMhstgi6JDatkb2uc5fvRTniDLGEG4
         oAAKVYF3nJSUMMYY33Jzu64AVXSD4w73Vm3RgAkh+y9UA5p/GzYqtGJfmBHc6C+4QsTJ
         JYjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfAguqbclqG072Xs/5tNzKxNLAUroAM93BhciWr65nTafT81XPRn/xmNcCmwGAcZ/0lXg+3UJoaw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxptQfxKUppI/aJrg1E5xH9lM2lDR/IgpnnrYnSuyIv+/f+BNYG
	MiTZ6JDfF1rUmLST8gXfpF/OimfWeyShpzXJ7GVlIJ5bHYoOBVlafJclEnjX+OUJq9/BCGkOzMC
	F+aiW62Nbs9pQlYjrYHj1xk/16pMP+Hx+g7VAz/qYkOtQRwhSVqfRecTJVeIDiNxMZShp6XXZxZ
	CsrMxohaOkZR5MZmhtLVYNvHS2E25OJ+Y=
X-Received: by 2002:a05:6102:3753:b0:4a4:9363:b84f with SMTP id ada2fe7eead31-4a8cfb25e4amr37666143137.5.1730868292819;
        Tue, 05 Nov 2024 20:44:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE4iGAezGMJs15MNuuVVJkx2duwmdHhkRxiLbHUY21XKlOr3ugjz4SNSgTPpCow5imWMd0nbAcU7G/vr44oXyY=
X-Received: by 2002:a05:6102:3753:b0:4a4:9363:b84f with SMTP id
 ada2fe7eead31-4a8cfb25e4amr37666136137.5.1730868292604; Tue, 05 Nov 2024
 20:44:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c753666e@ddn.com>
 <b4e388fe-4986-4ce7-b696-31f2d725cf1c@gmail.com> <473a3eb3-5472-4f1c-8709-f30ef3bee310@ddn.com>
 <f8e7a026-da8a-4ce4-9b76-24c7eef4a80a@gmail.com> <9db7b714-55f4-4017-9d30-cdb4aeac2886@ddn.com>
In-Reply-To: <9db7b714-55f4-4017-9d30-cdb4aeac2886@ddn.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Wed, 6 Nov 2024 12:44:41 +0800
Message-ID: <CAFj5m9L9xjYcm2-B_Dv=L3Ne3kRY5DVQ8mU7pqocqXE13Ajp-g@mail.gmail.com>
Subject: Re: [PATCH RFC v4 12/15] io_uring/cmd: let cmds to know about dying task
To: Bernd Schubert <bschubert@ddn.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Jens Axboe <axboe@kernel.dk>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, Joanne Koong <joannelkoong@gmail.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 7:02=E2=80=AFAM Bernd Schubert <bschubert@ddn.com> w=
rote:
>
>
>
> On 11/5/24 02:08, Pavel Begunkov wrote:
> > On 11/4/24 22:15, Bernd Schubert wrote:
> >> On 11/4/24 01:28, Pavel Begunkov wrote:
> > ...
> >>> In general if you need to change something, either stick your
> >>> name, so that I know it might be a derivative, or reflect it in
> >>> the commit message, e.g.
> >>>
> >>> Signed-off-by: initial author
> >>> [Person 2: changed this and that]
> >>> Signed-off-by: person 2
> >>
> >> Oh sorry, for sure. I totally forgot to update the commit message.
> >>
> >> Somehow the initial version didn't trigger. I need to double check to
> >
> > "Didn't trigger" like in "kernel was still crashing"?
>
> My initial problem was a crash in iov_iter_get_pages2() on process
> kill. And when I tested your initial patch IO_URING_F_TASK_DEAD didn't
> get set. Jens then asked to test with the version that I have in my
> branch and that worked fine. Although in the mean time I wonder if
> I made test mistake (like just fuse.ko reload instead of reboot with
> new kernel). Just fixed a couple of issues in my branch (basically
> ready for the next version send), will test the initial patch
> again as first thing in the morning.
>
>
> >
> > FWIW, the original version is how it's handled in several places
> > across io_uring, and the difference is a gap for !DEFER_TASKRUN
> > when a task_work is queued somewhere in between when a task is
> > started going through exit() but haven't got PF_EXITING set yet.
> > IOW, should be harder to hit.
> >
>
> Does that mean that the test for PF_EXITING is racy and we cannot
> entirely rely on it?

Another solution is to mark uring_cmd as io_uring_cmd_mark_cancelable(),
which provides a chance to cancel cmd in the current context.

Thanks,


