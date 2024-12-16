Return-Path: <io-uring+bounces-5498-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D284B9F2B03
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 08:39:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5308C1888F06
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 07:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 899231F7096;
	Mon, 16 Dec 2024 07:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IS29diS5"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F6A1F7093
	for <io-uring@vger.kernel.org>; Mon, 16 Dec 2024 07:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734334739; cv=none; b=PUOpZhdfRX4t2pSe6v9sfHWBjrBQQ6ZJmMHCNmR5/16GS63SyAL0F/PjoCc8Zd62z654uF0zwp9A99+aw9NlRGubBx8WfIBLFt9krU3FRP5ao2HXu0BeKRYOXhDgynhtS2Vny1syXIf2IbEaGXCYGFf4nmvJ7Ql75b92TwuoIlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734334739; c=relaxed/simple;
	bh=3pNaM1YfE2UVhLcTpBnTmligBHcggqB0+5jBqTTBZgc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gio7KQmEyPL3JA7s/WqBH2hXTDmO3ioLFsqBztQ6bJ3/zSzXnwC+JHrdu1rY55SVDKwRaKT72VzED5fLv5A1KWEaESXeM7wKFG9ncQk9if7vT6imzi4jQE91YHiK/kz9/1guRgfCsuV9eCXKSjejoPN9dhASxkei1X8O5rd+Lr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IS29diS5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734334736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7btIxl0I/5GL5jIBG+4D/1C7xmoGgE0Ue5vy6Ib9S6I=;
	b=IS29diS5shxmBCF0HbC1yT4CaZH1nZAvg3C6KQXbVazUpySei1xsmg8CMWCLyEUAj104pq
	4zi1hT1nF2AfGBZbGJn/9A1YZ5CXF1yoSlEcETMYM2cR1n4vC+hmdxm5nvS0jxZQpHQR56
	MzMVaV2uVgO9N2+GmYF97MngiGI16nI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-HJ3xew7rPJ27UZR6-k1WcQ-1; Mon, 16 Dec 2024 02:38:54 -0500
X-MC-Unique: HJ3xew7rPJ27UZR6-k1WcQ-1
X-Mimecast-MFC-AGG-ID: HJ3xew7rPJ27UZR6-k1WcQ
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2ee86953aeaso3372159a91.2
        for <io-uring@vger.kernel.org>; Sun, 15 Dec 2024 23:38:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734334733; x=1734939533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7btIxl0I/5GL5jIBG+4D/1C7xmoGgE0Ue5vy6Ib9S6I=;
        b=DQ/riMb4GNzeZBzrT4Vq4bJ0Gk1H9hLj5Y27DvRDsDuWQneybSAVFw6j4ra5xJd8wr
         2ZNkgsZUKQJjkbWO17aEM9aow0Bjhh4bi3bzk2nReSmXilJTpfbw9NwXnaNRYmFp4dKw
         T8ftGHDfftFifUzNID+xqt0h0Kh46XeMAeUQ2yBWGYbfG4eKpjO0VlaQ+4lxi1ENLmLv
         C1/5iyKW7osN/3RD3D3skKBWDoIwZI5Kxgw4VzcBJcl88d2pCIa65dHpWISAYgmcLrJQ
         ROY+1aL6CJVP/LPSLYKABQnU9mJGDf3KDgMYPWz9sEhy22ON9uddj1q2R9zkWY6y26Fv
         w1Cw==
X-Forwarded-Encrypted: i=1; AJvYcCUbo5nEyTb7d3xvBrG0nOjIr9K407Q6y/ywhETlxEzfHGNEQkGQA1yvVeNcKu9IAk5P1UaZeAm/SA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzhJiEBaX9So5yK+UFzhnkXD85culMiWfySKIBMtXJe4fc+elH3
	Q8U0OA8J1TRFIys9d9RvB4DabM1TU80eIwyhY0/5FHKmiI/fAEH/77XsjHIY4quql7Y98jAVf4F
	0d4v/SpK8Vkp+QCIieYYqdaca0Ex3GMyWydER9w9IeRcx+f4ADjOxDQR0LUDfFXCG3ivlkJDQ/2
	Gyb+gFwvPuQTPMN4i1zTDhaEhUvyBQ6SAfCFGYydQ=
X-Gm-Gg: ASbGnctbuPIA4njob069QM0zSEGRVABGXdtMbH8JCBqgqlAt2gjztlyXFnMljko5rvG
	L7QtEQldoOK3AQMMRuu8CZMi4Lbq1tIYiwFmb4LM=
X-Received: by 2002:a17:90b:4c12:b0:2ee:97d1:d818 with SMTP id 98e67ed59e1d1-2f28fb5060amr16268216a91.3.1734334733617;
        Sun, 15 Dec 2024 23:38:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFaM8RTKKP0AQqAiQH8PDIO4GC+uugqyOOQfClkGY2zjYqFPx3vPpIcrBgvnI0U66uTMndB7hGCm1+y/89c5ww=
X-Received: by 2002:a17:90b:4c12:b0:2ee:97d1:d818 with SMTP id
 98e67ed59e1d1-2f28fb5060amr16268195a91.3.1734334733156; Sun, 15 Dec 2024
 23:38:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241203121424.19887-1-mengferry@linux.alibaba.com> <2d4ad724-f9da-4502-9079-432935f5719d@linux.alibaba.com>
