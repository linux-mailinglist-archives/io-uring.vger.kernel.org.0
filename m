Return-Path: <io-uring+bounces-7827-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC6B1AA7A2D
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 21:25:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 407FF4C70E5
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 19:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE7451F1538;
	Fri,  2 May 2025 19:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ro3aLQGX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2539F1EFFA2
	for <io-uring@vger.kernel.org>; Fri,  2 May 2025 19:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746213939; cv=none; b=jYCVEZw5CF/ZEhz6xhGwIfFnuAXFHzwipe/a68Ah1ZddR34Be+M8xaCKAq1K3gYPoT01NloLPPmZ92U+wMdtPcsSzL1vUg6OXRuB2Jgwmqec8UXF6p+AYVSV73WFMg4wkCFNcIruMN1btoStP1RmMe6NVEqq/Ui9n/G65S1pg20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746213939; c=relaxed/simple;
	bh=ZOraj867pk/cuv9sGYnTnO1GOcFc4HnKNvgp4QcVTF8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LbBUnUAbKq8YVrBcRYDtAWuTQjRLI7AsZvQiHFwQFAY/zYrjP0VYgbqteVLgvMgK0abbsT/D5uH+FMnrRWqnriso1PKnlKEViROowdVWNM7zzuyP5R8/q6998A6lierOUzlU7Qj1RXe3/MWIKHmdtG2TZimm9DWY0vlb7z0T1sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ro3aLQGX; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2264c9d0295so31825ad.0
        for <io-uring@vger.kernel.org>; Fri, 02 May 2025 12:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746213937; x=1746818737; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZOraj867pk/cuv9sGYnTnO1GOcFc4HnKNvgp4QcVTF8=;
        b=Ro3aLQGXP8CNe9vRdK6XeulHVcTX2VBrUyrixmFqJdUgryLQtuH8O9cayvD79Dqomd
         hHQSiFSkuPc95X4JNas9F2/1xwcaILkXQgzpKCY86CeiOFD+5Sy0rkj8IdkC9tG64AFB
         +sLGwf0iJDKBNf46VNhOVRoslDOQ196S0dd0WmPb+3GIOS0GZsBtYyrBQgSFUD+hgnDw
         lPFeizJfOAIUiji8A8rGz1sEsM/yvDyh8s1u+zu5Oml7qMF86VPdPkxZzBC9Ue5D6ta5
         ogZi4kL6PgyFcScnHTl1aC7EYD3oJFVe7/pDKpJuFv0se1smNPI6iRl9/1tRg8oY0tuB
         Q0rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746213937; x=1746818737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZOraj867pk/cuv9sGYnTnO1GOcFc4HnKNvgp4QcVTF8=;
        b=McK6CqJQ7OxwvSXGGvYU6jcM4AlJYzntKVl0kIHX6cgJpU5jn1aRSwqJ00IREe0TMA
         RflmKhNFwkjF32GJKshCQnSWWWU5gMP43UH840JgBTw9CQqUt71WWikLmPFoQFIw0Y29
         PmeflsSn8PkT8RaJSJToN5mdK6dpo925gVsfCZy4UmTTFzrBkkIxT4PThN/+SNVfrkvL
         GvNRlq1FIDEGr/TQpKiCyPKEQ5Q0qS6d75mppJdTakqsBXL5ajFPcSjTwiIDeNwWnI2m
         JL47rDLmmUsi2S9b2tT6mGVNRITYS4f12oPrKw9CGw9oXdoHLAprpB9uvvf7UcD8zoVy
         E0Lw==
X-Forwarded-Encrypted: i=1; AJvYcCVT/HciFOxH3QMk89/fmzivqzCykrw+i2skinun2xEypiZ806SjGVA+C5UilStCKtQEuX3YaZ00eg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyH/j9MH+7X6423v9G3UP1NkZzO1TQB57Jg4cM3Y4BUCIF/FxL1
	71hHx6r+Lnkkl8JDBTFPAIMyTkBnqQyO72VwAojXJv47kZRzjvaoDnG84GMGwBEjy9HtMTOzShV
	8qih+jvjvsXD6WC7OqBStsfpprvaJgHn7pnjt
X-Gm-Gg: ASbGncvTLsTWtDRlJsMNNVablXm5lHGysOfqS4fmMel42MCT8kthnZ6rLmtzES7iXXt
	/0p45whAr3jyY5P1cdioiqwlYivitKZnmHpVcW+cocoR5VNLy4RHkiVZSYeTiZvZtWFsjxs7/bq
	KtIlOZFV3wftlO5+MM25SIfdJAhYZypX/y8A==
X-Google-Smtp-Source: AGHT+IHUOjgBbVOP8EhCotYEtz1xj8om994DHh63iGGlYgne8/oHskra7BjgsemS01jDY9TsbdDObHSsJ810l2GltBI=
X-Received: by 2002:a17:902:ce07:b0:21f:4986:c7d5 with SMTP id
 d9443c01a7336-22e18a3edccmr455755ad.8.1746213937102; Fri, 02 May 2025
 12:25:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250429032645.363766-1-almasrymina@google.com>
 <20250429032645.363766-5-almasrymina@google.com> <53433089-7beb-46cf-ae8a-6c58cd909e31@redhat.com>
 <fd7f21d9-3f45-4f68-85cb-dd160a0a95ca@redhat.com>
In-Reply-To: <fd7f21d9-3f45-4f68-85cb-dd160a0a95ca@redhat.com>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 2 May 2025 12:25:23 -0700
X-Gm-Features: ATxdqUFE7sBpQ0aEoZkfu-r1bro_WuWZDP8nLd_pOK-7HB7CvYHcAcfjkOn9v8E
Message-ID: <CAHS8izPr_yt+PtG5Q++Ub=D4J=H7nP0S_7rOP9G7W=i2Zeau3g@mail.gmail.com>
Subject: Re: [PATCH net-next v13 4/9] net: devmem: Implement TX path
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	Donald Hunter <donald.hunter@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, Jeroen de Borst <jeroendb@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>, 
	Victor Nogueira <victor@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Kaiyuan Zhang <kaiyuanz@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 2, 2025 at 4:51=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On 5/2/25 1:47 PM, Paolo Abeni wrote:
> > On 4/29/25 5:26 AM, Mina Almasry wrote:
> >> Augment dmabuf binding to be able to handle TX. Additional to all the =
RX
> >> binding, we also create tx_vec needed for the TX path.
> >>
> >> Provide API for sendmsg to be able to send dmabufs bound to this devic=
e:
> >>
> >> - Provide a new dmabuf_tx_cmsg which includes the dmabuf to send from.
> >> - MSG_ZEROCOPY with SCM_DEVMEM_DMABUF cmsg indicates send from dma-buf=
.
> >>
> >> Devmem is uncopyable, so piggyback off the existing MSG_ZEROCOPY
> >> implementation, while disabling instances where MSG_ZEROCOPY falls bac=
k
> >> to copying.
> >>
> >> We additionally pipe the binding down to the new
> >> zerocopy_fill_skb_from_devmem which fills a TX skb with net_iov netmem=
s
> >> instead of the traditional page netmems.
> >>
> >> We also special case skb_frag_dma_map to return the dma-address of the=
se
> >> dmabuf net_iovs instead of attempting to map pages.
> >>
> >> The TX path may release the dmabuf in a context where we cannot wait.
> >> This happens when the user unbinds a TX dmabuf while there are still
> >> references to its netmems in the TX path. In that case, the netmems wi=
ll
> >> be put_netmem'd from a context where we can't unmap the dmabuf, Resolv=
e
> >> this by making __net_devmem_dmabuf_binding_free schedule_work'd.
> >>
> >> Based on work by Stanislav Fomichev <sdf@fomichev.me>. A lot of the me=
at
> >> of the implementation came from devmem TCP RFC v1[1], which included t=
he
> >> TX path, but Stan did all the rebasing on top of netmem/net_iov.
> >>
> >> Cc: Stanislav Fomichev <sdf@fomichev.me>
> >> Signed-off-by: Kaiyuan Zhang <kaiyuanz@google.com>
> >> Signed-off-by: Mina Almasry <almasrymina@google.com>
> >> Acked-by: Stanislav Fomichev <sdf@fomichev.me>
> >
> > I'm sorry for the late feedback. A bunch of things I did not notice
> > before...
>
> The rest LGTM,

Does this imply I should attach your Reviewed-by or Acked-by on follow
up submissions if any? I'm happy either way, just checking.

> and my feedback here ranges from nit to corner-cases, so
> we are probably better off with a follow-up than with a repost, other
> opinions welcome!
>

Agreed a follow-up is better, but up to you and other maintainers.
There is some mounting urgency on my side (we're in the process of
optimistical backports and migrating the devmem TCP userspace that we
previously open sourced to the upstream UAPI), but we'll oblige either
way.

--=20
Thanks,
Mina

