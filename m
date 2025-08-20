Return-Path: <io-uring+bounces-9103-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6ECFB2DE86
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 16:01:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50160189D910
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 14:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662D62264A8;
	Wed, 20 Aug 2025 14:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hxp9UyiO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D54167DB7
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755698410; cv=none; b=I4Klg0n3O7vNf7nP5RipucHRrWSbf+BLBsNe0g0ZjdPxjq0CmqieChyw4vgzsoiuHdDMETX+bHQ99yTQ01wFCXJeT9tykV/1GMzcExT5Gr7JLaEznwfiIXNNCFzduY32VDQnlJn3QFrSPyToHm2WdZKuKLcjsDSszlFZjFVI5/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755698410; c=relaxed/simple;
	bh=WTD3/ArXFBvcXWRDIaLDjP6fA0+AfFc2iGlvvPf8jQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kZbFxoXxb017HBo0MdN4wN36lIGqdcVRccWNSSPQtDt/1Xxtwr0ecns14H9pl5GbPDwEYYrLSa/bpvKD3EdmpUon3hqycsosVdsAqQV2DE41F/sc8loRqF3hJfbF7WsJiSr5Aik7qAX6Ekp/I71iz53YUWlVXs4xlr6iiMDEzQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hxp9UyiO; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55cc715d0easo10568e87.0
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 07:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755698407; x=1756303207; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WTD3/ArXFBvcXWRDIaLDjP6fA0+AfFc2iGlvvPf8jQA=;
        b=hxp9UyiORUwzO3jg5zMSmwkvUk2XC+RuwZQZY6RH3kOfP74k9piTU2SDfy5SMonw54
         xi0Sg9lyFGWv8ZXHz0LTVgCEJBfT9QsovoCdxUuuKml15ApGEYqpjnnwW+teki3OPWEQ
         SaiqegaHkCMRDL3TgQHr6SNakXvPJ+iH5942/I6ADMhC60x62d7znnu8JCloA2vByYoF
         uT0oCy2j3uNjZPCZ0T/+nQE604Z9amPZ6GBpmx2Slz7fPVdv//48uRQaT0m0FS10AwIC
         54BwnofxXJzqc1fkjDi2hiZgGNCxdEjKfum9BqNWqwi+/G732MNHrUjDYCh0CVFzqzA7
         u4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755698407; x=1756303207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WTD3/ArXFBvcXWRDIaLDjP6fA0+AfFc2iGlvvPf8jQA=;
        b=Bqsi2nou6ouA1BivmI8+SdkvTgWLmGT0+B2+H1mXCSfcVc6mRBqRTgjz+ZiGe+VtZ7
         J07QNFL56ZW4WkNnX7YqT0m2OjfK+hyXYSu8du95+P8/5DmnmXpr9tlCJTw9WjhQNevA
         b0Ft0N9rOiUukLgXB7XpZkBfN+areM013M+ZGTfGmXj0kuOdM5eFsG/auqXr1cVbeL5c
         OlIB6l7Eu13Qnf0fCPKnoUnuvNEE7Hx+LJvRzs8aWQzYd19JLsWbFkGRaaOaBZjpUiD5
         XiXra7n0abIs9YVBJlvOSwnZoEUn4hQxop4Fzs85mrxWicFF/lrY13mT+YIceDIpjFYp
         6bJg==
X-Forwarded-Encrypted: i=1; AJvYcCXi36r6UC4XCehFLKcjiOfFdR7FG/mkHL9Hglb+6JmO8WOG2YsSWUz+4voNVSSPJFOHehkpmPiPkA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwvD5QFjEZY4grxXwXC/oqH1R9fujMtxjegBCA276NgPBjZziEs
	jQY/UuI9kJ5We5i1fa1Vomz9gdFVWPaYR59UjNliQ7n9a4rVX3uhSym61FGIBkpRy0js5H9U/Fc
	lub3i4nkJz18ncl0F2BvU7a0TPQx8cWCi0pY/86vj
X-Gm-Gg: ASbGncsCWyxmdJZyLiKZFLW3P2TwQh8JFTdY6DeDERFXR6y9RR7+I/ojq8RX79/eNpq
	dZW/A6U9DE1jWIPuN472fxluwRZgPWIkH7nIxI7HEglOCUK+KVyXoD9j2Rr380XE0fV8Db1MqFc
	Cx4aJ34BAN+eCaenyfRqBSqmJIeO53mL4FJBoQxp84voGyN7Br
X-Google-Smtp-Source: AGHT+IGlXQFrW/JI848HnlpaOFMG5uQo1vUXrwNovg/X/oPwBt3lyo06OZeyIWxfa7ULckeb9isVS2e26W/w+7wcCKk=
X-Received: by 2002:a05:6512:4388:b0:55c:df56:f936 with SMTP id
 2adb3069b0e04-55e06818947mr351070e87.6.1755698404574; Wed, 20 Aug 2025
 07:00:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <20250819193126.2a4af62b@kernel.org>
 <fb85866c-3890-41d2-9d5c-27549c4b7aa3@gmail.com>
In-Reply-To: <fb85866c-3890-41d2-9d5c-27549c4b7aa3@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 20 Aug 2025 06:59:51 -0700
X-Gm-Features: Ac12FXyn3WeKsZNiJ_eN0Aeg_Ps8KKgTYMmuYPbod81uJ5k4iGCaZzxEQKmNVk8
Message-ID: <CAHS8izP2odYCfEfB_JMdT26nUzniXRdp5MaZgqozYd7wV9Z-gg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 00/23][pull request] Queue configs and large
 buffer providers
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 6:38=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 8/20/25 03:31, Jakub Kicinski wrote:
> > On Mon, 18 Aug 2025 14:57:16 +0100 Pavel Begunkov wrote:
> >> Jakub Kicinski (20):
> >
> > I think we need to revisit how we operate.
> > When we started the ZC work w/ io-uring I suggested a permanent shared
> > branch. That's perhaps an overkill. What I did not expect is that you
> > will not even CC netdev@ on changes to io_uring/zcrx.*
> >
> > I don't mean to assert any sort of ownership of that code, but you're
> > not meeting basic collaboration standards for the kernel. This needs
> > to change first.
>
> You're throwing quite allegations. Basic collaboration standards don't
> include spamming people with unrelated changes via an already busy list.
> I cc'ed netdev on patches that meaningfully change how it interacts
> (incl indirectly) with netdev and/or might be of interest, which is
> beyond of the usual standard expected of a project using infrastructure
> provided by a subsystem. There are pieces that don't touch netdev, like
> how io_uring pins pages, accounts memory, sets up rings, etc. In the
> very same way generic io_uring patches are not normally posted to
> netdev, and netdev patches are not redirected to mm because there
> are kmalloc calls, even though, it's not even the standard used here.
>
> If you have some way you want to work, I'd appreciate a clear
> indication of that, because that message you mentioned was answered
> and I've never heard any objection, or anything else really.
>

We could use tags in the MAINTAINERS file similar to these:

F: include/linux/*fence.h
F: include/linux/dma-buf.h
F: include/linux/dma-resv.h
K: \bdma_(?:buf|fence|resv)\b

We could make sure anything touching io_uring/zcrx. and anything using
netmem_ref/net_iov goes to netdev. I think roughly adding something
like this to general networking entry?

F: io_uring/zcrx.*
K: \bnet(mem_ref|_iov)\b

I had suggested this before but never had time to suggest the actual
changes, and in the back of my mind was a bit weary of spamming the
maintainers, but it seems this is not as much a concern as the patches
not getting to netdev.

--=20
Thanks,
Mina

