Return-Path: <io-uring+bounces-6880-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D750DA4A7BF
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:58:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0711189AB42
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 01:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4048616D9C2;
	Sat,  1 Mar 2025 01:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="WOvjmXLc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC6314F11E
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 01:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740794320; cv=none; b=Qu1bFero5ieTjPJ0r/i39Bxdb71YtmjPZkd096C90BMpQC30L6UMJeSeNsmLUAEqEH1L1xvzjqS7jonkwUtsMohHaoe5PDknWf5Bjo1kKEbBM1hPA7U66hWfwZf+IJjr9aIkCaAC5INUeDjplpE7AwezkydhP4Jhp1uSSuPuyzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740794320; c=relaxed/simple;
	bh=Pf1AvH0BJiXTAGFPu5FnLQtIPpm6imf0CnVkvS9dyVs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iteM3z/04GLLxktEmlr2/gc8z8FVT3vbF7uRgLPb84ksrREEQA3irz5ugS9poC1m5B7HktFNIFQ+8Yxw6ajJVrNQznARQdbdVJqEYenYgMySRT6lO0nAFBXEImukvo+lqxH58CTDhaX6D6OxTdmoOkq2gILm92e0n+RNo+C7/28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=WOvjmXLc; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2fc92215d15so671763a91.1
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 17:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740794317; x=1741399117; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+Eiw6WhUYWTWQLvwakMpwXnmpwTj9SBwXUOxoJbM4I=;
        b=WOvjmXLcGRHjAQZy4Eio4giKfyjOezOHjyeM2xkDvjMw8S2Zc/2OX9AtJsZJ7TAVOO
         t8ARW2uXuNn3qV8z1OztunNq5/biL//74RT9+hTOwiXPsFuFgSQ05qbEBb3mzSDlhrYo
         rdAYbeyEHEBe4HIItQyQh06dHRzgRLyH8Z4ACHFeW6pFBBHdP7BsI0pHagHwQrRo6Zjz
         36G4l9mV5iq2slKFbi/EOfqmbovvR+TbRxU+34mNAQibSR6CofzYkS1B+maaTDCWcYS/
         qyuQuS78HNJZP0Ek4wYMh6rmt303W9d7bWtmZqOqa/4psaqgZJwtHwIx6PYMOaNmeFbo
         Z8VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740794317; x=1741399117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z+Eiw6WhUYWTWQLvwakMpwXnmpwTj9SBwXUOxoJbM4I=;
        b=TKS4kk1fsB0sl2PMNBbMsoRXmoJTZaFMYmySU90snd1jqmyzybd2NMO5lWXivpfF9n
         CCyReGG876PFV6LYPotHFKfUtVODHqsZjK21JPnf3bknklMtDdajOFsmnYeWzS/aP0Kx
         vaiaPhaOcelXEIFi0+uXA2W1HL7swBQUjk1ICixk2eq1lV5+AB4e3qp7M9N0cIPSiJC7
         nbG9wZTUvMuN98jmkvCbB98/RjIEYhvrcXVsSns8N/vuL6Jz5U+2In40phJAhzMbe52A
         dJy70dlOZ1E6TmwxjowMLTQdaXoay0JRT2UMegOsUYsXoqbjd+NGt1itQ4rIXNpVWi5F
         XYgw==
X-Forwarded-Encrypted: i=1; AJvYcCW07YbTzGHae+RQUO/LwTrxm6/9R/D6d0VQtREOxhqqWLM8nMuq7xQulvTzbPW5i+C6BH4wXgLPKg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGUNMBjN+7ua6itttCI7fYZ41H+Cnv0VJpyMT3K6MmQD+OH36e
	pjdSU0zZUIrd6IGqrsezjsLCYCwPUOs2/r9b3tbvKxajgiLhQV9e2R/E2rmjdr4c5fLYf1oCySx
	auc0LUPhUFVQQV9IoT4lOFzGHue/FKkwzpFmnsA==
X-Gm-Gg: ASbGncuGwtz8kq4cq9Yr0KsVpgt1+HPh16el5i6rb6YadG6kF7Pr0ptHMJKYoCyAiLw
	S+ncpR4NZ06heB4KBYLfgdAc5uLSAbPtCw6o9qRfgDYPB3mzHk6SG0Rga2h9Ive2jnWIv6hCYNT
	wY8F+irxTEKpY7Vq5aMGH4rteL
