Return-Path: <io-uring+bounces-10059-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A81FBEEA0F
	for <lists+io-uring@lfdr.de>; Sun, 19 Oct 2025 18:28:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01458189BA2F
	for <lists+io-uring@lfdr.de>; Sun, 19 Oct 2025 16:28:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3018D2E8B93;
	Sun, 19 Oct 2025 16:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="O+0yFi98"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774302AE68
	for <io-uring@vger.kernel.org>; Sun, 19 Oct 2025 16:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760891264; cv=none; b=KdVA9vm4y++IDjx64agLd2oPLgB0y2Y1++gGBlGVHQ+dFUJPC52kSHAUNdH7kWfr6gxWyVO1QGAK8bgo8Zqj0yptNp6C1GbE89B2nk6rB2HIqj0JicHTWXZtl6pKhThkN71ZeDS1n1QVKou1dtdw5JHsl3u7QNWbq5Ghek/Pme4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760891264; c=relaxed/simple;
	bh=QcTCkGIBUYzYO9QHpMoxKyB4r8Lskydg5ShbpSGUnWU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gvTfdrXePRAB7+LqkJXbpq1x8i45W2MRdQFCB6E+AxPhzecIruc6HObABYPr94/DJievG+EvHV41cVMZrkTEUNxxMFaSpuGLgtGoQRzuvAwoCKJJcjB1emFq+7Ut/xQVpfbQfDCLNAeBbObFj50kOfSicDtuGYVaN5ke8bi8BZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=O+0yFi98; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-339d7c401d8so911992a91.2
        for <io-uring@vger.kernel.org>; Sun, 19 Oct 2025 09:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1760891262; x=1761496062; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FOucnwwyBoO7lPGnZlMQL7im09iFXKmmatT3nYofhW8=;
        b=O+0yFi989RvAU7h+x4taCbhciDYgewjzn6RDls6j5thGBpYdeqF0Q2z67umbYpmH1K
         oFJUYH39lIZeBi9y6zYfvQBVCKwfJRG8XKVEDZuAM3daiEliArvI/UaV1sQk9YetQm9Q
         OhMXl0pYCj/asmWCVIxWq73pZaTd+wfSOMpkR+GInx6/H7gV/RWD1yEDbDAE+igOXtLI
         AJHGf448EC/HsnInKvZ6TmeL1pcRLvu4o+CqRuHeclaDW4l2W5YaFfLn1UQePI2R5W9X
         GLPfx8kzFGXemTuX9ALzNY7iU1rTfDgd/VKSNiPqIuhHW9zyDsqacPwzenDiOHwoKlKo
         yHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760891262; x=1761496062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOucnwwyBoO7lPGnZlMQL7im09iFXKmmatT3nYofhW8=;
        b=Czp+ulA5k+9fHP4dEtpfJejkRIJhWjG18SXZwpGbfqiSkXLYG6yhxdboEzn1WkqSBR
         MhmXzB9yhi445ZHdhAbEFlp+qRPT7iM1kDBByRSAAgLDkU6zeKkjO+rVD53+LMb7XSsu
         oJ+qVdf2rT+2hP303UgnwWFS0cdqCbeX9iN847sA5GNIcAmpe1Z1g3V8yrQK67DNN0tT
         MoXZB9lovV27ULwhquHH4P/Z1ufR+hioREQtIymTSvNt1a9L7UFiaThCn98MxVDufaOI
         PR7pV+ZoMDb1kBDNfKuRNdLS8V8xkzwutom5Yl32vVSqT88gFATWe4FDwI/Z0dN/W+91
         K+ZA==
X-Forwarded-Encrypted: i=1; AJvYcCXK3C/DcAaFKjEcRIGH2y3gYRmDeKcFecC861XEqLUoi7PAJnHcI5KmYuWx2JS7z537Ean9OoPbEA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgDr+8cqyeQrJKYlXHHVgj9qvqIBiKTFoMBy/ZkhcuBZ+7rbH8
	EYZYfjtKhfCoN9dYlBJBE3pHwYeyBDam+7ebZiGVONzB75ry4ECDmF6fM2/R4FuwhOu0xxM6GQI
	FBApShpgIvffgitOUpSkhedE0zvcEkh/i5W2wQHU6u2tylY3m++JGXBw=
X-Gm-Gg: ASbGncuUhM82oSH1UjEolLraM5GY9WkqT9+gpWg5883BVAMAQotzWnMRPomNHbIWi9i
	m4K6MqY9j5eb8OxpOhO3qvxX5xmhvQbKWrVhTbEKNE/UDE5cfclz+g3xctvk7sw6Orj0W7rSY+j
	OzcKSn+g37e5jTMplwBkBtHmCeNyTkwC5F87ZBCW2rko8oPYk6e/GRI1yQ9hSwyGJstiJPVqkcY
	caqcYcom0s1eby7pssMY8bnr3X6vvVaiLVV64IOnRR+2kIMaQk79zZ6HJ4Ii1/YN1DlHrtu2P/1
	mdYE4y8OaaMSYpewGywzGEGZsh93
X-Google-Smtp-Source: AGHT+IETTBmNeD1aTmXDUg8AHv6G+KLh1f60332iBI/2olUBUwWx+aPKq3I8VxnolRbPXq5wojGXr3FQWdsC5d44tQo=
X-Received: by 2002:a17:902:d2d0:b0:269:96d2:9c96 with SMTP id
 d9443c01a7336-290c9be9e1emr69495455ad.0.1760891261611; Sun, 19 Oct 2025
 09:27:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251018193300.1517312-1-alok.a.tiwari@oracle.com>
In-Reply-To: <20251018193300.1517312-1-alok.a.tiwari@oracle.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Sun, 19 Oct 2025 09:27:30 -0700
X-Gm-Features: AS18NWCuECNhL2eXcyeR4kKduJIVKZxx1l-510D6hAUjXwdUjvfZ3Acl6f0L0Jw
Message-ID: <CADUfDZpGh0HeUDTkRFQVRq8skAKS_OSvSmJ3u+Sb1RmxoHWnaw@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring: fix incorrect unlikely() usage in io_waitid_prep()
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, alok.a.tiwarilinux@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 18, 2025 at 12:33=E2=80=AFPM Alok Tiwari <alok.a.tiwari@oracle.=
com> wrote:
>
> The negation operator incorrectly places outside the unlikely() macro:

"incorrectly places" -> "is incorrectly placed"?

>
>     if (!unlikely(iwa))
>
> This inverted the compiler branch prediction hint, marking the NULL
> case as likely instead of unlikely. The intent is to indicate that
> allocation failures are rare, consistent with common kernel patterns.
>
>  Moving the negation inside unlikely():
>
>     if (unlikely(!iwa))
>
> Fixes: 2b4fc4cd43f2 ("io_uring/waitid: setup async data in the prep handl=
er")
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Other than that,
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

> ---
> v1 -> v2
> Remove misleading "constant result" wording and
> rephrase commit message
> --
>  io_uring/waitid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/io_uring/waitid.c b/io_uring/waitid.c
> index f25110fb1b12..53532ae6256c 100644
> --- a/io_uring/waitid.c
> +++ b/io_uring/waitid.c
> @@ -250,7 +250,7 @@ int io_waitid_prep(struct io_kiocb *req, const struct=
 io_uring_sqe *sqe)
>                 return -EINVAL;
>
>         iwa =3D io_uring_alloc_async_data(NULL, req);
> -       if (!unlikely(iwa))
> +       if (unlikely(!iwa))
>                 return -ENOMEM;
>         iwa->req =3D req;
>
> --
> 2.50.1
>

