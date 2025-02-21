Return-Path: <io-uring+bounces-6595-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3640AA3F410
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 13:20:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19B961894A2F
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 12:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6959E2080E6;
	Fri, 21 Feb 2025 12:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LiLs8i8W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47A6155336;
	Fri, 21 Feb 2025 12:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740140370; cv=none; b=NZx/Mc6m3P4IuEazWhnbwc1LEGk2p9cL9ztAOtDYHCsvAqjMS9muPMuJFaedswavm5ftTNeW/iuxHELLtu/nGI0+E6Kl/wFVdADv24KSA/0a0XiPAnl3KU6UfP6GBSgdV11c//aYgIBxJxVRX2WAWKbHDDRYNGOlk7DQzfKLK6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740140370; c=relaxed/simple;
	bh=dDuOSMiZlreg6zCSu9mLVqtPGIg+/TPcYUzJCeCHcEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jYP5FLVv/19ajrOccb0r6suaH5AkYT6vPI1Uvrfo3HEcJZi32t5zoUr5vDE76C1lkpCCiTOaogAs7qRyziTw8C+rZEr8HccT34ZZLYTc0zxQ1aRTG2eWZigJz/REINlssNNCwah/1mmyFYr9trt0ZOtWOD7T23oy9BejDbk2j3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LiLs8i8W; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ab744d5e567so360308166b.1;
        Fri, 21 Feb 2025 04:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740140367; x=1740745167; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=84BNNH4OFUTTsn2LV2g9aQ8aZ+4jEh72APMwWnrioZE=;
        b=LiLs8i8Wv9obJJ05K9dvHWFmTQEd+EdwHsIZ6VtxcJY58aQoxt2p+KkkNqN5o2yPYP
         rSJN10+RFJSMXMJKJJ4JMP6C9fwUkiJDLFKfa6aXlWFqIO1/E/H6fgwP+rRsMra2cZfx
         dDT5aWIiLG2gQbQwulgSTUdht1CfoVTJLkIOXNm56RfvZzGiYpYICoLW9h0pQJQ6MENH
         AyEmqxpKLhqY53zoTW0Ha/NWcF9qXHRlhlj6cYOt2QjOg2q1trkOKfHM8NF85TT+0BqR
         WMoP724uQ+HS6JTXgJ3IrMGPtqaGzu76bSvNN+3px0tBgXkbRj9vRWHvYBtoquEPANU4
         Uluw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740140367; x=1740745167;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=84BNNH4OFUTTsn2LV2g9aQ8aZ+4jEh72APMwWnrioZE=;
        b=XHoehAbkKvelS53k5qWs0kpzB5d32CuN2MnJtvG/o9kTOiYqq6MaWJQLOMDBC2nJSQ
         zzWtDeqWaf3AcXpeXaZ+KjYpa9NYXoFPEZ9noQnAYaHyqwDC4bQbgL1G9AtxCesL0IdG
         vDwYJCOSBU2dGoAtsRxe5JQIJsxmXXRZhUSVO5o/AS7i99UYV/S3YGlKKOFuPdCnUBhP
         KkNxxStLr11mSq85fNoTL1Rypb7vB6TOxQhXHL+H2ugt+BQ+49YM0oH+aqe98mNnC11I
         +9qPl3PovbJbsxU9XSYZQfPA7JKaR2ReQyW+qboRchp7KscFoH2Sm53ug2NBA5lFug10
         iy5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUvVnFj9HVL9No/zCmIlHfoUqAqpWMgVEvx7XjhfgeofM7KHwytuOSLOZt5tC80+C8mR/FcXtYIWg==@vger.kernel.org, AJvYcCXWndnk6uLqK/FWtmIePoP22oUDq0L7cpnJ2xIR7yMjf1mgJkEiMEJPYOyT0+zwnNMFec22yAKObYIYqpRo@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+BDBJlQRup/JIkQqh3IYsZ5Yd/ZH40CZOb/491DBN24kwFnyu
	J/fAenpk26xG36QMvkru/CTx36bU8XWjmEiVI/3R2tj57tcwwqcu
X-Gm-Gg: ASbGncsKRXY1tDhMeFmlXJlT0l5czBR8w2xYHucQs245/HRvxeyzHT/JXy9Y3i+et+h
	2nVUbqE4i3z8iBDS90kOqWseRmeNldqMwWgUls10EqcX/5c0FPfiVrWMbCAMLMouHqZrPAcitDx
	1hiqVAoH/nxhY4UAGcBoANj/7nXw3LsxxOfDlIJsoEtK+dQ2YgZd3Wsz0DsJvBfs4IpfGTQJiKl
	qHuZF5TQIGFqD6mFD1e3dkbVqi77VsMqeZns6XeYLpHzH7nO3wLTUP1bsDjayoXJ6SdY2w0dSmf
	89y/SfZRn8gKPJeiE18srjp+hIfhHrKtkA+0xrO+TceJW0wm1iOTL8eMsmM=
X-Google-Smtp-Source: AGHT+IGYSku4Z0bQqSe7NtXRBWj8U3CUiCrP9SUzdwnbBAK4If1/shtrr2RE4iWuvn5tdtsya/8mmQ==
X-Received: by 2002:a17:907:8a92:b0:abb:d047:960a with SMTP id a640c23a62f3a-abbeded95d8mr628600366b.22.1740140366695;
        Fri, 21 Feb 2025 04:19:26 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5e88])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abbb66ebb84sm726062066b.181.2025.02.21.04.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 04:19:26 -0800 (PST)
Message-ID: <79189960-b645-4b51-a3d7-609708dc3ee2@gmail.com>
Date: Fri, 21 Feb 2025 12:20:24 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: add missing IORING_MAP_OFF_ZCRX_REGION in
 io_uring_mmap
To: lizetao <lizetao1@huawei.com>, Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20250221085933.26034-1-minhquangbui99@gmail.com>
 <590cff7ccda34b028706b9288f8928d3@huawei.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <590cff7ccda34b028706b9288f8928d3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/25 09:10, lizetao wrote:
> Hi,
> 
>> -----Original Message-----
>> From: Bui Quang Minh <minhquangbui99@gmail.com>
>> Sent: Friday, February 21, 2025 5:00 PM
>> To: io-uring@vger.kernel.org
>> Cc: Jens Axboe <axboe@kernel.dk>; Pavel Begunkov
>> <asml.silence@gmail.com>; David Wei <dw@davidwei.uk>; linux-
>> kernel@vger.kernel.org; Bui Quang Minh <minhquangbui99@gmail.com>
>> Subject: [PATCH] io_uring: add missing IORING_MAP_OFF_ZCRX_REGION in
>> io_uring_mmap
>>
>> Allow user to mmap the kernel allocated zerocopy-rx refill queue.
>>
> 
> Maybe fixed-tag should be added here.

No need, it's not strictly a fix, and whlist it's not yet sent to
linus, the tags only cause confusion when hashes change, e.g. on rebase.


> Other than that, it looks good to me.
> Reviewed-by: Li Zetao <lizetao1@huawei.com>

-- 
Pavel Begunkov


