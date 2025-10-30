Return-Path: <io-uring+bounces-10296-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F849C21A9B
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 19:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0C1A13508A9
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 18:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA9291548C;
	Thu, 30 Oct 2025 18:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hDQYnW5V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128B113BC0C
	for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 18:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761847582; cv=none; b=sP3aapuBtQYn85Q6ZgUygOEGmNI/k53N3iH+svL7d5dKu3r4nKKRY2sMpykzz3a37ILgJmE3d1WNSUoz+9UrkUoRrpAtYpPWRMh3SJU/0x0WrdgUWrijkJLRO0Hg/Udjv/Iku25hTXAO6ljVYrC4pXZ/lKz5zaBHhWrmjmZQT1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761847582; c=relaxed/simple;
	bh=gtpVadPAzt1cZJjh+x39AH7IO4sABig7DKmdKYQiHGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fi5He8th/xP7tMIbog5HY+awxBTuDQIuymy58XlXR0VBbpAhjnSSMYASO4dty2Xu1FxMa6L4t3A9PgTKtmKy92G7UM9UTYSI1tNA8R4UvlIvvCFsxg67ZeEtE7mN4a3F8r/XiKIJ/Mcy7I0pg4S0ebFSFHHr/vk/TVl+meiq4x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hDQYnW5V; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-471191ac79dso15296635e9.3
        for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 11:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761847579; x=1762452379; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LctJqSNQDbmKMmTplmDwPKRu3GxnYoAJOiOCEmk0g7A=;
        b=hDQYnW5VAc/lFj0rxPfI8AoEzcQwMtVW1ppfsY6y4GcB0P0rCY6FmMwXdNpH+YLgCE
         UuMmk0ovSpLPLDPlb+EaCoJP+OOlJVDm+w34S2+XJhX7yFVDbBKv3vLenodLyttlAgnf
         nDfBZiAOwIYd51f4bylBkfLIJ+m/JxUpnzwNeNOFAjBr2XWfiap5tN4M6qIhGel8HrIw
         BAENFxIutpk3jLdy/dxEkRuZPZZElmV0I4d4gVwIB0/nioK00jjAiusQcnKsnCpw9Dcb
         zQohFgJUIGOVo8Kxs5Wq9//9/bHwt4+k2Xlv5VzfdoHoGd2/knsy04pg3PXPc4Kxmldz
         ROAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761847579; x=1762452379;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LctJqSNQDbmKMmTplmDwPKRu3GxnYoAJOiOCEmk0g7A=;
        b=dmzp0F7lrXtC8IvnrsnqLrhwTZNJeyTZXFPvlAgjDV7VeFSPsGyBUblhonSrHzNzJz
         xcl/1uppR+XX8TMsem8ZHT94ljW3Wz4rtxbF/T82XusgMytIAyCMAvV2np3IFOH3mr19
         zYx/+DV3/N+Y5mssBxq9opkUvL30nm2e0EWRxtUZO7vAiX165GFpV6q9jtUSUjX3+bhW
         2HDqNKShcAb+VtiYpfpKUNazOHG2GhjFEYtxTxTlN7NTEzxy66+BmXGqOJi6YQ4Qyhmc
         +auadGicT/Rfc0l/5TFcVTQThZn8So5wSDSp0qWoFUjZ+aepy9nOB4OaszT8eu+jr5EO
         9jmA==
X-Forwarded-Encrypted: i=1; AJvYcCX5ibLt9hViqg2tAUpGVsjjFd5mPtPae568OCBxLcdhAgh08L3vJoNrKtd/xo+JEWAjmC0lMu/Adw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwYoIrC3LJdfmie8odtUKL8aa/YJs304YuWoITzaB+v/30N1PQq
	l0FDF4sT5fyf8ndNRgzYKa/+gmDBkLz3n8z7nuLCOyjEamAksmQ/LvGx0/55qA==
X-Gm-Gg: ASbGncto7WzJbwGVQE4Q9CUYhZBi6Lwd7smrt1D+DpYPZgiAOr5Mp+5VrlLTPSlwcOo
	8kYwlVqSah0adTHH8ILowrRCeksTVEl9GXjXMos2XU4MbqeTcTImxgHvOIlrZlUcbYNmqqNiUMT
	j/e9iI70YWL3gEooXUTANtxU7tcLyVGqY6Q771tjX8hoTfTjWnHoqKCyhLtVh7fcfkvbYm4P6kO
	qCJPgai0KfvkNKLVUcKaWHBw1AKHYQnECKAo4dsd+rO5Pp1q+1LtEkpNpfRQKSMxmrFs2Zm/5Un
	dUGMHNHOz/TfXJqOGwSdiPwzy3iWKQcUjyM5laCZ2kAvbcm6ErchUjTk1dFDF3pQ3e3dH7YzUeH
	WPyilREKVP22GFdrOc1dtdLYgBwPNK+//jI8K/dv95rCAV9Nw0J/NwzOeIsJyhdDxMR88SDQGyD
	JW8dFy20nYP8IKQoDYzqbuuflNrmIFWM61mn2KVguWaaCZ1UEpJgWA4sS9c2d55Q==
