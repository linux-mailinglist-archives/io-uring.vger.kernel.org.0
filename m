Return-Path: <io-uring+bounces-8063-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EF90ABF7A7
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 16:22:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A2B418895B9
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 14:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE26518D63A;
	Wed, 21 May 2025 14:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HfooDQCT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87041A3165
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 14:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747837294; cv=none; b=eeTqREsB4S3btnH420o+6b51Pgh0Fj3wrL4LksKrEslrv3R5+O5bQCEJJTsxMx0zeMcN6tEft3H9vwFgbm0dMQwU2VKMC5Hcr71xhrFUOd6Fe0L2NfR3mMJGEmLQjzfCsGrGYan7q1OMbm03Hr/Wlaa+WiIZ8r1pyysMNhHDIr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747837294; c=relaxed/simple;
	bh=BriCSPpif43hz8yA3BoP4QGZiWa6nqsEeaZrDKbv+ZY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dIhE568ZX3tg8s0GK9MmBf9VPS9lNKFE8sgf5g/fhAS5KIOP5R9JyB9HOz1aeJyiz9K8fZ24+3fdhtKDiN6ePCcpZ2MXJJL1RvsSvRqNGtaoENzDyl1EArL5HIRiDlGt+vu6II1UaW1I+LjiG4RmVTU0m26h1e3jiE7LM/fsnK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HfooDQCT; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ad5394be625so290445066b.2
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 07:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747837291; x=1748442091; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BriCSPpif43hz8yA3BoP4QGZiWa6nqsEeaZrDKbv+ZY=;
        b=HfooDQCTYCl9AFV4hmAwZJfRJ81XRIVFqEhkVqkAjDMz++0r1kch6bDmK2SoG7E/nJ
         tUyaigTJoui7SJVBLJO+d6/bq+FsqCHOGLLTbY6IE2t81sKE/Ael24zJkh1u0TATcyG3
         z+WUCJo2HwLDSjHs/HRPl+wARNuy+G4oAiFb+wB2fBN1/x2l4XM4il3aUU9kWtUlRWgj
         Qq64fAJj1BIXsdqT7yQKHfVlSG2BTvLRIQo6K6fggO6jCIMzepEWCyf+CZRr7eTlzhNm
         hAYq+fSwNNR+esT1Aw35WPW9iB+mnZbt/g6qeU1M2r8VG4fyDzN6FOaXhvDvSA9xzLfN
         gxig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747837291; x=1748442091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BriCSPpif43hz8yA3BoP4QGZiWa6nqsEeaZrDKbv+ZY=;
        b=sP8OhT2t5/l2y68jCTSBGMvBtKWdL6J2xwKhVZhwiy5BFXhyhCUxbBVn2oO1KBJlTQ
         ErE78SickGrsjCXOzlJB34in5IOOEWvxG5aem+YZYgipL2dkvw3gVOLwTkUxit7ONwFZ
         UGtaqb41bezjuZf1/6z6fTpldY2xv404Jp6wLQcVDUAd6ctqiW9StpJao0JylLWKRmG4
         PlK0/fVnuo/misWQTMBHKw3c4M0tfRO9VSj0n/jW4rs4G5+tmHtyA+rHVvOw9lWh74Lg
         pe3BLmPBCndpeKw0ESWNPwCz2tFzMnGXhCBcY8W4KugqipX8dUF5qRcgc7JBDOHaDxJ2
         fLLw==
X-Forwarded-Encrypted: i=1; AJvYcCXi86nqzFGdJdziV+KZX6VhBYLO6rWdUcXPCGP6v4Jg+eBi4HWYj0QPtRDiK/GN3T+8SDPWlqw8WQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YytThf0qFkvv/lgC6RxxppE6ANFDH0pKja0Pfkp1o/U+d3KbClA
	Nn3CcbGa0E+8LBIdEd67aZ02rCWadjmgPtUEPr8G5A6CQuMWOErXxKDYP/1SXBaCvA+IyYFykG4
	cw8W+XMYeohRaO+3wTTDjIiZh27rorQ==
X-Gm-Gg: ASbGncuLdgSa84ulqkVXqiJlrs4jtdrfVEp9Yf/NN3PnLh/AFBbP59vAEbsUN8jrlBn
	bMWZyP3RiH64oEsNYwb0uqy4U+tm46gCEtC817j8FGlx514g1KWYTVkZXvAELOwUUZGdBO862uP
	NB4qb5JaaqLnOaUTfF6qc+OoxDXA3eVeY=
X-Google-Smtp-Source: AGHT+IF4We/IYiF5FMYBzJCiEYH4gUmhz6eB8F+7JGUTFTGisQt8UKJRLqOl87DMUEd3y4E+58ewZNYADoAkdy3jwTQ=
X-Received: by 2002:a17:907:805:b0:ad5:b0c3:76ec with SMTP id
 a640c23a62f3a-ad5b0c3781cmr218045066b.37.1747837290898; Wed, 21 May 2025
 07:21:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20250521083658epcas5p2c2d23dbcfac4242343365bb85301c5ea@epcas5p2.samsung.com>
 <20250521081949.10497-1-anuj20.g@samsung.com> <7e846c8a-3506-4581-bbc5-fdf9e084a5bf@gmail.com>
 <CACzX3Av3G1K0aoZXDOHjfT=Su6G9D-_RyKWjdMwsNpba8T7CFA@mail.gmail.com> <5b728d70-d698-4997-a5a3-5e90ae93daf8@kernel.dk>
In-Reply-To: <5b728d70-d698-4997-a5a3-5e90ae93daf8@kernel.dk>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 21 May 2025 19:50:53 +0530
X-Gm-Features: AX0GCFuS0UFzip5Gl_V8uFleFRogxa-WNMsqtHCJoVxfmJJGQXvJJyNGwxdmxRk
Message-ID: <CACzX3AsdtuTuxXU+GUdh_GWPJUhuEM4uiTSHJFtHMqMogvxOtg@mail.gmail.com>
Subject: Re: [PATCH liburing] test/io_uring_passthrough: add test for vectored fixed-buffers
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	io-uring@vger.kernel.org, joshi.k@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > Regarding the vectored I/O being limited to 1 iovec ? yeah, I kept it
> > simple initially because the plumbing was easier that way. It?s the sam=
e
> > in test/read-write.c, where vectored calls also use just one iovec. But
> > I agree, for better coverage, it makes sense to test with multiple
> > iovecs. I?ll prepare and post a follow-up patch that adds that.
>
> We really should ensure it exercises at least the three common types
> for iovec imports:
>
> 1) Single segment
> 2) Multi segment, but below dynamic alloc range
> 3) Multi segment, above (or equal) to dynamic alloc range
>
> These days 2+3 are the same thing, so makes it a bit easier, as we
> just embed a single vec.
>
> Bonus points if you want to send followup patches for both the
> passthrough and read-write case using eg 4 segments or something
> like that.
>

Thanks, Jens. Makes sense.
I=E2=80=99ll follow up with patches to cover all those vectored I/O cases.

> --
> Jens Axboe

