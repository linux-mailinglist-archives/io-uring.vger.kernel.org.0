Return-Path: <io-uring+bounces-5470-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5E2C9F0261
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 02:41:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70CDF28551C
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 01:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD471F95E;
	Fri, 13 Dec 2024 01:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kDx4npIr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B3D17BA1;
	Fri, 13 Dec 2024 01:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734054084; cv=none; b=kRh0f8Xe0ogV92e0YrG3FK24S14bZBej87k6fTTltoq2pMVCO979z6wc5upWEqTZtbz7RbO76N/nMJMAUwwywzoDuk/eC6ei+chGNUp7PoSzKbwKs3MHMYM1W6mo4swWj/rEQgMqCR+2n3MgGK8t52xKe5EjUzDWNzxBfbYqfFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734054084; c=relaxed/simple;
	bh=BOcbPZ7Zy/kzmIDP1Ntl5ZMa5BxR3I2l7FvIGpVJ4nU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=akcH9D0hFI6K1f8vS9wCsy8REKpFtHfCBHTk5mRGxCXrC8j+J7868DCSod26BTgNUSIGrtIWY6LXNTGzG2uoePD5h+wFfJhVX+w7ehekkDDxfLrvxZQJFv2YQPvqNzme3jgtIpdjyTXiiPQcYsU/ug0LpPVmxHJU5v9emhqqXCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kDx4npIr; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7b68e73188cso147353585a.0;
        Thu, 12 Dec 2024 17:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734054082; x=1734658882; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W9Vw3wI3qoyHZavfODkszBeG55pY3i/Phzlwyf4XUk0=;
        b=kDx4npIrDgZ0NkkZLfFaxYjMdEiaeylSu6prKcuVQL5f6QcKf7fYW7la/zMt6rzWNr
         l5UWAZ6nofdVW72+hN1BjZCHXZ5MlpNFXeiiLpUjescuOsbwxodzxq4cfEQDFAdjj+i6
         lOeYte6/n7sfh1MnMMr8BVO+vOhsbzV3Lf+u8PIE1UIAzXA5qRqBvdBRY9yUb8ULZiv5
         LPfeJUHlObBS9imbsxuTeePrFwgjgECb/1GTL+mVCk2gLF0AxiFclpOT4D6HgTMLqQ0j
         PntSM8fO/eLPSwAOSE5gC8k8+LhU1OaQGXW9A/pQN13GgeF2EmL4mTo44+3J6s3+sxta
         21Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734054082; x=1734658882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W9Vw3wI3qoyHZavfODkszBeG55pY3i/Phzlwyf4XUk0=;
        b=EW3b+2K1594tH02sloHS0E3YbXCVrfJ5asuEoFtzJjwrbetXutgu+qCI/JKHdcEyPg
         s/se29+9zaCFsQYrB+jzQhCb7ZIIGbu1UfdRNQ8io27Xl0WDqY6SYm5WBw3RDh20odGX
         L3LF8Z6yhnvY1chMFcH3L8xfo1ujWQn1v+VZPp/nJU2RFhXxziZiWuoUuKspOiNnVosx
         hXKKZoU7RRRRFrmw5GftGShoR47H39o4U05OF1sg2PfbZJ3Nk28hucn2H+PBVuMpPT9K
         hteV8FAKUn2L02unHYrhMma1k5JRsPcdulw+HpzO4KaOJyiHsToTK3urvgr8Of2Sm7hQ
         p5Lg==
X-Forwarded-Encrypted: i=1; AJvYcCVa5q17rtxC9TLZ2rTrCiB7wtALM6KSb91KI7NDcHW1bPNKIZ40rBU48r1IlUlpPuCbIILhoU+xmw==@vger.kernel.org, AJvYcCXulokjOI1/TakW6204+0tCMAx2CPUrHwvy53F0DNf7T55b897tO528tb+mmjGZ/TpT3AVBtO0uRReHhU5BOA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzlqEZKVb4nzEy60DQtpPJt4SjtK0U3i7HLTuvMLcuI5+aCmY9D
	pbWbqhFMBXWYwuyrfF9Nr9jlSAwCmglSMeZcnZYCvtvc16vD1hAX6YacWEMUfg9q9Y5EhHGOKX9
	2m+Jxc+iKISF+UC8OsYT/61hV3P4=
X-Gm-Gg: ASbGncuo3JBVOlGzCwaMOaM/4mURa+kfGUCdY7HFzPh/Us3KAL97Ut4Ff1IrRlhT84D
	GqNWGPZ4VogtUyXTdCMpFsDY0zhRjn9okoyo4OMclnzVisOfWB1xv
