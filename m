Return-Path: <io-uring+bounces-2814-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0827995554F
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 06:16:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA6DC282A3E
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 04:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CFA13716D;
	Sat, 17 Aug 2024 04:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QNg5VmM+"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D9C22338
	for <io-uring@vger.kernel.org>; Sat, 17 Aug 2024 04:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723868201; cv=none; b=is+xLq4ZWW2Qj4NrB688Q+/z91qg+FHA/Qt0hKgtevWhDpjVPF7OnH1pfz6t7hTjLWiZZXdCpsuXPmPOu2ShQCN/WLIou7Rkk0Mkc++NgsGEAVPpTcFAz3V6iAIl3l3GXT8Lu5pT1Sgx9TEIvl4URqnhjq3jludzr4bUEvfj0/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723868201; c=relaxed/simple;
	bh=O9/l7v5MYEnlC0f5zH8ojBWCl7YKPKoB9f0eBBd92CA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=UXFA9U+NlAG+LXARBJMOnUTTy69Io1h+euBy0I4OQU8UekZYi2QSDhMRSCK1shGDxjc5lubj5VAvBLv6C4VtuKWa2KA+e0YtyJqP8KWnQRQrD7gj7DlIOExiNWbo9bDNLoj0OTqitkAfg5v3lGtlCACRARBhoXRJAHJ63j+zg1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QNg5VmM+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723868198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LiqVRaoulk/mY0QB38YEzeF4KeY9i1TXrrsn3lGI4aU=;
	b=QNg5VmM+lbLIg5je9lb/QTf6c52dnqmw05c+jUIPolnu8GT6EMDBLSUa5Yu0I74IZSSN8F
	730RF0vFvnI5BPqxdnJy3Gp6vVvxHEOpXJ7tSjDIfzHtwV4lx/CVPhtGxTYSOyxbaRLTrB
	bhKBvSERr2tjftTn6But/CH/BqvSRGk=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-WGT_73nvMAGU0c9mgU9iXA-1; Sat, 17 Aug 2024 00:16:36 -0400
X-MC-Unique: WGT_73nvMAGU0c9mgU9iXA-1
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-492a3346e4bso64917137.3
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 21:16:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723868196; x=1724472996;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LiqVRaoulk/mY0QB38YEzeF4KeY9i1TXrrsn3lGI4aU=;
        b=ZzyuQWsHwG3JTYRBumdH4XcgD10ePC3ijrHyVBmuoyBt9y/0PRxmfr/LYkFQdBNtco
         9Yw+/mHx+rpdHVes2T39V3ajQPhejrOZdA6ij3BIE4iDG3FktM3F7pIybFwVsuhsNeP3
         huE94bl54RVLgGexe+P4Zx3xIKg/6Q77H2CVfaidys/UdRlIiWsjHwogIaKmMziXHCR9
         GvzF2GbgKvqCNFbz/7OnSk6Bz+2aEzbWuRztXReTC6p6PHpqqi76oaJgpyXyiiVdxNKw
         3wtUZJxfjT2jLOFuPngxbtajNcuHDUny9aorptqd+E22uBJBAsDu5NDPKwmDxPPd6jr2
         9xAg==
X-Forwarded-Encrypted: i=1; AJvYcCXo7oI2Yi3nWiK1Borrfto8QsJTICUxKxTfI/7jnvd3b38hCxZyRHHGSwiPwqO1xDGuZxX4VbjY19n9y2F/Mo8H3tbQXnXpbZc=
X-Gm-Message-State: AOJu0YxOfhnALHmDeXGnKe7AWbIKxdRP2RCf6qpDRdL4bhh7aZjg4uq8
	T5FqoJdNhG7aQpqmCReYdQXNNMYCYJhC7QnOWr1FNM8flO0Ieh1TMK1sxjP8Eyrc8a+WwG8JSWt
	CdUic4yyIqEwJ9jcfQmKO5yXTeRlDsM85jOa6f80jC+comocetiuww8Ms+dOa9jRIsHcEk7N+ac
	NIIgfW+3SwVwm54DA3hvsgkGMFBLO6fsM=
