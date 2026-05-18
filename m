Return-Path: <io-uring+bounces-13395-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLPWGcEKC2o0/gQAu9opvQ
	(envelope-from <io-uring+bounces-13395-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 14:49:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E9A56CFF5
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 14:49:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D72133038115
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 12:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 251C24218A2;
	Mon, 18 May 2026 12:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ldE6kcPi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6310C41C2E9
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 12:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779108024; cv=none; b=fKqQwgV4aaZm53hp/T//XxjmFefqvtsov29DM7WSL1uvDZv/9Ix3BSpWsVI6tQMovemfvaq0bxQaDdtefZmZOgL+035cg8iCmRDVTk4FbgW313/2yx7VDvebCzoxX7fv0MWa5P8DaM28p5J+yVBKsIU6KlCo/0ZHTVtVa7CD4pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779108024; c=relaxed/simple;
	bh=Mcv0gCsXAUFhkjqy5dwsfsmky6PBnJ9/bZQl4jFqXoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d1LXzj6EnoLEvjxYlh5SlYy9L1frdRZH7opBeA0nMP0EPM8wdm3Of5LGYFg3RmzyGFURcEnLF3e8k0ZVkbWNOdL6BGZhtqRaR83rqZV5TkC1PyQB3ltSEChSIkfH5o/6ATIT0t9EEOWUpcjpBSgnjZuPdSbSVpvAHrziLuyy+VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ldE6kcPi; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488a9033b2cso16779415e9.2
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 05:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779108021; x=1779712821; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QXVLM8myHSCmhmEigozDJCG9BugvlW9svyQsziHjoMk=;
        b=ldE6kcPijQ/Hej3uTb2mO+vEIefs2sqY1NKId/V+147wlqd3oqIKkGon8DEsKZa5dk
         T6Ix7dztbeyZ45XcmyYdewf/zIUmYooD3KWj+I7aYQaroDlRCD/Al3Nz/suqK0DJrB9n
         hpmHIKEFi6UPyBYwKC7D4LacIPfYR3QPnxbfoKiQH5ZcA71vDhee1bs+jArrNZY8nOY/
         2fZ/a7g7sOa9ZQtdBWmCI252Pz4WOB+qrC9s4x4nmAJ3LtQlj+uC35X9HztbaGmDWYZu
         MSFcZajGYOABIfHqGsgYm9Tp0nsR2VcLRag533bANJQsH90f3lv2QHY5SpF3ElD9n196
         0Gjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779108021; x=1779712821;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QXVLM8myHSCmhmEigozDJCG9BugvlW9svyQsziHjoMk=;
        b=CE1CSksMPVJzKWx2neor8BwtY3CcyB84vFoqdh2I3KlAzm3EaHdIl5txNXrl1lCt3o
         Np5Ksqh5ZRlL8J5YV01aDk0vnM3gmmdYkuCIi1pkyPJgtWIO60rcRWWqp974nRl7Vnc2
         qUNbSaGYA5paHv83ez+xNZw5DdEdAA5pj/1AN8jE9U50bRNLQPgv2QXBoWovpVuBx0dN
         GQIeo5wg+MShoYq6NkaynnTey6wEwAj/hYouGrGggnCIpDm8nCnrosdiSbUMNYUlbBmc
         tNGIu4uWth7ev2c9KeeCqmlk2fr+IEQBpq5415/0PYwHhDHVgTIB+g0cEAjiaKssubOG
         8vNA==
X-Forwarded-Encrypted: i=1; AFNElJ/1+j1uSykvZ/R8uCKSyfZZeiuhuk0eJsubL/3kmhEZE/Tr3BZbLTHeuG8Fk10Mi25AcZxgU1LIeg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwqXOhzfF80qZIyNIAaAX+em/B0wqq/V1ibcIDOyQHL1d6qdYCx
	DgHs0xUhgf6H8Q5o8mlZGdr305pBpUoFb7UMKhFQQr4gQZ8P6dsQnZjn
X-Gm-Gg: Acq92OF9AG6X9R3HkZmsLSLg6iO+aLm/16GlBrR/UfioVVGKORFqlGJRFKdqCKtMFJ/
	f5CdGoSN3tmcBymFGEJP/tdn574k6Mf61jawS9fYoHKrIeDmYLq3hvVJw6fzXO5KCyJBE+G2Odv
	JiUWOVktm8If5uOHYqsvKCFOqsj68fnqrK5qQIFnH3cuQj2nyAG788biFIK0VffXyzL8sTUYLXo
	moM22zGHmB3vxpABZgzR7YOnaTHUolWyqBC3B7c0a99SXE4F1Io4cHiH5wsBBucj7lHLXVDUhxu
	jN7TOU+1o2hIf9cg5+NZsOufelgDWBUbC6s0ISdnR/vzqlvrlLxMNOxl6NtQg+ZM1sauaw8ZXLo
	V/hcmGxrucQ1cFNVlIheOLQ2MxkBDQKyYylaYVPkntG+lO4ee2Dp013DfEG0BrYgYKZhQC6MV+h
	56oG6d6OyqQuAj/ZNvLdyllW/tfcSOJsvLyCVh1+BFUeO7eNfpu95XF04xeNfQbvqaPEYZPjHAS
	nDE0mgsDpP+oxmqmn01Uce0YflD056K7QXoSuFUWZJDLSaISSI/GSr06rYt7JFYnRQFHThHhb8P
	JqjXJZjMnHbh
X-Received: by 2002:a05:600c:6592:b0:48a:557e:6b4f with SMTP id 5b1f17b1804b1-48fe62f8861mr237008575e9.23.1779108020601;
        Mon, 18 May 2026 05:40:20 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c8d39esm256597555e9.7.2026.05.18.05.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 05:40:20 -0700 (PDT)
Message-ID: <4561c621-817c-46be-8ff0-0b557f6c819d@gmail.com>
Date: Mon, 18 May 2026 13:40:18 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] block: introduce dma map backed bio type
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, Nitesh Shetty <nj.shetty@samsung.com>,
 Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <646ecd6fde8d9e146cb051efb514deb27ce3883e.1777475843.git.asml.silence@gmail.com>
 <20260513081929.GD5477@lst.de>
 <24833f76-2289-4859-86d1-9215b11a1258@gmail.com>
 <df697a76-c700-4908-ac08-a47ad07e0796@amd.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <df697a76-c700-4908-ac08-a47ad07e0796@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D8E9A56CFF5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[24];
	TAGGED_FROM(0.00)[bounces-13395-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On 5/18/26 13:22, Christian König wrote:
> On 5/18/26 12:29, Pavel Begunkov wrote:
>> On 5/13/26 09:19, Christoph Hellwig wrote:
>>>> +    if (!bio_flagged(bio_src, BIO_DMABUF_MAP)) {
>>>> +        bio->bi_io_vec = bio_src->bi_io_vec;
>>>> +    } else {
>>>> +        bio->dmabuf_map = bio_src->dmabuf_map;
>>>> +        bio_set_flag(bio, BIO_DMABUF_MAP);
>>>> +    }
>>>
>>> This is backwards, please avoid pointless negations:
>>
>> I can flip it, but compilers tend to prefer the true branch. E.g. this
>>
>> if (cond) A; else B;
>> C;
>>
>> can get compiled into:
>>
>> jmpcc cond B
>> A: ...
>> C:
>> return;
>> B: ...
>> jmp C;
> 
> When that is really a performance critical path then you can use the likely() and unlikely() macros to give the compiler the hint which one to prefer.

That might be more penalising than placing them in the right order,
and it might be fine as it's new and all that, but it's not a clear
cut as it's definitely not created to be a slow path. TBH, not sure
why we're bike shedding such things, is it somewhere in the code
style?
> What could be useful is to have the true path for the more common and the false path for the less common case for documentation purposes, but in that case I would expected some code comments as well.
What kind of comment are you thinking about? A "this is not a likely
path" type of comment before each mention of the flag is usually not
very useful.

-- 
Pavel Begunkov


