Return-Path: <io-uring+bounces-4806-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E8119D1DE6
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 03:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA785B20B54
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2126F29406;
	Tue, 19 Nov 2024 02:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="b6yIDOZt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8B8179A7
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 02:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731981727; cv=none; b=rx6mSGRJEONblREhayzszv2o7GhLhLFZr07jVtTeTX6ckYSUA6Qbgg+fI86ROhrENJU2C3y1og0mEt0fJ5lOhuME8trud1bXBPUG3bis5P/Wzw8VyJne7k1MRcYdHcDn8qwTPapfJyMKj694BypD5s343cO6sMQVeSmqJdayfuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731981727; c=relaxed/simple;
	bh=I/5dN8O6i56fb0YGwK2szdKDK2UAP8QlNENuCCnzxv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o5ErUUbR4Sf5DBK4VdGyNCs3BbXF+PRP4teYFsfoi33KZ46Zi6geKsskoFtOTP+7sP5egckcZxACPwgmMxsdt1YzslDDC/dql/Rsjk1Wisb44zvOVtT/YvrYg42CbaEJ1F3GMjAJhfhjgoYA31QHhzH+lV4McvVSnUxpY/1O1OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=b6yIDOZt; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7f8c7ca7f3cso2865076a12.2
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 18:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731981724; x=1732586524; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BvCpgtDczM8fTWqbMLtasOe9kYB99UTUC1x+m0DkqVw=;
        b=b6yIDOZtGQPJtkuzYpqBtWv0RGTnce92wdT3RtF378r9gXMdpBDTP6iVOWCDEvcFGH
         wwikTk4RXDAWH//WxmJea7okn6pUHUfT5+rW/GF8aO6knI/j3hGKF4QfFIkJNFZN0JJt
         gm5NjvGYAg1e092bYlrqtDkWJA0xN0QOv1RkoksVZq+yf1MW5fzhuiOlZeOH/K7Vzhex
         BCnpkA1vM5nGo8XZUKPiSUzOPayIujsNhemklE+m3BpX0c6M02yuz9LRkwvlOeYWpyZx
         vw5UwCB68puBZ8IETt/kymxTO+1YzqJ+3zdjlpg66bGXUObnpTuaVH5lgdflxUHykMbj
         PFsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731981724; x=1732586524;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BvCpgtDczM8fTWqbMLtasOe9kYB99UTUC1x+m0DkqVw=;
        b=UwJozOclpu6vsSgQPiejU0ThWsCDJ1bjSmdB5DV3ZThLenQfmqFsHVlhBR5XBZTc04
         d0wAziPvMqmI4xgEwZ9i6ClhAGaEodZJ8TYanl7ZVn7Fb1ViRuZ6BdbGfFn33NEIyfmy
         wREGFNdp0D4UXyaxzMk05S7rZUC9u3kZ61h1HJG4eo2PI0eh9G5soZ6NtT7v/6mTfn0x
         ZG7xhIhFAC02qA2m16qFFcEkiUsT5DY+UqFRmmDmjgwIm9xPogO78Z1rd99nYkBlfnqi
         cLKzps4f0iv/b9uV5SOq3xwuTJU6hrjf0rZoWDAlK19SrHYshBx9wQdrztk1nK2sFYHj
         QvXw==
X-Gm-Message-State: AOJu0YyiP+hIKlKphyca9mIqC0iF3DiLzcgFzfbNwRa7QGZWJtJuSgtr
	ix9faQTEIbrYLJE1UTEH0LQOvWRK5y443dnEIbGp8ijmKUgd2Prj6mGos5PmsbkxOZu8/iFKQry
	pmVI=
X-Google-Smtp-Source: AGHT+IGy1dB8wlWBopdRVmT8HKf90+Shvl4Qg2WxkHrpIMV1MdiSjDEYM3IG0yHvzVAUPCsfVtqD5w==
X-Received: by 2002:a05:6a21:9993:b0:1d9:261c:5943 with SMTP id adf61e73a8af0-1dc90b233b0mr19917483637.10.1731981723866;
        Mon, 18 Nov 2024 18:02:03 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f8c1dade0esm6571652a12.66.2024.11.18.18.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2024 18:02:02 -0800 (PST)
Message-ID: <4e679f16-7da9-47c7-959c-d4636e5117b2@kernel.dk>
Date: Mon, 18 Nov 2024 19:02:01 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] io_uring: Fold allocation into alloc_cache helper
To: Gabriel Krisman Bertazi <krisman@suse.de>, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org
References: <20241119012224.1698238-1-krisman@suse.de>
 <20241119012224.1698238-2-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241119012224.1698238-2-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/24 6:22 PM, Gabriel Krisman Bertazi wrote:
> diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
> index b7a38a2069cf..6b34e491a30a 100644
> --- a/io_uring/alloc_cache.h
> +++ b/io_uring/alloc_cache.h
> @@ -30,6 +30,13 @@ static inline void *io_alloc_cache_get(struct io_alloc_cache *cache)
>  	return NULL;
>  }
>  
> +static inline void *io_alloc_cache_alloc(struct io_alloc_cache *cache, gfp_t gfp)
> +{
> +	if (!cache->nr_cached)
> +		return kzalloc(cache->elem_size, gfp);
> +	return io_alloc_cache_get(cache);
> +}

I don't think you want to use kzalloc here. The caller will need to
clear what its needs for the cached path anyway, so has no other option
than to clear/set things twice for that case.

-- 
Jens Axboe

