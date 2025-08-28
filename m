Return-Path: <io-uring+bounces-9392-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 442FEB39BF7
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 13:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B47641893FE4
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 11:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3467330EF9F;
	Thu, 28 Aug 2025 11:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PkWx0Cdo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA77930EF89
	for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 11:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756381807; cv=none; b=i5xrz7adFQo30IlZ1n0GmVlPviooims+dRMsrgGu4lY01ekyDSxbIMDTCuOIPTWrVGHS6RNBCEVVrTNEviUX7znpZz3Lh7CD6wJjpNSnYYilfOPsACfUqn28jALQra/fptIj0TGaGpBbsgCfwsvRGcQVzlPAzE6UkW8MuD8P/mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756381807; c=relaxed/simple;
	bh=/wf8U5IKj+z3YPZwIzpnehBZFZealmv3pS9JcwfsdIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DIkeRbhm5iXYAtKNcH468RUg9EkIDoAb32yJhzroM6qOOi8JCbyofifyaD6uQkdA8mvEY9V/aPvlX1QE2xDfsYvuY5R2rLZOIRHsYO7r5T6UpsIFts6cggqKhEim07ct7arcemne6pFabcUsHXN0k//dH0p12RJ2CgRW82rO4Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PkWx0Cdo; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-771fa65b0e1so461053b3a.0
        for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 04:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756381803; x=1756986603; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HjwNXVfVIbch6ui2Lije+o4C0nxjdug1cxVSvsXhRV8=;
        b=PkWx0CdoSUkpozQkkN6b92dwJk6kGsB1oNuweji4vy5hAxK2eDby7hQUzqD6kA25zx
         HHu2rvl6eWPo4+rguJVqtQIIyKwqoccph2UKkCaaV4Fjem9AOkS9XjZByqYm14DwLB9z
         8KArWmMz1rIyOyK5AxJ+SqQBMSMqhbm87s7h758FUzwl3BqKaPrdo+nsa+lFeoxt2jU9
         ZueFOpD8pdaMj6YTzpoNqHI8yAQ8HW4uJcgYG8du1kv9VhwTXufMlA8yn5cFAbdU5ZX9
         899uRtUgKnfTP5nmrXNJkxkKw69tbYK5CJSbpuUyZXe6OUWczHQFScQkQQADPY0VJ4+Y
         v1Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756381803; x=1756986603;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HjwNXVfVIbch6ui2Lije+o4C0nxjdug1cxVSvsXhRV8=;
        b=ipxUhrvGciGS0qxKW+rYVxBe4RE7RA4aHBTNS3G7yRqbp+Kjq/K2e3KJsfxnPhCiX7
         of9AGmhqipW9CLP/OY8X16BrZeL6nZruKiFbp8RO3TiyFZY41PHrOFFElfP1LndYnBtM
         J88mzbUP2OAoo8XVuoaJttu7k/eJT2tGrEmOS8/BdhZ1Qupxfq4iMrQS4IDhZ1wmxloo
         fSxlUsnv+fYR/UnfRr1Rr5l1JpTC4WWLCtjujP8n9zdI2tSygj4FVicZOujqjeFImbM3
         W17yNZBq1g+X7FnPZ0bQbo2iusv/0I/v32d010KZQVJRLjXvvwvdgY8cDiIWgTnLd++F
         EcdA==
X-Forwarded-Encrypted: i=1; AJvYcCXVRU13GhgsZu3WWeMZx6iV6Wf0UsfTIm/UePlK+cVBfmwLGE/ZmtE0BIthep0s+JoGJ04ngJM9Jg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7a5oEYGAqZ698roD+WHyCUb/mxdw6MvJBthff/8xrawSJYyJ+
	MURq0nZ7EJ+IN73y09zh2gB4bSdNNffemnMt+XK4ks/iIBiJ6j47i+aN4LYV9Ft/hUI=
X-Gm-Gg: ASbGncu50pIlYkEMnJvQxHPIw6Iv09rY3EFljN+4E/s/GoQOqB951QmePUXNz5QqFMx
	a2ZXbEhLxG2KnLxpkV/zNkU2uGpTOunfjysJUsBCR194Z9Oqkt5JDdsNEd3S9eOO5Uc2BR2SdbA
	QM+a8BTLqWd5g1pGGUvsyXHN5tvf1D55jZ1ECuPREXLFVb9cibjHahNYP5OWSL5mpE/1qNz/eEe
	Y+AxWWOb76OTMJTrTFiz73Uqa90RXiOZI+3BCY8/MfJe/Glcf5hihiVLWc3PHKwE6ncXGnoR1pb
	vI4kkqThWdE/v9kBaXHxGX4SuO0katsqHDdEUxX18fK4BgTGoQvZSdgFbtT7W2iIG8B7Pq88Xc7
	kezldAV0Lfbxqwyx/P89q
X-Google-Smtp-Source: AGHT+IGezOevIvE7/Nrz9LwifFeXlERPcAuSJuc4DRgcIe+ZiJiG+BpjvRh20H6Ivk7bP2zeqoIoMA==
X-Received: by 2002:a05:6a00:4b55:b0:76b:fab4:6456 with SMTP id d2e1a72fcca58-7702fadbb34mr29937177b3a.21.1756381802961;
        Thu, 28 Aug 2025 04:50:02 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-771fb852dedsm7163605b3a.88.2025.08.28.04.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 04:50:02 -0700 (PDT)
Message-ID: <3aba1ff4-4e8b-4f34-b300-5e7aeb18ec15@kernel.dk>
Date: Thu, 28 Aug 2025 05:50:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/kbuf: fix infinite loop in
 io_kbuf_inc_commit()
To: Qingyue Zhang <chunzhennn@qq.com>
Cc: aftern00n@qq.com, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <8f4a4090-78ed-4cf1-bd73-7ae73fff8b90@kernel.dk>
 <tencent_2DDD243AE6E04DB6288696AC252D1B46EF06@qq.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <tencent_2DDD243AE6E04DB6288696AC252D1B46EF06@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/27/25 9:27 PM, Qingyue Zhang wrote:
> Thanks for taking care of this report!
> 
> Regarding tags, it would be nice to add a 
> 'Reported-by: Suoxing Zhang <aftern00n@qq.com>'
> tag too, as this report and reproducer are
> developed by both of us.

Done!

> And absolutely, please feel free to use our 
> reproducer for a test case! I'm glad it can 
> be useful. Your version with idiomatic 
> liburing looks great.

Perfect, will do.

> This is my first contribution to the Linux 
> Kernel, and I really appreciate your patience 
> and quick responses throughout this process!

Let's hope it's the first of many!

-- 
Jens Axboe

