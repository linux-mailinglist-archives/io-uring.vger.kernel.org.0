Return-Path: <io-uring+bounces-11556-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C861D06E04
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 03:43:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 949623015EC8
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 02:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD1B6316909;
	Fri,  9 Jan 2026 02:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="OqYdaRkk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4949C316904
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 02:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926616; cv=none; b=PTimfV2M+GBQtzmdoj+EpQ/IDtYKNkCfN66FvFbhXi4qZ8fqRc5WdCpDeLX+uLl8A5Jet30rGKHfbIrJPf8S+W2yZbUuBZU6yTsViNyDFc8U/lMbb3uF6HO8iNn1nQ6fGAqmKZJBES8cfMtljrGWX38MEnqOBzHiKeszeKKPJRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926616; c=relaxed/simple;
	bh=31vJYhUYTLE28Hpclzdc9C16YqvRvnCq+iuIWtrzsv4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VlTZfIP9HHNafAIr97KJm4DKR4/EGfamLCLzSgoYrZAn6HHuDUu6YhDP7ddHJd1pXnU3TB2C+QZrEO9CJOE6hHdV8mhNrTTf1CXmO0le62xeOT0B7Pro0VbZ/5YdMuz1OSoTYbTMPYswSyN1BUt/yLwpdHlFy3q3l3bgpL1gOb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=OqYdaRkk; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-121a15dacd1so298656c88.1
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 18:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767926614; x=1768531414; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KuIP2NVdq++SgGIo2WGA+xm04D3PzsWEchd6P2Jj/Xk=;
        b=OqYdaRkkXujBFfwbPkw1wpC72S/frwwZYJgZRjIKV3EcuwhKD4t7ajT53anWj7JCZx
         GeYje2uL4K6xsKxh5nOJoGqbz6lGLIyCrwje8SdZktDgG5HOGYJFVxDkMvwlEiFxmfr3
         VPTLJOP6BnhCtX3wpdiSZawZsoB8ZucekEFHDayi8M5f2GwOdhnBg5+7oTNRdAJdun9z
         yzVko28N0UuiFiqDAgKPfYxDn3nrYZOhdNrCvpZBd/JnK05htxXQ/4reGDD+G4i9vci0
         iZ11DWMcBuySL+8prqDnANLxY2EAVttsx1lX9dugnJ2NyUsHcldFvXxs04Jb/RERnLmA
         sS3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767926614; x=1768531414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KuIP2NVdq++SgGIo2WGA+xm04D3PzsWEchd6P2Jj/Xk=;
        b=Vc9ZdFHMcK24ExmnTGlxkLSLlOYCg75apx05+nzUFw0aInny58BK+jZnGFyXbKA9/n
         bHKkt3zyjq2mpECZ5jraHf7wYkhHzJP+eP0tUNVfwS5ZFIHuAuW1ycKntHNcV5czP4sB
         oXYWY2klJCdEQkrnZSa131HOBSLfXPT18Il2hsh3g7UFtDtnp87BV0mlNv9VxyolFxgq
         gxIR1Eg4fH+lgu14tq0A2MfG7inHpBoOL7K9KDXZI7ft4pS1Nu6/8y+KTQwLCt3DAN+A
         bvGvrN3xsGithLdxss+MWQ8gjmeK5CpUwkiJDCRZUw5eJLnUs2BhGihS6dvt6HW8b73x
         txYg==
X-Forwarded-Encrypted: i=1; AJvYcCUurgs26bstVNZ5iKMKswQFyv05k//ED2C5Q3IwDeDW1FRL0lF6D/79EPtNkl6Jxp5cuiJepOCYXQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzIDmnaR3iAHRJsCAV0iaGYhya6wEUIkesG63nNgoafKpgXSDl/
	2jU/B43Mp2b1YutwH5jGSuW3qckoM6Bk6iVy21YMODtDPMpj+g44YNXIIVZc7L1PYWOUmFatiGV
	NKqJ5G5ZdXJ7j1guu6CLOjmyRDN5qZqA5OjhvpSauJQ==
X-Gm-Gg: AY/fxX6CAWiEOQadbmr5CcjA3qGY6/V2uqhEaY67e4NOj54nPSF5EafUqwFZo8hYp3/
	FzWuTPULL0alSUOruet9ilDsGyP6Cvdq8b5IGdBM7seYTNboBwB9YXyPGVI9BIvUqCJIvy8kg01
	qK1FRITohruikogblXgGQws7AJewQ3QrgWLvA4kq++732IF4d6WyR6WjvLKbiRedj0+6PVjy3Sc
	M+MEoXAL0IavZmpl6Tmg1VtV7a/xFIK57dED5Oe0fGtfNhXJ98C4fdwIZdTjtm7lezGA2WsKNTj
	319DcZU=
