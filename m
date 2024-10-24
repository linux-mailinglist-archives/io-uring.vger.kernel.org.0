Return-Path: <io-uring+bounces-4001-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57A629AEF75
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 20:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88AE61C2323C
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 18:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8141FF7CA;
	Thu, 24 Oct 2024 18:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0LrF1ALK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E65200105
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 18:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793627; cv=none; b=A1tMBGTDlVtMzDgbxAeWnmAenZAv+ImhrrPn2QO1X5uGswWGgLKHw2Nr244acXdJWixXNvBtDnbKFGeJdA3H0kSgB5/JS+VcT/BrIpgHByE1vb5knZ9m8J5SsHHILA4pKMfp090MXCl8THy/0HgkoaxdzMAO6WwDU00QIHEiunc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793627; c=relaxed/simple;
	bh=5v7kCAv0pp4jl6uAw1mSxZN39HwN4R6k0HDcgNpGXwU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jIW57tsXaa4HOM9Iqq3ihB3VLxbDf7If9wUgeMJLDhoYf7ynhgL2Qi9YkV4ApNhIgBJ//ug93kRXc3ZW+ivUPyqPKwraI/WOPOfDJR4ivM3hvVoX0p9lQe7Q2fEvvYlrw9RyOf30pyPjEZff0o3e5b3feiYferRdqtoxZ+5f044=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0LrF1ALK; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43153c6f70aso30865e9.1
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 11:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729793624; x=1730398424; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rthjlWdBVEiMElkAmw6QIpUw0Ietq6qsvwglL2Yz1ac=;
        b=0LrF1ALKejWrpp3gZ6ISa8tsDBvW7vgk0mSzNkmLcuA3S8TbwzmzUoVHRkWR5pzHUF
         EzOTWgIuyKcHTTooROGMAgBbbtbc1xvUmlrYELvas88LGKoGkisZ63bB5Fy9T24rQRdk
         x4F25XTLpC2J3Dr9BGLDRaRVXci+StvNFuK87zpU0XeidGWahT2thOjyAwHPdI7bJAB6
         Mwp+uQripfJz095SR3VziGx+Ww8nIeAGVMpJezQN6e8gj/RY1C793JL2J24c8kEKgAym
         Z0X1XVGoGQBu+XALdtDnfBRBx69hMGy68a0T/xe+4/5QyF9QiOF8pyTO6bhZpSR/KtKs
         qBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793624; x=1730398424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rthjlWdBVEiMElkAmw6QIpUw0Ietq6qsvwglL2Yz1ac=;
        b=XBGuujIOkbOl5pIqpkXcqikzatZ9kSelWiHhi4w5ER16ohKOpOQeCyVjaEC7LpmjvP
         ZhT1l33XfD7CJII2G4/9vPVy4LkAQDzY1IsJQZaAJ7RAH0th9D1lqZ62EiyqfeaeWjFv
         iNG6ORc79hkttXPFtDY2eQOc4T6fUHxICQA7N/WRZSMZKR8Qtk15N7uycFIT25gUSGLk
         gM4QOOqQeyGFPxKRlSEgy+yyk7bAjRD7ChnEliu8QQHsJdMcXers2xmOBpCxBfdfHlsv
         +D/CkZNthB9EJcqXoWjyj2INZf+BYisEFMN2pM1cEZ1mk2H8tKQ0bcUvlgw6Xg+x0d2y
         DZxA==
X-Gm-Message-State: AOJu0YwMP8DyDdalqsx627yL0fZNkfIbuaTxG4+dO986UWembcITzIAU
	rYAzbB9YzU+ciWqWj/f0JM2uFBptMoQGlyaKFYnx8ArSJW5R0tuMcD7AyT+sqeRp6vfC3tUir2x
	KKFDWrTol2nyYSDdxUWGTmVbNMx+jVrPBKIEN
X-Google-Smtp-Source: AGHT+IFfGorczthW9U1r/4p95pDfx1hz3NnBUyOMbIYk9DFYH7jcXEOqQa5Q8DfrkDMAzMpzP+ugSsJTFeJvzbnqgdE=
X-Received: by 2002:a05:600c:34c3:b0:42c:9e35:cde6 with SMTP id
 5b1f17b1804b1-43191f8e5f8mr351995e9.2.1729793623467; Thu, 24 Oct 2024
 11:13:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241024170829.1266002-1-axboe@kernel.dk> <20241024170829.1266002-5-axboe@kernel.dk>
In-Reply-To: <20241024170829.1266002-5-axboe@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Thu, 24 Oct 2024 20:13:05 +0200
Message-ID: <CAG48ez3kqabFd3F6r8H7eRnwKg7GZj_bRu5CoNAjKgWr9k=GZw@mail.gmail.com>
Subject: Re: [PATCH 4/4] io_uring/register: add IORING_REGISTER_RESIZE_RINGS
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2024 at 7:08=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> Add IORING_REGISTER_RESIZE_RINGS, which allows an application to resize
> the existing rings. It takes a struct io_uring_params argument, the same
> one which is used to setup the ring initially, and resizes rings
> according to the sizes given.
[...]
> +        * We'll do the swap. Clear out existing mappings to prevent mmap
> +        * from seeing them, as we'll unmap them. Any attempt to mmap exi=
sting
> +        * rings beyond this point will fail. Not that it could proceed a=
t this
> +        * point anyway, as we'll hold the mmap_sem until we've done the =
swap.
> +        * Likewise, hold the completion * lock over the duration of the =
actual
> +        * swap.
> +        */
> +       mmap_write_lock(current->mm);

Why does the mmap lock for current->mm suffice here? I see nothing in
io_uring_mmap() that limits mmap() to tasks with the same mm_struct.

