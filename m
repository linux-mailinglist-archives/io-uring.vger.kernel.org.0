Return-Path: <io-uring+bounces-6587-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54FCBA3DFEC
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 17:10:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 283D23AA6B1
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 16:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49F6320B1FD;
	Thu, 20 Feb 2025 16:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X0sS5DHc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BCC204598;
	Thu, 20 Feb 2025 16:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740067524; cv=none; b=OyFr8q5+76lmpQJi2eynawZrzchPsO9Le3pLGyJFrlXLWgvUB7+U9Noh5Pt19iuB9sZAFxFHWNDjgjWks9iSczoyAwJx5HFRmsjywbsDdZmG0t7p4YCt9sIKsMrTBG6DEQQtsiPcuPUtedsZ+q/ziOmBqIODGxnscOK53G1CEko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740067524; c=relaxed/simple;
	bh=GxhGhsIUsj/RNCP6Upmpnt1NwQzlkRjmu4jIZMadXZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QYFDjz89jA30BP7CBEA8ubHO+29l3MSow5wJlqp/I+iUceJeUxeGlYErYVq0zc0MLxC0ZNtZjsF1IMJHnBjk6l8pcMXs35HH+KtRRsvJFhD1a3R7womWyW7emuaMw9+CadhLwQhfriKCuMrl5BKoLTH/nipkmGLXdr8yKwZ6V/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X0sS5DHc; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-abbdc4a0b5aso223182566b.0;
        Thu, 20 Feb 2025 08:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740067520; x=1740672320; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QQVBb2M5ti5brPqoVnUK7BdGzRoVIEqb1cFl/teQLY4=;
        b=X0sS5DHc0opzg7RBZ6qO7y7FAOS7ZNB0dIZW5mrzNZEP8ZkQCOMcFQDx2PXXvs/ul2
         4BKghdOtL7DXaYKLs1fdDzim8hWLAnUBvjbOgH7T2zCeH7WFVPimU328gWztcp3hQ+mI
         4ZwLN2RKx5E9f+OPwJ5lAFO02uvtKOiPh957RjJdc+Q1zjeYJUyO9WcUzeUr5ZJ/l6TZ
         BLjVuoByFr9iz9gX+ebY4mJOewNzNcxeV671Sj2OampGZXQfPNiDkZ4a7QhTs/vk8XeH
         xxVQMYq1SRgfs0DJijDj8nxC18ymU/nNaKpKGDTJWiiiFHcDm7oBnV/Z6RAahmsRFiUU
         8wIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740067520; x=1740672320;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QQVBb2M5ti5brPqoVnUK7BdGzRoVIEqb1cFl/teQLY4=;
        b=FKLItjlbLDj4bX7ZxeHcGNJfaPqmMzuYNrXRJk1GOOfZU+SNeWZCA7XYoXqMhEVJ5s
         R+62YQOhqD1n0uSngYv+Hq3xT4LjtIZ21rimKNub1MO7vD5UO3njzcX94caiHIsbggbT
         AcddkshnmZ9Zv3nkkO5dN8L2zbdYA4c+J/msNIfBB6jtYS2hqyZ+8oashmbhggQpvLjH
         NYnDDqloksJdcKQEbbJz9XCqeCfwi1Kv3tvqL78wg+Y5E0LYOmY2oqj5xkavPnnb5XwU
         yn2754MfmQeJ29xdAsnD0i9XPlaUsp40Rb2bpamWxgpw0eqGbGmUDfVmP/1c8xmpn5Ph
         HdJg==
X-Forwarded-Encrypted: i=1; AJvYcCUkVCqXblGu1b4FAn2AQZLXv+nAYfK4IhLaa17ojRTDxd4YrN1RHBz/vlPBW2WzqKcbIk65uuADlA==@vger.kernel.org, AJvYcCVd1t/hR63Tu9i8JV8u+oIzWfIM4G1H0LuF1o9So84+0y5DfOuoRB9bpwlpq92JTxHxmT9rbDLR79/75hU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc7T1/8PAVMto0ZXLxLQon6nl/rj0Ra6om35ENS2YOEQOyv5qQ
	nrpqLEvV/2HLhpYkNQJtf5+qSZPLGQMq4f961q0fJeL6r294nmDtqBWGJg==
