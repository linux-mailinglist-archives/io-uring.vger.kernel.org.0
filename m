Return-Path: <io-uring+bounces-5502-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ECE69F35AC
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 17:19:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CE0118889C2
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 16:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 103922066DB;
	Mon, 16 Dec 2024 16:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hWRI19WO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2D22066D1;
	Mon, 16 Dec 2024 16:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734365653; cv=none; b=R0biebMCYHbUs0ve/sE3p+HUZIaRtzuolk+E5Rp35/YjzOIl81tj2dQ6l5X7b5hZfsWu320hm/6DXV7JSyl8wmwOdiKpaJEWefhq3BCMhpqjH3eqNM15rg60kHTdph7IVy0/jykDRcpDYGpzP7Nf5nE6J+htEjXIrHVQY6Insrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734365653; c=relaxed/simple;
	bh=Sn3chrE/m9+5fI4KxN090tU8mgWC4Aj8lyQMOoz6teM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u6XXWSVBPefUDH1jnLWPYRivJ7Dy33EJJ7Edi3xF8QWQsEpUYArYn+o88N6IF9VFEyTbP9JGhY4dmHnMp90Ucl8CADIU+p+hfxPlGSfeqq0anfO5XBAWxQ7451dDn74rlaEJ/dauE4ABXWSzskGv38Z/gPF0i4y14GeVDiA6z48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hWRI19WO; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5cecbddb574so7314329a12.1;
        Mon, 16 Dec 2024 08:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734365650; x=1734970450; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZHJ2lOqPcI4uWgZuisuf6hiF/EJ4Ewdtymu38Ng39Fs=;
        b=hWRI19WOvDHBJLOq6US846HUQfNvNvTYmuy8lYk9lJJ+DOMmOLh1QNRmCXVc1xeGp2
         hhZ0wbV3/yodngnNeeds+8yPa+kd43XA4u2HbrKipPRjjsmDzeO2J9coA0p62F8QAy4I
         2Pyi2gjhsIuxSvdMWayIc0vF544D/RswAo3cNta+BgTaPs0YM7/qo47dN0EFaVNNWeBo
         JKxdOFjndP6CEj7uDg/Sad8shtxXKrZnpTVvdLetduUFybW//XNyHH8wdqQjHIyIYU8r
         Lxd4xiz4LIxjj0Tco7RI80Xp2FTsZsny1voJiAbi2JScWf/vVUHFQsXbHY9q0zjQk0Vc
         JEIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734365650; x=1734970450;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZHJ2lOqPcI4uWgZuisuf6hiF/EJ4Ewdtymu38Ng39Fs=;
        b=Q+NP5qfU2eEwoUVTBh9G2beuvpgxU9wGSa5XS75O7Mvmj9tzQ66wWOT8uOgLDLM1OI
         ptdv9cyyflTqJXBXdu77fpdsXZORxlHI5O4dfJgAehx1stMal8grAAzW2/eCMUtgQ+Sh
         iDRuaGWdThXy4gzMLst4fshuf6YqYCRkmiQvewCNwOySG6dmTogSuY7iDDfhaQEl7SNn
         ZcYQpIh/ruS5shtKpPna8uxMenibWe45jwRIrhK4U31VJrf/U+UhUn0McndW1a1cbrbp
         xDq1D6xr2mA1gbwPOo1Z/ABJBl91mK5pgawLyuPDU/8uUnChaO/y45ZBISx5gClNJEWc
         cIWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpm+L6aZbXEGhuw0domRXexmcacGr9LkmU2nX3WLY3oVJw+jd5uno4ADOv9ZepvAwKkafT3H7lBRtwRcTl@vger.kernel.org, AJvYcCWe/EKMoH6RYwdDRF1yPBQFvkfuKG0CLgqsNP+DuIPgU+btFiXlVBrSFFT0/AuPZzN4BWIxcqr0aXfrn6Q=@vger.kernel.org, AJvYcCX0dEUtHvLHIKDz9dVFzgz+9cLziMQ+sim9f9WH6+JBkarjR4nOSHDq5NJXiQrSHuI2lsHxaAvSMA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy59TYO+NszgLlqJXBc7GGp8lxvY6LdDMsK5l7FbH/KFXOzxV52
	GIKRBGCunO3SOWQYgifGKyXFFtqJ8hIwUZvbSRNgHbtKRWC0/B5EOUqV/JR6yXjOwwxF+xp2EBP
	4QY2s3Y2E8Cmp1g1LrowoRGiTHJmx4Q==
X-Gm-Gg: ASbGncsE3LXxaKlfaOblEy5mRImza0CM2msbqDhSLR5uMZOG4QAdsgJjX+QCXdOgOKm
	TiLYFsdw94OpHPnR9FkXeI9dDFTScRQXL1+7t
X-Google-Smtp-Source: AGHT+IGpUyDeh2IFWn704xO0ehU/HUo5hO1pZVdfXYwfm9voS07OecSnnJ41T38qduxnCKav2XsaiBT/Q8IVjk4NfGI=
X-Received: by 2002:a05:6402:1914:b0:5d0:d91d:c195 with SMTP id
 4fb4d7f45d1cf-5d63c42dd88mr11156129a12.32.1734365649482; Mon, 16 Dec 2024
 08:14:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241203121424.19887-1-mengferry@linux.alibaba.com> <Z2BNHWFWgLjEMiAn@infradead.org>
In-Reply-To: <Z2BNHWFWgLjEMiAn@infradead.org>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Mon, 16 Dec 2024 11:13:57 -0500
Message-ID: <CAJSP0QXU_uNqL-9LmLRkDdPPSdUAGdesQ2DFuCMHnjyEuREvXQ@mail.gmail.com>
Subject: Re: [PATCH 0/3][RFC] virtio-blk: add io_uring passthrough support for virtio-blk
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
Cc: Ferry Meng <mengferry@linux.alibaba.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, linux-block@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Dec 2024 at 10:54, Christoph Hellwig <hch@infradead.org> wrote:
>
> Hacking passthrough into virtio_blk seems like not very good layering.
> If you have a use case where you want to use the core kernel virtio code
> but not the protocol drivers we'll probably need a virtqueue passthrough
> option of some kind.

I think people are finding that submitting I/O via uring_cmd is faster
than traditional io_uring. The use case isn't really passthrough, it's
bypass :).

That's why I asked Jens to weigh in on whether there is a generic
block layer solution here. If uring_cmd is faster then maybe a generic
uring_cmd I/O interface can be defined without tying applications to
device-specific commands. Or maybe the traditional io_uring code path
can be optimized so that bypass is no longer attractive.

The virtio-level virtqueue passthrough idea is interesting for use
cases that mix passthrough applications with non-passthrough
applications. VFIO isn't enough because it prevents sharing and
excludes non-passthrough applications. Something similar to  VDPA
might be able to pass through just a subset of virtqueues that
userspace could access via the vhost_vdpa driver. This approach
doesn't scale if many applications are running at the same time
because the number of virtqueues is finite and often the same as the
number of CPUs.

Stefan