X-Google-Smtp-Source: AGHT+IFHnCEJfTs8IuNeNWjo4WDOlKhJ53Yq9EDtOhCMoVzY7tX2LoiCZ+S4L49V4ege8NAPAZfS/A==
X-Received: by 2002:a05:600c:1d9b:b0:46e:2e93:589f with SMTP id 5b1f17b1804b1-4773082e737mr7312145e9.14.1761847578988;
        Thu, 30 Oct 2025 11:06:18 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952df5c9sm33681846f8f.41.2025.10.30.11.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 11:06:18 -0700 (PDT)
Message-ID: <9f0debb1-ce0e-4085-a3fe-0da7a8fd76a6@gmail.com>
Date: Thu, 30 Oct 2025 18:06:15 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] io_uring/uring_cmd: add
 io_uring_cmd_import_fixed_full()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
 bschubert@ddn.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com,
 csander@purestorage.com, kernel-team@meta.com
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-2-joannelkoong@gmail.com>
 <455fe1cb-bff1-4716-add7-cc4edecc98d2@gmail.com>
 <CAJnrk1ZaGkEdWwhR=4nQe4kQOp6KqQQHRoS7GbTRcwnKrR5A3g@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAJnrk1ZaGkEdWwhR=4nQe4kQOp6KqQQHRoS7GbTRcwnKrR5A3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/29/25 18:37, Joanne Koong wrote:
> On Wed, Oct 29, 2025 at 7:01 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 10/27/25 22:28, Joanne Koong wrote:
>>> Add an API for fetching the registered buffer associated with a
>>> io_uring cmd. This is useful for callers who need access to the buffer
>>> but do not have prior knowledge of the buffer's user address or length.
>>
>> Joanne, is it needed because you don't want to pass {offset,size}
>> via fuse uapi? It's often more convenient to allocate and register
>> one large buffer and let requests to use subchunks. Shouldn't be
>> different for performance, but e.g. if you try to overlay it onto
>> huge pages it'll be severely overaccounted.
>>
> 
> Hi Pavel,
> 
> Yes, I was thinking this would be a simpler interface than the
> userspace caller having to pass in the uaddr and size on every
> request. Right now the way it is structured is that userspace
> allocates a buffer per request, then registers all those buffers. On
> the kernel side when it fetches the buffer, it'll always fetch the
> whole buffer (eg offset is 0 and size is the full size).
> 
> Do you think it is better to allocate one large buffer and have the
> requests use subchunks? 

I think so, but that's general advice, I don't know the fuse
implementation details, and it's not a strong opinion. It'll be great
if you take a look at what other server implementations might want and
do, and if whether this approach is flexible enough, and how amendable
it is if you change it later on. E.g. how many registered buffers it
might need? io_uring caps it at some 1000s. How large buffers are?
Each separate buffer has memory footprint. And because of the same
footprint there might be cache misses as well if there are too many.
Can you always predict the max number of buffers to avoid resizing
the table? Do you ever want to use huge pages while being
restricted by mlock limits? And so on.

In either case, I don't have a problem with this patch, just
found it a bit off.

> My worry with this is that it would lead to
> suboptimal cache locality when servers offload handling requests to
> separate thread workers. From a code perspective it seems a bit

It wouldn't affect locality of the user buffers, that depends on
the user space implementation. Are you sharing an io_uring instance
between threads?

> simpler to have each request have its own buffer, but it wouldn't be
> much more complicated to have it all be part of one large buffer.
> 
> Right now, we are fetching the bvec iter every time there's a request
> because of the possibility that the buffer might have been
> unregistered (libfuse will not do this, but some other rogue userspace
> program could). If we added a flag to tell io uring that attempts at
> unregistration should return -EBUSY, then we could just fetch the bvec
> iter once and use that for the lifetime of the server connection
> instead of having to fetch it every request, and then when the
> connection is aborted, we could unset the flag so that userspace can
> then successfully unregister their buffers. Do you think this is a
> good idea to have in io-uring? If this is fine to add then I'll add
> this to v3.
The devil is in details, i.e. synchronisation. Taking a long term
node reference might be fine. Does this change the uapi for this
patchset? If not, I'd do it as a follow up. It also sounds like
you can apply this optimisation regardless of whether you take
a full registered buffer or go with sub ranges.

-- 
Pavel Begunkov


