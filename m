Return-Path: <io-uring+bounces-8061-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D02EABF794
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 16:17:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17E4317B1BD
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 14:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 258EF145A18;
	Wed, 21 May 2025 14:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QUj+Izpj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABC21946DA
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 14:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747836866; cv=none; b=eTbG0uCUPcmZs5vtjzeTlXB3cGs3fl9esmGPjhM5VTeRN4NQEPwKUx3hrZ4VSuSBpbXHymes0NLGuJv2BDHlrATUgJT40uzsCyZu3z3+sbTms0VghPhi5WQsUtBMzzq/IDTZYQfYym0oxyXF7jUF0AFoH6b/P1cRouaUARUfP3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747836866; c=relaxed/simple;
	bh=ANgd9im9tf2rWluDAn8QDCGiSflqIIGoi9Y/oXeA6Tw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YaEZ6Wr8DR+TjshymY5pAs5tA+CY1YMJuaRkymOkWDWJuaRq/shdeuaTxDizrE3DYyiTFz8NMJipRjQh/WRwTm3eq5DZNB9AdMhyC3YTce8UwwoqPrgjS5pO8u9lW+Szgp9VkSZpmBbbNNqgRxfoHifDdR+aBiwefyq4j6NvN6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QUj+Izpj; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3dc6f3fe907so12163405ab.1
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 07:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747836861; x=1748441661; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JnbD5JVPc77i2p26HQO1hs/e06lWBwIowvEhBrEXKHE=;
        b=QUj+IzpjoJRdag/qvY1244AimISuBhjlcBY3TiAJ8EKg12hlycRNnj+2YA4GMptbsA
         /2jVVTY3adG/3ElK1HunLRjsXAlHCDJkEDdmpOytWDVrQh9z2xtv7VoQm3dHOlJEBVmK
         tgHvZlzGsvFNT7mpbZfzXm5JKenOKc7A1+iir0Bd3kPGVWwScxDTfgXLCuz+vrAq6VdT
         xOMD4YxYtaKZhtN9wUZ1N1DHnw41rzp4lJ8xm0l9HJnqyg/DWPLOVujy3Q2VPAoYScYL
         Qt/RSgqgSS3K+0bNXkQReoqg7sK8ACUaxuYUTkMvIKxtpdnAQcAMaSf5frChT1abIWDZ
         zsog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747836861; x=1748441661;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JnbD5JVPc77i2p26HQO1hs/e06lWBwIowvEhBrEXKHE=;
        b=NxhRBOKvR0BMxRskLPqvibQMlztnZCyTb6T9Yge7+CZODRZJwWuk8ySL5FstrjXvwR
         JolGddjSoTcS5W/7Esfj1ag9acAlxS7inysGslP6FprwCYEoxjCK7wzkAQS9F1ADHJh2
         0ToDugzai9sNLG8Icf9fqVPPu5XHzSV5FjddqzeIbjigkyKycQbZslQNSANf58BGp94I
         RntY+Bp65Cea7D+2i/Tk95d+C/roOsZB79dt/eLmp4ffHRtYX5Ytp+/M5i9q9eV4P8Lx
         JLE9Rmte9tXlNytqO0LSeWJJsaaK59an+FpiGzXTMhDbONIMHYvsK3yiaBUtI41akUni
         31/A==
X-Forwarded-Encrypted: i=1; AJvYcCXM/WUCTDkvmQkvyUhs+F8OUsJxFimsZFzn/ToATF5rM7BCwPBdlABqKI0eaeETm8F/I80Zcjk0NA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwVCg1NgrtEb3OI/9ea9/RYBe+DnSg/neoZyqQSlDbKCjuYO7xM
	Gzi1cEngzsw7mpN3oQ16FgvSRH+s7N2FDOCNH+4amc7qNHzSPZuXwccyhVBL+RZOON4=
X-Gm-Gg: ASbGncvIOsXVNZtstdJAZRszF5wnPB36OlEiEyXCnNYNnDEsgA6VWBAj2+8jhLdaPhM
	OMHPAc1FXOP1bfUPQR1FGEqZ5G7o9zKHl6ngRbWYs8q4cfVQ25WEaaojbDyktpbBNFdVpamL5Vk
	mok2sf/bUqVlEqrWvYB3/6LjGCRt4QK8GrVz/1khMBDRBd6mmYUimoBHVGCLrkOHpqhYRcMXj89
	gKhfusrC2K1PGAkDM87kpJQ/iYkyuL8acMUZf3AgnfegecqoBwUvKZD0i5vP2KLBcr93gama03Z
	bnLe6g5ho4sIRlPwWioUI6cza56v+IItEhZulW3EXwZPSoo=
X-Google-Smtp-Source: AGHT+IH36il5Gtic1+SI1Np7H+TVMJuD9E7RRN0bxEsa/AQvdu+WlcZLifLBXyUQuUIwkdCcqX/Fog==
X-Received: by 2002:a05:6e02:330c:b0:3dc:811c:db86 with SMTP id e9e14a558f8ab-3dc811cde50mr34623445ab.8.1747836861276;
        Wed, 21 May 2025 07:14:21 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dc85ef07dcsm2722705ab.36.2025.05.21.07.14.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 07:14:20 -0700 (PDT)
Message-ID: <b4f0d0ef-b05f-4f40-bace-e7632293fbb6@kernel.dk>
Date: Wed, 21 May 2025 08:14:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] test/io_uring_passthrough: add test for vectored
 fixed-buffers
To: Pavel Begunkov <asml.silence@gmail.com>,
 Anuj gupta <anuj1072538@gmail.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, io-uring@vger.kernel.org,
 joshi.k@samsung.com
References: <CGME20250521083658epcas5p2c2d23dbcfac4242343365bb85301c5ea@epcas5p2.samsung.com>
 <20250521081949.10497-1-anuj20.g@samsung.com>
 <7e846c8a-3506-4581-bbc5-fdf9e084a5bf@gmail.com>
 <CACzX3Av3G1K0aoZXDOHjfT=Su6G9D-_RyKWjdMwsNpba8T7CFA@mail.gmail.com>
 <48319c53-9556-4a97-97b3-3530247b6046@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <48319c53-9556-4a97-97b3-3530247b6046@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/25 8:05 AM, Pavel Begunkov wrote:
>> About the use of io_uring_prep_read/write*() helpers ? you're right,
>> they don?t really add much here since the passthrough command handles
>> the fields directly. I?ll work on a cleanup patch to remove those and
>> simplify the submission code.
> 
> I don't care about the test itself much, but it means there
> are lots of unused fields for the nvme commands that are not
> checked by the kernel and hence can't be reused in the future.
> That's not great

It's still a pretty recent addition, no reason we can't add the checks
and get them back to stable as well. At least that would open the door
for more easy future expansion.

-- 
Jens Axboe

