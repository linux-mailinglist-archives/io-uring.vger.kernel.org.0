Return-Path: <io-uring+bounces-3557-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43D58998734
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 15:09:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB13C1F22656
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 13:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CAAD1C7B6E;
	Thu, 10 Oct 2024 13:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KUwxeHR8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A601C6F76;
	Thu, 10 Oct 2024 13:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728565755; cv=none; b=QvlSA21rqKRBaIK+9IvjhWh6VMG2fWIisEfCV1++XY+phRLz57SREaQwxespEH0u88WXv3olJH0lpOJQ0SH4M90zNl1qUYtYWh3DyWGkGYAYH90d/UTnLXYwW2hFsrRvB92bJ8/JwKJ19CCQ88Fa4q2ZHf+4TeK830N5RKDxE2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728565755; c=relaxed/simple;
	bh=T5mZkOHS7vG+lFUs47QdYqLQgBVPp/gyRQJV9bSGRTI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XJ8bQB8TB2RDzDZeXxKdyWxIizhVDqzwozWK2TXLIgRb5UBYMWLj45a2KPAWkxm+hzjxgW8EMVLcp9VAru2j1ypMF6w6caHGjg2WySF7btW/lNj9m7XdRBNrq2jBnV5TAT6QhgWMpxL9wJ7SfCEKu7Z1Yp9avY0dW/hJI0zMF18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KUwxeHR8; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-537a399e06dso980999e87.1;
        Thu, 10 Oct 2024 06:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728565752; x=1729170552; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=drS4tAaSX0Dp1i2a443TGR4Qyywtl9yYon3FWAjBVrA=;
        b=KUwxeHR8PinjGYc2y7Oz2YTV8Hau0D/hJwq3ZOioQgqgNhPBSsX6JDxJnIYz5ULICV
         LCNB4WC9QCtlrw1LY6ExqPCgGoD1A/LilKBmKRZdtMo4kmFJpC57rvLYpmLSLzZLsniZ
         SECTSm4q57fqFuA3E3owl42pbNDVcZ/KEcYvZeQxRw4lNv9gFj75RKV4334vCRcEvQ2m
         tgxIGrnOHnUJ4C56RrwSoT+6wZ/oNg5B0gJgUSS+HIwyj8zL79qWqOJBvq2R02xKiDMT
         QQJjGROIWZwe5olqWOTmEbqDZMFO3tMeYiz9oG/7yD7t+UYssZSlS8js0RpsGB73JPOy
         toQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728565752; x=1729170552;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=drS4tAaSX0Dp1i2a443TGR4Qyywtl9yYon3FWAjBVrA=;
        b=LoRHSEZ3JovwZjbf7gUArbuCuELqzJ/BlNLruli17QFXLTU7B2RL2mYR6P+SWpoktn
         JlxQTSWdhMDxbMYvGgnh1XQ2CN4VXMbbQROS2aLSzyYpjQ9UI9k5XaSlnNdl+xuqBi9o
         xQv/3WOWxweGiZxRi+n3WXtUKBGIdgaTvgK+7O8os/pNWQ3gDST3besstvW2BQl2QS0i
         Y5+wr4x1yRikfnoicX99CUUmsiEX9z4mxC1cuBLMUe6xANnIykoaCW0YNXwv8rf55wo2
         Bjl6oi7HGotPs4M0RYwgCuZMfVvxFTkplY7UlTYFuDuG7H+N2wqryTjaBcUfzeMM70ih
         kYSg==
X-Forwarded-Encrypted: i=1; AJvYcCU+/IqR5r7LsoJ6/QTUYZilUSCVH2g2n83oBD8SJTIWdXVx3xjFeOvPESNwTWGRYPFKNhKbeusw@vger.kernel.org, AJvYcCUgYV1pJyqMu5Snm58sSaQRPf9+N+vHp5CP3UTXLOOES9tJ4Du59g5f2TqnygsM2R7RaikyKzD6GQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1lU/2B8bzJzfb11zx6ASSsgXrlff21mJi6QqHV1RWypPMbsbt
	gE6Gdo0cuGnN1iYSDmt6feWE74Dqrav1TFsmIs8N81WpucGIRjbC
X-Google-Smtp-Source: AGHT+IGW1H55qQFwX6aVwBS8GUNAAqZiW0nlx8cOcm/N9CoCYdP/308KaoeC5k0/NmJAgDenOLTifQ==
X-Received: by 2002:a05:6512:a8d:b0:52e:e3c3:643f with SMTP id 2adb3069b0e04-539c488a5b2mr3572799e87.2.1728565751711;
        Thu, 10 Oct 2024 06:09:11 -0700 (PDT)
Received: from [192.168.42.45] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b7ef4f6sm1553999f8f.107.2024.10.10.06.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 06:09:11 -0700 (PDT)
Message-ID: <678babf5-4694-4b65-b32a-55b87017ed87@gmail.com>
Date: Thu, 10 Oct 2024 14:09:47 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 14/15] io_uring/zcrx: set pp memory provider for an rx
 queue
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-15-dw@davidwei.uk>
 <53f1284c-6298-4b55-b7e8-9d480148ec5b@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <53f1284c-6298-4b55-b7e8-9d480148ec5b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 19:42, Jens Axboe wrote:
> On 10/7/24 4:16 PM, David Wei wrote:
>> From: David Wei <davidhwei@meta.com>
...
>>   	if (copy_to_user(arg, &reg, sizeof(reg))) {
>> +		io_close_zc_rxq(ifq);
>>   		ret = -EFAULT;
>>   		goto err;
>>   	}
>>   	if (copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
>> +		io_close_zc_rxq(ifq);
>>   		ret = -EFAULT;
>>   		goto err;
>>   	}
>>   	ctx->ifq = ifq;
>>   	return 0;
> 
> Not added in this patch, but since I was looking at rtnl lock coverage,
> it's OK to potentially fault while holding this lock? I'm assuming it
> is, as I can't imagine any faulting needing to grab it. Not even from
> nbd ;-)

I believe it should be fine to fault, but regardless neither this
chunk nor page pinning is under rtnl. Only netdev_rx_queue_restart()
is under it from heavy stuff, intentionally trying to minimise the
section as it's a global lock.

-- 
Pavel Begunkov

