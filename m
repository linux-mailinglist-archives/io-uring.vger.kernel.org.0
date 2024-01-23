Return-Path: <io-uring+bounces-467-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2638D839BE0
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 23:11:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C25E92929FD
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 22:11:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C804E1BC;
	Tue, 23 Jan 2024 22:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lVNYZhlp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC991A27C
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 22:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706047866; cv=none; b=OaUovzLoHUp9fUxlVM+04JriuXDUA7LkyjLPVKKpUvug6DI/COuoZOvz42TvY5bgCmPG5UkVLpeZBeRyCFX2lkYLClJOp8PrUndBSoFkOWxOitkf5q9+DIu98SGBEteWDxYebodDMi1ipnj4jE+a/wgAVxc/nOI9nbqAQDdJhsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706047866; c=relaxed/simple;
	bh=uED+f09OSQaE9Ieleh1qK5bOLmqvX3MtnpT8Bk1B3+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mAerqkIQmsIiXeWP/zB18ygzDsGFeNoH2AXzqylgWyEvRShtH5BHWn374duoueyYOHKUXtZSPXfyDnhP7twN5jQkuY/FkVV3anPMmugxnnj5Ec8GOveJMprWqRw4ei0tbbv2IT9hQ708wlxl9mDPnlJE7nif6AG4e13NX/ZRz2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lVNYZhlp; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so701151a12.0
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 14:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706047864; x=1706652664; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Svns3nig7joeorU2G+WoVJ+rbZbgnVkotGKV4ksXVw=;
        b=lVNYZhlpG9KJqIsk4ba6ndo2nTPtJWyGzevORcGkkJvS5ZJSxsulOOBvWp4eIVR46/
         ZV3PQrcaXBLjNW76Bu5oC4NF/6f72iscpoyJu3+gBSonWpBniGhy2b0aXWUUAMsF9toX
         95qpmUKpUmw+a+ETXdlgCQ2s4RLUOk1qJf2hGVNYlUFo87jfvLjWEiXEQMLzrKA7LiaA
         qB4hUMafsTgvAyRlromvXVYThddZCNEjMyc+OjpRcY19XqrjzZNooNR2avnAc4ew0I6N
         4MkkTwvs5/ikJj72p2upd4lznNouWFDW/0MYTQLL4K8ybU7VFBtvTVBXv9hf2zOotCe8
         gIaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706047864; x=1706652664;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Svns3nig7joeorU2G+WoVJ+rbZbgnVkotGKV4ksXVw=;
        b=Ie5ncUHImR6HFpJZKI27qnFJejGtV3DdYX0cMXR83ys4gvYgSv5eO+doZLW7/fG9dY
         viNAjuE4SSb1/coZqxn9XdDyPAFHlCIHrV5wwm9BeHT8vP3+aLA9xREZP7t9mswJtN4P
         Vz4vMqLpuMetS2yZ2oFaOGngghXtlRh9l9Vr8aFCP2AiKz7LdWRM2aboxCeZejLY1xKm
         VJzyVVrusvU3Q8evfpcrJE9dAePi/Utek6/NuvBKQ3G0l5Ii61WN/cVbCtctBoaAcHvz
         LKcGx0V7uWEJPsmVz/nFztfuFTc0gsSMbWwwtUHjYhKoebGT/d2ue9uKNaYqlP2QLrvI
         HqvA==
X-Gm-Message-State: AOJu0YyD+YOZZa7yynjeNMEtf4FUeL0xK+iqOfEs+LYAuPHqSbZP5OgZ
	ICb9eNQE4T17tR/qBPnoZPFKgohhN2nbd079hgrrNIwQUzdDa2r4SvA1VF+JB/g=
