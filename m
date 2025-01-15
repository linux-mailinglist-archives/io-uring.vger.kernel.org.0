Return-Path: <io-uring+bounces-5892-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 597B8A12C77
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 21:20:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B2413A5C20
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 20:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B4D1D88D1;
	Wed, 15 Jan 2025 20:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bwRUWImP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C481D86CB
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 20:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736972452; cv=none; b=KOmPP1y5X4BY5Wjp/psprjtaITdWsM04X9zv/NwFD62D2Fje4XVr2ailJ//5J5UZvACzTZq0OzwrBUSC2nS60N2b1dyH5LFSoipsLKLWToJUXFhtrAt/vWM/ffL0yT5Ywjz+N3/2zHhxAnAyh2mrssqMyssESZ6w9ZinWg2oY0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736972452; c=relaxed/simple;
	bh=3fpu5QT9hm1s0fXCpJIz7jhjDa0wiroyHY0ug+97LAk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nvwIcYvZGX6GpcAmCg9GYVQAQd2kCLBb0+4+/t9TkqOG1/4CeXiV+AUgolltJRlB81usLI/5FTAWW94AKx0qcp9P3Td0IZpgMqpsXHnLZROIjB2+r0mjvMXYa/9B/SdtOa5y/BoTt7drdvZq3oX6iHmgT7jVghN9ZhOVARuzKm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bwRUWImP; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d442f9d285so1823a12.1
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 12:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736972449; x=1737577249; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UVN/UI4IotA2OowpWknr4EJ9Re8diuOHlZDXJpshczg=;
        b=bwRUWImP+78n2NyKCSIJXdjQNtfUdftCVMAymO2bO54OuX7mbCrSoN5ZbPaCVXyMXY
         rzo+jqNGcElbZ3Mn0PxWf3O34m7J0YGKWG0y+Z2AeQfM64hedG8VPwaId6+agKMcxbsB
         mnyWX6fK3syKtmOs9IP96b1sU85pM01fA/TICg04QarSwOJQZByLaOtWJHBgaJ/CLwgp
         7I0He2FEA9MSKNLAl4d1lIhKh3Usuwya060aX7VEIj1XAU+AcmgvalZcHMFwRLxT+wgV
         bbWYyK5yWkqi2pBuPyEp7BcRzj3oMIQVn/1RIiMNMON4CBqvagn4piXuPS4sDk4XqRzW
         bU6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736972449; x=1737577249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UVN/UI4IotA2OowpWknr4EJ9Re8diuOHlZDXJpshczg=;
        b=nWe4mfDDR5H9ZWFsayMazMisEh2eKlM9vJL1r87ac43ANxXn6MnmdFmV3WPoI3+cBH
         l0MTWBASCBnlrlLElEHCk7hia6uH0yyFEvXNj3AOC2c3qSoQzfSm2ghrdYpyl8ndp/Ck
         cGMGzH0TiwjmTp9E+lHCoxM1G6n7aTi7cDU2k1iKw1p04Ucpuc74NOz/6nSa5cV7+sYL
         VtsisTJum4fYl0Unomo3beTKttDyNzUAgJnjucE0vboRM79UA1Nev1F/6A/PFe4f3Tpb
         jLZ1zKjC9xB/i2nRgPJm4jKQRJ1FsBOy8fmsbhjIrCndl/FG/oIvdxj5uosYquel+WVh
         jUMA==
X-Forwarded-Encrypted: i=1; AJvYcCWiwpUzeRtqJYEsudsiJ4zvVFXyZx4wXUgo4qNC/3BWd0srZP2OU4crLWA2B0un1/AiQs43XJsmwg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwE5eY7vUMhliJ+TmOlWQh5x3kyHOQLFf3DPKh88OEUlfpoB0mN
	6LWQ5zCIsQdB3PViqQVlkWuWeFIpw9iZYZ/BzFbXL+0LAh9i9o+lpBinVoMquuUlXxkeScs9PxE
	vk/DcjwiBtyeFcMFRb/HncNvti+FZHATdEXJb0QgdYi1l0fs2c1H6
