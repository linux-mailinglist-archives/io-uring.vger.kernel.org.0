Return-Path: <io-uring+bounces-7086-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 133CAA63477
	for <lists+io-uring@lfdr.de>; Sun, 16 Mar 2025 08:23:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18D4C3AD596
	for <lists+io-uring@lfdr.de>; Sun, 16 Mar 2025 07:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D090617D346;
	Sun, 16 Mar 2025 07:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kEj1W/aH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7078BE5;
	Sun, 16 Mar 2025 07:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742109821; cv=none; b=Dht3oYx7nm7ImlOvfTylXcOEhcuRHkx4GuXmXilA+j1CE2O/lZ967htQFfhwf7ExN5u0A1OPIMPCB5Fl6+GHofuu7FWV7lc1YajVgEy0RV1v67iDJm+5qV02E7jNMtZsHq1nPwhJzooqrfD8GNKjAGGMYXmqwIoy9L2VKiGQ5pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742109821; c=relaxed/simple;
	bh=xN8botBMfGTx/F++f9gyRzsgVOqUZUSj4+BXj0x0jTo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d6hTxvms2UGjTQdnB0f/KbW91FUmqOAfFK4FalcxPcMoY0cXxoVf2gG/S9oUk2A2hdUL975PlQeuZL+WRI8E5Ox5QMWEK+YxvmJTc9g46ZvK6QLemngmpT+s5SpS5Vlx3Gmn+05NOGVwFzQyxEc88fW4ZCyAYZs7qN0sm+YM1n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kEj1W/aH; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3995ff6b066so124389f8f.3;
        Sun, 16 Mar 2025 00:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742109818; x=1742714618; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DPbuGqO896ds5DajaIouTs5eEWK0Q/acGLUcwPZfOp4=;
        b=kEj1W/aHhnlqHfcM1Lrj1G3qA1AooMTW4OGjuTrlhvHgViuZAhVECyurRmtTCN0+eQ
         U/EFwClhx4PEuNDxySsLBkP2OUoyAEOMsrwxNQrGniMCGdWjISThKJ5RCDMnNK6SzkZm
         t4v0EGwudnzKmTa0yxhFFxTeBXHagJfoQhN40fRkdQX3qgmLGvYKtd3cXmlQL8BMOfwg
         Gidmte5plN1QhP8gF9KfSk9DQ1BbA6CrdHPacw1itlmjGFtczuqfazFKwwiJZ8tz9uEx
         EwZSkkkiZolvPvY10gbAsyBjB5u+HciAV0EhfzvmJ36ix1PPO8cVFoTGHuteBE0wRaGD
         GJug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742109818; x=1742714618;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DPbuGqO896ds5DajaIouTs5eEWK0Q/acGLUcwPZfOp4=;
        b=xMnheIQNxw0wr849pisvra2WowJ7A3JqXqM4Mz7cK+hZHzlhFcmbdOkFXBo11Zb7si
         q/5vQSxyv04o7i8TWbmk6I715o2dUpkSAD9GPt4OtSqFU3lx+8TbopUyROVdlcxB1LGc
         zF5seCuXxJeu9/jRgN2XE/KYAYw5OkNJc5HKRYkznJAISQJORDxLk/ezOFshIZGQxBSj
         6K9JCfxd21X2O3f9uyke4nQZ8e45eQHoCSkhcSN00moq+PlPKlflhN6kymRRqDH3v13W
         UW5J63Z21/jnYIXOTQOdtz6ziXNmeNp78q38PgEeqqPBZg2p5Ja7qndP6pGNfj6p5wdc
         LghA==
X-Forwarded-Encrypted: i=1; AJvYcCUy+GHepUqwSUArsTf9c3Tk8ziRcC6hIRcutIbZkliNAwxuEepPyzvrfj8MOqdAM6BAkB2uh7mGNg==@vger.kernel.org, AJvYcCXt8rq7adVF6moTY/p1y4rSjTgTGkCy70NefWnLcXlAL+tC9sW8bvkFuodNr71423oO0R4Uix6bXyZb/jS8@vger.kernel.org
X-Gm-Message-State: AOJu0YxglKTt/xrpJDQML8ZekGtWEcUd+/lueXqNpXciZuMGAmp/oKJB
	Y37JGYTtXJnvrgvDkQItU3NMNnohDrjBTfYg8Qw2OuloT9EeiyBa
X-Gm-Gg: ASbGncsFCWbePiBGND8Swioyhr60TD6sqkxY4MO9CnkyzxFDA939jXXZl0IzR4IojHV
	O0niBP5SIhQMR1CdQTpDOxc3V+CqUv4vieph5yBmBKJ/A0QVPvhoP85lQkEZUT5UKl1fa0SUUlB
	NdXBb0ap6UdZpdLQUHcZF4U4BsQHwd7Drv7GtAnFySsID4QubHKJ+fqPr92IkuIfdOcWOtaZQeH
	AVe6BSpOeEXhNpJf1Hf6z0cuVTTzk+EKm4yLy6ST0ZwqRwz+9kvX25iFm46HjSWVuavhhpYACZ7
	mYnC6eW7ZwM72YJLTlzkGOa6ZL88pdPF+23lGIajIvEtYpkT1a9535sS03Ttop0rkRQw0L7aTg=
	=
