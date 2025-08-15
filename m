Return-Path: <io-uring+bounces-8977-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B35C4B280E1
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 15:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B0DC1CE73D0
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 13:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9225527979A;
	Fri, 15 Aug 2025 13:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZQr4Yy0i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60E71B5EB5;
	Fri, 15 Aug 2025 13:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755265928; cv=none; b=sVtU8mFtqU3uVwvTMJh79Nn+hexW9BQsXc+o2yThA0FB0s44Gi0PYAK8Wo9Z6AtTUS92oD5tmEJ8HutjCojuo5DD8+SUMAYPPN/cw0YRZexnOZRNq3409jtrDv88SpL8fHp14i72/rNZOw3622BUUWsSSx+IXqcFMZHAU8lXe3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755265928; c=relaxed/simple;
	bh=dVGzi4c4OVoWTrF1Pr7Q/JyDFc5S4I9xNjzuV38JcKc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O0kM1VShxPCpNIsTkcFCwIlEsTbeYho9Acq9zeosFocdRRYr2w/2AFOqxgmmEjBGOMI1Q1M9e9Jx4bf5aPqAY0DhVfFK50jJjJn1gP8lRUzkE+HNdpfw566hvne6xzBHHPtLY+QTvr96Gw/9L3DHKLj8fBYxkM4+vum8TKqvWyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZQr4Yy0i; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-618b62dbb21so699380a12.2;
        Fri, 15 Aug 2025 06:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755265925; x=1755870725; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dVGzi4c4OVoWTrF1Pr7Q/JyDFc5S4I9xNjzuV38JcKc=;
        b=ZQr4Yy0ij7qdmYcwhij1C8GKJJAOUaQqhvhTgz3jicqou049OePQ9e2TcjSJibonYa
         So7R2Ob+ssP61mNLUv8kc23k2Shi6RevzLqSANgpbdjtx63ogicQly27ADSvC5NCZVU1
         NxVm/h6YKsIiLIlCTnSoCvKzaosHpjggiYPs5IOPSSURV0gykOSe3RtGG9dDX6hzXXNG
         Too1tEIssNjayU3e81z/g3j9LPzvGLI1WAW9nmaBsZ91FkMswkv7ZIWreiByZ1MgxNMv
         GSQvNJmYdL4WjWehrRIzWfZOWYLa3ULQ2c1GyinV7Bni+U/UiYMaxct6Jnp8zxm/Jj2G
         ivSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755265925; x=1755870725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dVGzi4c4OVoWTrF1Pr7Q/JyDFc5S4I9xNjzuV38JcKc=;
        b=GYG+lie28YMFNPA1sLYOJk95cdgQn96bYHO1ID3dXhY6OJx9OPtGih3ztqcCGaXHnf
         jIHqmfgFsVKgZWsUnSkEKIJvRHsLmmwqwmQ6ypquJGyG4MJr+PxlU8APD7wjF8hH8KU9
         bMMWGC9r9zlVYcxDzeliGBqNHoqqxewqjAERSTPZPgg0uZPUiCKpVKnDSkkLdOsLa/8P
         NWI2XJFAXhAwg5Z8YUdVUuUijYy0MSE1QaAHPqXN+xItTbZIlNAbBB7pJqszHcQN7HL0
         5ffe/TR2Y9CcsbGqSD6BLSJ+73Hjokvsv6Qtnb2PpTD7pvUdKHdxsdbV/okvr6O7CmnC
         ZIrQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3fqcWZBk/qgDZmE8YGggsoHrgq6JhGxCWyjWKbTKaNSIlOxFSrNS80PNOIDUsv84j6BS5I67Y8+IX@vger.kernel.org, AJvYcCXzY42Qd1YuvHz8SJytPz1vADjdcNKrcvq84uiLVKzCnsGAoxdmnIRjbiIjT7bqFrnb5k2jzz1uKg==@vger.kernel.org, AJvYcCXzvY6TqtQbrv1BLtax4XU1BdI2zVq22+RnzN8BH2tTnl9ALpsd3UercqDJMc3EqpfdVZYCev2k70qAJHQSFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0g0bJlKvI1DCW16stnSeb77qraE9IYmfk8xTdCnmWavg8uolm
	p8w1EmcNHlXB5k73LkKomOEjQwVPFBVbsN8v2WrJvp/2ReEf2lQXXpy70BUXE9ZLpkBoji9zvCt
	VTYKjK9wIyTzGb/APWLrX7gEivmhglU0=