X-Google-Smtp-Source: AGHT+IFegU3FKH5QX8plRhx1QPzCJzeKyMq4iORYQqwxh8u3zQDOfW+uhhhfi9JftiMjmvSmooqvOskmY7BvtisQDEA=
X-Received: by 2002:a05:620a:720b:b0:7b6:ecbb:592 with SMTP id
 af79cd13be357-7b6fbf7cc86mr85739885a.54.1734054082027; Thu, 12 Dec 2024
 17:41:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com> <20241209-fuse-uring-for-6-10-rfc4-v8-9-d9f9f2642be3@ddn.com>
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-9-d9f9f2642be3@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 12 Dec 2024 17:41:11 -0800
Message-ID: <CAJnrk1b3vEiN2ASS=54KLEM=QXYiDgbFU4hRS8TgCW0CsejQVA@mail.gmail.com>
Subject: Re: [PATCH v8 09/16] fuse: {io-uring} Make hash-list req unique
 finding functions non-static
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 9, 2024 at 6:57=E2=80=AFAM Bernd Schubert <bschubert@ddn.com> w=
rote:
>
> fuse-over-io-uring uses existing functions to find requests based
> on their unique id - make these functions non-static.
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  fs/fuse/dev.c        | 6 +++---
>  fs/fuse/fuse_dev_i.h | 6 ++++++
>  fs/fuse/fuse_i.h     | 5 +++++
>  fs/fuse/inode.c      | 2 +-
>  4 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 2ba153054f7ba61a870c847cb87d81168220661f..a45d92431769d4aadaf5c5792=
086abc5dda3c048 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -220,7 +220,7 @@ u64 fuse_get_unique(struct fuse_iqueue *fiq)
>  }
>  EXPORT_SYMBOL_GPL(fuse_get_unique);
>
> -static unsigned int fuse_req_hash(u64 unique)
> +unsigned int fuse_req_hash(u64 unique)
>  {
>         return hash_long(unique & ~FUSE_INT_REQ_BIT, FUSE_PQ_HASH_BITS);
>  }
> @@ -1910,7 +1910,7 @@ static int fuse_notify(struct fuse_conn *fc, enum f=
use_notify_code code,
>  }
>
>  /* Look up request on processing list by unique ID */
> -static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique=
)
> +struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique)
>  {
>         unsigned int hash =3D fuse_req_hash(unique);
>         struct fuse_req *req;
> @@ -1994,7 +1994,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *f=
ud,
>         spin_lock(&fpq->lock);
>         req =3D NULL;
>         if (fpq->connected)
> -               req =3D request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
> +               req =3D fuse_request_find(fpq, oh.unique & ~FUSE_INT_REQ_=
BIT);
>
>         err =3D -ENOENT;
>         if (!req) {
> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> index 0708730b656b97071de9a5331ef4d51a112c602c..d7bf72dabd84c3896d1447380=
649e2f4d20b0643 100644
> --- a/fs/fuse/fuse_dev_i.h
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -7,6 +7,7 @@
>  #define _FS_FUSE_DEV_I_H
>
>  #include <linux/types.h>
> +#include <linux/fs.h>

Is this include needed?

>
>  /* Ordinary requests have even IDs, while interrupts IDs are odd */
>  #define FUSE_INT_REQ_BIT (1ULL << 0)
> @@ -14,6 +15,8 @@
>
>  struct fuse_arg;
>  struct fuse_args;
> +struct fuse_pqueue;
> +struct fuse_req;
>
>  struct fuse_copy_state {
>         int write;
> @@ -43,6 +46,9 @@ static inline struct fuse_dev *fuse_get_dev(struct file=
 *file)
>         return READ_ONCE(file->private_data);
>  }
>
> +unsigned int fuse_req_hash(u64 unique);
> +struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique);
> +
>  void fuse_dev_end_requests(struct list_head *head);
>
>  void fuse_copy_init(struct fuse_copy_state *cs, int write,
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index d75dd9b59a5c35b76919db760645464f604517f5..e545b0864dd51e82df61cc39b=
df65d3d36a418dc 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1237,6 +1237,11 @@ void fuse_change_entry_timeout(struct dentry *entr=
y, struct fuse_entry_out *o);
>   */
>  struct fuse_conn *fuse_conn_get(struct fuse_conn *fc);
>
> +/**
> + * Initialize the fuse processing queue
> + */
> +void fuse_pqueue_init(struct fuse_pqueue *fpq);
> +
>  /**
>   * Initialize fuse_conn
>   */
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index e4f9bbacfc1bc6f51d5d01b4c47b42cc159ed783..328797b9aac9a816a4ad2c69b=
6880dc6ef6222b0 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -938,7 +938,7 @@ static void fuse_iqueue_init(struct fuse_iqueue *fiq,
>         fiq->priv =3D priv;
>  }
>
> -static void fuse_pqueue_init(struct fuse_pqueue *fpq)
> +void fuse_pqueue_init(struct fuse_pqueue *fpq)
>  {
>         unsigned int i;
>
>
> --
> 2.43.0
>

