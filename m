Return-Path: <io-uring+bounces-13192-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qCyxH8eg82ms5QEAu9opvQ
	(envelope-from <io-uring+bounces-13192-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 20:34:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DE34A4A7076
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 20:34:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8BC783033D0E
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 18:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EA3E47CC86;
	Thu, 30 Apr 2026 18:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IKYNxebG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA9447CC87
	for <io-uring@vger.kernel.org>; Thu, 30 Apr 2026 18:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777574038; cv=none; b=aBGS4Xl7dBJth0tA8T0dDm9HC5oMvwV4U+fspjBIDgHqyJzowzyk4BdDwEp8eNZZ68ZPODiqZdSyLneIy31vEh8mQRk/E+uDIbAjcCBJMg1WTBJow4N54BhzmmqKcchkcIMjiGr3IyCluvS32W1iEvE26jB5v01g90w4xuiw5tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777574038; c=relaxed/simple;
	bh=/jhj+TskCXODG9hKampnDGfknOGVmEGixC/boL6nPuc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hW8Dip1bPHFThC6u+/vEB2pOAHxyaHB5Nkv3HFPb61R/fVj62iusIZfiwefNLC76X69HdOfWYGmkUUdgRs5uk3AIOrBOtiC7DW8JNF6tFDVO1EYruD65Q9GmfxvJ/Bb4Ymjdn2RstOA1w2pKHES9LMjcae6L1RDu6Aih8/SJrYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IKYNxebG; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43cfd1f9fd1so824136f8f.3
        for <io-uring@vger.kernel.org>; Thu, 30 Apr 2026 11:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777574035; x=1778178835; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NXLg+nrr3M9M+FT0+QCr6ZD6pc/R7QelMFoBuHbRWoU=;
        b=IKYNxebG99rJmgJdnK+STw62yP2P2cdaJBZG/cigckDb5MYyuKKqqi+dTFU2d9cFZy
         qhJhEBM2t2gYyYxeD5XqrpJttoMPpfwDkqQGaWge8r5FKsdQAdayH4cS/hC2kxIHEYq6
         tGmHwVFWfDn2FZp49tR0EcsXlAigU9Sqe8yADo0AbxH22Zw75c684dLC6hfRE0EgxQSm
         HB1ngLvlfAIWqWDd9zNtUSfCDyoND4JMJTyGyjU3XxM4J+M97HrqUqLRf+QYygwaj1mC
         Ogr8gZjOmeYK1nNMGlcIaHaGVz3S2JshItziqGxqT+GC883q+Byb/VWR9AJNIaDrVgN5
         mk/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777574035; x=1778178835;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NXLg+nrr3M9M+FT0+QCr6ZD6pc/R7QelMFoBuHbRWoU=;
        b=hUgsiPlqTT3nfO4ETcFZBTvlntRZ0BhYPofx86xGg2FFennzzWGEHfa0wB8ZaxVoRU
         BXKt3QNLxmU+qwtvtizErGQa7n4U1MenL/jJZC1YW8lLBOlDGXqSfKMQ/cmQkbmvQP7K
         K9ytBlMe19mr5yMUdsGDz6IzQ56HU7D+hj924Xl4GoSTGEvfjhmG3alNssEoeI2/9+qM
         qKfwrYi8iznwz87P5i4g4jcqItopP5uBI3FR+eEtSkLhHSz9PvT1I7suZiD/ZRzzisix
         bok0VBReIfK+mv0z73wrWOm71zFoQZ0Q17HLqHk/sFNfvLQVL10o3ekSpSJgUM9vB4Wv
         ZOrw==
X-Forwarded-Encrypted: i=1; AFNElJ+SD2mJyAlxfKn4kzJo3JPSdn7RIlqX+XL63Q3InqbUlfpoL6dZ/fC2aI0RaxBlgwj2Tw43B8Okvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxJrQli3O3ZqWshjpsxnMfRe86kAAORK3yQdzn6aFAYxdLr6LBX
	9GWO8w1yHViHOIqixh2ZUKmED+eg5MRPS2qACfgeUtZalgehQpD5Wk92Yv+Do5TF
X-Gm-Gg: AeBDiesTGZFt6UzZZ3lHWGMxOdIh2T72uOAtK3oifEzlfGM1fUvvXAnqvXHjKItvATN
	Q/i9MNBLIN1qIvZqoL13J46QqbONeBxsULr0R9h3TlZL7qk55QtHbBck2b7EZODftMLf7GaMubr
	Z+bmgbDn6azpMwV3Zk5Tb0iDC5pdskZm+BXXQL+Z6qXaKijtab3iqIlYQlBaXpYf9C+Tp9pHG0c
	C2IpPihnVFM7A5Y4Qz0CEEFZaHC0U0z7Nxs+SQ9NEemL9lERZm2nWzCMhraFxcegtB7EfoYF5QN
	yXjAvoceqlrAIPwGOvA+gDAWCb/OM2qAR3u3AxLNTUvsL4jN/vuYlkadY5QbWUPQe9C+/7FOfom
	GCuhV9LA40EvWuZj+IyFPySq1yvHqu7u2rIpHEmGLH0O+s1CP6LNl4JozMytX6LL2gAgqlbiPJI
	io0OeD2A3xsR+LF6aiVwpMJreNDTljGWYMzYpxHT84R8Z7ryLvf4IfNgmUA9/+u1obj+N4kjH6E
	EZDqCu9ef0xVmT73mfaj+oKcsutfR5H2YYvSMC+xjhGBm4f6FEd8ylvstjiiz72eGGzTdsiciXo
	ZQ==
X-Received: by 2002:a05:6000:1a8a:b0:43d:77a8:3baf with SMTP id ffacd0b85a97d-4493fa01beamr7079438f8f.32.1777574035154;
        Thu, 30 Apr 2026 11:33:55 -0700 (PDT)
Received: from [10.109.92.8] (net-2-37-141-89.cust.vodafonedsl.it. [2.37.141.89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b4216eecsm13579672f8f.9.2026.04.30.11.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 11:33:54 -0700 (PDT)
Message-ID: <6cce2f4d-7400-4618-82ce-cbd5004c92a4@gmail.com>
Date: Thu, 30 Apr 2026 19:33:39 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/10] file: add callback for creating long-term dmabuf
 maps
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
Cc: Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi
 <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <ae941457cf6cacb9d4c16b6ec904da9ef7fed97f.1777475843.git.asml.silence@gmail.com>
 <f0dd8f89-835e-4331-b593-4405ec59f4fe@amd.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f0dd8f89-835e-4331-b593-4405ec59f4fe@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DE34A4A7076
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13192-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On 4/30/26 07:03, Christian König wrote:
> On 4/29/26 17:25, Pavel Begunkov wrote:
>> Introduce a new file callback that allows creating long-term dma
>> mapping. All necessary information together with a dmabuf will be passed
>> in the second argument of type struct io_dmabuf_token, which will be
>> defined in following patches.
> 
> Well first of all the naming is probably not the best. Maybe rather call that dma-buf attachment or context or mappping.

"Mapping" or "attachment" would be confusing as maps are created lazily
together with struct io_dmabuf_map. I can name it create_dmabuf_ctx(),
but I decided to use "token" not to collide with dmabuf terminology.
e.g. I wouldn't be surprised to see some dmabuf ctx in the dmabuf
implementation code. Maybe "*io_ctx" would be better.

> Then the patch should probably define the full interface and not just add the callback here and then the structure in a follow up patch.

I strongly prefer splitting patches so that they touch one tree at
a time whenever possible. tbh, I don't see much of a problem it being
not defined as it's just forwarded in first patches, but I can shuffle
it around in the series so that definitions come first.

-- 
Pavel Begunkov


