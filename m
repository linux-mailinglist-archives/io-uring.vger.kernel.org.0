Return-Path: <io-uring+bounces-4442-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD8919BBFF9
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 22:24:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A4171C20898
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 21:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 348AF1FCC63;
	Mon,  4 Nov 2024 21:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D/h1dYv8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8042F1FCC56;
	Mon,  4 Nov 2024 21:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730755475; cv=none; b=jw9naa+w15eXCwYXf6jaXOE+UOZt7gFkuAQngZwuZ2jyuAyUpz+DLaHbMmABX1es9UXxKMdBf+6aBQTZeQf4w7f9EJMlTTBbVevGlpSDRprE+QYj1SAQ7sBnQ9VHElq4QTOkLpgvsqk6JwYx+CXrlHdj3W2KkdKo6rBBWktHbU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730755475; c=relaxed/simple;
	bh=KgmA9O/yjGXwPaEUwuagbYj6lZhVVXxgV2/KRNTMY+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SkTiOYmMGdwRK/t8qzwwCNAnfVVb9rTU4t8IkLzQbIB5LEKY2UWXyO5NKhentHoCIhakqvWQcrUl+grl3I8NMTNHAdCQNIFi3l3FCRCJQQiUf2gbLuZPw+wo7JPWfA4ssjNEyr8SMKJ8Joew2Ybfc4PbFCTUkgTmtJghFy4tovI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D/h1dYv8; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-37d447de11dso3715572f8f.1;
        Mon, 04 Nov 2024 13:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730755472; x=1731360272; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jNxM0Q8uHull7FrP6GsWQNVGnPpvVtnGbtMk1UqNzYY=;
        b=D/h1dYv81GGaxYpgdk/NUwz6IMqg9cJMZYIHqHbOpSa7N5DRijE1uRtQtZsU/poraT
         /J383UQcGO4w2D7FED4qkQEmc+lIgqzpIOLYKq+zQOmkEOwLKRi1gluT92Bn2WtN0gu1
         zTceLvigSMGaUA18mWPr8p4ZNoWIuY1JKV3a6k9qpSOxvP4pk+9gLL7KV++DF2gqcCth
         WdoXWjO7P2zrkAKaGTfpcntl0v7xRAVcDeCrIbEp9wh/ZmjQWulyMv/yo7u4hXP+HwLg
         nr4gbAQXlFC1IgDL+4BUz4rO8ealWpTIgFfdXb6XWWKOU62ItsMmL7lFM+xH98W/2wSV
         BGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730755472; x=1731360272;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jNxM0Q8uHull7FrP6GsWQNVGnPpvVtnGbtMk1UqNzYY=;
        b=lscqqMb+vQUxI8E8CGNwoJVLMvCMM5JWK/F8kXybti0D5WsY938j60M4bfTGHxzLTR
         V+AYW8mo9oLZ9ceAJyJBC7h6gtb8xjTXjkJgjI5UXj7xtwgCzPVqsrXWSZ0z80fCNT/j
         BcMSJjd2ah+EAbYA8wtu4M7RDxRI97pF6nS+jqeLL85CSRZTuUsznLaB5ArmQZJjukIZ
         H85TYsY6ckJUiB4cmgQ2TRK2+zfembYeL2pZl5F1GsuFdLQmVd7q6PE4ZYukrgsw8xeF
         gJas/PWXFVI8j5dSNGsZYMy/PfQRoLWF1ogRF8LGdc42NXJ9l+GDYYeSl5NBD82qBbOD
         gKfA==
X-Forwarded-Encrypted: i=1; AJvYcCUrcQaFRkYJxagx/k/jRm3udz1mwohT6jppJladJ+0fVBO7oDCSshHBAaVCtO3+bsOcdccH5vJAYw==@vger.kernel.org, AJvYcCVmoKrHE8V5oo3en8I7N/sDb9roBRqWMDzQZ7GCjSAfrJbCkOLRjtT9lKVk2SrTk/hmVh6H4NZH@vger.kernel.org
X-Gm-Message-State: AOJu0YwL020BybaJnjWKdHizHLG6gN3tFAvec70UekXzM22j9Xxm2K1Q
	8LKJ8B5yQ2KAd4Ors8OLA1LPtMdW3mPCOA7sEJ8oXyaLPkqbvhjs
X-Google-Smtp-Source: AGHT+IEpGUh8/ter2vp6zfChTBfkrbI4jytOtcNwlXgcvbC5os9jnjButkvYagv3VQZY4vC4Abzyug==
X-Received: by 2002:a05:6000:42c2:b0:37d:f4b:b6ab with SMTP id ffacd0b85a97d-381bea29202mr11542049f8f.59.1730755471580;
        Mon, 04 Nov 2024 13:24:31 -0800 (PST)
Received: from [192.168.42.103] ([148.252.145.116])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cee6abfcbdsm322417a12.37.2024.11.04.13.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 13:24:31 -0800 (PST)
Message-ID: <b966d211-26de-4796-9e54-5b464a565b7c@gmail.com>
Date: Mon, 4 Nov 2024 21:24:35 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/15] net: prepare for non devmem TCP memory providers
To: Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-5-dw@davidwei.uk>
 <CAHS8izPZ3bzmPx=geE0Nb0q8kG8fvzsGT2YgohoFJbSz2r21Zw@mail.gmail.com>
 <5b928f0e-f3f8-4eaa-b750-e3f445d2fa46@gmail.com>
 <CAHS8izMTuEMS2hyHs0cit0Wvo3DcuHxReE1WS-crJ8zDTs=_Wg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMTuEMS2hyHs0cit0Wvo3DcuHxReE1WS-crJ8zDTs=_Wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/4/24 20:20, Mina Almasry wrote:
> On Fri, Nov 1, 2024 at 10:41 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>> io_uring originated netmem that are marked unreadable as well
>> and so will end up in tcp_recvmsg_dmabuf(), then we reject and
>> fail since they should not be fed to devmem TCP. It should be
>> fine from correctness perspective.
>>
>> We need to check frags, and that's the place where we iterate
>> frags. Another option is to add a loop in tcp_recvmsg_locked
>> walking over all frags of an skb and doing the checks, but
>> that's an unnecessary performance burden to devmem.
>>
> 
> Checking each frag in tcp_recvmsg_dmabuf (and the equivalent io_uring
> function) is not ideal really. Especially when you're dereferencing
> nio->pp to do the check which IIUC will pull a cache line not normally
> needed in this code path and may have a performance impact.

Even if it's cold, all net_iov processed are expected to come
from the same page pool and would be cached. And it should be of
a comparable hotness as dmabuf_genpool_chunk_owner accesses below,
considering that there is enough of processing happening around,
it should be of a worry and can be improve upon later.

-- 
Pavel Begunkov

