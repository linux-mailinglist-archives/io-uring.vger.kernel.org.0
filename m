Return-Path: <io-uring+bounces-3539-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B4F8997850
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 00:13:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BAF22845D2
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 22:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7983F1E285E;
	Wed,  9 Oct 2024 22:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YnmBx5P6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08001E2852;
	Wed,  9 Oct 2024 22:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728511991; cv=none; b=qXzVQ68p3dwFHv0vrO6rls9xttkUMOMJbqptnLpnSmM5awnFatap1JewX7M94K3x+IedN/cbQ9evoDVwpgLdKSV0LwHlSEO50y42XKIPPQvxOoW4klTEwaj3CFV5k9Go0DtvciEO2MBe17eGtyqk1rZ/6ekfUTnSVO0bH7gDAyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728511991; c=relaxed/simple;
	bh=YdE+MwGZovbgZlqhhhGj7EkbelFSfI1CiW1IM+5R/mY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e/xFMCNC+k20lUdskA8cQ2Q86y5eKIC/IR1EjlaoxuRrF89Tg9IE8jlFZFg+Ons7tGp/FQaLMAvIyfV2R0Gc32cPr7txzHQO3A5a7UQdzkVdR3CRb1NNG91Eu9Mr3HrumwTrg/wTbiy4rBI3Td/8wRQCZ8DEOcwkVvaT7oqF+44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YnmBx5P6; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-37cd8a5aac9so97210f8f.2;
        Wed, 09 Oct 2024 15:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728511988; x=1729116788; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UNRrQCboDTvJyE1Ck0MXGLC3dJvzNdfbPYoAUaHWgjY=;
        b=YnmBx5P6a/47I/KIO/EXH6vbvtR3ZgBCBjmcB2wV7c8yEl+gUhRUs7L+LV7zUtNQdP
         +55My6TqjlPd9voOKxb+WYyV6UU3zGsB5ZqG+AgnWOrmErKqi51bmlZlEpKxoUppEmHQ
         t2JrvGePSzdQAvqsqBJ0dkMLYQ+IImHz1e8AEox0+AwjO6zNwyGemtENi4rI7iQTT0r/
         JE5zOkhScGO43becDU7b6e1wXyvwY05vjMKNdCJBkZRT9dVH2h9uKxLF8OcHk8dapPwK
         E7sp22F2TngyeAL7VUHAJlTuF9ywTLcFHWof8btCpKw3hu9JGgi7BZrHWq9A18f9hiMj
         WMkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728511988; x=1729116788;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UNRrQCboDTvJyE1Ck0MXGLC3dJvzNdfbPYoAUaHWgjY=;
        b=gie+JXC8jntxQ80tbiHALlH/7x76uH7O75tjX0bkvh9HPK7CKUZDV9jLThcYy4rS4t
         CSKXMplwI+bX7AdIaGGImy+h2/7waGw8AdIwlJcb3Pg40LDq+1wkUUmFIbMIdk1w9fkE
         PWMLK7MrGAXmCKU0GsZp9VJ9kT+b0VfAuCQC/4nGtOViM6K8+R9TWm2uVVzKe38apxW0
         T0O1JKdrZgvoHlpQ9JYKl0sQYwMBYuAxbSO/W6hCMaPp5nZz/fB1A03RUcM8kmeq/zPf
         g5bwZfxBPZNoSaiXi4d9rAyV5Be74JHynpHbx/krZ5AGFn+ZUOvsUbZ6k9T2OqdaeQIf
         ka7Q==
X-Forwarded-Encrypted: i=1; AJvYcCV1bKsGhb92Fp5thx5zFtAEawLyiu0Th0zQ20+b3ViPC+FInu0QS+YdUo/fMgbJQpJk9Zv5YsE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy83AAawMgnmuUMNr8GOUR1BKDbG+UJ+RcSp+jlS7xufDF5Pb+X
	GmTIfwPvUtz3EUbXpZW8pFV/RZI3YVw6K0uAB6pC7b1g9EvNr+D0
X-Google-Smtp-Source: AGHT+IE9r1m5up11/TMYRchdcWQtfWe7LzbAL/O5lbZL4XUPA7tn1D5JmfVdwfhQdJgjXU56GZKQPg==
X-Received: by 2002:a5d:4589:0:b0:37c:cca1:b1e0 with SMTP id ffacd0b85a97d-37d3aa6bef0mr2085258f8f.44.1728511987687;
        Wed, 09 Oct 2024 15:13:07 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.140.94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d16920be2sm11378399f8f.60.2024.10.09.15.13.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 15:13:07 -0700 (PDT)
Message-ID: <6ccc5207-51b1-423b-807f-4ad9ae3a0b92@gmail.com>
Date: Wed, 9 Oct 2024 23:13:42 +0100
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
> 
> I guess, with this patch, there is no way to tell, given just a
> net_iov whether it's dmabuf or something else, right? I wonder if

By intention there is no good/clear way to tell if it's a dmabuf
or page backed net_iov in the generic path, but you can easily
check if it's devmem or io_uring by comparing page pool's ops.
net_iov::pp should always be available when it's in the net stack.
5/15 does exactly that in the devmem tcp portion of tcp.c.

> that's an issue. In my mind when an skb is in tcp_recvmsg() we need to
> make sure it's a dmabuf net_iov specifically to call
> tcp_recvmsg_dmabuf for example. I'll look deeper here.

Mentioned above, patch 5/15 handles that.

>>   static inline struct dmabuf_genpool_chunk_owner *
>> -net_iov_owner(const struct net_iov *niov)
>> +net_devmem_iov_to_chunk_owner(const struct net_iov *niov)
>>   {
>> -       return niov->owner;
>> -}
>> +       struct net_iov_area *owner = net_iov_owner(niov);
>>
>> -static inline unsigned int net_iov_idx(const struct net_iov *niov)
>> -{
>> -       return niov - net_iov_owner(niov)->niovs;
>> +       return container_of(owner, struct dmabuf_genpool_chunk_owner, area);
> 
> Couldn't this end up returning garbage if the net_iov is not actually
> a dmabuf one? Is that handled somewhere in a later patch that I
> missed?

Surely it will if someone manages to use it with non-devmem net_iovs,
which is why I renamed it to "devmem*".

-- 
Pavel Begunkov

