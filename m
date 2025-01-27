Return-Path: <io-uring+bounces-6133-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76518A1CF97
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 03:56:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F38D11887779
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 02:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5962179BF;
	Mon, 27 Jan 2025 02:56:02 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851FF126BEE;
	Mon, 27 Jan 2025 02:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737946562; cv=none; b=KkNzV83WIRcu4iQ0D186NL7OgYSvE9zs/gDeDv/P6dWwGyZvY9VWj8oN91eQslZkOnA0fyEA4+DZvgJocV5nO3PuNzBu4DEJup+jn3eIGcVICbHcJx9QYmtqoTBsmB4/k+2+1fLU3Et197mztyL5fB6KRLigb3fDHpAYBrrtR6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737946562; c=relaxed/simple;
	bh=RF47p+2oBYjmf339fDtUDEtK0jI6cTVSyOlT4oUTV1g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UbndFTibqwT2NY+8gaEoZUl6R0j5cz5zemGApa+AIhg93hU9vqHUCJuTfr4EMCKfDiWhWgyH7CSz85mW7rdBrQqsZhkIqBCwUrFMZYiAyU4B7Q4A30s3DX3sgcGcY1jcm9/oFa46uJd/UF19k/nt+Wq0668FcBByIWiB7skB5J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4YhCdC4Kdtz2Fc75;
	Mon, 27 Jan 2025 10:52:31 +0800 (CST)
