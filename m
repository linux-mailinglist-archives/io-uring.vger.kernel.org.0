Return-Path: <io-uring+bounces-6814-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C05FBA469F1
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 19:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C37BB16C8D7
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 18:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE87A21E096;
	Wed, 26 Feb 2025 18:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HUaa5P1B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2702222CF
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 18:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740595230; cv=none; b=dwZVNbScIjTcelDqXOe9cW90mSO+EIjcgj06JK08gBK4rk796NWdfLKzDbDY+0CNDIEx4NW0HMU5Rys/bKyFOkqwhpGOK4bqKEjP2OFZqbMzctw0Sblau2JJXBKHnvrDp8azKHlK38oDNldu338QNSDIek9w8HcvhTGe9BlEReg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740595230; c=relaxed/simple;
	bh=SDS0zwcWP2Bd6umi8vdUr3ksCcJLy0HftJFhDpHch6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EGAhxRQzB73EwL+wLX4ZeYKyY5NTKrdT70HkNZkzHnvIeyJpERFPsgM99My5fQkZZ5RPIQ7oBSv0mUO/+gPVsxuZTpBTpiGB0lykxcAGCeKUbCUD8cUyvwyxpxdl9aqgoX/fYtCCBm8N2rrZY4wKcYm2S7fgTLeDBfTqIRsXn1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HUaa5P1B; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-854a68f5aeeso3561839f.0
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740595227; x=1741200027; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=symdU9EMvj/OBJzqzheNQbsiM+qkoxN4bra1Wzcsq1I=;
        b=HUaa5P1B61CeVR4yzIeb40L4W1lNYAMP+Ls0sQLoCvEKekHVSS3NG5NNZ5FG+PW57I
         U2iS+eJrulNo2wAG7Uq1JIbmzyI5Dy3kAUgimN7wRg8giPpvfFyA2FlcZXnNmnTxSM0h
         U+5hPcP3iJms3aKcKlhgEdc+fi9ZvKnTg3sAJ0xWlo4WqZt0eitaj0Nr+qEr5nYXOE2G
         eXfTf+R3xMtaHT8GQ3DDIrv+Lmt9NEacNM/o38jYvDfezXlNFsZn6tfOnEQpFKcloECu
         pYrKdZogP1VT4h21LFMuCq65yZsFzQ7d6L0w4xj+EywQRrlfk6jl5tWrY3HRjknfrCAi
         nzTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740595227; x=1741200027;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=symdU9EMvj/OBJzqzheNQbsiM+qkoxN4bra1Wzcsq1I=;
        b=YM4Q77S5fGeEM4eTfEZXLp5CEPLMA/zQ/2WOcywYPFn2L5+ibBdRtCqgPYf/VeEoqT
         lZIXLdXh+UOnoGq/o6xDTmRqgNb7hxBSY6LyaGrMQkwi50sXLu5hjAUiFTQj9o9oPnIw
         HMnw0eUXQxNWgsBYS0v6Giw1khphA+7zPtH0fSID5K1B1knxoZhKiYm9prFCBXq5NBNW
         RVDrMDSC9aqd1OGcHnJs2puB5IyVVKxP6WF1jdNRkKpfSKXpqR9vBKFYyJi2Dtyn8eJx
         0vvInWVGnpX95WSJOyjnhPL+IKglhQ2AfEK2o1wpB+UBTpKnyEoc8ffzWO+HJ3/EYiby
         Kbcg==
X-Forwarded-Encrypted: i=1; AJvYcCWMzt0nKH7FrPQPHSysPCY+AxH/77t7QkO/t4Eff53sxqO/8/5I5/8zz3LZCOKUXpiaGw53T5p44A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxT4yxinPqdWFffBMPXibuIdg53tLhPgP+D6uISL2HK3N3V7VZf
	f0lDJtbCS/n+TQpPc+1K53SSOO7mTmpXhrb5qUmZsZnBYz9mA2oLlDgha7SbB/Q=
