Return-Path: <io-uring+bounces-11058-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BD33CC0AEE
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:08:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C8725302C4C1
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B759B2C21F9;
	Tue, 16 Dec 2025 03:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Lqp9yliZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DE52BE64A
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 03:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765854478; cv=none; b=O/PJS4txGofqAxYspz1QRtZ/hhXvX1VOyuitK8Sc/ZkMfQdNrxjV4E2Bf3yC9Hujm6oZY3B8cq6FOpTODqg4+0cLXJGlkUUkZSg4uekLjBOUYEVdLKpPB7QTSac3DI7WfDeZhH16UufVUWBUY1ZAk0h5ixv5A9j1w4EMYRzUyjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765854478; c=relaxed/simple;
	bh=oNczs+Op/enBhLN5wk5s5RblT5qG1Ab4V5eXZu0DuZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GAMtdj+kKGwrKc97OBicd9VezS/uwAtmsAyZ4BAZfl0tSbxw6futhIkD/3qu/TOeG+KFdE2I5c3SaVwJczNCDLFYwZNK7FJKye1m7vP+kirjKyOhaVNwNuL5iCM5CrMgxhk2oH/jgohzKoW5PA9tA+5iOwY/FRsSzAzEfc6A/18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Lqp9yliZ; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-349e7fd4536so574237a91.3
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 19:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765854476; x=1766459276; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i32kBNi0DJqYnn5gUYyWAtk6nPGBOqaLEFAY1AGj4T8=;
        b=Lqp9yliZWgiLJc/ZH3jCfOEJf+dMq/iU2iKxvPWBtE7Ih8/6FqBbIlhb6+nFUfPvog
         6zz7VCf7ONd6JG8sueftRvUdQGIxuoVW4eku2aajBCUGAnMpSUGgeyefPjTXAr1b3Xeu
         2GIyvahmnEoOCjejEuVX3LDhISsdWOD956MzZ8J30zsd8Shp/nzYEVKtKW1bjgCoBtLB
         vAbMeX5855Nxo1sMyTzhe42x6fqHxnRlNz+vJwheQKSMu5osyZaPMMUa/L2eJO1Q4Xg7
         Z5bZX0Zd4iTvVopa6o7280krggaKEyr4OmWAMszRA1TnCxN+BHJDcX2FRtooSHPz+Opr
         7kBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765854476; x=1766459276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i32kBNi0DJqYnn5gUYyWAtk6nPGBOqaLEFAY1AGj4T8=;
        b=uWDwX8ENdnyCYl/I269pH7RZKZ5i1xe7E69Eeq0Tsd8nC6bntGoEF7B/mLYX9lNLbV
         xSEKQwDsEfRs/vu7o87UaG7sdJeXcoi8RoW7BrkiKsfAen0yyUtlf7QLEZRJ+HsxUX2S
         8IcCW8H+XUaYc3AfaJoyTh08tDIWWGkN795YZaSntsbLQK+E+Y9J0V6dvRMuz8Y+ZBdT
         8LkRTEONEsZbXpIjX+3qhK6GS6BkMn+KsHeUVaEuCQAFHetC5p8uiwSW9sNwIUhkfyo2
         LNuRQxAkEdQp1HJqxH2UJlvcGfoyRYwzVTW6FbzLNBi5gqp6LzgPtBPoG4zcJ7YTXi2P
         /SIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMNejX6vzlv02CzNULk9QvB1NJ3awoRPY20xBmqamvlcv0krvAthxXK8fW71PMe8NwA5XyAXrV8w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzIaUymsViQWaZ4l9pWdemVXiVuPAKBMD0GysAAyAqI3GxUZDI+
	kA6sTO9uIMxBFSnG4Zl91svDYRHS/z2qBC7RNi3pn9Gc31oezwYNUr43pP06AvdHPH5ywkaaAgk
	rihMMrkIbOQ9CSeCMR0dWoU5+oi2uQRdu/PXtiz4mDw==
