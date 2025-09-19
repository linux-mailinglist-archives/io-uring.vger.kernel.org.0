Return-Path: <io-uring+bounces-9849-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC170B89CE4
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 16:10:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C7F87AAC2C
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 14:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0FCC227EA8;
	Fri, 19 Sep 2025 14:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kmLj8tII"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4E930EF92
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 14:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758290995; cv=none; b=CkroJ26qQc8wgRE0iiyE3Kkx5jMZmSjRa2yaD+Kl46VR761yRciR6pJTRStf7jUYigB/Shv5YouA6IpO0G2URseE4WNdBlA8TlpMhGj5EUjWBhhKRNrU/DuIWjJWPopfjJWyXouwNtHvYXuI7+rsCfxFPjjy/NdsRg72VCYCnXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758290995; c=relaxed/simple;
	bh=N/UOAT1AHa1u6tSAYxch6uVQMxuMRrViH/flQVI2qHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uDv8dCPOaXll/vF4cy6aiMKq1081D7CSj9B149ACpBn0Lwk/ezJqnIFOKrcqtjupjJBJ8rrEPYy948epdv6PvPuxgJkNeyCdSkoQm2kYwqJvTwRz8UtOZ266XYUTukfAwzjDBxB41THZ1EiIuAaF7kVCdsMqPbAox7RHAnuG4hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kmLj8tII; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3c46686d1e6so1437268f8f.3
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 07:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758290992; x=1758895792; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mG5jSCP6/LGXM+3mpuJkYg8C76QLVXIzKcR+0FHNFeA=;
        b=kmLj8tIIkeuS2IkErYYLOLMfy1wrwMg9C3W3dxOeV/FTpYG2tpQkC2ReT5eNuu44at
         N0d3pxV/vOrJCdwECBZWsUXWCZ+RCxE1yKsngUwPYVsxuhlhK9DVKyLYd3iyPobQb0fN
         5qiyDAICibH/nv+StpCnAbis5MhclH3Ln753e4VId+DGTPBVBLe8alsF/uptM1eGflJb
         Jy1U8C1D7WoZ2//Mh2jX/ZhXk1aHJOi7RyFuBRjBi36F/c+x/PaDqnyHR6ia2CqNYula
         0ctxK1ibK/OVwPhR482XcjPow+QC+a82PIrlbIIx+ycfEya8ECK/XCPDO3TK/Cn+hckJ
         Wt/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758290992; x=1758895792;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mG5jSCP6/LGXM+3mpuJkYg8C76QLVXIzKcR+0FHNFeA=;
        b=T6I434wbGzs8x5ij9l60QsqKgLHQVpjcNPGpYh6lNt6zcKHCntYqn6QFbnn616Ba5W
         s12K8iv6KX1yWUtpfabwJjDMC1XY3sNuW6LxJVN2fRB8HkV5n/XqXLtGr4UkMuFgh1nt
         LDJ7Kca/zM1SLCfDgM9bgdT4LzLVYe3zlVODSDC15ZxxikxTOw956nOoiGOMjfrCYENj
         ElvbLctfQXmWWXrfYS97UjIL/vGvtm6T5PXpQ/9RlRipmugi67wrKVsKw5WFBpYqMO9y
         0hnk4gyuh/5R8Ig3EfV8qB4rPBbo47zO609H/g6W7KQ3EGBtPjYYt3oBNy3P7Kn4YVm1
         Vsew==
X-Gm-Message-State: AOJu0Yw16iqFFNOZnMEhFXUdn5JjOGLJ3tcGV0lXnDvSmbVw69rPOEo4
	r7Gcq+KOqGyzjjwQ5Z6WIs+TIV+QoPFCTTjguTurZwHZa4sil85vTvss7TgItw==
