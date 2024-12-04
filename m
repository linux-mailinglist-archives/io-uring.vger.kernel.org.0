Return-Path: <io-uring+bounces-5242-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECDAB9E471F
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 22:47:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4E3D1691C4
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 21:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420BF18FC83;
	Wed,  4 Dec 2024 21:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a6It1eNo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6280B2391A0;
	Wed,  4 Dec 2024 21:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733348854; cv=none; b=f8EPWhbB4xBFVeqjrae1G5BGQOrj+jMDkSpZdCDVAU1q0+JFM61YM6eYhueW0vR1DYA2RL5Lg9tu74TEyXPkaArsulmGBzJ18v9FsQLK2hmRrV8Zs5uxxry1i9jtZ5qctoL7hJZnPpChMEHcHCWIJoIzW5ZuH0OYRELLxnx4tIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733348854; c=relaxed/simple;
	bh=IJ+Tr5WrQEHCU2L/vBaaxP7MLc42N0SWwf2O9ZVrmJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FP1uRA52T4EdiapJi7Kc7PdMRQZLvNd0WOJAMOAM1IEXD8iPxe1RgFo0KT77arbRWC6pN3MuP7DgQyd4gXJ90h+xXa3ly1YV4yfFqnJn+rDgFyruE/yjY+H8Q7c44PbV5IL36DBJhwl4IlMK/Km83nXMH6VC63Jl4GDBfnZaluI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a6It1eNo; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d122cf8dd1so294974a12.2;
        Wed, 04 Dec 2024 13:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733348851; x=1733953651; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fKaI88AD29BFrp8QioqFZOOJyEQFk+/T1lAVWcKhhT8=;
        b=a6It1eNoFco4bdB2bLEqkTCAfvDiOFA1Yj8yhxEGEJWgXj0oK1Q70pxpMYZrb6S/hh
         zCgx5RDzOqKs7FLRbIXqg+zW8N5HUIeOE0kkqWvISLSym59uQL8odltQA94s4LyaHF65
         kIg9QfljDyJMyTP6gKyTgSUrgwIsap4/VkLTCC+yTBOeUFVrkU53j9l0wGpsI11l7O58
         kKgJekcfloZusDn0yZI/NLx7J7rkh3z51eNNm7wrBALfSbhZLxGzOmZgsauIdoNTbP/k
         h28xrJZL/iokGC8aM/66bwy4d5fMgLmqmgQKpzllw9LM6NLDbHMBWEmuwMJJDDqxcdXX
         0gvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733348851; x=1733953651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fKaI88AD29BFrp8QioqFZOOJyEQFk+/T1lAVWcKhhT8=;
        b=CZPrI2LniyuCMfx1LAoD+B1PZDSLH+zKEcNl9g+VMzj+tZdzaYVJYU6eGfyXgFAAHe
         aIir7Fjkhu0oVk+JyQDtSsoxaExEpUpGistTWwwk+lAAaKYRghBUJRSnAFY1/GZI5ffr
         9n3lP+m9eOVXNbeLGGHBRmc9Q2MJ7LK1IDUcrmHI+4ej1Et0WNnvSrBxnPbmVxK28nM5
         6FiezV6XlbHveI3s1wSf+aj2BdE2l0gOUWCWxFmJ8bNKhMRq19LVSi28rMSr6oJjNEbB
         jay7g2LQEcsr/YTocTSG3oX/or5/FKLovm0EDR/lPwX51a3+4Uteke9816oJTx3QX0gn
         bgCg==
X-Forwarded-Encrypted: i=1; AJvYcCV4Lo/XiwmAIFuOc/Dvzz7X3szifUkswwnnsVZrnOKHB1nEiaqJNVEl2caKGqTFDKyqfZVad4xEIA==@vger.kernel.org, AJvYcCXxtZ/S+2evXBD/zrV8GNoYMjtIjTVBkXonD9mejsKRoHGRZRW7StbDyMAwIv3hHQkeB4E8quzmOjyXxBve@vger.kernel.org, AJvYcCXyimpqz9mCWQw9mm1YgUjXGb6Gr2c8fhK6wsgvIaZBRR4tSmtrBQZWt4Hx2mbWel84MgyNvp9wGgIAfOI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+PQjjhbwEA2VGYyg2Y8Pa0eVpJCerc1pF4/WrViEJGwHE0uEo
	3SXGrf7Jh/PN9AY7taaROJqyEQbLXPGl4jyADvi2gyheeNT+nfkaqYd8SHbt2D72Rot/eE3DBNp
	9Lt4fpNILrzWHIxKIQATSqagrY+I=
X-Gm-Gg: ASbGncuQYk2+hHEUzHJwgrNUNNDnR0VS7841jig2QYDOsVUHx/FWQe8NiSZgDCFqqyX
	rZtJpN3EUUPiW6q2Xc7oLwbSvMR8XIA==
X-Google-Smtp-Source: AGHT+IGjeAWiYGkcl48wjHQuQfHn6HqZ1slDmfNXVWuNj+ailjPxy/721i4S3q0jxp+4ZIX1TsGbVhAz0VuLWgIFfBI=
X-Received: by 2002:a05:6402:40c3:b0:5cf:4527:4325 with SMTP id
 4fb4d7f45d1cf-5d113cf65c0mr7138144a12.24.1733348850513; Wed, 04 Dec 2024
 13:47:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241203121424.19887-1-mengferry@linux.alibaba.com>
