Return-Path: <io-uring+bounces-4579-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0D369C3229
	for <lists+io-uring@lfdr.de>; Sun, 10 Nov 2024 14:31:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DD0A1C20921
	for <lists+io-uring@lfdr.de>; Sun, 10 Nov 2024 13:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B36D101EE;
	Sun, 10 Nov 2024 13:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YDEQ8AxK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6551DDEA;
	Sun, 10 Nov 2024 13:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731245511; cv=none; b=KUb9Pg2N8YOot8E0o4QBySC8BLy4KlzBQrvXlCojh4LKjEQ/m4TBrjBHebZwIEz2Rz7qcHAQBHcLNyhzsir/afBOK35Im4D4yeQEYj+Z5tPy0WVxPHorjiZWolkJ3mEcpkqDr8apA+zrO77Nhjth9hJVDYlFIoiUZMfZWtS70o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731245511; c=relaxed/simple;
	bh=+Pn6z/ZrVg+jgocBF8TBEd5MVu38+jtPL7I3DzV4iCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=UlH9CiZmVieKkwvKoz5UIzqssCBI/7Iq0zxiNhxy1qLEiS2ug9njtj9NaWLREfcN2QkKykVo8UHV8HarK61GMbpheRugXAJM2GFewRB22UF8sNV76zx9abZrRPCkBjb8yCQovBn/b1vfpo0NSah7CLb+pLFYoh6RPng0QwzLQSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YDEQ8AxK; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e291f1d659aso3415306276.3;
        Sun, 10 Nov 2024 05:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731245509; x=1731850309; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Pn6z/ZrVg+jgocBF8TBEd5MVu38+jtPL7I3DzV4iCo=;
        b=YDEQ8AxKL7yv0J07JzlfEaQCnboFQzsECenNSYmkD8NzUAv5nYs5wGYXw9UX8dyLiq
         2dho3Yk2PECInl2HGIopVnpuAQQ42tT57qwG0ciOzYuQpcvUQwJ3B0hnjVEyBp9abqG+
         r59R7/THai67BmHzo3dbleayoTmMWUYFSdoYVk0dd+wKJ0RrkgdpmWt+yTO9BU+2kBr5
         X31l0kKypuL85BQnXXqooJJ+l9g2VMrI0z42HiuxL7QfRfnCNEsYYFmL8DzBSjRyRVCI
         74dbIsej9fMBaW4CA6Q5AylOZgLQBljEGKvbcdAGaILvGIoue6vOhwGdiDLr9/yhmErX
         c/yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731245509; x=1731850309;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Pn6z/ZrVg+jgocBF8TBEd5MVu38+jtPL7I3DzV4iCo=;
        b=kaqXBs1xJjbcI8goiagNM32YkrUQkVib5EEe0aoGOI3OBtiWnH80HYD097j8DI6Rqc
         ta9dptHn2vhW8JXCmpv7uL0wkofTTjdu2/gUKp5LCOgJKuTK7IZlUoJNG+O8BNoGAA3W
         lXaxIqktcooUcorTi3mBazt5kSwY1ASn+gMIiOja+mXKlVS3r2pLPZ0LDhuHo2CMZYG9
         tmY3LUDiUpJvQlh1gJL+anTZzvDOFUvxtKG1Yy1W0FONv9cqkT3mA7WAVGw1YueuH4nb
         VKWYaEzg5wEng1ZYM/zLls0oJ3RT3emO0NZfDQgroEu/+ERAI9dMoe0fR2KxCSgRuUFa
         S9ww==
