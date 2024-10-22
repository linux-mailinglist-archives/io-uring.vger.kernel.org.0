Return-Path: <io-uring+bounces-3899-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B00D19AA2E1
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 15:18:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF3C71C2203F
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 13:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C52BA19D06E;
	Tue, 22 Oct 2024 13:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2XZ825RM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6B419ABD5
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 13:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729603117; cv=none; b=Rt5xjV8go3INp3WMPsSCinnaT+3IblebbsSbxGaHXppbxUiWd/ws5zQptBI7eUqpI+hkgzxs5agDapOww1W5tMpBuskLGtYHQgs9Ji/qMiHfQcvhdwesoLFnvLR9IuZF1W16zvnOz8aVj2nCSJONJDylQWxHTGnGoOwOgrcF29A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729603117; c=relaxed/simple;
	bh=gy0s1DMfktVGQnHFXyQlj4/xwgyJ16oReDf3b3kOqQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oJvjTEZcajzyJ6SUl12B1AOJUc/PUY2RF3njYvo8Dcw9SazqS+KiHkHV1VzAVKHziNHEJkNFQDSJcQ/FehbLCFGGkfRugSHFP6aKKItjO8Z9dzEkPDj5P7ugklWOpk8aQ95x58DaPL/6aFfiHooOnOHj6VZvAkdZBQ73dc810gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2XZ825RM; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-83ab21c269eso220266239f.2
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 06:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729603115; x=1730207915; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0L9TYpjkarxYTFewfLsfvz/GrRHmYHU/JjLeDER58b8=;
        b=2XZ825RMBH9LyQTLZcPeMwZPGy3R+YpWEFdJFDbHydYdfQX6uB4ScE6rLXVnTWMdwd
         eBrCU+Ytz4JbqPOtNBdpZklbCWjhDGBiduzSAaV9s+wk0nPIEwsJVk/HzNdVIzAzz3HH
         oY4ynf2mB25gi1QRU7dgEQLQopX1jTGyJuAgppK/p4Rjbj7dtipR5ny8nWY0wzxmrlhG
         4vO2/xpkHttHH0qk0c60M+uvxDeJYx2RuySdFmnK78/FIxPpfFcj22tx/ax/sg8XIN4b
         2mIWrsTBnzVrsba1ByPO9KSwoXrG77fmYYYh2Q8h+I5GpOYdJo+1qSlM1rKuISDkbkDr
         jESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729603115; x=1730207915;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0L9TYpjkarxYTFewfLsfvz/GrRHmYHU/JjLeDER58b8=;
        b=eb/jqyTfkUbdTx7tB3k5IfMIJit0dQSpBXXGb3WK8KMkxzGBazd6VZMvDMKiyymYvi
         bCDzrtB61An/V5v8ye/37EdQ+EG2+z9wyAXjdDq1oHplJVC9U3WSMSjRE4uSlkza9reB
         GrwPIO49uzJjr9MHXkyF7ARbxEyTYvlxgi/CNZP07SW0v4mwquzPHvbT3VvFbZG9599J
         vjXJsWfSQ4GabGsEDZTTvGsjnhO0c/E6NTLQkzCQCzHkGjTU6BiRzxlcnx0yuJ4yAlN1
         OVk+FNy86HZjB2z/YswXW9oq6jFtdw7M/auB07eaLZVLLR65aXh2IYScZHFWnxxUxA//
         yN5w==
X-Forwarded-Encrypted: i=1; AJvYcCX6bAVmnQHjMbUBZc6Irm+z42OTWAMp1Vlk+Dxt89nfZlPcrtrBlFMNauxzdP48kG3s2ETzSV+LYw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwlyrzJggY7O1tp/LhVxFSdi0w6DPzbd3w2luAwHCKARTRCiW8B
	AQBZHkgDt4Nvf+npDtb3L5GeqHivj+4e/BEd1NkGI47xQOWTjMn++Jvh+R4Qf+8=
X-Google-Smtp-Source: AGHT+IGOcn2ulnlDlaDjdlGre9GWJzVPAdxJEXvgRGAw3AeqtYm6CBM9CisYKRfOyLBPBoiID9LF4A==
X-Received: by 2002:a05:6602:1549:b0:83a:b33a:5e0a with SMTP id ca18e2360f4ac-83aba5c5755mr1255358439f.4.1729603115060;
        Tue, 22 Oct 2024 06:18:35 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a661c23sm1540059173.178.2024.10.22.06.18.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 06:18:34 -0700 (PDT)
Message-ID: <b7741a2f-a6b6-4a92-aa6e-9eab3f018804@kernel.dk>
Date: Tue, 22 Oct 2024 07:18:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] io_uring/uring_cmd: get rid of using req->imu
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
References: <20241022020426.819298-1-axboe@kernel.dk>
 <20241022020426.819298-2-axboe@kernel.dk> <ZxcRQZzAmwm1XT3K@fedora>
 <f29d4778-b5f5-4f3c-a2e6-463c5432dd65@kernel.dk>
 <CGME20241022084205epcas5p190eb2ba790815a6ac211cb4e3b6a0fe4@epcas5p1.samsung.com>
 <20241022083424.wz2cmebvkrdcgw2g@green245>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241022083424.wz2cmebvkrdcgw2g@green245>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/24 2:34 AM, Anuj Gupta wrote:
>>
>> Gah indeed, in fact it always should be, unless it's forcefully punted
>> to io-wq. I'll sort that out, thanks. And looks like we have zero tests
>> for uring_cmd + fixed buffers :-(
>>
> 
> We do have tests for uring_cmd + fixed-buffers in liburing [*].
> 
> [*] https://github.com/axboe/liburing/blob/master/test/io_uring_passthrough.c

We seem to yes, but its not actually importing a fixed buffer...

-- 
Jens Axboe


