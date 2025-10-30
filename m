Return-Path: <io-uring+bounces-10295-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E86DDC218A6
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 18:45:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CFF01A63276
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 17:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BC2E1DE8A4;
	Thu, 30 Oct 2025 17:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EBZw2Dsq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E92315D4E
	for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 17:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761846168; cv=none; b=rTGPsLr0jqxneNQ7eBo6eJci6NiRqWnklZ8MVeHOQmrgjYiQhcGueRUHo1rpkwnQkm+foit6k2pJVMm5/tGRVgn28yr6K6XwdTtJjiIJfNOy8ysJJf4NIDfMxQnJE4nMbBfjBGHks69hpYolYu9ddLDQETHmBBcdVTm8VjxG9vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761846168; c=relaxed/simple;
	bh=b1POjuns61tfvPvDtbqhXxCP3k6/ikC6HAP/XOZbGzE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pNolz0zITCuhH/tTwFhl7ziyZMAlN1/ODM4gfcjYbZwcLhIw4zONkBCwa10Z0Xxk4uPA52WWsTKKSTeikEFfpHzQ1rQ6teMUsoKvXKFqzLg+kH3YNZqcjCpy+zFtd5rZyjCvdMZdWmtJBJULKgvlwR6yTod/9QteV6mOdzmRlb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EBZw2Dsq; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-475dbb524e4so8625595e9.2
        for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 10:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761846165; x=1762450965; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FYfzDRGnnPlhr93W60j8zTUhCMGw1L+Yzwlr2e0Jw3s=;
        b=EBZw2DsqQj1Imt6n7CY0ZfuBSSij4+LJSuMCDgoELWGEJ/HTzaWmA5/kjdHVtBtw0p
         6OHhe8VLUdmEoBRgh5mR3NzXQw49eT77a5IplHqdFI5LlwEJXQnSi9H+QAq3pV8cjNtJ
         ddia7WS6z067axa4iukqH/C3J9v7qeEn1omtjIsz5bppSdNPX7pJgSTLHM0ssNxkt6IO
         3u0tZ5jg86huXFlhSBEbXo/V+8x9KUhqma7yvL/z0Yf3Hs7e3+nnQQjxRejX/rY3yfbi
         1YkYw6bevF8WfQQiqu5yLl4n5wknaXeeKXR4/va4li4nqnPA9gD1dJVyf5BwJCx+ClJg
         tpPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761846165; x=1762450965;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FYfzDRGnnPlhr93W60j8zTUhCMGw1L+Yzwlr2e0Jw3s=;
        b=G15tWqbCfPX1nA7uoCQoRN3cIVZPBM9GjzBzay0RZTt2GFscTHI7/Zvow/KYemm3GO
         +OoW2yW8TzKx+k4V700r2waNTqIS+ApPulSLU1zfKUgbKQYp6WUWtDoqToIHY1e7Hf7H
         wciIhT+Kl5ho7PBfhz0xUDSa+Wd9nCiE7hMzqrRzBEV6+Ps/G8+z3hiP7aFnRz5r6n1S
         xodeScFcm5rVesyuLdudVKai3LuHcEJZmqUYWuz0yVfbHYfJtZ+kw4ygAp3hyzkyID8p
         ZhlVa2dOmf/WhcKqivQH+hZu9dfoBWtXhIGMvdlgNODGo3zGTluqzKrdWVQ31Cfc0pcM
         JQqg==
X-Forwarded-Encrypted: i=1; AJvYcCU+XbA8fCTtI0UK3Mwlpby7o7scNgtbYFmDK9Pg9+AGpuhhP4NN8l8jgyGUC3CMcgM6+VI5Vjp4Ww==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw26d5OBp9xxojIPjLRecDEuzc6wSV7TYIjPD83m7Viri1cnlUG
	hZb6Mhy2N0oKEU5/tE00e+XYW8FuG53ZjBxaJa6zI3RVSmG1mh3s8WRQ
