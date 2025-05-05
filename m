Return-Path: <io-uring+bounces-7834-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7023AAA8D37
	for <lists+io-uring@lfdr.de>; Mon,  5 May 2025 09:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21ADF1893EFD
	for <lists+io-uring@lfdr.de>; Mon,  5 May 2025 07:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D4C19992C;
	Mon,  5 May 2025 07:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GUD3x7we"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A9919995E
	for <io-uring@vger.kernel.org>; Mon,  5 May 2025 07:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746430931; cv=none; b=ecYRcs/Nk5Jp/QIs7xr7Ir57iDECl955tU4fqAkdVeXTy6Wg0A6x9lNQ5xS1FcwtH9SjvxEjtH5ANioGDR56wHu6Lhzmj5jyTZFn1eqE4SKnPfRpcOiExiX9yGJt4leHXTUC3xwVowItL27jkle0vVTUhgPruqG7dAyqTPHatT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746430931; c=relaxed/simple;
	bh=/1L4VXQZnM4TVg9Q0XEcQOC1Z7dwzdgPChSwdWfL7fE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TDn1bv5O/kxAWC8ST2ObB6jMyBeKLgpn9+ZThvjg7eddBFMhRLfqLv6pNZur3NmmJgH/jad/SffjUBFbPy5JUFAshItUBfQEPDDYIRz1RGtf8VscAb+Ktl4vVaX3xLKi2lo5WkBIEImRpmKlnH666EDG3aOt36TzUxdslREM9TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GUD3x7we; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746430929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NYutuEk9tS5pMcj+KQxarlK855jenHaF07JshpvJP/c=;
	b=GUD3x7weEWtIEGqfu1j0k6nnBLy6QLq6yU4A2vGDnp4xZ8q10PY1Stav7e4ahz2p42IxYl
	D2T2KPCTE1RDdXprvia4GhVOuQrwYlRoLGUUEk+WfnhjEJ4UmkDMnSEXtK1qqcPWzq+AWy
	kPU+5l9NM41g4FLRh1NAEOtX+gk7GwI=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-PO3MUmytMXKiyenZITlRYA-1; Mon, 05 May 2025 03:42:08 -0400
X-MC-Unique: PO3MUmytMXKiyenZITlRYA-1
X-Mimecast-MFC-AGG-ID: PO3MUmytMXKiyenZITlRYA_1746430927
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-30be985454aso18464561fa.2
        for <io-uring@vger.kernel.org>; Mon, 05 May 2025 00:42:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746430926; x=1747035726;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NYutuEk9tS5pMcj+KQxarlK855jenHaF07JshpvJP/c=;
        b=aCugaRQjcEQx3rUb/S3H1UTzTU670XBX2prFndTWLQdSETlQS2vfVINuunohRubjPj
         0+5+ckuOrszVViaCFPifPnnT6bodx5a9q3WlJ7VPVZufFf9fTAheDs2Ye6gk1PejlaF3
         Kee0w7NwEF4bjzMCRkBUYw3vtYCcfxwxj6SuaXLY9ej4qx/VTp2n/YeUZhqv9QIdj6f+
         WHU0hnSfDNd8zSwZM1XUkJnzUfQiaw83pGdjCQYag4ZgvcZ5Kc8vYvRZm1v0R7pIApM1
         nB5vYBlpyDhsIDnk3slEDvUGOoQQDEnylJhpO4dVz9GLQQuAMYKFwtJtnZrID8jIm/SL
         0QOg==
X-Forwarded-Encrypted: i=1; AJvYcCU82IKjMka27nPZ7anfzbfycZI7xcVxFDw8OMvbgh7PjdFSRS70qEhQHfjMBQRgUvOUd+B0EJzxQw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyreo1YqZ+9me8Pe5S2C0oWPdS8Tn/BSyjw6Rh4dJwp13WxreXy
	ZTaT9xUzPy0uhN68UojKnW5pEooD9k1ohK3M4Gyxeo8Q+DvBfvsTmeo5DGtaLw2B6aawczCFw8+
	LgW5itqnQ/HALwDlmkUDMWnKCX5cLDwrpfhBYgn8MR7kkb/QLF7qiD5A0pGLtOjPCL3BjUA==
