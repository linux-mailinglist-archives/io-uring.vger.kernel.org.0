Return-Path: <io-uring+bounces-4093-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70BCF9B4A0F
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 13:47:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 613BB1C2254A
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 12:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7408220262B;
	Tue, 29 Oct 2024 12:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k2fJjsQ9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD961E2301;
	Tue, 29 Oct 2024 12:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730206032; cv=none; b=Htw3mRRiISuXSwg7V7NCduCp+1HC9riiJU4jO7Ao7nUs9AVPF/rVgtsU16+0yGqx2rQLJriz8SfCeH6cQoX7iDlJaAAUudCtZx1N5EhreyOQXDqaPmuaSjHga8YyDQjlpv4cndb9jajmhU3uO7EU4Sg9qR+lPgzc6A29Dg9kbW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730206032; c=relaxed/simple;
	bh=PKIGvIkqahKGpUaSw28+IKqMSUuUV0Hhi1F1HBqO43A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ViWHb2sVD8TAsOvIovL1SwzGc39okDvQ8ZtjOD2OOia+lQthWNq5rqn/E+DuUxSeJo+QsVbAblwE+M+qlUGXr5Y+USaTqAAE5VjzPSqTizbQvvlhyAVGyFZc4l1HaXArjqqI3zOoKgztw/lv9yDGuN/6RT7HDXjr0uj7tBpxFbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k2fJjsQ9; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a99fa009adcso366944966b.0;
        Tue, 29 Oct 2024 05:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730206028; x=1730810828; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UXEU0K+HVbTbvp27dG/5AsENh9x1wq4XCrDbezUDB6I=;
        b=k2fJjsQ9L4LWoM4PL7yZwKPUFTf4+W2wupzWIb/ZoMnu5UZ6K74DWIitK8BZtN2aP8
         DDNTJXha54bcGgTf340F5t8zZubgVRbn9YoT7w8QP9S2wLJ2Im4uzFvlFbKMzUe1xWar
         Od+glT5qcwGsZT/tiOHoFiADygKJuHeKrGUgSgtC4DJBocXoUy3U+depaBXSJzny7DG7
         zmZEv/gGlnemfZ/MsuP+6rOMWGdAkOXEHnbeFzJDk3XMT68oEwa4j7qr7JepNdgFyeNH
         pHm/8j8W+pvMUY7y4Kmop6F43R72fSEzQTnxZJxpKxWd/RXtdao/Hup6PLEjolxQMTmL
         lBag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730206028; x=1730810828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UXEU0K+HVbTbvp27dG/5AsENh9x1wq4XCrDbezUDB6I=;
        b=rviQQKppHH/q6D3rsJ3vD8Np+vgz2bCrdLwnEQl/LlIR9/bPdWRCbtA9ZDGL2IK0t2
         tiSZYGJdhOSYXY5vQUw9rIYdxMZLkxn+XN/PZyyTsqkY9sF1rL33Oiq1LTuPqkTdX3BY
         Hqe/blm+SZOwZXLH0+fg4Vz2HJZo5sGw4VJZlABXaLuKqEZU1ZA23X6cdclIsGPVWmsk
         ORZ4tdccfDENZ+zKdw4yRxOKyKv6SpoKF5C8JTBhQt3DyIPY+x2HM3gxYpfR2thEE7dc
         BVVyYlZxx6rea6kFiX4Av5Q0l7+QKXYYPN5mz/ZVykw1culcXXu7hdxYeOPM+4Dj1VcQ
         OttQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4T+teNhJA7m3FeIWpz+R+WpzLRD8r34EjoVvYaLT38vjjGLnkYCJrGrHB+v5ePOoRxVW5P96WBQ==@vger.kernel.org, AJvYcCWGvH0a9OXs+3uIB+qHp3gHBZVvMoN8AAUwblU8SP5uyZT/S1n5ExT9rKMGbR/MT4BvHbmVKKpsi0kOxQ==@vger.kernel.org, AJvYcCWm/VatUyQD8aFm4dJhDhJa/M8GQFyebKNBVJiK0NUqGhN6jp9r21AwNSfDQ63zDvyb7p6hSWEP605agAhPfw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwlId72CxpIhoabaIILcShUBBsqAxjoS56fAdZ+7761LjCDgq9v
	ZQjnscx/nC8fQ5Ex40lgY/iEISaSVeCcgfhnMCFdM6E9629d1t8RSqP+vr7kORiMw0eyjFqueDx
	5nOdcHWiUTJ76rJOEXoZ77Y41tQ==
