Return-Path: <io-uring+bounces-12096-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wCrEANHBiWmXBwUAu9opvQ
	(envelope-from <io-uring+bounces-12096-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 12:15:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DFCD10E927
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 12:15:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0BDAC3002B71
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 11:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BBC836EA81;
	Mon,  9 Feb 2026 11:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LW7YteST"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEFD36E498
	for <io-uring@vger.kernel.org>; Mon,  9 Feb 2026 11:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770635725; cv=none; b=Pp6eTdlSwgLHZ8uJoO9cdA3UrvibvrpcNt2nCq1D70wfnax6OXhVGLzzdMnxWv57Im7mFyseLxM3kuXBZFt8KNKm3tD2ix08C3J8lhGYLBsd6D/TvwEp7aSZyJRA8Vz4ZVGD8sqfDxzaOavy1uB6HHLqTs7PWwm/UfHwbpvLX6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770635725; c=relaxed/simple;
	bh=eFyLq2eShSuSoRftAfNzIMk7e5J3AUWEPeBcMfu5m68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sn/r6AU9IDc2TnfSSgky19txJkGR7282jSKst5mJbCpFSP3/USPPMrQw3r5uRpUbbAlLx0a/RqhgEfPhArodCU441eefniD1KtPcF5TKHyOdENIYuE2yfLsZq44Ouv4dvXXxq1SDOaYcgvVuyqYrUZVcQYtyXVuEq72z/nyROFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LW7YteST; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-436e87589e8so1095646f8f.3
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 03:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770635723; x=1771240523; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3wbG3Hwlnnt7XslslOQ5Ajzf6jd6ChHMQtwpqlWp/yk=;
        b=LW7YteSTTFZNudE7wYSq4uzKRotya6t+c/tpDKe0aQubmcjnbywKTV4ZD6djoh5Awl
         +SDAinaG2Iuz4DJ6Ti6gJ9ahiLrQRG8o9beCRW+gM9MGuOBgqiRdAWzfRpiGUZWjqv/R
         Ep/aeauG4Ax784yVdeh0Xel1S6PlwumZtaJSg7dugdtPl5Sv8jvMC9x7FJJI0ie4xtaY
         XpEM+n6N8ShL7PWD+z9YjGDjhya6P/SfF4rspdbi8U74I/Fm/cAd9fiuiQTlR7VRAt6F
         evyzvU92lGCuyG1O6/fqh86AriJYe+oeZvHl1RXfS8ZhGUmF6lbN/1yCaI2ces8rtFFE
         JFSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770635723; x=1771240523;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3wbG3Hwlnnt7XslslOQ5Ajzf6jd6ChHMQtwpqlWp/yk=;
        b=mRuyGPYDTQ6vYuh4jaxCCNxmiXuZT2/lGbG5cnGvoUmr7dqWNbhlQsWrdxfkGkeD55
         CPit8Cd8Wpm8ta6TEFOUs5FcG60HxHO5UBBKJpA/W/vGIflj8XuKAj6uMjnblYQwhr1y
         wMiKDJ5e4aW4oYLSyinXqCRnExSx3LlEDcj9j7nXUvZXEwSt1R9zf6mi24zPl8XTlIk6
         yiftIc4VTvNmad1VvyYdeApt0yef9oelfCVDt/2eYCiIoFiOl8PHlnrA6nYrSTJ1EaDL
         vrqyddlO6ipirZXn6Z+oGXX+g4Uvh642xabvBU1NIVJ0FDJH+BwldFNnt2mmlNoqIEbp
         IIYQ==
X-Forwarded-Encrypted: i=1; AJvYcCV77Pn629XHCq3bnnsHrZ7cuhjqpKSKRIOcB3SqMBaRsWE8/iM7SP0LiyD2dZ9obfdC5farte98Ag==@vger.kernel.org
X-Gm-Message-State: AOJu0YzgRCxgLjW38b97k/YDIEsILKK3v3VxV7u79Em27VhJqluokgNG
	lHCoc3G7cHCW6Kwlg4ZECx5I3yqtNXBiLlzhlXdrBpKZ0hXYGC5hkeqh
X-Gm-Gg: AZuq6aKD4FjUpxv/Er1wKRf+muxzv++2vR9dJgl2YNLqvX4VH1khUDqmSx1QI/oMAsB
	w573REbJiRs0jBhYuU4/mHjROkFsKkoxRGoTpJb+6VH67ys2AvX13jNCZbKCm5eWSHmkEW/Oafx
	0kS5po5sHhchrBSljXmH+OpjnsefJjsy5kT8a1v1wuvTX326lyoyGpdFiGjFJNvvvsz8T+QyAMJ
	Sa5+eRPl4nhgF4lIUaskDIhBB43P2QKJyAFGTg0cjIpX1QgrQKYePUBKDsdFCz3dBJ2Sqn+kqRF
	3ImH1ze0l5Gf/JUPkjIqJ7dhjM+9qIt52j/gVqTkKjbvQ09b5yAOPsIEjNDV+glBJRwpQ98Vjib
	7OccKRHiErcjkR7vK0xpsOpjgtNTD9kM7AhaO1XYdt1enmm6Fiq4ckOKs2LQt+6rvxEO3P9WDlt
	19lOsmpHWnklRw1H/SO49ghNS/MSIK2/zomUqHQ2I112yD/GJzonf45Y8HWuU49Z/nfN9anRCkN
	jtXeKqBDcVacZbNgKusLD2mddqnI5w//3F284QTPXqSB/I=
X-Received: by 2002:a05:6000:2209:b0:435:9241:37b4 with SMTP id ffacd0b85a97d-4362938ffe3mr19185555f8f.53.1770635723028;
        Mon, 09 Feb 2026 03:15:23 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9b67])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4376806626fsm12638100f8f.37.2026.02.09.03.15.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 03:15:22 -0800 (PST)
