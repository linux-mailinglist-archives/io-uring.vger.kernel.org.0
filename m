Return-Path: <io-uring+bounces-8847-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6931DB1440D
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 23:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3BE93ADEE5
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 21:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2595A1F7580;
	Mon, 28 Jul 2025 21:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y04/f2HX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23711A23AC
	for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 21:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753739427; cv=none; b=jj1srT+P2LTkmL5kKtY2t5iTYIo3NKEdA24O3DW2xbwu4EOt8WEdTj5jqL+iijVL1JG4sCCeDPgOHGcvk7Td5/8kCp5oqAm/txVGbP1FynnGyt30ZPihzhfxKhHU1OmgQOYlYkt9Up1XPsgY8dOyWmjB1k4MgTVLQXpLQkmWWwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753739427; c=relaxed/simple;
	bh=za+fouNncsRFtwL3eqirO4Uvip0olpsZCva4ijfUiGM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mnvwH/H4DT9j2s3gj8GMTNNm4N5SogNDCSth7TomivU++y7XGkqcih6htzNEMgBHGKExXPfcnv1B7PPM7O4ZEIBwSqYv+ORzYs2eNQt+zw7iJ01h6xg7ALbA8ZzLC7w01Mge3kwU4MpS40rF2Rj9BitA4kToKdFMJgyf00Y4U8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y04/f2HX; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-23dd9ae5aacso24815ad.1
        for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 14:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753739425; x=1754344225; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kdp2ddqK80/pBKPJs62APptyPvd+Kj6ul7N6/XRncls=;
        b=Y04/f2HXCXASBncQW0iBmWUK64INmBsCxtJRvzkQabI404aPYFKWsP2E78WDR9c5ow
         XmCk4SOaGyb2KSZKymFuE5VK7oqJC+MnyveEd6eAP43ZVg5U6UUSseO2l8oNBl7m6HIa
         sj+CMRkqnI4xSxJvNulZMbX3Fs0ZdLEU3PAqZ4nxl8AV9ouY+88k+jZfA5msRJpqnXWa
         hgYPeh6UMzUYJ4gLV+phUEp4rcnF0mehjO0TQMDukxbVGZ2ehBrxSA9PAczEAZB4ly2Z
         G4e7skVeCC7wf8LeqKlzIpCczrFejVRXplMoEgNqkKcOndQDLdxdFG0C/QmpC9g2DMIW
         tOjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753739425; x=1754344225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kdp2ddqK80/pBKPJs62APptyPvd+Kj6ul7N6/XRncls=;
        b=YtgvX9nzzkQZ8zgRXDwnxUhBAqWIfmrzu1BIGMNZNgQN/YlEV2MMhiuaEVEn00R86V
         yqFNmqoe0pqdPKh2OEI3Y1c/i7szJZXQc2kew66cBnxYTI7byiU6t5F6CIvjBVVFst6E
         1j755cX+DHmN3BNDlmUIRGAdC9896NviJ//XW3KH5LXFzJ7jK+MIfS3yeXczQPDePzer
         yJPw/FqXt56AaIk9vLa0rW2Nn45CVQqI7r2XHECz1ZFPHgK8X5ThjTRt7sgOg3BYh/fC
         +QkRLeYI3u1i+Omccwp5m6q/Ec0CJpBBRpr7Pb5Huo+68fiweHXHuZ69FdWs+1uIzDqC
         wTGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbP16KVgWBapqo/+Ah8kFRRhXn9RooU//VHStuL2IddzVtonyTPzkafIaSSktdGi6vfeGo6lhcFA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwsgPLLS9IOw6rRwPf31MLSTt/wUTRMy5IpbQ3sp6JSc+shjAO+
	NN2bx9FOfKWL7quvEsXkXcFocoS8eM9vwRcXkuquyaZltUTrEycNFTesY0zT07nNKthZC4HqnAy
	MXK/1HyQAFey1kDIpbWgPiq2uK96OKGGXlDwTdyKf