X-Gm-Gg: ASbGncv/+yVXi/80RhwjnWmTBit1/kL/Q/SUuG1XTLKIaKkbRTqvQtgIxoj3mTgy/aK
	GQXB12dayyxnp/+i5VfWXAu9h6sLLHS0xlrhN5dee8CcB+enO4u/WUlYdpMTjt911sFUzKwkfob
	orG4FV+VumVWwhzHpJPVtPyk6NpJ4A+kxxrEhrW6hOiQRJ+4S1wxaWY8muMUWubVtCqa/4uTuFr
	TyNGf8N/ygsd72h3w==
X-Google-Smtp-Source: AGHT+IEtohHeYFXL04gnIB+eqg/0kHeWZ4aGAqbAUbGdpcEPHGxC0qI3MG7JkgB/t2/JklA2l8oWpKtZxxKug6zbnQ4=
X-Received: by 2002:a05:6402:46dc:b0:618:3a9d:53ee with SMTP id
 4fb4d7f45d1cf-618b055c7d2mr1934278a12.28.1755265925031; Fri, 15 Aug 2025
 06:52:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
 <20250814235431.995876-4-tahbertschinger@gmail.com> <CAOQ4uxhhSRVyyfZuuPpbF7GpcTiPcxt3RAywbtNVVV_QDPkBRQ@mail.gmail.com>
 <20250815-raupen-erdgeschichte-f16f3bf454ea@brauner>
In-Reply-To: <20250815-raupen-erdgeschichte-f16f3bf454ea@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 Aug 2025 15:51:53 +0200
X-Gm-Features: Ac12FXwHs77cA6iVE55I-ATj1tLTN8mqAHB8F3bMS6x9dNdEXtmz550_bNOcQ8w
Message-ID: <CAOQ4uxgBXeE3N5Pq8p=3AgH_cFnkzOK=ipiZHwx6i_C6Oghc3w@mail.gmail.com>
Subject: Re: [PATCH 3/6] fhandle: do_handle_open() should get FD with user flags
To: Christian Brauner <brauner@kernel.org>
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>, io-uring@vger.kernel.org, axboe@kernel.dk, 
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, 
	linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 3:46=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Fri, Aug 15, 2025 at 11:17:26AM +0200, Amir Goldstein wrote:
> > On Fri, Aug 15, 2025 at 1:52=E2=80=AFAM Thomas Bertschinger
> > <tahbertschinger@gmail.com> wrote:
> > >
> > > In f07c7cc4684a, do_handle_open() was switched to use the automatic
> > > cleanup method for getting a FD. In that change it was also switched
> > > to pass O_CLOEXEC unconditionally to get_unused_fd_flags() instead
> > > of passing the user-specified flags.
> > >
> > > I don't see anything in that commit description that indicates this w=
as
> > > intentional, so I am assuming it was an oversight.
> > >
> > > With this fix, the FD will again be opened with, or without, O_CLOEXE=
C
> > > according to what the user requested.
> > >
> > > Fixes: f07c7cc4684a ("fhandle: simplify error handling")
> > > Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> >
> > This patch does not seem to be conflicting with earlier patches in the =
series
> > but it is still preferred to start the series with the backportable fix=
 patch.
> >
> > Fee free to add:
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>
> I'm kinda tempted to last let it slide because I think that's how it
> should actually be... But ofc, we'll fix.

You mean forcing O_CLOEXEC. right?
Not ignoring the rest of O_ flags...

Thanks,
Amir.

