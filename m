Return-Path: <io-uring+bounces-3092-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A7B971D2C
	for <lists+io-uring@lfdr.de>; Mon,  9 Sep 2024 16:52:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82F5C28346A
	for <lists+io-uring@lfdr.de>; Mon,  9 Sep 2024 14:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C66F1DA5F;
	Mon,  9 Sep 2024 14:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cnudllxz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435011BB6B8
	for <io-uring@vger.kernel.org>; Mon,  9 Sep 2024 14:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725893508; cv=none; b=iRUhZvy8D5x49ndI2D1+9xTK6mBsXnm6xjkFFChvS1kCltmnmtSIn2PPC/Z+DxrCIb60EHElonLRWoDEUNKZn+TdyP3iNMWWZr9vW0PC64Q0ZHW6lvmK29s2kp0ZYHbuRBMOO2d6eo+dn8cRAxriOR6fh8DWrTiFtWdXkv/S0Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725893508; c=relaxed/simple;
	bh=+cJBG1upvR+F3tYffdvhWbT1y7mKiym6WyRY+g0v8zE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tZijK85GZs30Ae1qZZ698T6/LXwY5iaivRkmKI2MhFyJ6k6mSmenB1iboQ+zWoFh9PM0cdnYYh98L8XhFIghUj2MzoXg8rSLc0+8agFQfLfMgqlFUUJw2sj11nQ3cZFocHiceK+QIEveQ+DXTlGCJ+BjzceDcgI4k/3qYV6yySQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cnudllxz; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-70b2421471aso2913530a12.0
        for <io-uring@vger.kernel.org>; Mon, 09 Sep 2024 07:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725893505; x=1726498305; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f9rWAsIGzZ6u/QYJf5tnAdUimUu+PCvUeW7OogHaSuI=;
        b=cnudllxzOE8KL2lqOQmdQyS6HH8YpiuIX1rNf24tMN4nWHPT3h7UbwZNz1W+YbKdE7
         0YGmn5r4pRfhz/B3Z/KrvZiNBNoI+VutLAZmg45zOcjO3hMlQ2sAYHGdp0ETItoxUD5E
         HQAAu2XNTseXSGizMdTJygudXccn67OvyrSFaW3aon6yfHOfluU+vJDmpsUV1O8J96Ry
         wWULQYbY1u3Oezm8SeoB7Bfltk4kEkyz3WoK4j/3p3JXqI62eZFr6YSg4rI7RXdmuZnb
         5SZWZxcFVyxAA+mVy7kHw9lK+gJr/Dltfpr81AR5uzR0LK5wB8oaKuf+swArwDTR7r8P
         gWBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725893505; x=1726498305;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f9rWAsIGzZ6u/QYJf5tnAdUimUu+PCvUeW7OogHaSuI=;
        b=EvVMz/b6xqNFpXqYTIQwDTBmZpJ59vwDzbXAnGuzNTdl+CXblHgqMh/Mv/d+UGRY5T
         ysSYJhzysQjF/qUkUhk2Prarr9zz0R5Di4JaNYYL9w4E3Uqp6i1ez3vb6HloicmwEVy+
         z8pnffRAC4SwzKJSMAme3p/HgvVJwkqdPFlBAYCq62igZGygjEsKhfYtKifgiQHRZ4P8
         B1pdZ9bHCa8ueyX1B98+bpBAaprIB9eGgnvDz/KibD17+rEUnHa6AapMg8wnY1eBd0D0
         PTcQlzxlWZeerOLbuuv9k3V8ksq+8eBRfS8qD3R8M2kIOeAGL+fn4Sdb0iAOtvHaH08c
         fbRA==
X-Forwarded-Encrypted: i=1; AJvYcCUA15o8znlfQFfzlnadrLmybZcHidy8zaJzWcgcX/2EdoNpnwtMLjC0hvWfaaVmsQUhDlJB5pkfEA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLDYmyJWU2HXJEOXw2kagaNTJ5anOx+v5At/Q3uMKYjWcekwG1
	/cukw53K9h0JAxKumHiQed8Kkd7q22gDTuJRWNwi9Tgx9OuU2/nFSSu619PuN8L0f3vsXAXKImE
	j
X-Google-Smtp-Source: AGHT+IGXmoYoNnbLnmlnvdjNnKtCotyC6KrIkej+yws/iMo0+HjJYgBJ0A65h3AE+feie3K02nBLtw==
X-Received: by 2002:a05:6a20:891e:b0:1cf:2939:a0de with SMTP id adf61e73a8af0-1cf2939a1e8mr5746386637.14.1725893505231;
        Mon, 09 Sep 2024 07:51:45 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710f31235sm34960025ad.253.2024.09.09.07.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 07:51:44 -0700 (PDT)
Message-ID: <29245c2e-d536-4a98-88ed-d1757795b3cd@kernel.dk>
Date: Mon, 9 Sep 2024 08:51:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/8] implement async block discards and other ops via
 io_uring
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>
References: <cover.1725621577.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1725621577.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/6/24 4:57 PM, Pavel Begunkov wrote:
> There is an interest in having asynchronous block operations like
> discard and write zeroes. The series implements that as io_uring commands,
> which is an io_uring request type allowing to implement custom file
> specific operations.
> 
> First 4 are preparation patches. Patch 5 introduces the main chunk of
> cmd infrastructure and discard commands. Patches 6-8 implement
> write zeroes variants.

Sitting in for-6.12/io_uring-discard for now, as there's a hidden
dependency with the end/len patch in for-6.12/block.

Ran a quick test - have 64 4k discards inflight. Here's the current
performance, with 64 threads with sync discard:

qd64 sync discard: 21K IOPS, lat avg 3 msec (max 21 msec)

and using io_uring with async discard, otherwise same test case:

qd64 async discard: 76K IOPS, lat avg 845 usec (max 2.2 msec)

If we switch to doing 1M discards, then we get:

qd64 sync discard: 14K IOPS, lat avg 5 msec (max 25 msec)

and using io_uring with async discard, otherwise same test case:

qd64 async discard: 56K IOPS, lat avg 1153 usec (max 3.6 msec)

This is on a:

Samsung Electronics Co Ltd NVMe SSD Controller PM174X

nvme device. It doesn't have the fastest discard, but still nicely shows
the improvement over a purely sync discard.

-- 
Jens Axboe


