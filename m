Return-Path: <io-uring+bounces-2729-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B26B594F922
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 23:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 778D2280DFB
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 21:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3349170A0F;
	Mon, 12 Aug 2024 21:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eaE40Fft"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECBE1586D3
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 21:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723499449; cv=none; b=Zowf/r7PlD2QL7gqa5xr2Sn2pe7XSJwChaE2HRYr5xaafFybdbgRaX2GtiHb9vUbCttmRxOGzecV9lHT5oSEqBPRjzH2oPgnbSbLTdg2fUZXHDHRqJ7gR7hboH37Ml35wu8rlbk2cXJ55SSEeBDLIcdlButWk47hEigRB5JkR+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723499449; c=relaxed/simple;
	bh=fibczcEv7Wkzyzqtnfzt/yWuilF5gfBUNcQUUPrPjws=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kDNrSZTV93rQSehUzPfMt+zvMdbKcLQYtqfbknQWpAsmOS5mKi45AjwTHpdU9rFVxA5PbejJszMJ7w6KKOYisS+3vVBhkjAEacHc2hnyOYbTyN2tWf+aBDBtvkvgi2PaCQKBLXBYF/lUdoJUZcXzP6d17YaEQJQMh34344IoXWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eaE40Fft; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-75abb359fa5so813243a12.0
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 14:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723499446; x=1724104246; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cHgM33yn4OSloHH8MriTuXPNRzxU9jdB+TRSvK9gwxU=;
        b=eaE40Fftq3Voc0o7U7zHZEwC3JianL4f714G5j574fzxsGdeRFBzQvFyQdYEzW/cHg
         x3N/zrXmicWPijVTVk1GyRXIAGwQZ90is6MvRNPL1XlNAo7DNjJnLyRlb1STqtAakSz5
         tgVGX1KihpvygMuCMKi9qoloC7ybQ2iJJMt2Vheb9Mc1jPnFVXgrE5buaL+vgpkd5hbi
         +WDehUo+H7SW1zjEZlAqvDCFDb4HZS4A6Qkivpj3GOa4ObafN3fx3/WltkkP57LPQFKP
         ISOyOJRbPXPmvVkkaescYxsOCpjuJfKWA10bsHghkQlrjPgpqV4Kn4sYq67ttkGjuDur
         sQxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723499446; x=1724104246;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cHgM33yn4OSloHH8MriTuXPNRzxU9jdB+TRSvK9gwxU=;
        b=Q8T5rEk8ADTs5nbKnmUt62IYdgRLL+Rl5J1Eykm+XhhfRDImrM31Qnkc9IIxeEOcRx
         YEzjufvXOfBguO2zOQbvM3TkPysmtxszPoxR3/WBIU/3GEjx5AJpVZo/aR28KC5gUxvn
         ssLWcA8dIZlAS9sYvcswutN6xFvb5bcUfaRzrihzWCzarFHd6hKEOc+bJ2EevSqBLfY5
         SZKmgy6tQL/EQ0s5hHwq/DRe61SirAHaXJETD17uCDsOs/LQX0Q5EEy+YRkFh1/FYq58
         az3PoagGoihQ97sQ+jRMTgnLrTyOBtSO2wBLI3ToPeQMQFBl8aZ9JZB4gngF6zKtQg4k
         RHnA==
X-Forwarded-Encrypted: i=1; AJvYcCWuovjx+2wkEF+c9Z8baDh8SX03syv2TbMCGQi9JV5vf9VrBSiSbEr6f4m8WLJLLrxaT7dtlNO+DQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8K2H/rw2FR/ENifA6xJWAKmDvF5zGMj9aVatVnbVRUwAxRR94
	k09troMvGHPysrmToXFj3VSQpNpzg713rNNm3NORSpS1lOjEh9b9aqHN9KGf5lPSMixEj1r5VF3
	2
X-Google-Smtp-Source: AGHT+IGErOAD0RdJi2FdaTYvlLl2lMkLGicwGCXXSAeKU4JdJ6WtF9LMjxDPsQtHvCpn55pEVTkNTg==
X-Received: by 2002:a17:902:f2c5:b0:1fc:6d15:478e with SMTP id d9443c01a7336-201cda761d9mr1818465ad.1.1723499446040;
        Mon, 12 Aug 2024 14:50:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1cea90sm1384875ad.281.2024.08.12.14.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 14:50:45 -0700 (PDT)
Message-ID: <008765ed-d941-47f7-bbae-ade14687caa8@kernel.dk>
Date: Mon, 12 Aug 2024 15:50:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/napi: remove duplicate io_napi_entry timeout
 assignation
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
 <05255cc5136254574b884b5e10aae7cf8301662a.camel@trillion01.com>
 <8c1ee6ab-8425-4d13-80f5-ff085d12dc91@kernel.dk>
 <f1397b51-8d41-4f91-aa25-37f771fe4e13@kernel.dk>
 <8887f2d97c1dafb6ceaf9f5c492457f642f532dd.camel@trillion01.com>
 <5730c0c1-73cb-42b5-8af3-afe60529f57d@kernel.dk>
 <64d635e9bf39878d21f9b9a7a5d6e74614ad7c66.camel@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <64d635e9bf39878d21f9b9a7a5d6e74614ad7c66.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/12/24 3:45 PM, Olivier Langlois wrote:
> On Mon, 2024-08-12 at 14:40 -0600, Jens Axboe wrote:
>>
>> @@ -174,9 +174,8 @@ static void io_napi_blocking_busy_loop(struct
>> io_ring_ctx *ctx,
>>  	do {
>>  		is_stale = __io_napi_do_busy_loop(ctx,
>> loop_end_arg);
>>  	} while (!io_napi_busy_loop_should_end(iowq, start_time) &&
>> !loop_end_arg);
>> -	rcu_read_unlock();
>> -
>>  	io_napi_remove_stale(ctx, is_stale);
>> +	rcu_read_unlock();
>>  }
>>
>> @@ -309,9 +309,8 @@ int io_napi_sqpoll_busy_poll(struct io_ring_ctx
>> *ctx)
>>  
>>  	rcu_read_lock();
>>  	is_stale = __io_napi_do_busy_loop(ctx, NULL);
>> -	rcu_read_unlock();
>> -
>>  	io_napi_remove_stale(ctx, is_stale);
>> +	rcu_read_unlock();
>>  	return 1;
>>  }
>>  
>>
> Jens,
> 
> I have big doubts that moving the rcu_read_unlock() call is correct.
> The read-only list access if performed by the busy loops block.
> 
> io_napi_remove_stale() is then modifying the list after having acquired
> the spinlock. IMHO, you should not hold the RCU read lock when you are
> updating the data. I even wonder is this could not be a possible
> livelock cause...

You can certainly nest a spinlock inside the rcu read side section,
that's not an issue. Only thing that matters here is the list
modification is done inside the lock that protects it, the rcu is just
for reader side protection (and to make the reader side cheaper). The
spinlock itself is reader side RCU protection as well, so the change
isn't strictly needed to begin with.

-- 
Jens Axboe


