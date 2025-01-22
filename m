Return-Path: <io-uring+bounces-6044-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2C01A195E3
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 16:57:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58B331889C64
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 15:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98F0F214205;
	Wed, 22 Jan 2025 15:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="mEVM/tt3"
X-Original-To: io-uring@vger.kernel.org
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE3721480D;
	Wed, 22 Jan 2025 15:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.60.130.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737561421; cv=none; b=Kxi2AJ+TdIiqxpd+N3EIt/SqOpbYyYqR7Vg254EtkYpmezHxBEgoQ1MyzKPGW0754lIj8cGYvC4kHoWfBUY0FNPWLpWzDsKwD9MWVLp4WfzvwnJPUkmBlVDjzTPw85z8QFekZaqqo5LXF9XVpgv0GBeOvp5sTQNXX8jl2Klhvko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737561421; c=relaxed/simple;
	bh=MXv9ahTmKk93xJzU7awTsnkH/tFOADbQhIoc13hl9Po=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Fgss94r+LbxBin6zYU06oEpyDr++6pByLbTIXvS5Q0TeBY9m0xTLdLAVXiKjgqqO5C3exdiLf7xzWKpoPNIjieCmlh/yba6Vk5S/VTCa+KqKt2gr+cOGUHu4PuS8K9JgjSHzeGIxM1Mtqwe7jqqEYglIWtUgvyLTHs8U9FgKrjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=mEVM/tt3; arc=none smtp.client-ip=178.60.130.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8gQanH/Q23YQh/d3KPokZC/J8OHvMeJyPK+9LlBgM78=; b=mEVM/tt34OsEw0dy2ybHf3pKkd
	s62wkKVGebgHKVZUHR6ZTxbYJXfrqDFXiDiMKGFdT+OdWJhimPhD6Fz+nO2DH6GEqzw1KloU14vfc
	rUjya4JHKsjbE3h6Bm3E4S9Hy3ieBoMyAMAaZBBiZxp6uQurXypRMj5KJU7/tA37RC0wnFaUvrLx8
	fJzsCYyxjbrr9fD7nRKOg0KoweO1EgfLkYscg5fSY1g59jz6+XztuaZ/80CszREyye8uwembcXQ5D
	WzexNtjzuIAX9ZGWPpB1ImJwsUYlbExNJdec8F92H21XEPI0uMTiXngiRdITCG9RQqhl7/QXngl1L
	vo+fW2oQ==;
Received: from bl23-10-177.dsl.telepac.pt ([144.64.10.177] helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1tad66-000nf0-PB; Wed, 22 Jan 2025 16:56:54 +0100
From: Luis Henriques <luis@igalia.com>
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,  Jens Axboe <axboe@kernel.dk>,
  Pavel Begunkov <asml.silence@gmail.com>,  linux-fsdevel@vger.kernel.org,
  io-uring@vger.kernel.org,  Joanne Koong <joannelkoong@gmail.com>,  Josef
 Bacik <josef@toxicpanda.com>,  Amir Goldstein <amir73il@gmail.com>,  Ming
 Lei <tom.leiming@gmail.com>,  David Wei <dw@davidwei.uk>,
  bernd@bsbernd.com
Subject: Re: [PATCH v10 09/17] fuse: {io-uring} Make hash-list req unique
 finding functions non-static
In-Reply-To: <20250120-fuse-uring-for-6-10-rfc4-v10-9-ca7c5d1007c0@ddn.com>
	(Bernd Schubert's message of "Mon, 20 Jan 2025 02:29:02 +0100")
References: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
	<20250120-fuse-uring-for-6-10-rfc4-v10-9-ca7c5d1007c0@ddn.com>
Date: Wed, 22 Jan 2025 15:56:10 +0000
Message-ID: <87y0z2etb9.fsf@igalia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20 2025, Bernd Schubert wrote:

> fuse-over-io-uring uses existing functions to find requests based
> on their unique id - make these functions non-static.
>

Single comment below.

> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/dev.c        | 6 +++---
>  fs/fuse/fuse_dev_i.h | 6 ++++++
>  fs/fuse/fuse_i.h     | 5 +++++
>  fs/fuse/inode.c      | 2 +-
>  4 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 8b03a540e151daa1f62986aa79030e9e7a456059..aa33eba51c51dff6af2cdcf60=
bed9c3f6b4bc0d0 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -220,7 +220,7 @@ u64 fuse_get_unique(struct fuse_iqueue *fiq)
>  }
>  EXPORT_SYMBOL_GPL(fuse_get_unique);
>=20=20
> -static unsigned int fuse_req_hash(u64 unique)
> +unsigned int fuse_req_hash(u64 unique)
>  {
>  	return hash_long(unique & ~FUSE_INT_REQ_BIT, FUSE_PQ_HASH_BITS);
>  }
> @@ -1910,7 +1910,7 @@ static int fuse_notify(struct fuse_conn *fc, enum f=
use_notify_code code,
>  }
>=20=20
>  /* Look up request on processing list by unique ID */
> -static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
> +struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique)
>  {
>  	unsigned int hash =3D fuse_req_hash(unique);
>  	struct fuse_req *req;
> @@ -1994,7 +1994,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *f=
ud,
>  	spin_lock(&fpq->lock);
>  	req =3D NULL;
>  	if (fpq->connected)
> -		req =3D request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
> +		req =3D fuse_request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
>=20=20
>  	err =3D -ENOENT;
>  	if (!req) {
> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> index 4a8a4feb2df53fb84938a6711e6bcfd0f1b9f615..599a61536f8c85b3631b85842=
47a917bda92e719 100644
> --- a/fs/fuse/fuse_dev_i.h
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -7,6 +7,7 @@
>  #define _FS_FUSE_DEV_I_H
>=20=20
>  #include <linux/types.h>
> +#include <linux/fs.h>

Looking at these changes, it seems like this extra include isn't really
necessary.  Is it a leftover from older revs?

Cheers,
--=20
Lu=C3=ADs

>=20=20
>  /* Ordinary requests have even IDs, while interrupts IDs are odd */
>  #define FUSE_INT_REQ_BIT (1ULL << 0)
> @@ -14,6 +15,8 @@
>=20=20
>  struct fuse_arg;
>  struct fuse_args;
> +struct fuse_pqueue;
> +struct fuse_req;
>=20=20
>  struct fuse_copy_state {
>  	int write;
> @@ -42,6 +45,9 @@ static inline struct fuse_dev *fuse_get_dev(struct file=
 *file)
>  	return READ_ONCE(file->private_data);
>  }
>=20=20
> +unsigned int fuse_req_hash(u64 unique);
> +struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique);
> +
>  void fuse_dev_end_requests(struct list_head *head);
>=20=20
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
>=20=20
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
>  	fiq->priv =3D priv;
>  }
>=20=20
> -static void fuse_pqueue_init(struct fuse_pqueue *fpq)
> +void fuse_pqueue_init(struct fuse_pqueue *fpq)
>  {
>  	unsigned int i;
>=20=20
>
> --=20
> 2.43.0
>


