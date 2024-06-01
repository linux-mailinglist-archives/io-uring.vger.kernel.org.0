Return-Path: <io-uring+bounces-2053-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3D698D706B
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 16:19:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 182861C20F28
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 14:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2090212F5A3;
	Sat,  1 Jun 2024 14:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="21TpKGl3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7999A94C
	for <io-uring@vger.kernel.org>; Sat,  1 Jun 2024 14:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717251556; cv=none; b=cG8wQFBW3yar8N3wL7SvaWOvc1iu4cvb+I0vFXzPDb0lqa4n3Eq6I+8Og4lfSWMqlWDy6eMrgeqFo0098rDf08dIZYANccGakXzkDp2Sah91WNgW/9nQ/oSmuNQ7DLR1kEjfOyw2jxGxUwRZ5ROe5R4+m9bhfyfUmXt6lFzOsSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717251556; c=relaxed/simple;
	bh=NCumzEB8xUucvjUVikJnxbqweTiGzN/WneDyRh2malI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pAk5eHUXirYMTk9UHjugCGRekNLq1AnyaPa23zA6zGgv5MizNq79vhopz+ebPrLAgGiVy4LFDst9QebOGUENhT0jjt/zdJAJgTI9Y5KW0JE2Pc1KsTT83cA1l13NE0fa7tJ3Px6aWsc/npXzNsQ/rG0u19nVzGmMoy615sLgi7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=21TpKGl3; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7024f35d847so102391b3a.1
        for <io-uring@vger.kernel.org>; Sat, 01 Jun 2024 07:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717251552; x=1717856352; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BwIYNCN8UWZZjiGn42iisFwjstbgXAzvYnG0hJnSlao=;
        b=21TpKGl3a7pnnUVCdCLreaBGDIXbPdYWW5eHa6KaWizsnL1BATOS3EUh+nQt0saF3M
         5hIpBTQv1ZZi9PbM8eg8RlPmmTjMh6CbaObhsxVt7pp9jxF1dLm7fqTPJbZnwmccbA3k
         dtf9t2Qmcz5H616vDwefkHACzMpA/WEDGE2y2UFpRW0Mywx4wsaWvRuVqSUCCLW9OlMs
         T6ubVXTd80RwrJ433c4XG09itZZiunPXHisKm6tSCfsNH70lFfbLBmpUX6pwlY1dqRDa
         uhWVI+lYU0e6acGNls3jI4dTJ2WAG2kDIZRGVfF4gjDeybTJf9+lxbFbMO00U6PAr5+Z
         TN/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717251552; x=1717856352;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BwIYNCN8UWZZjiGn42iisFwjstbgXAzvYnG0hJnSlao=;
        b=WqCPuDdDHhU4C2Dw9P/geVo5Fq04hIfXu3VS6q9iwGYX+Qebb9cDfV3O1v5eulzYtE
         10v9LowH1om67KDw5jZ9n9yq+wJWwvtfeIq1RDYSSBx6x383l/0hRBqFWMAYg2SYfncD
         1YESuYuvxogCrppEL9peVv6BUqdR7oOeBwl+H0xX1Yu1uSGiIPanAmG1Uh3XgleWUpW/
         l8Uf56hnTDQyXBC7t/t2ZrngFre7/1EqX3dvTdzD7MXNLUhSJnfkjmZHcfYA8xms/Ftz
         A886nhIp+mY6yy2qvJ1MTv7b+/eAfCGCzH4/Y6jcURLIxJFG945brzp+iRNBRSeNRFQE
         /XGg==
X-Forwarded-Encrypted: i=1; AJvYcCU/f0UY28DL8Q8pOtdilGr5JEUJ7OWHWyCu3tg7cwEU+BGr5TPMRPS6pVQRbIelqYES6yp/uPSC8mMh0ismEslq0FkHGxw0lWM=
X-Gm-Message-State: AOJu0YyzxvHUJHVTnGc8SpS0w+MkxN9eOTatfHrhOhg2psYwMVXHeG4u
	Z90CKlzot/Zwy78VbElD8+OyIhiPdH1ttPTEEQA8xwj2sIp7jEGsgYbcRpNqW+g=
X-Google-Smtp-Source: AGHT+IEJkdzwJ8GgSmdlUeN7QFb+KojtAKfBFsYv4JSAF0O87+vbi2BugudGjJvakoy/9YQ//9wKPA==
X-Received: by 2002:aa7:9d0c:0:b0:6ea:ba47:a63b with SMTP id d2e1a72fcca58-70247663c9fmr4836688b3a.0.1717251551545;
        Sat, 01 Jun 2024 07:19:11 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6c35629c3a1sm2839706a12.56.2024.06.01.07.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jun 2024 07:19:10 -0700 (PDT)
Message-ID: <db4d32d6-cc71-4903-92cf-b1867b8c7d12@kernel.dk>
Date: Sat, 1 Jun 2024 08:19:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: madvise/fadvise 32-bit length
To: Stefan <source@s.muenzel.net>, io-uring@vger.kernel.org
References: <bc92a2fa-4400-4c3a-8766-c2e346113ea7@s.muenzel.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <bc92a2fa-4400-4c3a-8766-c2e346113ea7@s.muenzel.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/1/24 3:43 AM, Stefan wrote:
> io_uring uses the __u32 len field in order to pass the length to
> madvise and fadvise, but these calls use an off_t, which is 64bit on
> 64bit platforms.
> 
> When using liburing, the length is silently truncated to 32bits (so
> 8GB length would become zero, which has a different meaning of "until
> the end of the file" for fadvise).
> 
> If my understanding is correct, we could fix this by introducing new
> operations MADVISE64 and FADVISE64, which use the addr3 field instead
> of the length field for length.

We probably just want to introduce a flag and ensure that older stable
kernels check it, and then use a 64-bit field for it when the flag is
set.

-- 
Jens Axboe


