Return-Path: <io-uring+bounces-362-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 544F3820757
	for <lists+io-uring@lfdr.de>; Sat, 30 Dec 2023 17:29:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF9ED1F21E11
	for <lists+io-uring@lfdr.de>; Sat, 30 Dec 2023 16:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B383947F;
	Sat, 30 Dec 2023 16:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DLZ2fcMQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505F2156E8;
	Sat, 30 Dec 2023 16:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40d5b159350so36243575e9.2;
        Sat, 30 Dec 2023 08:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703953641; x=1704558441; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jcc7THfOf7mG9cp0BPwPix9VTXZppS8GBKJCQR6RBvY=;
        b=DLZ2fcMQgv1uxxH1dARaSvfinbj2EZaUa3PfvXL7Oo3d+AqjWNl2F+IFVfvvVdyD7i
         wkwUBiLJOmzz3lQbikm+rr8pq1UXuC5b+UoDULHg4DM7Q6LbbJV6ZCjAjNV0z5HLVifD
         DPu+7eg8H4aZWptO3in9j8F7ysgVGgQZ9Lxr1+LslIiUB3gPTEcJpbb03IOLzu8B9MWI
         nnkxTcsMdo918WWniIDOjU7wDcz2P/p8IW5kXb1OfIItjgxzk6JQQ8B5tzUQiN7Z3DHr
         BWknioa4InH1ozIMybudShAnfM0BVJnIqSzhv/FIuyVlIu2g9SYlpjCTxK6FAfAACmd9
         Ja6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703953641; x=1704558441;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jcc7THfOf7mG9cp0BPwPix9VTXZppS8GBKJCQR6RBvY=;
        b=ldO7/YhBa4E7eQ/BxE5z0z2Jj5Ecaojy/fch21/a4k8vZyGk+ktzDQPtRLozR/dHpo
         z/qEXpVLYj95IzJuRvAZVR/xQlImLPC3c6JWnLdiJ3BaP55uNEtAHkTokSUJtYSyxt6w
         /pfHurEiEILA2WiT9eB2/TVTZlFeMJWxG3Gy6xt0LOZLnHPpW0I9HLmU+OPhwOeUFOEr
         it3L5N8wagJkG5XPKSXbzrjl/18eP+V7o3VLTCa2i8xveI0mnVws3nO/NOqMmQIVM6MX
         FXd0e8V36RPXOU2xTgiRJvNFTFFRf+XOYHmF6coIcjzTNaTZXSBAZBZwJIwOi7fdmkDp
         CR9w==
X-Gm-Message-State: AOJu0Yywhrilm5u0+fylDObXtLhCIF3yv3Wl78egnCyVyPKyEYPlH9vG
	iP62gtNp1etxA2RGyhNQgYg=
X-Google-Smtp-Source: AGHT+IFXc6aQcDWDa96p1h54CQ4o1qkepjqD9vEqVSRUDFijeiDf0QWDbfv3ljmvkWkatzEWREXBHQ==
X-Received: by 2002:a05:600c:4fd3:b0:40d:5e74:89e8 with SMTP id o19-20020a05600c4fd300b0040d5e7489e8mr2766998wmq.55.1703953641269;
        Sat, 30 Dec 2023 08:27:21 -0800 (PST)
Received: from [192.168.8.100] ([148.252.133.126])
        by smtp.gmail.com with ESMTPSA id p2-20020a05600c1d8200b0040596352951sm43557299wms.5.2023.12.30.08.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Dec 2023 08:27:20 -0800 (PST)
Message-ID: <11e7232f-88ed-4330-8320-b3504ffccd48@gmail.com>
Date: Sat, 30 Dec 2023 16:25:43 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 07/20] io_uring: add interface queue
Content-Language: en-US
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>, magnus.karlsson@intel.com,
 bjorn@kernel.org
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-8-dw@davidwei.uk>
 <65847c8f83f71_82de329487@willemb.c.googlers.com.notmuch>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <65847c8f83f71_82de329487@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/21/23 17:57, Willem de Bruijn wrote:
