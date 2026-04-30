Return-Path: <io-uring+bounces-13191-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uOZNNiOd82lJ5QEAu9opvQ
	(envelope-from <io-uring+bounces-13191-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 20:19:15 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E9CD4A6CA6
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 20:19:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 50DB1301E223
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 18:18:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB1E47AF60;
	Thu, 30 Apr 2026 18:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M6ffAm8E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A25A257827
	for <io-uring@vger.kernel.org>; Thu, 30 Apr 2026 18:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573129; cv=none; b=A+ZOO3UzvkMMuuPY9607x2jJK9pHOW5zPtaCpz70hDUrsfH+gWG9/bdgKGpXl/3OgCGTijrg8I2h+pS507oxkE1Yy/9KuhVGdtrWG2dDolPEN9CiL4RmCSCvp23SA4SaTYd0NDkCjszMon3J+6bIkCKmAnzvLMwsQhul1B+Qu0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573129; c=relaxed/simple;
	bh=ML7iINJjRH4Gzjw9niY8gGNr83rzlZiUCq+9OWPM3vM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gyBo+LK8kjX1R6+j7wLBHewUrHLNh+mE5gbNosqL90XnCvYMZ8b5W0+emgyh2l+JWFyKPtHkkYSRuMJov2Vri8SkwbGt6W95wmrI0jmtnEjlyDha7qQ/+zvQM0B3V3FGXUPRaEmeoLU38S1OQ1VzaujcLtbWy6Vw7ttgyQGkb2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M6ffAm8E; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso10933005e9.3
        for <io-uring@vger.kernel.org>; Thu, 30 Apr 2026 11:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777573126; x=1778177926; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+sxVPeWzK/5JcscdkmY85m6FCWps4Q/alwynbpD7Pbo=;
        b=M6ffAm8E/r1bGQBMqCF1p483D6nCifjpf3Dvf/n5RLt7zojYsQeA4OkChPnvHkN1lR
         a/6W5fxkqPhlx1cTIQIvj+kwr/YERqxCSmggYnfZOmvTiFFIQ09v5D/CoEZBzgMO6W7l
         wn/udkFL9WkaeKjnCg73Jk9aWL+NBuCULSuqKPsA8/Rb/vS4o8DysSNwn8cfMAYzW6yd
         X1HitFTmsQJkPmyznFkdxs1S/tUG9VypPy0YaqJtPIN7czKDfbiZxZOTdZsnx619bJMN
         eRGaG4gfwCPfDx1J+URaLMlTdez3lJyDuydWgmUqksjNcPWygKvXXhxdpjRQ1PikurOf
         IqzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777573126; x=1778177926;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+sxVPeWzK/5JcscdkmY85m6FCWps4Q/alwynbpD7Pbo=;
        b=X8H3N7HrBs+P4tQOnDadPQ7Fz6zoNi3cO1C+Jv4mtn3HKmYmr7e2vDC7NV0afDdf9J
         vrHYAF7HSWht1GkQmMIdP3PoevU9QZIMyHqGpdQpT7QxkSvSNepP5rDVZvWVZkUqag6E
         h+RB4XWAsfd4LfkzaB3JilSrSzw0sseSR41Uu7oPZ6YNbfNo/Yz5uG6Uh0TPcMGdiSvn
         XOI29MXTZrkNjMQbtzw+sLDVlVuMmenvDnHffNHMmyQ89L71V3exz8VlTRUGY+TG6zW7
         lV3fyVycWF5HoC006O9UcEaKXAg9YKY9IdKnbPpXcKqWZnvSk2tUNDu3kciOspWhip3m
         fdEg==
X-Forwarded-Encrypted: i=1; AFNElJ/yFyQOeEROI7JRzi0XS8b1OtijMNCCZ6PqpDsQ0Zq5prHiyuZhol2dcZnJ1LNXMrGZIIHGwhljdg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzXiF2Mr6Xq+gAdXyELtapEvc9AHQfCpUMEw/QTFxKWc+FBPGaL
	rFpob/p1CCER3GBnwVTxUl2C5HDSdt18SZ9TczjB13BpcRsPIKg7ARlg
X-Gm-Gg: AeBDiesN4ZvQTLINYizNSkXUSyKL/FEPm23TfOepxSOSW4pJX2JJaCqbB/UsjZLf8VV
	3Dh/SPRvaqTuKeyP/E2INI7qK7OnpoXjZTG9Be8eYKaY8tPMgLiKxLJkbASJr2GbcfTZOMd0eXq
	bY0LH5zD3zUCWoGBSUhVsRGALQPovrMatvZzWEXyfYBG8ilPFCZh95VLafXZ0+ggMEbqrk1tv03
	afmlrX0HVv1ZwTiVOghOrNXj9UolSsLRjXuFCSr5gSju+m0x6F6YpUDWxWMZDsGXlZd7bzJ0AQm
	ngUF9dgzW8f+O9geaX1H2GqcHkyxTC6iryroYfqdPbTg84MQniPlam8ZStMmxCe3PWr/mbzxDXV
	Ze04qH18qD/pDKZ5jp/Rw3FQZrT7jOS8YTrW1wInFOUKqjlylAvcZTwoyDl2zDyJ7wm5Tr8690k
	sNMqV+n+rX7cNEWslUdnfbv+UEiARmoTTa1WKQolf/By6ImTJHfGqUCAS/dbe+soUwlrxI33vn/
	cfn8Tvijdddb0+lDm0dGJ3qsZEeq6LGWN475hr+d5TJCftnQvpCPAaXT66NvEq3lmKio/FtzVju
	tg==
X-Received: by 2002:a05:600c:3495:b0:48a:5339:ef0e with SMTP id 5b1f17b1804b1-48a83d62ffbmr66464485e9.3.1777573126483;
        Thu, 30 Apr 2026 11:18:46 -0700 (PDT)
Received: from [10.109.92.8] (net-2-37-141-89.cust.vodafonedsl.it. [2.37.141.89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8d15fdedsm3944495e9.4.2026.04.30.11.18.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 11:18:45 -0700 (PDT)
Message-ID: <7f091660-2e60-4de5-a3b7-7b8d206fd6ab@gmail.com>
Date: Thu, 30 Apr 2026 19:18:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] nvme-pci: implement dma_token backed requests
To: Maurizio Lombardi <mlombard@arkamax.eu>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Cc: Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi
 <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <5cecb1157ab784f9f303a91449fdf11b03aa6002.1777475843.git.asml.silence@gmail.com>
 <DI5RO76D5IWR.19K0ES58HUIVS@arkamax.eu>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <DI5RO76D5IWR.19K0ES58HUIVS@arkamax.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6E9CD4A6CA6
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
	TAGGED_FROM(0.00)[bounces-13191-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[25];
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

On 4/29/26 17:07, Maurizio Lombardi wrote:
> On Wed Apr 29, 2026 at 5:25 PM CEST, Pavel Begunkov wrote:
>> Enable BIO_DMABUF_MAP backed requests. It creates a prp list for the
>> dmabuf when it's mapped, which is then used to initialise requests.
>>
>> Suggested-by: Keith Busch <kbusch@kernel.org>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
...>> +
>> +static int nvme_create_dmabuf_token(struct request_queue *q,
>> +				 struct io_dmabuf_token *token)
>> +{
>> +	struct nvme_dmabuf_token *data;
>> +	struct dma_buf_attachment *attach;
>> +	struct nvme_ns *ns = q->queuedata;
>> +	struct nvme_dev *dev = to_nvme_dev(ns->ctrl);
>> +	struct dma_buf *dmabuf = token->dmabuf;
>> +
>> +	data = kzalloc(sizeof(data), GFP_KERNEL);
>> +	if (!data)
>> +		return -ENOMEM;
> 
> Shouldn't this be kzalloc(sizeof(*data)...) ?

Good catch, I'll apply it all for next version

-- 
Pavel Begunkov