X-Google-Smtp-Source: AGHT+IHsHwdd9jjYHJGA1Ig4TaxLfkVHrsu7oA55+j4ZYtcYRj8tQaT8PLIYS3cRzGK8lNwD4QcdYw==
X-Received: by 2002:a17:90a:7897:b0:290:8cb7:fa28 with SMTP id x23-20020a17090a789700b002908cb7fa28mr654281pjk.1.1706047863723;
        Tue, 23 Jan 2024 14:11:03 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id ee6-20020a17090afc4600b0028e17b2f27esm12468545pjb.13.2024.01.23.14.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 14:11:03 -0800 (PST)
Message-ID: <2271b0ce-875f-446f-bd13-8a5fdc9f0706@kernel.dk>
Date: Tue, 23 Jan 2024 15:11:02 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] io_uring: add support for ftruncate
Content-Language: en-US
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: krisman@suse.de, leitao@debian.org, io-uring@vger.kernel.org,
 asml.silence@gmail.com
References: <20240123113333.79503-2-tony.solomonik@gmail.com>
 <20240123211952.32342-1-tony.solomonik@gmail.com>
 <20240123211952.32342-3-tony.solomonik@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240123211952.32342-3-tony.solomonik@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/24 2:19 PM, Tony Solomonik wrote:
> Libraries that are built on io_uring currently need to maintain a
> separate thread pool implementation when they want to truncate a file.

Since we're getting down to nit picking, this commit message is not good
at all. It states a need, but it should also mention something ala:

This patch adds support for doing truncate through io_uring, eliminating
the need for applications to roll their own thread pool or offload
mechanism to be able to do non-blocking truncates.

> @@ -469,6 +470,11 @@ const struct io_issue_def io_issue_defs[] = {
>  		.prep			= io_eopnotsupp_prep,
>  #endif
>  	},
> +	[IORING_OP_FTRUNCATE] = {
> +		.needs_file		= 1,
> +		.prep			= io_ftruncate_prep,
> +		.issue			= io_ftruncate,
> +	},
>  };

Probably want to set hash_reg_file = 1 here as well, as it kind of works
like a buffered write in terms of serialization. Not strictly required,
as I can't see anything sane doing overlapping writes or truncates.

> diff --git a/io_uring/truncate.c b/io_uring/truncate.c
> new file mode 100644
> index 000000000000..4b48376149f9
> --- /dev/null
> +++ b/io_uring/truncate.c
> @@ -0,0 +1,48 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/fs.h>
> +#include <linux/file.h>
> +#include <linux/mm.h>
> +#include <linux/slab.h>
> +#include <linux/syscalls.h>
> +#include <linux/io_uring.h>
> +
> +#include <uapi/linux/io_uring.h>
> +
> +#include "../fs/internal.h"
> +
> +#include "io_uring.h"
> +#include "truncate.h"
> +
> +struct io_ftrunc {
> +	struct file			*file;
> +	loff_t				len;
> +};
> +
> +int io_ftruncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_ftrunc *ft = io_kiocb_to_cmd(req, struct io_ftrunc);
> +
> +	if (sqe->rw_flags || sqe->addr || sqe->len || sqe->buf_index ||
> +	    sqe->splice_fd_in || sqe->addr3)
> +		return -EINVAL;
> +
> +	ft->len = READ_ONCE(sqe->off);
> +
> +	req->flags |= REQ_F_FORCE_ASYNC;
> +	return 0;
> +}
> +
> +int io_ftruncate(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_ftrunc *ft = io_kiocb_to_cmd(req, struct io_ftrunc);
> +	int ret;
> +
> +	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
> +
> +	ret = ftruncate_file(req->file, ft->len, 0);
> +
> +	io_req_set_res(req, ret, 0);
> +	return IOU_OK;
> +}
> diff --git a/io_uring/truncate.h b/io_uring/truncate.h
> new file mode 100644
> index 000000000000..ec088293a478
> --- /dev/null
> +++ b/io_uring/truncate.h
> @@ -0,0 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +int io_ftruncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
> +int io_ftruncate(struct io_kiocb *req, unsigned int issue_flags);

Rest looks good to me!

-- 
Jens Axboe


