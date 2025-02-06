Return-Path: <io-uring+bounces-6285-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46108A2A8DD
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2025 13:56:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4978A1888FD6
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2025 12:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73EC2225783;
	Thu,  6 Feb 2025 12:56:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A4213D897
	for <io-uring@vger.kernel.org>; Thu,  6 Feb 2025 12:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738846586; cv=none; b=GjKYY8ZKsDCbB6IdcZINHC8yYWmPAomlJY6uZEYaD61g/xXGpng6P2jpdy628LM+ZVXz+FCsH2YJ73qpHo3s4Ll4YT1rLFSPu1bxXYhfUBntSUQbX4LK0vs0TwMYYC5jzvhGynsLhKsfx9MN3Ivhf6CD9X0UrUP9YlDV9SPvno4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738846586; c=relaxed/simple;
	bh=1hZnDiqcMl1MlsJOznQ0uiBC+MsPdV6yAQo55U8iio4=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HadTVGogXYxpxK6QFOxqQah2WhLKMd/i8d6ecIojC7rJ+67vWTDKCdGzzFAeS0roSoG1E+4naKTeDUFh0SNI6E3Mv/3BWBmCz9zsjoUME0Ye7O0dZ90snHHXKnyGlsFSPmJgmNKZuqzDtH5xNneQ14ovr1LR5bCV6OQ03gp42vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YpcTK6st5zbnny;
	Thu,  6 Feb 2025 20:52:53 +0800 (CST)
Received: from kwepemd500010.china.huawei.com (unknown [7.221.188.84])
	by mail.maildlp.com (Postfix) with ESMTPS id 2E38A1400CA;
	Thu,  6 Feb 2025 20:56:20 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd500010.china.huawei.com (7.221.188.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 6 Feb 2025 20:56:19 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Thu, 6 Feb 2025 20:56:19 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
Subject: RE: [PATCH 5/6] io_uring/futex: use generic io_cancel_remove() helper
Thread-Topic: [PATCH 5/6] io_uring/futex: use generic io_cancel_remove()
 helper
Thread-Index: AQHbeAxQdxWVUP+MI0inD4WR9gsgF7M6PB6A
Date: Thu, 6 Feb 2025 12:56:19 +0000
Message-ID: <c619c868b7b442cc9a2c669522242d96@huawei.com>
References: <20250205202641.646812-1-axboe@kernel.dk>
 <20250205202641.646812-6-axboe@kernel.dk>
In-Reply-To: <20250205202641.646812-6-axboe@kernel.dk>
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
> From: Jens Axboe <axboe@kernel.dk>
> Sent: Thursday, February 6, 2025 4:26 AM
> To: io-uring@vger.kernel.org
> Cc: Jens Axboe <axboe@kernel.dk>
> Subject: [PATCH 5/6] io_uring/futex: use generic io_cancel_remove() helpe=
r
>=20
> Don't implement our own loop rolling and checking, just use the generic h=
elper to
> find and cancel requests.
>=20
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/futex.c | 24 +-----------------------
>  1 file changed, 1 insertion(+), 23 deletions(-)
>=20
> diff --git a/io_uring/futex.c b/io_uring/futex.c index
> 808eb57f1210..54b9760f2aa6 100644
> --- a/io_uring/futex.c
> +++ b/io_uring/futex.c
> @@ -116,29 +116,7 @@ static bool __io_futex_cancel(struct io_kiocb *req) =
 int
> io_futex_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
>  		    unsigned int issue_flags)
>  {
> -	struct hlist_node *tmp;
> -	struct io_kiocb *req;
> -	int nr =3D 0;
> -
> -	if (cd->flags &
> (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_FD_FIXED))
> -		return -ENOENT;

Why remove this check?
> -
> -	io_ring_submit_lock(ctx, issue_flags);
> -	hlist_for_each_entry_safe(req, tmp, &ctx->futex_list, hash_node) {
> -		if (req->cqe.user_data !=3D cd->data &&
> -		    !(cd->flags & IORING_ASYNC_CANCEL_ANY))
> -			continue;
> -		if (__io_futex_cancel(req))
> -			nr++;
> -		if (!(cd->flags & IORING_ASYNC_CANCEL_ALL))
> -			break;
> -	}
> -	io_ring_submit_unlock(ctx, issue_flags);
> -
> -	if (nr)
> -		return nr;
> -
> -	return -ENOENT;
> +	return io_cancel_remove(ctx, cd, issue_flags, &ctx->futex_list,
> +__io_futex_cancel);
>  }
>=20
>  bool io_futex_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *=
tctx,
> --
> 2.47.2
>=20
>=20

---
Li Zetao