X-Gm-Gg: ASbGncvCSnBTmzdg5p+24r8IPH2TvUx7WwiEjbKXw1KYF7WqkyNjq25YI4H9qAFlCCN
	ft3d9gLMTB5u4Y9l3OkPxkGwS/SYP+NLLlm1s+/7Mdp9eSId1obRSrpwljI+Qsw5nJA==
X-Google-Smtp-Source: AGHT+IEI9TnSEHFNcYAVN2yURDNbELkOiMAXRVno6ls5MBCeswzfdIs1OgvJWBbIac1UVcpRbeDgRRnenl3/+8CWvME=
X-Received: by 2002:a50:ab17:0:b0:5d0:8752:cecd with SMTP id
 4fb4d7f45d1cf-5db636ea6dfmr15510a12.3.1736972448787; Wed, 15 Jan 2025
 12:20:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250115-uring-clone-refactor-v1-1-b2d951577201@google.com> <2439336d-b6ae-4d08-a1e8-2372fc6df383@kernel.dk>
In-Reply-To: <2439336d-b6ae-4d08-a1e8-2372fc6df383@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Wed, 15 Jan 2025 21:20:12 +0100
X-Gm-Features: AbW1kvaB6tSdLUo8N78HZdLfz-5NxinH55r69nuRe_LsRRVmQvYzdRFo55souAA
Message-ID: <CAG48ez3RG5iDrK4UWCjBWw9FTPCQK8NXK1wADo_VWWBatVpXBw@mail.gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: Simplify buffer cloning by locking both rings
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2025 at 6:18=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/15/25 9:25 AM, Jann Horn wrote:
> > The locking in the buffer cloning code is somewhat complex because it g=
oes
> > back and forth between locking the source ring and the destination ring=
.
> >
> > Make it easier to reason about by locking both rings at the same time.
> > To avoid ABBA deadlocks, lock the rings in ascending kernel address ord=
er,
> > just like in lock_two_nondirectories().
> >
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> > Just an idea for how I think io_clone_buffers() could be changed so it
> > becomes slightly easier to reason about.
> > I left the out_unlock jump label with its current name for now, though
> > I guess that should probably be adjusted.
>
> Looks pretty clean to me, and does make it easier to reason about. Only
> thing that stuck out to me was:
>
> > @@ -1067,7 +1060,18 @@ int io_register_clone_buffers(struct io_ring_ctx=
 *ctx, void __user *arg)
> >       file =3D io_uring_register_get_file(buf.src_fd, registered_src);
> >       if (IS_ERR(file))
> >               return PTR_ERR(file);
> > -     ret =3D io_clone_buffers(ctx, file->private_data, &buf);
> > +     src_ctx =3D file->private_data;
> > +     if (src_ctx =3D=3D ctx) {
> > +             ret =3D -ELOOP;
> > +             goto out_put;
> > +     }
>
> which is a change, as previously it would've been legal to do something a=
la:
>
> struct io_uring ring;
> struct iovec vecs[2];
>
> vecs[0] =3D real_buffer;
> vecs[1] =3D sparse_buffer;
>
> io_uring_register_buffers(&ring, vecs, 2);
>
> io_uring_clone_buffers_offset(&ring, &ring, 1, 0, 1, IORING_REGISTER_DST_=
REPLACE);
>
> and clone vecs[0] into slot 1. With the patch, that'll return -ELOOP inst=
ead.
>
> Maybe something like the below incremental, to just make the unlock +
> double lock depending on whether they are different or not? And also
> cleaning up the label naming at the same time.

Yeah, looks good to me. If nobody else has review feedback, do you
want to fold that in locally? If there's more feedback, I'll fold that
incremental into my v2.

