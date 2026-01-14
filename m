Return-Path: <io-uring+bounces-11720-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C200D217FF
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 23:09:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9209A3050591
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 22:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 669193B52F3;
	Wed, 14 Jan 2026 22:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ft8u+BrC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rpO+xKCB"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F1C3ACEE6
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 22:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768428543; cv=none; b=nO3ua3f/cSrUIuoWFt05Jo4/7KtfTBsC+08+ykfbSjG7u3WoS0JDrlIHuxVpp4aUXqZRF1StdFfLBFffGLTgiExU9hSgC2bzK/PVKhbXoZBAAvMiNedidXpkqutVnN/eaEpPQYyeKzWPCNVHcNvHGU/jFmGUUqZYQHzYMaWQGR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768428543; c=relaxed/simple;
	bh=X2pR4EyZ1p1PkaR9xG4NCt+loVj+lo3K4xT66OGYugo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u29xKFkYTjGwTU6uDZlPy4HaLT2S9kCTMKjL1/uiXCMYKdbc58Y3WrYSayDxxHbkdLQ18pUucpImTzAYQQCs+607TE72txp4+u0xr667vytDe/T0qDwoDGvhZa4iEg9r79AH78qWv1Mw0zXq8qI/A37scmtBp3ktkdSs3pEYFwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ft8u+BrC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rpO+xKCB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768428531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c5WjvJVLf0LB0Z2mLecxkbguMNv5LtVmwp/NDEi/7zI=;
	b=ft8u+BrCswuSdVYWZBqyA7pzsW/RadmWbVTQwFKNI23a9PWujTAbz0+tx6oDbH6mTdYBaY
	Ay+/2N60CFW4mFcOPp5Mxyg671IleyWspADL2LGjb9C8VPrlhvJya+7Z5xUw1kust6WQgD
	z3ZbU3pGbGB78UYuo/DVmfam/Ex6cW8=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-rlG3HCPlNXyRrlwoFsl3Sg-1; Wed, 14 Jan 2026 17:08:48 -0500
X-MC-Unique: rlG3HCPlNXyRrlwoFsl3Sg-1
X-Mimecast-MFC-AGG-ID: rlG3HCPlNXyRrlwoFsl3Sg_1768428527
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-38305c7a140so1286781fa.2
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 14:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768428526; x=1769033326; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c5WjvJVLf0LB0Z2mLecxkbguMNv5LtVmwp/NDEi/7zI=;
        b=rpO+xKCBRrSJUy77pVr7KbXJIVS00olWBy0rpcOQfngC790NFm621ngiUQ9napCbsM
         XPVMJqn8bGK0N8WkaTJ9xBaYaWz1yoQZ62qU93krX1AfEiFQ1mLcOS6v1sgKwC+7/f13
         I620C/EwS+D6xiC31xmV2O9MFxKYiwaKMWHGRqcWjyTWCRAUcu5yBRuJ11RmPQEMuzxp
         16ZLBfkfrxDaszrxpMnfEnrniod/PIlzsjup/gIlSOIgeCQlMMrEm1kUo2DSr2uEwTpU
         VVOxRDcuylgBfp6BjmCMdrvika0FD6dJHPC6sp3orjG74n9rIdfTRgOGgFceTk1RHOes
         dggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768428526; x=1769033326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c5WjvJVLf0LB0Z2mLecxkbguMNv5LtVmwp/NDEi/7zI=;
        b=a97WBha8ijSXiW8ppeWc4d7ezG5ILb09EB321h8GtnaVTXizOItYzwmlOz3UxLhiWA
         O3XJeM7ie0vvJ/MjliMt1DqdmssBAo21pzfyKGX/jndk1iYInnr0l13//ib3YqSybtwv
         WXucs6x2WJfG4W+fn0dfTYGTe1yOG11aZcvi9Lq+IlSTm5x6Y/X2MW+9FIwR7qrU/pAm
         g3U2w0LrPFsUt521+3DZku468I10Rgt/u2H3R8R1oFT5TVFSZrg/bMsOmmopNk9WT7gw
         MzzRxHQaoUmmeauhRekRwDb27ZLzhIkCjtofZxC1Aw2goFQBNyZ5iKQCc4sDBqC3J8nK
         mAig==
X-Gm-Message-State: AOJu0Yx5u/7Sv2GD1y79nWlO5I7pjsEqKISbvNMVUz2iShRimP1OczA4
	E9j09Eew4YhGQVSzF6VdNYWAihesG6hDxo5aPPqsCyu2BcJWBYI/WXqjZgakMsR3bwgpM88SEzE
	E1b0bKYodE+ciunRaqOAHkj0MjHYs3dR1cNhL1O19RHotEUQKO4ZFcYjwePQb71AGelFCQMHTdY
	P+9Tv+XsmLgNLOnkgxe1IMQ817ip59zuBff0i7J8PlmvaJlORMlBo=
X-Gm-Gg: AY/fxX6QadtZTO8reJirymLOHRzKh5BO9us9gSyEFXrwk4Qz8HiUM+/UAO3YjoJWfG/
	McgyetA4wwEkzyvQu2RFpok/GKOUdLngIQtQgEkAqIN/sKv46jNNyV4VhsgVErg+DhhZhSI+oWg
	sdNaollMUWQruNBhCMCZtnEHWcKDWmKHbXUZlpgu/dIfSsWTMWAJwp8EmUf1y72LBgzOc=
