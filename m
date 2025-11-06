Return-Path: <io-uring+bounces-10394-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69CBAC3A8C5
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 12:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 399A03AA735
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 11:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5764B30F53A;
	Thu,  6 Nov 2025 11:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DXAazodc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A8130EF8F
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 11:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762427825; cv=none; b=YDWSFw0El5B67iT5jjWE5Y3Dtkvf0sPqVhytsJFDk01vEabXNtpn4KNZbcFOFHOTvdUyOpkmHQiUS2BMKYjJ1rf/Jdc2uGAvspS2J5PWkXPBYBRmzBgkIEQ75QK25KVms8o14hnF9WLYeVek2HuQ7sjtLwDHpiOfFOZ1y6I0BTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762427825; c=relaxed/simple;
	bh=t7T9bdLSkD9Nv6Zb2rZgtyVhZXo2xta2IQVpO2VwIUw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cuywVK/2OnHAIaAsos8y2AZntxLHGwewLhbqfbO3/P4X0E64uZXcUd8RSKMesNN7WT6sf/e3a9fHIBUz8eyVUn2Yyi70Mgop+eJU/84NiGbrvR5MwE+B+PoNaHnDXsbx63MI0j8DPcqcdF0LbxiYHztdx+PTJRXHIULrzaCxuYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DXAazodc; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-471b80b994bso8020675e9.3
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 03:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762427822; x=1763032622; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2pwpif3AbMAeC4QL8pDydgnEKfTN0SLOUAnIYQfQy1U=;
        b=DXAazodcJTGzgp1tpv34kaS357hYOnTl9OA0oQbmWPXBmDEpwwZsrGXrfHISAmadYK
         de2zEiTEzgpIGS62WumnvW5uhsdqRQjb4bJcEwJ7yDOSry6PmyhXZiO5jp8Xm/p+ZDWs
         l3Gkwyk1t5fbLA8suXudUwENUV11ilSfSWXxBQHo09wP9bBclq4cD68WlYhewU2Qty/m
         7guxBw7E9T30LJNIHKn1YOnEPD8/lOiy0ONXtTnmAMcJnbV8J0qeFiCtxkmzwHt5Ddmt
         t67uhzkoDz6wbAOE3R9qVjThr1GcxLavDuh3nIRTHwrYIkj/trtEdyQMfA4hc4AZQ0gN
         B+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762427822; x=1763032622;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2pwpif3AbMAeC4QL8pDydgnEKfTN0SLOUAnIYQfQy1U=;
        b=oaI/tNIVVqwtXL4SUKrarafULKKR1sE64mO/U1fY8f3EGLlmkicgjUQE2xmNLKPYvj
         JOdxP3CTvzWJ1T8v8fVIM4q79uVs1VjJUnE+jW5E6i1TmpzQEO9dx45V4O0OskGTM62+
         f6gQp0b6hIwS7BGgHQlAVGfrG1EIpJKYKN9SBYPhx/5pKAHyuXKDy5kJVCkjnNxbSKTy
         f594BsWKT/xGvG0Pa2GCUE0Fxs9bujb9vUgXDMKsKsH2F0dWnSOHXQ6aqIlxcWYxxHHS
         7fg2MU7y7/O3Nuw8xlZ4IZj3rmuMRkpqqd8mE/w2Ow8dx9fj+QLxJFRQORnC31qe7qqH
         gN6g==
X-Forwarded-Encrypted: i=1; AJvYcCUG1/2rkzv2ypU+igbf11LwsmrCgrkF0sv9+/ZQJnNF5b9++nY0n4miX3XDgUNBCIGW05K5BXbgfQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyr9WIRhocav1BRbnu1kscUQEeLomngaH9tk9o2dhJQmiZH0r0o
	L8cjblSj67DHl+6ZdR+c2GZKT9xT3KRh97bZyYUgnAYSwMzRXAEeftMsaUt0NA==
X-Gm-Gg: ASbGncsG9eXxvDz3YUYWqcK++YtmFT1e3ed8geGKFo+J4NuWaERg23+1wZX0cR7lQM/
	cbNQ3Fl3swF9VHITPaPixTvSMLxGb7GhgMYU77Tf4DY07RinrHOOTS2Qy82Un9XGvU0K7vTyw9/
	JNe/rLhyPI/GG+5C4Rh4IuT8OfJ8mjt+2JEJ6lRNGcyQoYsE4nzxLAdRGTsHt9b5GYVHIgUqqyT
	hXhrGztmaecoE6VEBM0FIKVk5FA/9hljyN/+r3+ZOHRQPg5SLN5qJaI8HePBQax3fFWnHdF5F9P
	qCSMEz4gpyf/7+af0yHrafKmwC6l8YT9uqelqYaAktVQ0eW625TUp6jk4cTb4X8Eep/MubUjuzf
	RnISRqwCdN7Xcl4Pw+453scoMOGK7IFmxfejibP1VSOQWD4erWY7Lv5prtNn9UfXQrNk1XqFLRi
	Q9shrXWHtzFqFTimVN8iNxKPiK9b5E/1pJ4ovXLgZHVBZ1vrcpxJU=
X-Google-Smtp-Source: AGHT+IEjm2TbA6imlZYLR4rRFYK+5E2vEbsGazWIwtpvxS0FN0S6hlQHmUoABt0/OinEP6U0GNT8yA==
X-Received: by 2002:a05:600c:458d:b0:46e:3d41:6001 with SMTP id 5b1f17b1804b1-4775ce2304dmr77261405e9.34.1762427821871;
        Thu, 06 Nov 2025 03:17:01 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb403854sm4390960f8f.5.2025.11.06.03.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 03:17:01 -0800 (PST)
Message-ID: <608ac955-3d26-4a22-8fd3-715aac193dd7@gmail.com>
Date: Thu, 6 Nov 2025 11:17:00 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/7] io_uring/rsrc: refactor io_{un}account_mem() to
 take {user,mm}_struct param
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251104224458.1683606-1-dw@davidwei.uk>
 <20251104224458.1683606-4-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251104224458.1683606-4-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/25 22:44, David Wei wrote:
> Refactor io_{un}account_mem() to take user_struct and mm_struct
> directly, instead of accessing it from the ring ctx.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


