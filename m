Return-Path: <io-uring+bounces-2771-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D75895279A
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 03:42:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FAA4282693
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 01:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD491878;
	Thu, 15 Aug 2024 01:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UecL9i5D"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E8117C9
	for <io-uring@vger.kernel.org>; Thu, 15 Aug 2024 01:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723686162; cv=none; b=nomEvkkJA9zZcV1BfPwzSKHz+MtAAUz7C/9OCs+yOZYBIJk4VrAXW0smFnQnjuIJFWxMHz76JBzWW+Etr/7ZwkdeekdHXCuIPvw9NlwblYAlu7MAVf8PuJ5HMCkJd7pV8EMAqAb5bqyw2MOwtt8ChVfit0yQbTMWxTsn6XvyZGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723686162; c=relaxed/simple;
	bh=E6FKHKidRonGKOHEN40H7P70gEg4mgWPuWn21CDjAUQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aglzQvK3YCAJkEWh0cEc6bdVvYGu/OWP/A8HV3NcHjYWjM5X4x9oZFX7AoyC7M5nlL4KfY2MGRMx0ARJcCHG7zky3hxZNk3f6qhWwRodci13oO6ekOX2Wzf/EmnJjyP/54TFhs2Z6VJb6GhxkZsBseZAjmugAsjXe0lFlU6Tmj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UecL9i5D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723686159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SDO7p1/rCt/Ulp3/NJW+f3wt6sswEX3iXmzKx2IC/YQ=;
	b=UecL9i5DgLJ1s01aef+sVOxzH2/5byQVcBFlxc/qAvJaLA9tYFgHsvK0Zqx2QvKvPVCBsf
	M8mOvsF+C8wrdpKHpSmC9iwnF+fDsFi9/nJ+VOHoXHpd09OH8Yi5JchwmmzBdKwnc1++p6
	NqFtoCh+cy/LkHsbXVpBtw/5zL9YL2o=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-Wot0uavvNsKQi_SW-tGo3A-1; Wed, 14 Aug 2024 21:42:37 -0400
X-MC-Unique: Wot0uavvNsKQi_SW-tGo3A-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-4928d06cfebso38152137.1
        for <io-uring@vger.kernel.org>; Wed, 14 Aug 2024 18:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723686157; x=1724290957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SDO7p1/rCt/Ulp3/NJW+f3wt6sswEX3iXmzKx2IC/YQ=;
        b=N92/g8ZtS6b2I2xB55qPjFmXdg+6Q17FjU6WYwDfLG/sr3k3frQAgzSkQD/Si4NexD
         kWAOD0AEyPz7aLTYlJJAXVarBrFNCnnRd2o5nhdw1+iiB8OKTIO9rgrNG7ln7Stttmhh
         otu03XrYL0y6MvWvM1h+AcV0v3o8yjAbgBbSXYkZCts4aJtZK9D0F384XnOoybhjdjVw
         ziTuww1PSWtUu7v2oeegLQpHrINEIIafaeYKOIWNT6BE29Yi+UD5zIObKUi9ZJFVd9yl
         T78H79AR2qcbkMv1X/9P3lcPzonKmY3JU6aSXX+chjKCQX1UzQbCDAzdTa/rZZGEVVDa
         n6Ag==
X-Gm-Message-State: AOJu0Yyn/Wf7DjaszfAaXveXZVn0YzGIdDhBsH/9dpo4a+A5tZJAKrDA
	3edoZCdeUTxmxIWEDSd+YHhhIqxUrHPoEeRb8O3uNuuDI7hc7yL0QHTtZHrvLiW23XUQcw8+Sks
	l4NNK6w7dJwMXmiKfEgr5cI/hJNMIEUIuVESrPbEBtIV9kh5t3GcPgj4pqLJjQ/S+Gks1EDJvOQ
	N0rWSZuuNJiFHaIrxgsmbVoYXnVWg+UoE=
X-Received: by 2002:a05:6122:1685:b0:4f5:312a:658a with SMTP id 71dfb90a1353d-4fc5aa5ccdamr732812e0c.0.1723686157158;
        Wed, 14 Aug 2024 18:42:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGkXgg3KEei4df4ZQe2BBMOv0cgXLjhI//+DZyaCr9SlaZy09JMcILmazo/fy8v4koEzrDcRzwJjOp/HiyDrY=
X-Received: by 2002:a05:6122:1685:b0:4f5:312a:658a with SMTP id
 71dfb90a1353d-4fc5aa5ccdamr732804e0c.0.1723686156775; Wed, 14 Aug 2024
 18:42:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1723601133.git.asml.silence@gmail.com> <6ecd7ab3386f63f1656dc766c1b5b038ff5353c2.1723601134.git.asml.silence@gmail.com>
In-Reply-To: <6ecd7ab3386f63f1656dc766c1b5b038ff5353c2.1723601134.git.asml.silence@gmail.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Thu, 15 Aug 2024 09:42:24 +0800
Message-ID: <CAFj5m9+CXS_b5kgFioFHTWivb6O+R9HytsSQEHcEzUM5SqHfgw@mail.gmail.com>
Subject: Re: [RFC 5/5] block: implement io_uring discard cmd
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2024 at 6:46=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> Add ->uring_cmd callback for block device files and use it to implement
> asynchronous discard. Normally, it first tries to execute the command
> from non-blocking context, which we limit to a single bio because
> otherwise one of sub-bios may need to wait for other bios, and we don't
> want to deal with partial IO. If non-blocking attempt fails, we'll retry
> it in a blocking context.
>
> Suggested-by: Conrad Meyer <conradmeyer@meta.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  block/blk.h             |  1 +
>  block/fops.c            |  2 +
>  block/ioctl.c           | 94 +++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/fs.h |  2 +
>  4 files changed, 99 insertions(+)
>
> diff --git a/block/blk.h b/block/blk.h
> index e180863f918b..5178c5ba6852 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -571,6 +571,7 @@ blk_mode_t file_to_blk_mode(struct file *file);
>  int truncate_bdev_range(struct block_device *bdev, blk_mode_t mode,
>                 loff_t lstart, loff_t lend);
>  long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
> +int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)=
;
>  long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long =
arg);
>
>  extern const struct address_space_operations def_blk_aops;
> diff --git a/block/fops.c b/block/fops.c
> index 9825c1713a49..8154b10b5abf 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -17,6 +17,7 @@
>  #include <linux/fs.h>
>  #include <linux/iomap.h>
>  #include <linux/module.h>
> +#include <linux/io_uring/cmd.h>
>  #include "blk.h"
>
>  static inline struct inode *bdev_file_inode(struct file *file)
> @@ -873,6 +874,7 @@ const struct file_operations def_blk_fops =3D {
>         .splice_read    =3D filemap_splice_read,
>         .splice_write   =3D iter_file_splice_write,
>         .fallocate      =3D blkdev_fallocate,
> +       .uring_cmd      =3D blkdev_uring_cmd,

Just be curious, we have IORING_OP_FALLOCATE already for sending
discard to block device, why is .uring_cmd added for this purpose?

Thanks,