In-Reply-To: <2d4ad724-f9da-4502-9079-432935f5719d@linux.alibaba.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 16 Dec 2024 15:38:42 +0800
Message-ID: <CACGkMEuAgAcCDrCMhNHr7gcRB6NtMPPLdSFAOGdt4dXGoQr4Yg@mail.gmail.com>
Subject: Re: [PATCH 0/3][RFC] virtio-blk: add io_uring passthrough support for virtio-blk
To: Ferry Meng <mengferry@linux.alibaba.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, linux-block@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, virtualization@lists.linux.dev, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Jeffle Xu <jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 16, 2024 at 10:01=E2=80=AFAM Ferry Meng <mengferry@linux.alibab=
a.com> wrote:
>
>
> On 12/3/24 8:14 PM, Ferry Meng wrote:
> > We seek to develop a more flexible way to use virtio-blk and bypass the=
 block
> > layer logic in order to accomplish certain performance optimizations. A=
s a
> > result, we referred to the implementation of io_uring passthrough in NV=
Me
> > and implemented it in the virtio-blk driver. This patch series adds io_=
uring
> > passthrough support for virtio-blk devices, resulting in lower submit l=
atency
> > and increased flexibility when utilizing virtio-blk.
> >
> > To test this patch series, I changed fio's code:
> > 1. Added virtio-blk support to engines/io_uring.c.
> > 2. Added virtio-blk support to the t/io_uring.c testing tool.
> > Link: https://github.com/jdmfr/fio
> >
> > Using t/io_uring-vblk, the performance of virtio-blk based on uring-cmd
> > scales better than block device access. (such as below, Virtio-Blk with=
 QEMU,
> > 1-depth fio)
> > (passthru) read: IOPS=3D17.2k, BW=3D67.4MiB/s (70.6MB/s)
> > slat (nsec): min=3D2907, max=3D43592, avg=3D3981.87, stdev=3D595.10
> > clat (usec): min=3D38, max=3D285,avg=3D53.47, stdev=3D 8.28
> > lat (usec): min=3D44, max=3D288, avg=3D57.45, stdev=3D 8.28
> > (block) read: IOPS=3D15.3k, BW=3D59.8MiB/s (62.7MB/s)
> > slat (nsec): min=3D3408, max=3D35366, avg=3D5102.17, stdev=3D790.79
> > clat (usec): min=3D35, max=3D343, avg=3D59.63, stdev=3D10.26
> > lat (usec): min=3D43, max=3D349, avg=3D64.73, stdev=3D10.21
> >
> > Testing the virtio-blk device with fio using 'engines=3Dio_uring_cmd'
> > and 'engines=3Dio_uring' also demonstrates improvements in submit laten=
cy.
> > (passthru) taskset -c 0 t/io_uring-vblk -b4096 -d8 -c4 -s4 -p0 -F1 -B0 =
-O0 -n1 -u1 /dev/vdcc0
> > IOPS=3D189.80K, BW=3D741MiB/s, IOS/call=3D4/3
> > IOPS=3D187.68K, BW=3D733MiB/s, IOS/call=3D4/3
> > (block) taskset -c 0 t/io_uring-vblk -b4096 -d8 -c4 -s4 -p0 -F1 -B0 -O0=
 -n1 -u0 /dev/vdc
> > IOPS=3D101.51K, BW=3D396MiB/s, IOS/call=3D4/3
> > IOPS=3D100.01K, BW=3D390MiB/s, IOS/call=3D4/4
> >
> > The performance overhead of submitting IO can be decreased by 25% overa=
ll
> > with this patch series. The implementation primarily references 'nvme i=
o_uring
> > passthrough', supporting io_uring_cmd through a separate character inte=
rface
> > (temporarily named /dev/vdXc0). Since this is an early version, many
> > details need to be taken into account and redesigned, like:
> > =E2=97=8F Currently, it only considers READ/WRITE scenarios, some more =
complex operations
> > not included like discard or zone ops.(Normal sqe64 is sufficient, in m=
y opinion;
> > following upgrades, sqe128 and cqe32 might not be needed).
> > =E2=97=8F ......
> >
> > I would appreciate any useful recommendations.
> >
> > Ferry Meng (3):
> >    virtio-blk: add virtio-blk chardev support.
> >    virtio-blk: add uring_cmd support for I/O passthru on chardev.
> >    virtio-blk: add uring_cmd iopoll support.
> >
> >   drivers/block/virtio_blk.c      | 325 +++++++++++++++++++++++++++++++=
-
> >   include/uapi/linux/virtio_blk.h |  16 ++
> >   2 files changed, 336 insertions(+), 5 deletions(-)
>
> Hi, Micheal & Jason :
>
> What about yours' opinion? As virtio-blk maintainer. Looking forward to
> your reply.
>
> Thanks

If I understand this correctly, this proposal wants to make io_uring a
transport of the virito-blk command. So the application doesn't need
to worry about compatibility etc. This seems to be fine.

But I wonder what's the security consideration, for example do we
allow all virtio-blk commands to be passthroughs and why.

Thanks

>


