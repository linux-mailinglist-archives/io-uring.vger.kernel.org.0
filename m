Return-Path: <io-uring+bounces-10399-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C2C32C3A919
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 12:29:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7570B4FEADD
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 11:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2EE2EC08F;
	Thu,  6 Nov 2025 11:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KNDOe5f7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E78330DED5
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 11:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762428399; cv=none; b=tRUZPRtAD2xGvshWSOVS86WsVHSkwyY2Ei92FbdtsSqfcWmkeK5VRCQNYw8jCQLdaF32Ax8FbhEZ7kRKbbfS6vsFq4ZNt3PD57zq6DxhIa4X2dyLRRMOZnulRrKQLziOj6HR3rluYR8oIF4S0mQsLut4Qiqq+RN0QjmQ/vLjEO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762428399; c=relaxed/simple;
	bh=3TpxRglspUACq5c63L2B8gr8ctmmpt2sp9Dykw3bQdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rTEW6bMl2OykqB6p4helmDLaVvzWQ3QXjcx7FH0ZLuZUNgN66Wh97iaM7dBeVelRwcSV9kMKuzAFut8KwBkAnHt+nmvynqqrQBPwluoEYkfSMM/t3FC3IFwx7ElM7rqE5LdmgbC4HIfMrSudCtT81zvxN+xP2YAyGSXjzPqso14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KNDOe5f7; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47112edf9f7so4802205e9.0
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 03:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762428396; x=1763033196; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uXIpJytB/608z+FMyajHR2lsNkS90TJCy2K+7b1+Tfw=;
        b=KNDOe5f7U6td9nzoAXKLs46nF4c5oCVNm1dC/tNy4Eibs15MhC7shgVqPvle4TFuVX
         WVCyqd/GwO7Vy4rbkaUyrsd7WlDOxVGh9mKII4X6zS1QR5xjyYDdZM8Lrdgv7wW6nsVC
         QKR10YqOqsmIoc3fhq853Lsrg04EtcYW1fh7UmaEDXdKBrA1vrRKP+Oc7sacNN+nQF2w
         SQcN7P5lhmd44G5MnaBs9ACKiAvh7LW9SlSavlxqcQosvfwLJAX4lt10Cvs4EqF9vYyW
         fQPg5+BIVv6K28n2+MIgjXMQFUceeCY/FLoyJp6DaPnhppINWlbWV1Gnyw3DO2x504tk
         m8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762428396; x=1763033196;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uXIpJytB/608z+FMyajHR2lsNkS90TJCy2K+7b1+Tfw=;
        b=evRhj2yMnKJwuvJgYnZ0CVV8Wf06Kft/yVk8KCkMFguT9viDZzvTT51m7ssPv8LNwg
         GxHhReE9Av4GmsPXBlS3Sv+AkmSEbvnBcZDhqDXTGaHInSA9sLRc+SWVyQKTUuLzx5bc
         8VH4R1YqKgZ0qWcCEo3jCooGuBbiMmmAPILmCvKWh37yj84Ojh7LTY7yXPbOeqYGeoa8
         bXSSsWRmVQ4ULn6VzyCJpdxkXAoh4D8N63ntwFMGsycdLQaZ5C9qLBMY5PDKyncO0TF8
         n31RM8luLqjX94ROW5JLvpQLwgsiTRphG9tzCT4kSSDc+rQgRbGFTus0J/ryvj/1t/ls
         +1Gw==
X-Forwarded-Encrypted: i=1; AJvYcCV3ih2zLwRZez2nDeh02T+LicEvWTmZokQDoc0fgMKxdSWSnwkSgln36wlZCIIrReKP9FHHB1wQfA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9Jvcb+zQvMEF7Z6020h0ryd5Y9nP+R6/k2n4YYG4CjeEv9gqe
	OBpeJlxEciEA7Z3gd640XqLBxlH1mh9XX6ftuV+n2D6RbpIQElhufnjO
X-Gm-Gg: ASbGncv0Huwia+4MnPomKBbczndKK4XpF+1V2oq8gRuDD7mvIXmArZSmnVp3oR45PSj
	Eh+u4s9ZqNj/WwMg0ELTJeqtUqmlEZkkm7DfLVVQyImtXT5Q4YH2RSbrW0IYiOInFoekLy2vDqW
	cC/M5hpOvQG+tV0pvojlj6YMCU7j6xZgNxDxjGTkQ2r9w6ovSYgxQgdVGzlzAUIcL5RA3AIPoZT
	TGbz9japxq58aLY0eYgDBzdwHELaWq4huQuOKCDyuqDWwONp5csIS3gGMdlxzBIj9hvaMnIkz6w
	BRGHYEgjLycI5oLA9uc9TJOkYMpDN+PCEN+GJCOfk7+J+HwDkYJeYSQ0lp+qk3giQNMv8I5AWCa
	F73hcE0sF2rmsnVVfA1OezSq/KkLDygQsvFDQrEAvKCwcQ+GU7XpXDO2+HVoMhhWuSszsNEovKV
	6cxu6a2BtWg1y0j+yY1kBgLgAlocHKjcKG/jozLEbw2fG3j2cA5fE=
X-Google-Smtp-Source: AGHT+IFwjfWa10ed4D/OA6R4TyrGYSlDyevcL51fS4SIUhaeeCwUOl0t28dKWG74SGYAnj7jcwDf4Q==
X-Received: by 2002:a05:600c:45c7:b0:477:19c2:9765 with SMTP id 5b1f17b1804b1-4775cdad684mr64252725e9.4.1762428396298;
        Thu, 06 Nov 2025 03:26:36 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477641b622asm13860925e9.4.2025.11.06.03.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 03:26:35 -0800 (PST)
Message-ID: <a78d7e6a-5ba3-489e-8c14-302883d09769@gmail.com>
Date: Thu, 6 Nov 2025 11:26:34 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] net: io_uring/zcrx: call
 netdev_queue_get_dma_dev() under instance lock
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
References: <20251101022449.1112313-1-dw@davidwei.uk>
 <20251101022449.1112313-3-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251101022449.1112313-3-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/25 02:24, David Wei wrote:
> netdev ops must be called under instance lock or rtnl_lock, but
> io_register_zcrx_ifq() isn't doing this for netdev_queue_get_dma_dev().
> Fix this by taking the instance lock using netdev_get_by_index_lock().
> 
> Extended the instance lock section to include attaching a memory
> provider. Could not move io_zcrx_create_area() outside, since the dmabuf
> codepath IORING_ZCRX_AREA_DMABUF requires ifq->dev.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


