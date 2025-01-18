Return-Path: <io-uring+bounces-5995-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C410BA15B2D
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 04:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23C781887093
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 03:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A30C200A3;
	Sat, 18 Jan 2025 03:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EeMLVfzz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5887038DE9;
	Sat, 18 Jan 2025 03:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737169738; cv=none; b=lELgNOxJyUnfsgbRh4mSp3Z4PZtOtAbvKMTdQ0x+tZvH8yNP9bbJIX8Shx7pmeXbipKl/bud41CqnH0XpghxQ1wL3SxS4GqW4bZLBi6kY8YMwRujrtSnMcclu9kwVqTyg2+Bxs8PQmeUf/NhcPbgG703qURq9ZxNx9VvapRHpyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737169738; c=relaxed/simple;
	bh=9+ch1ksxRpfJkBpBv820NiOip4ovel/VaBirkvD+mxA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cmE7kyYkAxittAmzA+zNBY3lOimfI+E8oflknYPZr/enfyMTSjm25PsyzQp0ZQDwQaNKe3oe3zhNo301RjkVLOwciwgiwnLuer1olUcKKNI7hQeliQFY4Rd7/Lm8uTRqlCH0vGOf0lfBtfu4Qy7u44wAKUqytmyuopalUjqT2J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EeMLVfzz; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-437a92d7b96so26066675e9.2;
        Fri, 17 Jan 2025 19:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737169734; x=1737774534; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CkpmY/6VWrL6GD/2i1ThcVerDeYISUtxVLfE0BZP4Eg=;
        b=EeMLVfzzMHgPzeUbDbLl6c1gL8hzp2BI5rDqj6X0hhGOi68JbYbSJGagCUYlO7cIsA
         CIFQluFh/sGgI6VGHDLI7ZKkt3gwq1CjXUCGu7NPvsPx5f46XlOzVUwys5S1+xOszMF8
         iSqa12PXt5pKZPKvhIsIC2IhAZB0PMN+vamj2bafdOBxOnCFzDV8lbsENgy3VGCFenHB
         rmYwV+SlMdjIGED9XYboFZJEz8yQXYSQ40Q7s4cupIoZ4Weh+3hi9MOO+d+nM0HaFNbl
         hxkBxCixe6B3HxRgiBOrrfPofi3aMDf/ozgFoL+97p9dpz8ynw5jv807EQ2fP2YiTGBH
         ySeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737169734; x=1737774534;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CkpmY/6VWrL6GD/2i1ThcVerDeYISUtxVLfE0BZP4Eg=;
        b=mGvcSxOaepbNRHP5dQ80yY9tE5seOdB+6LnX5sCHAs62N21RXYadxZo1y+PnGZ45Pd
         3C6XzqwTzFHUzb0QPEld6mt9l0CqVOFQF/E75Gcoo9Bgj467fbE7XzWvygkva2vA0ZqI
         RiXkHzY19ZP2Aqj3e+TvWJGBtyHttYodlKAAcM+kQRJOtna1+4qmUsTCZRcth+zeSzoI
         +pai+0Kle7mczvBaa5t8Chf3xPU9iJ3M0Ax1U7PL1pWPJcL5xnDfDavoVpJJLwE3HkbL
         2OEmGVy5BbXa0YtVBe6+L9w8pRd6hKdZPufQrfx8N+9+P/NqvwK2lMQyFa9rRc+mlGsr
         ZhRA==
X-Forwarded-Encrypted: i=1; AJvYcCUa1hgA9f0Ac0egGCTmXfe4PKkr4SjkMhohq37XOiHG2xoZN0q/JpCKQIcXigjyM++GuCsd0z2e@vger.kernel.org, AJvYcCWohOS+AM02mNJIIYV4c3mirYQsGA+LZqOs2+5Uy44IcqVYV0kDCW3caqu8U2JewEOiVp3ZcfmVRA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxyGj7lGogd2TTpvbifFnFWwTbyPBOIONi6HXIc/gYAvEcEfdfW
	0e7PBAjs1pH5o/6KWqOJ8LxqEpRVUBtFi3tw9xyOe/Zckg98oXeB
X-Gm-Gg: ASbGncv1KKNnIoF6pdA0qX9bnIWxRAN855/+ykX5noNbkIPVJ2YWWuOc6OodYtRRqpu
	kbLIOIiHOCW7Mg7/iAAYiaFgvEhTzlIsj9778DmhEOnuAbfpWw3i3xO+gF27AUFpX8VL078yl0r
	u+t1q2KOpGd+U8wo0ozwEmbBBYi7P5IxxerHIV4XvqlunwnxF03pE1Gg6u19L1nDtJ9xlN4dD7m
	adZzMORk3Wkg0Ldx6TBeinjeN/N7c32O+XK6hboVNIuVkG4Lq7me3BZIY9Nal/K1AaKwUvZDfXm
	yQ==
X-Google-Smtp-Source: AGHT+IFH6lCoY1yVOGWUbGl/86uaF2JN2HPDbsKCNOSKUKWPibyg4oF4bMePO7vbbRk5Uui/EFG1Wg==
X-Received: by 2002:a05:600c:1f14:b0:434:f623:a004 with SMTP id 5b1f17b1804b1-438913e391fmr54798475e9.16.1737169734328;
        Fri, 17 Jan 2025 19:08:54 -0800 (PST)
Received: from [192.168.8.100] ([85.255.237.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c74c4f85sm114911425e9.18.2025.01.17.19.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 19:08:53 -0800 (PST)
Message-ID: <573cb5d3-ebef-40c9-9f21-b75fcbe9514a@gmail.com>
Date: Sat, 18 Jan 2025 03:09:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v11 10/21] net: add helpers for setting a memory
 provider on an rx queue
To: Jakub Kicinski <kuba@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250116231704.2402455-1-dw@davidwei.uk>
 <20250116231704.2402455-11-dw@davidwei.uk>
 <20250116182558.4c7b66f6@kernel.org>
 <939728a0-b479-4b60-ad0e-9778e2a41551@gmail.com>
 <20250117141136.6b9a0cf2@kernel.org>
 <0d851165-dfe3-491a-be8b-77d01ee00de4@gmail.com>
 <20250117180856.42514e9b@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250117180856.42514e9b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/18/25 02:08, Jakub Kicinski wrote:
> On Fri, 17 Jan 2025 23:20:58 +0000 Pavel Begunkov wrote:
>>> True, so not twice, but the race is there. It's not correct to call
>>> ops of a device which has already been unregistered.
>>
>> Ok, from what you're saying it's regardless of the netdev still
>> having refs lingering. In this case it was better a version ago
>> where io_uring was just taking the rtnl lock, which protects
>> against concurrent unregistration while io_uring is checking
>> netdev.
> 
> Yes, v9 didn't have this race, it just didn't release the netdev ref
> correctly. Plus we plan to lift the rtnl_lock requirement on this API
> in 6.14, so the locking details best live under net/
> 
> The change I suggested to earlier should be fine.
> 
>   - If uninstall path wins it will clear and put the netdev under the
>     spin lock and the close path will do nothing.
> 
>   - If the close path grabs the netdev pointer the uninstall path will
>     do nothing in io_uring, just clear the pointers in net/ side. Then
>     the close path will grab the lock in net_mp_open_rxq() see the netdev
>     as unregistered, return early, put the ref.
> 
> Did I miss something?

That should work, but it's also a house of cards comparing to the
alternative, that netdev trickery with bunch of sync around is a
direct product of that. It absolutely will fail at some point.

I'll put it in, I don't care anymore.

-- 
Pavel Begunkov


