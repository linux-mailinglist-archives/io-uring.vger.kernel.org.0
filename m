Return-Path: <io-uring+bounces-9311-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BD7BB386BC
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 17:35:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A20DB1880188
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 15:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D3A2C2347;
	Wed, 27 Aug 2025 15:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NbEKRGsN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5753929B8F8
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 15:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756308923; cv=none; b=ALyqoOUnJ7bAHY0toyo46umuZum5txTW0QMBzFy9QB37D/hoXNHPPk6G9ey5zR4U7SLa0R55rjxj4+tX9pOox7q2su96nM7dWAoutJ0LsxNq2OcI34UzqmNHBXOx2t5UM2SrOIb2EqYav9ZMzML9xIif2WfkGwWBjZLhqvqrbzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756308923; c=relaxed/simple;
	bh=G09kD1/VYChZgo9Zu3s3ew76Xv6i3z8XzfReUAcDMUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aiPnMocaoF/DqozSEsixgyJGuNXBqobWKmyhnYLh9Kn3015qwszqII3jt8DIk7Rofi2tWn6RB+X4piD/si3V1OhK/fSZpIeKULoOkIbsxUoVLeAbnRW02UoaqOlhrLOK3HncxNMRsmyehRMUqsHh8FT8oeO9yzb81g1sMd1+7WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NbEKRGsN; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-88432ccd787so498239f.0
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 08:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756308919; x=1756913719; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dj2uZkG/sqGrFRj4wPvT/kH9qhX8Ko09fzIejSXEAVk=;
        b=NbEKRGsNg4n+sRF73mPyAdfzYJyrJ9MTeq2etYWP4W9Mg7yPmZlKeTjiVk7HslRjwr
         rq/ayVBtIll4xE9zEvsUbiUWB4I1Fo4qzQ6jK+UcDX3daffeSg/03Yx6cfYtw8VBr9A2
         RD7cf/JyxHXDR+V350FaWiXu3TPeO7y7Z7PgsCAQ8XZFaA/sKUPVt36Huft5hNjh6pgf
         O0uB7ATgIjtn5Uj6dBe+Rqxin8yeA6jEeS1oQYq4Q4jMLtSEjaT45gh97ORd+710Wbyp
         X94lGxwQ0VVOEyUsOwus3AZnpodRaHsA6aO7GLhnzA8Zs2cb0Zj6zPJnNA3z26fObTsL
         t3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756308919; x=1756913719;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dj2uZkG/sqGrFRj4wPvT/kH9qhX8Ko09fzIejSXEAVk=;
        b=N09RhNQI3YhROpvNLB6juBlgFjXzGC4fwYis3aNfmimYLWq35KxcA9kW2pRoysrv+3
         VbcvEE47X8DR4jYDBA1H+GQoifI6N7/GePXM8dmZqp6Qph0hs+ItxGDWqwHOdYASdSVv
         GHBgstupw9+7vC5QRLG3PXUlyBsd0knoyUq0JK2bbPjstAGHDQO33XLXTAvn/83IeqjD
         /lV7riZv8mARKGHCJycGxgEHM+sKDy4BYkZaXzALu827pDijyV4ILnN0AqgJXIRnnyAp
         G3LhIXOXk8fH5LeAnKLU8fqOHstG3wcBjVD5dIkwDAR+h8r7LVfMaHOMx+k9ZhA8qcU8
         8uBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCrYBq5Wy4cG53EuVkrSj0l8cUnm3FJw9MlVwWmTg7MbicHf1grz+q5/uajqY+yoMZpof09IRTrQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzZZ9/65IrL7ryA2oQo0At1C0zUu7ab0PrN6LL9tozIiobuBLWr
	hKF8VecScNnJbGvL7HOziyXmlPjgw/cw2bni11vQYqIQbgl6tQpn5F6AQvsQFgNGztQ=
X-Gm-Gg: ASbGncvFpiBWxHRPbIPoEYHHQTsXz7cIu57WGHCxzqwQ0u51DtJvjsdthPH9BKnv3SF
	6wqKbdeFL70ON2Yg7HMjlqiixQSNVUru2hxQE557fD81ko4/pDh66D7OBkBHvvbeLQhZMtQlp7w
	3HiKLiqSbBnCJ5J3QTIOiVt0txeLDrm/yKVeYG+0H4+vsWNjU9zSZ4VM8F8qEkytPD1b5THt11a
	prfF5Mx1ja8/kX4S1hc9yToK9K3LzPagEfFRyHJUym0Zb/JuzlAU9Ja4B+nTgizuwpbQrzwXcTF
	3CVxF0VN8LPWDeEZ6nfvZh7DPm7LEM8+xnuHda68riUx7vaI3+NnzGMd4uH3/pa0iV7vFX0zzyX
	5KX2w6zKUTGrbWcjAfDg=
X-Google-Smtp-Source: AGHT+IFoLuquOLYHLz0Jt47HW1YimKY/DLpbXQdc4hQYELdvOAqC3pPSrHwgRim25HIe56oDM/rfxg==
X-Received: by 2002:a05:6e02:2306:b0:3ee:78e4:aff7 with SMTP id e9e14a558f8ab-3ee78e4b04amr107960405ab.6.1756308918696;
        Wed, 27 Aug 2025 08:35:18 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3f0821080a0sm7598385ab.9.2025.08.27.08.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 08:35:18 -0700 (PDT)
Message-ID: <271e1f16-3651-4bb7-a2e1-ef447d37ba8c@kernel.dk>
Date: Wed, 27 Aug 2025 09:35:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 0/3] introduce io_uring querying
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1756300192.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1756300192.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/27/25 7:21 AM, Pavel Begunkov wrote:
> Introduce a versatile interface to query auxilary io_uring parameters.
> It will be used to close a couple of API gaps, but in this series can
> only tell what request and register opcodes, features and setup flags
> are available. It'll replace IORING_REGISTER_PROBE  but with a much
> more convenient interface. Patch 3 for API description.
> 
> Can be tested with:
> 
> https://github.com/isilence/liburing.git io_uring/query-v1
> 
> Note: RFC as I've got a last minute uapi adjustment I want to try.

Nice, was actually just dabbling in this yesterday, there are some
half assed patches here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-features

Your patch I had the identical one of, but moved it to a separate header
instead for adding more limits.

But I like your query style better than Yet Another
struct-with-resv-fields. I think that direction is good for sure.

-- 
Jens Axboe

