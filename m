Return-Path: <io-uring+bounces-7615-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D22A96DD1
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:04:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3D63167C8D
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 14:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACDAE283C8D;
	Tue, 22 Apr 2025 14:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="diHRM3SS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBC1281537
	for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 14:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745330622; cv=none; b=Vz9aJKcRnVuyXoi4ZZ+HUwh7lowAM4LN0qzXrjTeg2kWuYKhJbdeJWBlyIQjnBD+JuqwTkNkRBI8PXV63VAZF8zqTGsT8ZgXR3jDYLSjwqZAwbogzYazMnik/WbaXPl4IEquIl0t6lne03rz3HxtF0Ao+W+Q8W9X74YtDqgoAJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745330622; c=relaxed/simple;
	bh=DI5wbiqZFhNjcg4g07wsE2rRpyR+Bg6kHqEcrbHze4Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iY4cBDbujO+Nes4MsZboMvTUdbOvh9Zmds2NldWNaozShYXrDh1kkGlpfTFO1dn2JB80MoH9zOv22qbuTgIdrHhbben9l5qxMwRF6E6S6WqK7Z5EVebbN7yCNqcElgyvAm827sQ4pSB35X+VCIJJyGMyS1GKPqIQ7aDLD5ZoC2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=diHRM3SS; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2240aad70f2so182705ad.0
        for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 07:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745330620; x=1745935420; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wxtxQ2q5f2CesvMzHl2K/43Dvf+KKs8Sp+BtzyImVRI=;
        b=diHRM3SSYX1rhVTrFh85dMgmHNY8sO2ecyPwPFFxn5sQbKf8uyHGCTCokaasiZyg6F
         VKxRmeoGqd8z3gNfYfdYx9nRIt0sO2m4rZspMiU89vOTce8M36DF/iBjf+yUOw63OKP3
         hITordz6p0dyt9ILX6PjDqmdftBpNagsZ2+9Q43sianlor0YDckrxv6UHr73LrRP40nl
         0RhaPUqvIJhdfxVTKdVpFekbtxJ6p6mBz3v5CgPtgZJFLkFtAW0VeT+gmLV9s0iEgJ0l
         8gyzbdup2vQ5J4dKQketbtzn+Miv5FOylJYS/7yQo/70s3oaoMk8nilN940PIjwG8SKq
         /+mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745330620; x=1745935420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wxtxQ2q5f2CesvMzHl2K/43Dvf+KKs8Sp+BtzyImVRI=;
        b=K9nNm2yKZTY0YzeLr/cMvn5yAGjIjNRDfzgwlravpmpSAN5z3lgE0V87hv4YhOV28C
         uJERCQaFWYDwMBwtZloSccCP0AU4bVhqwGVod7YAZNAHl7yifRImgKB3vLQA+sqzpDGZ
         c+8l3vDU+PEP6Mhr/P0Z0oFUR0KTrJ/Ndu+CbLnqmCQFFxKx+qPylGzVl6lHg4bpEuvC
         oShZk9vzqI2hx/GYdD8373D2DltaOKsV2zA0Tqu7P2KP0JKSV4j0xOBGIolSbXal6vmT
         0n0/pyjZYk3TM0NxWEu6R1Aol1EoELXnEvtqG36YTrRQ5P34Sw1ZFbpLwcyBxcmExjiw
         QAPA==
X-Forwarded-Encrypted: i=1; AJvYcCWjPH/FnNsHFFfJsaRAB5gUmuaVPnOp4ljWHyN5X5vYrfk0AVIA9Jtbp/zGZ4eiJHVCdL44pA9i0g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzcFqIgp349W5ENeBmEdcPS1SIEFe8uxrQ1RKIcKR9iN/GzYy3I
	elhRGMLD5iYLNQh8gCPt9jTTtbTXpqx8qzlooR2PBtEAiihAirhFRMGnrlr0hpDRLX1H81pHF+R
	hpY1oyd7cXaxdJp7/RwgnqwxaFoCGpmzAQREl
X-Gm-Gg: ASbGncslZZ8zCDLY3zJB/y1FX/tVc88i7wqDjSsbmRjvmspaeoY6m1x/0x9340tAYtt
	4/a7lluBS2/sR8evg/14wLMW0a1LMr304o3DqT8JP0zwR1VzcZMzJilzSuIERPNC9VyUcFOOtR7
	XsJXyYOBR2UdQ7fbI3EO8sStpt5PL9sz5taw==
X-Google-Smtp-Source: AGHT+IG0i+651pdR53K0l/n7uIQCSuRiQEGLD3Fi7ND1TmWV2npssXiwnzzo30HBpgP42jyUy2IALw8wxWFt/Kz8RzE=
X-Received: by 2002:a17:902:ebc3:b0:22c:33b4:c2ed with SMTP id
 d9443c01a7336-22c52a93c28mr10089535ad.26.1745330619867; Tue, 22 Apr 2025
 07:03:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417231540.2780723-1-almasrymina@google.com>
 <20250417231540.2780723-2-almasrymina@google.com> <f7a96367-1bb0-4ed2-8fbf-af7558fccc20@gmail.com>
In-Reply-To: <f7a96367-1bb0-4ed2-8fbf-af7558fccc20@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 22 Apr 2025 07:03:26 -0700
X-Gm-Features: ATxdqUHgiM0jEZwKYWOLJlVXJ7i1N-PNg4kE-n9ns-g62S6RZ7kqQTTDhmeVqPw
Message-ID: <CAHS8izMFxDG5E07ZdqnDH_2D_g1fW8X0M7u3gGyV8efzxDNZbg@mail.gmail.com>
Subject: Re: [PATCH net-next v9 1/9] netmem: add niov->type attribute to
 distinguish different net_iov types
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	David Ahern <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>, 
	Victor Nogueira <victor@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 1:16=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 4/18/25 00:15, Mina Almasry wrote:
> > Later patches in the series adds TX net_iovs where there is no pp
> > associated, so we can't rely on niov->pp->mp_ops to tell what is the
> > type of the net_iov.
>
> That's fine, but that needs a NULL pp check in io_uring as well,
> specifically in io_zcrx_recv_frag().
>

I think you mean this update in the code:

if (!niov->pp || niov->pp->mp_ops !=3D &io_uring_pp_zc_ops ||
    io_pp_to_ifq(niov->pp) !=3D ifq)
return -EFAULT;

Yes, thanks, will do.

> You can also move it to struct net_iov_area and check niov->owner->type
> instead. It's a safer choice than aliasing with struct page, there is
> no cost as you're loading ->owner anyway (e.g. for
> net_iov_virtual_addr()), and it's better in terms of normalisation /
> not unnecessary duplicating it, assuming we'll never have niovs of
> different types bound to the same struct net_iov_area.
>

Putting it in niov->owner->type is an alternative approach. I don't
see a strong reason to go with one over the other. I'm thinking there
will be fast code paths that want to know the type of the frag or skb
and don't need the owner, so it will be good to save loading another
cacheline. We have more space in struct net_iov than we know what to
do with anyway.


--
Thanks,
Mina