Received: from kwepemd100012.china.huawei.com (unknown [7.221.188.214])
	by mail.maildlp.com (Postfix) with ESMTPS id BB7CC180042;
	Mon, 27 Jan 2025 10:55:56 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100012.china.huawei.com (7.221.188.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 27 Jan 2025 10:55:56 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Mon, 27 Jan 2025 10:55:56 +0800
From: lizetao <lizetao1@huawei.com>
To: David Wei <dw@davidwei.uk>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, "Mina
 Almasry" <almasrymina@google.com>, Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>, Pedro Tammela <pctammela@mojatatu.com>
Subject: RE: [PATCH net-next v11 12/21] io_uring/zcrx: add io_zcrx_area
Thread-Topic: [PATCH net-next v11 12/21] io_uring/zcrx: add io_zcrx_area
Thread-Index: AQHbaG0Gu2QjYqoQfUWmPmDzLSgt+LMp/MDw
Date: Mon, 27 Jan 2025 02:55:56 +0000
Message-ID: <14d20c4b8e304ee09f8cb76f5981a526@huawei.com>
References: <20250116231704.2402455-1-dw@davidwei.uk>
 <20250116231704.2402455-13-dw@davidwei.uk>
In-Reply-To: <20250116231704.2402455-13-dw@davidwei.uk>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi,

> -----Original Message-----
> From: David Wei <dw@davidwei.uk>
> Sent: Friday, January 17, 2025 7:17 AM
> To: io-uring@vger.kernel.org; netdev@vger.kernel.org
> Cc: Jens Axboe <axboe@kernel.dk>; Pavel Begunkov <asml.silence@gmail.com>=
;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David =
S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> Jesper Dangaard Brouer <hawk@kernel.org>; David Ahern
> <dsahern@kernel.org>; Mina Almasry <almasrymina@google.com>; Stanislav
> Fomichev <stfomichev@gmail.com>; Joe Damato <jdamato@fastly.com>;
> Pedro Tammela <pctammela@mojatatu.com>
> Subject: [PATCH net-next v11 12/21] io_uring/zcrx: add io_zcrx_area
>=20
> Add io_zcrx_area that represents a region of userspace memory that is use=
d for
> zero copy. During ifq registration, userspace passes in the uaddr and len=
 of
> userspace memory, which is then pinned by the kernel.
> Each net_iov is mapped to one of these pages.
>=20
> The freelist is a spinlock protected list that keeps track of all the net=
_iovs/pages
> that aren't used.
>=20
> For now, there is only one area per ifq and area registration happens imp=
licitly
> as part of ifq registration. There is no API for adding/removing areas ye=
t. The
> struct for area registration is there for future extensibility once we su=
pport
> multiple areas and TCP devmem.
>=20
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  include/uapi/linux/io_uring.h |  9 ++++
>  io_uring/rsrc.c               |  2 +-
>  io_uring/rsrc.h               |  1 +
>  io_uring/zcrx.c               | 89
> ++++++++++++++++++++++++++++++++++-
>  io_uring/zcrx.h               | 16 +++++++
>  5 files changed, 114 insertions(+), 3 deletions(-)
>=20
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h index
> 3af8b7a19824..e251f28507ce 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -980,6 +980,15 @@ struct io_uring_zcrx_offsets {
>  	__u64	__resv[2];
>  };
>=20
> +struct io_uring_zcrx_area_reg {
> +	__u64	addr;
> +	__u64	len;
> +	__u64	rq_area_token;
> +	__u32	flags;
> +	__u32	__resv1;
> +	__u64	__resv2[2];
> +};
> +
>  /*
>   * Argument for IORING_REGISTER_ZCRX_IFQ
>   */
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c index f2ff108485c8..d0f11b=
5aec0d
> 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -77,7 +77,7 @@ static int io_account_mem(struct io_ring_ctx *ctx,
> unsigned long nr_pages)
>  	return 0;
>  }
>=20
> -static int io_buffer_validate(struct iovec *iov)
> +int io_buffer_validate(struct iovec *iov)
>  {
>  	unsigned long tmp, acct_len =3D iov->iov_len + (PAGE_SIZE - 1);
>=20
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h index c8b093584461..0ae54d=
deb1fd
> 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -66,6 +66,7 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, vo=
id
> __user *arg,
>  			    unsigned size, unsigned type);
>  int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
>  			unsigned int size, unsigned int type);
> +int io_buffer_validate(struct iovec *iov);
>=20
>  bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
>  			      struct io_imu_folio_data *data); diff --git
> a/io_uring/zcrx.c b/io_uring/zcrx.c index f3ace7e8264d..04883a3ae80c 1006=
44
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -10,6 +10,7 @@
>  #include "kbuf.h"
>  #include "memmap.h"
>  #include "zcrx.h"
> +#include "rsrc.h"
>=20
>  #define IO_RQ_MAX_ENTRIES		32768
>=20
> @@ -44,6 +45,79 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
>  	ifq->rqes =3D NULL;
>  }
>=20
> +static void io_zcrx_free_area(struct io_zcrx_area *area) {
> +	kvfree(area->freelist);
> +	kvfree(area->nia.niovs);
> +	if (area->pages) {
> +		unpin_user_pages(area->pages, area->nia.num_niovs);
> +		kvfree(area->pages);
> +	}
> +	kfree(area);
> +}
> +
> +static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
> +			       struct io_zcrx_area **res,
> +			       struct io_uring_zcrx_area_reg *area_reg) {
> +	struct io_zcrx_area *area;
> +	int i, ret, nr_pages;
> +	struct iovec iov;
> +
> +	if (area_reg->flags || area_reg->rq_area_token)
> +		return -EINVAL;
> +	if (area_reg->__resv1 || area_reg->__resv2[0] || area_reg->__resv2[1])
> +		return -EINVAL;
> +	if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
> +		return -EINVAL;
> +
> +	iov.iov_base =3D u64_to_user_ptr(area_reg->addr);
> +	iov.iov_len =3D area_reg->len;
> +	ret =3D io_buffer_validate(&iov);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D -ENOMEM;
> +	area =3D kzalloc(sizeof(*area), GFP_KERNEL);
> +	if (!area)
> +		goto err;
> +
> +	area->pages =3D io_pin_pages((unsigned long)area_reg->addr, area_reg->l=
en,
> +				   &nr_pages);
> +	if (IS_ERR(area->pages)) {
> +		ret =3D PTR_ERR(area->pages);
> +		area->pages =3D NULL;
> +		goto err;
> +	}
> +	area->nia.num_niovs =3D nr_pages;
> +
> +	area->nia.niovs =3D kvmalloc_array(nr_pages, sizeof(area->nia.niovs[0])=
,
> +					 GFP_KERNEL | __GFP_ZERO);
> +	if (!area->nia.niovs)
> +		goto err;
> +
> +	area->freelist =3D kvmalloc_array(nr_pages, sizeof(area->freelist[0]),
> +					GFP_KERNEL | __GFP_ZERO);
> +	if (!area->freelist)
> +		goto err;
> +
> +	for (i =3D 0; i < nr_pages; i++)
> +		area->freelist[i] =3D i;

This is redundant as patch 14 will reinitialize it.
> +
> +	area->free_count =3D nr_pages;
> +	area->ifq =3D ifq;
> +	/* we're only supporting one area per ifq for now */
> +	area->area_id =3D 0;
> +	area_reg->rq_area_token =3D (u64)area->area_id <<
> IORING_ZCRX_AREA_SHIFT;
> +	spin_lock_init(&area->freelist_lock);
> +	*res =3D area;
> +	return 0;
> +err:
> +	if (area)
> +		io_zcrx_free_area(area);
> +	return ret;
> +}
> +
>  static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)  {
>  	struct io_zcrx_ifq *ifq;
> @@ -59,6 +133,9 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct
> io_ring_ctx *ctx)
>=20
>  static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)  {
> +	if (ifq->area)
> +		io_zcrx_free_area(ifq->area);
> +
>  	io_free_rbuf_ring(ifq);
>  	kfree(ifq);
>  }
> @@ -66,6 +143,7 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq) =
 int
