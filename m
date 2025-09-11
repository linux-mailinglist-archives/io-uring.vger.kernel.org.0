Return-Path: <io-uring+bounces-9755-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F1B9B538E1
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 18:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3989416F54D
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 16:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D5133EB0D;
	Thu, 11 Sep 2025 16:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="C+OTkRt2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5544E3568F8
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 16:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757607260; cv=none; b=X6JsM4bEK9/q+WLVz6mbGhT4pYC5hhZ9BYNzR1b3x1fOfok1ccHGR0RbCmyBcE596bpK03p9SAb8YIUCAQ1btG9DJTApbYbH3dVKz61cJByOWCCOppla/pWtMDFrSwWLWNY34AsN8HWzuNvxcGzbscijsrvLTaNLNRuVuDVtNEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757607260; c=relaxed/simple;
	bh=hjv904P+4rqOqflkNtuRiRuphKk9Xj6gBOvCQNNfr38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V8nBJWqsnKPrgF5WRAIvk7mbSLbR+F8qe+yXLYgBxd+sGNd5F1Z3cubA5VKStKbAZKz4WmZmJsGQJfItXfe48Pvpvg/NrTvcGXp2tL9q6zL/mfEkQ0ThQeEUsvO+Dg2fLpzLwm4Ls99MO2y3VdkYipoY16iZ2w8cSqJ9ZW+ITy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=C+OTkRt2; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24cb267c50eso1287675ad.0
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 09:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757607257; x=1758212057; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vQhWayApKotZNesM7LFDQ//d+s5uEF6ep39Z8MhejHA=;
        b=C+OTkRt20shJjinYKUb1hBs3msVyGgCjRv9ptcgBwm0HG97D0+wNBcFtXTcJHkno1R
         UHQvwrqZs726MelKKkf2Wxl5Wm49zobSL9+6oIghzJikVACLh55YUli0Qnm3y1mHq6I2
         2l1swpoBp0TLXZ+dDRfUocPZejGJ61r3rCds1/dEAXZhWROJWFjqT04EC2RMEdc2Xmif
         TKgghMYZ8KgxHGmMtrguhxAW1twLAiV/qYndFEcrER3vYX03iR1ZjVB8a8n1VLyaGlYx
         lBP2KquVSUYIl8QjVf3Nw4HvjytO0UzPCNwxb1rowQRaQtDBGDIvGRX2pC3n7CZe6sFL
         c5hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757607257; x=1758212057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vQhWayApKotZNesM7LFDQ//d+s5uEF6ep39Z8MhejHA=;
        b=kMkrZGv72ozivHMCuKNyZzgLaeheKxSBmZZY4IzhHenKXOJYb0L/eNNRK4F+WWi47k
         HNgppBq36j1zD2m8+EQVALDyXZuSM17snNJVYpxuSttvoQ836EuovpFF+wK2Lt+Tv4D5
         gAT4XZi7gLoX98Vw/QFc7K52PIrDviQTKS4+zrx2HI/9oIHzbfgDP6iGp/YnqZGfhD8h
         xAWpFAdiuZ9q2bWKDowVasnc8lkH3EWJ6GKF4j8UTNXe6H0s8luSSIn0s9XkJ4Vxa436
         KFHsLGtqlBA9tR8rEZ7SDja1hVu1HDhmixPzs7LkPtJex+KmtJzPFxF75jPMZMFXlAwh
         ukzA==
X-Forwarded-Encrypted: i=1; AJvYcCXdjDSb9fmS87jApqVEF5jlAxAX1M52reLNCpM66Bhn5yzaTv6UZgLMVsRo7O8ky6oz0f6A26Z0mQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxNUbTrJRwBQJBqsvCIaKd/gwKLnU2MsSQBVSK02WmYnGpuI4FY
	JJa4bY72x1byqlobu42cJNqmQ1v1po3+12+TM6L2HGPnRGNiwhi2DLpLc+15e4eD+YnX48jmgRS
	JhViiDyK5NaA7Dtw9+/FDUTagqH0NFkLr9wcHJNP+6g==
