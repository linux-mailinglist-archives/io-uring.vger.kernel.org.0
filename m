Return-Path: <io-uring+bounces-10201-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9230C07A4A
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 20:08:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B0943B3433
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 18:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0EEC34679B;
	Fri, 24 Oct 2025 18:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CmsWDbuy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D7B31D374
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 18:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761328951; cv=none; b=DQz0VpKWASrkMTwxnMKPgomyQ6qTdRvTIO9V+tgsds6BFvOVGpdwdRBlTeyprKWCUxboj8oKhmdQeZl3+j/BPuSsIBJ5XInEh5EZgVEQa5WwIE10oCTsht8KBmiPtgoBdrcSGEvAJCaIehgWfnWbsH4keT44nfXwMglLZB7RLJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761328951; c=relaxed/simple;
	bh=n3U5yfkUfv5ArTf3S1cM1mT8QSeYdL4U9ZBKUWuF8pE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dz+oVDjgTA0F7NUBBW4XVamLuyC6gVg9cVN/KU4zSE6P+7BTc/JC5PeCdFgAs5LuayV97IoLC7mhylyrT3EHvyVwKukjlxzcLlN8Fu0HvIZr76QF5aHAolvDMI0WfW9/fP7QCygYRB08Cx2uV6vouZMM7mz1sH/Pf8wuT88V9SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CmsWDbuy; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4e89e689ec7so14705071cf.2
        for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 11:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761328949; x=1761933749; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n3U5yfkUfv5ArTf3S1cM1mT8QSeYdL4U9ZBKUWuF8pE=;
        b=CmsWDbuycSUrehkKy8Y7RaYC5vDfqMeIeAX0gahBFEw8fZUbV9l1ETJ+vf7Zg1ZuKJ
         jUwBktNDx9ORQGR0IawiuiTntbxsNCqVIjlZc2XOSWRxV0JtjYvueE690OrkP6bhiBhS
         Hjz+NalGfXhrqOS14AxJK7ujvSIgp0oQZVyrnjqMk4L4LsdQuCIHpBpZkE1O5UZs9vFn
         iJQKqMslHyQeRj7tEXmy62AZm3oLG0+e4Z3LehcSVoHAE91VJyF2UDKOJtUyZ/eNbtw/
         IIHD90EOM728cI5JkLeHmNSkLXLHgzPWG4DGtOddlpXagbXPW10PNQ64Q0NS8FAGsaZq
         WiaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761328949; x=1761933749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n3U5yfkUfv5ArTf3S1cM1mT8QSeYdL4U9ZBKUWuF8pE=;
        b=o+CxFNXnsGStqZXMfIEtn6eBhVqND1XDH2RpqvUpO5KaN/uyD2Clcd60zrzbEGgyjb
         h+Tq3TkySX/0v+SHsKxcqWHaLEKkD7R18iDTm+YQ1Mf0IvAlBqSeh7GgkI6ewrwkhuRH
         w8w8ptQ62nbF8k5B8WQYyD7/NqFaqUJSR0JFjnO70FnWfJ2d0Wwl6wjvf6HEyqI5n7D4
         JNNqveHV0xOyo/yXs0F/7nRa28Xa8V3DPy/eCbCjDM3JPPALmuERJiwyLEo3jXomJR9U
         4O8LbIoUQBwxpwIpcRAz/Bw+faIpTdqNcAUwbSOjzLGTI3wSOx6nu4mEl5CYdMy+bSlV
         l7Uw==
X-Forwarded-Encrypted: i=1; AJvYcCUlcvoLD3otxXVLe+ZGgwMWpHE3QPbMoL+7ejSj6nWEm75Tp3bH0LSyZgefm0Y6LTrEGSdMQJozqg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy56yCxvgHvrO+/ZWFE15DM3wglwH0VCis94QNu9oCr5nzI6wir
	ldBC3y4QWWbYjk+nCSyyGqGUuKg+Ctqz29sdmibOw7XJpgKsJJR05oPknZXsUE4WxAub8X/Dq9z
	tjVO+0EMgOSrRGSWJGrnKCOzno24k4oI=
X-Gm-Gg: ASbGncsV5WIxtFtJZwc/HHErURVd6nac6OWmEF41kTTX7AEUBwSsMKxwoxSRFXzI8+v
	EHG/Zq9qDbDpdbDSL+zahMk7dG0vu+4a8NHlypUkLPsHkRonyqBRQN/lpA2bW1usOcvVBg7wveq
	QJkjNQ5ucA8FaM7Vn/hzRGPwkJTVHL6er2QAE5rvF5atLdSLmptCU7q23G1F7zr5Q8J9KP+DfqZ
	uo/Xtc3pi0DmeC1OeuHc2HgN9QDyjDjoPD32J3txUDY5B1AnxKhc7KB7z6f+98tJR9784AXOauV
	ONh4rYSOD3ydOn8=
X-Google-Smtp-Source: AGHT+IHOYAhak2DJmJnuD81MshZ0YrIbaQ7SPeN6Q7uc6WwOQ6CGgDUFvv7kdf9d8y+cHCgwg1tX6r6GxCHpt/IRZ+0=
X-Received: by 2002:a05:622a:1114:b0:4e8:aa11:586a with SMTP id
 d75a77b69052e-4e8aa115bbfmr316544311cf.53.1761328948898; Fri, 24 Oct 2025
 11:02:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20251023114956epcas5p33a9384d06985dc5936fd355f1d580fb2@epcas5p3.samsung.com>
 <20251022202021.3649586-1-joannelkoong@gmail.com> <20251023114524.1052805-1-xiaobing.li@samsung.com>
In-Reply-To: <20251023114524.1052805-1-xiaobing.li@samsung.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 24 Oct 2025 11:02:17 -0700
X-Gm-Features: AS18NWClytBndieGCtwSHdHSq8PrGe29hlx395rcvjWj57qenh9N9_zO7YEzOlQ
Message-ID: <CAJnrk1YDkZf1GNNODXemHUV1kOyqXtLtQzODiA=Ujkkc5TpfKg@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] fuse io_uring: support registered buffers
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, bschubert@ddn.com, 
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, 
	joshi.k@samsung.com, kun.dou@samsung.com, peiwei.li@samsung.com, 
	xue01.he@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025 at 11:17=E2=80=AFPM Xiaobing Li <xiaobing.li@samsung.c=
om> wrote:
>
> On 10/22/25 22:20, Joanne Koong wrote:
> > This adds support for daemons who preregister buffers to minimize the o=
verhead
> > of pinning/unpinning user pages and translating virtual addresses. Regi=
stered
> > buffers pay the cost once during registration then reuse the pre-pinned=
 pages,
> > which helps reduce the per-op overhead.
> >
> > This is on top of commit 211ddde0823f in the iouring tree.
>
> Do you have any test data? How does the benefit compare?
> By the way, how were the changes made to libfuse?

Hi Xiaobing,

I am going to run more rigorous benchmarks on this next week after
making the changes for v2 and will report back what I see. The
libfuse-side changes are in this branch [1].

Thanks,
Joanne

[1] https://github.com/joannekoong/libfuse/tree/registered_buffers
>
> Thanks,
> Xiaobing Li

