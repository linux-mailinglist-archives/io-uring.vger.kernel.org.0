Return-Path: <io-uring+bounces-4720-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EDC09CF0BD
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 16:54:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AF8628CED8
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 15:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E67A1BC9F4;
	Fri, 15 Nov 2024 15:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XhlYGJpW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C52C16F282
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 15:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731686036; cv=none; b=ZyfnwctNwWNLrz5h5G3CUKZJSwHSzpx/VEQRCD8wV4WXa/evROgnlvowgV585pKRhesg+Nrtiz48SWLayY3Eu+M0PBfm6fFiX4MOGjooGjWmnG8aHqAlrFQnq8bqDLyJS5mMEc6AUeS5ULuift4WnAQ8i7tT9jIBTGWfuonRY9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731686036; c=relaxed/simple;
	bh=F0BwOFY37ZuVvqmVP4Gqvm/6PgGe0rl4PyIkPPOOjh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=neWlwEIejAynVvK2JwE3xuyGHDjylx4R/yvmhXO09NdLYd+u05JMPutHNZBRR2qywV+zzPC3owNwVNXTtf5ky1cBK3dgSsu6QUkJm1J6q2Yv4cD52qtsej6Xs5gQdc7Mbeb6ZhXOWd/uMrEIXEwacd5eey83TtiIayLA7pSGS8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XhlYGJpW; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3821c5f6eb1so1336256f8f.3
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 07:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731686033; x=1732290833; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/7ZAyRIRoptrIRj76X39POdtrGGWt+FLdcDLY+8+OeM=;
        b=XhlYGJpWgnXKwYM4QC+yjZo0LbBzF1ydMDPaiQoI87LvxtsuENT2F6pJsDkaOnvNbt
         uoCK0WywsG4yJaVFzM5aA7H/a5WXJGs2IJce2J6JkF4YMu1fK+i+P60vtopSHEQi0zOv
         f9fUbhYaIeV+OdcJ13fwQwJZyN2htJc8m60onKj4mmBdn44eKrzgP6lHMt0tBse9UC/D
         0rhSflBT4hK9dNaoxWHewOZdQwskPAHmBNAN+nOV7C8SL9DPcNItXFZVZaXlETFqhjBp
         ggLUmjR76FTyMKqJwaYLLYzdW/pExKIO240Yjvs/a1A46E9ckZy56ub7NCO5xUJ9gjTC
         5idg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731686033; x=1732290833;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/7ZAyRIRoptrIRj76X39POdtrGGWt+FLdcDLY+8+OeM=;
        b=n1sG8oePtBRHJf1wsQm0AgeabCs0ofDccAJgL+s8aWh3YjyDubLyQaNIGWTXYXTQty
         p7BZ8kWT/C6YSVIIgq7cUQB+K65CoVaqm4L3WG5Jr8VEQeUJBC14O2rjt038p7dq26/Q
         VCKTGTvbaYTMCQ505ntexXJzzaMayeYLZT0cbFpK1HTuH11akjzPhoAsMi1Du6yJaO/g
         I0xUGdv1GtJS4tlW/o5cuTeWkYq4kGNJMclkPwEV017SLAfHOK40UHznehck0TxFOspm
         thbTszTLZwoQ8zerMquLd+5nysIblHnqPSCOOylBeAvDuFQKoC4kuv/T6foyNZJJD4fB
         u+yA==
X-Forwarded-Encrypted: i=1; AJvYcCWjVIEA+G/yt6vGSAiUfxRWEJRahs12FbruqyKPFayduHP74NoDBFZap0+QvEMYZO7uWUuxy/E3RQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQj3HjGcedmZUn3pjoomgcq7ICGUG7eLPqHwR1U0/8STtDbtNz
	wp/lVy7lNeJy4fcnQ2MAdx01Gd9IiMf3qdXhctPprZNP+bgc2RtFquR/6Q==
X-Google-Smtp-Source: AGHT+IFoiKrZkOLezMNzOHcUUm4EkxVD/IkDgbKGY2MkSe8I8myqjVCp9hU7AWYAB0HN6h9o1U3Ybw==
X-Received: by 2002:a05:6000:1448:b0:37d:3e6d:3c2f with SMTP id ffacd0b85a97d-38225a8baeemr2592620f8f.47.1731686032460;
        Fri, 15 Nov 2024 07:53:52 -0800 (PST)
Received: from [192.168.42.191] ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382207fd632sm3924416f8f.44.2024.11.15.07.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 07:53:52 -0800 (PST)
Message-ID: <4836a0b6-b978-4c1f-bce4-b606e890c5c0@gmail.com>
Date: Fri, 15 Nov 2024 15:54:40 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] io_uring: introduce memory regions
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1731556844.git.asml.silence@gmail.com>
 <cd8e0927651ecdb99776503e50aa3554573b9a61.1731556844.git.asml.silence@gmail.com>
 <073858ab-ad4c-4f57-ae3c-b9b30c59fc6e@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <073858ab-ad4c-4f57-ae3c-b9b30c59fc6e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/24 14:44, Jens Axboe wrote:
> On 11/13/24 9:14 PM, Pavel Begunkov wrote:
>> +void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
>> +{
>> +	if (mr->pages)
>> +		unpin_user_pages(mr->pages, mr->nr_pages);
>> +	if (mr->vmap_ptr)
>> +		vunmap(mr->vmap_ptr);
>> +	if (mr->nr_pages && ctx->user)
>> +		__io_unaccount_mem(ctx->user, mr->nr_pages);
>> +
>> +	memset(mr, 0, sizeof(*mr));
>> +}
> 
> This is missing a kvfree(mr->pages);

Indeed, I'll fix it.

FWIW, this is v1 instead of v2 (which also has the same problem).

-- 
Pavel Begunkov

