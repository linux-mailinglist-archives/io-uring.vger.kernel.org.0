Return-Path: <io-uring+bounces-5958-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78043A1482D
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 03:17:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B339168C7A
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 02:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53B61DED6D;
	Fri, 17 Jan 2025 02:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="YtdjXu6y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EA01E04B9
	for <io-uring@vger.kernel.org>; Fri, 17 Jan 2025 02:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737080230; cv=none; b=en1qQFYwy5/lUlko7yqDObmXbPRX8fVQt1nI18kOdMO7Oc7vlfJrrq8fUw/JoAjgvCMoUgaKYgZkvpZRbAU2IrzJhn3bTwHzioUq1E3DEtOwZ+csCmbkBhO45ge6vRxr7unph0JOhPsxLER+6DNiPCNsRCWI7N0vRhJ5V1IY7v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737080230; c=relaxed/simple;
	bh=ER6R9v8AJ405d+Lt2Mt514FdtTe+EsxuWv5o+fgncbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gjXshl6Op3zhazbKjP2qYMEkHde5T+DAR3NsCE9h7WdddImDb/J7YLmofXuz8jzCtFGbFOJ3hBBR4IEphg3gbDL2GQfM/urd/7Q0bO/UgFoITlLOHWI2jECwEXdBDW3XN9fyY5docfqaEL0wiaXeL5Qcoes5EHp++cfql1BwJRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=YtdjXu6y; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-216401de828so27999275ad.3
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 18:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737080229; x=1737685029; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WsZWFpIqCOprVA8AcjoSvhBNijx2DjW619VHPTjVUAk=;
        b=YtdjXu6y6Q1y8a7t7ROyGcKfENnLNabvUeeTU6t7VJxb/5jA6/XGADVMNAu0d3IG8w
         L6g+Ssp1tb0MhoI+opXIgH+5xev6Z38DA2gi0jbTk9VBBaV5zWKZn0XA4nIe7Q4nStk8
         e1OplB5H9YWPOS3Z/ZZL76PiREmVfs865y++J38p3AiWTTLjCk34GVbx7ikFgrzng22m
         pBnlNR0v+q4uaqkj9sVrfox0Ta2qiVHjpxQhFnKEOObsnjpVVtdgo9YQUbottWXDMJ8G
         cdhSi/A6ZeC2TztXrTgtEIE+vb4Ml7NbfMCXubkpU7thhyu9QsUs34C517KDLUXo3oiu
         2tHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737080229; x=1737685029;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WsZWFpIqCOprVA8AcjoSvhBNijx2DjW619VHPTjVUAk=;
        b=Hy6OGx69P/RWyAOF+BiedaFbQCCY27PgDitgVMxHve8zt7wilVcLnU1YM3CT9gsFDX
         HbPlzGWTXdCnksoOZ2JcBbaAWNSH6HWIPaya0fNkqhNXoavhdVpY8hniXDSfxGvI/XLt
         uf+aVkQ3EDAQ6vR/tQRskpTivrvDKzuEqVliAsjC561U0QFiIrBnEaCjk8X1TftgRzaw
         mv2PPuzuMe4RNmw/Tfzd8BlvVUYYQRjLcNkDDwyKeE3l+DPBiMBEFttIXtE4v+gjNo1I
         VE4lHgaAx/vxrQK2Rtqy3I5ZOrAfDwiUIYz62Mi2tJx8ewZxguC07L9a2ip9K2GFp5Av
         rYdg==
X-Gm-Message-State: AOJu0Yw/bhxbHVYG5Tp8oSrbUF4MHG1iyxL7y5NAOd4v3VLqDbPUNeSH
	bAwpTkAppXte5Ga8JL021TK4Z6ZaoQztzTNIgoi3jpmrBI+mjOxbpE59mUrzK00=
X-Gm-Gg: ASbGncsMUZ0BDioK5lacNAiX9rk3J/bpAVO+wVpNvCq5wO3hEwYnkwFbjVIIs62F6Vm
	gjlglVoztp0Q5I1CmNbH9O9iVMyyDeq7Ouq7TOisZi/pD5RZVQBpdWQYP93rm09zOtLl8oP3SEu
	rTRjgiTm3g2KRNsO076z7KrJl+OpryaxyUQDxsZKy3ugRMa8fpy74v/NMmauLnUpCI1YNRxO1Nq
	I7wyhHGxdMjQl2tWJbBbWQi0TFDme2+TsNUR9SZCzdxoOMO65qEFAjBQzM3+OTuIG1ro4qI5uKK
	7J2z2dQXMAM50sLZPQ==
X-Google-Smtp-Source: AGHT+IHtiBAE/AhhLy8BO56X9syo+nIgSxnlPcyPJAy0E09R2b5E766BPWXWUAjtbCwARxDq8bM2nA==
X-Received: by 2002:a05:6a20:12d6:b0:1e1:a576:aec with SMTP id adf61e73a8af0-1eb2145dc23mr1477497637.8.1737080228742;
        Thu, 16 Jan 2025 18:17:08 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:cf1:8047:5c7b:abf4? ([2620:10d:c090:500::4:b8ed])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a9bcaa3a8e7sm617057a12.13.2025.01.16.18.17.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 18:17:08 -0800 (PST)
Message-ID: <8872441b-7de4-402e-a982-ceeab14e6e43@davidwei.uk>
Date: Thu, 16 Jan 2025 18:17:06 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v11 10/21] net: add helpers for setting a memory
 provider on an rx queue
Content-Language: en-GB
To: Jakub Kicinski <kuba@kernel.org>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250116231704.2402455-1-dw@davidwei.uk>
 <20250116231704.2402455-11-dw@davidwei.uk>
 <20250116175256.6c1d341c@kernel.org>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20250116175256.6c1d341c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-01-16 17:52, Jakub Kicinski wrote:
> On Thu, 16 Jan 2025 15:16:52 -0800 David Wei wrote:
>> +	ret = netdev_rx_queue_restart(dev, ifq_idx);
>> +	if (ret)
>> +		pr_devel("Could not restart queue %u after removing memory provider.\n",
>> +			 ifq_idx);
> 
> devmem does a WARN_ON() in this case, probably better to keep it
> consistent? In case you need to respin

Yeah I see it, thanks. It looks like I need to respin so I'll fix it up.

