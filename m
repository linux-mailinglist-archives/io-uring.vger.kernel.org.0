Return-Path: <io-uring+bounces-4470-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91B8E9BDAE7
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 02:08:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 428A71F21A14
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 01:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D6B817D378;
	Wed,  6 Nov 2024 01:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AZaHW7WW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700FD17AE1D;
	Wed,  6 Nov 2024 01:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855295; cv=none; b=Iywp2sLVAfHDhWJ+4RjbvAn5fg2P9yu3pMKZWY7Jy2eF9/rDBFF2+RXCfLkTmHRYxjCkGBwVTX3XbzK22LzPVHmAmmGZhCP88XjSn5/TohbbKgaC7vI+Rrd1xIN1Td+/GFwuBumP+s2NhLcZSe6dyiGaIReiGWTO/TRabAzyaHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855295; c=relaxed/simple;
	bh=UPQb2stjWqGu//9tdKSpz4jsQe4UFL2Xq1BD47l8cjA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zo4L+FiypkpsC3LrfXa4PC0ghAVHHo/bGAe5wUW3usF5Je6hn361Udthz/NOnt77HDGT2X8P7erCXkirSLeY1q8quzq5Nlm6dfk30RnWKZSh6bWAt6YUJsfVf2IGiQ8XEAi9YpT8M0P864xediNCdOPtCxiMPWw3KD328m5Umdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AZaHW7WW; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9e8522c10bso57465366b.1;
        Tue, 05 Nov 2024 17:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730855292; x=1731460092; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cCD7OgOV4Waq3xfPYg8bwHGrFRAJmhq4QJxhWdMpz1w=;
        b=AZaHW7WWB9zRe03DKzAXWYb6b8zS1SelXGkseaSM/5xYMxLWoIKRCZUeEC08dNI+pW
         2N2G32Hccj8JZUaYezWcVnH8J3StM8KxazTP2poa+ESjhFF+LYPP+M+CBhukzK7vhbBv
         J2hUXkiO1Ix/xqB0bA2ukZgduSxLDdbco6jtei5m+R9cSbHAiY8R2SDLu3txIqrfBHV+
         pnOk1rM4BmU4VtIxiUYPo5LfUDzHcXT2MX0Su8c1Hd33ISpbpvhIpT7rblw6puohTlGx
         jbHopMyUU0UkldDF5qt5XLWlq34/DTjStn1uvEmq869V1s355I0a2UAGC9amLoyD5diE
         E2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730855292; x=1731460092;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cCD7OgOV4Waq3xfPYg8bwHGrFRAJmhq4QJxhWdMpz1w=;
        b=U6FB9nfpe+4m+ID7gBeX9/x3M8SD29cvt/wfOQwmfUa/XnMjXIRw2T+RoKhJ4dUpmA
         9uhQdteNospF9duUIe60KlPNCEakyoiNJHU9ytVc/8J6thRfNCFx6vMsRiL7rTH4Wtwb
         +ENBfWS9tp+DRyPHs2+bLIvQxP18OQzpLFvNx5EqVPzCPXR8cLg3MfmAR7u/Tsnwrv0b
         95mixnfnik0bK+sMQqen24tHy4evJldO+XZFyq+WEUMAJinC+bwv48VMFVZZKmVsantC
         12bloPeJ+HH5j12mMGWEsEOJJb1em9D1d/JYmUj1QuzmN9fhxkx51mojVqejheMpscQn
         e/lA==
X-Forwarded-Encrypted: i=1; AJvYcCXpkgkJxjgHnq/Wnkf0G97osH8E05c7/bxCGTcsDwXI/VdlLd0sT/geX5Xj7lrdGWGVGKyUBOM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+MswQQMl6bAAWNxERzYb56fvWZXRI7ZtuRtZ6S+TtF/pqR+sH
	pYP5m8O8/L9xmT6OtZ95WOWzFOQhdapCFe7Z7y2Jd6BqAhcqslCS
X-Google-Smtp-Source: AGHT+IHp4lpDCtjBpUUkPfN0WxakfiJsZcT+GwZNsSu9dU1g5RmVmWnAQKScKAhJomplP91LaZfh1w==
X-Received: by 2002:a17:907:97ca:b0:a9a:1ef0:837b with SMTP id a640c23a62f3a-a9ec66049b4mr74308866b.10.1730855291409;
        Tue, 05 Nov 2024 17:08:11 -0800 (PST)
Received: from [192.168.42.189] ([148.252.145.116])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb16d67bfsm200265366b.56.2024.11.05.17.08.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 17:08:10 -0800 (PST)
Message-ID: <99cf79b6-d056-4006-9d40-a1fc02169e82@gmail.com>
Date: Wed, 6 Nov 2024 01:08:12 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/15] net: page_pool: create hooks for custom page
 providers
To: Alexander Lobakin <aleksander.lobakin@intel.com>,
 David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-4-dw@davidwei.uk>
 <6d227ee7-68c9-4d81-8efa-c91bbfede750@intel.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6d227ee7-68c9-4d81-8efa-c91bbfede750@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/24 16:28, Alexander Lobakin wrote:
...
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index a813d30d2135..c21c5b9edc68 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -284,10 +284,11 @@ static int page_pool_init(struct page_pool *pool,
>>   		rxq = __netif_get_rx_queue(pool->slow.netdev,
>>   					   pool->slow.queue_idx);
>>   		pool->mp_priv = rxq->mp_params.mp_priv;
>> +		pool->mp_ops = rxq->mp_params.mp_ops;
>>   	}
>>   
>> -	if (pool->mp_priv) {
>> -		err = mp_dmabuf_devmem_init(pool);
>> +	if (pool->mp_ops) {
>> +		err = pool->mp_ops->init(pool);
> 
> Can't we just switch-case instead of indirect calls?
> IO_URING is bool, it can't be a module, which means its functions will
> be available here when it's enabled. These ops are easy to predict (no
> ops, dmabuf, io_uring), so this really looks like an enum with 3 entries
> + switch-case ("regular" path is out if this switch-case under likely etc).

Because it better frames the provider api and doesn't require
io_uring calls sticking off the net code, i.e. decouples subsystems
better, that's while these calls are not in the hot path (in case of
io_uring it's ammortised). But you're right that it can be turned into
a switch, I just don't think it's better, and that's how it was done
in the original patch.

>>   		if (err) {
>>   			pr_warn("%s() mem-provider init failed %d\n", __func__,
>>   				err);
>> @@ -584,8 +585,8 @@ netmem_ref page_pool_alloc_netmem(struct page_pool *pool, gfp_t gfp)
>>   		return netmem;
> 
> Thanks,
> Olek

-- 
Pavel Begunkov

