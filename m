Return-Path: <io-uring+bounces-328-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ED4C3819604
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 01:54:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 90450B22288
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 00:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6173B1FC6;
	Wed, 20 Dec 2023 00:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H9TBf3FV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6A61FA8;
	Wed, 20 Dec 2023 00:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-54f4f7e88feso7068800a12.3;
        Tue, 19 Dec 2023 16:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703033657; x=1703638457; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h2PeBaBRdkqlD9a3kfiUcdxd8zVw2YNGDxjyerpCsiM=;
        b=H9TBf3FVEqN8A8CxiUXVgymQ8V+1miyt8ahWLetEbm6XGNreYUoJODcw2k1g740Z5h
         VuoSDkSzszHVDJ+su/GpWzQCeR1cyoMa7ZuUkIZ2lzGjCzq1ooPxWGQmiYnN3rnc9xcb
         GTYw6VMWhj5K+YUrOFUaDEEjff4AMlxD5aKMYK1CissEk8Nhrk7ngafMfXf70FFNJgeL
         MQDEhd5uUN3EegXNl73WMXAXV1FCYCrwikSsXKjTp8Cu5QBAneJl44I8iZFkwgO9vJke
         g7M3ycRWfygpMKEGJbi3hBwfxFRYRUwE6xqZKXxQGCKnGOGFb0sRgMdzIa7IVxeZ6Q0Z
         GzwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703033657; x=1703638457;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h2PeBaBRdkqlD9a3kfiUcdxd8zVw2YNGDxjyerpCsiM=;
        b=SDm6LtJ3OmIPNZkjpya9kQQVsYNSivaNYinM63yQjWPbIiIlsp/Rr6G/JfaRfycIE1
         9PLBdLoUk0f6HeH0ADfOfj3Ufh0If026KATKxrqo6HmItoZ2ue5pIlTulSAboOTAY5i1
         yOp6Sg3hQ+F9sjAnGe1qKBF1DG8L2ikkNZKA43lYNvHGvBwc8/Q7mt8qHznh0UAsSRu+
         X8SubYKrQGGmORtb0jO6F9JYye1ORB7Wq49elHobMODvMDt0TMvstf3mmkRIQMTosODQ
         8N23WfPNiJ46Qd92R8aS++W8bl1UGvSuxjOUacJqzkgjERnrDUnjSDYdG9Ja8hsYKi8e
         IJVw==
X-Gm-Message-State: AOJu0YwhJyPDd6AnI/EEv5TlkbFOljFC6M65yAc1zx17Sjca79KoG9zg
	lcNse8WShKq/K3gUypDuFbE=
X-Google-Smtp-Source: AGHT+IGRk5TN4/kGOzJGXYSq0y4ujntw0DgxWlEKz8WQd60avWxz/Pd2OYrgXOoz+5HPwO85lWC07Q==
X-Received: by 2002:a17:906:155:b0:a22:faee:74f9 with SMTP id 21-20020a170906015500b00a22faee74f9mr4998738ejh.38.1703033656750;
        Tue, 19 Dec 2023 16:54:16 -0800 (PST)
Received: from [192.168.8.100] ([85.255.233.166])
        by smtp.gmail.com with ESMTPSA id tn9-20020a170907c40900b00a1f7ab65d3fsm14864309ejc.131.2023.12.19.16.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Dec 2023 16:54:16 -0800 (PST)
Message-ID: <a473720f-ae8c-42f4-8f87-987a2d9151f9@gmail.com>
Date: Wed, 20 Dec 2023 00:49:10 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 03/20] net: page pool: rework ppiov life cycle
Content-Language: en-US
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-4-dw@davidwei.uk>
 <CAHS8izPqKg73ub5WUg=EBdd8ifCcAuh69LB0pBUSw6t+5NGjjQ@mail.gmail.com>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izPqKg73ub5WUg=EBdd8ifCcAuh69LB0pBUSw6t+5NGjjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/19/23 23:35, Mina Almasry wrote:
> On Tue, Dec 19, 2023 at 1:04 PM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> NOT FOR UPSTREAM
>> The final version will depend on how the ppiov infra looks like
>>
>> Page pool is tracking how many pages were allocated and returned, which
>> serves for refcounting the pool, and so every page/frag allocated should
>> eventually come back to the page pool via appropriate ways, e.g. by
>> calling page_pool_put_page().
>>
>> When it comes to normal page pools (i.e. without memory providers
>> attached), it's fine to return a page when it's still refcounted by
>> somewhat in the stack, in which case we'll "detach" the page from the
>> pool and rely on page refcount for it to return back to the kernel.
>>
>> Memory providers are different, at least ppiov based ones, they need
>> all their buffers to eventually return back, so apart from custom pp
>> ->release handlers, we'll catch when someone puts down a ppiov and call
>> its memory provider to handle it, i.e. __page_pool_iov_free().
>>
>> The first problem is that __page_pool_iov_free() hard coded devmem
>> handling, and other providers need a flexible way to specify their own
>> callbacks.
>>
>> The second problem is that it doesn't go through the generic page pool
>> paths and so can't do the mentioned pp accounting right. And we can't
>> even safely rely on page_pool_put_page() to be called somewhere before
>> to do the pp refcounting, because then the page pool might get destroyed
>> and ppiov->pp would point to garbage.
>>
>> The solution is to make the pp ->release callback to be responsible for
>> properly recycling its buffers, e.g. calling what was
>> __page_pool_iov_free() before in case of devmem.
>> page_pool_iov_put_many() will be returning buffers to the page pool.
>>
> 
> Hmm this patch is working on top of slightly outdated code. I think> the correct solution here is to transition to using pp_ref_count for
> refcounting the ppiovs/niovs. Once we do that, we no longer need
> special refcounting for ppiovs, they're refcounted identically to
> pages, makes the pp more maintainable, gives us some unified handling
> of page pool refcounting, it becomes trivial to support fragmented
> pages which require a pp_ref_count, and all the code in this patch can
> go away.
> 
> I'm unsure if this patch is just because you haven't rebased to my
> latest RFC (which is completely fine by me), or if you actually think
> using pp_ref_count for refcounting is wrong and want us to go back to
> the older model which required some custom handling for ppiov and
> disabled frag support. I'm guessing it's the former, but please
> correct if I'm wrong.

Right, it's based on older patches, it'd be a fool's work keep
rebasing it while the code is still changing unless there is a
good reason for that.

I haven't taken a look at devmem v5, I definitely going to. IMHO,
this approach is versatile and clear, but if there is a better one,
I'm all for it.

-- 
Pavel Begunkov