> io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>  			  struct io_uring_zcrx_ifq_reg __user *arg)  {
> +	struct io_uring_zcrx_area_reg area;
>  	struct io_uring_zcrx_ifq_reg reg;
>  	struct io_uring_region_desc rd;
>  	struct io_zcrx_ifq *ifq;
> @@ -99,7 +177,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>  	}
>  	reg.rq_entries =3D roundup_pow_of_two(reg.rq_entries);
>=20
> -	if (!reg.area_ptr)
> +	if (copy_from_user(&area, u64_to_user_ptr(reg.area_ptr),
> +sizeof(area)))
>  		return -EFAULT;
>=20
>  	ifq =3D io_zcrx_ifq_alloc(ctx);
> @@ -110,6 +188,10 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>  	if (ret)
>  		goto err;
>=20
> +	ret =3D io_zcrx_create_area(ifq, &ifq->area, &area);
> +	if (ret)
> +		goto err;
> +
>  	ifq->rq_entries =3D reg.rq_entries;
>  	ifq->if_rxq =3D reg.if_rxq;
>=20
> @@ -122,7 +204,10 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>  		ret =3D -EFAULT;
>  		goto err;
>  	}
> -
> +	if (copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
> +		ret =3D -EFAULT;
> +		goto err;
> +	}
>  	ctx->ifq =3D ifq;
>  	return 0;
>  err:
> diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h index
> 58e4ab6c6083..53fd94b65b38 100644
> --- a/io_uring/zcrx.h
> +++ b/io_uring/zcrx.h
> @@ -3,9 +3,25 @@
>  #define IOU_ZC_RX_H
>=20
>  #include <linux/io_uring_types.h>
> +#include <net/page_pool/types.h>
> +
> +struct io_zcrx_area {
> +	struct net_iov_area	nia;
> +	struct io_zcrx_ifq	*ifq;
> +
> +	u16			area_id;
> +	struct page		**pages;
> +
> +	/* freelist */
> +	spinlock_t		freelist_lock ____cacheline_aligned_in_smp;
> +	u32			free_count;
> +	u32			*freelist;
> +};
>=20
>  struct io_zcrx_ifq {
>  	struct io_ring_ctx		*ctx;
> +	struct io_zcrx_area		*area;
> +
>  	struct io_uring			*rq_ring;
>  	struct io_uring_zcrx_rqe	*rqes;
>  	u32				rq_entries;
> --
> 2.43.5
>=20
>=20

--
Li Zetao

