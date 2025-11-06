Return-Path: <io-uring+bounces-10426-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EE65BC3D892
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 22:59:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B7CAA4E17A4
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 21:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387222E92DA;
	Thu,  6 Nov 2025 21:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JhCVnWEj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891B73081BC
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 21:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762466377; cv=none; b=eA3rD7EfEFaHtozOosHV/PN6wW6pwxQDWQ93XQiQK4t+DBEgowHgAofWEfly3ExTddLe1EMxL+6s7RFMkVSWlIrerRjPFzHUa7oIUDK14RGIDeOkufXsNMVB7RHw4lO1wH2gS6kYfKGAj5BiKNe3+1Jqajj5HdF6ElsIv/tcvj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762466377; c=relaxed/simple;
	bh=HhvKsgN0r6mGQMPzR58FTLKlqZilnJLzKqsEiobmtOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ttk4e4NeZ6xqyeHAQBPa5Pzzt+WNbRCDl9+6JntMhU6Jg1B1NE0MA3GwWxJd6R4CSwaGX8Un+HFa7R9+y6UFPkEONvBCN1nLkRVjMbT1NAZOCDDmkehm0ytwGxCehzp9EmJn/wO1NYksoMn1b/DQXwNZVYWVdt0A5kvFOkhmfOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JhCVnWEj; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4e88ed3a132so1269021cf.0
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 13:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762466374; x=1763071174; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5oZaoWw1jQ++un/u/viLDbLmUB2kF5YuTdAAA/moAHQ=;
        b=JhCVnWEj/ZqYwsGmeHLiQ+Y3T7u95nzcSv05Fci6svOYXde7bjPzSSyAdV5UD7MiEq
         DXuWrQGmkD9y3oNR2seiBx4ZoIQnM9Ff0p4Vx7+3ac7TywIPT1i1MuwE6+aTPqQZ0zv8
         W08dV0WFfh5T+uqTcdUCXNOexBqJX3Q1QgWeHO10hffNiYE2sroK66EXdJTG9WpOXPca
         z0kOSG9tNfOVJ3S04UYMAXGvaMehUtb0HpEu8SDCOKengzaGsqRRNRUg9dgBwQmMHYfu
         PMzc7vZKtJZPLwYLZw9E2LSPtrFova9NrPvs4R9xE92axLIZx0lxsIZi9pSkYTGwdCN0
         EFpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762466374; x=1763071174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5oZaoWw1jQ++un/u/viLDbLmUB2kF5YuTdAAA/moAHQ=;
        b=X+hl+hbopoR3hHswOa05UrWz9VuXAQ64WZRKbdTvdUtKxKYlYKCI6OAGIRTVyZUYud
         EMtvlx9eVjb+AOikVtOGXfC4+kEWmn2v8CfakHIEvxElVIVIbt7Wmg1c4wY5oI801nc0
         kZ6P76Xn8wmP+GkP0yc00c27V7bYiCPIXHX9jC5f76ZSyWDedlXOgvHKSfKMEVejLGYV
         NpCOqtRmdK1qTgRPhG1UOBW22dUi1DRL8EtGpYqWziEF/QjO3gEdamkw0Dj91G1MNELS
         9VrAHks5opW6ADsP99TFu7LGDow713r0gTpuRCe2nTV+HtXZC28c5hryM5N/Bir/V4iR
         LG3w==
X-Forwarded-Encrypted: i=1; AJvYcCWsFJscnUyGiPaqTp2HTO/BXwUz6zGWjXFJvC8MpQIBYIjYv33+xt7bnOjn1NxNx42uWvciAL1Wjw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyuqDPPEmC8HmhOOodIgeaiUq5eBXPrmrUDs8P+4bQz4uFXguKq
	sSb35ra6F85guCel1xh5z/b995awjCRNV1OH2oItNrfNFUzcgp3GyD2PJTZBKLeIMuBIO0J6dxM
	GI0KGKMnN1LRRjmV9O+vEF1sWeY5hQ8A=