X-Google-Smtp-Source: AGHT+IFHht8LNLu9wC1vNjgcK5ZNYQwytH2g955mA0hstC5639tu7p4tomNGAaRkQ9kqG0TffnahHoCsCHzAzUgZkhY=
X-Received: by 2002:a05:7022:2217:b0:11e:3e9:3e9b with SMTP id
 a92af1059eb24-121f8b60647mr3833271c88.6.1767926614213; Thu, 08 Jan 2026
 18:43:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-11-joannelkoong@gmail.com> <CADUfDZqHhVi1RY71dvEFbWsHmrzLbTSgev5o8yRXxExV5=XY2g@mail.gmail.com>
 <CAJnrk1ZQqgQmQyC8v47rpP0TrpcwGRzw6r9w4Z=TQO8EpQOF3g@mail.gmail.com>
In-Reply-To: <CAJnrk1ZQqgQmQyC8v47rpP0TrpcwGRzw6r9w4Z=TQO8EpQOF3g@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 8 Jan 2026 18:43:22 -0800
X-Gm-Features: AQt7F2q-gqNpugddpUigjhF-0Ud4D2b2rNKxcVUgfWOMT58EjgRYljFXh3fQwR8
Message-ID: <CADUfDZpjx2trr5GeyCjidZx=i_2YKW+V=Ec6Pk6um8yLU7KAQg@mail.gmail.com>
Subject: Re: [PATCH v3 10/25] io_uring/kbuf: export io_ring_buffer_select()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 4:38=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> On Thu, Jan 8, 2026 at 12:34=E2=80=AFPM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > On Mon, Dec 22, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > >
> > > Export io_ring_buffer_select() so that it may be used by callers who
> > > pass in a pinned bufring without needing to grab the io_uring mutex.
> > >
> > > This is a preparatory patch that will be needed by fuse io-uring, whi=
ch
> > > will need to select a buffer from a kernel-managed bufring while the
> > > uring mutex may already be held by in-progress commits, and may need =
to
> > > select a buffer in atomic contexts.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  include/linux/io_uring/buf.h | 25 +++++++++++++++++++++++++
> > >  io_uring/kbuf.c              |  8 +++++---
> > >  2 files changed, 30 insertions(+), 3 deletions(-)
> > >  create mode 100644 include/linux/io_uring/buf.h
> > >
> > > diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/bu=
f.h
> > > new file mode 100644
> > > index 000000000000..3f7426ced3eb
> > > --- /dev/null
> > > +++ b/include/linux/io_uring/buf.h
> > > @@ -0,0 +1,25 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > > +#ifndef _LINUX_IO_URING_BUF_H
> > > +#define _LINUX_IO_URING_BUF_H
> > > +
> > > +#include <linux/io_uring_types.h>
> > > +
> > > +#if defined(CONFIG_IO_URING)
> > > +struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t =
*len,
> >
> > I think struct io_kiocb isn't intended to be exposed outside of
> > io_uring internal code. Is there a reason not to instead expose a
> > wrapper function that takes struct io_uring_cmd * instead?
>
> Oh interesting... I see struct io_kiocb defined in
> include/linux/io_uring_types.h, so I assumed this was fine to use.

Yeah, I see a lot of types that look io_uring-internal in
include/linux/io_uring_types.h. I'm not sure why they're visible to
the rest of the kernel rather than forward declared. But Jens please
correct me if I'm misunderstanding whether these types are meant to be
private to the io_uring subsystem.

> Hmm, we could wrap this in io_uring_cmd * instead, but that adds an
> extra layer and I think it clashes with the philosophy of io_uring_cmd
> being a "general user interface" (or maybe my interpretation of
> io_uring_cmd is incorrect) whereas this api is pretty io-uring

That's my understanding of io_uring_cmd too.

> internal specific (eg bypasses the io ring lock which means it'll be
> responsible for having to do its own synchronization, passing the
> io_buffer_list pointer directly, etc.).

That's a good point. I wonder if there's a better way to encapsulate
this for general usage outside of io_uring? I'm not that familiar with
io_uring buffer rings, though.

Best,
Caleb

