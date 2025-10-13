Return-Path: <io-uring+bounces-9971-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AE440BD17C2
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 07:44:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7A32E4EA8F3
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 05:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B69C2DC776;
	Mon, 13 Oct 2025 05:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+I7ZrtE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FAA2DC76E
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 05:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760334272; cv=none; b=YWddYd1XFMvQdmXLoLT/gBxIltyMjOVxf5xDSon2oKR+D1uMFft6QsGhUmRLCPwJaXJaCcukTk+MvlwJSQG4TcJJfpz5fmO5iM082PU0fPAcV1/r0TZ2YqkEL1m1jeiFpwqdFPCUMcIXUqtgG6OY5Le3sdeNkiDoO/f2v8gOOoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760334272; c=relaxed/simple;
	bh=Vluz9ytPQeMtlO7P9ORKtagTdZgZUvCkj7WhJdLaLOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GdTEhYHU7TQVQUDjgK34Dlksr47bzwh379MUAX3EK+7uF6KLyJlXOASgpnAWOydpfCKAArUCQbX3bb9Yhik73lQS0mxMqVIhbSU8lxOz+iE3qowecv7tQ0484MYjkmYjlRDZ2wfAjEEWuH2DxECOqXZYP3oiAjCzznZUU7XVgDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y+I7ZrtE; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-54b27d51ef7so610522e0c.1
        for <io-uring@vger.kernel.org>; Sun, 12 Oct 2025 22:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760334270; x=1760939070; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PfZ0cjDYVK5lhFzxXW1zOC477aQ4q/mTU1VD2TvA1nQ=;
        b=Y+I7ZrtEUyrbBVyxb/pwVHSPm/NUjdcUN7p2QIOR2Gc76JioaCNAHT0DpUo4aQJBuh
         6U3XRCAD4pT22cE0CZIrWjFoF94AIvPb3sECA4AIwObH5az4F4oBgbgRjAHJ04DUSgIN
         cgJWnI10SIM9wQD8DIf6C2A8ZivTesUbfjQGHDwE2Xta85NwyTJaH02gd6HZZnUc2Iqh
         /b9tlDquyWgeVVEOknwdr29PWPcBZODGzVtZOZKagmwsoSyx+ITO/MQ4LKrvzqej7/Nv
         t+me5XWphNc1k+F81d5qH4Z8A1bOgpxWdzw1oKqHAm1sQO0Uy4SnSje7hng2iB1YlAnS
         JpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760334270; x=1760939070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PfZ0cjDYVK5lhFzxXW1zOC477aQ4q/mTU1VD2TvA1nQ=;
        b=Hx19IVBHCUeABgpsi2MQWHihn5a6QzeeSSxfBwZvxjpAB/9WtKCJyjauB5SQIDWaFL
         7hbGNaCr7BVk5FLAyVuWPtDHI7QkLcG7ZRyJvmv5jwt1qEqNrUdhQR8xCZWhQjv/lMy+
         TewN85Tgg18B7L+1Od/nIkcbWSAu9HG6aHPMDmj9cl2YhBSycUi0shdxR28FZvMYgNuW
         BYD+u2VIxg3Vo096qI3yYoFhqeOFzJsTTluO0hmj77zmknt0s8uaIzvic0va7UAdTDXh
         c6QqVMKc/Vw2bkL3asBBmMmqlt+JUZn9m4Vu9UoVL1RfFcycMsd+TvVHVWMDMvNSZB8R
         VqtA==
X-Forwarded-Encrypted: i=1; AJvYcCW40gzzS802gC2fScjxOIWPBi++CroxJQaHgP2tMLmmWAY2FxW7Vu4PUnbnOT+EjqKHa2Ky8OumSw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxVm6WdJ2bXwZ1Kz78iIO0+0qdl+hkYsWczXwzyGCp1Zz3Eb8u6
	onpLgPqp5FIseB2Vc8W6aUxkg4tPCtmOsO8tVl2+XzpKNKcDbS4Bgp753iILXhveMwdbGi/Sy5J
	4JYQZEa/VDRzVXL/ooDS6q+nGgjYx9Nk=
X-Gm-Gg: ASbGncsUB3ws3mGhvtl1wpIfGB4u/eCYNoIi6NicP0oGR/Bp/3XRQvpcPwkiP1WRngA
	DLsEJbnRgqCVSqN+V/lIa+oGSpgtxEQ7IU/snL+PAAfN0qNU09IBynoGCrY+JPIUH3iFz0H5ypX
	SGUKQAQNLRrHTNIg0/NRbXsD7i6eSG4s3027gK0toPRFjtHmXLnAxmCqypido0yQmWU1srZoIsq
	qseQoHJGzIsOVYwc+f78ru9xX4=
X-Google-Smtp-Source: AGHT+IHpSmXJAORlFvfBjiO5EpZknUsClCESfr6miv9ORXUHlNjIb1jckJtzwj7e3Gce86ucBxKeE0hLKTbq4g4SBL8=
X-Received: by 2002:a67:e009:0:10b0:5d5:f437:92d5 with SMTP id
 ada2fe7eead31-5d5f43792efmr3865770137.3.1760334270191; Sun, 12 Oct 2025
 22:44:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251011013312.20698-1-changfengnan@bytedance.com> <aOyLlFUNEKi2_vXT@fedora>
In-Reply-To: <aOyLlFUNEKi2_vXT@fedora>
From: fengnan chang <fengnanchang@gmail.com>
Date: Mon, 13 Oct 2025 13:44:19 +0800
X-Gm-Features: AS18NWD8kq6UQsDDGG0qKmrz3bfZhv6wKElSNkMZ019t6wf6DXrrEBmZE82HmfY
Message-ID: <CALWNXx_J5L1fjTrVA5ChXsPdGk5E5HSuNHUO183mVat6GZdo=g@mail.gmail.com>
Subject: Re: [PATCH] block: enable per-cpu bio cache by default
To: Ming Lei <ming.lei@redhat.com>
Cc: Fengnan Chang <changfengnan@bytedance.com>, axboe@kernel.dk, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, jack@suse.cz, asml.silence@gmail.com, willy@infradead.org, 
	djwong@kernel.org, hch@infradead.org, ritesh.list@gmail.com, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 1:19=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Sat, Oct 11, 2025 at 09:33:12AM +0800, Fengnan Chang wrote:
> > Per cpu bio cache was only used in the io_uring + raw block device,
> > after commit 12e4e8c7ab59 ("io_uring/rw: enable bio caches for IRQ
> > rw"),  bio_put is safe for task and irq context, bio_alloc_bioset is
> > safe for task context and no one calls in irq context, so we can enable
> > per cpu bio cache by default.
> >
> > Benchmarked with t/io_uring and ext4+nvme:
> > taskset -c 6 /root/fio/t/io_uring  -p0 -d128 -b4096 -s1 -c1 -F1 -B1 -R1
> > -X1 -n1 -P1  /mnt/testfile
> > base IOPS is 562K, patch IOPS is 574K. The CPU usage of bio_alloc_biose=
t
> > decrease from 1.42% to 1.22%.
> >
> > The worst case is allocate bio in CPU A but free in CPU B, still use
> > t/io_uring and ext4+nvme:
> > base IOPS is 648K, patch IOPS is 647K.
>
> Just be curious, how do you run the remote bio free test? If the nvme is =
1:1
> mapping, you may not trigger it.

I modified the nvme driver, reduce the number of queues.

>
> BTW, ublk has this kind of remote bio free trouble, but not see IOPS drop
> with this patch.
>
> The patch itself looks fine for me.
>
>
> Thanks,
> Ming
>
>