X-Forwarded-Encrypted: i=1; AJvYcCUI0y5mjC81I4ofqU6oiWQvgb1GvmQrJYanN7vor1CL+JHZBDNFRZu15kuk959+JTOEOfVepvAQAA==@vger.kernel.org, AJvYcCXvX1Ccm8tGPHUinZs7DmI21d9B4ECLVIx98O0JVmJFMjbcmvJytwJD9gczvUa1rgAkDyux2tEwQiS9HhW2@vger.kernel.org
X-Gm-Message-State: AOJu0YyrNEiAEQmSR5AVxSIlXxBcDBIK/nngLlkpkwCOcyRLRHn7H+ab
	rTWmcGfwQYaJDdgkOIQ0zHscijqGuCwmwH4SMSKR0G/+D477Cd9IP2pSzRrbco9+rxGJ5Dsu+nw
	LEuivGsZO9XHng+mmp1B24Gpf5un6nDNp/SI=
X-Google-Smtp-Source: AGHT+IHSc+0P4vDyt1SRg0wgbExQWuk/BKoItU+LH9+IRYwzEYf8XEH06mczX1N7rGfqvyWtUdRUEz4v6CNesd50gfc=
X-Received: by 2002:a05:690c:67c3:b0:65f:a0e5:8324 with SMTP id
 00721157ae682-6eaddd863b6mr86311297b3.4.1731245508731; Sun, 10 Nov 2024
 05:31:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADZouDQJOe-JimRj8f4ELtKOzHFiz7yDqnqcpSMP8oU=RuypGQ@mail.gmail.com>
In-Reply-To: <CADZouDQJOe-JimRj8f4ELtKOzHFiz7yDqnqcpSMP8oU=RuypGQ@mail.gmail.com>
From: chase xd <sl1589472800@gmail.com>
Date: Sun, 10 Nov 2024 14:31:38 +0100
Message-ID: <CADZouDSZj_V9HBuzXkDqHZZEaG8d++z3knxYAnvbrOTbZAgs5g@mail.gmail.com>
Subject: Re: Potiential nullptr derefence in io_do_iopoll
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry, apparently I missed a check
[here](https://elixir.bootlin.com/linux/v6.9/source/io_uring/uring_cmd.c#L1=
69).
this is not legit then.

On Sun, Nov 10, 2024 at 2:24=E2=80=AFPM chase xd <sl1589472800@gmail.com> w=
rote:
>
> Dear maintainers,
>
> I'm looking into io_uring internals and find there might be a bug in
> io_do_iopoll, but I'm struggling to construct a POC due to my lack of
> knowledge about the kernel internals. So maybe it's better to put it
> here for discussion.
>
> After [issuing an
> SQE](https://elixir.bootlin.com/linux/v6.9/source/io_uring/io_uring.c#L19=
20)
> in iopoll-enabled io_uring, if the return value is
> `IOU_ISSUE_SKIP_COMPLETE` and the op supports `iopoll_queue`, the req
> will be added to `ctx->iopoll_list` and later retrieved in
> `io_do_iopoll`, where `iopoll` or `uring_cmd_iopoll` of the req file
> op is [called](https://elixir.bootlin.com/linux/v6.9/source/io_uring/rw.c=
#L1167).
>
> IMHO here we miss a check of whether `iopoll` or `uring_cmd_iopoll` is
> implemented. A more understandable case for me is, the custom ioctl
> function with [IORING_OP_URING_CMD](https://elixir.bootlin.com/linux/v6.1=
1.7/source/io_uring/opdef.c#L416)
> satisfies all the constraints and will go to this path if `uring_cmd`
> returns `-EIOCBQUEUED`
> [here](https://elixir.bootlin.com/linux/v6.9/source/io_uring/uring_cmd.c#=
L192).
>
> So this requires that all the ops with `->uring_cmd` returning
> `-EIOCBQUEUED` should support `->uring_cmd_iopoll` as well, which is
> not the case for
> [ublk_ch_fops](https://elixir.bootlin.com/linux/v6.9/source/drivers/block=
/ublk_drv.c#L1967)
> resulting in a nullptr-deref in `io_do_poll`. I'm wondering if this is
> legit.
>
> Note that the related code changes a bit for [newer
> kernel](https://elixir.bootlin.com/linux/v6.11/source/io_uring/uring_cmd.=
c#L261).
>
> Best Regards

