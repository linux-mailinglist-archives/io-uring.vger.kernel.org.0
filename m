Return-Path: <io-uring+bounces-6131-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FD72A1C618
	for <lists+io-uring@lfdr.de>; Sun, 26 Jan 2025 03:06:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E0823A589B
	for <lists+io-uring@lfdr.de>; Sun, 26 Jan 2025 02:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A9338389;
	Sun, 26 Jan 2025 02:06:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AFE288DA
	for <io-uring@vger.kernel.org>; Sun, 26 Jan 2025 02:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737857210; cv=none; b=Uo6iU4JXn+KxG53C7m9oxc/x3hv+3IA0flczbPkfE9R4y8WMobZE26okp2bCrnJvC70xyn0UpkHxqS1TOm0RErQmXLGjCN5NW8Slb4n8Nr4/UY1e5xYwgJSJ54yJyhCw6p+w2C2tTSzAjURuSMFjqtshzBBVmmhjH7e/vtwRqUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737857210; c=relaxed/simple;
	bh=iL2Zi78bgiw0L8URg8PaxJXEE0Gh5j3lxO9iE6LYP6o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nFkrPuu+dWzj3OH5Xvq2rzdctNtr6nET1eVOxHhsaFBjP8Sz/2CJUyYiOA71hTuKtKs9pQTdzRAqwN6FXFxwEAeLt2gvwvt106mX6qNPPzdDdZ857ylGsoCFHQe/FRS47vMPMA5MdFRi8bQW+liXSO8vSP+gurTZTu6S0KahyIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4YgZcZ6ydGzrSb4;
	Sun, 26 Jan 2025 10:04:46 +0800 (CST)
Received: from kwepemd100011.china.huawei.com (unknown [7.221.188.204])
	by mail.maildlp.com (Postfix) with ESMTPS id 2472F1402C1;
	Sun, 26 Jan 2025 10:06:25 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100011.china.huawei.com (7.221.188.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sun, 26 Jan 2025 10:06:24 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Sun, 26 Jan 2025 10:06:24 +0800
From: lizetao <lizetao1@huawei.com>
To: Sidong Yang <sidong.yang@furiosa.ai>
CC: io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: RE: [PATCH v4] io_uring/futex: Factor out common free logic into
 io_free_ifd()
Thread-Topic: [PATCH v4] io_uring/futex: Factor out common free logic into
 io_free_ifd()
Thread-Index: AQHbb4Dmp7p0zOOlF06ZUhNQNpzHPbMoTrMA
Date: Sun, 26 Jan 2025 02:06:24 +0000
Message-ID: <7160405e60db436599585a6be115e1db@huawei.com>
References: <20250125232828.10228-1-sidong.yang@furiosa.ai>
In-Reply-To: <20250125232828.10228-1-sidong.yang@furiosa.ai>
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



> -----Original Message-----
> From: Sidong Yang <sidong.yang@furiosa.ai>
> Sent: Sunday, January 26, 2025 7:28 AM
> To: io-uring <io-uring@vger.kernel.org>; Jens Axboe <axboe@kernel.dk>; li=
zetao
> <lizetao1@huawei.com>
> Cc: Sidong Yang <sidong.yang@furiosa.ai>
> Subject: [PATCH v4] io_uring/futex: Factor out common free logic into
> io_free_ifd()
>=20
> This patch introduces io_free_ifd() that try to cache or free io_futex_da=
ta. It
> could be used for completion. It also could be used for error path in
> io_futex_wait(). Old code just release the ifd but it could be cached.
>=20
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
> v2: use io_free_ifd() for completion
> v3: format, inline, remove reduntant init.
> v4: inline static -> static inline format
> ---
>  io_uring/futex.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/io_uring/futex.c b/io_uring/futex.c index
> e29662f039e1..6d724435cf23 100644
> --- a/io_uring/futex.c
> +++ b/io_uring/futex.c
> @@ -44,6 +44,12 @@ void io_futex_cache_free(struct io_ring_ctx *ctx)
>  	io_alloc_cache_free(&ctx->futex_cache, kfree);  }
>=20
> +static inline void io_free_ifd(struct io_ring_ctx *ctx, struct
> +io_futex_data *ifd) {
> +	if (!io_alloc_cache_put(&ctx->futex_cache, ifd))
> +		kfree(ifd);
> +}
> +
>  static void __io_futex_complete(struct io_kiocb *req, struct io_tw_state=
 *ts)
> {
>  	req->async_data =3D NULL;
> @@ -57,8 +63,7 @@ static void io_futex_complete(struct io_kiocb *req, str=
uct
> io_tw_state *ts)
>  	struct io_ring_ctx *ctx =3D req->ctx;
>=20
>  	io_tw_lock(ctx, ts);
> -	if (!io_alloc_cache_put(&ctx->futex_cache, ifd))
> -		kfree(ifd);
> +	io_free_ifd(ctx, ifd);
>  	__io_futex_complete(req, ts);
>  }
>=20
> @@ -321,7 +326,7 @@ int io_futex_wait(struct io_kiocb *req, unsigned int
> issue_flags)  {
>  	struct io_futex *iof =3D io_kiocb_to_cmd(req, struct io_futex);
>  	struct io_ring_ctx *ctx =3D req->ctx;
> -	struct io_futex_data *ifd =3D NULL;
> +	struct io_futex_data *ifd;
>  	struct futex_hash_bucket *hb;
>  	int ret;
>=20
> @@ -353,13 +358,13 @@ int io_futex_wait(struct io_kiocb *req, unsigned in=
t
> issue_flags)
>  		return IOU_ISSUE_SKIP_COMPLETE;
>  	}
>=20
> +	io_free_ifd(ctx, ifd);
>  done_unlock:
>  	io_ring_submit_unlock(ctx, issue_flags);
>  done:
>  	if (ret < 0)
>  		req_set_fail(req);
>  	io_req_set_res(req, ret, 0);
> -	kfree(ifd);
>  	return IOU_OK;
>  }
>=20
> --
> 2.43.0

Reviewed-by: Li Zetao <lizetao1@huawei.com>

--
Li Zetao