In-Reply-To: <20241203121424.19887-1-mengferry@linux.alibaba.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 4 Dec 2024 16:47:18 -0500
Message-ID: <CAJSP0QW2GWNCtekar68bniwB6xX=ADsh7YjFjq_bQvExRNxnyA@mail.gmail.com>
Subject: Re: [PATCH 0/3][RFC] virtio-blk: add io_uring passthrough support for virtio-blk
To: Ferry Meng <mengferry@linux.alibaba.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, linux-block@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, virtualization@lists.linux.dev, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Dec 2024 at 07:17, Ferry Meng <mengferry@linux.alibaba.com> wrote=
:
>
> We seek to develop a more flexible way to use virtio-blk and bypass the b=
lock
> layer logic in order to accomplish certain performance optimizations. As =
a
> result, we referred to the implementation of io_uring passthrough in NVMe
> and implemented it in the virtio-blk driver. This patch series adds io_ur=
ing
> passthrough support for virtio-blk devices, resulting in lower submit lat=
ency
> and increased flexibility when utilizing virtio-blk.

First I thought this was similar to Stefano Garzarella's previous
virtio-blk io_uring passthrough work where a host io_uring was passed
through into the guest:
https://static.sched.com/hosted_files/kvmforum2020/9c/KVMForum_2020_io_urin=
g_passthrough_Stefano_Garzarella.pdf

But now I see this is a uring_cmd interface for sending virtio_blk
commands from userspace like the one offered by the NVMe driver.

Unlike NVMe, the virtio-blk command set is minimal and does not offer
a rich set of features. Is the motivation really virtio-blk command
passthrough or is the goal just to create a fast path for I/O?

If the goal is just a fast path for I/O, then maybe Jens would
consider a generic command set that is not device-specific? That way
any driver (NVMe, virtio-blk, etc) can implement this uring_cmd
interface and any application can use it without worrying about the
underlying command set. I think a generic fast path would be much more
useful to applications than driver-specific interfaces.

>
> To test this patch series, I changed fio's code:
> 1. Added virtio-blk support to engines/io_uring.c.
> 2. Added virtio-blk support to the t/io_uring.c testing tool.
> Link: https://github.com/jdmfr/fio
>
> Using t/io_uring-vblk, the performance of virtio-blk based on uring-cmd
> scales better than block device access. (such as below, Virtio-Blk with Q=
EMU,
> 1-depth fio)
> (passthru) read: IOPS=3D17.2k, BW=3D67.4MiB/s (70.6MB/s)
> slat (nsec): min=3D2907, max=3D43592, avg=3D3981.87, stdev=3D595.10
> clat (usec): min=3D38, max=3D285,avg=3D53.47, stdev=3D 8.28
> lat (usec): min=3D44, max=3D288, avg=3D57.45, stdev=3D 8.28
> (block) read: IOPS=3D15.3k, BW=3D59.8MiB/s (62.7MB/s)
> slat (nsec): min=3D3408, max=3D35366, avg=3D5102.17, stdev=3D790.79
> clat (usec): min=3D35, max=3D343, avg=3D59.63, stdev=3D10.26
> lat (usec): min=3D43, max=3D349, avg=3D64.73, stdev=3D10.21
>
> Testing the virtio-blk device with fio using 'engines=3Dio_uring_cmd'
> and 'engines=3Dio_uring' also demonstrates improvements in submit latency=
.
> (passthru) taskset -c 0 t/io_uring-vblk -b4096 -d8 -c4 -s4 -p0 -F1 -B0 -O=
0 -n1 -u1 /dev/vdcc0
> IOPS=3D189.80K, BW=3D741MiB/s, IOS/call=3D4/3
> IOPS=3D187.68K, BW=3D733MiB/s, IOS/call=3D4/3
> (block) taskset -c 0 t/io_uring-vblk -b4096 -d8 -c4 -s4 -p0 -F1 -B0 -O0 -=
n1 -u0 /dev/vdc
> IOPS=3D101.51K, BW=3D396MiB/s, IOS/call=3D4/3
> IOPS=3D100.01K, BW=3D390MiB/s, IOS/call=3D4/4
>
> The performance overhead of submitting IO can be decreased by 25% overall
> with this patch series. The implementation primarily references 'nvme io_=
uring
> passthrough', supporting io_uring_cmd through a separate character interf=
ace
> (temporarily named /dev/vdXc0). Since this is an early version, many
> details need to be taken into account and redesigned, like:
> =E2=97=8F Currently, it only considers READ/WRITE scenarios, some more co=
mplex operations
> not included like discard or zone ops.(Normal sqe64 is sufficient, in my =
opinion;
> following upgrades, sqe128 and cqe32 might not be needed).
> =E2=97=8F ......
>
> I would appreciate any useful recommendations.
>
> Ferry Meng (3):
>   virtio-blk: add virtio-blk chardev support.
>   virtio-blk: add uring_cmd support for I/O passthru on chardev.
>   virtio-blk: add uring_cmd iopoll support.
>
>  drivers/block/virtio_blk.c      | 325 +++++++++++++++++++++++++++++++-
>  include/uapi/linux/virtio_blk.h |  16 ++
>  2 files changed, 336 insertions(+), 5 deletions(-)
>
> --
> 2.43.5
>
>

