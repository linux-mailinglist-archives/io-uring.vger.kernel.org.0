Return-Path: <io-uring+bounces-5961-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5CE6A14851
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 03:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 319073A97A9
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 02:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B028671747;
	Fri, 17 Jan 2025 02:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ROdTIsTr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAC638DE3;
	Fri, 17 Jan 2025 02:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737081474; cv=none; b=b3fWR/AxYgx7a/Nh8wOp5wsPIlDLTAPCYXrePp6f1JCal9N3ljSNob12DLaQ3WVEZGEBjalKyWJsS6+oDzIc5Og2zEQxpUhfpc9cw501oiMTDwWruUbVfv7TmS6DQOl0YHIKBlAZB6FwHRIi7OKbrxoJ5H/dMp4ojNlXNJleuEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737081474; c=relaxed/simple;
	bh=hcw68fNYyG1DCwRB2lxQzffiVC7LXU7caQ6dSHDepNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KBZ2B78X7dKhuErjKkQ17LksqrbQmjmomzvxlBVkptT2Q8P097qa2Jiz5uN1yN74kjH4OkvmHStOCQDu/zHQp78KGaYNlReIc9Wkz1I4kddrOD/zxRArSF0TWmXKqN3EQtHzQgEqUgQ7eMTSeExIsyXu61sxGdiqhIh7X7DvHPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ROdTIsTr; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ab38a8ad61bso55742966b.3;
        Thu, 16 Jan 2025 18:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737081471; x=1737686271; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TdxH+rVX2v44Nsl5timtDCzBYhVYgdi4rasFbxAjVOs=;
        b=ROdTIsTrIoGVdb7Z8Atr45jjGGZN6OF1daqlENh8gJxmFiWHFanbYCSzDZvquBaTbk
         Q9OFJW038u0fcQZsaCkJvn4ei1kC4UQA3fzDpNxe3sfHDcTxX3YHm0s50H5ZTMJxZA9r
         8xMGKq4E/iq5H15FVN2IimjoWwAkpW+tM17lJU0bUkfJ/Kz4YMpIOs4Q5M0aJOJyVY4A
         JHTlkNzG92GLev4CHgJ5oJIRlweeMgaRlcs3wFv1ziKGFBYdNai9LFtWYk/pQvPdhrdd
         M+JZDBqZ0xzo+FClWGlCfHY4BMvJbUraE/zRLk6RdMClef/e0PI3H7sX6x9RJujCAC/X
         8lbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737081471; x=1737686271;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TdxH+rVX2v44Nsl5timtDCzBYhVYgdi4rasFbxAjVOs=;
        b=lpAvnq+w//ehEoVhlXo9xF6A+gpFd1PqZmRgdzQ7R7onGrmz65SfRbYNMbWl8p8aHc
         4SglbFsSoJ8MrqA9PREjN9kUS0YGnyX03lPws47E+XoGjoRRoUVppWOchAwPWJs/p4E9
         3a3AJDtS3Q2hA58vUiGN540QCyPcyDhXpcSe2EY6RKbwEjBtbGHvT+Bt/bAo1ktosFnt
         4B+XSB+WOEzVQp/lpqFsBhsNMZfazSM9j5Dplr3mPESi/pYrxUWOLWVpZCcBN1wifSi0
         VdpfTj8/07noeRqCpG7iK3E7d56hCthmXuIJola8lCiqpwGMSySzOL3yCUdNnkROE3yD
         pACQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWLadtmPRyhgfh33z1pd/oR9crRHQHn0PpIUTpPtxntdccjgQHMqRY1V/YYzugNprllP/VBHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMMzaLgi2vAONG72X5fAb76BJ7EanQwLi17N0PapiHtX9BnZhj
	XQMGNUcBULuZ8K8W+9LQ099JB4G0svfPCatYrn9PrEz3aUIVomy3
X-Gm-Gg: ASbGnctHlmiESUHqSJ3HxIfWiVmydf+nKtZFw0DrGDorgUp7ToO+7g8+lFnglEKd6mV
	QrAN2Atl/08Mv/Ug41pXnua9uGxFKSUy2r4SY9xi3ItYb/V/9s80AjRLMaLpxXG+EqPOcw9N5ws
	5JZDLc4lHUK/9wsfPql4fJ1BZp9yO/NbmaIWY++zEHTIMeGKBI8/+UdIuaFyov+8/lx8AGKv0ol
	7Z+31jV/o6RUXGnX+jf0ewMr7k1JLSStJ3GA330CjpPcId7Zk6S3/d+9xTdAVwcXyY=
X-Google-Smtp-Source: AGHT+IH1kCsSx7eANFle2Gb/tMxWxvlJraguq/FN0O/YA2aY06NCuT2UnqBzQFVnRwPC++DGaV7x+A==
X-Received: by 2002:a17:907:7207:b0:ab3:8b1:12aa with SMTP id a640c23a62f3a-ab38b0a2216mr93577566b.8.1737081470912;
        Thu, 16 Jan 2025 18:37:50 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384c60746sm89498266b.4.2025.01.16.18.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 18:37:50 -0800 (PST)
Message-ID: <9c8e9ad4-22ab-4727-a345-f8e403c55294@gmail.com>
Date: Fri, 17 Jan 2025 02:38:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v11 17/21] io_uring/zcrx: set pp memory provider
 for an rx queue
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250116231704.2402455-1-dw@davidwei.uk>
 <20250116231704.2402455-18-dw@davidwei.uk>
 <20250116181349.623471eb@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250116181349.623471eb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/25 02:13, Jakub Kicinski wrote:
> On Thu, 16 Jan 2025 15:16:59 -0800 David Wei wrote:
>> +static void io_close_queue(struct io_zcrx_ifq *ifq)
>> +{
>> +	struct net_device *netdev;
>> +	netdevice_tracker netdev_tracker;
>> +	struct pp_memory_provider_params p = {
>> +		.mp_ops = &io_uring_pp_zc_ops,
>> +		.mp_priv = ifq,
>> +	};
>> +
>> +	if (ifq->if_rxq == -1)
>> +		return;
>> +
>> +	spin_lock(&ifq->lock);
>> +	netdev = ifq->netdev;
>> +	netdev_tracker = ifq->netdev_tracker;
>> +	ifq->netdev = NULL;
>> +	spin_unlock(&ifq->lock);
>> +
>> +	if (netdev)
>> +		net_mp_close_rxq(netdev, ifq->if_rxq, &p);
>> +	ifq->if_rxq = -1;
>> +}
> 
> Did you mean to call netdev_put() somewhere here? :S

yeah, it's missed

-- 
Pavel Begunkov


