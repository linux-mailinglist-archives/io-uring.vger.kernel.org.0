Return-Path: <io-uring+bounces-370-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF496820FB3
	for <lists+io-uring@lfdr.de>; Sun, 31 Dec 2023 23:25:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D859D1C214BE
	for <lists+io-uring@lfdr.de>; Sun, 31 Dec 2023 22:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76160BE5F;
	Sun, 31 Dec 2023 22:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cJiEXAH8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1298C143;
	Sun, 31 Dec 2023 22:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-427d5bfe24cso46737461cf.1;
        Sun, 31 Dec 2023 14:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704061513; x=1704666313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2B1UYdh01D/aFcxewU2iYNFB5u7g0OvezMNr9MpvqPE=;
        b=cJiEXAH8/XkC7xCbhMk5+ZDaZWjQ9v7oHeNet6vsM0tJzrVUReLzOHpW6wRtRkWOU7
         eLBV7bB8ZkdpvytuwxA0MR3wrRdKqs7hCHDN2+9i0apln1xcdljpHbhRAE0xidJE+j+y
         5u+vS1jUzajtrtlVV8MNc4BT0FbLJUFMjfm00y55wYUo5b66iCf8oYMC9ALBZFG+QxGK
         TvBJSesHxS1+tr+05J2liH2foSlymDT983P1ptTyoDjutMIVQS9drJRZtVjKLzlvMXfC
         Wx0PUrqX/vuB5Nrkh24Uu9tzBSUU2OHyQPL9v9MvDnzsfxzzkCr5Lm21p7e4tk8LkCnY
         tr4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704061513; x=1704666313;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2B1UYdh01D/aFcxewU2iYNFB5u7g0OvezMNr9MpvqPE=;
        b=vY5erRtYplloHCGmAkfb3+76fxMISWJl6stcCMaX846LvPxmZgKXZ45m5yELvvQd+h
         S5f8uxBjw5vfY7WKNV6yUQsNiamUwbdBPPkFok+lqfDetj1P/yn94WEm8IiW0pyf3WLp
         rsJsCeXgK7yCLjiyWmr5k6M8ELvgidOFfbvscQsS0kQGz1hBCYuleKUvQ3Jts3jJnTAN
         FyeCNlCz/CDyCHVDfBFWv3diINkLBOeD9GC/gqi5C4zHou3MTUpj3DgnFuPsVj6IK3vI
         ZdylzaC02osg43skwlEJgi+xCtb311oMn21kPJRwqEhXZGxVq8qejUWS6ggXwM1umblu
         NFbw==
X-Gm-Message-State: AOJu0YwFjIdcG1kEFM3pI99ZBDEIPQo52Gq9KlixbyuuGzFpxozBGdSK
	I/Pq7qCTSWy9zi8CxeT0Vwo=
X-Google-Smtp-Source: AGHT+IGfabGU2Ehr63M1eaxUe61+2pB/M4XYiPTkc3p4YSrOAfv50hgqCb+wBTK/VMAsTy2XdR2HLQ==
X-Received: by 2002:a05:622a:13c7:b0:428:2447:a780 with SMTP id p7-20020a05622a13c700b004282447a780mr447277qtk.66.1704061513597;
        Sun, 31 Dec 2023 14:25:13 -0800 (PST)
Received: from localhost (48.230.85.34.bc.googleusercontent.com. [34.85.230.48])
        by smtp.gmail.com with ESMTPSA id z1-20020ac84541000000b00427e0e9c22dsm6149377qtn.54.2023.12.31.14.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Dec 2023 14:25:13 -0800 (PST)
Date: Sun, 31 Dec 2023 17:25:13 -0500
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 David Wei <dw@davidwei.uk>, 
 io-uring@vger.kernel.org, 
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, 
 Jesper Dangaard Brouer <hawk@kernel.org>, 
 David Ahern <dsahern@kernel.org>, 
 Mina Almasry <almasrymina@google.com>, 
 magnus.karlsson@intel.com, 
 bjorn@kernel.org
