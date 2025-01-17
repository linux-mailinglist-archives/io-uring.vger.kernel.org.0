Return-Path: <io-uring+bounces-5962-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFEA7A14857
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 03:46:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E01D7A47F3
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 02:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAFA41F63EA;
	Fri, 17 Jan 2025 02:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A9ZTEFNv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE291F63E3;
	Fri, 17 Jan 2025 02:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737081997; cv=none; b=SbYDclAXSeSRCPAfCy6MqsTboXIiJ8+/YPdSRG5a7lSYR5XjShsbkVU8z3Io36/KXxiuF8TWvN0r/eqtgyQktQtHnTWs0L0LOVs8IhgvmonxLdEY3j3HeK+WuAJCCArHlf+vScVDk/4kGJ3JMZ8Tn8zZA3f0BRknJ5uK3DWUy3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737081997; c=relaxed/simple;
	bh=4OqeoHECF3icSGbYgcfGLuBMo1TB7q8ZysWEJ61qzn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S4BmELIMUVmJBGNXbg/vBInIi/Tpd/AcGO077gLzuG1q9GFuzPeJAmwfsud1zoCmrQ6iNyDsZYc4XSFBn5mvcWxIBHdHDZQbdt+eSHHuO3lDys/VP9r4Gkq5mKpmmCPyRGJavchZuZbqPUMVKD3lJ5e5PoeaSx83rsJzDWGb308=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A9ZTEFNv; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aa6c0d1833eso316505466b.1;
        Thu, 16 Jan 2025 18:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737081993; x=1737686793; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OJMa2kQhexeKm+WodE5bkNPyqEThGqjUP/nXYc/f/qs=;
        b=A9ZTEFNvaw6XpPOTekglWZMzJIW64ufSo5f2hKSks47SxDdPCGGElYbZQmZUBGEWnF
         RMkCUBBOdSODSksBmPlICU2aUuER2H0zZDi8kglro8lSjBEJCYhH/siskZagc+UpwAqU
         IGd3YK+b/cjBPmS2sGqy8pDF0cRkufveU6ONz/Gy0GUGyhq7688rfO4QU0mfIR6xYDqT
         nlFwqDuTCZ15rPu74ovUzL9X0SNcHr0+xXoudb1XJcF9Ldr6+hD7oAOmwpFmb6OuoBBZ
         Yz5yOdogcN4OIiAi+Wje0NpaKR6agFbjz6/Td2qIMnIoF9NDXHA3Zdgz9KlbsFyYjuos
         Zv1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737081993; x=1737686793;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OJMa2kQhexeKm+WodE5bkNPyqEThGqjUP/nXYc/f/qs=;
        b=fD3m/sT6vjwrOWEyRzJ5ECiK3Ack+XvS2L02xp8u2eDpt7ybKu6UGhTJM2tCwj3MsX
         QZhH6nAuiEYg9qaeZSH9fUTIQ8dvUqV7qB1cWrrFLZM8cMX+JXChv2Lul2jxDdQmsJc1
         OIgRh98whHz+UulMAHobsiyjxJS6Cx3ZIxNA+O3jIKcxOAIv+fd6To6AyYX1cRIVn9j0
         61P/zo2wIIiUSEN71J6InvUHIrgqZyObUXa6eIPoQvsxPY18uOhy8zti2e9+lZG3Mv0P
         42KcEFcDZE3TjOc7S+4zl8/5Uq/GUOgTrXTYfwA8YqyM/lBmQ9oXQB/TJSYzwSbwBJy2
         mn3w==
X-Forwarded-Encrypted: i=1; AJvYcCVvGkoXWxqSdcm8zYoVLLbWLlEQTgliB80jF2qZLDkARRBU7794ErGDAgajOWFzH0PSkgN1vTg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcYHi8cBfScw+dAh/s+y6xTWe8l2K227IMVDLQBNnBuEBWOvjz
	RJrBdbOBYoAGqneJzU/uSh7FpfqnRoZvneyjUkrDjqSw2cwZmnAf
X-Gm-Gg: ASbGncsRaHrR+1k/3THRmhK5RMLT/ouZGneTYWUskUVwt0Zr9DMvMeDI3asuyEaQBDb
	bsKgnFKpdND1eNBEB+QPzB5WRnUyoJ6jEBjwYo8hCOs0ZgI6p4AvIE7jah2cL79750PxNPi3VTu
	KQrcfWJUQk+EDd2GT5ZnXBpqbjnBmkZlJCAFBBBuSOU3jh+RCJkVoqI5OtUYJDzJAVpnMX3lAmv
	cZY2xXbHPLu9pAwFMCesPbDJOuw3uDhraM9nTHQuLMj1Xon+OfciAFVrnUWI6wwRk0=
X-Google-Smtp-Source: AGHT+IF58VVXUbQoAKC4VaF0QSbswPBbLQOlXZxUItHA7xOzKwbyJHue1oERSEsGd0zMl5uT8lJXqA==
X-Received: by 2002:a17:906:f58e:b0:ab2:f816:c5e0 with SMTP id a640c23a62f3a-ab38b1e569cmr95459566b.12.1737081993190;
        Thu, 16 Jan 2025 18:46:33 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384ce6890sm90080266b.70.2025.01.16.18.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 18:46:32 -0800 (PST)
Message-ID: <939728a0-b479-4b60-ad0e-9778e2a41551@gmail.com>
Date: Fri, 17 Jan 2025 02:47:15 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v11 10/21] net: add helpers for setting a memory
 provider on an rx queue
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250116231704.2402455-1-dw@davidwei.uk>
 <20250116231704.2402455-11-dw@davidwei.uk>
 <20250116182558.4c7b66f6@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250116182558.4c7b66f6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/25 02:25, Jakub Kicinski wrote:
> On Thu, 16 Jan 2025 15:16:52 -0800 David Wei wrote:
>> +static void __net_mp_close_rxq(struct net_device *dev, unsigned ifq_idx,
>> +			      struct pp_memory_provider_params *old_p)
>> +{
>> +	struct netdev_rx_queue *rxq;
>> +	int ret;
>> +
>> +	if (WARN_ON_ONCE(ifq_idx >= dev->real_num_rx_queues))
>> +		return;
>> +
>> +	rxq = __netif_get_rx_queue(dev, ifq_idx);
> 
> I think there's a small race between io_uring closing and the netdev
> unregister. We can try to uninstall twice, let's put

They're gated by checking ifq->netdev in io_uring code, which is
cleared by them under a spin. So either io_uring does
__net_mp_close_rxq() and ->uninstall does nothing, or vise versa.

> 	/* Callers holding a netdev ref may get here after we already
> 	 * went thru shutdown via dev_memory_provider_uninstall().
> 	 */
> 	if (dev->reg_state > NETREG_REGISTERED &&
> 	    !rxq->mp_params.mp_ops)
> 		return;
> 
> here, and in dev_memory_provider_uninstall() clear the pointers?
> 
>> +	if (WARN_ON_ONCE(rxq->mp_params.mp_ops != old_p->mp_ops ||
>> +			 rxq->mp_params.mp_priv != old_p->mp_priv))
>> +		return;
>> +
>> +	rxq->mp_params.mp_ops = NULL;
>> +	rxq->mp_params.mp_priv = NULL;
>> +	ret = netdev_rx_queue_restart(dev, ifq_idx);
>> +	if (ret)
>> +		pr_devel("Could not restart queue %u after removing memory provider.\n",
>> +			 ifq_idx);
>> +}

-- 
Pavel Begunkov


