Return-Path: <io-uring+bounces-2533-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 411CE937CD7
	for <lists+io-uring@lfdr.de>; Fri, 19 Jul 2024 21:05:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB304B21DCC
	for <lists+io-uring@lfdr.de>; Fri, 19 Jul 2024 19:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 231641482F8;
	Fri, 19 Jul 2024 19:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jGBOiDuo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647CD1482F0
	for <io-uring@vger.kernel.org>; Fri, 19 Jul 2024 19:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721415914; cv=none; b=Cl2bIPii538t6CGm6bHy195+vQ21eZJea8dWwvK3VQuJa5lQxsQHr+2P0SHBIeB3rxVuSM1r/RXZ8YcABCnCb4J6OFgiBozzhDxh0N1m8juOfgpH2RUOLq13kj1CUV4W1PX0LmDKPN7lB/skWkvkiFORAzvQHjr5PNE2ZYWd8qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721415914; c=relaxed/simple;
	bh=yBKphk+kO34RoHjQgFpte2hSaIa0wA3auRo+TLhJx8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rt+0OtEqE8aHa6KTKa0Cuj5ogFQoGX8lJWhz4Nqacta1gxE93biBuOnLMSnAffC/p8cR7svcBZGXsZ5JpLWGD9ufmrR18rK/SMvLuWk+cRBeK4RbL2BA+8gjWpJH6uo3EQzZLJF4t6625gV4mUw2HIyFBpvKcW9LnDlP8XmxhJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jGBOiDuo; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-6c386a3ac43so306492a12.0
        for <io-uring@vger.kernel.org>; Fri, 19 Jul 2024 12:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721415912; x=1722020712; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+nx9OdCwMEY2JRvD0bOdHslpOXnBey2t65szlXZcXug=;
        b=jGBOiDuoRicy9n9YSOQdMhAhSmdJViuPq/z1Wri3hDJPCOaUnIWinuw3Rs+UneidjC
         Y48jRZUDk3/pHgqLMHZcvekr0/WXPTmdkeI03oq8qQFAyMj4Y4cA8IMJOthhyv08aOh5
         AWgWLR5ihs7XmQgrrIiXPBEC2CdwTGNWzJecfbhNdQZJFF2eeqwXXZ0MR1Tt7ImsC6My
         atRt4QzH7ozr4pCmVrPDcyNBeympt5r1yzHd5G5PQnyis0WWbEhHQIdw1h4o0QZ9ijaX
         aEfOH3hx+l3N4YnyMZnTTcCi8GmggfxLuG4VWCi7g3hVsH+Ge7aSe9JNgn/GMD7I1DPV
         y7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721415912; x=1722020712;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+nx9OdCwMEY2JRvD0bOdHslpOXnBey2t65szlXZcXug=;
        b=CKhBjay6S6jyoe/Vj4LbkWu1O0URSMcrgdoYRVHrMplXjGyCxCaakjl9wwnO5Rg7Ww
         Bg+xZzV6rPyksd3nwFXCeT/zNSqIhFRzqxzY1hDNMriVXWZj5Vm3zZubAJwvth1EDsoT
         WfrvS6o4ZUfZ4Ec1JfgZTWRE2AnWVIogakEz6RKA5MX/fHkLuqKfGGieiO1hx6osALQI
         wagXblyA97xfZXlVyyZVVz1W5y2e+c3PFvdGbcZzlUNhAb23ruZVB3ofe1LTH3A2U1Fy
         xMpzlKYft2RfdBtd8k0wmm7I25XMdQB+GTwp6RmJciY6eba2DXKTFCa6z4I8poXXyKKv
         Fgpw==
X-Forwarded-Encrypted: i=1; AJvYcCWfTBgx1elcZG8kzNwv8l7SSRUjrkPUdYjqCsNjf49GuKeqyoE61XApgYnSXxViENtcaZut6z2wjXX/Ky0OMS+wWZC/sY1wdrE=
X-Gm-Message-State: AOJu0Yyyc0aNkaMAhSgCT5wN96AuVf/AOuYqZZbmxPRsxOzx0puZkT7a
	Qhq6vzdvOP2b1Fhh/HzTegA4kbTZ8vf7PBWN2Fn7SCe2dKvndzAuVr++hyMTM/vGHulQsWCn3L+
	dFsQ=
X-Google-Smtp-Source: AGHT+IGdhsJWDxm7pZKeryvCYAK1+cTyIo63zWdJkrvVVhI7KSLmqHOJHPUVumTVMUg6S1EE6FkwVw==
X-Received: by 2002:a17:902:cecb:b0:1fd:6d4c:24cf with SMTP id d9443c01a7336-1fd74573b0amr5601685ad.5.1721415911589;
        Fri, 19 Jul 2024 12:05:11 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f299651sm8374115ad.104.2024.07.19.12.05.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 12:05:10 -0700 (PDT)
Message-ID: <5aeac0c6-9658-4845-81bf-8bede181767d@kernel.dk>
Date: Fri, 19 Jul 2024 13:05:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6] io_uring: releasing CPU resources when polling
To: hexue <xue01.he@samsung.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240709092944.3208051-1-xue01.he@samsung.com>
 <CGME20240718100113epcas5p255acf51a58cf410d5d0e8cffbca41994@epcas5p2.samsung.com>
 <20240718100107.1135964-1-xue01.he@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240718100107.1135964-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/18/24 4:01 AM, hexue wrote:
> On 09/07/24 9:29AM, hexue wrote:
>> io_uring use polling mode could improve the IO performence, but it will
>> spend 100% of CPU resources to do polling.
>>
>> This set a signal "IORING_SETUP_HY_POLL" to application, aim to provide
>> a interface for user to enable a new hybrid polling at io_uring level.
> 
> Hi, just a gentle ping. Any coments on this patch?

It's merge window and vacation time, and related to the former of those
two, any changes for this would have to be targeted to the next kernel
release. So it'll get looked at once things settle a bit, there's no
rush as the 6.11 merge window is already in progress.

-- 
Jens Axboe


