Return-Path: <io-uring+bounces-5413-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B60999EB73A
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 17:56:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B32EB1881236
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 16:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38EEF230D01;
	Tue, 10 Dec 2024 16:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bCdpW0n9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E6D22FE1E
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 16:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733849759; cv=none; b=tL8qC/GHSr5lH/2RE/L2r73GA75KXsgd3mYoiwUKWA2PjmllDcoy7DJRrKZGPA8E0CtaxamOupN1U7Oz/2lebY42c5o0M8kfZJ/jgkKPzIPEhcwZP0nUbUsIDDJOotIs4UM3w4k75+LaSAY2G6OYFwrBieHVmmNRdpvkiSIQXHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733849759; c=relaxed/simple;
	bh=/LxO6WPdDUxZ8Hgbs/2Wun67rLijCC4KxC688SOw/d4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cDMeVvHnvAGergSkTflFA9nNuOQQTmavMIS5oNmR6ZkJF+IkZTU4xnNWuhZydaZQDbmupfsdUcJyArKAcT0LdBQVxAg/EbEf+JYk3cbnwNkyVTIQeHDgNQRQhVPWryR/yJ8G7eWiFV6xYZKqmGkl1prmmRCMOm1YZGPi9AvnZ4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bCdpW0n9; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4675936f333so180421cf.0
        for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 08:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733849756; x=1734454556; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W7tKKwXbpN1GVUNkR1kL9d2a06AChiLqalDl9Gjh9wY=;
        b=bCdpW0n9vVjAxr6pBDxPiP7Rujahlqk0UlGIR+0SOOJeD4/3Ppru/PrTXepERW5UjR
         qMBy4pqyc2C+9V/MAo4pt+ZlVPBv1HEZLWdkibpLImtP6U8LmD1qahjI9lJmsPEtdf3L
         7Qes0S9fKJdFatQp1VQW1CgDk3Px8VeXyEBoEwdv2bnFvfY1dfSAlM+NlhlHbKzd1+1p
         BDbLoLZY3JGtBx8QhLkCOasOVXkQKAK9aUPFXQEpf1iFQoeW0NqOYRk6vb9DPPUYgt8u
         MnimGIKCPCI+37uTq1muMRUXzSZbR6m1qub5tH+Z4C05Mtdref04XQ7bSWBou+hAvw7/
         ReSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733849756; x=1734454556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W7tKKwXbpN1GVUNkR1kL9d2a06AChiLqalDl9Gjh9wY=;
        b=jDJLA76bLDbYoqz9Y6Y0f1H3jXC0kOX2WRhUvGA81ZbotAsmUYcm/ULhASPrnDclOK
         2TfbPotulWOQuun4tnS2kB/SWVUAcW9SvXWkv0GqW0NEOvAgIUAE5SSTepxGut/7Ynxa
         h2ikFdBLNoCNwOh2eT+wq5CbQHowxlp5Jf52oYND9aqPGDhR7pWWwG8pgI3J3xn+5v3N
         JbVglcowInUL2WQtIILUwPKO2dwe2O8i+Cb/NXmq232uBBRrSIF6kapkvgiMWk9JCBWh
         SnkcxdFLpguHM0vBsXVzh8+xGIUarCIlefiJ6962/OFAx1o0Dgsr6z3P2V3pZlk+zK48
         t3LQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIeG5GYnUWOgweT6MZAFXDgMZWjHrL1MA7JP4oCukcpTZdNqahIKIstDG2Pk0ykrpSqoqEHx9dRA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7jkR2y3h8rCgaCXzwRCcIkDvVoUXlIMFk3Fut9yQFI2eEGI4+
	6qGKyVe/TmBF7245ORyvZ4gZvzCj+7oE7sdz+V4fMbucw732lXEtTeEHg37RaLZrhTTuTsYYRTv
	m4u2gDJNRwIRkXf0W7H9K7N/pZeSdPaVXOeQm
X-Gm-Gg: ASbGnctxeoEZAlQX0FmMZlMNQnqOySggI+WrrQVsUjkBEMXa7eHViBsHSNNnMWDJp1f
	ixg5nfGQCjLYgT6x/IkCQm8ZfMEhfiAInnOg=
X-Google-Smtp-Source: AGHT+IHlPKeiLD6rlP5LINUtZzJpapiZf38wS5NZhgH5AdGxy6cSCKvr6QshYKht0RWFh9n5cZ+ju+NxtKL7siLDKnQ=
X-Received: by 2002:a05:622a:1e08:b0:467:5fea:d4c4 with SMTP id
 d75a77b69052e-467776c91b4mr3272711cf.27.1733849756351; Tue, 10 Dec 2024
 08:55:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204172204.4180482-1-dw@davidwei.uk> <20241204172204.4180482-12-dw@davidwei.uk>
 <20241209200156.3aaa5e24@kernel.org>
In-Reply-To: <20241209200156.3aaa5e24@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 10 Dec 2024 08:55:44 -0800
Message-ID: <CAHS8izMSD5+cbidwRukv55wG2b1VsiCD176gvk6_CFy8_wiAsw@mail.gmail.com>
Subject: Re: [PATCH net-next v8 11/17] io_uring/zcrx: implement zerocopy
 receive pp memory provider
To: Jakub Kicinski <kuba@kernel.org>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 9, 2024 at 8:01=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Wed,  4 Dec 2024 09:21:50 -0800 David Wei wrote:
> > Then, either the buffer is dropped and returns back to the page pool
> > into the ->freelist via io_pp_zc_release_netmem, in which case the page
> > pool will match hold_cnt for us with ->pages_state_release_cnt. Or more
> > likely the buffer will go through the network/protocol stacks and end u=
p
> > in the corresponding socket's receive queue. From there the user can ge=
t
> > it via an new io_uring request implemented in following patches. As
> > mentioned above, before giving a buffer to the user we bump the refcoun=
t
> > by IO_ZC_RX_UREF.
> >
> > Once the user is done with the buffer processing, it must return it bac=
k
> > via the refill queue, from where our ->alloc_netmems implementation can
> > grab it, check references, put IO_ZC_RX_UREF, and recycle the buffer if
> > there are no more users left. As we place such buffers right back into
> > the page pools fast cache and they didn't go through the normal pp
> > release path, they are still considered "allocated" and no pp hold_cnt
> > is required. For the same reason we dma sync buffers for the device
> > in io_zc_add_pp_cache().
>
> Can you say more about the IO_ZC_RX_UREF bias? net_iov is not the page
> struct, we can add more fields. In fact we have 8B of padding in it
> that can be allocated without growing the struct. So why play with
> biases? You can add a 32b atomic counter for how many refs have been
> handed out to the user.

Great idea IMO. I would prefer niov->pp_frag_ref to remain reserved
for pp refs used by dereferencing paths shared with pages and devmem
like napi_pp_put_page. Using an empty field in net_iov would alleviate
that concern.

I think I suggested something similar on v7, although maybe I
suggested putting it in an io_uring specific struct that hangs off the
net_iov to keep anything memory type specific outside of net_iov, but
a new field in net_iov is fine IMO.

--=20
Thanks,
Mina