Message-ID: <6591ea497b5f_21420c29454@willemb.c.googlers.com.notmuch>
In-Reply-To: <11e7232f-88ed-4330-8320-b3504ffccd48@gmail.com>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-8-dw@davidwei.uk>
 <65847c8f83f71_82de329487@willemb.c.googlers.com.notmuch>
 <11e7232f-88ed-4330-8320-b3504ffccd48@gmail.com>
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

Pavel Begunkov wrote:
> On 12/21/23 17:57, Willem de Bruijn wrote:
> > David Wei wrote:
> >> From: David Wei <davidhwei@meta.com>
> >>
> >> This patch introduces a new object in io_uring called an interface queue
> >> (ifq) which contains:
> >>
> >> * A pool region allocated by userspace and registered w/ io_uring where
> >>    Rx data is written to.
> >> * A net device and one specific Rx queue in it that will be configured
> >>    for ZC Rx.
> >> * A pair of shared ringbuffers w/ userspace, dubbed registered buf
> >>    (rbuf) rings. Each entry contains a pool region id and an offset + len
> >>    within that region. The kernel writes entries into the completion ring
> >>    to tell userspace where RX data is relative to the start of a region.
> >>    Userspace writes entries into the refill ring to tell the kernel when
> >>    it is done with the data.
> >>
> >> For now, each io_uring instance has a single ifq, and each ifq has a
> >> single pool region associated with one Rx queue.
> >>
> >> Add a new opcode to io_uring_register that sets up an ifq. Size and
> >> offsets of shared ringbuffers are returned to userspace for it to mmap.
> >> The implementation will be added in a later patch.
> >>
> >> Signed-off-by: David Wei <dw@davidwei.uk>
> > 
> > This is quite similar to AF_XDP, of course. Is it at all possible to
> > reuse all or some of that? If not, why not?
> 
> Let me rather ask what do you have in mind for reuse? I'm not too
> intimately familiar with xdp, but I don't see what we can take.

At a high level all points in this commit message:

	* A pool region allocated by userspace and registered w/ io_uring where
	  Rx data is written to.
	* A net device and one specific Rx queue in it that will be configured
	  for ZC Rx.
	* A pair of shared ringbuffers w/ userspace, dubbed registered buf
	  (rbuf) rings. Each entry contains a pool region id and an offset + len
	  within that region. The kernel writes entries into the completion ring
	  to tell userspace where RX data is relative to the start of a region.
	  Userspace writes entries into the refill ring to tell the kernel when
	  it is done with the data.

	For now, each io_uring instance has a single ifq, and each ifq has a
	single pool region associated with one Rx queue.

AF_XDP allows shared pools, but otherwise this sounds like the same
feature set.

> Queue formats will be different

I'd like to makes sure that this is for a reason. Not just divergence
because we did not consider reusing existing user/kernel queue formats.

> there won't be a separate CQ
> for zc all they will lend in the main io_uring CQ in next revisions.

Okay, that's different.

> io_uring also supports multiple sockets per zc ifq and other quirks
> reflected in the uapi.
> 
> Receive has to work with generic sockets and skbs if we want
> to be able to reuse the protocol stack. Queue allocation and
> mapping is similar but that one thing that should be bound to
> the API (i.e. io_uring vs af xdp) together with locking and
> synchronisation. Wakeups are different as well.
> 
> And IIUC AF_XDP is still operates with raw packets quite early
> in the stack, while io_uring completes from a syscall, that
> would definitely make sync diverging a lot.

The difference is in frame payload, not in the queue structure:
a fixed frame buffer pool plus sets of post + completion queues that
store a relative offset and length into that pool.

I don't intend to ask for the impossible, to be extra clear: If there
are reasons the structures need to be different, so be it. And no
intention to complicate development. Anything not ABI can be
refactored later, too, if overlap becomes clear. But for ABI it's
worth asking now whether these queue formats really are different for
a concrete reason.

