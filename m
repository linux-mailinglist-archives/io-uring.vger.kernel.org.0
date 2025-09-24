Return-Path: <io-uring+bounces-9877-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D8E5B9C27A
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 22:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88F287ACD1D
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 20:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A97F3148C7;
	Wed, 24 Sep 2025 20:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="DfKN4HLo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930A73128B7
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 20:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758746263; cv=none; b=VRcvcvd0s71EMWGjWon/CiT7+idLtG0ItgQ0qqjUwptUEpGArLusF0fOdINtDQj08oLewLIuCk2tvFlT//hZfKsvSX7vCVfzaWBnXwIHg1PuNrx2EEUi4HZlcsbWSr+cvsxueIRO3wgNuqdFcwYYkG8xxzxKruAbCDNWVBxLVAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758746263; c=relaxed/simple;
	bh=tkRxggpc49uVOux44S6pALbPaEiOcHuoA3JzhABYaGA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VCRflY0L6m0SJte0P269Xvssi5R0kgaJgv4LKATnOMsvkTcNW8YGC/gecpjk2cXR5rT+BA9TdU92pZLPIiR+RpDnwtTS44RRyHuEKdernCs+j0WL9U4coAocnqhKr9pjuvdphncRoKuaBxctLmvAuJlkHhpNhyDSMIS4MLYUgxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=DfKN4HLo; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-32f3fa6412dso41616a91.1
        for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 13:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1758746261; x=1759351061; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eh8F/fVgcxqUnBwIA9IkqF/OC9VkfN3bIgiJaJ0S+nU=;
        b=DfKN4HLoEZ3PgUx1ooFcsbGSxOnYFTbd5xbZ4S1sf8TxJZVEtwpMCGiW0+Hg0wmW0b
         HAv040NWYeJbCsu+sKHmFBYakiyRcxXlEvIun2q7Fw5+ZwRTcxUnL+EW9wfmz75jBIxV
         Ap9vls0msLEmrkOsTdv2njnD1+ETRKko/kxFNFQV9QBLCYxP7CdhIWcbL5wv0dmE0Jeb
         Yzs0PKXixUI5SE1OawCPvPSw/W7PjtHXcbRQDhd10lf8T+IF17ZaLwwvMQqL76GORe8F
         hqCLf0GJKEQOzcZtXRGPXFbMFQwif+MBt8COxEL2LDoldO2a5ArnNaYUZmV0sEo4Xuhq
         W66Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758746261; x=1759351061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eh8F/fVgcxqUnBwIA9IkqF/OC9VkfN3bIgiJaJ0S+nU=;
        b=dS1bOoOsetAIBc9eXSez67ohfM7ZjLBpC/O30fjYef4QOJZ2lIiQki8dm8TKrLxcdf
         sxayH8XB6i/6qloQdQIK0Balf37WCIqKYURFsIV87e633uRFb3ANXl5kaMtrT5u08eIU
         qWZqQ9hFMjtW2rdJiFrdkIWmk2wxFsQi00/k4P4i0SGLEVAOF0GDJdR4NhsqABiuF44K
         ht+vtRMb4UgAGu9PPVVDsiQwqbggG1Z4hEXxMbE0IamBNbyKsTvj82IL77WpsDA/FGrm
         sDci36nyRIdK6u08ys36eKfDjKA2DKcroPfV7TFm53jzvJbm6NSz2G0B38dNMCCiAfgO
         TqiA==
X-Forwarded-Encrypted: i=1; AJvYcCXrzUOMwFueCrK5AOZ0G4OuePTD372k5pQITx2Lx5fjcKodo+VnznsZUTocsGThcOtd9PnFgCtKkg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbvNeHJiTh2QJ6OR96eO8TxcYWt2AQdsH9nSI9t1inih/GUKKy
	4fmeQmXC2SCmJCiNa5G+AUghYKPzn0cQQ6BM2VGJ6orJmeWA92dWoUslU+MmfUu51Vt55oC3q2v
	QQsWcqTqVwBEMK6q2hhzIXarBaY/8IVOR6S2iSwLch5Fr3VuitqjEpj0=
