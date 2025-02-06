Return-Path: <io-uring+bounces-6284-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E68A2A8BB
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2025 13:46:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96A581888B28
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2025 12:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF6222E3F3;
	Thu,  6 Feb 2025 12:46:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A52020B208
	for <io-uring@vger.kernel.org>; Thu,  6 Feb 2025 12:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738845970; cv=none; b=Ul1wIB6dalb/wGMWcxFZdH0mOlekS7pweLGvEDNTftXRcCYv4Kmdy5JOVuoRKdQa/BU7MvBeWrCvvr6MqLhMAhOmKg45nVLFvGfnZ+9ULz0+1xldFKKzcNSiw0b1e6E6zapw2z0a+880hkHEsl8/yhczHBtTYsKNjSASlMQVFeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738845970; c=relaxed/simple;
	bh=Fs6eAM/R3OfhlffF0ZzeuD5us/IfI42HVd7croUh6Ps=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qy8HEncJWy7xDcdLyEpS094Mbi4TwkSsuSfYWvmlS+CR808leDUXaoKga8ii0Ln8BcebnVfz+S9vxzePJEja35Z9Du/PZXIjMwNPmNrLPAkYeFLuHs2vZ04X0GPKocqM74iF1jqTG32eGEyJZ/UQ/BzZDb0gY8v83m/hVX8VckU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YpcDQ49PMz11PfK;
	Thu,  6 Feb 2025 20:41:42 +0800 (CST)
Received: from kwepemd200012.china.huawei.com (unknown [7.221.188.145])
	by mail.maildlp.com (Postfix) with ESMTPS id 39DAF1800E5;
	Thu,  6 Feb 2025 20:46:02 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200012.china.huawei.com (7.221.188.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 6 Feb 2025 20:46:01 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Thu, 6 Feb 2025 20:46:01 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: RE: [PATCH 1/6] io_uring/cancel: add generic remove_all helper
Thread-Topic: [PATCH 1/6] io_uring/cancel: add generic remove_all helper
Thread-Index: AQHbeAxPICYWZSDkkUOm+Zk3Pk5irLM6ObGA
Date: Thu, 6 Feb 2025 12:46:01 +0000
Message-ID: <689a799d20e048f8a42ab2e927493279@huawei.com>
References: <20250205202641.646812-1-axboe@kernel.dk>
 <20250205202641.646812-2-axboe@kernel.dk>
In-Reply-To: <20250205202641.646812-2-axboe@kernel.dk>
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
> From: Jens Axboe <axboe@kernel.dk>
> Sent: Thursday, February 6, 2025 4:26 AM
> To: io-uring@vger.kernel.org
> Cc: Jens Axboe <axboe@kernel.dk>
> Subject: [PATCH 1/6] io_uring/cancel: add generic remove_all helper
>=20
> Any opcode that is cancelable ends up defining its own remove all helper,=
 which
> iterates the pending list and cancels matches. Add a generic helper for i=
t, which
> can be used by them.
>=20
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/cancel.c | 20 ++++++++++++++++++++  io_uring/cancel.h |  4 ++++
>  2 files changed, 24 insertions(+)
>=20
> diff --git a/io_uring/cancel.c b/io_uring/cancel.c index
> 484193567839..0565dc0d7611 100644
> --- a/io_uring/cancel.c
> +++ b/io_uring/cancel.c
> @@ -341,3 +341,23 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __u=
ser
> *arg)
>  		fput(file);
>  	return ret;
>  }
> +
> +bool io_cancel_remove_all(struct io_ring_ctx *ctx, struct io_uring_task =
*tctx,
> +			  struct hlist_head *list, bool cancel_all,
> +			  bool (*cancel)(struct io_kiocb *)) {
> +	struct hlist_node *tmp;
> +	struct io_kiocb *req;
> +	bool found =3D false;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +
> +	hlist_for_each_entry_safe(req, tmp, list, hash_node) {
> +		if (!io_match_task_safe(req, tctx, cancel_all))
> +			continue;

Should call hlist_del_init(&req->hash_node) here, just like the original co=
de logic.
> +		if (cancel(req))
> +			found =3D true;
> +	}
> +
> +	return found;
> +}
> diff --git a/io_uring/cancel.h b/io_uring/cancel.h index
> bbfea2cd00ea..80734a0a2b26 100644
> --- a/io_uring/cancel.h
> +++ b/io_uring/cancel.h
> @@ -24,6 +24,10 @@ int io_try_cancel(struct io_uring_task *tctx, struct
> io_cancel_data *cd,  int io_sync_cancel(struct io_ring_ctx *ctx, void __u=
ser
> *arg);  bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_d=
ata
> *cd);
>=20
> +bool io_cancel_remove_all(struct io_ring_ctx *ctx, struct io_uring_task =
*tctx,
> +			  struct hlist_head *list, bool cancel_all,
> +			  bool (*cancel)(struct io_kiocb *));
> +
>  static inline bool io_cancel_match_sequence(struct io_kiocb *req, int se=
quence)
> {
>  	if (req->cancel_seq_set && sequence =3D=3D req->work.cancel_seq)
> --
> 2.47.2
>=20

---
Li Zetao