X-Gm-Gg: ASbGncswgiWgVCBIyxA9fczOYbInC4XXxZajeEV6wBlXog/5wgi1xW6Y9kBZ6nFcdgB
	1F1NxfvUc2IZoH4xPlt1OGinCarMfTWBssK+6yeLy3zDxcpu7159RwJX7nTh8hrzhlBvkA4aKMf
	7G5i0ZCvR+NJM1D3/WltwYVmkM1yRss8TjJ7MSNothtVKAq35Xh+tiaC/0BUmdkid8Kg66WVcQB
	E5DhlPJu5NvBNH0RP7KaT31we1xHoWS9/PSSXYiEr8B4+dKsVdWiFWC3DgsPzAk9JU6eDC+9wRB
	rLZIDBsJNW+Rt4acqfVpCvtFEuT/Fm9cLRomh0yLQpzP1YZBi2SbqjT2Rhru7ArkZ9ydwJN17QL
	FbkfJ8zn5l1dDkD+kmwCrwGE9tIbvlAZtJJJOge7VM+PSKa/3Hypox0lcQ5pN0rqlcxCJ6K5m3w
	==
X-Google-Smtp-Source: AGHT+IGuBACJ6jF+qu/h2W4Te10aHWOFYsBG78dx4YZEJydBWlLuWzHjy+U8as6nvTRGR+BHEk0idQ==
X-Received: by 2002:a05:6000:2c0e:b0:3e5:a68:bdd0 with SMTP id ffacd0b85a97d-3ee8585f7d1mr2979968f8f.52.1758290991799;
        Fri, 19 Sep 2025 07:09:51 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07408258sm8166031f8f.19.2025.09.19.07.09.50
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 07:09:50 -0700 (PDT)
Message-ID: <8fe7837b-e12d-47d6-93ac-3580b6ac1127@gmail.com>
Date: Fri, 19 Sep 2025 15:11:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/6] tests: test the query interface
To: io-uring <io-uring@vger.kernel.org>
References: <cover.1757589613.git.asml.silence@gmail.com>
 <71ff0fec25ae279ba6bdc1ce81e3ad86995340f1.1757589613.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <71ff0fec25ae279ba6bdc1ce81e3ad86995340f1.1757589613.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/25 12:26, Pavel Begunkov wrote:
> Add the header / definitions and tests for the query interface.
...> +static int test_chain_loop(void)
> +{
> +	int ret;
> +	struct io_uring_query_opcode op1, op2;
> +	struct io_uring_query_hdr hdr2 = {
> +		.query_op = IO_URING_QUERY_OPCODES,
> +		.query_data = uring_ptr_to_u64(&op2),
> +		.size = sizeof(struct io_uring_query_opcode),
> +	};
> +	struct io_uring_query_hdr hdr1 = {
> +		.query_op = IO_URING_QUERY_OPCODES,
> +		.query_data = uring_ptr_to_u64(&op1),
> +		.size = sizeof(struct io_uring_query_opcode),
> +	};
> +	struct io_uring_query_hdr hdr_self_circular = {
> +		.query_op = IO_URING_QUERY_OPCODES,
> +		.query_data = uring_ptr_to_u64(&op1),
> +		.size = sizeof(struct io_uring_query_opcode),
> +		.next_entry = uring_ptr_to_u64(&hdr_self_circular),
> +	};
> +
> +	hdr1.next_entry = uring_ptr_to_u64(&hdr2);
> +	hdr2.next_entry = uring_ptr_to_u64(&hdr1);
> +	ret = io_uring_query(NULL, &hdr1);
> +	if (!ret) {
> +		fprintf(stderr, "chain loop failed %i\n", ret);
> +		return T_EXIT_FAIL;
> +	}
> +
> +	ret = io_uring_query(NULL, &hdr_self_circular);
> +	if (!ret) {
> +		fprintf(stderr, "chain loop failed %i\n", ret);
> +		return T_EXIT_FAIL;
> +	}
> +
> +	return T_EXIT_PASS;
> +}

It might be a good idea not to test the capping and add
a "cycle + SIGKILL" test instead. I'll do that later

-- 
Pavel Begunkov