X-Gm-Gg: AY/fxX41lT4mPvpgx8YZ7z1oOobSbOW1GyW/jMfgRNFx6L8WIq0qVPoRv88SUrVR7DP
	LLA1XHs4x7dKCYFo2Qf/MCgMWuY+qbksz+A4M9/+lJ5vd3hWkiCyViRVuHjqLsMOmqf6lJEFDc/
	ZbKwls3oztKy7bIH14LFJTinXehqhK08qmxal2TaxkdIOl/KN6GSTDnyh8WILqbSW4gw18uySne
	e4R9W2Q/x246dpU6rhZWecdhm20l7FITFTUNq5bvhDu0KtxnVA0XDAVeOxCEGrgUyKULg+w
X-Google-Smtp-Source: AGHT+IEkdAVOYyrzH2Vn0TCTeVw7DcwshVmz6ZS2XMprUMhrrm3CgypWJ2YPV/Vdl4267ZP4bVvWUx4X9lYhEbPlhIs=
X-Received: by 2002:a05:7022:ec0b:b0:11b:1c6d:98ed with SMTP id
 a92af1059eb24-11f349a9d7emr5968016c88.2.1765854476034; Mon, 15 Dec 2025
 19:07:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-23-joannelkoong@gmail.com> <CADUfDZp3NCnJ7-dAmFo2VbApez9ni+zR7Z-iGsudDrTN4qw1Xg@mail.gmail.com>
 <CAJnrk1YO+xWWAQtEvk_xAsoBStRR=o0=t3audmmGrEpKpYGPpg@mail.gmail.com>
In-Reply-To: <CAJnrk1YO+xWWAQtEvk_xAsoBStRR=o0=t3audmmGrEpKpYGPpg@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 15 Dec 2025 19:07:44 -0800
X-Gm-Features: AQt7F2pCCnk4VD1YEf4p6JENbqY7Nml3f00KeaP3YXqjMXyifAnUo5W-x6D8z2c
Message-ID: <CADUfDZp3_r2E5uhu88HgfWQhf5-QWdYL+JiicTeBMDFLrdvVCw@mail.gmail.com>
Subject: Re: [PATCH v1 22/30] io_uring/rsrc: refactor io_buffer_register_bvec()/io_buffer_unregister_bvec()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2025 at 9:11=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Sun, Dec 7, 2025 at 5:33=E2=80=AFPM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > On Tue, Dec 2, 2025 at 4:37=E2=80=AFPM Joanne Koong <joannelkoong@gmail=
.com> wrote:
> > >
> > > +int io_uring_cmd_buffer_unregister(struct io_uring_cmd *cmd, unsigne=
d int index,
> > > +                                  unsigned int issue_flags)
> > > +{
> > > +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> > > +
> > > +       return io_buffer_unregister(ctx, index, issue_flags);
> > > +}
> > > +EXPORT_SYMBOL_GPL(io_uring_cmd_buffer_unregister);
> >
> > It would be nice to avoid these additional function calls that can't
> > be inlined. I guess we probably don't want to include the
> > io_uring-internal header io_uring/rsrc.h in the external header
> > linux/io_uring/cmd.h, which is probably why the functions were
> > declared in linux/io_uring/cmd.h but defined in io_uring/rsrc.c
> > previously. Maybe it would make sense to move the definitions of
> > io_uring_cmd_buffer_register_request() and
> > io_uring_cmd_buffer_unregister() to io_uring/rsrc.c so
> > io_buffer_register_request()/io_buffer_unregister() can be inlined
> > into them?
>
> imo I think having the code organized more logically outweighs the
> minimal improvement we would get from inlining (especially as
> io_buffer_register_request() is not a small function), but I'm happy
> to make this change if you feel strongly about it.

Yes, io_buffer_register_request() is a large function, but this
io_uring_cmd_buffer_unregister() wrapper is small. It would be nice to
either inline it into its caller or have io_buffer_register_request()
inlined into it. I don't feel that strongly, but this is in the ublk
zero-copy I/O path. You make a good point that this organization is a
cleaner abstraction. And I guess there are already plenty of thin
wrapper functions in io_uring/uring_cmd.c. Let's hope LTO comes to the
rescue!

Thanks,
Caleb

>
> Thanks,
> Joanne
>
> >
> > Best,
> > Caleb
> >
> > > +
> > >  /*
> > >   * Return true if this multishot uring_cmd needs to be completed, ot=
herwise
> > >   * the event CQE is posted successfully.
> > > --
> > > 2.47.3
> > >

