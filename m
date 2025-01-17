Return-Path: <io-uring+bounces-5974-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B152A151CC
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 15:28:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA1E718809EF
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 14:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D0820B20;
	Fri, 17 Jan 2025 14:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KHUI1ANd"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3DA78F34
	for <io-uring@vger.kernel.org>; Fri, 17 Jan 2025 14:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737124106; cv=none; b=cpgHfUM80V9DPRImCJepcEkW4rPbDVJLYa9r2f3fHdJ4wSoILPdqyXkheKxBXFVm3UQyxHjKvSQ/buAe6yPOeMCJTUvV2/CGkMA0o6Ri8ypMHRfvUnBHUXpFk/Iz9bf056DC6sbcIhn17v9ie8cXymmH4iGMqbiv2QuhwS0adUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737124106; c=relaxed/simple;
	bh=mDdv8bie31on18kTBHvxq3RFrERNo/c/QthRYx79W8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z0R5V6DDSaLqwUverWda/P4UZhzZD69mGkZ4sN8NU/GwJ5PHYhgoK2YtHoQkH55xaxdq1GEWUA1t5KuuYzrwT6p4NDAK7IQasCW4jUvTdJXuf4zIRW1ZoaOZJWbGpfgiZhLqFwJUUquuB1NGHtAiqVSok5mmivLM6whq/bHWpeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KHUI1ANd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737124103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2oi08zdO3Y89Or/bOx5y047G2RaQw5VgeU693ZnudoM=;
	b=KHUI1ANdNsqzgRK8UxRy5TxCvTbnWcb8YFBXmskp4Jx9Q+lHKI9SmPxKOcjTCrL16qfBJb
	yFZ8cjGor/+mI/TnlluO0pGUZPM1Pk1pwT10dADPU1Zp9iSuiSAn4e++k3diLuyBRikudq
	gryf7ndwlXoYBnMSwJmitI8ymx+/g2o=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-BvTRZkmCOl-V7tvnWLB7EQ-1; Fri, 17 Jan 2025 09:28:21 -0500
X-MC-Unique: BvTRZkmCOl-V7tvnWLB7EQ-1
X-Mimecast-MFC-AGG-ID: BvTRZkmCOl-V7tvnWLB7EQ
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4362f893bfaso11057195e9.1
        for <io-uring@vger.kernel.org>; Fri, 17 Jan 2025 06:28:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737124100; x=1737728900;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2oi08zdO3Y89Or/bOx5y047G2RaQw5VgeU693ZnudoM=;
        b=Ipo2b2dJhkB9gjbaOPO7FrKoukzcDHDdlLpe/ab1I1q5iDeFwb0r55z/2nW/Sa2dha
         7J//SvZGBYUfz6UetMz1ciMqcf3kR3jn+SaBWHThsSK4yDS2Nu42sSugdCjc2LLwBUoa
         MDCOag2CIgy0HsS/0LoED+SJ1szBNnINAvSBrzR3rFjX283VsSB+fCZdgxs0YcM09wc5
         KAFGl/ZD89BoOC38IRqVWNT1Izk/DZbqEPQ51u0GMNHVomLTRcS5rmsc3nUs2SXuaYcG
         KOBLVtvvmDuAKm4HWz6qD5AHtNaTKDRgeaY/gyrIxctm3AFul6K1SaMevzqIS3LtOfsQ
         OWWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuBYxtacqKL3hJ9WKbNwpGkt/48zGSz/Ajkl193uNfHu9zHIP+VWCrFqPGnOWrKYYyUNJNQRYaGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkxQFdWc0OxYv2k1qIuXAUGGyXlmb0Fq/pmQ2XfeLagHxRjCmc
	fYGSZo0T9mSOxoxXYAXKsVcb1IY7pAUx/evA10lkUGgG4/oGyCoXZ+yqiU0O1MszF6j1Vseye4X
	93krSEsKiHRpHDDAccl4nImYCea1hdzRNjgzbUIf9sGoczlO82bqIrctc
X-Gm-Gg: ASbGncu3ssGTobTeFWGbb9nbaz8nkZW97pO3Bbf+nN+0SHDkkJyI6hXX2Ypgfw//Vpl
	a+1RUR9YiRFi14rKtfcOCaK+f6GhGGo8Ax+h7p9pTneK0yuAY+9jgyPXoTpMDJiud8ImVeAWG23
	cft1Gxws1+hheOtlY/3/zcXVyiVeyOVdyHuUICCfLcZMvsIKALNlCjpHNUblHbzeHeSlQQ2G2Qv
	8zXzRj+HjOR9+/PFZd93eNEEK/9SxSQ2n17Bwf8L3cH7FhJif6cETnaU6sNrxvn1+xmehOgBaTn
	6YrDn9xdugU=
