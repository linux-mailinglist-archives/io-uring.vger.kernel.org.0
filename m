Return-Path: <io-uring+bounces-9183-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A3D6B301E0
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:20:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86FC6AE03B9
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 18:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C070419EED3;
	Thu, 21 Aug 2025 18:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Hk6D+exS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63E12DF3CF
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 18:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755800413; cv=none; b=p/RAEtyBQ4CuJukEa1JvMFvkULSjJRBoPW+PfSdlS9wAYx0iRGVHlvIF0Sipmspfj0S29oJSps77cbQjc02lZJzNn5ye6V1plhKvQe0zXGGXZDeRTBmD658bHxmg8mxIA/Dz7By5tlok5H7dAc3xu37KZJnTrExkcFqRWmuJEh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755800413; c=relaxed/simple;
	bh=Otnk2MbFSTCTS6Whn4wHdCcBvK+bFkeM49vAj/upOjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pRNkEbD16p03kQ9G4IUyPp4Jjsx4/IXyJkJDF3+uIDgiAvP4E7WLRUwQXzON1Xm7DzuZYHqACgp4/OGoWf1QpOs15DZNhkzAI+8h3IU2g6AE5nJDHKtkQZmaV70jgKzPDQhtSXk3oKpsOp/tIYEt+mQAyGoTRMfIVlMvVzqtkLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Hk6D+exS; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-244581cd020so1876235ad.2
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 11:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1755800411; x=1756405211; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Otnk2MbFSTCTS6Whn4wHdCcBvK+bFkeM49vAj/upOjQ=;
        b=Hk6D+exS0slqNzCvU8q2SoMrwhOeuXI9YCQFA1yTVxF9bYHuUKUJJMKDkvQJHbwnfo
         Rn7C+MwiDi/yGTKNxN3Zan2fiSK+gwlCJQLqoUm0/Ory0yXx62psJRed2h5xhEXdhJTc
         MvNWZUe4VpYSBYudBUTYUBZvFWlDO70FT0xQ6xbAB9uplFEJEydwDGZdfzbr8HXUGee+
         Sr3gOlTNEmvznhbA8NW++QU8CnGBKt9phoJOAxjdZVHPpJwtUPBnOqPumoL+C8qWKKp4
         +BUR9gKD65zm0m3oy02rMdM4Mt//o1j0iMbp66oKbubF6I3MzawUVZzOxaXexr5Xfv6S
         UXdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755800411; x=1756405211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Otnk2MbFSTCTS6Whn4wHdCcBvK+bFkeM49vAj/upOjQ=;
        b=f77NoNI2+WvpDKbb95ezgKFU6ZbxuBbjcJOkGLCt1nolEAOKPvmu7PKCcotzS3akgn
         giQbd0hgkfssCLVLRIYXhJu0Wmd1Jv1TdtCSY9B0iX5dt7m+iBHc1uji4S144qO23Tfe
         51vOfyT9ljhSWz0OG0ZUa7DFNd81It7wX3dcvroH1opisZgC8P8e07tCGByy5h4lhPov
         BD7pFaAo0HGXzJkOo2eVDxsR8H+Cr/0VuORx9BEjgvb7l0+fJhRe4isBEC7jKbQInVw9
         WWGRa8VFajyK2XZKzS4DFBN1KU7WGuOlHnTMI+ugU8UKLXXYyo56lb51CItfjnrS7DHC
         Oq4A==
X-Gm-Message-State: AOJu0Yw+UvS1ZFVQbPN1rgx8hgWD+4UrCO2TIsPUloCm8lC64CTmrOc9
	Tlktx5VrATdW68cRu1WWk6bzDHKGZnvQ43v5BCQBPhzansH5Iuvt6ZrwjrxgBJWIPIZRZVJNjxK
	A3Thh00F27LtgbegzY7xFZ1QEmWgu0wJI5agTaZzMDQ==
X-Gm-Gg: ASbGncutBTNHA5HhTOg3fjptQTattBwng5oIAmXzd2xd8pui6Hju+3Hohw3k9MsFyyH
	l1+dcazkBSH2pK0z3Vp1rN9zPIVcc7sBnWB2OL40JwOIecwb8h8YDLqNC1cHsONh+vwORri8ZSc
	aVYnpmlPHphYUVj2ak1G2ecV+LQwhZ5/L8VhBMny4Zr+GPDGlhotbZyB4AXz6Q+4bF+0uUJS0jl
	SE4D3rwOG3HnecyiednQO11p/s1ug==
X-Google-Smtp-Source: AGHT+IECGmFPjMV89aTWQMOJX1OtSC4dzlKMak29E4HwBgWrn9HM7DZO9u4B3F2tVkBUqXoNhSr2Mh2iZnx8VGJ9QdE=
X-Received: by 2002:a17:902:db0d:b0:234:8f5d:e3a0 with SMTP id
 d9443c01a7336-2462ee14b2amr1988345ad.2.1755800410782; Thu, 21 Aug 2025
 11:20:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821141957.680570-1-axboe@kernel.dk> <CADUfDZragMLiHkkw0Y+HAeEWZX8vBpPpWjgwdai8SjCuiLw0gQ@mail.gmail.com>
 <6145c373-d764-480b-a887-57ad60f872e7@kernel.dk> <CADUfDZpPP2FR1X9hVSkhbtQs=2wtXkeXRBjPDXA9ShSCU0PM2w@mail.gmail.com>
 <670929ea-b614-40cf-b5cc-929a39d9e59d@kernel.dk>