> David Wei wrote:
>> From: David Wei <davidhwei@meta.com>
>>
>> This patch introduces a new object in io_uring called an interface queue
>> (ifq) which contains:
>>
>> * A pool region allocated by userspace and registered w/ io_uring where
>>    Rx data is written to.
>> * A net device and one specific Rx queue in it that will be configured
>>    for ZC Rx.
>> * A pair of shared ringbuffers w/ userspace, dubbed registered buf
>>    (rbuf) rings. Each entry contains a pool region id and an offset + len
>>    within that region. The kernel writes entries into the completion ring
>>    to tell userspace where RX data is relative to the start of a region.
>>    Userspace writes entries into the refill ring to tell the kernel when
>>    it is done with the data.
>>
>> For now, each io_uring instance has a single ifq, and each ifq has a
>> single pool region associated with one Rx queue.
>>
>> Add a new opcode to io_uring_register that sets up an ifq. Size and
>> offsets of shared ringbuffers are returned to userspace for it to mmap.
>> The implementation will be added in a later patch.
>>
>> Signed-off-by: David Wei <dw@davidwei.uk>
> 
> This is quite similar to AF_XDP, of course. Is it at all possible to
> reuse all or some of that? If not, why not?

Let me rather ask what do you have in mind for reuse? I'm not too
intimately familiar with xdp, but I don't see what we can take.

Queue formats will be different, there won't be a separate CQ
for zc all they will lend in the main io_uring CQ in next revisions.
io_uring also supports multiple sockets per zc ifq and other quirks
reflected in the uapi.

Receive has to work with generic sockets and skbs if we want
to be able to reuse the protocol stack. Queue allocation and
mapping is similar but that one thing that should be bound to
the API (i.e. io_uring vs af xdp) together with locking and
synchronisation. Wakeups are different as well.

And IIUC AF_XDP is still operates with raw packets quite early
in the stack, while io_uring completes from a syscall, that
would definitely make sync diverging a lot.

I don't see many opportunities here.

> As a side effect, unification would also show a path of moving AF_XDP
> from its custom allocator to the page_pool infra.

I assume it's about xsk_buff_alloc() and likes of it. I'm lacking
here, I it's much better to ask XDP guys what they think about
moving to pp, whether it's needed, etc. And if so, it'd likely
be easier to base it on raw page pool providers api than the io_uring
provider implementation, probably having some common helpers if
things come to that.

> Related: what is the story wrt the process crashing while user memory
> is posted to the NIC or present in the kernel stack.

Buffers are pinned by io_uring. If the process crashes closing the
ring, io_uring will release the pp provider and wait for all buffer
to come back before unpinning pages and freeing the rest. I.e.
it's not going to unpin before pp's ->destroy is called.

> SO_DEVMEM already demonstrates zerocopy into user buffers using usdma.
> To a certain extent that and asyncronous I/O with iouring are two
> independent goals. SO_DEVMEM imposes limitations on the stack because
> it might hold opaque device mem. That is too strong for this case.

Basing it onto ppiov simplifies refcounting a lot, with that we
don't need any dirty hacks nor adding any extra changes in the stack,
and I think it's aligned with the net stack goals. What I think
we can do on top is allowing ppiov's to optionally have pages
(via a callback ->get_page), and use it it in those rare cases
when someone has to peek at the payload.

> But for this iouring provider, is there anything ioring specific about
> it beyond being user memory? If not, maybe just call it a umem
> provider, and anticipate it being usable for AF_XDP in the future too?

Queue formats with a set of features, synchronisation, mostly
answered above, but I also think it should as easy to just have
a separate provider and reuse some code later if there is anything
to reuse.

> Besides delivery up to the intended socket, packets may also end up
> in other code paths, such as packet sockets or forwarding. All of
> this is simpler with userspace backed buffers than with device mem.
> But good to call out explicitly how this is handled. MSG_ZEROCOPY
> makes a deep packet copy in unexpected code paths, for instance. To
> avoid indefinite latency to buffer reclaim.

Yeah, that's concerning, I intend to add something for the sockets
we used, but there is nothing for truly unexpected paths. How devmem
handles it?

It's probably not a huge worry for now, I expect killing the
task/sockets should resolve dependencies, but would be great to find
such scenarios. I'd appreciate any pointers if you have some in mind.

-- 
Pavel Begunkov

