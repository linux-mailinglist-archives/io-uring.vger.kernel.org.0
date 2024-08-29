Return-Path: <io-uring+bounces-2976-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 672ED9646B9
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 15:35:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2158F284684
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 13:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B091B143F;
	Thu, 29 Aug 2024 13:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yk2CnSiD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679BA1B143B;
	Thu, 29 Aug 2024 13:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724938186; cv=none; b=h2SSiWWBVz2AiAOjODcSVnNmse+CK39+qaU6j5SMEYWdtRjSLVC5ve/v8HehCUJ8DzuAVEAIKuK83vE5rhp6b88RbKMCh8XztwlInGyQVCOAKIixJKnDRKisB06P047j/cD09qyNgSuVzIIpWGm/vdx0hHD0TLOVLiaLjy2MCWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724938186; c=relaxed/simple;
	bh=pZvP4akX1FNW4jsFlwLLkJZAHk1+SP6pnWAd6+58RhM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RgRwrvXnGbTKc1/pOpaY09hQ9QOBXnOJWJOUEylKZDpBQMq2hFow9tKiRIyBKdwoxEWdq+i1rdT+3INeGeqt7BKUYfvCDg0Mkx1an7BCQyJcl85mnvw4NMOgNG55uq7D8gu5QXzyeh+hF30gxQ5mi+X0j646v81c9Ti0sl3z+e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yk2CnSiD; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-2702ed1056bso387007fac.3;
        Thu, 29 Aug 2024 06:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724938184; x=1725542984; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZvP4akX1FNW4jsFlwLLkJZAHk1+SP6pnWAd6+58RhM=;
        b=Yk2CnSiDx0hjsvt6ozDIk8rcMkS2ZvpTGnCnKyUjOapyT1ISWAuvhBjoQj1dWHyLNR
         vVZG+UsBVWRRHXj1tz+ihQhlH1UsPyLEilm6id2H4+F2PVXGyUR1Kiksh2XjmOEeG9TN
         2mIuK+0jhiSzLDQZbO/McAa2F4Gjb5fNS5p6mVWWgkCu6+aTGT394zxAy2V9Q7OlrJCA
         CZgFvvt7YIxRIJn3XmoHCy6KLeRvWlym1sEBiVap3mxAywX5fPyBLFklt4qEDnuut8hk
         dG15CEISIweE2TGSqXoVrcFKtlxwMtCFsq+i4rl2wc02+vZVObQKX4OpW3AjmpgG5TaB
         iouw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724938184; x=1725542984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pZvP4akX1FNW4jsFlwLLkJZAHk1+SP6pnWAd6+58RhM=;
        b=Sb+wBcmrtLhvxNPPiE6CFpw+Ad06N7fwnLzH9E3vdTOhteGUd65iSmp6VTReABMgH8
         cW8G2AVoutKK91YBcEQ43s/KkIZDv4M6MtbHKs9Ra9W5DwTHM7lWI6qFoMMoZWLn2QDc
         SmIg0KwuclOdqj7Tey2Ckj5ke/OBYMT+bhfiT5kV9Vb3zgeXIouTKLG409MG3OCwlrS+
         kjDKW/bbpT3rkRGVU/C2zT1WAuweR9F+fHgBuMc9IJquZFehLfxRALBNYC0R0QHdFA1g
         H3uxe/5hc4Si0fEc20gD6FSIjszgjWJDabbP2XB0NphdR0jJWWuqSaZOCt9EUT3mN4Kw
         9Yzg==
X-Forwarded-Encrypted: i=1; AJvYcCVtspTdtv3bJLeSU623yUnjBTHxmc820bkSdU0Gz6D2DjxNMSShJgkzqT2AyVIvTHwayFbFQlbfUg==@vger.kernel.org, AJvYcCWEDsEn7mhwATRpmdtuUiCjmJGFn3ag+c3pP9VRswf0xKYiNbNB/f4YLNF++zZ98pKft8jh0IZ5eQGpcg==@vger.kernel.org, AJvYcCX4KDvsXE+42j3OcbXH9IStBnT+0yHcz3qVx/sA2WT+mQBq3vYzdyP0oYdIwFt5oy0FwgU4yZ1JhFWvCGk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh7ANsM31sFLh8wo8Iy0fDgAMLA4+Z1yilkOH6ojpmKJ17kzYO
	pk7M1vmov4xXzsdz6Q4v0lfs+5B5Uiv2wrq1bw3ghcJNYXO67rFoH1CUEneUnKjTx7oMAk+XsTy
	t+WsXpHJuwxnmpw5Aasxc63/2Bg==
X-Google-Smtp-Source: AGHT+IEB9AghDWmQTaWbGpeIraxIQPqERplZzNtYk9DNetcO5Rt7NpJPuYrDDGDj8FK1DdGZ/2QbinPEhl0Lrhh+j2M=
X-Received: by 2002:a05:6870:f153:b0:229:f022:ef83 with SMTP id
 586e51a60fabf-2779035fabdmr3133038fac.43.1724938184280; Thu, 29 Aug 2024
 06:29:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240823103811.2421-1-anuj20.g@samsung.com> <CGME20240823104629epcas5p3fea0cb7e66b0446ddacf7648c08c3ba8@epcas5p3.samsung.com>
 <20240823103811.2421-8-anuj20.g@samsung.com> <20240824083553.GF8805@lst.de>
 <fe85a641-c974-3fa7-43f1-eacbb7834210@samsung.com> <yq1plpsauu5.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1plpsauu5.fsf@ca-mkp.ca.oracle.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 29 Aug 2024 18:59:05 +0530
Message-ID: <CACzX3AuX9FkxPoBRLmy_HEmu6Ex63jHLyz9Z8fhUd_Y5_MdJyw@mail.gmail.com>
Subject: Re: [PATCH v3 07/10] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kanchan Joshi <joshi.k@samsung.com>, Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>, 
	axboe@kernel.dk, kbusch@kernel.org, asml.silence@gmail.com, krisman@suse.de, 
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-block@vger.kernel.org, gost.dev@samsung.com, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2024 at 8:47=E2=80=AFAM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Kanchan,
>
> > With Guard/Reftag/Apptag, we get 6 combinations. For NVMe, all can be
> > valid. For SCSI, maximum 4 can be valid. And we factor the pi-type in
> > while listing what all is valid. For example: 010 or 001 is not valid
> > for SCSI and should not be shown by this.
>
> I thought we had tentatively agreed to let the block layer integrity
> flags only describe what the controller should do? And then let sd.c
> decide what to do about RDPROTECT/WRPROTECT (since host-to-target is a
> different protection envelope anyway). That is kind of how it works
> already.
>
Do you see that this patch (and this set of flags) are fine?
If not, which specific flags do you suggest should be introduced?