X-Received: by 2002:a05:600c:5112:b0:434:a5bc:70fc with SMTP id 5b1f17b1804b1-438913cfa0emr30436245e9.8.1737124099126;
        Fri, 17 Jan 2025 06:28:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFguh3eO0ebu9zvt9jzGDEhcT4DR9FA36zwFEJJvb9LxoI84XCY17GLvDMG2Y5+ZSZ0+MvdsQ==
X-Received: by 2002:a05:600c:5112:b0:434:a5bc:70fc with SMTP id 5b1f17b1804b1-438913cfa0emr30435045e9.8.1737124097250;
        Fri, 17 Jan 2025 06:28:17 -0800 (PST)
Received: from [192.168.88.253] (146-241-15-169.dyn.eolo.it. [146.241.15.169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4388ebdefe0sm50904125e9.15.2025.01.17.06.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 06:28:16 -0800 (PST)
Message-ID: <406fcbd2-55af-4919-abee-7cd80fb449d3@redhat.com>
Date: Fri, 17 Jan 2025 15:28:15 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v11 00/21] io_uring zero copy rx
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250116231704.2402455-1-dw@davidwei.uk>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250116231704.2402455-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/17/25 12:16 AM, David Wei wrote:
> This patchset adds support for zero copy rx into userspace pages using
> io_uring, eliminating a kernel to user copy.
> 
> We configure a page pool that a driver uses to fill a hw rx queue to
> hand out user pages instead of kernel pages. Any data that ends up
> hitting this hw rx queue will thus be dma'd into userspace memory
> directly, without needing to be bounced through kernel memory. 'Reading'
> data out of a socket instead becomes a _notification_ mechanism, where
> the kernel tells userspace where the data is. The overall approach is
> similar to the devmem TCP proposal.
> 
> This relies on hw header/data split, flow steering and RSS to ensure
> packet headers remain in kernel memory and only desired flows hit a hw
> rx queue configured for zero copy. Configuring this is outside of the
> scope of this patchset.
> 
> We share netdev core infra with devmem TCP. The main difference is that
> io_uring is used for the uAPI and the lifetime of all objects are bound
> to an io_uring instance. Data is 'read' using a new io_uring request
> type. When done, data is returned via a new shared refill queue. A zero
> copy page pool refills a hw rx queue from this refill queue directly. Of
> course, the lifetime of these data buffers are managed by io_uring
> rather than the networking stack, with different refcounting rules.
> 
> This patchset is the first step adding basic zero copy support. We will
> extend this iteratively with new features e.g. dynamically allocated
> zero copy areas, THP support, dmabuf support, improved copy fallback,
> general optimisations and more.
> 
> In terms of netdev support, we're first targeting Broadcom bnxt. Patches
> aren't included since Taehee Yoo has already sent a more comprehensive
> patchset adding support in [1]. Google gve should already support this,
> and Mellanox mlx5 support is WIP pending driver changes.
> 
> ===========
> Performance
> ===========
> 
> Note: Comparison with epoll + TCP_ZEROCOPY_RECEIVE isn't done yet.
> 
> Test setup:
> * AMD EPYC 9454
> * Broadcom BCM957508 200G
> * Kernel v6.11 base [2]
> * liburing fork [3]
> * kperf fork [4]
> * 4K MTU
> * Single TCP flow
> 
> With application thread + net rx softirq pinned to _different_ cores:
> 
> +-------------------------------+
> | epoll     | io_uring          |
> |-----------|-------------------|
> | 82.2 Gbps | 116.2 Gbps (+41%) |
> +-------------------------------+
> 
> Pinned to _same_ core:
> 
> +-------------------------------+
> | epoll     | io_uring          |
> |-----------|-------------------|
> | 62.6 Gbps | 80.9 Gbps (+29%)  |
> +-------------------------------+
> 
> =====
> Links
> =====
> 
> Broadcom bnxt support:
> [1]: https://lore.kernel.org/netdev/20241003160620.1521626-8-ap420073@gmail.com/
> 
> Linux kernel branch:
> [2]: https://github.com/spikeh/linux.git zcrx/v9
> 
> liburing for testing:
> [3]: https://github.com/isilence/liburing.git zcrx/next
> 
> kperf for testing:
> [4]: https://git.kernel.dk/kperf.git

We are getting very close to the merge window. In order to get this
series merged before such deadline the point raised by Jakub on this
version must me resolved, the next iteration should land to the ML
before the end of the current working day and the series must apply
cleanly to net-next, so that it can be processed by our CI.

Thanks,

Paolo


