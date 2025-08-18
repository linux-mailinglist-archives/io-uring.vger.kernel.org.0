Return-Path: <io-uring+bounces-9043-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BB83B2B011
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 20:17:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0CBF4E839E
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 18:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B78A25394B;
	Mon, 18 Aug 2025 18:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jtZkh99D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952C92517AC
	for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 18:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755541021; cv=none; b=uGJF9dAptd62rMVWD4s+Zd2ul1WGl8Z3C8Tspi5ki9TPyNmfRm6j1uc4v4dhBlajiBJwOOgTvfMLY+MRnDJBxIVnOndbZWLfjWcO16cpgOHFrfCUwTaXWFtG/cm9jfrzyRLG15XXyogKud+dau2u1ZFSHDs56wvswXL/GPIpDoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755541021; c=relaxed/simple;
	bh=C1Y1an+sUmj2nAIDYJEW/GfH6u44YkSququT3k6djnw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rp2dBYRaV/1+h9dkcwIsoZErXkOwPWz/gfW0JBV9lHYQTIfN+wXaXvLoFHcr4i+LygOa5FpVh6Hq6aN20IzxFbRE5LRSEfy9ehOeRQ+Qhs2dmmQkOk+SX/FXz8tXbek+oW9gJ6z5V72tGXg0x1qXOxzYMSAQ/KK/lMdpQoExfPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jtZkh99D; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55cef2f624fso1130e87.1
        for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 11:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755541018; x=1756145818; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C1Y1an+sUmj2nAIDYJEW/GfH6u44YkSququT3k6djnw=;
        b=jtZkh99D8KgPXBEkA+bgaXUT2xfiSCjYdn+L2RLi7A46plIvwETQelo0YZidt6StQC
         el00aGuYG23FtcIsELDjrvw53LGWOCZx5qixD4Z+KjEbs7yrfHvctGXNr+s2Hk748g6E
         wRHyuvJYY+Z+tIfJKMeAYPoT5vXOefR81eEhnQUuoawE0kbjqCiw+6gLMnBVeAXCPAIm
         sxITD3dTUozW/Cj8+DUgyequ01SKoWkcC8jW8ZPB/Dq/IZnTR0mqPOW0aYT0be0WAhKp
         TDcoZsxboYttrELHuvtmSwJJDkfq/6M5yG87GE9tjqV1JQc6e+T7k/8S8WLlXrqd7pTd
         pY1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755541018; x=1756145818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C1Y1an+sUmj2nAIDYJEW/GfH6u44YkSququT3k6djnw=;
        b=NiSu48CXtfwn5Rmmb+3uu2rhjUA6gIVHV+ENZt9x0umUGvD/z7Qb4QQUU5st+rVXvG
         ICrVvYHp78oFCF1g25ZdyI62gx+YTbBJ6c9BXcIAWv1DTIapErYdwmPHspvkNJoXCI0I
         hFSsp2OITjVwevFC0bGB8j1M1DF6xc4me4Nj2wVNP2mlMb8tsViebjRzcQJxfHY/2r5Z
         fKN852MENVCWUKMRHWEU6lcpkc77Yz5IusTjo4KbblENvVa+Z0OuVfq8TwQuCDP2/+RK
         4Ih74e20b9fXb5Jko3MgLlkXLBWhiMiGJSJHEUeNqEoJ5b3WMuvBsIbAhZMcvCrTInWo
         4ymg==
X-Forwarded-Encrypted: i=1; AJvYcCWOXR5wrolZ/UDViu2zAsmDlRLjdt1TL2CoukfXsD6mWSnfYVZBTpqzd+xqF4G7OK9wB2AxQsQlbg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsVMvK8emrA5HUKI/LdD9D1mE9p0pwCtq0JPAhZfvRe6Fx3CBN
	oML87YdtVmtrfe7lsDqHqvOUpAIGClMddPce1Fmon/lZM3/YO0MOuSglr3SO9qqQM/2UC+gIe/7
	usEt6ICe17sxn7SbZvhn4hIZPIGff03eE13kMtZ+F
X-Gm-Gg: ASbGncvzmn/kMu+aRuWju2dnACj3yTkvjqKmhDnipdg5BGK9lYxfoMkq/1CWjfiF1nM
	YIjAUAtHvQTOoOnaba7ljY7Py4Uk1rzc11woW1BvkqIszovKzWgTIPJ8pHh+tsaE/lD7PpKF89p
	BXhhnA3xsSApNzHwZJXU7wti48uN5GHocH5k7VEDEPcBytSqBr2PTe3kRMpA9pEv0CyNLGBPzR0
	oH8JxKUtecJByGCei0P8Xsqj7qbOvQXPTplOBPwhui5Rmvy
X-Google-Smtp-Source: AGHT+IFrEtgaEleSS/E7MfEjCCsdfFWnTZVke9fjOnKYpBW8UgHErfLttqygIW2PcKBPJauSEscACtqWd40In8O2shc=
X-Received: by 2002:a05:6512:61c8:20b0:55b:7c73:c5f0 with SMTP id
 2adb3069b0e04-55e000efb91mr11705e87.2.1755541017364; Mon, 18 Aug 2025
 11:16:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250815110401.2254214-2-dtatulea@nvidia.com> <20250815110401.2254214-4-dtatulea@nvidia.com>
In-Reply-To: <20250815110401.2254214-4-dtatulea@nvidia.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 18 Aug 2025 11:16:44 -0700
X-Gm-Features: Ac12FXxbqw37w2Q5TXCoed0lmNK_AKgfOfQNYIHB02CLjHEqLFsUSXJLgNpeSXQ
Message-ID: <CAHS8izMiS-OWASmzy4ZKYrgd50Tj92CkUndC+E12drbziZjE+w@mail.gmail.com>
Subject: Re: [RFC net-next v3 2/7] io_uring/zcrx: add support for custom DMA devices
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>, cratiu@nvidia.com, 
	tariqt@nvidia.com, parav@nvidia.com, Christoph Hellwig <hch@infradead.org>, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 4:07=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> Use the new API for getting a DMA device for a specific netdev queue.
>
> This patch will allow io_uring zero-copy rx to work with devices
> where the DMA device is not stored in the parent device. mlx5 SFs
> are an example of such a device.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Looks like a straightforward change. FWIW,

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina

