Return-Path: <io-uring+bounces-5352-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C1E9E9D82
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 18:51:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2A55282ABE
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 17:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A96A1B0420;
	Mon,  9 Dec 2024 17:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UBCCDmwf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059791534EC
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733766681; cv=none; b=Yn3I1W/3R+9bhro9dbeNntRO48fdbO+U0IcALN5fMYBQxsVgdq69HHwUTRqoahkCpYAx5szTivJ9TnjtrkJZZwHvqk1TPTa/EOasctvL/QlqWdlJxUZMmm0KlfZjtBrlAka58wQFXlRDs2i5GgN4Lkfva+A/1yY6uSmwM+ngwpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733766681; c=relaxed/simple;
	bh=I650u4xgoBvZVnpFknCJORT87dGzGprkCetninL2hTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oWxV2CdCiudWdYX5EiAFnPRhwCRHkSgMvYiQFPpx0AkO4zgQw3ifjxDMzdtuCAZo2nNbTiXNjbfYHJT7DhKV330b2N2KyAiHlUycE1ad3nueH9hWKBgWVd3tEdrWVYyoie6IbxIm4Nv4/vpn+61ZfDXyxgYojxSxuSllb8iiGik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UBCCDmwf; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4675936f333so321111cf.0
        for <io-uring@vger.kernel.org>; Mon, 09 Dec 2024 09:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733766677; x=1734371477; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5mBPvczMWM/n5bKZ9YlmyB0NFq3GEO6dYo6FnSFDkwk=;
        b=UBCCDmwfheFAdt+1y5HT4OFrP9evdDUof3V/dXcgDney6vBp7ck0CPCCiCaXkhgitK
         QHFzFUTLbSHpGexFnWJBfKDULPXQ2H0lYK7lfkZI0vCaBndObfFftXtrZP7aef/JYG5/
         4GVBCkMwKbMlSKDSrNQflSCIvcBSUvrTjD4+THXZprcaGrYEd1Qi8r3Zjb/rQSX/7E7V
         86iAwVlv2Nb8ECTngsy/JyCrMn5tLDgNaOoMV89i65/enJ8wZKOhzCRLKg/fAgKcODMm
         o0VNb8gpcvXvR+8ywxEMAnWLRJtmDyQx2b8PlLMnFeAxvEmZpCcOrEvNcGGBp3svheWr
         Ijug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733766677; x=1734371477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5mBPvczMWM/n5bKZ9YlmyB0NFq3GEO6dYo6FnSFDkwk=;
        b=t3UJn8UbDe97+ejeO/wbqip6QQd5xfWlqJs2+wxuTNkx9pX6031xHMH0mx152qZZ7m
         nvCgF2cJSFzK0zkmmunjnSKgAVqWmrBIPCitGkiXtQSFdpc8RGi6ZZCBzzlJaKiZuxlG
         EXxKyQSUeTCUMtDX58TKfyDDNeaqKDIvyAO+5LWNN2FqbK5TeXXU2JzrQnG9/HsMO5Qj
         c1CD6pcJfPv2FbN84r/5ftp+Xy1Ygo+Vkn4fSm6o+bPzimyC2LUYYTxipzvlHfsiye/6
         BNzD5e1Mj6YB/mEII09TvTe4Gnx2Td1RD8r+Fpp65Mxz70Mi0aGwQ5IdswFrDQWS7U+q
         /KXQ==
X-Gm-Message-State: AOJu0YzrDswzE26biqwqB/qIt1Xsi4PcMnfvmSrnqO+KfMAU3rk3ZKoL
	wCHrol/fUF4V6TQxXt0rB5gPTm6PdaiFxrfu6PMeXs3RtQo5YPPBRuWjI6jY7n6A0ZoMAcwpiQw
	tjXHNqBxCHxpT/rCwjdXx4WX+OygUwBtLy5Zs
X-Gm-Gg: ASbGncuAB+6OnhZ0coS/1s+Qyeg1s9sKm5eHkLfRJ+ar14H9KLCIRxdCPy72heST5MV
	iTKiCl1MV3NQ53tbU5B3hjZrMZ9EHWJnJ6iqeb6/cDSVAASoOXK1e2a3f9E9ZHQ==
X-Google-Smtp-Source: AGHT+IE7xvWGaHaycDDuW3FhhbirXibugXj3omDncQUKbGN7PZSoEothwM/hNMib71fL12aAIYzaHzO8ImgEqcQz2zU=
X-Received: by 2002:a05:622a:5e13:b0:466:975f:b219 with SMTP id
 d75a77b69052e-46746f3433emr10033691cf.8.1733766676670; Mon, 09 Dec 2024
 09:51:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204172204.4180482-1-dw@davidwei.uk> <20241204172204.4180482-17-dw@davidwei.uk>
In-Reply-To: <20241204172204.4180482-17-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 9 Dec 2024 09:51:04 -0800
Message-ID: <CAHS8izP3mo=BYNxKawetg5vNxgRhtUOU2qykJxkWpvua8HQU6g@mail.gmail.com>
Subject: Re: [PATCH net-next v8 16/17] net: add documentation for io_uring zcrx
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 9:23=E2=80=AFAM David Wei <dw@davidwei.uk> wrote:
>
> Add documentation for io_uring zero copy Rx that explains requirements
> and the user API.
>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  Documentation/networking/iou-zcrx.rst | 201 ++++++++++++++++++++++++++
>  1 file changed, 201 insertions(+)
>  create mode 100644 Documentation/networking/iou-zcrx.rst
>
> diff --git a/Documentation/networking/iou-zcrx.rst b/Documentation/networ=
king/iou-zcrx.rst
> new file mode 100644
> index 000000000000..0a3af8c08c7e
> --- /dev/null
> +++ b/Documentation/networking/iou-zcrx.rst
> @@ -0,0 +1,201 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +io_uring zero copy Rx
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Introduction
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +io_uring zero copy Rx (ZC Rx) is a feature that removes kernel-to-user c=
opy on
> +the network receive path, allowing packet data to be received directly i=
nto
> +userspace memory. This feature is different to TCP_ZEROCOPY_RECEIVE in t=
hat
> +there are no strict alignment requirements and no need to mmap()/munmap(=
).
> +Compared to kernel bypass solutions such as e.g. DPDK, the packet header=
s are
> +processed by the kernel TCP stack as normal.
> +
> +NIC HW Requirements
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Several NIC HW features are required for io_uring ZC Rx to work. For now=
 the
> +kernel API does not configure the NIC and it must be done by the user.
> +
> +Header/data split
> +-----------------
> +
> +Required to split packets at the L4 boundary into a header and a payload=
.
> +Headers are received into kernel memory as normal and processed by the T=
CP
> +stack as normal. Payloads are received into userspace memory directly.
> +
> +Flow steering
> +-------------
> +
> +Specific HW Rx queues are configured for this feature, but modern NICs
> +typically distribute flows across all HW Rx queues. Flow steering is req=
uired
> +to ensure that only desired flows are directed towards HW queues that ar=
e
> +configured for io_uring ZC Rx.
> +
> +RSS
> +---
> +
> +In addition to flow steering above, RSS is required to steer all other n=
on-zero
> +copy flows away from queues that are configured for io_uring ZC Rx.
> +
> +Usage
> +=3D=3D=3D=3D=3D
> +
> +Setup NIC
> +---------
> +
> +Must be done out of band for now.

I would remove any 'for now' instances in the docs. Uapis are going to
be maintained as-is for posterity. Even if you in the future add new
APIs which auto-configure headersplit/flow steering/rss, I'm guessing
the current API would live on for backward compatibility reasons.

> +
> +Ensure there are enough queues::

Was not clear to me what are enough queues. Technically you only need
2 queues, right? (one for iozcrx and one for normal traffic).

> +
> +  ethtool -L eth0 combined 32
> +
> +Enable header/data split::
> +
> +  ethtool -G eth0 tcp-data-split on
> +
> +Carve out half of the HW Rx queues for zero copy using RSS::
> +
> +  ethtool -X eth0 equal 16
> +
> +Set up flow steering::
> +
> +  ethtool -N eth0 flow-type tcp6 ... action 16
> +
> +Setup io_uring
> +--------------
> +
> +This section describes the low level io_uring kernel API. Please refer t=
o
> +liburing documentation for how to use the higher level API.
> +
> +Create an io_uring instance with the following required setup flags::
> +
> +  IORING_SETUP_SINGLE_ISSUER
> +  IORING_SETUP_DEFER_TASKRUN
> +  IORING_SETUP_CQE32
> +
> +Create memory area
> +------------------
> +
> +Allocate userspace memory area for receiving zero copy data::
> +
> +  void *area_ptr =3D mmap(NULL, area_size,
> +                        PROT_READ | PROT_WRITE,
> +                        MAP_ANONYMOUS | MAP_PRIVATE,
> +                        0, 0);
> +
> +Create refill ring
> +------------------
> +
> +Allocate memory for a shared ringbuf used for returning consumed buffers=
::
> +
> +  void *ring_ptr =3D mmap(NULL, ring_size,
> +                        PROT_READ | PROT_WRITE,
> +                        MAP_ANONYMOUS | MAP_PRIVATE,
> +                        0, 0);
> +
> +This refill ring consists of some space for the header, followed by an a=
rray of
> +``struct io_uring_zcrx_rqe``::
> +
> +  size_t rq_entries =3D 4096;
> +  size_t ring_size =3D rq_entries * sizeof(struct io_uring_zcrx_rqe) + P=
AGE_SIZE;
> +  /* align to page size */
> +  ring_size =3D (ring_size + (PAGE_SIZE - 1)) & ~(PAGE_SIZE - 1);
> +
> +Register ZC Rx
> +--------------
> +
> +Fill in registration structs::
> +
> +  struct io_uring_zcrx_area_reg area_reg =3D {
> +    .addr =3D (__u64)(unsigned long)area_ptr,
> +    .len =3D area_size,
> +    .flags =3D 0,
> +  };
> +
> +  struct io_uring_region_desc region_reg =3D {
> +    .user_addr =3D (__u64)(unsigned long)ring_ptr,
> +    .size =3D ring_size,
> +    .flags =3D IORING_MEM_REGION_TYPE_USER,
> +  };
> +
> +  struct io_uring_zcrx_ifq_reg reg =3D {
> +    .if_idx =3D if_nametoindex("eth0"),
> +    /* this is the HW queue with desired flow steered into it */
> +    .if_rxq =3D 16,
> +    .rq_entries =3D rq_entries,
> +    .area_ptr =3D (__u64)(unsigned long)&area_reg,
> +    .region_ptr =3D (__u64)(unsigned long)&region_reg,
> +  };
> +
> +Register with kernel::
> +
> +  io_uring_register_ifq(ring, &reg);
> +
> +Map refill ring
> +---------------
> +
> +The kernel fills in fields for the refill ring in the registration ``str=
uct
> +io_uring_zcrx_ifq_reg``. Map it into userspace::
> +
> +  struct io_uring_zcrx_rq refill_ring;
> +
> +  refill_ring.khead =3D (unsigned *)((char *)ring_ptr + reg.offsets.head=
);
> +  refill_ring.khead =3D (unsigned *)((char *)ring_ptr + reg.offsets.tail=
);
> +  refill_ring.rqes =3D
> +    (struct io_uring_zcrx_rqe *)((char *)ring_ptr + reg.offsets.rqes);
> +  refill_ring.rq_tail =3D 0;
> +  refill_ring.ring_ptr =3D ring_ptr;
> +
> +Receiving data
> +--------------
> +
> +Prepare a zero copy recv request::
> +
> +  struct io_uring_sqe *sqe;
> +
> +  sqe =3D io_uring_get_sqe(ring);
> +  io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, fd, NULL, 0, 0);
> +  sqe->ioprio |=3D IORING_RECV_MULTISHOT;
> +
> +Now, submit and wait::
> +
> +  io_uring_submit_and_wait(ring, 1);
> +
> +Finally, process completions::
> +
> +  struct io_uring_cqe *cqe;
> +  unsigned int count =3D 0;
> +  unsigned int head;
> +
> +  io_uring_for_each_cqe(ring, head, cqe) {
> +    struct io_uring_zcrx_cqe *rcqe =3D (struct io_uring_zcrx_cqe *)(cqe =
+ 1);
> +
> +    unsigned char *data =3D area_ptr + (rcqe->off & IORING_ZCRX_AREA_MAS=
K);
> +    /* do something with the data */
> +
> +    count++;
> +  }
> +  io_uring_cq_advance(ring, count);
> +
> +Recycling buffers
> +-----------------
> +
> +Return buffers back to the kernel to be used again::
> +
> +  struct io_uring_zcrx_rqe *rqe;
> +  unsigned mask =3D refill_ring.ring_entries - 1;
> +  rqe =3D &refill_ring.rqes[refill_ring.rq_tail & mask];
> +
> +  area_offset =3D rcqe->off & IORING_ZCRX_AREA_MASK;
> +  rqe->off =3D area_offset | area_reg.rq_area_token;
> +  rqe->len =3D cqe->res;
> +  IO_URING_WRITE_ONCE(*refill_ring.ktail, ++refill_ring.rq_tail);
> +

Ah, I see why it's difficult for you to napi_pp_put_page() refilled
pages. In part it's because the refill code in the userspace never
traps into the kernel. Got it.

I guess I read from the other thread that there are some
(significant?) changes in the next version to incorporate feedback
from Jakub, so I guess I'll wait for that before commenting further.


--=20
Thanks,
Mina

