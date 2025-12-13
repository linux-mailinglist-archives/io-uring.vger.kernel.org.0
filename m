Return-Path: <io-uring+bounces-11034-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 87901CBA4FD
	for <lists+io-uring@lfdr.de>; Sat, 13 Dec 2025 06:11:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3FF34307566E
	for <lists+io-uring@lfdr.de>; Sat, 13 Dec 2025 05:11:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C980821CC64;
	Sat, 13 Dec 2025 05:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VkHSvc9O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA241E22E9
	for <io-uring@vger.kernel.org>; Sat, 13 Dec 2025 05:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765602680; cv=none; b=NZiv3kMIWNCGpIfW46GR4gPH/AGvE1qfjfPXwAiB+dIA0jOM+G/79ws0kdE9QYWjJCCwpI1cNCr5rIxkwNGzt5fKC8uxGKaaPotWwPJniHnsabZ8IVNCi7sIuixJC67+KN6F6l1FPL85nzcNGMTGpmPMV2Lo3ozUj1ksS7cEopc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765602680; c=relaxed/simple;
	bh=syEV0/FLiHAZC/PAiurnsJLsnmdLwzHGRNM7kYJ3f34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hOPL8GOhI+IRj9rFruHAyEGCbIgTk/rpNRnSCg0ek1A2gkrJQzQ311lRcPMmXsjcHgdDqLMSTsXpLMTNjalvZPg8Q6LCn4D/B9nprejRhYs1R9zS04m7NH0sgEdMdt4G1N/pg2ooiKCC2CEtgtngnHEFR2UvFziR1bbL0AUfgLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VkHSvc9O; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ee0ce50b95so16455411cf.0
        for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 21:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765602678; x=1766207478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5oO5mXc19/bkHG/OQGgSGSbA7Gcjm1z9eNxoGQZ9t+I=;
        b=VkHSvc9Oi2JBzsRKuWS3MDfb7LqnsdaZmclzB9fjqVByXfOJgkStSzmJYSDSZD6+/u
         LYBQYd29M47yB2ShQ9YW020Mb53yqp4Zeb/igqtGaY79tjTrLUpQuBBckkJRejT7Bk/Y
         pDy/9CVKY7w5TCCXofXymafURT94wauKVBZefP/up2r0cf41O+RLJ8fmv7Q+Bcf4qgpZ
         35HDKuDeTN0SOTbr7eUAQgdeF26qk/4u1smCeCLcx0a2eLKRdDRhLNoYugJAsW3ltIKw
         0msLt6CIHsD2y//CMlJAvjx/tZ1x53pWQhpvkT/UX7JvuQtSc0hUylxaCcJjph2ctz/B
         2OjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765602678; x=1766207478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5oO5mXc19/bkHG/OQGgSGSbA7Gcjm1z9eNxoGQZ9t+I=;
        b=ConvrlMuQKSu/xHYVNgKuHIOgmkYJ6mfmXnjqxcrWzbm1rn9ehkcD7yc40LOScDJfP
         utCgwNmG9MwOfYKnpVJDxpaGawZ+5BtS85+HFBnkUuo5I6MZMAy2VRJ+BbHV/IImZRYk
         p3whuoyJY0j415qrHkQ3TGZ/x3oLF0lVM/OUmJisgxVMmhIYGgXZOh/pdQ6dpVZYIu1q
         x6xJIFNen8qpN67INz8jx2iLFr/e/ePzdr/IK4vbRuiqnr5AOQk2ckn0hIVocYG3MawC
         5xOHH2HmA6iIi+YdvDR0uKGelBWuGcfwWIejljH32144uDhvKjWlpSszAoIiS9k+OERO
         xedA==