X-Gm-Gg: ASbGnctu9MntBjHU8t9NCEQ8p6t8RW4+f6NOjpQspkBdOnhCIZezXr2OX8pozjWrb9M
	gbSCVkOSHO2VsNfZK+Uk2ktWKA96aCzeAISQMcyqSP+On62x2jWrVGM0Uqz4/bfTsSO754WK8Dd
	8enlX4lthLPsXm47M0d9CqvIbFVOIDLUFvw1BXyL7GyNuvReEkRqvQ782EivcE+LGdqBL9G2WmJ
	eVCE1MVr/v3FcA9pFzPKNiHj0SH/f0pdoK5oM0TR6dxz8Oxh+xpS2l0c4YuElbwmvrjMXukq4yO
	Kv9qVfP4JPHjR3w=
X-Google-Smtp-Source: AGHT+IGZcM2LdSWi2zIO5Fvip8+SgSm5P62E1Md3BtKG1att3bkTSshoWQHS+4y58CO5T3LeFPkWKLsl3JbUjjZJnr8=
X-Received: by 2002:a05:622a:1a25:b0:4eb:a715:9aee with SMTP id
 d75a77b69052e-4ed807ee016mr56263921cf.4.1762466374387; Thu, 06 Nov 2025
 13:59:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-6-joannelkoong@gmail.com> <f74e1f05-5d66-4723-a689-338ee61d9b43@bsbernd.com>
In-Reply-To: <f74e1f05-5d66-4723-a689-338ee61d9b43@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 6 Nov 2025 13:59:23 -0800
X-Gm-Features: AWmQ_blEckKSunVwGcW2ZHLIgUvIN0HVUeOunuLlGhN1_WiHg3nEAS5O5St5Lzs
Message-ID: <CAJnrk1apBiPMrDZDyVfLeFKLPdPiB=4e1d7D3QHsX5_6ZtFccA@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] fuse: use enum types for header copying
To: Bernd Schubert <bernd@bsbernd.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	bschubert@ddn.com, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	xiaobing.li@samsung.com, csander@purestorage.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 5, 2025 at 3:01=E2=80=AFPM Bernd Schubert <bernd@bsbernd.com> w=
rote:
>
> On 10/27/25 23:28, Joanne Koong wrote:
> > Use enum types to identify which part of the header needs to be copied.
> > This improves the interface and will simplify both kernel-space and
> > user-space header addresses when fixed buffer support is added.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/fuse/dev_uring.c | 55 ++++++++++++++++++++++++++++++++++++---------
> >  1 file changed, 45 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> > index faa7217e85c4..d96368e93e8d 100644
> > --- a/fs/fuse/dev_uring.c
> > +++ b/fs/fuse/dev_uring.c
> > @@ -31,6 +31,12 @@ struct fuse_uring_pdu {
> >
> >  static const struct fuse_iqueue_ops fuse_io_uring_ops;
> >
> > +enum fuse_uring_header_type {
> > +     FUSE_URING_HEADER_IN_OUT,
>
> In post review of my own names, headers->in_out is rather hard to
> understand, I would have probably chosen "msg_in_out" now.
> With that _maybe_ FUSE_URING_HEADER_MSG_IN_OUT?

Ahh I personally find "msg" a bit more confusing because "message"
makes me think it refers just to the payload since the whole thing is
usually called the request. So if we had to rename it, maybe
FUSE_URING_HEADER_REQ_IN_OUT? Though I do like your original naming of
it, FUSE_URING_HEADER_IN_OUT since FUSE_URING_FUSE_HEADER_IN_OUT
sounds a little redundant.

I'll add some comments on top of this too, eg "/*struct fuse_in_header
/ struct_fuse_out_header */, to clarify.

>
> > +     FUSE_URING_HEADER_OP,
> > +     FUSE_URING_HEADER_RING_ENT,
> > +};
> > @@ -800,7 +835,7 @@ static void fuse_uring_commit(struct fuse_ring_ent =
*ent, struct fuse_req *req,
> >       struct fuse_conn *fc =3D ring->fc;
> >       ssize_t err =3D 0;
> >
> > -     err =3D copy_header_from_ring(&req->out.h, &ent->headers->in_out,
> > +     err =3D copy_header_from_ring(ent, FUSE_URING_HEADER_IN_OUT, &req=
->out.h,
> >                                   sizeof(req->out.h));
> >       if (err) {
> >               req->out.h.error =3D err;
>
>
> Reviewed-by: Bernd Schubert <bschubert@ddn.com>

Thanks for reviewing the patches!

