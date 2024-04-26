Return-Path: <io-uring+bounces-1647-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D919E8B39EB
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 16:27:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C80B2893D3
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 14:27:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D004156880;
	Fri, 26 Apr 2024 14:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2SQEIX/0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE0B154C02
	for <io-uring@vger.kernel.org>; Fri, 26 Apr 2024 14:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714141560; cv=none; b=pcfCX2Jy6LmJ6qzDx+/k8hYysb3DUj/V1AzssYPr4o/II+K+TCxHyPONVntKzwZjsALLmGfV1SDn6nlX9MnbwbYAuIwmjLTg4C1qvCgBRiUvvoBJJbGZ6O2yySYxphOitTFmUDb3CCXwXYgrj5ByBwFwtr7hVdiRkVKlB6tKz1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714141560; c=relaxed/simple;
	bh=R+X6vEPvFdoCJxBIEPLQMPr/wTwjjGdva+cEfV/Afi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zo7KLUxtpXGBmT2euzzFxNOqkNaZQPuGcGE0k16shwKRMdf6Kd9NTZwJ51P3YgaoOUKsNSfPTiFhqpMEyyLHPflnnHVm3dbP0OZ/bHxJ+7XzB5a5mRROgkGfveBimb2di9VOUF+3wmA/YFRmCIxes84t+3jmWlaqml+OLoeEBhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2SQEIX/0; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7d9c78d7f97so17011439f.3
        for <io-uring@vger.kernel.org>; Fri, 26 Apr 2024 07:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714141558; x=1714746358; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SYZdlhOSW2plAcrRNZa4kVgqNxzt+id2KNIRqIUgxH0=;
        b=2SQEIX/067Onznf3PPogeA2vv3fIQ2IDTTWwUS0E3M1LKaIcyhl6rwHwocm3R0WMQ2
         0GSkqKniGnkpwN69me2mJgasxJXZNr6U1g1nOsswzKiMRUlN/S2LBvWgnP/DAI8vo221
         9MfqjzNl/KcVqrgRGat7bLDGIG+obdqahC9mSYM58uTGydS9Tzw2wOZhtzBcICl+Yvk2
         FmpyCKpBZwvwnGL22CrA2iUGUWO38KR7SavdfU9cqO6PVLQfVaPcq1NYCiOkPWNgOYLO
         U8zHh4AYd8u1dakr5XBbQ4qgJbbsKaxdIgXtezypgWMCw2CuRUY2GqGgB+nEbdT96T8R
         aaKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714141558; x=1714746358;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SYZdlhOSW2plAcrRNZa4kVgqNxzt+id2KNIRqIUgxH0=;
        b=MqQP5Q+S4qRlDHjpCqqBE+t1HqQ0/IH56uuHHNDsAjduVLnY1T0rwZ6aktUeMcKdAC
         Cd+ahD4OWFU4XVoItOCtOKMw7NnmnaTy/c7QCfviF7VuVUpRafpq3asRLTB2Jw1L+/Vx
         1+/i0Iyn8sE0n61kbeW8TZX1Jn3rdrZxmDoJrC5KD9yBypXMC6MNp31/cC0MRHY2f9/2
         AySUEOGPhfQAgRfXaXAWNLtg5hUGUgbSzmlcaxpF5DfXlTQmX8O2TZBC8aHkAzeXa7nn
         zYkXG1JkNqXTtNYSKbflNRYfqhqy4MHvEcbjGg27lJHVbI8dg7jonVECrKATVtapIH+3
         gICQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2IyDAHq2OwUobuw7O9xWSZq2nnyS4+0kFeWsprwGwqXIpPY2WDbHQuxsIyPzmzCuYKv0GX8ZdBd3+fuWWUI9IaPLTIQ8yaH8=
X-Gm-Message-State: AOJu0Yym3JyN8Y62HlpfZ9E27+dKv1UmRUjCwNi/XgsMnvYSKeULt75H
	V8nF/EG2U0GeS8bqs0/4PvOAObilZAD5BRWcg6NKXXIJ2hRNkl+Hf9GxzOGi3uY=
X-Google-Smtp-Source: AGHT+IHWycOosPVtgbMwTpV7/9CaNBl4iip2iOSTKzHCtn56tUpEKvqQDc9Ko3d1m//8UmZnV2Xyig==
X-Received: by 2002:a05:6e02:1a6d:b0:36b:3c29:8d19 with SMTP id w13-20020a056e021a6d00b0036b3c298d19mr3595304ilv.3.1714141557913;
        Fri, 26 Apr 2024 07:25:57 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v8-20020a92c6c8000000b0036a1303cc0asm4007216ilm.0.2024.04.26.07.25.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Apr 2024 07:25:57 -0700 (PDT)
Message-ID: <f3489d0c-2d27-4e27-ae49-df2e9dad2e00@kernel.dk>
Date: Fri, 26 Apr 2024 08:25:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/10] io_uring/rw: add support to send meta along with
 read/write
Content-Language: en-US
To: Kanchan Joshi <joshi.k@samsung.com>, martin.petersen@oracle.com,
 kbusch@kernel.org, hch@lst.de, brauner@kernel.org
Cc: asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>,
 Nitesh Shetty <nj.shetty@samsung.com>