X-Gm-Gg: ASbGncvvTNSOVQ7lLTqVCNNnwtvP8YUtbmfMKjiTj64iWjT5UrgQoAcgdqdEi52U0Bi
	asEL5RZKLfaGFBcQwplXEdN6HEsOmFbhdkchSh+fCNdyhJmZhoku6PaAl+1YZ1XW/EJgn/TWtwP
	+MPd9pbtJ5vJMEzY2YIrvHJUQWnnssC9uqK+Qs+b4XnY+UEY4NP1/O7ZzCBTrP1Pw1ywFJlG0mJ
	4ONsY6SJExV9zmnW1t2Fp5wZ5eiORc2fdFTjdYa54/uJoQeQt4tG8HpIBIF7C/q9MBJ7/qVPPBl
	EJ8pjYAmhWA9XAQMecsdtVG9eWJU2DQ+7XZPup413czfkoadc5bmFkRBL86eDgnMbgAKucTZHYV
	7uXVsWVQlxHBUIcmnTHVZoXVzyLMuajGYkEMQ40BLxXDFUzI7pIp/sfheXuBq/t+Yf/4icCg8Kc
	FVO1AAU9odTtn3boZk6oC3fGyhOInx7ioDon881I4zuMZhi1TLUpKNm+9VeAQGlXnOqrkohMMl
X-Google-Smtp-Source: AGHT+IFe4aCtij33QC4DH0aHd6JDe3xOjq1gI+3SwZ3GsAwAZoN8IDEcyy5P82TSWws9qdvpdK86XA==
X-Received: by 2002:a05:600c:190d:b0:46f:aac5:daf with SMTP id 5b1f17b1804b1-477308dbefdmr6098625e9.35.1761846164760;
        Thu, 30 Oct 2025 10:42:44 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952db99asm33502479f8f.32.2025.10.30.10.42.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 10:42:44 -0700 (PDT)
Message-ID: <dbc88b2f-bfee-474e-ba7a-609c544eadde@gmail.com>
Date: Thu, 30 Oct 2025 17:42:41 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] io_uring/uring_cmd: add
 io_uring_cmd_import_fixed_full()
To: Bernd Schubert <bschubert@ddn.com>, Joanne Koong <joannelkoong@gmail.com>
Cc: "miklos@szeredi.hu" <miklos@szeredi.hu>, "axboe@kernel.dk"
 <axboe@kernel.dk>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "xiaobing.li@samsung.com" <xiaobing.li@samsung.com>,
 "csander@purestorage.com" <csander@purestorage.com>,
 "kernel-team@meta.com" <kernel-team@meta.com>
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-2-joannelkoong@gmail.com>
 <455fe1cb-bff1-4716-add7-cc4edecc98d2@gmail.com>
 <CAJnrk1ZaGkEdWwhR=4nQe4kQOp6KqQQHRoS7GbTRcwnKrR5A3g@mail.gmail.com>
 <3bddaa1e-b4a0-4f0a-8b30-05a2cb8fd1fd@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3bddaa1e-b4a0-4f0a-8b30-05a2cb8fd1fd@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/29/25 19:59, Bernd Schubert wrote:
> On 10/29/25 19:37, Joanne Koong wrote:
>> On Wed, Oct 29, 2025 at 7:01 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> On 10/27/25 22:28, Joanne Koong wrote:
>>>> Add an API for fetching the registered buffer associated with a
>>>> io_uring cmd. This is useful for callers who need access to the buffer
>>>> but do not have prior knowledge of the buffer's user address or length.
>>>
>>> Joanne, is it needed because you don't want to pass {offset,size}
>>> via fuse uapi? It's often more convenient to allocate and register
>>> one large buffer and let requests to use subchunks. Shouldn't be
>>> different for performance, but e.g. if you try to overlay it onto
>>> huge pages it'll be severely overaccounted.
>>>
>>
>> Hi Pavel,
>>
>> Yes, I was thinking this would be a simpler interface than the
>> userspace caller having to pass in the uaddr and size on every
>> request. Right now the way it is structured is that userspace
>> allocates a buffer per request, then registers all those buffers. On
>> the kernel side when it fetches the buffer, it'll always fetch the
>> whole buffer (eg offset is 0 and size is the full size).
>>
>> Do you think it is better to allocate one large buffer and have the
>> requests use subchunks? My worry with this is that it would lead to
>> suboptimal cache locality when servers offload handling requests to
>> separate thread workers. From a code perspective it seems a bit
>> simpler to have each request have its own buffer, but it wouldn't be
>> much more complicated to have it all be part of one large buffer.
> 
> I don't think it would be a huge issue to let userspace allocate a large
> buffer and to distribute it among requests - there is nothing in the
> kernel side to be done for that?

You can, but unless I missed something with this patchset you'd need
to register it N times, which is not terrible but have memory
overaccounting problems and feels less flexible.

> (I think I had even done that for the 1st io-uring patches and removed
> it because there were other issues and I wanted to keep the initial code
> simple).

-- 
Pavel Begunkov