X-Gm-Gg: ASbGncshBg0eZTwj9XgVL3QShyCkZBnh39dDWIt38Q29aF81/3hJjvOveOOUAgZTrnz
	wH2S9+adp9FN5hke0O+u6OxvA3ukvmN1o06roaxNlbZLTE+YKa35azUujdwpDXQxedvB10m4iPJ
	DC+PZH1SLIyTqXxTZbdjvvuSm9sTZgaisiRwAlPwrCWfgYlPHXAv0GpHB925PvVJqEnI965HsWQ
	mlEmV7IQZYQnsYeRhSkKhEWIAak+pTokLYV1Q==
X-Google-Smtp-Source: AGHT+IHk9ze23ZqnnsOrfKU+c2WBYOckJrdIC3cvTOhckFRi9TjshDyNt9hxfNSa80OsSwkI8FdrHRPnmpFYfdyqx44=
X-Received: by 2002:a17:902:c949:b0:240:4464:d48b with SMTP id
 d9443c01a7336-240679824d0mr1073915ad.16.1753739424526; Mon, 28 Jul 2025
 14:50:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1753694913.git.asml.silence@gmail.com> <261d0d566d3005a3f2a3657c40bf3b3f7a9fdc98.1753694913.git.asml.silence@gmail.com>
In-Reply-To: <261d0d566d3005a3f2a3657c40bf3b3f7a9fdc98.1753694913.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 28 Jul 2025 14:50:12 -0700
X-Gm-Features: Ac12FXwdZrCstap-bKplw1sJf9I1lQ3NOyHUm_mMRyRnNmLhtOfmdeGtwKEwrDw
Message-ID: <CAHS8izOx5p2hw7OxhKZNUUmC5uJaM0PKw_4UdELe8LQ1QkuLyw@mail.gmail.com>
Subject: Re: [RFC v1 05/22] net: add rx_buf_len to netdev config
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, io-uring@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 4:03=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
>
> Add rx_buf_len to configuration maintained by the core.
> Use "three-state" semantics where 0 means "driver default".
>

What are three states in the semantics here?

- 0 =3D driver default.
- non-zero means value set by userspace

What is the 3rd state here?

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/net/netdev_queues.h | 4 ++++
>  net/ethtool/common.c        | 1 +
>  net/ethtool/rings.c         | 2 ++
>  3 files changed, 7 insertions(+)
>
> diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
> index 81df0794d84c..eb3a5ac823e6 100644
> --- a/include/net/netdev_queues.h
> +++ b/include/net/netdev_queues.h
> @@ -24,6 +24,10 @@ struct netdev_config {
>          * If "unset" driver is free to decide, and may change its choice
>          * as other parameters change.
>          */
> +       /** @rx_buf_len: Size of buffers on the Rx ring
> +        *               (ETHTOOL_A_RINGS_RX_BUF_LEN).
> +        */
> +       u32     rx_buf_len;
>         /** @hds_config: HDS enabled (ETHTOOL_A_RINGS_TCP_DATA_SPLIT).
>          */
>         u8      hds_config;
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index a87298f659f5..8fdffc77e981 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -832,6 +832,7 @@ void ethtool_ringparam_get_cfg(struct net_device *dev=
,
>
>         /* Driver gives us current state, we want to return current confi=
g */
>         kparam->tcp_data_split =3D dev->cfg->hds_config;
> +       kparam->rx_buf_len =3D dev->cfg->rx_buf_len;

I'm confused that struct netdev_config is defined in netdev_queues.h,
and is documented to be a queue-related configuration, but doesn't
seem to be actually per queue? This line is grabbing the current
config for this queue from dev->cfg which looks like a shared value.

I don't think rx_buf_len should be a shared value between all the
queues. I strongly think it should a per-queue value. The
devmem/io_uring queues will probably want large rx_buf_len, but normal
queues will want 0 buf len, me thinks.

--=20
Thanks,
Mina

