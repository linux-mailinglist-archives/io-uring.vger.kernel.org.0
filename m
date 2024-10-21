Return-Path: <io-uring+bounces-3862-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C3739A6F66
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 18:28:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6627E1C22AE6
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 16:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 373E31E00A1;
	Mon, 21 Oct 2024 16:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UCvuqJE3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1147A137750;
	Mon, 21 Oct 2024 16:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729528081; cv=none; b=Gcui9LtlOBVqszamaiwsIK/sHqb28xsgV9h1dVXcFUGnnK3IwQDhT+I2UVDBZse4/Uf8RUeNzg2AB/YEB1L4Jw9qZK20cO3nF0WNPG0Gov05if2ik55Xfvmxe+VTjDP0NzWUcBTNGndH4NZBHMd262BHGHcM2hU5euAXA9uxQYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729528081; c=relaxed/simple;
	bh=tK9FDYKOCWUki5dgpFB9+gXbd/NrIS4DUJBRWGDo5Vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U3DponRJtWRGoHD01cT4cRF8CgevMlJ1DBJzJlcDAxY3bOgH7yfgG8RBz2hljKrkCd4TdnbVm1QfA+ksJ02EoZl54fWelH0QylRL+IPDslt8CHOibzJg1DHgyXazvluBZCg4IfEBuQOyp6T0gJH0K+c9+FD9Tv+04y6x85iFDmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UCvuqJE3; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-37ed7eb07a4so1688844f8f.2;
        Mon, 21 Oct 2024 09:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729528077; x=1730132877; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+wu+rsl6Ec0qRaVz+cSxiypc4jjSxoVCm0KmeiL50cs=;
        b=UCvuqJE3QoaC9FV7eeWvdQWqk3rsNnQ6VljZl/PtVG6h3whx1AC8SnO2exYaxQGdNm
         4voKiCMyM/GiYbO70VvHeLVtHORFsAETiAmnLeDKOm/lPtmweZZAO2Qzp2WVvgIf2dTL
         ek9c85KqQE2VeIDGzV3ZNJUPWUEZ8Pngi8gB8IDaJPINhyXuWpAlDIERR4GuMuUiQcp9
         nV9NzmtqaVu0vkY9kLrjlDoTKyoDRy1YOSNBR830Sp/ONgfWi8DyAXXYmq2nCRpxuO3R
         nS3RvxVHbcP746rdTCuE9+faMcKzNLHwVWPlsfD8Sq/iSl6SN0mb7qkQETtxY18Vrri3
         sd6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729528077; x=1730132877;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+wu+rsl6Ec0qRaVz+cSxiypc4jjSxoVCm0KmeiL50cs=;
        b=KGQp24FK4pJ4iHmPazpMzPdcntCPA4VkSq24tRrc3mVNAGpJIKCZh9PdsYh/0Adns4
         J+VyQ8W2qhcRK8xqMlFoH9Tc8kHNXsx2HYSXHJKPxGYe09Ui1qxVzV7FZXf8r/LzLr1R
         YNRcK3z3iuDyqoIizLMD9rJEgveroiQms0/JkUyMJIaYNrq9HMhcEarCzc32L+QZnb2n
         wGpX1yLy0rbXmawlB9k5UhzwAFTS98/tF8Dv79cmA4BbfGUq2AX05w9yz+KaV6vba97b
         nzDPu3jNsyG/yilkaiRTY4gsUim4vMFO0albdSiRHeavBLqtW/tiG5h42i+E0bNe7k8S
         Bckg==
X-Forwarded-Encrypted: i=1; AJvYcCUZiUATG4xSoVVhOUpkQkJH/2aImC/qbfpA4GM7PF+RZH3zctXhXJtMUi1ewscbTES3o1SBz1bp@vger.kernel.org, AJvYcCWdI/Cwg1sFaH3xBus8F6j+YEmYN4mf/ulIqtpUhXH8rpDD6BnwwVy2/wPv9XDhOpsQ0/VoOIQwqw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx67V4LH4JslA/eG8IHMc95y+pucGkCusJWhZvwc5JkhFrqnrRT
	I9g+dYNABFnwwsrufJQqaHhsY/aWHLf/cvwhMRseZ0dJdq2aO7dm