X-Received: by 2002:a2e:a9a5:0:b0:383:24fe:4e82 with SMTP id 38308e7fff4ca-383607dd5e3mr15811001fa.32.1768428525817;
        Wed, 14 Jan 2026 14:08:45 -0800 (PST)
X-Received: by 2002:a2e:a9a5:0:b0:383:24fe:4e82 with SMTP id
 38308e7fff4ca-383607dd5e3mr15810931fa.32.1768428525335; Wed, 14 Jan 2026
 14:08:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c008dbd2-6436-40da-b5c6-f34844878a6f@kernel.dk>
In-Reply-To: <c008dbd2-6436-40da-b5c6-f34844878a6f@kernel.dk>
From: Yi Zhang <yi.zhang@redhat.com>
Date: Thu, 15 Jan 2026 06:08:32 +0800
X-Gm-Features: AZwV_QiIrBgSTMkSt86M-qTHOsfmaSEQIXXcVgv8hcn1dCMJo6AVOEU4w1VFoOA
Message-ID: <CAHj4cs8=5Lifi8U+8mCnknxODYAeqD2_fS-zvkmWeb4hCp9z-A@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring: fix IOPOLL with passthrough I/O
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>, Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2026 at 11:29=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> A previous commit improving IOPOLL made an incorrect assumption that
> task_work isn't used with IOPOLL. This can cause crashes when doing
> passthrough I/O on nvme, where queueing the completion task_work will
> trample on the same memory that holds the completed list of requests.
>
> Fix it up by shuffling the members around, so we're not sharing any
> parts that end up getting used in this path.

I tried the v2 and confirmed the issue was fixed:

Tested-by: Yi Zhang <yi.zhang@redhat.com>


# ./check nvme/049
nvme/049 =3D> nvme0n1 (basic test for uring-passthrough I/O on /dev/ngX) [p=
assed]
    runtime    ...  7.991s
nvme/049 =3D> nvme1n1 (basic test for uring-passthrough I/O on /dev/ngX) [p=
assed]
    runtime    ...  7.970s
nvme/049 =3D> nvme2n1 (basic test for uring-passthrough I/O on /dev/ngX) [p=
assed]
    runtime    ...  7.965s
nvme/049 =3D> nvme3n1 (basic test for uring-passthrough I/O on /dev/ngX) [p=
assed]
    runtime    ...  7.975s
nvme/049 =3D> nvme4n1 (basic test for uring-passthrough I/O on /dev/ngX) [p=
assed]
    runtime    ...  8.003s
nvme/049 =3D> nvme5n1 (basic test for uring-passthrough I/O on /dev/ngX) [p=
assed]
    runtime    ...  7.999s

>
> Fixes: 3c7d76d6128a ("io_uring: IOPOLL polling improvements")
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Link: https://lore.kernel.org/linux-block/CAHj4cs_SLPj9v9w5MgfzHKy+983enP=
x3ZQY2kMuMJ1202DBefw@mail.gmail.com/
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> v2: ensure ->iopoll_start is read before doing actual polling
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index e4c804f99c30..211686ad89fd 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -713,13 +713,10 @@ struct io_kiocb {
>         atomic_t                        refs;
>         bool                            cancel_seq_set;
>
> -       /*
> -        * IOPOLL doesn't use task_work, so use the ->iopoll_node list
> -        * entry to manage pending iopoll requests.
> -        */
>         union {
>                 struct io_task_work     io_task_work;
> -               struct list_head        iopoll_node;
> +               /* For IOPOLL setup queues, with hybrid polling */
> +               u64                     iopoll_start;
>         };
>
>         union {
> @@ -728,8 +725,8 @@ struct io_kiocb {
>                  * poll
>                  */
>                 struct hlist_node       hash_node;
> -               /* For IOPOLL setup queues, with hybrid polling */
> -               u64                     iopoll_start;
> +               /* IOPOLL completion handling */
> +               struct list_head        iopoll_node;
>                 /* for private io_kiocb freeing */
>                 struct rcu_head         rcu_head;
>         };
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 307f1f39d9f3..c33c533a267e 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -1296,12 +1296,13 @@ static int io_uring_hybrid_poll(struct io_kiocb *=
req,
>                                 struct io_comp_batch *iob, unsigned int p=
oll_flags)
>  {
>         struct io_ring_ctx *ctx =3D req->ctx;
> -       u64 runtime, sleep_time;
> +       u64 runtime, sleep_time, iopoll_start;
>         int ret;
>
> +       iopoll_start =3D READ_ONCE(req->iopoll_start);
>         sleep_time =3D io_hybrid_iopoll_delay(ctx, req);
>         ret =3D io_uring_classic_poll(req, iob, poll_flags);
> -       runtime =3D ktime_get_ns() - req->iopoll_start - sleep_time;
> +       runtime =3D ktime_get_ns() - iopoll_start - sleep_time;
>
>         /*
>          * Use minimum sleep time if we're polling devices with different
> --
> Jens Axboe
>


--=20
Best Regards,
  Yi Zhang


