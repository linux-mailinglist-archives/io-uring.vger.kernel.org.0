Return-Path: <io-uring+bounces-1543-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BEBF8A463E
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 02:09:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55597281E4B
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 00:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAFCE634;
	Mon, 15 Apr 2024 00:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CejU6EOE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E73936B;
	Mon, 15 Apr 2024 00:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713139737; cv=none; b=Iv1mi45E9WJO+emCqYDyFCup7E8FM1yfrgGGjPkCNLUw/FpxVkjIu0snAAsvrzWXvQrOLZU50ksf1uleTbbtY9Ktyr8rqizccqRafGr+TOF2CxYMnC0AakKAKv7qtjRa7meTh7tucF/aIaeWJX8PkoXycdHC7GyHde2yhfoemCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713139737; c=relaxed/simple;
	bh=RAtrPn9LIJIjIRfdE99vo8j0a4jE5tS1h5TSS0lmAWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m71goIHJP/LryCm1HBZaC09SHEsFuOBpYTXNobSnMwgj5qwaALghuk0FhimYrII05PFlRl2M/vP+oGyQjhUhaWhXCBERcMaNhNaBVzXeHrK8Dge6So3EqMwmC4U6ZhORQs38gS3s+dUpl2kA4vGNYfpgXZXRrDN6wGcKW3fIcJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CejU6EOE; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4186e93b9faso182185e9.0;
        Sun, 14 Apr 2024 17:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713139734; x=1713744534; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ncthlo/v5qsu3DftyrtcPgP/aaTqW1pG0v6SXB9xGXU=;
        b=CejU6EOE9oKe5qQpyMXTtkcdHsMEEQ5zi3ekVZQzK6g4i8OfagTOC1rSLzu8q0r3VL
         AXj5XMKJIEKt//ZdqpXSjkmcWxGdQqqJFgAcg9/kSRpS1+tqmFJMYDJvyJnhsW7yD/SV
         UaHzsD0Hy19Iqa4hvBOxjoV44z4fG/d7Cy1DlEUI+952niczUrz+ankOndQTIRCbWxnp
         oC8ug0xHuNJIEIdgrXnGfdH9dkJlQo7oxZGCGnZcsg6ZJ6j26rFGzADe/tPpiIooVY9f
         veWiVIWvQOvRO2cyBhqXBZlnFK637maIDl4rFuR8xkpg9WJrDkg3v34WMNLyRu0V5cgE
         wISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713139734; x=1713744534;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ncthlo/v5qsu3DftyrtcPgP/aaTqW1pG0v6SXB9xGXU=;
        b=AYdmGublM9wBBBFCEhwvVsp2BAYIcyhC6yLIvfqB+RRHZW5Y4V5Idpl/mWI9p4s06i
         WfPBCRsAndLw8+01VyCfZ06eTYSP4p3WIAvdI16803k1vmIN5JLqJyCAxGCRLcdDEMSC
         jhWLItDPsKw4fab48V9fy8vNXTaprqIFf/dGgfH6nR6NiW/vcA837JDyHaGaAqJ4hnlU
         aVjrzITshEAkJmL2Ds7s5PNIoLipxU+bdAxTjYI2Om8ps5asO7w4iH4lT6KtZYpjL9y6
         m3QcPr+WvinY0TAdycqZa/f1NwpEl7MHG9R3Tf4qQsUHPE5NDAnvnlNrBNivIPMr6chF
         naYA==
X-Forwarded-Encrypted: i=1; AJvYcCUDc0pZNLZqWPhEh/kRz+uBJx+djrv5eDD4q1YsCL2I/OL5YZtOJ1U+M3OQlmcQkb4OmzXbTpQh1rRdxNvSKzfix79veGVNJwsIaxUqVGzN5mlG5enlZxU0DPPkn7wMZ1M=
X-Gm-Message-State: AOJu0Yzy1q/0baJN3SXcrK/4/TtKhSLbro7o1cGlVRwgFvoSQjR2pOBG
	I7KsXMOdEu9eBGyVzSZ/EBA+Sxz+RxhMb3VkyBcg9bCOyKTIS7af
X-Google-Smtp-Source: AGHT+IHQvV6Ji7+8b/FdO6L6/tHmuw4m1Er8ZQrGENyxPmDQxz4bbW3E+xE6KszuhXz8jAzjTUOA5A==
X-Received: by 2002:a05:600c:4fce:b0:415:8651:9b8e with SMTP id o14-20020a05600c4fce00b0041586519b8emr5879906wmq.39.1713139734397;
        Sun, 14 Apr 2024 17:08:54 -0700 (PDT)
Received: from [192.168.42.114] ([85.255.232.172])
        by smtp.gmail.com with ESMTPSA id l23-20020a05600c1d1700b004163ee3922csm17113708wms.38.2024.04.14.17.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Apr 2024 17:08:54 -0700 (PDT)
Message-ID: <bbf9cb47-d022-4711-8d73-b035275519a7@gmail.com>
Date: Mon, 15 Apr 2024 01:08:55 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/6] implement io_uring notification (ubuf_info) stacking
To: David Ahern <dsahern@kernel.org>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
 <cdfee62d-32fe-4796-8265-d77f678c3d78@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cdfee62d-32fe-4796-8265-d77f678c3d78@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/24 18:17, David Ahern wrote:
> On 4/12/24 6:55 AM, Pavel Begunkov wrote:
>> io_uring allocates a ubuf_info per zerocopy send request, it's convenient
>> for the userspace but with how things are it means that every time the
>> TCP stack has to allocate a new skb instead of amending into a previous
>> one. Unless sends are big enough, there will be lots of small skbs
>> straining the stack and dipping performance.
> 
> The ubuf_info forces TCP segmentation at less than MTU boundaries which
> kills performance with small message sizes as TCP is forced to send
> small packets. This is an interesting solution to allow the byte stream
> to flow yet maintain the segmentation boundaries for callbacks.

Thanks, I'll add your reviews if the patches survive in the
current form!


>> The patchset implements notification, i.e. an io_uring's ubuf_info
>> extension, stacking. It tries to link ubuf_info's into a list, and
>> the entire link will be put down together once all references are
>> gone.
>>
>> Testing with liburing/examples/send-zerocopy and another custom made
>> tool, with 4K bytes per send it improves performance ~6 times and
>> levels it with MSG_ZEROCOPY. Without the patchset it requires much
>> larger sends to utilise all potential.
>>
>> bytes  | before | after (Kqps)
>> 100    | 283    | 936
>> 1200   | 195    | 1023
>> 4000   | 193    | 1386
>> 8000   | 154    | 1058
>>
>> Pavel Begunkov (6):
>>    net: extend ubuf_info callback to ops structure
>>    net: add callback for setting a ubuf_info to skb
>>    io_uring/notif: refactor io_tx_ubuf_complete()
>>    io_uring/notif: remove ctx var from io_notif_tw_complete
>>    io_uring/notif: simplify io_notif_flush()
>>    io_uring/notif: implement notification stacking
>>
>>   drivers/net/tap.c      |  2 +-
>>   drivers/net/tun.c      |  2 +-
>>   drivers/vhost/net.c    |  8 +++-
>>   include/linux/skbuff.h | 21 ++++++----
>>   io_uring/notif.c       | 91 +++++++++++++++++++++++++++++++++++-------
>>   io_uring/notif.h       | 13 +++---
>>   net/core/skbuff.c      | 37 +++++++++++------
>>   7 files changed, 129 insertions(+), 45 deletions(-)
>>
> 

-- 
Pavel Begunkov

