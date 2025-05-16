Return-Path: <io-uring+bounces-8023-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 73121ABA6B3
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 01:49:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DBD31BC7261
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 23:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE46E22DFA4;
	Fri, 16 May 2025 23:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iRYtBCCZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487E81F8AC8
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 23:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747439359; cv=none; b=dRF89RnwttW992k1pV5joOLT/cmRPW6hD6K6gOBfmqZQitJrunCdtOSWVS1UcfLkcreP+xIE/ErMUukz4D9/YGmpmdLjMgzWPzfIn0IkmbaAxytnFxv/QWSeNAZF1rRidFs5GGbPo1g56bfMVihNhGFxI/5ywuAwhgViv33yYFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747439359; c=relaxed/simple;
	bh=CldkRFbh1FYhapa+c4XZMj9tLMHLrPj9ZTluQW6JM88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N/gnKRB+K/tZUc6+/hIooFGSE1GnQbr8FnkCsUQQdRP7kji4pyrukZb61yWxdh9CuKH2zbatjYY6VoXxmot9PouXXZNN8QYfPTodDodqOBvwd8TltfYp7q198xVfZYVYgjaetImqGZJzr5nXIfP0wiuREAg0Nm93Q6HrSQ9tugA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iRYtBCCZ; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3da73df6b6bso8693175ab.3
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747439356; x=1748044156; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yfviK3LpGhqNCzra+ez+UUuh45U3c4B9L84snvNT5/c=;
        b=iRYtBCCZF2eGS5OaQ1mW2YZIaLB3fkuNODFL5adZAc8V+shfBulIN10CDi1KRHmzih
         cb95fnBkjJ61Xy9phgNmeRmhPuLWsa34Ro5jGK1uAh+4RZVEwaMVd7iQwchx8AB/mQ0N
         6kYM4/9oYZxMRfFWm2y1VUSxHgpysHuyRUkZcGINMc5Et4OQrmW1QEJK7c0638n9q2Dv
         VI36GcE8vlvm0+l4kdObzoq647onPTjqeAybVOG1ZNmiyrHKg3TbGOINJwxmudcU6+3k
         ggOeY31H/vcaQr2dAHS8SaXZU9hVyljBeyQhSpp3wZgukRvMbDFsakmh2LWyfkEIVqhr
         S3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747439356; x=1748044156;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yfviK3LpGhqNCzra+ez+UUuh45U3c4B9L84snvNT5/c=;
        b=H23C+PZXVPPHgVEZy5asp2IAiDyKNu7s4QCchib7qdbwmI5fhU3WeUa+gjcLQwiYDf
         TulQovr53JwdcoyjPWZtJR6xNN6fLPLgzNZf2rCRemrzg4s+7u7uWYvaGS+D2rTIpVBV
         Kkso9djD85v9ZduQMe3uHcKd2aSs0ybU2ZbkBFVTXvKF5hV6zz9OcwiX1y3BvfUL20Ue
         O3tbN3N4CYa7HmNtKCEmMVvCy3VgJDtRclhtDBgBnbctRmAUMWJHdxw0pjsvgPTDToNe
         +UL6eX30REcUtnTKV/n+T7x1PXL+uum4fhA4u5c9CDhWei1+d7PTqNCO36YJhLMn4nt0
         os0w==
X-Gm-Message-State: AOJu0YwxOAOXCN/6rOk4Q1M4oIVzCeKJKTReAB/fni7nEAJjbKzFKhSB
	8TUSOPDyk0nH+OPtImzmcSglDz7tqle9vB5jZoON8oe0pngLnIRNd74YO+AchvQV6hIU0OvVr5d
	gTKd+
X-Gm-Gg: ASbGncu+d+41RTh7Si9kw/locxnHyJgoN9GJ+EeKNjQFGurc96sOLmDZahSrQ4ZPoyj
	hJhNg/165HGbC2ZvgwODJqeb2qbEZ2jTbUuYkbFzwFnOoBrqR9E1knh6/RxHgakSqUKMIKvL6O2
	k7DrA/KgTmzjbw99OUWKo5x7L6tXa8sc4vpAPeeXmUAIMr3Q00xQUXbrJsTApt+er42++Ztl8pE
	LgavBCMRMlmGtd35D973AdcYZLgsb0gECmfTPgY67n1AwatHfJHA4QqcGHCCdhPu0rOhlTOFk+y
	0Liwi+lUaa+XK7bnNKJcpMNqUcH3FUKoxTjZ/NxvW3H22CPG
X-Google-Smtp-Source: AGHT+IHiu0viaQ9ZbaF2Q+T2QCWyGQEwINLp+JOPeMJ71eM7VthU5EXHJOPsfxH1H3KyRz4gYz5PEw==
X-Received: by 2002:a05:6e02:b4a:b0:3d3:f19c:77c7 with SMTP id e9e14a558f8ab-3db84333756mr53262205ab.16.1747439356456;
        Fri, 16 May 2025 16:49:16 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1abbsm649593173.44.2025.05.16.16.49.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 16:49:15 -0700 (PDT)
Message-ID: <35dbfe01-3aca-4096-9d96-9666b70428aa@kernel.dk>
Date: Fri, 16 May 2025 17:49:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] io_uring: add new helpers for posting overflows
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
References: <20250516201007.482667-1-axboe@kernel.dk>
 <20250516201007.482667-6-axboe@kernel.dk>
 <CADUfDZq19zOMkX2ZnaAuftb=jCGXRfje+UNu9xmR3gnGBSACMA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZq19zOMkX2ZnaAuftb=jCGXRfje+UNu9xmR3gnGBSACMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/16/25 5:17 PM, Caleb Sander Mateos wrote:
>> @@ -808,6 +808,27 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
>>         return false;
>>  }
>>
>> +static __cold void io_cqe_overflow_lockless(struct io_ring_ctx *ctx,
>> +                                           struct io_cqe *cqe,
>> +                                           struct io_big_cqe *big_cqe)
> 
> Naming nit: "lockless" seems a bit misleading since this does still
> take the completion_lock. Maybe name this function "io_cqe_overflow()"
> and the other "io_cqe_overflow_locked()"?

Only reason why I chose lockless is to match the ctx member for the
same. But yes, you're suggestion is probably better. I'll mull it over
and change it regardless.

> Otherwise,
> 
> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

Thanks!

-- 
Jens Axboe

