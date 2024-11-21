Return-Path: <io-uring+bounces-4910-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FAE69D4546
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 02:28:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2ED671F21FE5
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 01:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5AF14C6D;
	Thu, 21 Nov 2024 01:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ETLgj3g8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC8F2309B4
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 01:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732152531; cv=none; b=mYPMFUw0jKzLWuC1TGbuEdcQfqwCOORPix8eVKJ1/ahWaOCKeb5SNRUVfh+Q8cme/7vzH8S34sr7Ue8YdmKqD3WaG2nh0Y98VYQMp2yYzoeEotKkzAp+XlBF3YcgMbcvoSLBw/hr59lrOUVZ80BDgLmHJS731Hq3X8ramGRGVvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732152531; c=relaxed/simple;
	bh=68xrzqLqZX09A6t2B3kKZ7MpFedVv/VpqAoEyn+j7pI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Za2jXECURTEB0nuMotwGGp20eYDMUVhcb5SPb96Jgf4C9FH1WDVkAQJ4Ecd1pELGQet4DwEGsr8IMGva0sS/+DrX2o+moRtef+Kc9DZ6LaNF6zrSzRQkGBKZtu999ebG3yFXtkRsORMkZwnAoaEbtkNF31PHCPQSjYdNs0US+ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ETLgj3g8; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21271dc4084so2921095ad.2
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 17:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732152528; x=1732757328; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+no6goR9ad+f1RHNr0/8/pSSion0FFN4E1n/OOqB+d4=;
        b=ETLgj3g8l9Gb+ND4jsG7UDm91T+TeDBmEmvK3htbZXpKlnCQWzK0EeauDGzS70oc2k
         BdgE9yOPqJfh8vGvfBviy3pmZl1bzKgadHz1nEzft/rPqY2CB0Ac4II90msp8P4JHUmH
         SC9C7Xw5Akjifxu8kz+u5IQ52q3eYdPJSC4pSM9IIJXOF3bvjO6SA/JI6LLKAezLlskA
         1SCkvHKMXg44QiNXINnOl5OMvz9Z1IzyiPFywgVgj73JzPrDx1zaGr7MEJfT5aiBbYW9
         x5T5Rm5shm4UzYGwa7EqHkUSFa9iDu59IwBXQmrmuSYrecOZ8qU4IPRbmBBXxR5svApl
         ZKkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732152528; x=1732757328;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+no6goR9ad+f1RHNr0/8/pSSion0FFN4E1n/OOqB+d4=;
        b=kUQ529ifxZp3X6zQQms3Na9NoLnKQ2zZHJ9fECp3KSMLd2kkFPKVNGNHErjfehtebZ
         IOc/8aqIiNmXh4E85SQDazLTFsAJcMzs7yVBlQFE+PB2qwyLXJkkjuqHELWGXDyuJzd1
         jk97c/reA042ydRzi0ZOsqjRM5nt1WEZIdqsml9so6B85R/473h5mCjhFvW3RiHs/HpJ
         vIqHg2QIFb5pP+5s9bmwiMqtG8NL5foxzGOGb2WROEg/fVKhQsGyfgzu7Pucg7bXsEAi
         Cge1pjrWSOYDXbvJ39Z2jb+tHhwnRoBeKd02SGWyytxJ3psUIjK9kg54lEXLKJ26x9k7
         0Eug==
X-Forwarded-Encrypted: i=1; AJvYcCWfLUZXECY2qe2W/n4ctewaRP5unfT42L8bcyTJAwt8+xXwAlMk4o7xGA3Rpp6wipG5tkx0FNqktg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs2z6zYGLdEhTJIpr6ABuZVr/9gXBkwxVJlBelqRVbKXX1k4aX
	RgD++ah/H9xDpoQcKDJFHk9xtA7+CUPdH9fk1Kk/d0MQzeOf3ojxbVu6dbGNSAw=
X-Google-Smtp-Source: AGHT+IHivwx5HsOi7JTtZXN0JO1/nzvvi+Fj5LmPtB2FRJxzMMnZhGvjw9mrlYlHW5xds/RHuxbG8g==
X-Received: by 2002:a17:902:e810:b0:212:13e5:3ba1 with SMTP id d9443c01a7336-2126cb20658mr68678625ad.36.1732152527872;
        Wed, 20 Nov 2024 17:28:47 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2eaca647808sm1194952a91.1.2024.11.20.17.28.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 17:28:47 -0800 (PST)
Message-ID: <2c373177-10a7-41f6-88a4-df91d46749e8@kernel.dk>
Date: Wed, 20 Nov 2024 18:28:46 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] support kernel allocated regions
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1732144783.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1732144783.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/24 4:33 PM, Pavel Begunkov wrote:
> The classical way SQ/CQ work is kernel doing the allocation
> and the user mmap'ing it into the userspace. Regions need to
> support it as well.
> 
> The patchset should be straightforward with simple preparations
> patches and cleanups. The main part is Patch 10, which internally
> implements kernel allocations, and Patch 11 that implementing the
> mmap part and exposes it to reg-wait / parameter region users.
> 
> I'll be sending liburing tests in a separate set. Additionally
> tested converting CQ/SQ to internal region api, but this change
> is left for later.

Took a quick look and I like it, agree that regions should be
broadly usable rather than be tied to pinning. I'll give this a
more thorough look in the coming days.

-- 
Jens Axboe