X-Google-Smtp-Source: AGHT+IG7tJeCk+QMqGMTtsrxfjNffUIaqEmvA5ZvxsnFM9/8BDnyVaj4Acbq7b9OPCAXTXcbgx/XSw==
X-Received: by 2002:a05:6000:144f:b0:391:31f2:b99e with SMTP id ffacd0b85a97d-3971ddd8fb5mr10824356f8f.2.1742109818096;
        Sun, 16 Mar 2025 00:23:38 -0700 (PDT)
Received: from [172.17.3.89] (philhot.static.otenet.gr. [79.129.48.248])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c8975d65sm11430504f8f.56.2025.03.16.00.23.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Mar 2025 00:23:37 -0700 (PDT)
Message-ID: <da0445a9-1fb4-4b75-b939-b38ce976205f@gmail.com>
Date: Sun, 16 Mar 2025 07:24:32 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 1/3] io-uring/cmd: add iou_vec field for
 io_uring_cmd
To: Sidong Yang <sidong.yang@furiosa.ai>, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250315172319.16770-1-sidong.yang@furiosa.ai>
 <20250315172319.16770-2-sidong.yang@furiosa.ai>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250315172319.16770-2-sidong.yang@furiosa.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/25 17:23, Sidong Yang wrote:
> This patch adds iou_vec field for io_uring_cmd. Also it needs to be
> cleanup for cache. It could be used in uring cmd api that imports
> multiple fixed buffers.

Sidong, I think you accidentially erased my authorship over the
patch. The only difference I see is that you rebased it and dropped
prep patches by placing iou_vec into struct io_uring_cmd_data. And
the prep patch was mandatory, once something is exported there is
a good chance it gets [ab]used, and iou_vec is not ready for it.


> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
>   include/linux/io_uring/cmd.h |  1 +
>   io_uring/io_uring.c          |  2 +-
>   io_uring/opdef.c             |  1 +
>   io_uring/uring_cmd.c         | 20 ++++++++++++++++++++
>   io_uring/uring_cmd.h         |  3 +++
>   5 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 598cacda4aa3..74b9f0aec229 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -22,6 +22,7 @@ struct io_uring_cmd {
>   struct io_uring_cmd_data {
>   	void			*op_data;
>   	struct io_uring_sqe	sqes[2];
> +	struct iou_vec		iou_vec;
>   };
>   
>   static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 5ff30a7092ed..55334fa53abf 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -289,7 +289,7 @@ static void io_free_alloc_caches(struct io_ring_ctx *ctx)
>   	io_alloc_cache_free(&ctx->apoll_cache, kfree);
>   	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
>   	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
> -	io_alloc_cache_free(&ctx->uring_cache, kfree);
> +	io_alloc_cache_free(&ctx->uring_cache, io_cmd_cache_free);
>   	io_alloc_cache_free(&ctx->msg_cache, kfree);
>   	io_futex_cache_free(ctx);
>   	io_rsrc_cache_free(ctx);
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 7fd173197b1e..e275180c2077 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -755,6 +755,7 @@ const struct io_cold_def io_cold_defs[] = {
>   	},
>   	[IORING_OP_URING_CMD] = {
>   		.name			= "URING_CMD",
> +		.cleanup		= io_uring_cmd_cleanup,
>   	},
>   	[IORING_OP_SEND_ZC] = {
>   		.name			= "SEND_ZC",
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index de39b602aa82..315c603cfdd4 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -28,6 +28,13 @@ static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
>   
>   	if (issue_flags & IO_URING_F_UNLOCKED)
>   		return;
> +
> +	req->flags &= ~REQ_F_NEED_CLEANUP;
> +
> +	io_alloc_cache_vec_kasan(&cache->iou_vec);
> +	if (cache->iou_vec.nr > IO_VEC_CACHE_SOFT_CAP)
> +		io_vec_free(&cache->iou_vec);
> +
>   	if (io_alloc_cache_put(&req->ctx->uring_cache, cache)) {
>   		ioucmd->sqe = NULL;
>   		req->async_data = NULL;
> @@ -35,6 +42,11 @@ static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
>   	}
>   }
>   
> +void io_uring_cmd_cleanup(struct io_kiocb *req)
> +{
> +	io_req_uring_cleanup(req, 0);
> +}
> +
>   bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
>   				   struct io_uring_task *tctx, bool cancel_all)
>   {
> @@ -339,3 +351,11 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
>   }
>   EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
>   #endif
> +
> +void io_cmd_cache_free(const void *entry)
> +{
> +	struct io_uring_cmd_data *cache = (struct io_uring_cmd_data *)entry;
> +
> +	io_vec_free(&cache->iou_vec);
> +	kfree(cache);
> +}
> diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
> index f6837ee0955b..d2b9c1522e22 100644
> --- a/io_uring/uring_cmd.h
> +++ b/io_uring/uring_cmd.h
> @@ -1,7 +1,10 @@
>   // SPDX-License-Identifier: GPL-2.0
> +#include <linux/io_uring_types.h>
>   
>   int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
>   int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
> +void io_uring_cmd_cleanup(struct io_kiocb *req);
>   
>   bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
>   				   struct io_uring_task *tctx, bool cancel_all);
> +void io_cmd_cache_free(const void *entry);

-- 
Pavel Begunkov


