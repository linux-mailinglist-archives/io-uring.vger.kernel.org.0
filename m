Return-Path: <io-uring+bounces-3521-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 843AD9975D3
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:43:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E58741F233AC
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 19:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A901E1A0A;
	Wed,  9 Oct 2024 19:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="E4G9Quyg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053F11E1328
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 19:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728502945; cv=none; b=AQCdOlGFskMiitUjsiNlo/r1SW69VCPFhOijy/7PzGUKDw/lFTWdMZQl7Zvdaes37zocGHMQ8gDJDrsvPPkLZvTuFh+hVhdIEP2PiglplvftdT+g+IfP073ZcRsydFxqViFvfsYQdlWsah5rTAJDgqA0kpEBNpT+Cui5CwBJBf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728502945; c=relaxed/simple;
	bh=4bhWfeG62fNGNmC5L9A4dqWFQjNQFzBo482snbJu4Hc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lsUoWroMlxrUBhyaOtzfCpzB8wwfHT85643VfwoKweFv2YUYeUSN/ccNLu76ryS3WdLiSUX/Uczn61cus7o2sJt38LLnlIyFPJW5h47uQ27UFAfo2IxpuKuMrq2zqC68Pg+ou42HvrZOJDN5c8yJwarBYMWooP1xWIGV74EGEwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=E4G9Quyg; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-82cdc21b5d8so4392539f.3
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 12:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728502943; x=1729107743; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gJpXjBZRiEakReIJjC3t69bC3OiI8d1T+4kpU6ZG8fE=;
        b=E4G9Quygy87C58+ttd9cBX95rOwnLjfHvFNObHAXAgJ78prRCNDoap0+nS0WuwsIxD
         M8NuICkUKe739P9ijMzgFexf3eHI2Z7hSxxskqikWuLoF37wJtpH2m1JBz+llGmWM0jp
         IqINbcOHWz+qwAQ+v9PGxuB7rq4uyvXK5nfCfH9f5Ad2wzvsHtLOBsX/ue27JEH5K0lS
         8JH9OV/Rx/ROI5aVfXI0BTj6VcKWa+R0Sac536cgpZqS71eoJZvkYW0iRPXI9/NneNzi
         IgKlTLkLggqi2Z06V5wS0Rhut/Ed0a/caiHpwe1Lrg+ROuYv9gMvbzJ+80/byLHXaWmI
         m6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728502943; x=1729107743;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gJpXjBZRiEakReIJjC3t69bC3OiI8d1T+4kpU6ZG8fE=;
        b=OkHuBowe10gnELf0mq/nxFHeULqSKTqgYZgArBtaqsXWmBt6+Vdri+sMOZnor7dE3L
         zY02zQD9Zk46PHav5uTXdfZIdKbZ5e30pXMPsa6UAMUwNSXm3bkB0CLKMIUtfj8L7Jnq
         rjAw2rDdIi2YjVlr2ZFQMf6MNqhCgVeXZq8tzGUHJRJMZFvhSzcVHHZxyjoKFhPihMPh
         DlPUZLrKKTihJlBVko5zh71XO5eYUwXHM7srHzqo2gE68sIA2yZvuFqXqKUK+q+RzHOf
         zKebMQgzNitqSVG8fInkJ+aJbgkyYs9KGgLbOPQqkf2h9kWYGzQmgcRknuo+LHciqH4l
         9HVg==
X-Forwarded-Encrypted: i=1; AJvYcCUST16uwQPfppEF5qBBBYp0ZtMh6YlhkBTlk8PWXPZPw9tOWrqQFU3OEiC4EJBUuxAULoJZGFH/Eg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEsyKpdaSBF3RdtkICyH/HAs0IK+je57evcieKDzYQ1J0PKIl0
	wS2MKOk8fmVhE1CUflY3yXio3DVkSwtj0V6fBfDHYPKHjDIYOqFd9hBIYTia06Y=
X-Google-Smtp-Source: AGHT+IHDnqq5hvMLhYcAnu3N0/Pn9Cbs+egv/wAfYhJpIwpbvtVnrkprtXZvezX3AW6lHdu42RSumA==
X-Received: by 2002:a05:6e02:1a83:b0:3a3:4122:b56e with SMTP id e9e14a558f8ab-3a397d1da78mr33839595ab.26.1728502942956;
        Wed, 09 Oct 2024 12:42:22 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db7a94e671sm1843896173.148.2024.10.09.12.42.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 12:42:22 -0700 (PDT)
Message-ID: <177d164a-2ebc-483a-ab53-7741974a59c4@kernel.dk>
Date: Wed, 9 Oct 2024 13:42:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 12/15] io_uring/zcrx: add io_recvzc request
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-13-dw@davidwei.uk>
 <703c9d90-bca1-4ee7-b1f3-0cfeaf38ef8f@kernel.dk>
 <f2ab35ef-ef19-4280-bc39-daf9165c3a51@gmail.com>
 <af74b2db-8cf4-4b5a-9390-e7c1cfd8b409@kernel.dk>
 <7cee82f7-188f-438a-9fe1-086aeda66caf@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7cee82f7-188f-438a-9fe1-086aeda66caf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 1:27 PM, Pavel Begunkov wrote:
>>>>> +    /* All data completions are posted as aux CQEs. */
>>>>> +    req->flags |= REQ_F_APOLL_MULTISHOT;
>>>>
>>>> This puzzles me a bit...
>>>
>>> Well, it's a multishot request. And that flag protects from cq
>>> locking rules violations, i.e. avoiding multishot reqs from
>>> posting from io-wq.
>>
>> Maybe make it more like the others and require that
>> IORING_RECV_MULTISHOT is set then, and set it based on that?
> 
> if (IORING_RECV_MULTISHOT)
>     return -EINVAL;
> req->flags |= REQ_F_APOLL_MULTISHOT;
> 
> It can be this if that's the preference. It's a bit more consistent,
> but might be harder to use. Though I can just hide the flag behind
> liburing helpers, would spare from neverending GH issues asking
> why it's -EINVAL'ed

Maybe I'm missing something, but why not make it:

/* multishot required */
if (!(flags & IORING_RECV_MULTISHOT))
	return -EINVAL;
req->flags |= REQ_F_APOLL_MULTISHOT;

and yeah just put it in the io_uring_prep_recv_zc() or whatever helper.
That would seem to be a lot more consistent with other users, no?

>>>>> +    zc->flags = READ_ONCE(sqe->ioprio);
>>>>> +    zc->msg_flags = READ_ONCE(sqe->msg_flags);
>>>>> +    if (zc->msg_flags)
>>>>> +        return -EINVAL;
>>>>
>>>> Maybe allow MSG_DONTWAIT at least? You already pass that in anyway.
>>>
>>> What would the semantics be? The io_uring nowait has always
>>> been a pure mess because it's not even clear what it supposed
>>> to mean for async requests.
>>
>> Yeah can't disagree with that. Not a big deal, doesn't really matter,
>> can stay as-is.
> 
> I went through the MSG_* flags before looking which ones might
> even make sense here and be useful... Let's better enable if
> it'd be needed.

Yep that's fine.

-- 
Jens Axboe

