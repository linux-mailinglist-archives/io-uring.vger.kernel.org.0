Return-Path: <io-uring+bounces-5515-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0DC09F406C
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 03:13:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB4961885E88
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 02:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2909012F375;
	Tue, 17 Dec 2024 02:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HFNZ/0Vn"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846ED2B9CD
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 02:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734401566; cv=none; b=X178gbqq1DHlqYjT/CIpyKqW9U5jZwA54cOVp8B+PuMSelJO3zVOqdwE7OcgBAtvarh3mhhUYUvUk2KroXjbO50D6lromjv2SGIzcz0rjrfYHMjCzbbPn1myIIooa5KUiQGyKcS53kU+2Wtgj+KymEd/PtI+TbC/XYE4RXIc9Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734401566; c=relaxed/simple;
	bh=yLTlIFC32POHxZiPY9cw5QEBfX1gSNNQz6nVW4ixP5A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EpeULAlrYlew85Tx4fy5R/eXgvoSjhpKBI7kjW8jHf6b+6W7Y+K2/129VmmcYftTF2xRmg8nXbZMDVBkDTOVSU637mc+guWSvbD4bNJJPcWNgX2EMmbBYPuGxL/eED3P6mAVr3AdJ0zM3b0uwCZgWg3uGBX5HCj7sSbAc3Ixrd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HFNZ/0Vn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734401563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lx1OsaaoolFeL7wbx64aXWvFu5/zVMeLGy2oXijyrkI=;
	b=HFNZ/0VnyL0w7EUkNQCjmIxT4xuIb/TURW/q1uHMvzHztRIUgI2b4UuLwf8f618rn5Hzkl
	IKewVlb5DfLVw0AOqwDfEoisACHTxkL2bYs7GH1oZkZ2avsgTMO03p2q111jeh2/9jFhsO
	Jr9B5hViivwu8XWKvF8W+s4DUWjI8a8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-uTA3tFg6MB62qtb01CkPlQ-1; Mon, 16 Dec 2024 21:12:42 -0500
X-MC-Unique: uTA3tFg6MB62qtb01CkPlQ-1
X-Mimecast-MFC-AGG-ID: uTA3tFg6MB62qtb01CkPlQ
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2ee86953aeaso4232749a91.2
        for <io-uring@vger.kernel.org>; Mon, 16 Dec 2024 18:12:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734401561; x=1735006361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lx1OsaaoolFeL7wbx64aXWvFu5/zVMeLGy2oXijyrkI=;
        b=aY4VyUCzGD3ukC4pCvk9Bs42Fo/0+LKRv6vzD9niZvByVjDsGeoDnniT80KWP29r87
         jF/xRaLyp73/GYkyVp96JnjMF8p1Xlfwl16o4qlDrfoiKrXvmGHXnuycODNyU07Ow+3h
         zSKDCak8yevAm+6HFylZq22xdrQfZ4v4PaM6vlJrPjC0WAiFJIIJjcyGjCJQMHQZV54O
         6pohVtYAn4nkR7pEP4gCI94MgzKp111emHOewJolez5W6mawVdQLRh1/0RMaiCKRSOXZ
         +CAKtxhyJmMOSncq05ztDjBTpQ1vE0jip0WvykJ4sTnQq9CwZroyX1jF/iuwRgx7qwm4
         qLhw==
X-Forwarded-Encrypted: i=1; AJvYcCWKP4lNuTBmkzA64lerZD9VLNLcwTyKpBO2zdyn+FRTG+Nw7Nh4E4XvZ4rZJopsNruRbPekdm+N9A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHCz10eHuRSt/+jZwSW0JIfuTMXIICAByZRJY12Cv3o28XV7vd
	83sPhy8fRePGX6/0nlmRohelMAE1y+siI2ZU6Jo8ImShpuphNNXgG2+7ta0+vegHlF0W1bM09X7
	iVrN1W+WqXYAr53E2G3uKHjvAAkIuOn9J3+2x8sFX1KOs4ZV3fIcVLvBSOsFL/FSOFpk9IAvm3R
	Fn5S39mgn0J4jrLbYoPNVzm3g30gS5gV8=
X-Gm-Gg: ASbGncuI+Tz+bh47V/YIMRa2Opf8sSaULS9VjAIHLtCxMLNS+mvCfLWI7IxZKv77qt+
	a52pgqYl5Mw3xw6w4X6vNktgWtxatCZ/XZt/5DIo=
X-Received: by 2002:a17:90a:c2c6:b0:2f2:a664:df33 with SMTP id 98e67ed59e1d1-2f2d7d6d6c9mr2562031a91.1.1734401561234;
        Mon, 16 Dec 2024 18:12:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEWfOMwLE4xN7EgIgUmoj8RBxxJhD+t49TCaL2tr59Vru/vF26Eb336KxLuaGzGJG7u8TB7F89vPmau4TDvCMc=
X-Received: by 2002:a17:90a:c2c6:b0:2f2:a664:df33 with SMTP id
 98e67ed59e1d1-2f2d7d6d6c9mr2561996a91.1.1734401560849; Mon, 16 Dec 2024
 18:12:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241203121424.19887-1-mengferry@linux.alibaba.com>
 <Z2BNHWFWgLjEMiAn@infradead.org> <CAJSP0QXU_uNqL-9LmLRkDdPPSdUAGdesQ2DFuCMHnjyEuREvXQ@mail.gmail.com>
In-Reply-To: <CAJSP0QXU_uNqL-9LmLRkDdPPSdUAGdesQ2DFuCMHnjyEuREvXQ@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 17 Dec 2024 10:12:28 +0800
Message-ID: <CACGkMEtPdhrXnTYgF4eCC7x7fbh53hgOJ9TytYmZR=z+nFexTQ@mail.gmail.com>
Subject: Re: [PATCH 0/3][RFC] virtio-blk: add io_uring passthrough support for virtio-blk
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Ferry Meng <mengferry@linux.alibaba.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	linux-block@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Jeffle Xu <jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2024 at 12:14=E2=80=AFAM Stefan Hajnoczi <stefanha@gmail.co=
m> wrote:
>
> On Mon, 16 Dec 2024 at 10:54, Christoph Hellwig <hch@infradead.org> wrote=
:
> >
> > Hacking passthrough into virtio_blk seems like not very good layering.
> > If you have a use case where you want to use the core kernel virtio cod=
e
> > but not the protocol drivers we'll probably need a virtqueue passthroug=
h
> > option of some kind.
>
> I think people are finding that submitting I/O via uring_cmd is faster
> than traditional io_uring. The use case isn't really passthrough, it's
> bypass :).
>
> That's why I asked Jens to weigh in on whether there is a generic
> block layer solution here. If uring_cmd is faster then maybe a generic
> uring_cmd I/O interface can be defined without tying applications to
> device-specific commands. Or maybe the traditional io_uring code path
> can be optimized so that bypass is no longer attractive.
>
> The virtio-level virtqueue passthrough idea is interesting for use
> cases that mix passthrough applications with non-passthrough
> applications. VFIO isn't enough because it prevents sharing and
> excludes non-passthrough applications. Something similar to  VDPA
> might be able to pass through just a subset of virtqueues that
> userspace could access via the vhost_vdpa driver.

I thought it could be reused as a mixing approach like this. The vDPA
driver might just do a shadow virtqueue so in fact we just replace
io_uring here with the virtqueue. Or if we think vDPA is heavyweight,
vhost-blk could be another way.

> This approach
> doesn't scale if many applications are running at the same time
> because the number of virtqueues is finite and often the same as the
> number of CPUs.
>
> Stefan
>

Thanks