X-Gm-Gg: ASbGnct9h9ezZGC2XFrH3nCUl1ensLHbrO5boGaWQAq0Am6ad4SRM4M9q9MsV89QaU/
	fzOy5vA0N+rGXQB+K+7pyuqECuBlyzfS8qYWMziQx5h5T9Vth/NX2tdj5spfuqKpEmqF+dQ2J5s
	o4m4u0MI2thrRNQA1HnpFJOWEQiXgV1MGOpvyyMBC3QHKEyspA2K7FuIhDuiHsEUmprO91s/3I0
	xSbus3BHMI7ckGIZr4qZGmO50hsNy2w8BepRnI=
X-Google-Smtp-Source: AGHT+IEntaUlyZJpjvhL3dhWQiy1zz9ST9DXO6LhnC0/iBeHnmxCwuuBSobY4k3WQjPr8z3/FD0he6xnmqQYRAROND8=
X-Received: by 2002:a17:902:c407:b0:24b:142a:c540 with SMTP id
 d9443c01a7336-25d24bafdb3mr114635ad.1.1757607257455; Thu, 11 Sep 2025
 09:14:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904170902.2624135-1-csander@purestorage.com>
 <175742490970.76494.10067269818248850302.b4-ty@kernel.dk> <fe312d71-c546-4250-a730-79c23a92e028@gmail.com>
In-Reply-To: <fe312d71-c546-4250-a730-79c23a92e028@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 11 Sep 2025 09:14:06 -0700
X-Gm-Features: Ac12FXzAgdE35uhUmu6ZIn5ymvgle8od7WgZ2nhI1zOUzVmMns8HB3zGpbcJ8lE
Message-ID: <CADUfDZpH+6mx=rYb9uoL2z3-9DCmLLnF8vTBR8DX-PQBH+nqaw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025 at 4:56=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 9/9/25 14:35, Jens Axboe wrote:
> >
> > On Thu, 04 Sep 2025 11:08:57 -0600, Caleb Sander Mateos wrote:
> >> As far as I can tell, setting IORING_SETUP_SINGLE_ISSUER when creating
> >> an io_uring doesn't actually enable any additional optimizations (asid=
e
> >> from being a requirement for IORING_SETUP_DEFER_TASKRUN). This series
> >> leverages IORING_SETUP_SINGLE_ISSUER's guarantee that only one task
> >> submits SQEs to skip taking the uring_lock mutex in the submission and
> >> task work paths.
> >>
> >> [...]
> >
> > Applied, thanks!
> >
> > [1/5] io_uring: don't include filetable.h in io_uring.h
> >        commit: 5d4c52bfa8cdc1dc1ff701246e662be3f43a3fe1
> > [2/5] io_uring/rsrc: respect submitter_task in io_register_clone_buffer=
s()
> >        commit: 2f076a453f75de691a081c89bce31b530153d53b
> > [3/5] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOL=
L
> >        commit: 6f5a203998fcf43df1d43f60657d264d1918cdcd
> > [4/5] io_uring: factor out uring_lock helpers
> >        commit: 7940a4f3394a6af801af3f2bcd1d491a71a7631d
> > [5/5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> >        commit: 4cc292a0faf1f0755935aebc9b288ce578d0ced2
>
> FWIW, from a glance that should be quite broken, there is a bunch of
> bits protected from parallel use by the lock. I described this
> optimisation few years back around when first introduced SINGLE_ISSUER
> and the DEFER_TASKRUN locking model, but to this day think it's not
> worth it as it'll be a major pain for any future changes. It would've
> been more feasible if links wasn't a thing. Though, none of it is
> my problem anymore, and I'm not insisting.

If you have a link to this prior discussion, I'd appreciate it. I had
tried searching through the io-uring lore archives, but apparently I
don't know the magic keywords. If there are specific issues with this
locking model, I'd like to understand and address them. But opaque
references to known "bugs" are not helpful in improving these patches.

Thanks,
Caleb

