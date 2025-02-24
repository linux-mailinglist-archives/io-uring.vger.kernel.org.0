Return-Path: <io-uring+bounces-6722-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49749A42F4C
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 22:39:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B88E3AFFE0
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 21:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78F6A469D;
	Mon, 24 Feb 2025 21:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Wt8iXrEu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4321F19F48D
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 21:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740433191; cv=none; b=SUgknr3xtQBhmWFn4rA4IYW8rJUN6ne5Siws/igP4wrWWU0ALMkoJARNV1ieFk3ksH0BnoeNUfiiOWIR8iBR7X0Oc9rxT7orqmZ7LX83zpsxlQiGAhZ4lCgJCyoGLR7rgr7ILyTHNaMV5NLaCF2v77HYOGjDij+m477ew1Mf0lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740433191; c=relaxed/simple;
	bh=9FTBOSdhT8Fk49aybKjxWWzf6EmwXh52+BABmAiLiFs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O35s/rBMh2t+knuD0bMFz5JEGXanHvqRg+h3iVwIBZGM7FoXDhKsZoObpTYq3Mix42leS96umDfnxJhbgWDnn4FiyurjUhEhSxBBD9ShDb8TPmfSPgecag8T7C5kpRaYTQMDqX4nL6J5ooeioArXagg/Mf551uDYnJNesAa4Rjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Wt8iXrEu; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-220c3e25658so11656885ad.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740433187; x=1741037987; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HbT5GxY7U8d29szFcIEb937yeprNIBlLXP0MxBpt1uw=;
        b=Wt8iXrEuMVsAb+Im1xMoSggQl9BdKe5nHqgzSldeJ8HNPNGZVroA1CkFvWAo/uQ2DN
         8jaBoJY1PTNRPr8GMBrGm63SqKDguqNggbRiX/IdwkBnnw/4a+ejxVb0AExxnNi/682P
         WAo31zjd53E5rSc3U2WFrwwQiIveUPPBSuCWcPk8uv99b802wJELniwRsIS/xQF0x+F8
         N1yUaiqfmK8eM0xca4uziVunqBxLONnxkRFV6JJ47Y2BEuCGskAy9pv9sK9Z1xLvv2IH
         XXUIqmA08E1rG3mVcZatDhfBcwH/fFoG2A74vsNp6Fxxc3oGDqWLyRno66aqTGJjoW+T
         5CZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740433187; x=1741037987;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HbT5GxY7U8d29szFcIEb937yeprNIBlLXP0MxBpt1uw=;
        b=d13QwTerH46VWDdWnSxjPVTPJN5jWOMGWcCrxTvYi99z3PcwETIv1/WqNGsieq1TLD
         DptL0Mw3Eqm4+ocfLH2s0Zx7Beoni1bHDZec5nHjPD/bGD96+ufy0AtOJ/3Pzr29Sue2
         8ffEtoWqYh1vJFU8KeLZ6TVB2+INqkYsgw4czgzZBcBdC2HIF3tvMMVJ2jKpwG8aNYIN
         yZK1bqtk1IZX1yQtFoRCggM6//kb9sfiRvJllZj21pruVV3ExBpgNFXYojlRKLs6vm4t
         KRsF7UVKXH89Ps2dN8dfy4FxLOLdWJHgofUz/213iDEW21a9r3taEUKJL2K3zVlHlHF7
         8qTA==
X-Forwarded-Encrypted: i=1; AJvYcCWl7NXTN+3PcEtJw1wRurqJeuo8AylfRLinRa5haC6EFeCBnHC3gpuxy1p87ZkutFKJCFvzWFulTQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf3v6WZb/qR2Y6HWOlDEC34BqXuhTl8sJgrTOaxp1CnfcABKcF
	NLaH+DDMpyrr6o9YcjM0tKbnNDrCPVBgOGWXpcqeTETBJa0Fdi5HdwvO1fkyMrtlkInkpRMSCSE
	kwubCAiku/7vty6ZIce2TLvtQMLZadb6CPxKMJA==
X-Gm-Gg: ASbGncvtMYPnyzz+SOR5aYTDGpCNeU9c6WMJZhiQlKYfKCNUZkptWd2naDp676GWzmF
	NcmFWjPPHSMMCm4L7//C4N/WQqeC8lSaJ1iVSuwIiIAuWK0y9kv4jOJBF/wCzy7rK72poA1pHnk
	QpnQqZsZE=
X-Google-Smtp-Source: AGHT+IH8rrLIdP/vBzrKzcBOAgB0iZOygLzf1jzMPI39fpDZZ3eZVixpVuQWLyQGQvndxOTo31U7KHyiT902oOEaGTM=
X-Received: by 2002:a17:902:e884:b0:216:3dd1:5460 with SMTP id
 d9443c01a7336-2219ff4e2bdmr91667145ad.2.1740433187429; Mon, 24 Feb 2025
 13:39:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218224229.837848-1-kbusch@meta.com> <20250218224229.837848-6-kbusch@meta.com>
 <CADUfDZq5CDOZyyfjOgW_JE_A_GWLscZkbJDgQ-UKTbFC66FjKA@mail.gmail.com> <Z7zeNLEnZqsniK69@kbusch-mbp>
In-Reply-To: <Z7zeNLEnZqsniK69@kbusch-mbp>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 24 Feb 2025 13:39:35 -0800
X-Gm-Features: AWEUYZlp7pcVXtW5Q-RqbTsTSpF0m36Os2YU2YRa2vl7senSIcqny3nHoyNmlGk
Message-ID: <CADUfDZqF-AV7MfdXHchxgQRLMFuLvbOoWkzZmki4_L5upKcs4A@mail.gmail.com>
Subject: Re: [PATCHv4 5/5] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, asml.silence@gmail.com, 
	axboe@kernel.dk, linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2025 at 1:01=E2=80=AFPM Keith Busch <kbusch@kernel.org> wro=
te:
>
> On Tue, Feb 18, 2025 at 08:22:36PM -0800, Caleb Sander Mateos wrote:
> > > +struct io_alloc_cache {
> > > +       void                    **entries;
> > > +       unsigned int            nr_cached;
> > > +       unsigned int            max_cached;
> > > +       size_t                  elem_size;
> >
> > Is growing this field from unsigned to size_t really necessary? It
> > probably doesn't make sense to be caching allocations > 4 GB.
>
> It used to be a size_t when I initially moved the struct to here, but
> it's not anymore, so I'm out of sync. I'll fix it up.
>
> > > @@ -859,10 +924,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *=
ctx, void __user *arg,
> > >                         }
> > >                         node->tag =3D tag;
> > >                 }
> > > -               data.nodes[i] =3D node;
> > > +               table.data.nodes[i] =3D node;
> > >         }
> > > -
> > > -       ctx->buf_table.data =3D data;
> >
> > Still don't see the need to move this assignment. Is there a reason
> > you prefer setting ctx->buf_table before initializing its nodes? I
> > find the existing code easier to follow, where the table is moved to
> > ctx->buf_table after filling it in. It's also consistent with
> > io_clone_buffers().
>
> Yes, it needs to move to earlier. The ctx buf_table needs to be set
> before any allocations from io_rsrc_node_alloc() can happen.

Got it, thank you for explaining.

Best,
Caleb

