Return-Path: <io-uring+bounces-5188-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E5FC9E259D
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 17:02:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 766E6B62B09
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 13:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58D281F12F5;
	Tue,  3 Dec 2024 13:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EsVpHKAA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8374B1E0E12;
	Tue,  3 Dec 2024 13:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733233613; cv=none; b=i06DdEbyXUGfSfGMQ1g+VBb5AK8Eq1TIAvga7573yDXDCDHuPXxJ6cvq9vnppJeWgSbjk6SD9DQcfdyfoFo6zr2cc/la1xoZBAbqbmGnuEufsuRfAFvC58MBnsf4ULXZmCzXT9sCXnfaThvUj8/Q59kKDC2wnLYAzbfrsWXHUYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733233613; c=relaxed/simple;
	bh=tcWzjpxqWNgbgEDLSBkQH0YXLSNLYXAlu6btqLwbbBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xkno05TKm7iQoOqvOeUES2FA+dQ8m+mnPUt1zwLLaQXqga9uJ4Z+neLu6ap+bTRCFRB37kflTdpmS2eCJFHlLh1d1eBR2ee+S5sBl/jR5ltO/h53yoxcbSpir6uUToFGjQPCWnzrrYgTC2iTpaXQYldK2YudSDy54JBrSdVnd6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EsVpHKAA; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d0b922a637so5367907a12.1;
        Tue, 03 Dec 2024 05:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733233610; x=1733838410; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OtQtGdm2qxcHHDtKUbbuhDBQOpZ5gw84uBRHgBHBz+I=;
        b=EsVpHKAA8SFyhhnKmhKIo59IaSdqro+ZT7xlp65D0GhkigyG/noFIvf6z7tE6hVFSS
         ORCHd9lF8/bOoLEwQeugf829WJ7iQwyDdMkzOV/vT9/P1MjixkTqKxvISLFzOa8pf07r
         qe1RTnsOOnZRDD60SpiPgdpuYbEfNelcBS9sOp2xYjAW4ZDbm9z58f1rzw0Yb9FSNsUW
         X0k2n/G7hW5n/serw55y5/ihpiCh0UuC3fuX/AU6kxvLsL9i900rIrCmx7Jg1ijDkOoz
         cuxC4zQzOMVIazkjrg2llei4L1S6whaeubxBfgtQLZ20Wa0KEB/9pxJoaME3ABoymoPA
         5VfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733233610; x=1733838410;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OtQtGdm2qxcHHDtKUbbuhDBQOpZ5gw84uBRHgBHBz+I=;
        b=G5KwdjXHsREj5yM2wY6AvnXHaPsK8XYPI8rViujGcwx8C91LiwrBVEBETTNznQkrbF
         1yXaaWOieE0WXq0tVJqrMkzc8CowAi2WzT3ZqgLPf4cdENQmChr8x2c2in6rbuohGYE1
         480RQedMjh4LdQJJxMzjPN9wVnKGtyhXqkS4XpocEhdHwOibuP3kTs6y/P6+cJ4jt42R
         P1F1cG43YmqSxu1EMBFk67LfvTYtkww/V1s7BxJb+3wYri5opVzeRs7NEn3UOLzR9g4+
         MT5TjIgtQJFKnDyfBWn1uhfKGQxopUMjOj7ze696V0D3f4Ssc1tZNlbKqhZxLStLT/ow
         h/cA==
X-Forwarded-Encrypted: i=1; AJvYcCW+v+e8oPC+mrp3yKVBOYYgUNiK300WwIuQk6JgN46mgG3d6ssUvOYmvWsqhzgGgKBBMa8i7jBjLgv0utnRBg==@vger.kernel.org, AJvYcCW4bKmieZe8KQH01JaJH+zx8G8Bi/nelPK8D4YitlUlca231law55Q/N573w6CPgSBGZ8DZAN5clw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgDS4YcKQPEohF7EcW0spf5E9KS7zlvIA4OJTozbp0sQB/1WAD
	N8NkEJaTB5AW/ujQbd/fw7D6D7bJ7zQY9MshriPBI2e6M6UxU3mw
