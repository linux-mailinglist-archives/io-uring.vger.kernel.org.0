Return-Path: <io-uring+bounces-10397-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E53A2C3A832
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 12:20:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6535C1A47881
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 11:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0CF62737FC;
	Thu,  6 Nov 2025 11:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OGsPOn/1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0276038DE1
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 11:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762428010; cv=none; b=d3YnbuBrm8IsCq/AXKPKjwe/Pm72LYOC7MrfO328/R9q2fZwMzFjfgHhJtOyVV2hDXGbG5a1ImzYrYb1/udYMihKlp7M9/+GFbecGDjVnglx/Vsy+/ov6V0Bd8/1WLMia46tAS+2dTE10EOqBOZmJ3WdAcidGYPRH6grUrEqd84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762428010; c=relaxed/simple;
	bh=FP9NM+3aCaFyy8S8X4uShfckyRpPcF7PbkxpFQEZXaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KZF7YQJ6RBSJaeN2ND4Tt2GLPa0vLnKQ8kB1jS4sRQ1ute/6nE8lCYm5M8fJqP8mnddBejcFAX57eKRBYWV082H5cSXNaP+GCAKmm7d6G9Ilt4IuLU1JM79kna1Dh4udlKvtIH7pd9JA92TCOuLZ2rX0c0udiU7OW7A+q51JIjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OGsPOn/1; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47721743fd0so3797585e9.2
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 03:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762428006; x=1763032806; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f7dWREg84wLVwTN0Z31lc7M5a+XEMVB4V95uAvuHHC4=;
        b=OGsPOn/1YzwLu6kMCvkLQSkest1tcUeKSFkOT0fazdxxqH+RsAfA1K+ZreMebVBO/9
         e/2SOdZxsi7IDiEjz3ArH5apOKCJV81R/xicn8HsPazs3Z1pnLQZ6kHr/rYwL9+7hS7V
         NLaswDsOSlga5cruWjM3f1XrJQMk6G5xkrBx4n9wNH2i8eW5wq71zWL4hrKtIc1zstYm
         ltMX/eebKlHpAz4G+CcFTZM15XhrRxcv/gpfNVkKo5/rHpL0j8QBQSL1BRlEpan9bxqR
         Ur3La83Qde4ftE6PB1OEFJ2UzUZL/IULmQjQuHQxVBWBbkIXIrbjv2GjYkklwDWU13MY
         U++w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762428006; x=1763032806;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f7dWREg84wLVwTN0Z31lc7M5a+XEMVB4V95uAvuHHC4=;
        b=PBXFbhEcAxRDBTu+rqFFp31YqTtiSTDuzafZODkPsdOvnaoVMqBLL6WAONDQcZecI4
         2z+sMZx5C+AK/R6MRZoROox7+2rDwLEHEw3agKVNF2YsmEr5EjYA9x0wqfHDl31I6HE4
         fTWpOogNmd62E3l8UfzrsezkMAksq2xupWExBsF1FBc13mtsTx/nS2HksdyXmOpDfPtP
         +qXUMtzCwlQ0itkZ0ZfwgP9wn+6BrzPEhYvv5xtVJyT8Mh5grKsJVliqshUthL1EY68y
         WHpi6u0ybAsoMiP/9mywDv+NcQt7NsqGhCgBTU1kGlcFcuNk+JBTUwulk0IeeeJppn1+
         J7kg==
X-Forwarded-Encrypted: i=1; AJvYcCXKbyHTCvxBYnfHdIhWbg68muhJ24L5oNB6myhKdNOGFcqHZ/NL8ld94r4pX6olGHg7BPmjAdsTwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9aU18wHGrQ7sAg93UTHH6PuqcVGFgAyZKfZfnnnyDcLXLugcW
	WVdZVE5oGiflgRgWbhk7AxOxBBvJww01jSSt2bPhQP8oid8yj+9Xntk+DoLLKw==
X-Gm-Gg: ASbGncvtB1heUvFN2fvnFBpnSf6dfYFUcJqDsXNpQa+8LGeCWwJAIpMO9TvuNqJQvk8
	uIA90Y69QIE4kdD1EwQUX1Kv82rUsUHRU4AP4dKi3QU7kYTgp5GEJqBX/0g+dpEGfZnq+mmsB+0
	o1CjA1894QBpT8HQ0afsom/1WI1MQggzYkDQD2S8B3qzgLHnKSloe5u8WBfjr/WhkhG/O6a+M5z
	VLBshmVVmKJDQoX/2Eu0/8nfFyVev83UoWtV/c50V937kCk5pdfARace45ZfkYRHmVBGDR+hCgw
	zVY1dsPL/PogThMY5bVvsTCQsRt6ja1xG6rPXpG0MWQmvdY6ASU6+QFvdXfSd8TV/Ykw9D/x9nT
	FpYYXGFMWxwAz9/hij8EX+DwG3G6BGc97Ocp/IzvCTyjwpOBz5wqM1xSTiyB1C5IK2C+5h7UYME
	4czyqeDyz3P4o5nqBbbHc0C6NhXLtCsdD7QGMNy2mSv0hkAYjdyQn31g09ZdQ8yg==
X-Google-Smtp-Source: AGHT+IFmPEOGXwmiNYFV8qNYtQCERc0uP4rcrWry1AtWNHepXQvSUroPgf3ymb0aUW3f85vOL9FEbQ==
X-Received: by 2002:a05:600c:1993:b0:46d:996b:826a with SMTP id 5b1f17b1804b1-4775ce2491bmr71488725e9.36.1762428006179;
        Thu, 06 Nov 2025 03:20:06 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47763dc2b8asm14874085e9.2.2025.11.06.03.20.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 03:20:05 -0800 (PST)
Message-ID: <12e904e4-92da-497d-8bf3-27f3018232d9@gmail.com>
Date: Thu, 6 Nov 2025 11:20:04 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 6/7] io_uring/zcrx: move io_unregister_zcrx_ifqs() down
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251104224458.1683606-1-dw@davidwei.uk>
 <20251104224458.1683606-7-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251104224458.1683606-7-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/25 22:44, David Wei wrote:
> In preparation for removing the ref on ctx->refs held by an ifq and
> removing io_shutdown_zcrx_ifqs(), move io_unregister_zcrx_ifqs() down
> such that it can call io_zcrx_scrub().

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