X-Google-Smtp-Source: AGHT+IH24jDXrN1/rLUODZ7dXWnQNAXgArrAqn9CD/XkQZPaaSbgd3HS6kL07anh4QVcaAdjYqc8XepfsP8tIRg++xU=
X-Received: by 2002:a05:6402:348f:b0:5c9:34b4:69a8 with SMTP id
 4fb4d7f45d1cf-5cbbf889850mr13754716a12.6.1730206028117; Tue, 29 Oct 2024
 05:47:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241025213645.3464331-1-kbusch@meta.com> <20241025213645.3464331-6-kbusch@meta.com>
In-Reply-To: <20241025213645.3464331-6-kbusch@meta.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 29 Oct 2024 18:16:29 +0530
Message-ID: <CACzX3AvZ=+cBaoZ9oKW3osA1WiWm5H5b7+wWAouLryK4-ymYfA@mail.gmail.com>
Subject: Re: [PATCHv9 5/7] io_uring: enable per-io hinting capability
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, hch@lst.de, joshi.k@samsung.com, 
	javier.gonz@samsung.com, bvanassche@acm.org, Hannes Reinecke <hare@suse.de>, 
	Nitesh Shetty <nj.shetty@samsung.com>, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 26, 2024 at 3:13=E2=80=AFAM Keith Busch <kbusch@meta.com> wrote=
:
>
> From: Kanchan Joshi <joshi.k@samsung.com>
>
> With F_SET_RW_HINT fcntl, user can set a hint on the file inode, and
> all the subsequent writes on the file pass that hint value down. This
> can be limiting for block device as all the writes will be tagged with
> only one lifetime hint value. Concurrent writes (with different hint
> values) are hard to manage. Per-IO hinting solves that problem.
>
> Allow userspace to pass additional metadata in the SQE.
>
>         __u16 write_hint;
>
> If the hint is provided, filesystems may optionally use it. A filesytem
> may ignore this field if it does not support per-io hints, or if the
> value is invalid for its backing storage. Just like the inode hints,
> requesting values that are not supported by the hardware are not an
> error.
>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  include/uapi/linux/io_uring.h | 4 ++++
>  io_uring/rw.c                 | 3 ++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
> index 60b9c98595faf..8cdcc461d464c 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -92,6 +92,10 @@ struct io_uring_sqe {
>                         __u16   addr_len;
>                         __u16   __pad3[1];
>                 };
> +               struct {
> +                       __u16   write_hint;
> +                       __u16   __pad4[1];
> +               };
>         };
>         union {
>                 struct {
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 8080ffd6d5712..5a1231bfecc3a 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -279,7 +279,8 @@ static int io_prep_rw(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe,
>                 rw->kiocb.ki_ioprio =3D get_current_ioprio();
>         }
>         rw->kiocb.dio_complete =3D NULL;
> -
> +       if (ddir =3D=3D ITER_SOURCE)
> +               rw->kiocb.ki_write_hint =3D READ_ONCE(sqe->write_hint);
>         rw->addr =3D READ_ONCE(sqe->addr);
>         rw->len =3D READ_ONCE(sqe->len);
>         rw->flags =3D READ_ONCE(sqe->rw_flags);
> --
> 2.43.5
>

Since this patch adds a couple of new fields, it makes sense to add
BUILD_BUG_ON() checks in io_uring_init for these fields to assert the
layout of struct io_uring_sqe. And probably a zero check for pad4 in
io_prep_rw.
--
Anuj Gupta

