Return-Path: <io-uring+bounces-4595-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D45219C398B
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 09:16:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44280B215EA
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 08:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C6C915CD55;
	Mon, 11 Nov 2024 08:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DOvEBdgY"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E6514885D
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 08:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731312984; cv=none; b=f7viGe6TBPTQDSALneASlBWfmpSclj58TN6OfOAwmBwRWjk+K5apCjiuvr6BIRM1ta9V27p9xn9hw+FeTsjFK6iJe838rZRAsAdOuMVTtls5JNh+YjLMasfEZ+Kzf1YUushG3KYvf7aMDtqdZW7pla01Rgr5x9vI40Ual5ceUU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731312984; c=relaxed/simple;
	bh=/DgzjMSagDpsiKkAI13Vi3hCzyv2nW9w5Hb5qz4D+Qc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rzHQF805zcCtia48eHljW+nFqzek1JAEjt5zblCL6IXMOCV1U78Tooau5zrNIcYqj+gVvsafL8tN7FRIhx6L4HxwZezZXQ5Ae9on63nVJr5mnwVf93CCgdDDFGazCw27LS0508TKa3aSfvFjPBUTZqV+xB9/lhwNcgwwrsgEFAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DOvEBdgY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731312980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sswn/yWFXh/I4+VJKZQA7OtGWIn3XUvK0AhEuoM2v3s=;
	b=DOvEBdgY423E+6VB/lhNzLYb1AdCBkmQmJ+eie2d43df2AfnOUQY7r9H+SKIlNqdS/pKoy
	maNlF73nDanLixZsyIuhj5y25ZKeeOZpS527UpdivANTdJhEU2l/hZ5y78kGWATZo17bgz
	OvVN7Wj6DwGM3X57Slf+TBY05XDdCco=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-R4vb4iFmNKexqIzWM6Qztw-1; Mon, 11 Nov 2024 03:16:19 -0500
X-MC-Unique: R4vb4iFmNKexqIzWM6Qztw-1
X-Mimecast-MFC-AGG-ID: R4vb4iFmNKexqIzWM6Qztw
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a9adb271de7so366488166b.0
        for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 00:16:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731312978; x=1731917778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sswn/yWFXh/I4+VJKZQA7OtGWIn3XUvK0AhEuoM2v3s=;
        b=EOZEf7HqBHsMAFy10vax1u2yhe51ZjEX96AgSg87KR7vKlg4t3yadbFGykuXF095nh
         KYgHDYiB19U/H6Q3khZ8zHc4Y8frbegxx67bexVpJT0OQuvg6xyQT9aSIQLUqsSyNJ3X
         ePrKN9RtTOI0BEaNRR511YH3kNQfPuKKr0TOq3nvU+aZ/2qaJA0X5l16q36DeODQLaUW
         hUAXl+a9RvWK7oqlO8SWBY5WqydPQItN3kRYulZFE1HXFXKZie+NiiZ7v81pm4tL8ib3
         4t9CPnUjoNH0bnLRyqqx3nnFTfM3b53sJwPGRMNRExG3cNIJJiqJDYDlcmRPZgu1CL+b
         Yc6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUltEn7t6lqeowgYS6lhmyEBnv3iM/SbhX8FOZ+J8QKGjC1UdOoVMQORfu2kcV9skPUQTiDt6gaLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1anrX4xg/LRxBnHV8hVHCfHynwvo15pq9Tpx1sa2CbCFDtaLA
	mYcsMwgQx9tPeXkJfUQpACljnuSPjM/k9dad+2QkV/5Bh6jnJ0+uImFWfiduUG6riYXH3JsGk/N
	ox5j6kYu75PkuhcBNJhn5BLrW+ohjCHuNYNMM56C9CcTkCMi4oSZNYaZA2kfvdfPz1j+CVDIYOG
	FuFkIgwcNaGRTB8qOVPS99a6CVtgEsViE=
X-Received: by 2002:a17:907:842:b0:a9a:1792:f24 with SMTP id a640c23a62f3a-a9eeff0eaaamr1146295166b.24.1731312978012;
        Mon, 11 Nov 2024 00:16:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGVUiOT1WItFcquK84t0eVWA13hCGajjuhTweC1hSCd69LhRZj/ezlUq86TAsfwHnJEPo77diKMKZHFU7UiK9w=
X-Received: by 2002:a17:907:842:b0:a9a:1792:f24 with SMTP id
 a640c23a62f3a-a9eeff0eaaamr1146293366b.24.1731312977673; Mon, 11 Nov 2024
 00:16:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGS2=YqYbvNi6zu8e9e=R+gZMKwY_LegK2vi2MSgdsL1pMyDLA@mail.gmail.com>
 <ZzG3Qk0wvKR67CoU@fedora>
In-Reply-To: <ZzG3Qk0wvKR67CoU@fedora>
From: Guangwu Zhang <guazhang@redhat.com>
Date: Mon, 11 Nov 2024 16:16:06 +0800
Message-ID: <CAGS2=YqS=euMO5-mBU10p7pKMbRdfSGO4q-9cpg12uOm0PU7mA@mail.gmail.com>
Subject: Re: [bug report] fio failed with --fixedbufs
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

OK, will test the patch and feedback result.

Ming Lei <ming.lei@redhat.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=8811=E6=97=A5=
=E5=91=A8=E4=B8=80 15:50=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Guangwu,
>
> On Mon, Nov 11, 2024 at 03:20:22PM +0800, Guangwu Zhang wrote:
> > Hi,
> >
> > Get the fio error like below, please have a look if something wrong  he=
re,
> > can not reproduce it if remove "--fixedbufs".
> >
> > Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linu=
x-block.git
> > Commit: 51b3526f50cf5526b73d06bd44a0f5e3f936fb01
> >
>
> The issue should be fixed by the following patch:
>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index e7723759cb23..401c861ebc8e 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -221,6 +221,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe)
>                 struct io_ring_ctx *ctx =3D req->ctx;
>                 struct io_rsrc_node *node;
>
> +               req->buf_index =3D READ_ONCE(sqe->buf_index);
>                 node =3D io_rsrc_node_lookup(&ctx->buf_table, req->buf_in=
dex);
>                 if (unlikely(!node))
>                         return -EFAULT;
>
>
>
> Thanks,
> Ming
>


--=20
Guangwu Zhang
Thanks


