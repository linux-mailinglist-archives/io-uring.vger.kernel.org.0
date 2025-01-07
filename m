Return-Path: <io-uring+bounces-5698-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2BC0A033AD
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:03:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7D6116466F
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 00:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7630515A8;
	Tue,  7 Jan 2025 00:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RGZM05f4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDF14A01;
	Tue,  7 Jan 2025 00:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736208234; cv=none; b=ZRopawfSWHEavNE/2KfgNsdk8zNL483Jdhpyotcu6EeoCAsCc0VlzWNa6SFbupvgaZMBqwohZN1m2GUJpiNMFAra6fDX0xoYKf7in3CKmgamTAltUYLVqfYBmD7Ezpx8GxVPkryfHv6C7pR/vnnXoaYBM91hyN7wI6L05Ma4LTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736208234; c=relaxed/simple;
	bh=zPftNuwVLC6uUamaPi3T0AKffRXCxxn7UNjzChRurrw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=owI5CLjyPrJ5ouwGwwkY07mBkb3QPGrO/GJNffjPH1y33UdzC6sJJLWvxez76bgFNS/uPwKcFo1mx4zktN0F+7VOMjHc9E/Q/vJ/a5E5SopQWZp8wD1nOdBOcB0UdE+/uNux00XB3fhiORr9709wZDFpwSIx8J3BsQZGZP+u7eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RGZM05f4; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aa692211331so2870549966b.1;
        Mon, 06 Jan 2025 16:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736208231; x=1736813031; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wm9FEINY2vMKaqEAhN1bvr9GD5DoxOVx3XbzLcR2SZI=;
        b=RGZM05f42UhajEudqgrLVYVX9m57lbutX4T2+TIVKaUObrvugVMOEsznpV1JvtHKE3
         aKZN+fl3sCcWZF2oyuWMUWTS2g++2JINtlQhDzzT8CTZZFXOHIuLwA9Aw5DolyxuYoXO
         bN1KFrT+stAtpu+Av7Vg9xRv4l3+Ao2GM4pL3jgjZ9gU3v77/nmbwxu2bZBWW4woQQBp
         YlaASC84BoUtfwW4zLSe0Y6e7KX/xXTWibWwtEupVEikNBwMLTYz68bQS5dpwdXDjiK1
         Fx6wj+M39v0T0bM4IwAltM8HT/fgzdwN7Ro3rbZomgmE5tKtdmYOC+NsF5N0ByTvokTi
         hSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736208231; x=1736813031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wm9FEINY2vMKaqEAhN1bvr9GD5DoxOVx3XbzLcR2SZI=;
        b=NvcnZZtjQw2u8tDVqHLb5gQO+r2blIfJqMsBB22kS81Vxqz/frWK53hAJfULCxVUbI
         3Z1RHfHFj5En9mzThn0v7nrW1dswvE5SDMAEk4kALQkTPjY3eymyVvPxuWszhZEmYYxW
         nxPQ4/3ejXMiGdVGEmzv3KcnB9qFrz3B/OZdpF0eRhMVTQzZPMRBaom9urSYsswgTWHV
         ZeEqdiVEbjKuT7t3FcMZZtmdtNml1Y3YIjGMIUIS6XUUBH3tWuBqVMbFXfmxyfrITCyr
         JkEvL5fduhYlPU+TyfIgqk4xIekBjiqChuRxJGvmtymjcfyQy3VLYkb+Ad9lLEKkAAGd
         I6qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeUYmtFtIuUtg5eGMYAQDx/5gfYYjZjeffyCXulvh6HHPVoRjGjFWBNfMMwgBp8Wb/7IgWyEs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcqeDfZgXCJX7H6tnVvDNPJUqVEVhQknlIiJwDTMEXFFqAGZH8
	K3M4sfjqg1CJeBDnA3p01cLRiySncf8N6iOwxgsOAKJEjia0CtQY
X-Gm-Gg: ASbGncvu5Z3Bn10O369zQt6XSP7ldKQ0kLiidqHW+O3gKiagmdF5hQhMmIm2K5gNwV5
	oRfenxnUIEO57DxjWZApL7CD/ISVn1xCjWKQG6c/fJy6DfASQdgQSVVph8SVTYLix8EJXMsahIM
	1kIHRurOzjsuynCVqGzhE5leIJEb95UmTwHa5AV7jzsBMk2FwCRTmizD33o/NNyaI6Hm72Ss1BZ
	d/oLRhqrJ4/ku0RFyYniVLAZiCA6UjcEjLJvLZikLP8WIekxd3Y3OpVj+9UbB2lYQ==
X-Google-Smtp-Source: AGHT+IE0oJvC61p8YC4wLcfipBLmjVs/UeG39VrY0+NEAELnuNM3Xx/Vtu3Dqi74yhv7lhgadmpGJA==
X-Received: by 2002:a17:907:7ba5:b0:aab:f971:1f73 with SMTP id a640c23a62f3a-ab2918fdce4mr83839266b.22.1736208230597;
        Mon, 06 Jan 2025 16:03:50 -0800 (PST)
Received: from [192.168.8.100] ([148.252.133.16])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f0160d3sm2286663166b.164.2025.01.06.16.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 16:03:50 -0800 (PST)
Message-ID: <dafcf456-5153-49ea-91d8-a8242d3d4f13@gmail.com>
Date: Tue, 7 Jan 2025 00:04:49 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 11/20] io_uring/zcrx: add io_zcrx_area
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241218003748.796939-1-dw@davidwei.uk>
 <20241218003748.796939-12-dw@davidwei.uk>
 <CAHS8izNCfQjhmywd=UQgFpk2OQZinnWcz8beZTROzJ33XF55rA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izNCfQjhmywd=UQgFpk2OQZinnWcz8beZTROzJ33XF55rA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/6/25 22:46, Mina Almasry wrote:
> On Tue, Dec 17, 2024 at 4:38 PM David Wei <dw@davidwei.uk> wrote:
>>
>> Add io_zcrx_area that represents a region of userspace memory that is
>> used for zero copy. During ifq registration, userspace passes in the
>> uaddr and len of userspace memory, which is then pinned by the kernel.
>> Each net_iov is mapped to one of these pages.
>>
>> The freelist is a spinlock protected list that keeps track of all the
>> net_iovs/pages that aren't used.
>>
> 
> FWIW we devmem uses genpool to manage the freelist and that lets us do
> allocations/free without locks. Not saying you should migrate to that
> but it's an option you have available.

It's not the hot path to care that much, but even then lockfree
is not always faster. It's naturally batched for allocations
while genpool does enough of work including at least a couple
of atomics.

-- 
Pavel Begunkov


