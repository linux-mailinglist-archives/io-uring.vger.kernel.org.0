Return-Path: <io-uring+bounces-4716-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB3C9CDFF2
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 14:30:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1313F1F22940
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 13:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF9F1C07D5;
	Fri, 15 Nov 2024 13:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e10ZpYOG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62811C07C5;
	Fri, 15 Nov 2024 13:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731677392; cv=none; b=S/ryoDxIE4tJL2uVQTctc5BOSZbPf6h6XLFnX/FO7bBxnGdZ4HuLVGwK9vKfSUa0M6l0XtbIc5jAQfgVLWIhlYrXQCRNya5BqTjCVDv43cqSyQ9vIDFJ8+i+PjmT99MGoadbXsgPsRyXNOcKkz6tIcfBEouvPk7qKXb7jRzXGPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731677392; c=relaxed/simple;
	bh=J/5ZDP8yvp5xJV8M6LlD9Na/ogk0y+HnBPjWwxvT0Uo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ISjGHHVFjWrPne++zMA1LiGcEquetTLJgs+YTlxRlLo8KT4VvlDi2GwEgazVX7d13g0IUZXNUqi/2QG2SUXejVgOiPJsP9xfY/0qgHBMMhmfdpukrAEJSx3SxjvfRxCT0LhG4TmTv4d5ndIZyjVJhk8Ao+2pUlL06hpc7b8D3Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e10ZpYOG; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5cf9cd111ecso342156a12.3;
        Fri, 15 Nov 2024 05:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731677389; x=1732282189; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXyAxxnKLpgZmGT3ZHAoHzNaVqLioXGnV41IMIjl6Ac=;
        b=e10ZpYOGXLB0I4FRAn2tWsYwb7Bl/E3d2XZofmgYyOgivasDX7iAEdr4geUjwdxv5/
         1TGVJv2yTsBlx8qzAxNU0Dbc2UoNDX9bEPZS7olYRXmZ0qpIcgxzwzn7ICRI4XZYlVxi
         O5wV15dbvXuKfXc5ec4NzgS4nM72ap8U/IhF1FX8H96cMOS+sKoiRGQYN9dnAy5NvB44
         d37RwDO64ZI6wuu4H0VsqQkHcr7LYC06k5rCxnDeAQwOjHLgqvJ4cGVSQDQCBH+3FBj4
         vqQ/FUsRm30Juaf81SmOUHe4KB/P862D4TeCI/Z5bboY8K2FXyEvmSdbeHVSM+uDznSq
         nhdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731677389; x=1732282189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PXyAxxnKLpgZmGT3ZHAoHzNaVqLioXGnV41IMIjl6Ac=;
        b=DNzaJd/BYeiZFB/zEpsWjgYaHE9Ez1oRn4jaY9pUJxT8/7C39Btk04w5vdYZaRctlO
         gJeG35v8lHGlPBne0gnqvkx247ah2bvtABIcxdzUeWL4hXTemnUSbrGAr3Lz1uSuFzpR
         5x1pjSLEwFoYQt3Q3GV7Ijf3pRI+8cFJqKz7MRAeB80NP8nrh4YIdXxABFUpD9GKII8t
         lHV7Li45u2Z0Ptb2M3fFsrXMVB7FWNkNnA3r46Ag3X6WN4yMw7Rc9l5O0k379MD0KUm9
         mqFSeFml9dLvIWVXfkyQQpRyLxoQ/6KoAsSVQKKPTRVSCKS+lI9gNi3ZOs+Of6q0KUkG
         nPAQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3BLsG0sxonhnDmfrhQ+/wUpIf7DchKfC+wgLaaX18vC/ZT6lWmVcdqy51B6b9obs/5AWwh/a6eg==@vger.kernel.org, AJvYcCV8emCuU7QBUIu1SHldD5LpNsGNk83JPwacgOVMJBKMdaPFdVCcN0H/j82QjQEEjUIZvGFFXzQS1MSzC8U=@vger.kernel.org, AJvYcCVvrQ9zcBcRPmwqlojZMMhDTpl2LO2oNvi6qb97zW067lr2getIrzJK2v1I7Me2TA+I0S6yz4x/0yYB7g==@vger.kernel.org, AJvYcCXi1mHIFkxseSLCeJ1JYDLb0413TjtCt/tIltWQxnUIzUcqUz1SebKZ8GcPlB2RZ898FV5LVjvQPlnOAPShSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfQR0PX6JIs2sD26y2rK/9MDbNk6Svz9J3+jozk/uSJ09FqFK6
	jGLD7KDxOTsa40eCF2gbtvKiIUbIyOJGx+fh5KVM1MGR2pVAqjDd6fQXhX6FVfmmeqGuAg8QqxV
	wzfgMkcJ5pkMj6zB0IzJgkvub+w==
X-Google-Smtp-Source: AGHT+IGqWKTlmFq3/n12hP2Y2a/LRqzo/oZoAMzv7wmcNU8urPo976WbIba/QasmZjKbU6xrICmiEgAE4o4NmycRUDo=
X-Received: by 2002:a17:907:3f25:b0:a9a:2afc:e4e4 with SMTP id
 a640c23a62f3a-aa483557d9bmr200273066b.59.1731677388795; Fri, 15 Nov 2024
 05:29:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241114104517.51726-1-anuj20.g@samsung.com> <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>
 <20241114104517.51726-7-anuj20.g@samsung.com> <20241114121632.GA3382@lst.de>
In-Reply-To: <20241114121632.GA3382@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 15 Nov 2024 18:59:11 +0530
Message-ID: <CACzX3As0EzgC-Qgp=Kt67kjqwq8sqsEWDCpgjb3BFW2UzU=oGw@mail.gmail.com>
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org, 
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org, 
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, 
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com, 
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2024 at 5:46=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Thu, Nov 14, 2024 at 04:15:12PM +0530, Anuj Gupta wrote:
> > PI attribute is supported only for direct IO. Also, vectored read/write
> > operations are not supported with PI currently.
>
> Eww.  I know it's frustration for your if maintainers give contradicting
> guidance, but this is really an awful interface.  Not only the pointless
> indirection which make the interface hard to use, but limiting it to
> not support vectored I/O makes it pretty useless.
>

The check added in this patch returning failure for vectored-io is a
mistake. The application can prepare protection information for vectored
read/write and send. So vectored-io works with the current patchset.
I just need to remove the check in this patch.

