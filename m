Return-Path: <io-uring+bounces-10139-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2F6BFDC6A
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 20:10:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03EB73A5A9B
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 18:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D5C2EAB8E;
	Wed, 22 Oct 2025 18:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iFi7bOvR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C07D2C3250
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156615; cv=none; b=Ov8lCwm+/XZLjRucGqCbwxDHINDSoqrkCV/S98RPdJdkPsOyV4nHpzXOGQGIvJWHrSJ+94hFkFakQoQvA7xGd+rTyp0lfMJeHpyrviEpTOI6cEn0DSrqSIBZ9MCVKpnGd7z2kGmUJJ6Swmz8/tCI/UsJ3/HilRwCd0sQyVxZC5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156615; c=relaxed/simple;
	bh=NuOgVXwJ9AT0gcuaIicWv9yZkcbHZs5ZCogIJz+trco=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UYAPgGBAbqE9jPdceCMOKoLmvQqHfSdxkI4liQHaJtYTQCiNgRiuKokCS+N8yZGq7DatXI+e5CiPL8G7FjDYxKIySzImo8YuN2vA8i8bnoaSckomMbnmuc7cCQLjFy+0zAyweS0WKgRfdD+tKdGbXY1i3jnRThdkZXq2Texsvqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iFi7bOvR; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-430da09aa87so17908035ab.2
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 11:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761156612; x=1761761412; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ptCD/yK0XuBnsdJi3XiLCc7SvsQSZzxWarLurh61vFY=;
        b=iFi7bOvRNkdeMuLwQCtRmvEXrPIMC9ITL8QEeDVk6DodlL6NZ7eN9HFFYtYdszxpv3
         s1T+vjn1PykmD/kNfN20qDG6MS5INGdYWg44ugACDVu0OtZ2oSEg7A/xoemvLLZVnpQK
         s8vid2190YVKKukb8mZmD8RkV6QCSCkAi83HqArrDEWSGNoV/xy2YS2UThANa4i2Aa4F
         gT4V77iZJOcR1iToHoCYjIadqagKeyq5jOR2ovFVGqfLTxAvc6nGvS/vyUExQXgMNhLp
         rX8clOrKoEwCwteaISRR1vJnAeabXX3a8JvoZgYg1iOmnqWWIjFsg9ngd9EKxQB+MYZy
         s79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761156612; x=1761761412;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ptCD/yK0XuBnsdJi3XiLCc7SvsQSZzxWarLurh61vFY=;
        b=S9GQEClqzDC/JQfPvlPVv3UthIHcAnqnkFxfVQjjww1ns+4cHZzeUlzTfHYtIcxbAT
         QhgiFdzplnKuRWky0cf89nfgE6OGLi0JfEPW38CldZdd7hFUBPJs2ZDHb+jm9tn21ktQ
         0NDYRaIlstoSn/rmv8hjFF+OoDtzUtIQKVtGpmLhC5lszWOSJNSS8jPAzSu6qtQnbjbl
         kLsVcRISF1BtasdRuzge+L1EUE1b03DE6VynwCExE/9GPQqQXerc+obrNXpOQSMD25FL
         lSKHq6fNBBOl74BenBrWGw9iF6xbm71RlhNmZHjnge057TkAeK2u2UaV3eNh43qM6a2m
         /w8g==
X-Forwarded-Encrypted: i=1; AJvYcCV8y3KwT8TmDyUb5ejP87NmJkJ0/ncx5nRXe5ErZffRTs9adCifrA7vFYRHftf1a9Qhs4pES0PRSw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwV+CMJYbfOse3ZibSoIXWbakDksbQ5OKkKnJw1sX+WjK73Q/H2
	/nbb1ZneUFMWpb3pEYVN3EsvlorFinu1KLmRqKWjOLkCvEJGjmGETmeW/CyYYk0nM4F8kfu3bt+
	UiW9dV6g=
X-Gm-Gg: ASbGnctFXxVaGdbWDUaA7q88ASVZSDX7gujvzPNb4Nq82dn3JcY4hG89MJhSfeU38oR
	H7m+lL4gGQleCsKIxRE9e5Ban+LPvS669qHmjCyj2c2BevfjW1SnnXt+Rvmcii451n22447FudO
	doqR1t6uQglH7ufun/BKoa++xfLMBT9bAQ15p9IzOI0l3DtoYOUsIgg20p+AiE0USGXvdqVhTgF
	EglmiCs80127ut00Ti6p5idPpqWBuztWmp4OoGkfTDz/9aJJT8PWe5St5Uu5bxVzT7s+Iy3sdkO
	92cAVuaweMn2wlOOh2+W34m+NygdT8teIbacAc00VSnJBNJIvFy3uoFi3bTL9GKLQxAqiYbr4Ju
	EnLT6B53Q9tzc52nPK6dL20BXoiUeDF1nP/+NBf5MWkHmRs7Y8PzN0sHNwwl8Yh8huPxiD8RhJn
	EwJVTiFcU=
X-Google-Smtp-Source: AGHT+IGM6nm2CIZPo092fF4J0vfYve4I3jL1wvlnvqpd0iPrGZM8oOxpKLRw2uGcyMiCYT8Fs9DIFA==
X-Received: by 2002:a92:ca4d:0:b0:430:b05a:ecc3 with SMTP id e9e14a558f8ab-430c525f52amr105907045ab.9.1761156612357;
        Wed, 22 Oct 2025 11:10:12 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-430d07b4372sm57921265ab.32.2025.10.22.11.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 11:10:10 -0700 (PDT)
Message-ID: <0aeb657b-7eb3-47bd-9781-a24f625575f1@kernel.dk>
Date: Wed, 22 Oct 2025 12:10:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] add man pages for new apis
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org
References: <20251022180002.2685063-1-kbusch@meta.com>
 <f3b648e2-94c2-46c5-8769-a59e89890910@kernel.dk>
 <aPkdHow085ple9Zi@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aPkdHow085ple9Zi@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/25 12:06 PM, Keith Busch wrote:
> On Wed, Oct 22, 2025 at 12:02:02PM -0600, Jens Axboe wrote:
>> On 10/22/25 12:00 PM, Keith Busch wrote:
>>> From: Keith Busch <kbusch@kernel.org>
>>>
>>> Add manuals for getting 128b submission queue entries, and the new prep
>>> functions.
>>
>> Thanks! A bit of too much copy pasting in terms of versions etc, but I
>> can just fix those up. Also needs a bit of man formatting love, I'll
>> do that too.
> 
> Ah, thanks. man syntax is weird, I usually see projects generate them
> from a more friendly markup rather than committing their raw format.

Yeah it's terrible... At least copy/paste is a thing, but unfortunately
then quite common to miss changing a name or the date/version.

-- 
Jens Axboe


