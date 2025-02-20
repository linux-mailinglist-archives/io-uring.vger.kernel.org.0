Return-Path: <io-uring+bounces-6576-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AADBEA3D6E9
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 11:39:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6ED21165192
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 10:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C221F0E31;
	Thu, 20 Feb 2025 10:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GlmZx2Tz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF891F03F1;
	Thu, 20 Feb 2025 10:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740047881; cv=none; b=ljatAek+T5y24iWay+1Uh4wm80yhN5oPxUW2z3a7grPEHRmAFAqPT4diU8hHnoFcdiPHq0vGxF8yARf/acMk4z0ECs6t4TG+KczxlEMxYFRGbzqs1xTUXzUaxo+n2ejh6nGzPvw9tolC89FpnsadpKkPQLsooehbDfV/qeduI20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740047881; c=relaxed/simple;
	bh=6f5Uqjch9lYY515D2gskrHDjoHkLhw4CV3BClmDkXLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WonHtcURMC6tdnv1zd9v5XeMi+0XMs1pSsti8ZpcRasR2XoH9m4GE9+UUIh7zgA3pDVnQQgKxkaPvKPnFDdThNiESmBC6L1afvkeMVT1PYZomnCWLt2Jd0R7p5mSpGP0NiyqbCNuu2jtuc1k94VRQYE7Ce9/4O+MuduMehUEVeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GlmZx2Tz; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5deb956aa5eso1024131a12.2;
        Thu, 20 Feb 2025 02:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740047878; x=1740652678; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P0G8BGaw8hE5sseZSTLX1lXRj6SFC5fXXfKNLX25HZY=;
        b=GlmZx2TzHxiRRlhUBn+f7LK2YN/KRYN2BRHIayG/TmChouk5rFwSUp/Ej49xNuk4RX
         3XevlV+9yWEj6adhXZZBUAqZHCCe05Q8+wbpZi9iApysOQj5C8ljbh0GNs6Z5rx/dYyM
         84MA2/cx4VZ065dALzf+iwRTkv6xjrONZIc1+posHUEaKz275ulOGyDMhl4DU2XhMKaS
         rkd3DUEbDYJHCPFqoP/tro9h7JxLimu+fW5JZOSP5AllAsfXEmttdiaD7wSoNeLKJyxO
         /p1Yg626Gb7EWB33YPy/+mPAELGIyTwRRPtUF+MP0BgNnohjoaqdjG8qGQy2U3LzHdvm
         v2EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740047878; x=1740652678;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P0G8BGaw8hE5sseZSTLX1lXRj6SFC5fXXfKNLX25HZY=;
        b=jM22+jQF25DVmGBc17HxBcjKj4wt7RTMnSP/objD/WL8dDw6v3Y/X04FOuKV6tSZ3F
         nB++dN64zpR682W6p/3W/pQCDgyQ36rB4VfXsKAn4Wmjhh3x53KdRRJAQoDaOHXEBMJD
         r/La3nlgnCDcJPbathmuQ1t5zGGZxz8oJ+TL/ZPwdGWqFyikhY1GR66l7W9Kidp9qOf/
         JwiJ/ijetHPPpk0v1PPWw6IgqkO+TxzOG2eoQQBN0FhGtWIYnTi+o0WFEuynj0O6QSEI
         la0ThHzF6ziD/S1xca+KLXI6/hMb/qRQe/3jSMsbqeia9Ek4mOMjBpy1DJmCcbRdUE3o
         +PRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVY7ao+XsghSBsyQ4jPFQF+s5sKF0Ha+uXV4G5k8yqfiIwuJwSLi4FwssC8CojtM2AbEA9TJaJjlxfqV4g=@vger.kernel.org, AJvYcCVYfK6lU4yh1VvmuIUG35CCnY8HdiyCWBwxOu8Af2KLkXb1q5uhXF8wygn1MSfB2g6B+idy8x5IiA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxinaUCz6TiZpgrvBHQgEpHIXfJ5wWHvGRaZZCIirfWuAWDEUan
	5Q0rwN/5qLOjYAtGwtZeP+wTINMtvcpNLR9yQBWth44mtfnq2Luo
X-Gm-Gg: ASbGnct8ToosLDFKJYrI4V+ta6AIdQWz/nHHvGGymtRD1rCW6+oYNToW3DEpfLiOAiD
	pJmFt75IRTrOOzN0DFd91KvdMZ/WZdUp+mB/jFT6wTGS9N54siSCVejC0hKXScJ+H85Ux9YlxRz
	P1q/rjZRJarsdU8+LNGFb0p1m8TJ/wYa7lkf/p4/UyM1oUKsXjBb/BrivSI7u//MSn2HBkT1Q6d
	JqNqOLB4yK84wnY0eb9z0rklplwaEDc+e8Y2Uv0bSxN/3PjKYue3BQpbSHGYnV0ZmKHvUVIvgA2
	UTWv3ZSParEpJmgzg9atuZfQyVZ8oxVbT+V+gyL5fcfE8RuT
X-Google-Smtp-Source: AGHT+IGUakjQczbEFsbuqPeTGCARTyj4nMYupcHCOXUPSL9xs4iNyRLscrVSPPZnmFkUDVPOpMzVTw==
X-Received: by 2002:a05:6402:3547:b0:5dc:cf9b:b04a with SMTP id 4fb4d7f45d1cf-5e035ff9d49mr45427320a12.1.1740047877548;
        Thu, 20 Feb 2025 02:37:57 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:f455])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba53231fcasm1426610966b.25.2025.02.20.02.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 02:37:56 -0800 (PST)
Message-ID: <23fd95a6-9e68-4c87-8678-2023d80336d7@gmail.com>
Date: Thu, 20 Feb 2025 10:38:59 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 2/5] io_uring: add support for kernel registered bvecs
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-3-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250218224229.837848-3-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/18/25 22:42, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
...
> +int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct request *rq,
> +			    void (*release)(void *), unsigned int index,
> +			    unsigned int issue_flags)
> +{
> +	struct io_rsrc_data *data = &ctx->buf_table;
> +	struct req_iterator rq_iter;
> +	struct io_mapped_ubuf *imu;
> +	struct io_rsrc_node *node;
> +	struct bio_vec bv, *bvec;
> +	int ret = 0;
> +	u16 nr_bvecs;
> +
> +	io_ring_submit_lock(ctx, issue_flags);
> +
> +	if (io_rsrc_node_lookup(data, index)) {

I don't think array nospec inside is enough as you use the
old unsanitised index below to assign the node, and it seems
like it can speculate there.

Same in io_buffer_unregister_bvec().

...
> +	node->buf = imu;
> +	data->nodes[index] = node;
> +unlock:
> +	io_ring_submit_unlock(ctx, issue_flags);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
> +
> +void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int index,
> +			       unsigned int issue_flags)
> +{
> +	struct io_rsrc_data *data = &ctx->buf_table;
> +	struct io_rsrc_node *node;
> +
> +	io_ring_submit_lock(ctx, issue_flags);
> +
> +	if (!data->nr)
> +		goto unlock;
> +
> +	node = io_rsrc_node_lookup(data, index);
> +	if (!node || !node->buf->release)
> +		goto unlock;
> +
> +	io_put_rsrc_node(ctx, node);
> +	data->nodes[index] = NULL;
> +unlock:
> +	io_ring_submit_unlock(ctx, issue_flags);
> +}
> +EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);


-- 
Pavel Begunkov


