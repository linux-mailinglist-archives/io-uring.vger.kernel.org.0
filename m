Return-Path: <io-uring+bounces-3540-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 319D3997860
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 00:18:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E524D283256
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 22:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C0B1E32A4;
	Wed,  9 Oct 2024 22:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HqgRF71x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CFC192D67;
	Wed,  9 Oct 2024 22:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728512321; cv=none; b=bDTvpnuHx8XMcIId8/4hr6fdcpuGHjbTe0KT0pvRfHy5p+75PFmqtkZfahQ+uAc6lsP7/ZxnsfqVrMitCNzEtMlXk5zVqfbJyPtfhtiMqM2TGc8QRtElNRkHcEiWLv6MbF7K7/xLMQhdjxT77vSdxfUcc+XQdYHELPsMsCM8Udk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728512321; c=relaxed/simple;
	bh=nhNVFn0IuqZ2uDoBBgWdVCv/BSnLuK3yZcTvZQhLrsg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uZWixJAVTvMzL2gtPyOvvQcKKXiSgHZTNjAloV1c5hzdTCu9DoxDCrjJdZahh7XRoh9r1Veezf9HiRYplQnES6aYn3a7hULBX2YcJIrP4MjUTJgu+QsNn1dOGI4C15CC0KA2STNXACyIhiHzyN7sWBO9Fi4T1HIUu45nrNslpsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HqgRF71x; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42cae6bb895so2032235e9.1;
        Wed, 09 Oct 2024 15:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728512318; x=1729117118; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qJ/0BiXkDj6ZYPT8cU0nKVYivBhWBPinOeqjItbFH04=;
        b=HqgRF71x3lEZda+Q5qHCmU6YBk6yjoHh2jqbhL69x475LN1jZOCzIzpxHhKhOZ7ZEU
         TtBoWqd3Ad+R3Ay6oEPs54ruafxdqb1JyTNEbdiYOAPCBYnUuCOthAAcJHLJ8yVBLhZh
         6GjcVITzfOXBy4BxJu77Yd/h/l9To8qIm7sunTtnCNw183VuYybJGV263D8BJiw1UcGB
         9Ng+r+BW2VwE6fTGQ8bLWx/GiVdjkKwUX+xFaWVP65mWgGXWskXcTL5h9VvIT11bCiN1
         GOvW7VH2r33HhZ/HtrG46S3KC28FTro342OWv8cRHEK28ZKXqGxN0H54kKyUYhr9HIEt
         y1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728512318; x=1729117118;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qJ/0BiXkDj6ZYPT8cU0nKVYivBhWBPinOeqjItbFH04=;
        b=JuD0XQVcljUo13gu3Aj6h0uIXkPYL7T7Pc+bG5+vQjAGkkPrnQnoL5WkWAIhxver4c
         JVYO51htL6tyRu36oG7baw1T0TvrAEuj8l6+XZEbgi5xhvWSShGxYsC/OVONbeF3NfUB
         dHDClImDBMtmjG7v+uxaO+Iccx3Yww7C8JBn5GV77fLX5q8ykeZuS9Heiq+iQ72tCuvx
         5nfQUdKf0jNns+Dizum0w/AwbbGxGoiWh1NuOS458ZE0VjUW4o5AoTBaevdQDopdydkG
         RSi3HP3sI8I2BZaiuzWG+6xxy/33DqZsR6E5KhDq706LKki176ii8sUJlLZmcQ53rtKQ
         XYgA==
X-Forwarded-Encrypted: i=1; AJvYcCWYJJQSSGQ0GFeBEJmpHphiaBgaQHpYlKAOMq9dC1iBuRiIVW+AsLOvaKtBXnfOzCxEWoBKrQE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvJQgI+f5OHul7tFlDBLN6EF4qGaHPJJK7nshhKlvTRvOXZuXk
	Rl2Ga/RQKTP1G552W9timWD0TpQpBEendfClQuInkBNczArNDQNuqwWuNw==
X-Google-Smtp-Source: AGHT+IFAIt0XWccOY7EBeJGtIXekoUShwKn8c85/ivh5pr3kJSOMXgZnxppXeVeUqvpliOUwq0sGNg==
X-Received: by 2002:a5d:6349:0:b0:37d:45c3:3459 with SMTP id ffacd0b85a97d-37d45c335eamr1593074f8f.21.1728512318019;
        Wed, 09 Oct 2024 15:18:38 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.140.94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d376009a0sm3759233f8f.88.2024.10.09.15.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 15:18:37 -0700 (PDT)
Message-ID: <7238e811-adb5-4c9a-a5ce-43e9c13bd738@gmail.com>
Date: Wed, 9 Oct 2024 23:19:12 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/15] net: generalise net_iov chunk owners
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-4-dw@davidwei.uk>
 <CAHS8izMyOur0_SCrh8CJet2xeW8T39CC8b9K3hzfn5fh7hVB6Q@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMyOur0_SCrh8CJet2xeW8T39CC8b9K3hzfn5fh7hVB6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/9/24 21:44, Mina Almasry wrote:
> On Mon, Oct 7, 2024 at 3:16 PM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Currently net_iov stores a pointer to struct dmabuf_genpool_chunk_owner,
>> which serves as a useful abstraction to share data and provide a
>> context. However, it's too devmem specific, and we want to reuse it for
>> other memory providers, and for that we need to decouple net_iov from
>> devmem. Make net_iov to point to a new base structure called
>> net_iov_area, which dmabuf_genpool_chunk_owner extends.
> 
> 
> Similar feeling to Stan initially. I also thought you'd reuse
> dmabuf_genpool_chunk_owner. Seems like you're doing that but also
> renaming it to net_iov_area almost, which seems fine.

I did give it a thought long time ago, was thinking to have
chunk_owner / area to store a pointer to some kind of context,
i.e. binding for devmem, but then you need to store void* instead
of well typed net_devmem_dmabuf_binding / etc., while it'd still
need to cast the owner / area, e.g. io_uring needs a fair share of
additional fields.

-- 
Pavel Begunkov

