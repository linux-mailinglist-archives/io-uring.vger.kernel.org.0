Return-Path: <io-uring+bounces-1005-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F2A87D7FA
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 03:31:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B13C282BA1
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 02:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9D0636C;
	Sat, 16 Mar 2024 02:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SJoNKoSJ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E709D641
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 02:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710556274; cv=none; b=g2Z7CL5QNNflnYS9umB8H6kYa16VwmIjcHvg5HhcJ+760T8oUYd6GKtUnoeZ3ME+5qorl38OocD8EzmaC60PI40N78gRfNryNsv2E1ucK4dlAi08zuDST2hVpjQgbH1WVS9hh9yhM0MzMcUAsO56HtbQtc64rlNixZtGIJ8YUa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710556274; c=relaxed/simple;
	bh=9/jjR3U5q/i59Ny9aGyCYLFbY6vTcnXGlOKdKAfuHxI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ouje0493CbuEr1ey1cKoRflMkCHI8faEAOwaE91rDMDaGzdMdWuDw3sUQAsZ97oK8Let37S5dpHhg48JukTZkuJGMGkB0U6a5WU7wdNp4pNIha2G1XkOFHxI4YzDxFQkgThHUYC8+7AOnX0B3ivtaLz4hP8nKQetLUKYQYumVKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SJoNKoSJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710556271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LL2aiOudT2QmtdIqb/ELukW8Oe9P5VE/7KMlCFGljw4=;
	b=SJoNKoSJp9Jyjof2FApsqDXqLiTdRslz9r9WLKJK+5Ss35SoeuqhG1BUhGCXlsyfjlCtHd
	0oAEIpJrRF7m2CvMYG5bODqWg2gBzwJlt3Mh5HKXywD8oqIdFFCtnVDGVcVathyNMaUYEc
	4BMz9VNKLpjbyuTtZUdhBsIDEpJsSdw=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-DAfMAvfvNzK7x6xhYMY3Ag-1; Fri, 15 Mar 2024 22:31:09 -0400
X-MC-Unique: DAfMAvfvNzK7x6xhYMY3Ag-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5c683944ab0so441228a12.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 19:31:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710556268; x=1711161068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LL2aiOudT2QmtdIqb/ELukW8Oe9P5VE/7KMlCFGljw4=;
        b=usdlSRh/0qrgphEwDsP7m47AU9xtkjMqzTsMrMM+y6UqRTOFPrTZnVAS6aMWnscZN3
         4xwPK6mj8Z1Zj9aMjjzk5NgWGsBHX2ogHd3Gaq+DAuLyS6aOJ1jSKLu/w+L4rsM7BRsW
         EexaEGv8DKHi6JTRSEIPVednXfn3dQWH3GcpkXh1WZHo0OGva3OgCoufbHfx9k7rgDgs
         gKYpniZVTpY7IXKJuoZMMnVnUWOBSSsae3cCfRCEU2uPmlsDtRYOAtR/Jvem++yZ5JwB
         BCLHEJQXudWHGo/clL+4xaleCyl/6Yzzel1NyYjr0t7/bGR4IAoupE4dW8HcnAs2ThQP
         v/Ag==
X-Gm-Message-State: AOJu0YyDgYb2NU/7rL4/MGJhkISEmAEoHZtoTJJUHrRy34vZaZkmmBKD
	WKbPnRbWGdAY5RxxDFDgbXmQS+Svh6m52n0/FXuj6vfbtGMCjX7VjpL9EaMt7glOjL0kKPawDUx
	5gIbexsKGekha5LBnAIgNLJV92E12QV3pAjbwe7bs0eBQDyRVHU6oYDglEMA2SoAfW2g+cyrrWW
	vNwMRqzWvrQUM5Mp4G9UGljV8Bk/9Bkh0=
X-Received: by 2002:a05:620a:1a27:b0:789:d106:1dae with SMTP id bk39-20020a05620a1a2700b00789d1061daemr7394678qkb.5.1710555879670;
        Fri, 15 Mar 2024 19:24:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHykChZCjA10Rbu6b79SKOfaxiB0J3C+wqart0s2xWfsFik70q8LOk3+PFj74HrJ2XySwQA9h3yebMNvJG8A60=
X-Received: by 2002:a05:620a:1a27:b0:789:d106:1dae with SMTP id
 bk39-20020a05620a1a2700b00789d1061daemr7394673qkb.5.1710555879326; Fri, 15
 Mar 2024 19:24:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1710514702.git.asml.silence@gmail.com> <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
 <ZfT+CDCl+07rlRIp@fedora>
In-Reply-To: <ZfT+CDCl+07rlRIp@fedora>
From: Ming Lei <ming.lei@redhat.com>
Date: Sat, 16 Mar 2024 10:24:28 +0800
Message-ID: <CAFj5m9LXFxaeVyWgPGMiJLaueXkpcLz=506Bp_mhpjKU59eEnw@mail.gmail.com>
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>, 
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 16, 2024 at 10:04=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wro=
te:
>
> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
> >
> > On Fri, 15 Mar 2024 15:29:50 +0000, Pavel Begunkov wrote:
> > > Patch 1 is a fix.
> > >
> > > Patches 2-7 are cleanups mainly dealing with issue_flags conversions,
> > > misundertsandings of the flags and of the tw state. It'd be great to =
have
> > > even without even w/o the rest.
> > >
> > > 8-11 mandate ctx locking for task_work and finally removes the CQE
> > > caches, instead we post directly into the CQ. Note that the cache is
> > > used by multishot auxiliary completions.
> > >
> > > [...]
> >
> > Applied, thanks!
>
> Hi Jens and Pavel,
>
> Looks this patch causes hang when running './check ublk/002' in blktests.

Not take close look, and  I guess it hangs in

io_uring_cmd_del_cancelable() -> io_ring_submit_lock

[root@ktest-36 ~]# cat /proc/1420/stack
[<0>] io_uring_cmd_done+0x161/0x1c0
[<0>] ublk_stop_dev+0x10e/0x1b0 [ublk_drv]
[<0>] ublk_ctrl_uring_cmd+0xbc9/0x11e0 [ublk_drv]
[<0>] io_uring_cmd+0x9e/0x130
[<0>] io_issue_sqe+0x2d3/0x730
[<0>] io_wq_submit_work+0xd2/0x350
[<0>] io_worker_handle_work+0x12a/0x4b0
[<0>] io_wq_worker+0x101/0x390
[<0>] ret_from_fork+0x31/0x50
[<0>] ret_from_fork_asm+0x1a/0x30

(gdb) l *(io_uring_cmd_done+0x161)
0xffffffff817ed241 is in io_uring_cmd_done (./include/linux/list.h:985).
980 return !READ_ONCE(h->first);
981 }
982
983 static inline void __hlist_del(struct hlist_node *n)
984 {
985 struct hlist_node *next =3D n->next;
986 struct hlist_node **pprev =3D n->pprev;
987
988 WRITE_ONCE(*pprev, next);
989 if (next)


Thanks,


