Return-Path: <io-uring+bounces-13379-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qPFlAM3YCmrb8gQAu9opvQ
	(envelope-from <io-uring+bounces-13379-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 11:15:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id ABABA5697C7
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 11:15:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 61E31304FBBD
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 09:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110A83E4C6B;
	Mon, 18 May 2026 09:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TJPAkrMm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B733E51E7
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 09:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779095429; cv=none; b=CaQdTAXT8O+2CHXi+q+nbnceAEqHTsTErmnPVRGwdVGgQRQepXHerdynJO27Ifo+E7x+T6nUE2v2tZnz3sd1wQAm1TQV8sd++M24hMhxgTzCYWR46b6N4Cj4ip7HS50pxu6I9YOTxueBzySrauvwLQsS3MfI49feqFA6mvQCl8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779095429; c=relaxed/simple;
	bh=JDf5tfG8fpD06t7iMggta6QbZxhroHbPF6Ww351Aud0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=T3mqj2z4GxwSbU7sikPNq2RymayOwpYNhvSmWLKQftsCh4/AaGtBV49nLChbU31G1iBZrt2poN4BrAeQAoBUNRHGZF5yakuduaa7M/hZv6RYp22a+iwXNjAMUZ3RfbxugwnApz4Ax+EVuA2/LsvoDmCxf59aqtTPl0YkDrpqFJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TJPAkrMm; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-670ab084a39so4354218a12.3
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 02:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779095426; x=1779700226; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NK6QaM0AvluQNq8GVPqTX/wBbD7FgigoEBmBlLT11LA=;
        b=TJPAkrMmxASGuDLSpftlKK9PV2MtAwT6+7Zl98Vv1r8yDlfkDFF/T+xJ88LhrcItVy
         ogY/zfhZ2Xnl5jlrZIb6sM4Mz3XxcicP7OiNGHUStVms8Gwjd5P8+TT6NAfBi73t5hZg
         0RQzv0FBgIFWDCSXCa+GlKsUl4aracaro5yu0WDXS0VvvSedi6zLP0ZXeFy0w52LN7k8
         XipxwpaOI/gdIFepZD0M2KQT9zlG3SAeoBBPX89ZVnTj0/aWa+P3LiXCRjYEu+4pc9c9
         vZ0R9gPdyLql3qAx7QemfDa+q25ncNE+TNIhhkPPbjwsPksLMjMxFooK9aFjxvyUC/I+
         Ombg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779095426; x=1779700226;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NK6QaM0AvluQNq8GVPqTX/wBbD7FgigoEBmBlLT11LA=;
        b=JBTcchVp9u/I+hirNOQimNfZxeEzd/0CEhX2BaGPmYaGD74eOMWIyn/JY1phLf9B3X
         1SIv10NZz6JZY9PtT89ACwZiihI7FqvDzpQP3B9mUM51dI96sw3yS1467iLPXfTFOyCe
         0i3zSHsLMQtw0mRX+MCpzL0JvYQgQ429ZA+SYfoHWzr0Qv9idUU07dBSoCk0MpAjXdW+
         P0Uy97laIoLHtcxc4fZbvYf60RK6jn64nXyvnIw5refjrbchJ+YOyUW27tLsh6B+qbah
         bg4+b8qkHV259FMDW6/nnDlp55hItN24B47AFNYT742a8vw4obYlppiXWqBkZIm7Tul+
         yHBw==
X-Forwarded-Encrypted: i=1; AFNElJ+ms+7GCBVbAPMBc1FU+CWDs7tQDRZt0y4zcby2GjL/njtBP0MtlixJ71O5266Yu7IY6Qfo5DPR2g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwIpzdEFYft7mot7FT5CJgzbQscQ3DhQm4+gB8RU09H+FhFhbfZ
	eGU7s33gddf/0LMXylKHpJN4+T8OHgogELnUpC5xMVOavdzPnzXGoJ1p
X-Gm-Gg: Acq92OGhS2f4N8/3KAaYgcRhZMWhdQVsTv0OwU92I06HqTc+AipsrPI672Cj/WceYAC
	Za/uHBZzUVJzbrEL9Eq6l2heOLTcLfvVHihZPm5kk6llrMu3OjoE/BoLt3WFTUN321o+3YSZ1SG
	h7FxGHKXUMRLy+Cb2wsVcxLRKJ56psO+Jza0gqPbX+3+bQyrKydW/cDjiSTeGlpUlfsFKomiOnN
	OpVa3iX6TwnnY6mHng5mS6e46JNCt52BzlsXlRyx0LuIzmXTNZGvr5jps/YnzLCQF6NH8cAZ/mB
	Z/VyNpt/8wUG4IaoKOittUaiyckNaUxb5MlpUHjeE9gU2S0cluS5RhPLx70kUM/J0YGQ3q3N/kB
	BKQjTx2h5qdugFcIdeEv6TVPPtC4CHU6/QzhuAdcw97EGA4bHh52cjXKp/tOQMyWE2NN1aZgjqO
	jHFK4qPrZU9QAtZF0zPffDdGP1+hsZL56OTtZp8L42MBNuDU5Wx2m+ML7LBvYtst1aVw1W23jCl
	U6iA5Y5tUjuOA0WuL3zlwojLmUZIm2oJ+KUD2/wSkjXaYhvrZCGsSW1J9IeUUcCmAI+WQ==
X-Received: by 2002:a05:6402:4150:b0:67e:153e:51cb with SMTP id 4fb4d7f45d1cf-683bcd9e33amr6611396a12.16.1779095426574;
        Mon, 18 May 2026 02:10:26 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:6e9b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68310b4069dsm4929655a12.1.2026.05.18.02.10.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 02:10:25 -0700 (PDT)
Message-ID: <d14967a9-979d-428e-8190-6a756da1c130@gmail.com>
Date: Mon, 18 May 2026 10:10:23 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v3 03/10] block: move bvec init into __bio_clone
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <43a91f54d61d3329316e40c69ace781b4d35fe0b.1777475843.git.asml.silence@gmail.com>
 <20260513081238.GC5477@lst.de>
Content-Language: en-US
In-Reply-To: <20260513081238.GC5477@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ABABA5697C7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13379-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/13/26 09:12, Christoph Hellwig wrote:
> On Wed, Apr 29, 2026 at 04:25:49PM +0100, Pavel Begunkov wrote:
>> To quote Cristoph: "Historically __bio_clone itself does not clone the

Sorry for late replies

> It's Christoph.

Oops, typo, sorry for that

-- 
Pavel Begunkov