Message-ID: <76299bc2-4871-4571-bef6-9886ee0d2c5f@gmail.com>
Date: Mon, 9 Feb 2026 11:15:22 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
To: Nitesh Shetty <nj.shetty@samsung.com>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
 <CGME20260204153051epcas5p1c2efd01ef32883680fed2541f9fca6c2@epcas5p1.samsung.com>
 <20260204152634.gyybb2axszwpewrk@green245.gost>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260204152634.gyybb2axszwpewrk@green245.gost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12096-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4DFCD10E927
X-Rspamd-Action: no action

On 2/4/26 15:26, Nitesh Shetty wrote:
> On 03/02/26 02:29PM, Pavel Begunkov wrote:
>> Good day everyone,
>>
>> dma-buf is a powerful abstraction for managing buffers and DMA mappings,
>> and there is growing interest in extending it to the read/write path to
>> enable device-to-device transfers without bouncing data through system
>> memory. I was encouraged to submit it to LSF/MM/BPF as that might be
>> useful to mull over details and what capabilities and features people
>> may need.
>>
>> The proposal consists of two parts. The first is a small in-kernel
>> framework that allows a dma-buf to be registered against a given file
>> and returns an object representing a DMA mapping. The actual mapping
>> creation is delegated to the target subsystem (e.g. NVMe). This
>> abstraction centralises request accounting, mapping management, dynamic
>> recreation, etc. The resulting mapping object is passed through the I/O
>> stack via a new iov_iter type.
>>
>> As for the user API, a dma-buf is installed as an io_uring registered
>> buffer for a specific file. Once registered, the buffer can be used by
>> read / write io_uring requests as normal. io_uring will enforce that the
>> buffer is only used with "compatible files", which is for now restricted
>> to the target registration file, but will be expanded in the future.
>> Notably, io_uring is a consumer of the framework rather than a
>> dependency, and the infrastructure can be reused.
>>
> We have been following the series, its interesting from couple of angles,
> - IOPS wise we see a major improvement especially for IOMMU
> - Series provides a way to do p2pdma to accelerator memory
> 
> Here are few topics which I am looking into specifically,
> - Right now the series uses a PRP list. We need a good way to keep the
>    sg_table info around and decide on‑the‑fly whether to expose the buffer
>    as a PRP list or an SG list, depending on the I/O size.
> - Possibility of futher optimization for new type of iov iter to reduce
>    per IO cost

There is a bunch of improvements that we can have on the NVMe driver
side, just take a look what Keith was doing in his series ([2] in the
first email in the thread), that looked very exciting (I dropped it for
simplicity). I was planning to take a closer look at optimising the driver
part after, but if someone wants to take it off my hands, it'll definitely
be welcome!

-- 
Pavel Begunkov


