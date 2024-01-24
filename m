Return-Path: <io-uring+bounces-483-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 749E983AAFD
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 14:36:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A76461C212A5
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 13:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC7C77F04;
	Wed, 24 Jan 2024 13:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c7GwLGIF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D728BE1;
	Wed, 24 Jan 2024 13:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706103400; cv=none; b=EFNyVSWhF2Qn26iRiqUI3EF0MlU0pOu/PsM80NF2bFoYHosyuNU+3XM+pgMhXACJ+0ZfbxntQS9HBtFTbq12jd5nKveumlN4MVlAqeGVn7uF/v71gs4uWgztXkkOEiNyIDYXwML1ygWQbLh4olXEc/wR/QxFpkzYMhOrMNonSLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706103400; c=relaxed/simple;
	bh=GTaTORnOj7gNjCsEHgCdgGerLLavw67hjEYFK9q4jjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eO1XFoc0guLQtC0y6nuYBRb3UCwLhD/AmYkWt8ZQ67xVmPNeOxVs1sQLqIo9EIjKYhGCgOWyPhXyIWtJQI9JiN6b3DiEMPPOt9B66OHMSwgAizVXCg702+SW/T6bIEECQPaLy6iGhpkaHDSp5qxALVPXWmgsecj23j3i+k6pfwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c7GwLGIF; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2cf0e9f76b4so23934471fa.1;
        Wed, 24 Jan 2024 05:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706103397; x=1706708197; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ob9Be6C5UnFhXFv8WrifBw30hdAz7N4ducDXTKZYrVA=;
        b=c7GwLGIFHKorX55YFjQ3q0ODPQF9XlfWuseC7PQbU82GpamUE+Lo4eD+igJ3JWLiRs
         FpRWogROS64bmGxuAOOE3198v0g4wicBYqYZhuH70mMp0er38IEZYP+k7xitBrmAihsO
         fkXxp2UEsvitk5XNxPIamfpL56xljfbUblg91071rsTNGhgNcGz8INLlH1L6+bA5Wrcp
         p6CkqvP+7t9U3lkUS67CNw1Bvz7bR5Um/Dl+70/IwjoieSJrQA2GJBBXx3iibGUYxvgi
         M7CsTD3cxzSXO0M7IKaMDopU88abjYUyHn0FeU0YJNR8dfjqizkopP6TyGRX8vCaskpt
         tLuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706103397; x=1706708197;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ob9Be6C5UnFhXFv8WrifBw30hdAz7N4ducDXTKZYrVA=;
        b=m5Wk50HTsqk7WF+j1Hdy8nuCQhIx+eLUI0K9HJ6OsGs+YglJXRECTw4KzIAPF9YUG1
         qCM9C7ll163uphXeu9ltIEzcJRWcGUA0tBs1Y0AGWlzAxEw+ydqScqLx6MwLf8RiPWcF
         AtGDCljUSvXEyEYA7H7LYPBBZM2KOMq9IyaRFjjV8Al+078UqOahW2QVGiXY7MPkGlgF
         gAlm27WqDvIB+UAbcmxZ0tvtVMmr1AEJ9lYicgI8Y2x3lrIB0g7XuCSk0piWpcguvxbu
         lV9CVH4dLRv84hg0RUZ9UFmeM4I9e+9/5XC9NRaa0Uq2PunoIAGZbtybQlEW6CLPBfJK
         FaVQ==
X-Gm-Message-State: AOJu0YzsJacSIUZ1XjvfuGzgbjwsdMTI+NbKPvS7kopKg0zvPVfVEWPj
	WmOlzFYMED5HY0TxNdnYlX3gc1z+FTazaLj698pFd6xkKfSgrUEDVBWnn30cHm9+uJSNSo4HWwh
	CEvvu4zJeJbkS8SFroud0nxdfo2yfHkvh
X-Google-Smtp-Source: AGHT+IEuDu0Iwa6OL5YMTZiljwLQtQHZpF6ecHAJwdFXdBjREBVj+NV8nBApkw1MXuCI71V7kmMjxmQ5vhraXhMTR6w=
X-Received: by 2002:a2e:b894:0:b0:2cf:14ad:ed92 with SMTP id
 r20-20020a2eb894000000b002cf14aded92mr639128ljp.126.1706103396918; Wed, 24
 Jan 2024 05:36:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240124083301.8661-1-tony.solomonik@gmail.com>
 <CALXu0UdfZm-UJcPqF5H6+PXPp=DC2SA-QFbB-aVywmMT5X3A6g@mail.gmail.com> <fefaf2bf-64b7-4992-bd99-5f322c189e35@kernel.dk>
In-Reply-To: <fefaf2bf-64b7-4992-bd99-5f322c189e35@kernel.dk>
From: Cedric Blancher <cedric.blancher@gmail.com>
Date: Wed, 24 Jan 2024 14:35:56 +0100
Message-ID: <CALXu0UeFNiFgTNtgE+-WQbA3-WForFm9pKH18xHo=GrB97zEAw@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] io_uring: add support for ftruncate
To: Jens Axboe <axboe@kernel.dk>
Cc: Tony Solomonik <tony.solomonik@gmail.com>, io-uring@vger.kernel.org, 
	asml.silence@gmail.com, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Jan 2024 at 13:52, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/24/24 1:52 AM, Cedric Blancher wrote:
> > On Wed, 24 Jan 2024 at 09:33, Tony Solomonik <tony.solomonik@gmail.com> wrote:
> >>
> >> This patch adds support for doing truncate through io_uring, eliminating
> >> the need for applications to roll their own thread pool or offload
> >> mechanism to be able to do non-blocking truncates.
> >>
> >> Tony Solomonik (2):
> >>   Add ftruncate_file that truncates a struct file
> >>   io_uring: add support for ftruncate
> >>
> >>  fs/internal.h                 |  1 +
> >>  fs/open.c                     | 53 ++++++++++++++++++-----------------
> >>  include/uapi/linux/io_uring.h |  1 +
> >>  io_uring/Makefile             |  2 +-
> >>  io_uring/opdef.c              | 10 +++++++
> >>  io_uring/truncate.c           | 48 +++++++++++++++++++++++++++++++
> >>  io_uring/truncate.h           |  4 +++
> >>  7 files changed, 93 insertions(+), 26 deletions(-)
> >>  create mode 100644 io_uring/truncate.c
> >>  create mode 100644 io_uring/truncate.h
> >>
> >>
> >> base-commit: d3fa86b1a7b4cdc4367acacea16b72e0a200b3d7
> >
> > Also fallocate() to punch holes, aka sparse files, must be implemented
>
> fallocate has been supported for years.

Does it support punching holes? Does lseek() with SEEK_HOLE and
SEEK_DATA work, with more than one hole, and/or hole at the end?

Ced
-- 
Cedric Blancher <cedric.blancher@gmail.com>
[https://plus.google.com/u/0/+CedricBlancher/]
Institute Pasteur

