Return-Path: <io-uring+bounces-5529-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 383549F584C
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 22:01:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DC4F17039C
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 21:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDEE21F9415;
	Tue, 17 Dec 2024 21:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QM+9mkTs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1497F1D79BB;
	Tue, 17 Dec 2024 21:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734469252; cv=none; b=hP8DT2g/ujvLbe197OY/vqRZI4vft7M1HChEoXt5eILWyN0uY58z3sFJuoBp2fNqWvmzQscQKyR1uj3JvHIa4ukPiyDeIhOAdUtHGMbCPqaAkwHCH0WzMKh2Y2wQQbAgyC3FBzJnoJxFuFzq0XSrett1mD8yiuh8nDSyPMWDnmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734469252; c=relaxed/simple;
	bh=INHCV9g7S0q1m2IVXiOJftwDpaPmTbEq/X94iWftqSU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lhafOGm8JUJh4Xe7MU0B8/kv5z6M9GnFvuKW4fZ8xo60OKuaMJqhkUTLeUWOZ8TcmyDNCyHdfHSSVNVeij5Rae0xKPrrhwhREf6pF+wS7pppaSKFDT5a0yo4yTm8jjGcT4SAmdUe1se6/wuawNzadQ+rhjGYjuJGBCbVU9s6dg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QM+9mkTs; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d41848901bso206077a12.0;
        Tue, 17 Dec 2024 13:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734469249; x=1735074049; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=INHCV9g7S0q1m2IVXiOJftwDpaPmTbEq/X94iWftqSU=;
        b=QM+9mkTsqpkoEqNawfZSe9gjHxumVgL6qjg3HRDWWDvuWxRQKfkx+k0nI/LplCRSDP
         GzY37PVVax8X4H9MDgL5WaHL6loSv4ssXPnKVVIbzjyrlXMoz9T5LPXjnYcFtE++4iLS
         pohl5FYaWCh4ngolyFhAWDyC9C4pQx9BxUQofIJ0+6a4pzMERVbnHzMu+Cs7xzAAFgfg
         D8tAX9sYTVDMWSh+gh9qsJTiJ3dqoIj4u8pWGDcrvGUO9yQ+aV/pK6Df5tMrtyM/uWsf
         4c5yocFy69gv2JqDpy6zMBKkQCJ/2sbZjPlck8fA1G3d/7YbeZnzW4ci1LWLhcos7ZOW
         K7yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734469249; x=1735074049;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=INHCV9g7S0q1m2IVXiOJftwDpaPmTbEq/X94iWftqSU=;
        b=A0vuYAevSgSLrqhGK5gq58FVytRw1lEFvWg1V7oxRuMQGEO52b2UsR6tWeMij7mZU8
         uJ0sxdfU8Y/3Z2QGIi25xnWHV94ZQJ9cWnPY/L8YHJRTyiXn6XShvOAVePOiTNOityNM
         ESH2RcYdBi6eNzBbaOWuz6J2fF3O8RwxQUkis5gd7CbZPx5Ib5TNkq5blwdlJf+pr9t4
         8jr0EszWQHjUarg2OVYV4kET7HXMu0TAlVbOYW1qHwQNHGnpRJzsNAJSiZc9JJlR7cSe
         rdFsBQ8ksRW5cipc0XjtSzz55xWujIpdmkKT1ud6Bd+E1WR/hl34SLY5tWB7TA39XegA
         FWJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeC/abErGLUXEzk1v53ZG/1eh6pLlzYPrWhJaiMnC1Ou41bdUsT11ZWyakWSYd2voCQ6N+0jG4iNkCA3M=@vger.kernel.org, AJvYcCWBsoz6Iy2IzmwjiysxkWV7D9wm3CYFl5ser8PkZrr/GXL4frLNR/plGjqUpbIP6dkqKD7qrAaPwA==@vger.kernel.org, AJvYcCXMedGwjujODWtNkAyA7GcIPdZk49CCra+xeMk7VX7xXNJxahhivNPHYWZraR+1MyCixBvIYookV9Glrdiv@vger.kernel.org
X-Gm-Message-State: AOJu0YzgXouRcOcRLFCGuISh8dZazF7eYvsPva8+u9fMHzUBU3SVK4x7
	0okansonmUi4oooHE06QcdscGw8ympck6XlyRukGiOth49Xz4QxlX3D1k0Ifkj2nfiMGokxUb2/
	QwtAEKZyJ2RRxGgO566p0t27Nt5U=
X-Gm-Gg: ASbGncvqLldBaiqtnZbewCZaSoS3SdrNexzO7qGffL4TaDrf6q4QqK2tWD8qG3WnUNq
	IiC2Tfz5MK7flMVRIM982q2ClSCa0yZCL51UZ
X-Google-Smtp-Source: AGHT+IFHf4Fsj2G5kYDkmrWOuJ0ZbLbpmTkR4fwRt0Klc0NOJT0DyBzTmeB2D0VpGqL4MxzKPGgpgwaEbImDj00MlCQ=
X-Received: by 2002:a05:6402:354d:b0:5d0:7282:6f22 with SMTP id
 4fb4d7f45d1cf-5d7d56175c1mr5324324a12.14.1734469249108; Tue, 17 Dec 2024
 13:00:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241203121424.19887-1-mengferry@linux.alibaba.com>
 <Z2BNHWFWgLjEMiAn@infradead.org> <CAJSP0QXU_uNqL-9LmLRkDdPPSdUAGdesQ2DFuCMHnjyEuREvXQ@mail.gmail.com>
 <0535520b-a6a6-4578-9aca-c698e148004e@linux.alibaba.com> <acaf46f3-3f6c-44c9-86b5-98aa7845f1b6@kernel.dk>
In-Reply-To: <acaf46f3-3f6c-44c9-86b5-98aa7845f1b6@kernel.dk>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 17 Dec 2024 16:00:37 -0500
Message-ID: <CAJSP0QWfSzD8Z+22SEjUMkG07nrBa+6WU_APYkrvwzNbScRRCw@mail.gmail.com>
Subject: Re: [PATCH 0/3][RFC] virtio-blk: add io_uring passthrough support for virtio-blk
To: Jens Axboe <axboe@kernel.dk>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>, Christoph Hellwig <hch@infradead.org>, 
	Ferry Meng <mengferry@linux.alibaba.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, linux-block@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 17 Dec 2024 at 12:54, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/16/24 11:08 PM, Jingbo Xu wrote:
> >> That's why I asked Jens to weigh in on whether there is a generic
> >> block layer solution here. If uring_cmd is faster then maybe a generic
> >> uring_cmd I/O interface can be defined without tying applications to
> >> device-specific commands. Or maybe the traditional io_uring code path
> >> can be optimized so that bypass is no longer attractive.
>
> It's not that the traditional io_uring code path is slower, it's in fact
> basically the same thing. It's that all the other jazz that happens
> below io_uring slows things down, which is why passthrough ends up being
> faster.

Are you happy with virtio_blk passthrough or do you want a different approach?

Stefan