X-Forwarded-Encrypted: i=1; AJvYcCVdj0DuJutvkJeQKUQq043mN29zJU0hZAGA2h1K1qOtARptsDBUVgrot/8vrZy7FMY96arX3AAoJw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwA3ZAe4sI+1TLgf2ZwOEEvjI15JSmaKUfINChzvmqgXZfzlrjL
	JBkOoFkAkdNqC6GxBSJQAyYVsnIxpRmbNCjwEEZ3WrvaIZt6gYb5JtJ08gIgEMm135DM8q1EVs5
	EW1ZfArxSgi0nP3adLtX/5bVV+FPM4D4=
X-Gm-Gg: AY/fxX5GQx8A9bz0/lm584ltaNV+Qqmh3/Ym7qXe3SAF62QshcvLVNIKo1uENo2Dbqe
	hdV8u1oHPndmfajVFNqOw7Nso+DaRdqxfo9SUV59XtprASRqr5/qCI7TP72xze6h0uaCK+iN31r
	zesrobeVwIfFp26ik+X4K+VTGbH7B/qck1Fa4brL2Hv5MtTao1TxlmwM5/XZiiCwmRmN2Fl8BQ7
	AjDLH7SrVv6vgHOlDD+ptqzKaway6uNfQj0v8Xo+C38MKvSzNXp+Nm8qPQ8xvnDjJviKovX
X-Google-Smtp-Source: AGHT+IFQfKyFwrVgAa+rr2QG+mOZUqAjIMt/0Uer3JkOvhELpjGEVT9Hh/oikQx7a29AZ7c+bGtB4lPzPQvpV4H6kb4=
X-Received: by 2002:a05:622a:8cf:b0:4ed:2715:6130 with SMTP id
 d75a77b69052e-4f1cf614407mr57782791cf.36.1765602678144; Fri, 12 Dec 2025
 21:11:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-23-joannelkoong@gmail.com> <CADUfDZp3NCnJ7-dAmFo2VbApez9ni+zR7Z-iGsudDrTN4qw1Xg@mail.gmail.com>
In-Reply-To: <CADUfDZp3NCnJ7-dAmFo2VbApez9ni+zR7Z-iGsudDrTN4qw1Xg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Sat, 13 Dec 2025 14:11:07 +0900
X-Gm-Features: AQt7F2rpMQBtSK4ORLC2iykOw4xczA77OTsnQlOWjzyhrCf2eU8E3aMFXaonYHo
Message-ID: <CAJnrk1YO+xWWAQtEvk_xAsoBStRR=o0=t3audmmGrEpKpYGPpg@mail.gmail.com>
Subject: Re: [PATCH v1 22/30] io_uring/rsrc: refactor io_buffer_register_bvec()/io_buffer_unregister_bvec()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 7, 2025 at 5:33=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Tue, Dec 2, 2025 at 4:37=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > +int io_uring_cmd_buffer_unregister(struct io_uring_cmd *cmd, unsigned =
int index,
> > +                                  unsigned int issue_flags)
> > +{
> > +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> > +
> > +       return io_buffer_unregister(ctx, index, issue_flags);
> > +}
> > +EXPORT_SYMBOL_GPL(io_uring_cmd_buffer_unregister);
>
> It would be nice to avoid these additional function calls that can't
> be inlined. I guess we probably don't want to include the
> io_uring-internal header io_uring/rsrc.h in the external header
> linux/io_uring/cmd.h, which is probably why the functions were
> declared in linux/io_uring/cmd.h but defined in io_uring/rsrc.c
> previously. Maybe it would make sense to move the definitions of
> io_uring_cmd_buffer_register_request() and
> io_uring_cmd_buffer_unregister() to io_uring/rsrc.c so
> io_buffer_register_request()/io_buffer_unregister() can be inlined
> into them?

imo I think having the code organized more logically outweighs the
minimal improvement we would get from inlining (especially as
io_buffer_register_request() is not a small function), but I'm happy
to make this change if you feel strongly about it.

Thanks,
Joanne

>
> Best,
> Caleb
>
> > +
> >  /*
> >   * Return true if this multishot uring_cmd needs to be completed, othe=
rwise
> >   * the event CQE is posted successfully.
> > --
> > 2.47.3
> >