X-Gm-Gg: ASbGncugAD0uvjdx5Lq5YD1vf1Gk37kxwZuGHrfnkMBHY8p4L9IttEUDmqQl1uIRmD+
	vcP7ynfnBe29Wwa1vU47xPhXPG5thDVG6FDWQzgPaR9tKCIIFvUZ+8N0AuvILRqY4GDnpNx/nuy
	aqOcaBRBp7shnVQsFTgSiHAm6kyj/BUot4MMqdeXlOpHr+hRSqJ0admlkH0jo/iLRErpHeyyDZb
	mj03IGqPdBbTcv4iqcg0ksX693XxQV0rdZQiX8ZaEm49QnAyUmVTSSirzjYBg==
X-Google-Smtp-Source: AGHT+IG1amz/IzU2dNt1TZrDlWFgXpLcVIHtvYqImiXKXZmqkXunLbWj6eMXvPhWpTWRXlWCL/K/7A==
X-Received: by 2002:a17:907:7806:b0:aa5:3b1c:77a7 with SMTP id a640c23a62f3a-aa5f7cce469mr188190166b.6.1733233609393;
        Tue, 03 Dec 2024 05:46:49 -0800 (PST)
Received: from [192.168.42.149] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa599801591sm615327366b.91.2024.12.03.05.46.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 05:46:49 -0800 (PST)
Message-ID: <b9a7308a-19d0-40d7-8f00-5b95404936b4@gmail.com>
Date: Tue, 3 Dec 2024 13:47:45 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 09/16] fuse: {uring} Add uring sqe commit and fetch
 support
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <20241127-fuse-uring-for-6-10-rfc4-v7-9-934b3a69baca@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-9-934b3a69baca@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/24 13:40, Bernd Schubert wrote:
> This adds support for fuse request completion through ring SQEs
> (FUSE_URING_REQ_COMMIT_AND_FETCH handling). After committing
> the ring entry it becomes available for new fuse requests.
> Handling of requests through the ring (SQE/CQE handling)
> is complete now.
> 
> Fuse request data are copied through the mmaped ring buffer,
> there is no support for any zero copy yet.
> 
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
...
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index af9c5f116ba1dcf6c01d0359d1a06491c92c32f9..7bb07f5ba436fcb89537f0821f08a7167da52902 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -24,6 +24,19 @@ bool fuse_uring_enabled(void)
...
> +/*
> + * Write data to the ring buffer and send the request to userspace,
> + * userspace will read it
> + * This is comparable with classical read(/dev/fuse)
> + */
> +static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent)
> +{
> +	int err = 0;
> +	struct fuse_ring_queue *queue = ring_ent->queue;
> +
> +	err = fuse_uring_prepare_send(ring_ent);
> +	if (err)
> +		goto err;
> +
> +	spin_lock(&queue->lock);
> +	ring_ent->state = FRRS_USERSPACE;
> +	list_move(&ring_ent->list, &queue->ent_in_userspace);
> +	spin_unlock(&queue->lock);
> +
> +	io_uring_cmd_complete_in_task(ring_ent->cmd,
> +				      fuse_uring_async_send_to_ring);

Just io_uring_cmd_done should be enough.

io_uring_cmd_done(cmd, 0, 0, issue_flags);


> +	return 0;
> +
> +err:
> +	return err;
> +}
> +
>   /*
>    * Make a ring entry available for fuse_req assignment
>    */
> @@ -148,6 +385,189 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
>   	ring_ent->state = FRRS_WAIT;
>   }
>   
...
> +
> +/* FUSE_URING_REQ_COMMIT_AND_FETCH handler */
> +static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
> +				   struct fuse_conn *fc)
> +{
> +	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);

Same comment about checking SQE128, fuse_uring_cmd() sounds like a good
place for it.


> +	struct fuse_ring_ent *ring_ent;
> +	int err;
> +	struct fuse_ring *ring = fc->ring;
> +	struct fuse_ring_queue *queue;
> +	uint64_t commit_id = cmd_req->commit_id;
> +	struct fuse_pqueue fpq;
> +	struct fuse_req *req;
> +
> +	err = -ENOTCONN;
> +	if (!ring)
> +		return err;
> +
> +	queue = ring->queues[cmd_req->qid];

READ_ONCE()

> +	if (!queue)
> +		return err;
> +	fpq = queue->fpq;
> +

-- 
Pavel Begunkov