X-Google-Smtp-Source: AGHT+IGndh1XRy+jafK12jHb8J9Q+W8JmqdMwvlnzYk31QNXksRmU2TMi1YQvyGddSS+mLYWbDvCeUI3/k5nUfCc8cw=
X-Received: by 2002:a17:90b:3803:b0:2fe:8e19:bcd7 with SMTP id
 98e67ed59e1d1-2febabd5637mr3513676a91.5.1740794317508; Fri, 28 Feb 2025
 17:58:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250301001610.678223-1-csander@purestorage.com>
 <20250301001610.678223-2-csander@purestorage.com> <d4271290-2abb-49ee-a99a-bc8bb6dde558@gmail.com>
In-Reply-To: <d4271290-2abb-49ee-a99a-bc8bb6dde558@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 28 Feb 2025 17:58:25 -0800
X-Gm-Features: AQ5f1Jp0Fi9BrgiNU-W_hwn1KbtF63gE0zx_ZOgKp5IxMfW8m4QCTaEDSBl4Zq8
Message-ID: <CADUfDZq43eAJxsnZ71hnPsoJsM9m7UnLWBMavUYwufiTu+UBow@mail.gmail.com>
Subject: Re: [PATCH 2/2] io_uring/nop: use io_find_buf_node()
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2025 at 5:40=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 3/1/25 00:16, Caleb Sander Mateos wrote:
> > Call io_find_buf_node() to avoid duplicating it in io_nop().
>
> IORING_NOP_FIXED_BUFFER interface looks odd, instead of pretending
> to use a buffer, it basically pokes directly into internal infra,
> it's not something userspace should be able to do.

I assumed it was just for benchmarking the overhead of fixed buffer
lookup. Since a normal IORING_OP_NOP doesn't use any buffer, it makes
sense for IORING_NOP_FIXED_BUFFER not to do anything with the fixed
buffer either.

Added in this commit:
commit a85f31052bce52111b4e9d5a536003481d0421d0
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sun Oct 27 08:59:10 2024

    io_uring/nop: add support for testing registered files and buffers

    Useful for testing performance/efficiency impact of registered files
    and buffers, vs (particularly) non-registered files.

    Signed-off-by: Jens Axboe <axboe@kernel.dk>

Best,
Caleb

>
> Jens, did use it anywhere? It's new, I'd rather kill it or align with
> how requests consume buffers, i.e. addr+len, and then do
> io_import_reg_buf() instead. That'd break the api though, but would
> anyone care?
>
>
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > ---
> >   io_uring/nop.c | 13 ++-----------
> >   1 file changed, 2 insertions(+), 11 deletions(-)
> >
> > diff --git a/io_uring/nop.c b/io_uring/nop.c
> > index ea539531cb5f..28f06285fdc2 100644
> > --- a/io_uring/nop.c
> > +++ b/io_uring/nop.c
> > @@ -59,21 +59,12 @@ int io_nop(struct io_kiocb *req, unsigned int issue=
_flags)
> >                       ret =3D -EBADF;
> >                       goto done;
> >               }
> >       }
> >       if (nop->flags & IORING_NOP_FIXED_BUFFER) {
> > -             struct io_ring_ctx *ctx =3D req->ctx;
> > -             struct io_rsrc_node *node;
> > -
> > -             ret =3D -EFAULT;
> > -             io_ring_submit_lock(ctx, issue_flags);
> > -             node =3D io_rsrc_node_lookup(&ctx->buf_table, req->buf_in=
dex);
> > -             if (node) {
> > -                     io_req_assign_buf_node(req, node);
> > -                     ret =3D 0;
> > -             }
> > -             io_ring_submit_unlock(ctx, issue_flags);
> > +             if (!io_find_buf_node(req, issue_flags))
> > +                     ret =3D -EFAULT;
> >       }
> >   done:
> >       if (ret < 0)
> >               req_set_fail(req);
> >       io_req_set_res(req, nop->result, 0);
>
> --
> Pavel Begunkov
>