X-Gm-Gg: ASbGnctcu4oZeJ8vmhjp0gU3RGgLxX6N/4RCCQWk2QjgVHiGDCMyr8Z7YJxAImm/VL8
	+Idxe4ugvG4Egc4MFBHqR+bPXhqPx92B009TYrq77eVujnPtlxdkCKERqjaly9xZ43X1v/K17Gz
	dA0K2/JPxEb6ORkJ4jQa1uhtvYCUY5Jj/6VtGq1XdUct0CwuMSHTKG6dvlTZGXhXo+/g58OgFv/
	adl1l98AyFlo1Rmkz2ecJMCZhkviXO5JOXOvV7yOAeOxrY5lcCxki2IL5Nkp+oe0Wg3ChNfpqeg
	+szmc0FNS8T60EHscliwrNCsvZnJn0X0XCG0w7ueFQxMxvUT
X-Google-Smtp-Source: AGHT+IHyNRhhv3ei0ZJuaFMCDqamGcD6o4pAmT2joN3wDr/ElRBS1wimDAPE/dY+d50yJ4+AoxHqZg==
X-Received: by 2002:a17:907:7a87:b0:ab7:d44b:355f with SMTP id a640c23a62f3a-abbedec1060mr339549866b.25.1740067520168;
        Thu, 20 Feb 2025 08:05:20 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:f455])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abba4b9ee98sm707344866b.167.2025.02.20.08.05.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 08:05:19 -0800 (PST)
Message-ID: <00375984-956d-4a25-aae2-e2d72a91c62a@gmail.com>
Date: Thu, 20 Feb 2025 16:06:21 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 5/5] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com,
 csander@purestorage.com
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-6-kbusch@meta.com>
 <d2889d14-27d2-4a64-b8d1-ff0e4af6d552@gmail.com>
 <Z7dJNx5yIneheFsd@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z7dJNx5yIneheFsd@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/25 15:24, Keith Busch wrote:
> On Thu, Feb 20, 2025 at 11:08:25AM +0000, Pavel Begunkov wrote:
>> On 2/18/25 22:42, Keith Busch wrote:
>>> From: Keith Busch <kbusch@kernel.org>
>>>
>>> Frequent alloc/free cycles on these is pretty costly. Use an io cache to
>>> more efficiently reuse these buffers.
>>>
>>> Signed-off-by: Keith Busch <kbusch@kernel.org>
>>> ---
>>>    include/linux/io_uring_types.h |  18 ++---
>>>    io_uring/filetable.c           |   2 +-
>>>    io_uring/rsrc.c                | 120 +++++++++++++++++++++++++--------
>>>    io_uring/rsrc.h                |   2 +-
>>>    4 files changed, 104 insertions(+), 38 deletions(-)
>>>
>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>> index 810d1dccd27b1..bbfb651506522 100644
>>> --- a/include/linux/io_uring_types.h
>>> +++ b/include/linux/io_uring_types.h
>>> @@ -69,8 +69,18 @@ struct io_file_table {
>>>    	unsigned int alloc_hint;
>> ...
>>> -struct io_rsrc_node *io_rsrc_node_alloc(int type)
>>> +struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int type)
>>>    {
>>>    	struct io_rsrc_node *node;
>>> -	node = kzalloc(sizeof(*node), GFP_KERNEL);
>>> +	if (type == IORING_RSRC_FILE)
>>> +		node = kmalloc(sizeof(*node), GFP_KERNEL);
>>> +	else
>>> +		node = io_cache_alloc(&ctx->buf_table.node_cache, GFP_KERNEL);
>>
>> That's why node allocators shouldn't be a part of the buffer table.
> 
> Are you saying you want file nodes to also subscribe to the cache? The

Yes, but it might be easier for you to focus on finalising the essential
parts, and then we can improve later.

> two tables can be resized independently of each other, we don't know how
> many elements the cache needs to hold.

I wouldn't try to correlate table sizes with desired cache sizes,
users can have quite different patterns like allocating a barely used
huge table. And you care about the speed of node change, which at
extremes is rather limited by CPU and performance and not spatiality
of the table. And you can also reallocate it as well.

-- 
Pavel Begunkov


