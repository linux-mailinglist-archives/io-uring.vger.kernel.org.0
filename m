Return-Path: <io-uring+bounces-6578-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1310A3D7E8
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 12:11:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB4FE7AA71D
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 11:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B32E31EBFE0;
	Thu, 20 Feb 2025 11:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MgkwDCDl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD4422EE4;
	Thu, 20 Feb 2025 11:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740049861; cv=none; b=HDFOAwUAh8Fqsww1lBubTI5tDgCzDU0pf99BK/RHE7RvSi/t4rGtlrRUOxoX8FZK0nosFv9wyavBory4uFXQhxZDMadTnw3CUg9XMxzfVOgpk4sDLFy7VqxAJoz9D5oCeejNhB53ufffwp5YqenT2vcwsgEOznaJfWJZOr0Ow4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740049861; c=relaxed/simple;
	bh=lfPh0PAhDawk8rSUhs1ts1IfimfjKKtt6x4CuoJdbyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rXMl9tQpgXkCiO4c2oFv72jFzk9feFd4ullTT89DUsIDZnTH4Ba20EuZd0hpY+PLEJCjC8GgW4MiuYC2YFKP4LNWfN2F6ZZF4Vp9W67AKf09b3osDbTXT8tAENPBQCzOUf50/T4RbG9QFfMkKox8xCW8FuIVE20UNI7buygK/Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MgkwDCDl; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-abbc38adeb1so143005766b.1;
        Thu, 20 Feb 2025 03:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740049858; x=1740654658; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CWjPIveShp9pXIzSAYbwDxAsIMaohb44TpJ4ozqWNeY=;
        b=MgkwDCDlm+26T0V96YBQN7U1VLAxa8QYashlkJqKJZQ3o0Guvm08s1msbid2DYNJD8
         hmBPkqr3hLtE3OaYD20GljvJpe50T0j+oB//oPvYfxyeir3BuTfXFRwpztBFavSYgZ+n
         UvGJJ0ETLCfn89/c6coFaXg9NgRoMb9k51qo628t4Ey82RO/2jU++wkeHPfHs3c0wP0r
         uJqIWv5zzvXW+YqEPqVApzlYd2KfvJqVj0Few2eEU3+n77ZcPjoxa3NhgrZUbruqfiio
         lMpymZ5x7dXM7ALhL1rdlk1RJFNhBO0BeoZUpY7tTrJBapbQPTsMhWm2yYSQki0Aya7V
         l6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740049858; x=1740654658;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CWjPIveShp9pXIzSAYbwDxAsIMaohb44TpJ4ozqWNeY=;
        b=VCf7YF/rbOFrf8WW8HrtwiKu305w8JjK2iyOccEqDYMWi49z1RCyRA5wAWEY6nNOfW
         uaf12LJEbc00px66hsI/2C4X5KQwftUPMooNF0gT7mSAmrd+Nq7SutV2ughljsbFrNSg
         X4nM+nM/9z1pqJovi5ndP14Nb8ZabH5ODgikj/TsNxgMT3kNOGbZ5/GmP8euTf5byXNx
         t/HW23KKkxrvM+yco9W1nrdfKNgtuv8en23T3psAM6avYv5NLGu2MLhmRYB8m3Rk+nnR
         RycPBcw7B3V5k85E+VrD+ZEQdJc3JmDiPPi/13jcGzBnbARUOutU/Kj72lG+0tw5iBAx
         lOJw==
X-Forwarded-Encrypted: i=1; AJvYcCVXd8dZEZXrJ/H9IGjvgAHWOkDkqJf//vCyAJXPa+AFLTnXoe1k+H/4SyTncWvFwN+54o63HY678g==@vger.kernel.org, AJvYcCWd7kzUXeW2VZz5zd1hU64hRPRcDx5hD1LRtdDbQKiY8gqlBsRdKKZ7wbBtKlmALt+UESg5kweks9P58jc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqFJWlt8PVb7+qChK6PE6rTLEu0+ADMiSAUL2d1hwtVFBVrSKQ
	URApTc8QMxazVl/6bk3VeFGbg/A29iV6CNd7REzpPgpbAnLRO0aM
X-Gm-Gg: ASbGncse0ZMnVGZ2LjlD2CG4AbfKENOvKFCUyNTXRleWIz5xDr/2qzTgli4v+xhLLBb
	Di+Aa4feyOIHTcSST2zNxBXLhUAx/4RJRMrMgNNDmSjcFGk8KKHVM6b3JwXrEl7km7Ee+kA8+kW
	FZyyp9Niv/9O3j65pSc34qm+yNum1oAssLrHwiKeZOFsexxKZydllQa3yu56XmZ4VLTaVHY4W6F
	GhLpUI7Dkuzkl8P7RX9a2Sgx90pWJNK2tO6TubvgNgOolakWH84RIftsg67YgLwre8YwGGOz6gx
	YgG1YDFgcDWdf3PtfR1hmn2k+M+T0ie5bAV8jlKMUP7kjk2A
X-Google-Smtp-Source: AGHT+IGzhcT/tQ2Re3nqWBcU/+7uZpV3yGUKNiSdkSTtzjy+nGhy7P2ye1c2OJT61PbapG+qfKBsWw==
X-Received: by 2002:a17:906:2718:b0:abb:ebfe:d5eb with SMTP id a640c23a62f3a-abbebfed7admr239117966b.18.1740049857771;
        Thu, 20 Feb 2025 03:10:57 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:f455])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba532322e6sm1434340866b.1.2025.02.20.03.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 03:10:57 -0800 (PST)
Message-ID: <a636d5fa-1c60-410a-a876-52859df7277a@gmail.com>
Date: Thu, 20 Feb 2025 11:11:59 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 3/5] ublk: zc register/unregister bvec
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-4-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250218224229.837848-4-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/18/25 22:42, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Provide new operations for the user to request mapping an active request
> to an io uring instance's buf_table. The user has to provide the index
> it wants to install the buffer.
> 
> A reference count is taken on the request to ensure it can't be
> completed while it is active in a ring's buf_table.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/block/ublk_drv.c      | 137 +++++++++++++++++++++++++---------
>   include/uapi/linux/ublk_cmd.h |   4 +
>   2 files changed, 105 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 529085181f355..0c753176b14e9 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -51,6 +51,9 @@
...
> +static int ublk_unregister_io_buf(struct io_uring_cmd *cmd,
> +				  struct ublk_queue *ubq, int tag,
> +				  const struct ublksrv_io_cmd *ub_cmd,
> +				  unsigned int issue_flags)
> +{
> +	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> +	struct ublk_device *ub = cmd->file->private_data;
> +	int index = (int)ub_cmd->addr;
> +	struct ublk_rq_data *data;
> +	struct request *req;
> +
> +	if (!ub)
> +		return -EPERM;
> +
> +	req = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);

Shouldn't there some speculation sanitisation for the tag as well?
Looks like a user passed value directly indexing an array.

> +	if (!req)
> +		return -EINVAL;
> +
> +	data = blk_mq_rq_to_pdu(req);
> +	io_buffer_unregister_bvec(ctx, index, issue_flags);
> +	return 0;
> +}
> +


Pavel Begunkov