X-Received: by 2002:a05:6102:5127:b0:492:a4f3:34c2 with SMTP id ada2fe7eead31-49779a409b6mr3094145137.5.1723868195808;
        Fri, 16 Aug 2024 21:16:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFsztqX8ZhdNatL778NuvEH/u9w9I5BJjMoYXfA03WqFWsKr785hzMGK4Fd6ZtrcZCRkVRd2QJnX7cr2X0NEw0=
X-Received: by 2002:a05:6102:5127:b0:492:a4f3:34c2 with SMTP id
 ada2fe7eead31-49779a409b6mr3094141137.5.1723868195494; Fri, 16 Aug 2024
 21:16:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240808162503.345913-1-ming.lei@redhat.com>
In-Reply-To: <20240808162503.345913-1-ming.lei@redhat.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Sat, 17 Aug 2024 12:16:24 +0800
Message-ID: <CAFj5m9L3FGhdFw61K9-iLWs=ak3OGmunEKC6Fs=SPYDVfcPAVg@mail.gmail.com>
Subject: Re: [PATCH V5 0/8] io_uring: support sqe group and provide group kbuf
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-block@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 12:25=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> Hello,
>
> The 1st 3 patches are cleanup, and prepare for adding sqe group.
>
> The 4th patch supports generic sqe group which is like link chain, but
> allows each sqe in group to be issued in parallel and the group shares
> same IO_LINK & IO_DRAIN boundary, so N:M dependency can be supported with
> sqe group & io link together. sqe group changes nothing on
> IOSQE_IO_LINK.
>
> The 5th patch supports one variant of sqe group: allow members to depend
> on group leader, so that kernel resource lifetime can be aligned with
> group leader or group, then any kernel resource can be shared in this
> sqe group, and can be used in generic device zero copy.
>
> The 6th & 7th patches supports providing sqe group buffer via the sqe
> group variant.
>
> The 8th patch supports ublk zero copy based on io_uring providing sqe
> group buffer.
>
> Tests:
>
> 1) pass liburing test
> - make runtests
>
> 2) write/pass two sqe group test cases:
>
> https://github.com/axboe/liburing/compare/master...ming1:liburing:sqe_gro=
up_v2
>
> - covers related sqe flags combination and linking groups, both nop and
> one multi-destination file copy.
>
> - cover failure handling test: fail leader IO or member IO in both single
>   group and linked groups, which is done in each sqe flags combination
>   test
>
> 3) ublksrv zero copy:
>
> ublksrv userspace implements zero copy by sqe group & provide group
> kbuf:
>
>         git clone https://github.com/ublk-org/ublksrv.git -b group-provid=
e-buf_v2
>         make test T=3Dloop/009:nbd/061    #ublk zc tests
>
> When running 64KB/512KB block size test on ublk-loop('ublk add -t loop --=
buffered_io -f $backing'),
> it is observed that perf is doubled.
>
> Any comments are welcome!
>
> V5:
>         - follow Pavel's suggestion to minimize change on io_uring fast c=
ode
>           path: sqe group code is called in by single 'if (unlikely())' f=
rom
>           both issue & completion code path
>
>         - simplify & re-write group request completion
>                 avoid to touch io-wq code by completing group leader via =
tw
>                 directly, just like ->task_complete
>
>                 re-write group member & leader completion handling, one
>                 simplification is always to free leader via the last memb=
er
>
>                 simplify queueing group members, not support issuing lead=
er
>                 and members in parallel
>
>         - fail the whole group if IO_*LINK & IO_DRAIN is set on group
>           members, and test code to cover this change
>
>         - misc cleanup

Hi Pavel,

V5 should address all your comments on V4, so care to take a look?

Thanks,


