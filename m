Return-Path: <io-uring+bounces-3328-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8234C98AA20
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 18:44:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C18DB26F18
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 16:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0CD1990D6;
	Mon, 30 Sep 2024 16:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wp3DCa9N"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13891990C6;
	Mon, 30 Sep 2024 16:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727714570; cv=none; b=Viy45UZyfbuxW66PqNuTu87uU81CFtnhQlV/jVNC17LTtHxznl9wEkNzy9j5hyPfwkLYXnzFGM2Z7dGJMpLe2mb/8a7E/IVQ9DM7TNg34Sj5oIpAvTkLamQ55SCIM0A4K557N4Iqys/NZLqt6ImgoCoHFaooOHVUMDP4cEpVTUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727714570; c=relaxed/simple;
	bh=bHMIGTbLu6KxLb+TfCgB+lUPHDBwW+oj6ZCEvSTDToM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oFv4XlhOGSbtWjUYe8G3dUKD9PFZkATkF3v2zvnQST4+XAALWGyOp0+0wy53pHdvLmo4IMVHxCU5vMiJklNMISRPSyti1UhafD5xHtASU2rFr4A42CJ20DCSI24byy4PLWFZfMbt6RzROGzNrLIup1Ja+ErTyBKMcmGbw/Z+UfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wp3DCa9N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E91C4CEDC;
	Mon, 30 Sep 2024 16:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727714570;
	bh=bHMIGTbLu6KxLb+TfCgB+lUPHDBwW+oj6ZCEvSTDToM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Wp3DCa9NGIpXjA4o7jyzfUfAn8Nul46d2oVLnjnjuEg4EykAFrHZ21nspJPgFL5mu
	 FPtTShXdZMkRrjXeT2i1u4ls0El3OmBUfS1Pk6fRPeCDom/QpD1xCYhv5eVIPLw1uq
	 LZ9rkAiR+MtFM/o2UxbFdHZMrCZTc7vTJPYfJItykJOpD63fum50Q5McgQwS7s/5gF
	 4oB6TQw0GLdrW89/EODfA/Ft783cqgy/bYOlFlgHsTUipBKradmglBa2N1XC75Kcks
	 RW6eWFPT1BRVt+njpccf7gOYv49ogVSI9MirLXUHwWH7AVpyOAWVaKKNLHX6Iwn1cE
	 38gm/aLq5XOhA==
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-710fe5c3b44so2729462a34.0;
        Mon, 30 Sep 2024 09:42:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUZL2Xp+bpvyTknC0tx4EyDNENgsiJYtery4GBQ0rKKJkhMsWzO0z2Iczbh2/dm7Ya85NrxaCWiucZlWQs=@vger.kernel.org, AJvYcCVMbqA20IFwW6xtMU/oq4bU5btPn9Z1FTAaYbqa3y4CO04WqF5CZFtzghFDiSMMENsPiRKbB3CY6w==@vger.kernel.org, AJvYcCWrFqUDYq8G+bc4YM+6QcbEXkHuqOFI37OsFVOzvt+kQuDhXSqIwVRT3x1qY++uGYcwiUXvN3SxNJs=@vger.kernel.org, AJvYcCXx/hj/KL9dxsBrToqWzVfVJ1yPhvc3v7r6dhN9seMAh0jfk9X8OlAcgAvzU+bh/qMCpuG6toDaP69LbyQL@vger.kernel.org
X-Gm-Message-State: AOJu0YyBJjiY8RYNJMr+nj7P2Ln90v17mZZhiMktJIPRr+lqu5JKDK2E
	YnrZOeKBWy/efkQm+DXyZRgYhTxzvVlA4LIdECau9ymWk5K3qzAhWysF/N8ACv5Yge8zCdyf25K
	UKL5ksEyDjty6h+hDuSS1Sp8H9Gg=
X-Google-Smtp-Source: AGHT+IHze5qANDiYr4RriiyfVRHVxK7VwaKDVHNF9tZefVumRdGfhxb9aIQwSgnQv+FWi7f0PwXGwlYkpiFOYx8eQys=
X-Received: by 2002:a05:6830:7196:b0:710:e8c6:9a1c with SMTP id
 46e09a7af769-714fbe825b2mr6787769a34.3.1727714569727; Mon, 30 Sep 2024
 09:42:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240905092645.2885200-1-christian.loehle@arm.com>
 <20240905092645.2885200-3-christian.loehle@arm.com> <CAJZ5v0gKeHsvB_Jfja=yYLijhe9_dWSjCaMDtE2isOuJa6dy8w@mail.gmail.com>
 <e343155e-63f9-4419-836a-0e23676ef72e@arm.com>
In-Reply-To: <e343155e-63f9-4419-836a-0e23676ef72e@arm.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 30 Sep 2024 18:42:38 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0jhV12zL3FP1JoqUZNVMM5Fbj1NUUdsxeW0OsNWemJ7oA@mail.gmail.com>
Message-ID: <CAJZ5v0jhV12zL3FP1JoqUZNVMM5Fbj1NUUdsxeW0OsNWemJ7oA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/8] cpuidle: Prefer teo over menu governor
To: Christian Loehle <christian.loehle@arm.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, linux-pm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, peterz@infradead.org, juri.lelli@redhat.com, 
	mingo@redhat.com, dietmar.eggemann@arm.com, vschneid@redhat.com, 
	vincent.guittot@linaro.org, Johannes.Thumshirn@wdc.com, 
	adrian.hunter@intel.com, ulf.hansson@linaro.org, bvanassche@acm.org, 
	andres@anarazel.de, asml.silence@gmail.com, linux-block@vger.kernel.org, 
	io-uring@vger.kernel.org, qyousef@layalina.io, dsmythies@telus.net, 
	axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2024 at 6:12=E2=80=AFPM Christian Loehle
<christian.loehle@arm.com> wrote:
>
> On 9/30/24 16:06, Rafael J. Wysocki wrote:
> > On Thu, Sep 5, 2024 at 11:27=E2=80=AFAM Christian Loehle
> > <christian.loehle@arm.com> wrote:
> >>
> >> Since menu no longer has the interactivity boost teo works better
> >> overall, so make it the default.
> >>
> >> Signed-off-by: Christian Loehle <christian.loehle@arm.com>
>
> First of all thank you for taking a look.
>
> >
> > I know that this isn't strictly related to the use of iowait in menu,
> > but I'd rather wait with this one until the previous change in menu
> > settles down.
>
> Sure, I will look at any regressions that are reported, although "teo
> is performing better/worse/eqyal" would already be a pretty helpful hint
> and for me personally, if they do both perform badly I find debugging
> teo way easier.
>
> >
> > Also it would be good to provide some numbers to support the "teo
> > works better overall" claim above.
>
> Definitely, there are some in the overall cover-letter if you just
> compare equivalent menu/teo columns, but with the very fragmented
> cpuidle world this isn't anywhere near enough to back up that claim.
> We have found it to provide better results in both mobile and infra/
> server workloads on common arm64 platforms.

So why don't you add some numbers to the patch changelog?

If you can at least demonstrate that they are on par with each other
in some relevant benchmarks, then you can use the argument of teo
being more straightforward and so easier to reason about.

> That being said, I don't mind menu being around or even the default
> per-se, but would encourage anyone to give teo a try.

Fair enough.