References: <20240425183943.6319-1-joshi.k@samsung.com>
 <CGME20240425184706epcas5p1d75c19d1d1458c52fc4009f150c7dc7d@epcas5p1.samsung.com>
 <20240425183943.6319-9-joshi.k@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240425183943.6319-9-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 3134a6ece1be..b2c9ac91d5e5 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -587,6 +623,8 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
>  
>  		req->flags &= ~REQ_F_REISSUE;
>  		iov_iter_restore(&io->iter, &io->iter_state);
> +		if (unlikely(rw->kiocb.ki_flags & IOCB_USE_META))
> +			iov_iter_restore(&io->meta.iter, &io->iter_meta_state);
>  		return -EAGAIN;
>  	}
>  	return IOU_ISSUE_SKIP_COMPLETE;
This puzzles me a bit, why is the restore now dependent on
IOCB_USE_META?

> @@ -768,7 +806,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
>  	if (!(req->flags & REQ_F_FIXED_FILE))
>  		req->flags |= io_file_get_flags(file);
>  
> -	kiocb->ki_flags = file->f_iocb_flags;
> +	kiocb->ki_flags |= file->f_iocb_flags;
>  	ret = kiocb_set_rw_flags(kiocb, rw->flags);
>  	if (unlikely(ret))
>  		return ret;
> @@ -787,7 +825,8 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
>  		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
>  			return -EOPNOTSUPP;
>  
> -		kiocb->private = NULL;
> +		if (likely(!(kiocb->ki_flags & IOCB_USE_META)))
> +			kiocb->private = NULL;
>  		kiocb->ki_flags |= IOCB_HIPRI;
>  		kiocb->ki_complete = io_complete_rw_iopoll;
>  		req->iopoll_completed = 0;

Why don't we just set ->private generically earlier, eg like we do for
the ki_flags, rather than have it be a branch in here?

> @@ -853,7 +892,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>  	} else if (ret == -EIOCBQUEUED) {
>  		return IOU_ISSUE_SKIP_COMPLETE;
>  	} else if (ret == req->cqe.res || ret <= 0 || !force_nonblock ||
> -		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req)) {
> +		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req) ||
> +		   (kiocb->ki_flags & IOCB_USE_META)) {
>  		/* read all, failed, already did sync or don't want to retry */
>  		goto done;
>  	}

Would it be cleaner to stuff that IOCB_USE_META check in
need_complete_io(), as that would closer seem to describe why that check
is there in the first place? With a comment.

> @@ -864,6 +904,12 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>  	 * manually if we need to.
>  	 */
>  	iov_iter_restore(&io->iter, &io->iter_state);
> +	if (unlikely(kiocb->ki_flags & IOCB_USE_META)) {
> +		/* don't handle partial completion for read + meta */
> +		if (ret > 0)
> +			goto done;
> +		iov_iter_restore(&io->meta.iter, &io->iter_meta_state);
> +	}

Also seems a bit odd why we need this check here, surely if this is
needed other "don't do retry IOs" conditions would be the same?

> @@ -1053,7 +1099,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>  		if (ret2 == -EAGAIN && (req->ctx->flags & IORING_SETUP_IOPOLL))
>  			goto ret_eagain;
>  
> -		if (ret2 != req->cqe.res && ret2 >= 0 && need_complete_io(req)) {
> +		if (ret2 != req->cqe.res && ret2 >= 0 && need_complete_io(req)
> +				&& !(kiocb->ki_flags & IOCB_USE_META)) {
>  			trace_io_uring_short_write(req->ctx, kiocb->ki_pos - ret2,
>  						req->cqe.res, ret2);

Same here. Would be nice to integrate this a bit nicer rather than have
a bunch of "oh we also need this extra check here" conditions.

> @@ -1074,12 +1121,33 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>  	} else {
>  ret_eagain:
>  		iov_iter_restore(&io->iter, &io->iter_state);
> +		if (unlikely(kiocb->ki_flags & IOCB_USE_META))
> +			iov_iter_restore(&io->meta.iter, &io->iter_meta_state);
>  		if (kiocb->ki_flags & IOCB_WRITE)
>  			io_req_end_write(req);
>  		return -EAGAIN;
>  	}
>  }

Same question here on the (now) conditional restore.

> +int io_rw_meta(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> +	struct io_async_rw *io = req->async_data;
> +	struct kiocb *kiocb = &rw->kiocb;
> +	int ret;
> +
> +	if (!(req->file->f_flags & O_DIRECT))
> +		return -EOPNOTSUPP;

Why isn't this just caught at init time when IOCB_DIRECT is checked?

> +	kiocb->private = &io->meta;
> +	if (req->opcode == IORING_OP_READ_META)
> +		ret = io_read(req, issue_flags);
> +	else
> +		ret = io_write(req, issue_flags);
> +
> +	return ret;
> +}

kiocb->private is a bit of an odd beast, and ownership isn't clear at
all. It would make the most sense if the owner of the kiocb (eg io_uring
in this case) owned it, but take a look at eg ocfs2 and see what they do
with it... I think this would blow up as a result.

Outside of that, and with the O_DIRECT thing check fixed, this should
just be two separate functions, one for read and one for write.

-- 
Jens Axboe



