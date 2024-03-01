Return-Path: <io-uring+bounces-806-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64E5086DA54
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 04:45:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A9221F23936
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 03:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E38145BED;
	Fri,  1 Mar 2024 03:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Mr9Bjzqg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F012D16FF42
	for <io-uring@vger.kernel.org>; Fri,  1 Mar 2024 03:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709264742; cv=none; b=IbhXG3jyuJHsVXjTeUMpEx3HESKRbQcre0OCZTR+eBBWNyvmc9oyLWkrH9ZtdUadaOgfgkeJ3Zjke9J4wZH4sK9VjFYTtb1+GXL4fjpbcIMJBsDCj+QTnBIqTOQsA+aqjFEF9uyMaxftCMXqoXgAf8oUaivg+Kh851HIOqlzjVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709264742; c=relaxed/simple;
	bh=hCBAeL93RltP6gos1DK1KeazH9FJy/dQqJBdE5JAHF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OKHyHTBZf5LkQvtANlPLSuhS/8ea+4MQ+FvhqR5CknXFiv4noAuysxO3qqBkMW7uoClaOpvA9hktuQuT1PDb/r4ihJq9t+waNlfvJGgeAP88uKfz2EspixMF2XfUnXnZxdfN9+SfGztIYWqVgYkPQnNeP2sJqd+ItELigzTifOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Mr9Bjzqg; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so475233a12.0
        for <io-uring@vger.kernel.org>; Thu, 29 Feb 2024 19:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709264737; x=1709869537; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zinNhFZ4zKMti+t633Ujy7dKcvwpdXpL++2Y4DiPSOs=;
        b=Mr9BjzqgxzsD9tkbCB30KNT+THtevyRiEqVjQU3bMwd3LuJ7vnL1RyFzSDhipX/ZTB
         kYKoZWLVJjPUkKs7KuqijQfqZ3O58h3fLLDrxUs+K+5XpMuttopWAm27dGLOUCYixYG8
         LTRDF+lTkQJq0PJerPlSVnTRkaiArUWwYcIbyZC4Q1MIp4UAlzb9dSl2bKL3EMkZCsv4
         HEYO3O73Xx2nerfDhrfW4NEhsll+mHBvt83H9ueP+YKVsdJhq1fyxiWiCyU2KtX794VA
         8rpZqJXaEIVzXU3r0KNPcVuVDvf/xNAvcSkd3BnaPvqSEpEXziF54WcOisT7yjqnub9z
         /8fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709264737; x=1709869537;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zinNhFZ4zKMti+t633Ujy7dKcvwpdXpL++2Y4DiPSOs=;
        b=Y+4x6YdtMihrvyUcW1zQK6sm3kk/x8lrEJ+rUQ8qHp4jfx2GZDDMtkc0pB/RKUKHCv
         kov9JztDHJPWJG3m8q/emj9Lg9lQHiRLW93Y9N6EyX2FOgNjUy75g1ZJHB7qiBBXT1MY
         8TwkCGQWsFjW6f+R83xhpv9Wjy2h5AAO4jBMJdOZSUtZNxEG/EOj8LGrEICosCt5l+k5
         xg5rQA75p9KOijs8u6v5RqP1AzyVWCyOybd/1alaF5RCFTy+o8EXmR4Sd/G4Ftd+h+Qf
         j9Uzh1tJ50nD55N7BxYzwPYmAeS34Ss1mx/oMY29y9JxEH4iol6P876Sjal7E7LkE9Ze
         xJ5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVCmRv/GFnrgisKqEyRv6EhE+N6rJZlaiV+7az+1gptyTIJo9VrYoJcwW31EA9MFZmshGR04LnKnTtTT4m9xFOG9ZWdoMGZ6mU=
X-Gm-Message-State: AOJu0Yxj7CWsjlHzktKnAW01EtrsKCg/RY/V8GIkluAeWOvNukDCJpEM
	jpAUtkmiOmBXIwUVKfQqFLtgEWL2cfL5oE9jcIC3+b3+sb/BK0MJZZAAooJLBI0=
X-Google-Smtp-Source: AGHT+IGekOH98q5nELmuwwBY2Lhpr53tKvy7uf6tUJSMHdbGS73UHNC7fKjFytJDJyuf+1WRr8wyNw==
X-Received: by 2002:a17:90a:804c:b0:299:dddb:3a92 with SMTP id e12-20020a17090a804c00b00299dddb3a92mr550591pjw.1.1709264737330;
        Thu, 29 Feb 2024 19:45:37 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id bg1-20020a056a02010100b005dc9ab425c2sm1818688pgb.35.2024.02.29.19.45.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 19:45:36 -0800 (PST)
Message-ID: <1c21f708-ab56-4b5e-bca9-694b954906e5@kernel.dk>
Date: Thu, 29 Feb 2024 20:45:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: get rid of intermediate aux cqe caches
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <935d517f0e71218bfc1d40352a4754abb610176d.1709224453.git.asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <935d517f0e71218bfc1d40352a4754abb610176d.1709224453.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/29/24 9:36 AM, Pavel Begunkov wrote:
> With defer taskrun we store aux cqes into a cache array and then flush
> into the CQ, and we also maintain the ordering so aux cqes are flushed
> before request completions. Why do we need the cache instead of pushing
> them directly? We acutally don't, so let's kill it.
> 
> One nuance is synchronisation -- the path we touch here is only for
> DEFER_TASKRUN and guaranteed to be executed in the task context, and
> all cqe posting is serialised by that. We also don't need locks because
> of that, see __io_cq_lock().

Nicely spotted! Looks good to me.

-- 
Jens Axboe


