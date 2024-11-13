Return-Path: <io-uring+bounces-4635-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B5469C67D4
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 04:31:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CCA2283533
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 03:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086A32AD16;
	Wed, 13 Nov 2024 03:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m9cUaURh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D907081C;
	Wed, 13 Nov 2024 03:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731468684; cv=none; b=KbqHrJoE2CSpbcxKc27eRkTKhjdtQr4pq4851jxYFrFZfUtlZyBeE32KXSGNsGMhqcY3EYBBpkaTks0pndGkfELcAHlmSddopkPPWzqpc4VemPYCS+GB5++BcAsxjqrmgSarjTYpSHYXDZvub6o0xA89i9djC9RC1cFIt00kJLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731468684; c=relaxed/simple;
	bh=gc+oqLRYVg11Q8QZp697vZYwDox1efy2ghGXLJHESgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N4rA4YrlZlHDesDTkNeG7kZSW47roA0UQ5W1hep44FnsZpGUVyRXY0Ef841Hgv4vShd5fpY9CrlKDIHB8LuwITw7xXLMiuQRyecInWutDR0Zc8sn+oalK9CvqdUsNI/FlYq9UdL4Q98knOSyEdtCbZBIexz9NyvxfZvmEKE2Izc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m9cUaURh; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4314f38d274so80498685e9.1;
        Tue, 12 Nov 2024 19:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731468681; x=1732073481; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=psaCi7LsZP+5Yoh2HRN+rRdeKKvSq/sHXDoS6AQn8OI=;
        b=m9cUaURhQbKlJRiCoL5cR84F2gC8WmNkO5nZlvCOwumpFhzS2aK/MqV6OpvGMVQbBa
         m2QR88ci2Ty1T/2M/AaD8yGHZMaz16ffZ/+hzY55rf4xXxabWhQP911vcH7LbdY3lyO4
         e0FU1tt7A5SfiorGgGGSBwP3nYYFmkCN/pEw6mKRKWYsWgqy9LHLB4WGfwibsjlKg2E0
         fTKYshsSuZtiGJfNih63EBQpXff5CuEuTC7rGr70ZQyHRD0Rqim3XZiF4qwJfzwY0a+5
         amCiHGu/RMLLX5pW3U/klh9TQzLEOzFx8bBMlKww8glhfG4VQnxzZvNgFqbTqztlccL3
         7MpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731468681; x=1732073481;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=psaCi7LsZP+5Yoh2HRN+rRdeKKvSq/sHXDoS6AQn8OI=;
        b=Tyx9AEDYR7l7QkkSlLZeRacnIOHOLiT70CfizF/dbEJKEGIi9+mIwkqK2kHLGrJtN2
         /aGMgcTgIWnLbdTwqzIXrKVA+RNZu8bIax3Fxkp1/mDTCTyf9kJROKIu/IsC5HZg5qAz
         WqtVihXe750Lf5E4CPai7gKzej10O0cyG6o8ZVYouUnLtPdirwXG0WxNy64fkFzo+3iX
         XZgrJoZ9BrayDnF1xvyM3fAvqc2k2LCW3iFowZ0aivJihruK4I/Ltatws67azTOvMAq6
         2doEmk3FOLom0e0ncdG2iDBohLOFP3AmgzthQ9BIHEUllFT2mWB+8kCxRwl87O7VRYdy
         AGsg==
X-Forwarded-Encrypted: i=1; AJvYcCVYiyHWWPda6GGECs5uoWkXMoSMTtr2ZRC2AmhdrGeIwHHlx2Km/iXFyzCRsY3h3NcJfLct/HcoK/X5KUY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7jXiXOZiEIcm/z910e5FYG4OvE/7u2I5zgMgMKn2EG6C43gSr
	bEVc24TWLN3BZsc7npl1iIYzPzDEQgJr5s7YrRvCj9fc2bJENLDJ
X-Google-Smtp-Source: AGHT+IG+C+HlyZnoZGWfchB8sQitMkY1P8pKlCIbafGTrUxOO45oQRtYF1O2bn3uGTmXrfQnPG8I0Q==
X-Received: by 2002:a05:600c:190e:b0:431:5465:8072 with SMTP id 5b1f17b1804b1-432b751f555mr204284265e9.31.1731468681327;
        Tue, 12 Nov 2024 19:31:21 -0800 (PST)
Received: from [192.168.42.243] ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432d552ea45sm7901835e9.44.2024.11.12.19.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 19:31:20 -0800 (PST)
Message-ID: <c5848ad2-94e6-4951-9266-b21f14b848e2@gmail.com>
Date: Wed, 13 Nov 2024 03:32:08 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] test: add test cases for hybrid iopoll
To: hexue <xue01.he@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20241111123656epcas5p20cac863708cd83d1fdbb523625665273@epcas5p2.samsung.com>
 <20241111123650.1857526-1-xue01.he@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241111123650.1857526-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/24 12:36, hexue wrote:
> Add a test file for hybrid iopoll to make sure it works safe.Testcass
> include basic read/write tests, and run in normal iopoll mode and
> passthrough mode respectively.
> 
> Signed-off-by: hexue <xue01.he@samsung.com>

If it's not covered already please add tests for failure cases.
E.g. when SETUP_HYBRID_IOPOLL is set without SETUP_IOPOLL

> +static int test_io_uring_passthrough(const char *file, int tc, int write, int sqthread,
> +		   int fixed, int nonvec)
> +{
> +	struct io_uring ring;
> +	int ret, ring_flags = 0;
> +
> +	ring_flags |= IORING_SETUP_SQE128;
> +	ring_flags |= IORING_SETUP_CQE32;
> +	ring_flags |= IORING_SETUP_HYBRID_IOPOLL;
> +
> +	if (sqthread)
> +		ring_flags |= IORING_SETUP_SQPOLL;

Doesn't it also need IORING_SETUP_IOPOLL?

> +
> +	ret = t_create_ring(64, &ring, ring_flags);
> +	if (ret == T_SETUP_SKIP)
> +		return 0;
> +	if (ret != T_SETUP_OK) {
> +		if (ret == -EINVAL) {
> +			no_pt = 1;
> +			return T_SETUP_SKIP;
> +		}
> +		fprintf(stderr, "ring create failed: %d\n", ret);
> +		return 1;
> +	}
> +
> +	ret = __test_io_uring_passthrough_io(file, &ring, tc, write, sqthread, fixed, nonvec);
> +	io_uring_queue_exit(&ring);
> +
> +	return ret;
> +}

-- 
Pavel Begunkov

