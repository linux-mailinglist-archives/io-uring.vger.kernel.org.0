Return-Path: <io-uring+bounces-3530-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E3A6997710
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 22:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E6741C20C6A
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 20:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A187C1E32CC;
	Wed,  9 Oct 2024 20:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oJEUBz/5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18B61A3BDE
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 20:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728507410; cv=none; b=RKvVsaZfUPn9vIZwxBz68b4moTdAo6w84kH2WEEyx1zxmcwOVtpT4zFy0zIyWXg1QN/XN0yCSYd2r5x0ZYIiNNOMwQAvLL+wqVg1lXSUcOy2HkvJzF3vYct630Vv6nIlcuChBpXr8ketXP3naVMbo3vwGkufiOvIGsQvbaPjOY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728507410; c=relaxed/simple;
	bh=Dxarsn1U4GHc2gwi6pMoZFV3rL7A/nPYDOpDpzibF3g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VQCz3EeMBCB3MzcniYG2dUOj9Y+9ZnX7Z+43ComSgKG/RTGe5pl6W/AOfYi2dAo/Pgwdh7pG6d592RticuEq/lyw6t0rTPv4FQ8jVfkcSePFKbAKXR7CTxuLPNq9D8r2AxBIre/oAJagwxt4AMWFh2yID0OJSwTzUELMYksFwq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oJEUBz/5; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-45fb0ebb1d0so28491cf.1
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 13:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728507408; x=1729112208; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIWPVQ7a6qiEeFf03ned4m4WhXcJXhc8NgItOtvYSr8=;
        b=oJEUBz/5YpM4L5TY/E1jrCYM31R73OaHevnRfRFyILD0T7jOdBXQtOfDX8IVa7aqHF
         gP2JcWLBxCE+FX5aUW5gXq7NSGrzFQCXPgFx7pdg30mYZ+J1bwCW43B+sPP+YFV4acde
         AsV4hDIRxm4U5T4ZC+hEj0ktZIhvgUPUdRLtiCqBydx9soatrYOPcohYT9Ke9OrQMOuy
         SN26EkUWfUOGbEF+Vma5EfE/Zzpka605Ugv3hcAoJI1+m9cknyLcm4qez0M+/uO0nPID
         BSdXjc+ykg0V6U4KeSSZ72YG/qVF9LzBZfm8Bb46lS02XwPhEO9krEUw/vGTS0rt2zAx
         jgKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728507408; x=1729112208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UIWPVQ7a6qiEeFf03ned4m4WhXcJXhc8NgItOtvYSr8=;
        b=cHsWoPVIxdMeoFd31p4iOflSR34ubdp/8wTOkQcERH1hY2Ld8FBHx/nPlZCqC01wX/
         ld4b8cgILzrIBoY8TgJ8bjuFJuAIIzdxj6BkxGoTPMJtmBNBeU5lmUM5bt2vSjgU9J8+
         gFxBmdKByk8QTAjBeoRzR5Z4b2FfwIW1MmVroBfSOQCVlhcXA5QYJC/9R1HsuzTP3UdP
         dIvUYjarFxTgnyUpZhopUPztKLZTpv9HjBxF4qYzmNqaSyD2aSTHDOHjBOGErJVSWWlh
         QxbMN4xXdQ3t440tFq0MuOSuc5Ug2skvv3EL4M/hbZpzLCLmvFvK2ow6MTVf5IBWY5wp
         t8EQ==
X-Gm-Message-State: AOJu0Yx2JUOuNG8FratheG8pQ6k/iRUrvkU9haIXClFRa/2QvlIV1BNQ
	vYPrgxSXh3DyMfkodIKvu3a/WucvRq3CAmmcJGBCOpwcFZhEH/gDbYBc6/iC87pU2whuPnkEmhq
	WmAWILIIdbcdWJuG0hJzg/nl2I1VKKBTTD059
X-Google-Smtp-Source: AGHT+IEEFPF82MH9ZifDRxy+ToxZdjRH3bj3JRzDevvnPFKbY7+isgzmSeGm4vCLmfZM+WQ76FIVwM9KeUa2CF6Difw=
X-Received: by 2002:a05:622a:2991:b0:458:1d2b:35f6 with SMTP id
 d75a77b69052e-4604044223fmr866711cf.24.1728507407719; Wed, 09 Oct 2024
 13:56:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-6-dw@davidwei.uk>
In-Reply-To: <20241007221603.1703699-6-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 9 Oct 2024 13:56:33 -0700
Message-ID: <CAHS8izOqNBpoOTXPU9bJJAs9L2QRmEg_tva3sM2HgiyWd=ME0g@mail.gmail.com>
Subject: Re: [PATCH v1 05/15] net: prepare for non devmem TCP memory providers
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 7, 2024 at 3:16=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> There is a good bunch of places in generic paths assuming that the only
> page pool memory provider is devmem TCP. As we want to reuse the net_iov
> and provider infrastructure, we need to patch it up and explicitly check
> the provider type when we branch into devmem TCP code.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  net/core/devmem.c         |  4 ++--
>  net/core/page_pool_user.c | 15 +++++++++------
>  net/ipv4/tcp.c            |  6 ++++++
>  3 files changed, 17 insertions(+), 8 deletions(-)
>
> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index 83d13eb441b6..b0733cf42505 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
> @@ -314,10 +314,10 @@ void dev_dmabuf_uninstall(struct net_device *dev)
>         unsigned int i;
>
>         for (i =3D 0; i < dev->real_num_rx_queues; i++) {
> -               binding =3D dev->_rx[i].mp_params.mp_priv;
> -               if (!binding)
> +               if (dev->_rx[i].mp_params.mp_ops !=3D &dmabuf_devmem_ops)
>                         continue;
>

Sorry if I missed it (and please ignore me if I did), but
dmabuf_devmem_ops are maybe not defined yet?

I'm also wondering how to find all the annyoing places where we need
to check this. Looks like maybe a grep for net_devmem_dmabuf_binding
is the way to go? I need to check whether these are all the places we
need the check but so far looks fine.

--=20
Thanks,
Mina