X-Gm-Gg: ASbGncsfWm8YMTme3m9n5SSfQ3PdQ7RiAgQdERqVDxnYMcWUEMZKNAv/S/bV1eaBzFi
	TrJrqmxLb8mWTqS+k4rQao8EcSwWwSQZDUorxd8QXcff4NeJkynbBkYYGtXMBIhd5frZxDKvGQH
	3Ayuiwb/ZpWV9mKm+RXIsme9R4fZHsmMvoHA1pboe70rSdVaHBKmu2Vm1AK/e3dfP+VTLnTyYYz
	Blp+IYjea4VKpDfy51zycYDAKQojdz/6WTsLWy8fxn5PSRu7OSM+cHmkHmshtcnrBLJoscA74jb
	kPx7TK9z+NLDvov15+U6nFCBGHnF2w9lJv5lVVBV+yanCCQxY3VbG1wlXEA=
X-Received: by 2002:a2e:a9a9:0:b0:31e:9d54:62bc with SMTP id 38308e7fff4ca-32348b4dfe0mr13209001fa.14.1746430926264;
        Mon, 05 May 2025 00:42:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsEsHgZOcmzKyEYKe53zgGMeSaMF3WinuQkv4wSGTWsyP+GpxlPUt85uINmh0HuIcOZYrSLQ==
X-Received: by 2002:a05:600c:1e09:b0:43c:f895:cb4e with SMTP id 5b1f17b1804b1-441cb49494cmr15680615e9.17.1746430567130;
        Mon, 05 May 2025 00:36:07 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2706:e010:b099:aac6:4e70:6198? ([2a0d:3344:2706:e010:b099:aac6:4e70:6198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b391c42bsm162401715e9.39.2025.05.05.00.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 00:36:06 -0700 (PDT)
Message-ID: <8cdf120d-a0f0-4dcc-a8f9-cea967ce6e7b@redhat.com>
Date: Mon, 5 May 2025 09:36:03 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v13 4/9] net: devmem: Implement TX path
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, io-uring@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Jeroen de Borst <jeroendb@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn
 <willemb@google.com>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>,
 Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>,
 sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>,
 Victor Nogueira <victor@mojatatu.com>, Pedro Tammela
 <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>,
 Kaiyuan Zhang <kaiyuanz@google.com>
References: <20250429032645.363766-1-almasrymina@google.com>
 <20250429032645.363766-5-almasrymina@google.com>
 <53433089-7beb-46cf-ae8a-6c58cd909e31@redhat.com>
 <CAHS8izMefrkHf9WXerrOY4Wo8U2KmxSVkgY+4JB+6iDuoCZ3WQ@mail.gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <CAHS8izMefrkHf9WXerrOY4Wo8U2KmxSVkgY+4JB+6iDuoCZ3WQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/2/25 9:20 PM, Mina Almasry wrote:
> On Fri, May 2, 2025 at 4:47 AM Paolo Abeni <pabeni@redhat.com> wrote:
>>> @@ -1078,7 +1092,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>>                               zc = MSG_ZEROCOPY;
>>>               } else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>>>                       skb = tcp_write_queue_tail(sk);
>>> -                     uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
>>> +                     uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb),
>>> +                                                 sockc_valid && !!sockc.dmabuf_id);
>>
>> If sock_cmsg_send() failed and the user did not provide a dmabuf_id,
>> memory accounting will be incorrect.
> 
> Forgive me but I don't see it. sockc_valid will be false, so
> msg_zerocopy_realloc will do the normal MSG_ZEROCOPY accounting. Then
> below whech check sockc_valid in place of where we did the
> sock_cmsg_send before, and goto err. I assume the goto err should undo
> the memory accounting in the new code as in the old code. Can you
> elaborate on the bug you see?

Uhm, I think I misread the condition used for msg_zerocopy_realloc()
last argument.

Re-reading it now it the problem I see is that if sock_cmsg_send() fails
after correctly setting 'dmabuf_id', msg_zerocopy_realloc() will account
the dmabuf memory, which looks unexpected.

Somewhat related, I don't see any change to the msg_zerocopy/ubuf
complete/cleanup path(s): what will happen to the devmem ubuf memory at
uarg->complete() time? It looks like it will go unexpectedly through
mm_unaccount_pinned_pages()???

Thanks,

Paolo


