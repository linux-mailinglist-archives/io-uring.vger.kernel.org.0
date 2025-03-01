Return-Path: <io-uring+bounces-6901-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB05A4AD53
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 19:26:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C81C3B4C98
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 18:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC551DF985;
	Sat,  1 Mar 2025 18:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="fMRzFkOO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D36219D067
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740853607; cv=none; b=dJgwD7ZlykKVEuG2TPCtL890DOqyZx9zMKXbkSSW1ar1ScOaw79ccMcbx2EpyVn5M0412++AfUlBN/U7FyFJS0M516CydIf5WHwS4VI4f+D2D/rxv7gjbFtPkp451zDseL857U8vquM3yOgas9+P+IExwamoYxyzKyyZBOY6CFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740853607; c=relaxed/simple;
	bh=BUyMLGKoaHqFNhbLKEJ58fyXJjdRMGC55aFapC0p4wY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ee3TFoHFeOioRlkDLf7S1rPqvCvUz88HzKcJ3zzXb5OTwlTzk/vLgMmJM6LaqtuPowEuwBwFxZvgacYNql04Iwlo9MxMX8Mpg/b4dvo/vXNsjekLUSuW8J6xg9kD+6TtLM/Ep4q1JsqD78kcL4hy2jGdt2vINCpEu+c9Fz4AELU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=fMRzFkOO; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2fe99d5f1e8so828610a91.1
        for <io-uring@vger.kernel.org>; Sat, 01 Mar 2025 10:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740853604; x=1741458404; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n1fJlUaLf1gxbdB/IQ3C9C6Fd5Y0TrYQvEpDMwroLec=;
        b=fMRzFkOOKcMjTTlMfvXI6XW6m//lZz5lzzozKlSLnQjxSkA9qOyrEm1haetQuxpx7c
         DfT01qDqg36rU8sS/AqFeDnacj3QzixK7JZTum5kXqicb3GGxeqt/XsJU/fOP7zKr1CJ
         RZsWadzAR0tun23368kJ6MOoWoY7thSwziXsWkyDRuISH4JciN+D7Z6aQ5uXujPne+EM
         xzdtO+hgf9Gq3lzcghkgO3QYN4/QEn2RDKHXeHN9AuL2oF0nE6kJR0Bp2RwYCir3OGk6
         GInDlgaxm4qpJAMbzhBb2BcuIGEU8x9VGDyZ+uA6kfnK42NbMlrUCoJnLM8416+3MW2w
         HPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740853604; x=1741458404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n1fJlUaLf1gxbdB/IQ3C9C6Fd5Y0TrYQvEpDMwroLec=;
        b=vfM5oDyWW1O9QYAYhG8fTQmTuDDhp17+Uz4RRLrVxIJJzEFpSY0qdRDyfitxa2JHgl
         mSIiKqKTHCoAGiinXelIRfQge5P+cUeRm6Vigwk1YTz2lPc5x6scI4y8Q6F3FiZvhcmc
         5OzXg+Gl/UTKou2B+fpfkNAE4KG1FnYBkrla8HnvTu0quXsyhtMbHrjCXG4QAjer9SAt
         LrWN0p4Cfu/WmLpxRAB5yy+l90MtI78zesAel6HvP64L0RedwWR30FYjzlXF4t4uXodY
         thXjvDfChIZEnKwi9f61OC1vscH2uVz/z02Uy84i8NnrZqUGCdBkGUYqKOnvsTOR6dMK
         zl4w==
X-Forwarded-Encrypted: i=1; AJvYcCXno1P+OmvtNMOVTm96cPm9P9IP+GkjncxMhvLrUAxP/Rr1nVGA6TualeHaMJu5q+/Dnjwe903GHQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzZjE0z6I9SuS026Xm47HHAHPC28AtSuLtoWvsnaRrJnBqixVD8
	CRTknPKh1aF0/vatWhasIoUiiQ1G4pG4K4Kq795v6uwSVBOT/cXcUV4DK13do92WMgGy0dg3s4F
	d8p3Rm98G3cvhYZJDHUoTeM9BcnofqLQFwmgutA==
