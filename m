Return-Path: <io-uring+bounces-5908-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 926FDA1311F
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 03:11:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E887E1889028
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 02:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4EC26AEC;
	Thu, 16 Jan 2025 02:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X9pcSY3t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88946E555;
	Thu, 16 Jan 2025 02:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736993485; cv=none; b=kiCn0yWjaD/g0hFw5OQQJFtS5bR+I1NfPM1UtlyOHPyC3wZwQ2rPrITK1hghN21eRvxmiL/XPyUIV/EZG5sMJ2zu/XvcFuDeKJC3Xz1y9oWGXfiR7LbZkuAE7Qj5hg5maQfHtX+Jj3+a87MGg7RTG+YZmJjtLBRBbdSbmbyc8q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736993485; c=relaxed/simple;
	bh=If6e7JUd0wHH3QJbKx1jLYerq1TRixK3ys7C7XgVnak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=isL9LoS15JwDH6T25sQHu75JLO9hLFWB3GNRiEQKsUepSDptzpoM30w4t3/siSETQNZuq+fV0yKsG6QuDAKKOSh3Wircekev4nSIgjs8dQOZw5etEQpI9UpjILmsSI90EjfJeCd3Psx5uE4suQkvvPUBZ1ldKzSb8fuNz439fLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X9pcSY3t; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aaf3c3c104fso86448266b.1;
        Wed, 15 Jan 2025 18:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736993482; x=1737598282; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HobMKiDrpJIwR5gQ0zoCBwyAXPBc+T1lokPO3vlcSm8=;
        b=X9pcSY3tnh7el54ysdwc5u5yFbd+hSTtGJARYKFAOVEdUkTIskc7LKw4w8GfF1cPuI
         asseNlT8FEZHlJDQqyS+lvahNIEO6p2uMqwN2Kbr3r1cHZMX8csuxSVpbpZPv+4KfRiD
         zx3Niz0oLxPzaJ6y9hzTicShUI7/b9R3fQ7pk/yQk2QDbdBTv3Jaa6rq6Yw9GjgNEXnO
         uacbnJAbsjBX76VuLxmML5LCGVwYJxWxg3SPCaYolh42O/QThbm3zuzyR+U0kKaJjlF2
         ZYHMnS8BTWPRMAI16ToG9s/AZeqAuDGvfwvkdmeSFY0zMtCgCYoMu+E9H6ONVKGGJbSh
         xS9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736993482; x=1737598282;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HobMKiDrpJIwR5gQ0zoCBwyAXPBc+T1lokPO3vlcSm8=;
        b=fLORXK22ipAxyMRIMNJ9ZyNmoKxZyEydnoGh1Dpd1lQreHLHs3Lfyr6We4TZhky2ji
         lAwYfpe9Q9mpZ+DXwTIuyTYH0gh31epgw9gocRVVwmhUGNjKC5avsECrpGFmfxR07TiO
         pVZwg/b75BNK1crCBxmGWV1VkrtwFUQ3pgRKbJ69eLf80WkBPG1d2fyGjpi3lxK4nUCO
         NfIJsKLMjGwwyrtIIhdfIshBXaI8DVfU6O5k9PCWtUdy6VbFbluEOO5aj5Us4LJhkTpT
         irwyW44eDUWENeMTbLRGeYo/+zZXZ2RJBEV9tVw1uiv66aNl7a50RanFGhE5+2QllEt2
         skvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNuHL+8dFq7Bxt8pXOpA3Q+olzvYsxA0FGGrYtC7msBAYL35PRg+bNrCYRm4eaQoXAGM+5fcc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzia0ar/ryyKDvnGeKsH+OdrhtGK35l/7cgJwMxrr8aVt3Desp0
	Pn4ti2k54kVIo9xOHYyqGUI9NceKFNiDywX54x2uA456X/UtXfs8
X-Gm-Gg: ASbGncv7zQKP+Q3bvL5xf+rivPoaenPwXxL4gB2Jaswknk4y9V+TQO0m7lulMknTQyd
	7rfaq/xrTvQlHjlUj20/Bs12Wx4d42UfQ2C5BOlRgDfK4gkOrDNmjIN/kXqZkZWH6D61rjwKMwM
	IRanYpFVablXfNMVblNR5w7YNjHQv+hyuDHdWGZfvGRa7BYGwHsiNcyFPUWfKvDEIvmHXBxwA5x
	svbTV1KuijKlBK67tGbAXKbZWkJh5SQr/9FamFEjhGNcfJj+qWcopDbhzH7hgT7n0E=
X-Google-Smtp-Source: AGHT+IGjrzuchJ0ljYWZnknsMRFzZ7MqEZ1pqMNfE9BHyvUa8D/vnsgmMOHtVVGI5jm/SQE7a0/QqQ==
X-Received: by 2002:a17:907:d1b:b0:aa6:b63a:4521 with SMTP id a640c23a62f3a-ab2ab558881mr3096399566b.15.1736993481619;
        Wed, 15 Jan 2025 18:11:21 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c9060badsm836041666b.29.2025.01.15.18.11.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 18:11:21 -0800 (PST)
Message-ID: <52fffbfb-dadb-48fe-84e4-8296b18fd22e@gmail.com>
Date: Thu, 16 Jan 2025 02:12:06 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v10 01/22] net: make page_pool_ref_netmem work
 with net iovs
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250108220644.3528845-1-dw@davidwei.uk>
 <20250108220644.3528845-2-dw@davidwei.uk>
 <20250115163019.3e810c0d@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250115163019.3e810c0d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/25 00:30, Jakub Kicinski wrote:
> On Wed,  8 Jan 2025 14:06:22 -0800 David Wei wrote:
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> page_pool_ref_netmem() should work with either netmem representation, but
>> currently it casts to a page with netmem_to_page(), which will fail with
>> net iovs. Use netmem_get_pp_ref_count_ref() instead.
> 
> This is a fix, right? If we try to coalesce a cloned netmem skb
> we'll crash.

True, I missed it it's actually used.

-- 
Pavel Begunkov