X-Google-Smtp-Source: AGHT+IGUmRHTdztAMIYxTu1Feixk2/i2yZfWQK1dgHM6zUpeelllEiXmQ8lUMe15iXK0/yr8dI3iEA==
X-Received: by 2002:adf:fb45:0:b0:37c:d23f:e465 with SMTP id ffacd0b85a97d-37eab712dbfmr7028773f8f.55.1729528077178;
        Mon, 21 Oct 2024 09:27:57 -0700 (PDT)
Received: from [192.168.42.158] ([185.69.144.55])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0a4ae36sm4704415f8f.43.2024.10.21.09.27.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 09:27:56 -0700 (PDT)
Message-ID: <433d21ff-6d7f-4123-8b11-c5d3c9a9deb1@gmail.com>
Date: Mon, 21 Oct 2024 17:28:42 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/15] io_uring/zcrx: add io_zcrx_area
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-11-dw@davidwei.uk>
 <3aebbd91-6f2f-4c8c-82db-4d09e39e7946@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3aebbd91-6f2f-4c8c-82db-4d09e39e7946@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 16:35, Jens Axboe wrote:
> On 10/16/24 12:52 PM, David Wei wrote:
>> +static int io_zcrx_create_area(struct io_ring_ctx *ctx,
>> +			       struct io_zcrx_ifq *ifq,
>> +			       struct io_zcrx_area **res,
>> +			       struct io_uring_zcrx_area_reg *area_reg)
>> +{
>> +	struct io_zcrx_area *area;
>> +	int i, ret, nr_pages;
>> +	struct iovec iov;
>> +
>> +	if (area_reg->flags || area_reg->rq_area_token)
>> +		return -EINVAL;
>> +	if (area_reg->__resv1 || area_reg->__resv2[0] || area_reg->__resv2[1])
>> +		return -EINVAL;
>> +	if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
>> +		return -EINVAL;
>> +
>> +	iov.iov_base = u64_to_user_ptr(area_reg->addr);
>> +	iov.iov_len = area_reg->len;
>> +	ret = io_buffer_validate(&iov);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = -ENOMEM;
>> +	area = kzalloc(sizeof(*area), GFP_KERNEL);
>> +	if (!area)
>> +		goto err;
>> +
>> +	area->pages = io_pin_pages((unsigned long)area_reg->addr, area_reg->len,
>> +				   &nr_pages);
>> +	if (IS_ERR(area->pages)) {
>> +		ret = PTR_ERR(area->pages);
>> +		area->pages = NULL;
>> +		goto err;
>> +	}
>> +	area->nia.num_niovs = nr_pages;
>> +
>> +	area->nia.niovs = kvmalloc_array(nr_pages, sizeof(area->nia.niovs[0]),
>> +					 GFP_KERNEL | __GFP_ZERO);
>> +	if (!area->nia.niovs)
>> +		goto err;
>> +
>> +	area->freelist = kvmalloc_array(nr_pages, sizeof(area->freelist[0]),
>> +					GFP_KERNEL | __GFP_ZERO);
>> +	if (!area->freelist)
>> +		goto err;
>> +
>> +	for (i = 0; i < nr_pages; i++) {
>> +		area->freelist[i] = i;
>> +	}
>> +
>> +	area->free_count = nr_pages;
>> +	area->ifq = ifq;
>> +	/* we're only supporting one area per ifq for now */
>> +	area->area_id = 0;
>> +	area_reg->rq_area_token = (u64)area->area_id << IORING_ZCRX_AREA_SHIFT;
>> +	spin_lock_init(&area->freelist_lock);
>> +	*res = area;
>> +	return 0;
>> +err:
>> +	if (area)
>> +		io_zcrx_free_area(area);
>> +	return ret;
>> +}
> 
> Minor nit, but I think this would be nicer returning area and just using
> ERR_PTR() for the errors.

I'd rather avoid it. Too often null vs IS_ERR checking gets
messed up down the road and the compiler doesn't help with it
at all.

Not related to the patch, but would be nice to have a type safer
way for that, e.g. returning some new type not directly
cast'able to the pointer.

> 
> Outside of that:
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> 

-- 
Pavel Begunkov