In-Reply-To: <670929ea-b614-40cf-b5cc-929a39d9e59d@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 21 Aug 2025 11:19:58 -0700
X-Gm-Features: Ac12FXxmsx4X-tJFX68Bds3lQTzBWdnLqzSe0WnaoVH_60RgQIPwCczyS2_52pI
Message-ID: <CADUfDZrbt1Yz7KwxEmOUc+Z+jgOvTzzqOq2cM91VBPXw-PEDAQ@mail.gmail.com>
Subject: Re: [PATCHSET v2 0/8] Add support for mixed sized CQEs
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 10:46=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 8/21/25 11:41 AM, Caleb Sander Mateos wrote:
> > On Thu, Aug 21, 2025 at 10:12?AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 8/21/25 11:02 AM, Caleb Sander Mateos wrote:
> >>> On Thu, Aug 21, 2025 at 7:28?AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> Hi,
> >>>>
> >>>> Currently io_uring supports two modes for CQEs:
> >>>>
> >>>> 1) The standard mode, where 16b CQEs are used
> >>>> 2) Setting IORING_SETUP_CQE32, which makes all CQEs posted 32b
> >>>>
> >>>> Certain features need to pass more information back than just a sing=
le
> >>>> 32-bit res field, and hence mandate the use of CQE32 to be able to w=
ork.
> >>>> Examples of that include passthrough or other uses of ->uring_cmd() =
like
> >>>> socket option getting and setting, including timestamps.
> >>>>
> >>>> This patchset adds support for IORING_SETUP_CQE_MIXED, which allows
> >>>> posting both 16b and 32b CQEs on the same CQ ring. The idea here is =
that
> >>>> we need not waste twice the space for CQ rings, or use twice the spa=
ce
> >>>> per CQE posted, if only some of the CQEs posted require the use of 3=
2b
> >>>> CQEs. On a ring setup in CQE mixed mode, 32b posted CQEs will have
> >>>> IORING_CQE_F_32 set in cqe->flags to tell the application (or liburi=
ng)
> >>>> about this fact.
> >>>
> >>> This makes a lot of sense. Have you considered something analogous fo=
r
> >>> SQEs? Requiring all SQEs to be 128 bytes when an io_uring is used for
> >>> a mix of 64-byte and 128-byte SQEs also wastes memory, probably even
> >>> more since SQEs are 4x larger than CQEs.
> >>
> >> Adding Keith, as he and I literally just talked about that. My answer
> >> was that the case is a bit different in that 32b CQEs can be useful in
> >> cases that are predominately 16b in the first place. For example,
> >> networking workload doing send/recv/etc and the occassional
> >> get/setsockopt kind of thing. Or maybe a mix of normal recv and zero
> >> copy rx.
> >>
> >> For the SQE case, I think it's a bit different. At least the cases I
> >> know of, it's mostly 100% 64b SQEs or 128b SQEs. I'm certainly willing
> >> to be told otherwise! Because that is kind of the key question that
> >> needs answering before even thinking about doing that kind of work.
> >
> > We certainly have a use case that mixes the two on the same io_uring:
> > ublk commit/buffer register/unregister commands (64 byte SQEs) and
> > NVMe passthru commands (128 byte SQEs). I could also imagine an
> > application issuing both normal read/write commands and NVMe passthru
> > commands. But you're probably right that this isn't a super common use
> > case.
>
> Yes that's a good point, and that would roughly be 50/50 in terms of 64b
> vs 128b SQEs?

For our application, the ratio between 64 and 128 bytes SQEs depends
on the ublk workload. Small ublk I/Os are translated 1-1 into NVMe
passthru I/Os, so there can be as many as 3 64-byte ublk SQEs
(register buffer, unregister buffer, and commit) for each 128-byte
NVMe passthru SQE. Larger I/Os are sharded into more NVMe passthru
commands, so there are relatively more 128-byte SQEs. And some
workloads can't use ublk zero-copy (since the data needs to go through
a RAID computation), in which case the only 64-byte SQE is the ublk
commit.

Best,
Caleb

>
> And yes, I can imagine other uses cases too, but I'm also finding a hard
> time justifying those as likely. On the other hand, people do the
> weirdest things...
>
> >> But yes, it could be supported, and Keith (kind of) signed himself up =
to
> >> do that. One oddity I see on that side is that while with CQE32 the
> >> kernel can manage the potential wrap-around gap, for SQEs that's
> >> obviously on the application to do. That could just be a NOP or
> >> something like that, but you do need something to fill/skip that space=
.
> >> I guess that could be as simple as having an opcode that is simply "sk=
ip
> >> me", so on the kernel side it'd be easy as it'd just drop it on the
> >> floor. You still need to app side to fill one, however, and then deal
> >> with "oops SQ ring is now full" too.
> >
> > Sure, of course userspace would need to handle a misaligned big SQE at
> > the end of the SQ analogously to mixed CQE sizes. I assume liburing
> > should be able to do that mostly transparently, that logic could all
> > be encapsulated by io_uring_get_sqe().
>
> Yep I think so, we'd need a new helper to return the kind of SQE you
> want, and it'd just need to get a 64b one and mark it with the SKIP
> opcode first if being asked for a 128b one and we're one off from
> wrapping around.
>
> --
> Jens Axboe

