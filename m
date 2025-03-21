Return-Path: <io-uring+bounces-7186-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 268BDA6C511
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 22:24:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3E6D483205
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 21:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32DDC231A37;
	Fri, 21 Mar 2025 21:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="IYYF0198"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CDE230BC5
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 21:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742592260; cv=none; b=Rz9P5AsSF5/Kif+9Y4NHbFPKhvl3EK2U7wUfBf/WEZH1KbnjNjIeGpyi3uVyRj1+cXUAyZA+hJPiFC8ka5H+Ow8W+1qw9I4fbDhwbrSbbMCcoGdTeSMMisgy8BGVgS0uG6fqFSXybGnVW++c253SxIXFXLKBJyUzE5Lm0IeXYqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742592260; c=relaxed/simple;
	bh=xgEexH4YlzNQooQdAkGITDiRNkQG2ag5mUu5UecmzPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HwhMS+Laa4ySYxNPWUN9ncHwV4jgaB1kuxqnQNU0hqR0X3P8LDOgqDyZlFIWBjYjX2LXaN9LJJmX/vvi3641FvndjsarDfccFuQfw7xv0k9h8VXAkgPBNFnOCZI8TZ+oNBaaHj9X+jWnElDbH/cpFxrjo09pecUWBeNu2I+Np/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=IYYF0198; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-301317939a0so651390a91.2
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 14:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742592258; x=1743197058; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xgEexH4YlzNQooQdAkGITDiRNkQG2ag5mUu5UecmzPo=;
        b=IYYF01985D9yvKCk2MjWBG431+Jzo8ey8cwDWapZo+t/ACvSnefnWLeOQEceH0cZb5
         1GhaKhd6WKFN1VJG8TYbPLRZkQ6ElZlTejKCVp8byI9LIu/hVDfIjNrDZkod4tnT4bB6
         5BeLTa06w71yjAEiHXfd++Ft2sESA87vp+dt/9JD2JeCFsEVveh/9t/JXin7QUQybWRy
         /+XU4I2M9bIzJQ6uPyJgWnVEAZuZegYNJgL3hUtcTZtMXUsbC/xCH14hD/9tgyRchwib
         oY9C88Kjm0GyPhnKxDXYaha9ELJ/G/4VynWHO1RnjW66Xk2CQ1kNIkoX7PIW5DM5fvaQ
         j9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742592258; x=1743197058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xgEexH4YlzNQooQdAkGITDiRNkQG2ag5mUu5UecmzPo=;
        b=CMRa82VZX5cxOyQrRUuqo3HgaD3iQKVRtGbCdCLtb+htdl9UrGmjjd5rb7QH8WXuOq
         Ds8VLtKpMmC060WVi3Y70ARg9DOZTJDJKdGCBjzEHscSAjD28hcHCVhXimwuarquUaEH
         rsKW3DLrM+9pDIuGGXbjFGiGRbv/HijDoXcNMViKDQpYTbmsJapn4JLmeNf3KcGwTb7l
         Gc7KOrpsIQxdg3ixBZb+nk68yYl+66PI5JUbImq5SCQqy2yvjsAhMTNtQW28WlS+M2ZD
         tl5+KDDFtYELGlgKvCsoAB6p1C39PjPLTebODAv37EQ/ZjYEzWJpdCWoo4yszAG+7YfC
         E/sw==
X-Forwarded-Encrypted: i=1; AJvYcCXJaOkbW0SzT81pzwuyMB64xZqqCDaXh7FmGvkqzIZd+lKZcqucos3UG97M6DZlg8BZbg1go2fFvQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxguJk5yu4e6E52H9SvaSlWB9KErPW7AtOXm0YwiH9j3lJDy1HR
	Nojmn5GQmqTsk3hITFmPUz+Zq8xAfGYnlegi0UQFLSJreySKCr0IL40VofH5n4stGlmBKXkg4yY
	SQ1J72uNoRfDMoh75aspWgkZCX08rDWc3yoA/HVj11O3BqXssHD8=
X-Gm-Gg: ASbGnctW818p8PlE16B4NYOO9a3do6/7mZMGyKLZMPEZQDu9V0NZbb8d8nrw0sDy0r0
	m/Cuxsweu++SKjShScrLuSugnReCVmHeuX8ngb4QH+RE9LIQ3960RYfsemz+KIwkkH3hL3mTjtW
	ipX1ZoTAK1PGMDLQhWbbTyoc9S
