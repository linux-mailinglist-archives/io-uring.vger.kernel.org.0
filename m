Return-Path: <io-uring+bounces-345-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7583E81BDB9
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 18:57:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3239428A6DE
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 17:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE798634EC;
	Thu, 21 Dec 2023 17:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IjGXpRix"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E7E634EE;
	Thu, 21 Dec 2023 17:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-78106c385a1so66129185a.0;
        Thu, 21 Dec 2023 09:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703181456; x=1703786256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yKQZO+oMIxb+L/35Gcm255u4NIVS88PO7HEdsHog3wA=;
        b=IjGXpRixsi04pEsokBErT+i5kAExUqsBlgN1Y682v8KOagsNeJVkg6TRQhFcl2V95q
         I4ndVS4ULJAs8lpkDf9260Lqzyg3tMytPZKq/z6/GzjWVjDPKHi77kT3191bj3ZrvogC
         xpTDrvK5is6MJceykQ1JqS9o0cePAy8nsboCWU5Qt6zCFmwn9ZvhqsN2AF/FS6Ufcn77
         ALF2xlkStjXuYgR6tERXtTRh5bV0QrvUB1xpSfw/dule5/5rrgshd/bvcVP8bTQGjoiV
         JGxAlpgVo8bJ26mTMZF+xll8J6vYdKqiQfPzlLHlCr9h/N3u3F1gzdz5pGniQXoPY+cc
         7QxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703181456; x=1703786256;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yKQZO+oMIxb+L/35Gcm255u4NIVS88PO7HEdsHog3wA=;
        b=Fj/JY4oFM6gCc9Ku/YnZku4oNQztYCCDWrzPqqsq03LwWZrc3dOII9Ef3Nq3E6J+lo
         lVqI6ydmlQP4AddochodpztvhNIhs9hE7JvowIhhl9+MzRhnZdRUvjUHmH9G7A0vnv3Z
         br9YZLdtKddMeij1vPPrKYG1G8NT/BwBsixaNRFlr8uwezpq8cRzaQnVNJOcbO4+7T1+
         FFPtOM0HpSrFSpKsfbv+DZjaVOGBuC8S3r46ialj0yDCXh6YNpZv4wYe8ODRiJXxPKkI
         Y+u93wW90bvaTvsJjMVKjwk9L+j74pnSb5/VmMOqhdKX8HCy6xSudbSssZ1TPdBDyBes
         h9yQ==
X-Gm-Message-State: AOJu0YyEb5rEGPy2bBu5ymYOM5Gl7NZFUD1ogdfqH+YUbmn5EExv532d
	FinqoyOtsFDzjvwGh+6Y2MM=
X-Google-Smtp-Source: AGHT+IHeQR5V4He933XknvRdXl6RsNFfLpQkv8oih7pCPZe+NZwEhGAafy625/SchTXpsN4V+l3ATQ==
X-Received: by 2002:a05:620a:2610:b0:781:ee6:6318 with SMTP id z16-20020a05620a261000b007810ee66318mr167785qko.141.1703181455992;
        Thu, 21 Dec 2023 09:57:35 -0800 (PST)
Received: from localhost (114.66.194.35.bc.googleusercontent.com. [35.194.66.114])
        by smtp.gmail.com with ESMTPSA id b21-20020a05620a271500b007811eef5044sm541285qkp.72.2023.12.21.09.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 09:57:35 -0800 (PST)
Date: Thu, 21 Dec 2023 12:57:35 -0500
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: David Wei <dw@davidwei.uk>, 
 io-uring@vger.kernel.org, 
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, 
 Jesper Dangaard Brouer <hawk@kernel.org>, 
 David Ahern <dsahern@kernel.org>, 
 Mina Almasry <almasrymina@google.com>, 
 magnus.karlsson@intel.com, 
 bjorn@kernel.org
Message-ID: <65847c8f83f71_82de329487@willemb.c.googlers.com.notmuch>
In-Reply-To: <20231219210357.4029713-8-dw@davidwei.uk>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-8-dw@davidwei.uk>
Subject: Re: [RFC PATCH v3 07/20] io_uring: add interface queue
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

David Wei wrote:
> From: David Wei <davidhwei@meta.com>
> 
> This patch introduces a new object in io_uring called an interface queue
> (ifq) which contains:
> 
> * A pool region allocated by userspace and registered w/ io_uring where
>   Rx data is written to.
> * A net device and one specific Rx queue in it that will be configured
>   for ZC Rx.
> * A pair of shared ringbuffers w/ userspace, dubbed registered buf
>   (rbuf) rings. Each entry contains a pool region id and an offset + len
>   within that region. The kernel writes entries into the completion ring
>   to tell userspace where RX data is relative to the start of a region.
>   Userspace writes entries into the refill ring to tell the kernel when
>   it is done with the data.
> 
> For now, each io_uring instance has a single ifq, and each ifq has a
> single pool region associated with one Rx queue.
> 
> Add a new opcode to io_uring_register that sets up an ifq. Size and
> offsets of shared ringbuffers are returned to userspace for it to mmap.
> The implementation will be added in a later patch.
> 
> Signed-off-by: David Wei <dw@davidwei.uk>

This is quite similar to AF_XDP, of course. Is it at all possible to
reuse all or some of that? If not, why not?

As a side effect, unification would also show a path of moving AF_XDP
from its custom allocator to the page_pool infra.

Related: what is the story wrt the process crashing while user memory
is posted to the NIC or present in the kernel stack.

SO_DEVMEM already demonstrates zerocopy into user buffers using usdma.
To a certain extent that and asyncronous I/O with iouring are two
independent goals. SO_DEVMEM imposes limitations on the stack because
it might hold opaque device mem. That is too strong for this case.

But for this iouring provider, is there anything ioring specific about
it beyond being user memory? If not, maybe just call it a umem
provider, and anticipate it being usable for AF_XDP in the future too?

Besides delivery up to the intended socket, packets may also end up
in other code paths, such as packet sockets or forwarding. All of
this is simpler with userspace backed buffers than with device mem.
But good to call out explicitly how this is handled. MSG_ZEROCOPY
makes a deep packet copy in unexpected code paths, for instance. To
avoid indefinite latency to buffer reclaim.