X-Gm-Gg: ASbGncsRIxGSBn51bUO9g5OSPETRqS5YVIsOHdHUr/63//K11ofKAAN0SsaTUKZlJfb
	XZV58Pr0aLThiJ4UPPgZRgmSrDFeB3DT3YzxX9MezjdcV8P8554b5KBvz01MzFqYiuCbstJWDot
	6d9IYWs6CoAtZmEhu/2/wgkjR8hNWm4ff5Zi8TrJ7I0P6EUOj8qroMEFVLDqlINmenPUgXOArdn
	ZgC1ofLumsehtZ7OWmEWyoMHV3dSGOXjpcJC5k=
X-Google-Smtp-Source: AGHT+IEAxmTpsYlv+z2aJ8t4NSn9y4IMt9afRAgV6HkaCP+fsg2Kzaks3uNIpSDcso9423yv19DDbQYbZ2Fvffiqxyc=
X-Received: by 2002:a17:90b:4d0a:b0:32e:64e8:3f8c with SMTP id
 98e67ed59e1d1-3342a2582d2mr564577a91.1.1758746260902; Wed, 24 Sep 2025
 13:37:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250924151210.619099-1-kbusch@meta.com> <20250924151210.619099-2-kbusch@meta.com>
 <CADUfDZrmFphH5AwNkLs=OtPg9qfnpciJB--28PVQ4q=5Fh21TQ@mail.gmail.com> <aNRU0fStL1YuEBSf@kbusch-mbp>
In-Reply-To: <aNRU0fStL1YuEBSf@kbusch-mbp>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 24 Sep 2025 13:37:28 -0700
X-Gm-Features: AS18NWBLkJhgINS9hTS1QofAQcOodg38IPG5CUM7iLFGwIysAFt2LlMtei-Jj2o
Message-ID: <CADUfDZpk_=hjtMRT_ze67qqeX4Rd1dYJLrdnT5WfQ+josVUrVA@mail.gmail.com>
Subject: Re: [PATCHv3 1/3] Add support IORING_SETUP_SQE_MIXED
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org, axboe@kernel.dk, 
	ming.lei@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2025 at 1:30=E2=80=AFPM Keith Busch <kbusch@kernel.org> wro=
te:
>
> On Wed, Sep 24, 2025 at 01:20:44PM -0700, Caleb Sander Mateos wrote:
> > > index 052d6b56..66f1b990 100644
> > > --- a/src/include/liburing.h
> > > +++ b/src/include/liburing.h
> > > @@ -575,6 +575,7 @@ IOURINGINLINE void io_uring_initialize_sqe(struct=
 io_uring_sqe *sqe)
> > >         sqe->buf_index =3D 0;
> > >         sqe->personality =3D 0;
> > >         sqe->file_index =3D 0;
> > > +       sqe->addr2 =3D 0;
> >
> > Why is this necessary for mixed SQE size support? It looks like this
> > field is already initialized in io_uring_prep_rw() via the unioned off
> > field. Though, to be honest, I can't say I understand why the
> > initialization of the SQE fields is split between
> > io_uring_initialize_sqe() and io_uring_prep_rw().
>
> The nvme passthrough uring_cmd doesn't call io_uring_prep_rw(), so we'd
> just get a stale value in that field if we don't clear it. But you're
> right that many cases would end up setting the field twice when we don't
> need that.

Sure, that's a reasonable concern. Perhaps a helper for initializing a
NVMe passthru operation would make sense, though maybe it's difficult
to do that without requiring the linux/nvme_ioctl.h uapi header. But
regardless, it seems unrelated to the mixed SQE size work.

>
> > > +       IOSQE_SQE_128B_BIT,
> >
> > I thought we decided against using an SQE flag bit for this? Looks
> > like this needs to be re-synced with the kernel uapi header.
>
> We did, and this is a left over artifact that is not supposed to be
> here. :( Nothing is depending on the bit in this series.

Yeah I figured this file just needed to be updated with the current
version of the uapi header defined in your latest kernel patch.

Best,
Caleb