X-Gm-Gg: ASbGnctC7Jt4CGmEsYMsxzKrCX5Pd/HuLrV9VU4xNbvoUQxSIuIp/SStWMQ5x+2V9Rr
	Wwo5nMrY6OMKMw04Lk6rtLgE/BI8KuJPDmX3SCjUR+EGWSVhhKvR9pTZF6nz2zzIcvk0InWeK24
	mTS/67EM3w/3eT6m3DHoGFLCe3Gikvj/L74Ad4b/lVq7thzgOjte7swqq6qWZLcM8LBjjhP/EAr
	ADa07NYi0x99sq2J0RyH2pBadh+1gIUqPf1LJDGtnxymCuOpviaucppg7gIDnLQyQMh96WWRGx6
	mka6tlJfIujIaZYpUSJLSA==
X-Google-Smtp-Source: AGHT+IEcVGZxj+MZL024go/7Ek44HCywTu0ZTaoD2vxe2DtY/vJ/oJ+MqLDaGS+x97+xAMqCCyDQ4g==
X-Received: by 2002:a05:6e02:339f:b0:3d3:d23b:21f7 with SMTP id e9e14a558f8ab-3d3d23b23a8mr56142825ab.18.1740595226635;
        Wed, 26 Feb 2025 10:40:26 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f047530650sm1033139173.117.2025.02.26.10.40.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 10:40:26 -0800 (PST)
Message-ID: <f987f9da-4aa0-47d0-b906-8790afe6be60@kernel.dk>
Date: Wed, 26 Feb 2025 11:40:25 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 4/6] ublk: zc register/unregister bvec
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
 asml.silence@gmail.com, linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
References: <20250226182102.2631321-1-kbusch@meta.com>
 <20250226182102.2631321-5-kbusch@meta.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250226182102.2631321-5-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/25 11:20 AM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Provide new operations for the user to request mapping an active request
> to an io uring instance's buf_table. The user has to provide the index
> it wants to install the buffer.
> 
> A reference count is taken on the request to ensure it can't be
> completed while it is active in a ring's buf_table.

Looks pretty sane to me, just a few minor nits below where only one of
them actually is required to change.

> +static int ublk_unregister_io_buf(struct io_uring_cmd *cmd,
> +				  const struct ublksrv_io_cmd *ub_cmd,
> +				  unsigned int issue_flags)
> +{
> +	int index = (int)ub_cmd->addr;
> +
> +	io_buffer_unregister_bvec(cmd, index, issue_flags);
> +	return 0;
> +}
> +

Minor nit here too, I'd drop 'index' and just cast it in the argument.

> -static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
> -		struct ublk_queue *ubq, int tag, size_t offset)
> -{
> -	struct request *req;
> -
> -	if (!ublk_need_req_ref(ubq))
> -		return NULL;
> -
> -	req = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);
> -	if (!req)
> -		return NULL;
> -
> -	if (!ublk_get_req_ref(ubq, req))
> -		return NULL;
> -
> -	if (unlikely(!blk_mq_request_started(req) || req->tag != tag))
> -		goto fail_put;
> -
> -	if (!ublk_rq_has_data(req))
> -		goto fail_put;
> -
> -	if (offset > blk_rq_bytes(req))
> -		goto fail_put;
> -
> -	return req;
> -fail_put:
> -	ublk_put_req_ref(ubq, req);
> -	return NULL;
> -}
> -

This could be a prep patch to cut down on unrelated changes, but not
really important.

> @@ -2459,7 +2507,7 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
>  		 * buffer by pwrite() to ublk char device, which can't be
>  		 * used for unprivileged device
>  		 */
> -		if (info.flags & UBLK_F_USER_COPY)
> +		if (info.flags & UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY)
>  			return -EINVAL;
>  	}

Missing parens here around mask.

-- 
Jens Axboe

