Return-Path: <io-uring+bounces-4428-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99DF59BBA3F
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 17:23:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB54E1C2468C
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2B961C2450;
	Mon,  4 Nov 2024 16:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wXh7YonW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8CB1CACEF
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 16:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730737282; cv=none; b=taxAyN3u4qYKVqcro7fz3yj+RxZsWCn4/2QOyr1ubfvXWKf9NN4l1QB6TgeOrsvAyy+XvzrHHF116FDwfmxPtwOj3x+CFZ/V8sGtECUJIW/cMM6U2LdWeRTC2AC+zKSQ2Soh07oTt2bWgSKYVHB8Vnpg7iiArgn3eB11U9aW0C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730737282; c=relaxed/simple;
	bh=dBAhqXHq/slcTX9bzaSb/SxdvhUAiLVaNKzH65NStRY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YrPXXn/sAbp68iNqhkr1urH+h5j3wYcufELWRt8sKNefHl4xSFZVDrMma0tvDNkADJnXtUJwbg+p0ZiZfprWxL8t1m6QOnAf7mUeUQRN9LWttlaVvYPfr7LEcv9HF+WtoRNRm9GBGpmsNceVTP32Mjz+hsVYG80IyaEsuazDCdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wXh7YonW; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-83abc039b25so175409039f.0
        for <io-uring@vger.kernel.org>; Mon, 04 Nov 2024 08:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730737279; x=1731342079; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gCkzIY8lvwR9jW+wCfLD+cI8Ga+TdeAOk0nkkCBQsQo=;
        b=wXh7YonWbrtNdBbfjrQhlyskOVGRK+RJUFVABt1yS1YbNy4b51uyLZASvfcTyRS9aD
         fZEhPpAaT649ZRcNS06qqJMY5DA96W5UuCyo4Yt0MWhjk/mvllOR6K41lvSinr8ouhtl
         erxIU8HO3Q1zc5AwrCSpT4+krmhxbCQY4p1JXhIEAdAa2OYS3m/RrTLt2LTnNpvm0amp
         zgkOlY4bZePBDqopEmFC2vEMmQiIxSCdoz7RoiPdwysHBkf5wIYbOfceitQD5jobQN5v
         e0nHJ65NfKuqUjvdcZIDzGzi6ukitkBLrXg+3y0mEDQ1FvmBQ+qXEbMg+q1y54zG9GoX
         GZBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730737279; x=1731342079;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gCkzIY8lvwR9jW+wCfLD+cI8Ga+TdeAOk0nkkCBQsQo=;
        b=NRvOGbUrAS9ZpgHssUIFVQXiZRYcMBHcPG7aQSU/dijMJZ1r4dSlYphaOqNLFniA29
         bdtGUtlSpiAoHIPlN3l43M8nSAbw6Wp4UYXgunsajNM5dhRzGoVKuBeuVHEBcARIX2Qn
         Xp1DOBlJqVkSs6vQ1pwG+6fG9TYP2B3xU/HnmtbVh4eOKg2HmGoWfc/QKpFtz3Ib4VZF
         aEyZcRL/Gca8xZ4TONrLSnxHj4keeXCPBbpeYiyQLcpkckvZvnhHz07Os+tpIS+fxyR1
         75QDHALPjiB6lvDyXE0bqwnhPFUm+o7lMy8oYM6TT6AmdCLPYAMj1iP5ALB0GDqdgE1K
         Mzmw==
X-Forwarded-Encrypted: i=1; AJvYcCVIRpRRrNLo+VpiKzwvE0I8wQh6Ez+JISp1lpKMie9CXtdsBXZjwQFUYzgo1Et8vYpqtItwG/GQwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxxMBwZiTc43gBWAO9jBP64hFlhgty4AnKxKGDl8D7PO+jMC7O3
	c4TAM+qErQmU2I5gurM/+NHnHfbGPROD3WJWDrMAgosC219h323Xz198pLQGr6gQlIvcGUErn6x
	A5aE=
X-Google-Smtp-Source: AGHT+IGJL1lpTcBtghGCDf7hbxLLzoSwJTdYMgCJ1xLFvofscrqNrruIJpFPUg3EAiZP+n6NS61KYg==
X-Received: by 2002:a05:6602:6405:b0:83a:a96b:8825 with SMTP id ca18e2360f4ac-83b7180abc0mr1338147639f.0.1730737279382;
        Mon, 04 Nov 2024 08:21:19 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83b67cd14casm224576239f.46.2024.11.04.08.21.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 08:21:18 -0800 (PST)
Message-ID: <ebb71378-7224-45f6-b47e-3f89eb446fc2@kernel.dk>
Date: Mon, 4 Nov 2024 09:21:17 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/1] io_uring: releasing CPU resources when polling
To: hexue <xue01.he@samsung.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <a9b7a578-cf47-474f-8714-297437b385cd@kernel.dk>
 <CGME20241104072914epcas5p2d44c91a277995d5c69bacd4e4308933d@epcas5p2.samsung.com>
 <20241104072907.768671-1-xue01.he@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241104072907.768671-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/24 12:29 AM, hexue wrote:
> On 11/1/2024 08:06, Jens Axboe wrote:
>> On 11/1/24 3:19 AM, hexue wrote:
>>> A new hybrid poll is implemented on the io_uring layer. Once IO issued,
>>> it will not polling immediately, but block first and re-run before IO
>>> complete, then poll to reap IO. This poll function could be a suboptimal
>>> solution when running on a single thread, it offers the performance lower
>>> than regular polling but higher than IRQ, and CPU utilization is also lower
>>> than polling.
>>
>> This looks much better now.
>>
>> Do you have a patch for liburing to enable testing of hybrid polling
>> as well? Don't care about perf numbers for that, but it should get
>> exercised.
> 
> Sure, I'll add some liburing test cases and submit patch soon.

Thanks! Bonus for also documenting the setup flag in
man/io_uring_setup.2 as well in the liburing repo. If things don't get
documented, then people don't know they exist...

-- 
Jens Axboe

