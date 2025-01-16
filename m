Return-Path: <io-uring+bounces-5911-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB9AAA1315B
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 03:26:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E8B33A4E00
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 02:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA86224A7EE;
	Thu, 16 Jan 2025 02:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JJGxuHHO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D50142056;
	Thu, 16 Jan 2025 02:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736994406; cv=none; b=IbRF/yYb7rk09aJKsCMlD2dMBZ0biKZsrzJnSwswMsjqTuMHioxUfO3rOVxIwzS6zp9vl6Adk+tedBkcxqlDDjGiy3Tn/queBAGEeZ6NsCVdWWV/yhCx5Gzdt0Wt8B9bC9EUHq9b4qc6CQ+omTTYxmeWdkyFd7N2G71cRLIIc5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736994406; c=relaxed/simple;
	bh=2uRFfy6/gSue8l5p1J8yPs8Wkun1XqhnbecKA0YuaCE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hdIshl2MFb6JcNmKBXhHlpgTqer29GVbcKyCKY2oRMs7+JIslPx1GdXPHsY0EbmLKB4xYbc4ITpqCXq6drX94RgZAfvopoP3/LRDSL7y+18a9XFMq/mmZlKJvz6tYRSFhZAJQkdFEJYW8meIKcooCvS9mozSckSDCOBkwOhDtBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JJGxuHHO; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aafc9d75f8bso77123466b.2;
        Wed, 15 Jan 2025 18:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736994403; x=1737599203; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2QNF6TZpkxO9TH6+F+DFmg6fnt7FLeb3Mxcx/Rmi2rA=;
        b=JJGxuHHOf5pfr+5twJBKA71mFb+IWcqiGAXRhBj/4hyhXsZJIAojLS5ZziF5TLIzMU
         lgo+OKsgvV+iPTrOxSosVSY77euAyVoRdjf4iOHMdVC+rb7yGpTluxDZXjWnY9g4gT8Y
         ov22CQjasbQ9wK8drSY/7gbH/WAZESkyIyOxYlRxMNPi6xxrpltuA3NYY1jgpPqaF7kQ
         cVFK4FpxDUtvPIyXRZeh163yQcBlU35f8hGE+OdV5e1Pm6nt1haFJp1efdZuxAy4PGv6
         mqtihgeTb5gg9WQnkJceOWhQlvK35WLc8yHlZgZDSJcCUPh4g1ctlb7/bLyREnPPSJJw
         6YBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736994403; x=1737599203;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2QNF6TZpkxO9TH6+F+DFmg6fnt7FLeb3Mxcx/Rmi2rA=;
        b=p43+G80Q2k+tV58k3Sz/vkazzNWoZVOHWE5fbOENAOvUIOufoDvSeWsxBWq3eN2oD+
         qpUMxGo2K+j+sDkBJrEb+h3e9RVwzlTjW/ksVCYtQZmEkbBIlXyKcmNNsvf7/e5+DdS7
         Tjp/vUXUL2dyZwvkrVFvwtGkHrOxUKedaoykhUCYXVsL88VuDd9n9Pj2FTG6L6tir3vl
         1V8dwBkYyw+NfVuOmZ64nwHp1YAEEaTFeikWVI5rvzV0klRYas6kFmAjQZLKhdDE9uU1
         KhBhrc/IhD+dVmscTb6HZE6mOB6MK0ocDM7ZjNrTXJFVsxnWGAVNR8JJ8nrVtKosiK44
         L86A==
X-Forwarded-Encrypted: i=1; AJvYcCU3AfhZYybAYYbr0KX4EDPhU0+ENEksUUHdkyMI7Bg+5B5+EyyXdzfrux6gCTtzZz+NyeaX4KE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw0GdrxiufFfEs3v7JVP5v2aYtCoBwO+fYZWm/1Z47f5VJMEnx
	UDMABrkxBPqIli1OiuP3nXHLS496HWdbPLE+4vpTS5B4UT2oxM43
X-Gm-Gg: ASbGncvIfRgdGvcD2hGovZf+8vzedCRBCsSQlp99JnHJrJLRqz2Y58J16y9h8K4wVsu
	BZ/LTmRf9SKqdqGAr81b+sUXJ0XYhixqr1rmOA9eIrZVyP3ZJ+1eLkl7ZyaraTAggvUOxB4VVVL
	dSxoqId09PJKfmCQxbNXCKjvr2xOBMm/LlNJtDiHBOyCyLiE7ss4M6bh0qm9Wtuw45a3R/MbfHt
	msvwphSIp9F/LChQWy9Rw3YVPHFROoTxGdgzIKfHCP5MBUn7bw5FqlKCeIecKGqa6E=
X-Google-Smtp-Source: AGHT+IEzZC89ooyAEMJfCo3GlW2y620hQ1Fq9CxpnxfERQiAAHmI6NS63AQlY2IPrMkiUVAOPgww5w==
X-Received: by 2002:a17:907:1b11:b0:aa6:8676:3b3d with SMTP id a640c23a62f3a-ab2ab741451mr2748670766b.29.1736994403440;
        Wed, 15 Jan 2025 18:26:43 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c905e2ebsm852312966b.10.2025.01.15.18.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 18:26:42 -0800 (PST)
Message-ID: <8d449738-e2ab-4571-bbbb-857cf510c0ee@gmail.com>
Date: Thu, 16 Jan 2025 02:27:29 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v10 18/22] io_uring/zcrx: set pp memory provider
 for an rx queue
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250108220644.3528845-1-dw@davidwei.uk>
 <20250108220644.3528845-19-dw@davidwei.uk>
 <20250115171257.04289cc9@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250115171257.04289cc9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/25 01:12, Jakub Kicinski wrote:
> On Wed,  8 Jan 2025 14:06:39 -0800 David Wei wrote:
>> +	ASSERT_RTNL();
>> +
>> +	if (ifq_idx >= dev->num_rx_queues)
> 
> _real_ rx queues.
> 
> We don't allow configuring disabled queues today.

ok

> 
>> +		return -EINVAL;
>> +	ifq_idx = array_index_nospec(ifq_idx, dev->num_rx_queues);
>> +
>> +	rxq = __netif_get_rx_queue(ifq->dev, ifq_idx);
>> +	if (rxq->mp_params.mp_priv)
>> +		return -EEXIST;
>> +
>> +	ifq->if_rxq = ifq_idx;
>> +	rxq->mp_params.mp_ops = &io_uring_pp_zc_ops;
>> +	rxq->mp_params.mp_priv = ifq;
>> +	ret = netdev_rx_queue_restart(ifq->dev, ifq->if_rxq);
>> +	if (ret)
>> +		goto fail;
> 
> Hm. Could you move all this (and the rtnl_lock() in the caller)
> to a helper under net/ ? Or does something io_uring-y here need

fine

> to be protected by rtnl_lock()?

no, io_uring doesn't rely on it

-- 
Pavel Begunkov


