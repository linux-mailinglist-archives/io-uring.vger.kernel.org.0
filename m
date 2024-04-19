Return-Path: <io-uring+bounces-1588-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BFB88AAB36
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 11:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5C13B20E22
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 09:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341A773518;
	Fri, 19 Apr 2024 09:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="IyECAjlz"
X-Original-To: io-uring@vger.kernel.org
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5AF5FBB5;
	Fri, 19 Apr 2024 09:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.81.211.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713517821; cv=none; b=Buez8dwfCMIRgevItCP3fkQgfr4UlkSoPr0QXQDlcqVsvFD5wzkhzPYXmU4Z001UqqJhp1ZZMwxuEEGGkzGSp/vjS9Ij0aCmhnE2+6hRUTNoP171YMPtaYoCPpB6EzBedgBAr47d95udnc49GUxSyPMOPtYgYojG/vdXOp1t5aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713517821; c=relaxed/simple;
	bh=FUyrDkEoZkFe3j2Sa11pBqz9kStQx6lt90ArRaAHaYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q2wzrzmSXok0JDAfWe0UZgam09UwWFrJbsfRu3NPu7DTABwkEeEj+8RywoM0qjipdXa1Sl1aUPKzvXNWegt6eNSRfyAsM2ankhZjZf2XmHCClEDQ2EIAYznlpCySM+5BsMMjbwQc5WKV8VqhjB9QYIXgqAIkAvJkNoSM3oDgmTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=IyECAjlz; arc=none smtp.client-ip=51.81.211.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1713517813;
	bh=FUyrDkEoZkFe3j2Sa11pBqz9kStQx6lt90ArRaAHaYo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IyECAjlzs3S9RlCI58V209dKzrihrBf2qjZXpTpVQA/pl8gcbkwlPhSZ+cD/Gl3/+
	 MNP0IcdBK2bVd4vNtIPWmFL5JXmci5q+p/GjXQr9sSwnH5yBNJoqYOOInBvyNQOpOk
	 oeBW46fJmUdwO3+wSdIK7lDrIyHk3VGp4BR5LjHof4A0KIhCFeTBDNH3hCqa+ih/vL
	 4mvcZ7/nysID8rjWrtzpiGZK+JTAg5EAsaiz6z17XM9zYbxl4NRY4Ev29VZC+e4VjV
	 yPS4DnOPVjiFzsNvDxtHgIpyows6BYdf3eMCcUBeOgNYwFl7e1f7oJ7PnFTO139JCj
	 ElyuRYd0nXhtQ==
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by gnuweeb.org (Postfix) with ESMTPSA id 616FC24AE8F;
	Fri, 19 Apr 2024 16:10:13 +0700 (WIB)
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4347cb2bf76so3686681cf.0;
        Fri, 19 Apr 2024 02:10:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUOGYho+A2nxpv0r8Eji6Ww2HtUn/Uvsg9Nrgi/55BsNF6BjZRJTiaq8AUj6exiaufe50HX9JgZySCU9ufoIlxhYGNUnmWFw2M=
X-Gm-Message-State: AOJu0YwkR0mJpf0odweklFg+6UH+76pGD4XTCovmwMBvUiYIE+ySNttQ
	gXU3byWMZ1bDV+Z/AeLmOrl7FY+KpmXgOr9aD6SnU+PayysxJhfKp3rsKHz4UHFSKtq+XVThoDQ
	t4+LGK0p6UEnOawzaUChcfFI2BF8=
X-Google-Smtp-Source: AGHT+IFj+cSkPdz2w+IhOOTokNmm/YCqjbL32GYxwRwPZRXBkNU3JOplf6dRnMwoK5oQU0GSmh//6qWnbFlYZLRnduQ=
X-Received: by 2002:ac8:4e21:0:b0:438:d78f:66a7 with SMTP id
 d1-20020ac84e21000000b00438d78f66a7mr310205qtw.0.1713517812443; Fri, 19 Apr
 2024 02:10:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240418093150epcas5p31dc20cc737c72009265593f247e48262@epcas5p3.samsung.com>
 <20240418093143.2188131-1-xue01.he@samsung.com>
In-Reply-To: <20240418093143.2188131-1-xue01.he@samsung.com>
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Date: Fri, 19 Apr 2024 16:09:56 +0700
X-Gmail-Original-Message-ID: <CAFBCWQJAjef4AGXmVDZ-dR02zqstpXuP_mWimsF5HQCMxxeCcg@mail.gmail.com>
Message-ID: <CAFBCWQJAjef4AGXmVDZ-dR02zqstpXuP_mWimsF5HQCMxxeCcg@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring: releasing CPU resources when polling
To: hexue <xue01.he@samsung.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	io-uring Mailing List <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Kundan Kumar <kundan.kumar@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Wenwen Chen <wenwen.chen@samsung.com>, Ruyi Zhang <ruyi.zhang@samsung.com>, 
	Xiaobing Li <xiaobing.li@samsung.com>, cliang01.li@samsung.com, peiwei.li@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 3:47=E2=80=AFPM hexue wrote:
> +void init_hybrid_poll_info(struct io_ring_ctx *ctx, struct io_kiocb *req=
)
> +{
> +       u32 index;
> +
> +       index =3D req->file->f_inode->i_rdev;
> +       struct iopoll_info *entry =3D xa_load(&ctx->poll_array, index);
> +
> +       if (!entry) {
> +               entry =3D kmalloc(sizeof(struct iopoll_info), GFP_KERNEL)=
;
> +               entry->last_runtime =3D 0;
> +               entry->last_irqtime =3D 0;
> +               xa_store(&ctx->poll_array, index, entry, GFP_KERNEL);
> +       }

GFP_KERNEL may fail; you must check for failure. Otherwise, it could
lead to NULL pointer dereference.

--=20
Ammar Faizi