> I don't see many opportunities here.
> 
> > As a side effect, unification would also show a path of moving AF_XDP
> > from its custom allocator to the page_pool infra.
> 
> I assume it's about xsk_buff_alloc() and likes of it. I'm lacking
> here, I it's much better to ask XDP guys what they think about
> moving to pp, whether it's needed, etc. And if so, it'd likely
> be easier to base it on raw page pool providers api than the io_uring
> provider implementation, probably having some common helpers if
> things come to that.

Fair enough, on giving it some more thought and reviewing a recent
use case of the AF_XDP allocation APIs including xsk_buff_alloc.

> 
> > Related: what is the story wrt the process crashing while user memory
> > is posted to the NIC or present in the kernel stack.
> 
> Buffers are pinned by io_uring. If the process crashes closing the
> ring, io_uring will release the pp provider and wait for all buffer
> to come back before unpinning pages and freeing the rest. I.e.
> it's not going to unpin before pp's ->destroy is called.

Great. That's how all page pools work iirc. There is some potential
concern with unbound delay until all buffers are recycled. But that
is not unique to the io_uring provider.

> > SO_DEVMEM already demonstrates zerocopy into user buffers using usdma.
> > To a certain extent that and asyncronous I/O with iouring are two
> > independent goals. SO_DEVMEM imposes limitations on the stack because
> > it might hold opaque device mem. That is too strong for this case.
> 
> Basing it onto ppiov simplifies refcounting a lot, with that we
> don't need any dirty hacks nor adding any extra changes in the stack,
> and I think it's aligned with the net stack goals.

Great to hear.

> What I think
> we can do on top is allowing ppiov's to optionally have pages
> (via a callback ->get_page), and use it it in those rare cases
> when someone has to peek at the payload.
> 
> > But for this iouring provider, is there anything ioring specific about
> > it beyond being user memory? If not, maybe just call it a umem
> > provider, and anticipate it being usable for AF_XDP in the future too?
> 
> Queue formats with a set of features, synchronisation, mostly
> answered above, but I also think it should as easy to just have
> a separate provider and reuse some code later if there is anything
> to reuse.
> 
> > Besides delivery up to the intended socket, packets may also end up
> > in other code paths, such as packet sockets or forwarding. All of
> > this is simpler with userspace backed buffers than with device mem.
> > But good to call out explicitly how this is handled. MSG_ZEROCOPY
> > makes a deep packet copy in unexpected code paths, for instance. To
> > avoid indefinite latency to buffer reclaim.
> 
> Yeah, that's concerning, I intend to add something for the sockets
> we used, but there is nothing for truly unexpected paths. How devmem
> handles it?

MSG_ZEROCOPY handles this by copying to regular kernel memory using
skb_orphan_frags_rx whenever a tx packet could get looped onto an rx
queue and thus held indefinitely. This is not allowed for MSG_ZEROCOPY
as it causes a potentially unbound latency before data can be reused
by the application. Called from __netif_receive_skb_core,
dev_queue_xmit_nit and a few others.

SO_DEVMEM does allow data to enter packet sockets, but instruments
each point that might reference memory to not do this. For instance:

	@@ -2156,7 +2156,7 @@  static int packet_rcv(struct sk_buff *skb, struct net_device *dev,
			}
		}
	 
	-	snaplen = skb->len;
	+	snaplen = skb_frags_readable(skb) ? skb->len : skb_headlen(skb);

https://patchwork.kernel.org/project/netdevbpf/patch/20231218024024.3516870-11-almasrymina@google.com/

Either approach could be extended to cover io_uring packets.

Multicast is a perhaps an interesting other receive case. I have not
given that much thought.

> It's probably not a huge worry for now, I expect killing the
> task/sockets should resolve dependencies, but would be great to find
> such scenarios. I'd appreciate any pointers if you have some in mind.
> 
> -- 
> Pavel Begunkov



