Return-Path: <io-uring+bounces-803-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B82B086D15F
	for <lists+io-uring@lfdr.de>; Thu, 29 Feb 2024 19:03:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22BE3B216AB
	for <lists+io-uring@lfdr.de>; Thu, 29 Feb 2024 18:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E63EB16063E;
	Thu, 29 Feb 2024 18:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="FPulyRxg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3280B757F1
	for <io-uring@vger.kernel.org>; Thu, 29 Feb 2024 18:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709229817; cv=none; b=UYrsSAQ84OdPO1NNLUoSrhghCCiljN/yAMKfL4BRjF7ms/gDsK+I9sUSspAHSIcEgsP+qFxJVdGGctLsWSLEcnJFarARkSTREXIdgwPpnt9IXLM6d6f9k8lRx8HYCET3NEy7MlFuTdepHUXxagFglH8ORdPgMPGwFk8mINohTgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709229817; c=relaxed/simple;
	bh=5T85FO0sKRv6o1WiQ1PmlO+kVyIJiwSZm/FSTApI6O8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JIB+j1JIUuakn5fE/etJJXXg3Mltnu6GkL7cAS5ryyaHv8os+ujbKcl6fBzpDW0oLLLo2/h8cFzgmEX+Ed2X6f6T7NJfm48/FAbVb0B+9+59NB7juH38LfqmNCTy6kc4Bynd5h6QYft4ySeHraXZ6aZgz/CIpqcgQYQqJahxA+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=FPulyRxg; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a441882f276so177939366b.2
        for <io-uring@vger.kernel.org>; Thu, 29 Feb 2024 10:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1709229814; x=1709834614; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7kOaQ4FjNfc/ZQuhUmDhG4KmcJXLXDEh3idgcQXqqnM=;
        b=FPulyRxgvYVFC9UgCXxvoskJi0iMsqYp0rcSJ3mVhtTkjChFE0urdmZE0LNgbFEmwa
         hx8rfTKvgJwnKFWrBe4Ta0TTSOVwS2YlPe+dXKHDkGnQ0mMdp8sdmgr6kCSv8JG0aBH0
         gLu2TGZ8veXJBkFp/PWelezyVqEb+4GCIAHUYHwb1kwII8RlAXp3nELIdPCE1xej8Y/u
         cT/lF+xyFTEbluPOfJTekk1+OX7vwBYbcUHeTgDO/5DGbpc/y3cxK3yfGQZ0wE7bgjSY
         GJMCivYAbuVohDvh1Hukgr6r95M+woU6YA/NKbdmIt2wXRNRMHEPOJEMn8VOF9/hn7eG
         FP7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709229814; x=1709834614;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7kOaQ4FjNfc/ZQuhUmDhG4KmcJXLXDEh3idgcQXqqnM=;
        b=ei31vHXwS/ilztbWSaNXu+8PYocuJ4DTYIGzVu2FKOPWviaY9YISk9QAMw5IPNK/ap
         JT6yzaVD/oY8YJCpcTDDOhH7OuqHDpeR16mE9uMgMbSsdtSM4yAPi7KHLUifDsRUThbR
         EMQzrCcTM+bx9to9/EiKgbqKKwIEWXAvgK05gaRC5xrNBEatwlyFqtYR2VKFKaNxab7y
         CXZAcEEKhYfBe5XQYsgZrEwLlLi7rh5Y0UUsu6b/Y4mQU5N/fCIN5eWcYTp+FxhXQbqs
         xqqUdZSVSCC4m8NTFguYE+pzVx6YJiA8N1NeQFEEDNRAd++3LTRgrQhd7OQS7+Ccr4QZ
         XY6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXnRyMddumEORhHuo7gngJ64C8rsdW/JVG71qcuQFjQRG3uHbfF+LFcRFqqHaX+syvXT0mKIC1N0Y6sh8UnaO8tO8PsJC1tulY=
X-Gm-Message-State: AOJu0Yylfsy/eViRU2MTqd/IYgkoxey9SV0Z0C6wcnhWoXcIEdjfPiGT
	muIH68PYvG+4HUP56s3Mb+cw+8zSZ9eKonSlcfvnRcSWOOJ77C7owIIeLJYlzNutE6fFSGkgEkd
	4LxQ=
X-Google-Smtp-Source: AGHT+IEw9Zb488w9JKOqp8jfrRvb/V7IyS59OHhNMjFB2YsOt8wW8n1JZQ9vemccjST8zo1nzm8tBg==
X-Received: by 2002:a17:906:4918:b0:a3f:c0bd:b7bd with SMTP id b24-20020a170906491800b00a3fc0bdb7bdmr1869518ejq.43.1709229814452;
        Thu, 29 Feb 2024 10:03:34 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1126:1:102c:cc03:e11a:c6de? ([2620:10d:c092:500::7:f446])
        by smtp.gmail.com with ESMTPSA id dx7-20020a170906a84700b00a3f45b80563sm903739ejb.77.2024.02.29.10.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 10:03:34 -0800 (PST)
Message-ID: <076c3569-1403-4ea2-b62a-cf7426c6d097@davidwei.uk>
Date: Thu, 29 Feb 2024 18:03:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: get rid of intermediate aux cqe caches
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <935d517f0e71218bfc1d40352a4754abb610176d.1709224453.git.asml.silence@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <935d517f0e71218bfc1d40352a4754abb610176d.1709224453.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-02-29 16:36, Pavel Begunkov wrote:
> With defer taskrun we store aux cqes into a cache array and then flush
> into the CQ, and we also maintain the ordering so aux cqes are flushed
> before request completions. Why do we need the cache instead of pushing
> them directly? We acutally don't, so let's kill it.
> 
> One nuance is synchronisation -- the path we touch here is only for
> DEFER_TASKRUN and guaranteed to be executed in the task context, and
> all cqe posting is serialised by that. We also don't need locks because
> of that, see __io_cq_lock().

Overall the change looks good to me. Are there any tests that check
corner cases for multishot recv() CQE ordering?