X-Gm-Gg: ASbGncu/9acQIPDzFcV9Q6ArxRbJNvEHSHV3kYROsohC6f3gvkc8Lgixw0a+kgq0BwD
	FkCggrFHzitWzlJXuO4kcYkUBqEsp4JgcwIPExoGKxsfGIwIUBmg7AW0se1JHwGnbx+P9bah3S7
	AlZTDwg5E+raB9BiA3tupVRKx5
X-Google-Smtp-Source: AGHT+IFldxOK6OJbDdbWpVRrspMM77OA3WhEQBn3nrMDky43Gr52XcLxm7oy/5RrmJlVL3sdDmhBzIRbDFjUTuC7qE4=
X-Received: by 2002:a17:90b:1d10:b0:2fe:afef:b706 with SMTP id
 98e67ed59e1d1-2febac10656mr4566239a91.7.1740853604275; Sat, 01 Mar 2025
 10:26:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250228235916.670437-1-csander@purestorage.com>
 <20250228235916.670437-3-csander@purestorage.com> <f74d6e16-29fb-4a9a-a6aa-9a7170c683ba@gmail.com>
 <7d64216e-4bf8-4557-b8a8-7285f161a2a7@kernel.dk>
In-Reply-To: <7d64216e-4bf8-4557-b8a8-7285f161a2a7@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Sat, 1 Mar 2025 10:26:32 -0800
X-Gm-Features: AQ5f1JoAnn34QyE_05Wc_hwwFc2GahHIUfSpbqlLvw2hci4HLHC_a_BQDPGL19g
Message-ID: <CADUfDZqZ794CXKPeXnJ3oX3MrKPg6VtgQATLOTmrMv5wEhucRA@mail.gmail.com>
Subject: Re: [PATCH 3/5] io_uring/rsrc: call io_free_node() on
 io_sqe_buffer_register() failure
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2025 at 6:23=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/28/25 6:31 PM, Pavel Begunkov wrote:
> > On 2/28/25 23:59, Caleb Sander Mateos wrote:
> >> io_sqe_buffer_register() currently calls io_put_rsrc_node() if it fail=
s
> >> to fully set up the io_rsrc_node. io_put_rsrc_node() is more involved
> >> than necessary, since we already know the reference count will reach 0
> >> and no io_mapped_ubuf has been attached to the node yet.
> >>
> >> So just call io_free_node() to release the node's memory. This also
> >> avoids the need to temporarily set the node's buf pointer to NULL.
> >>
> >> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> >> ---
> >>   io_uring/rsrc.c | 3 +--
> >>   1 file changed, 1 insertion(+), 2 deletions(-)
> >>
> >> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> >> index 748a09cfaeaa..398c6f427bcc 100644
> >> --- a/io_uring/rsrc.c
> >> +++ b/io_uring/rsrc.c
> >> @@ -780,11 +780,10 @@ static struct io_rsrc_node *io_sqe_buffer_regist=
er(struct io_ring_ctx *ctx,
> >>           return NULL;
> >>         node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
> >>       if (!node)
> >>           return ERR_PTR(-ENOMEM);
> >> -    node->buf =3D NULL;
> >
> > It's better to have it zeroed than set to a freed / invalid
> > value, it's a slow path.
>
> Agree, let's leave the clear, I don't like passing uninitialized memory
> around.

io_rsrc_node_alloc() actually does already zero all of io_rsrc_node's
fields (file_ptr is in a union with buf):

struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int type)
{
        struct io_rsrc_node *node;

        node =3D io_cache_alloc(&ctx->node_cache, GFP_KERNEL);
        if (node) {
                node->type =3D type;
                node->refs =3D 1;
                node->tag =3D 0;
                node->file_ptr =3D 0;
        }
        return node;
}

How about I remove the redundant node->buf =3D NULL; in a separate
patch, since it's not dependent on switching the error path to
io_free_node()?

Thanks,
Caleb