X-Google-Smtp-Source: AGHT+IEWKjJGtm5ghineH2xwXYNT84KCnqIRLDNZSQSW8P28Btfs8lapQkXp4I96X8icAPuhtpGyDCSg8I4uBIG6u90=
X-Received: by 2002:a17:90b:3a86:b0:2ff:7b67:2358 with SMTP id
 98e67ed59e1d1-3030fe6df4bmr2143070a91.2.1742592257499; Fri, 21 Mar 2025
 14:24:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250321184819.3847386-1-csander@purestorage.com> <5588f0fe-c7dc-457f-853a-8687bddd2d36@gmail.com>
In-Reply-To: <5588f0fe-c7dc-457f-853a-8687bddd2d36@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 21 Mar 2025 14:24:06 -0700
X-Gm-Features: AQ5f1JovqdCIrHb51iECUiV7-0VxJPfIpPS2a0CZYqJvx9jgCUTe3TWJ9VOPsBk
Message-ID: <CADUfDZo5qKymN515sFKma1Eua0bUxThM5yr_LeQHR=ahQuS_wg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Consistently look up fixed buffers before going async
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Xinyu Zhang <xizhang@purestorage.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 21, 2025 at 1:23=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 3/21/25 18:48, Caleb Sander Mateos wrote:
> > To use ublk zero copy, an application submits a sequence of io_uring
> > operations:
> > (1) Register a ublk request's buffer into the fixed buffer table
> > (2) Use the fixed buffer in some I/O operation
> > (3) Unregister the buffer from the fixed buffer table
> >
> > The ordering of these operations is critical; if the fixed buffer looku=
p
> > occurs before the register or after the unregister operation, the I/O
> > will fail with EFAULT or even corrupt a different ublk request's buffer=
.
> > It is possible to guarantee the correct order by linking the operations=
,
> > but that adds overhead and doesn't allow multiple I/O operations to
> > execute in parallel using the same ublk request's buffer. Ideally, the
> > application could just submit the register, I/O, and unregister SQEs in
> > the desired order without links and io_uring would ensure the ordering.
> > This mostly works, leveraging the fact that each io_uring SQE is preppe=
d
> > and issued non-blocking in order (barring link, drain, and force-async
> > flags). But it requires the fixed buffer lookup to occur during the
> > initial non-blocking issue.
>
> In other words, leveraging internal details that is not a part
> of the uapi, should never be relied upon by the user and is fragile.
> Any drain request or IOSQE_ASYNC and it'll break, or for any reason
> why it might be desirable to change the behaviour in the future.
>
> Sorry, but no, we absolutely can't have that, it'll be an absolute
> nightmare to maintain as basically every request scheduling decision
> now becomes a part of the uapi.

I thought we discussed this on the ublk zero copy patchset, but I
can't seem to find the email. My recollection is that Jens thought it
was reasonable for userspace to rely on the sequential prep + issue of
each SQE as long as it's not setting any of these flags that affect
their order. (Please correct me if that's not what you remember.)
I don't have a strong opinion about whether or not io_uring should
provide this guarantee, but I was under the impression this had
already been decided. I was just trying to fix the few gaps in this
guarantee, but I'm fine dropping the patches if Jens also feels
userspace shouldn't rely on this io_uring behavior.

>
> There is an api to order requests, if you want to order them you
> either have to use that or do it in user space. In your particular
> case you can try to opportunistically issue them without ordering
> by making sure the reg buffer slot is not reused in the meantime
> and handling request failures.

Yes, I am aware of the other options. Unfortunately, io_uring's linked
operation interface isn't rich enough to express an arbitrary
dependency graph. We have multiple I/O operations operating on the
same ublk request's buffer, so we would either need to link the I/O
operations (which would prevent them from executing in parallel), or
use a separate register/unregister operation for every I/O operation
(which has considerable overhead). We can also wait for the completion
of the I/O operations before submitting the unregister operation, but
that adds latency to the ublk request and requires another
io_uring_enter syscall.

We are using separate registered buffer indices for each ublk request
so at least this scenario doesn't lead to data corruption. And we can
certainly handle the EFAULT when the operation goes asynchronous, but
it would be preferable not to need to do that.

Best,
Caleb

