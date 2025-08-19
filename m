Return-Path: <io-uring+bounces-9079-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 924C7B2CD24
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 21:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DA802A322F
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 19:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F974340D85;
	Tue, 19 Aug 2025 19:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lmMWyOV0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8FD33EB02
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 19:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755632642; cv=none; b=IUdOZ99AKx5LGmm3O/h8/x4jsk+XYPwjRcPEKtbzaXzejQCqZmNzlegCCLmLOMHmhJD0/Jg9o5qXeoEtS9Qt7CRHG2P+Bo4ECij6hcdtYNFC7VtDeUIhbW0q9OokSfd3VVA9IHIX2a7+iYkcnLTK2T0EAfKFxP+Gu2ldPbdIApo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755632642; c=relaxed/simple;
	bh=zat7NJlmUUgoU/fA5UVQBv+E1bcTWYWMLkGLrDLXRWs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Be2jICS2eiHbSJJgubN0pizZkQOeIzYCMUY6y1lzXuLR3JP6gRZYIvtOqi0HpSqVRU3xjt7RpDbc198HtNWrrso7Yuoss+Pa9nRmAb9X1SrUOFgZwf1nwJNRH0pQDf4whh1MGsjiBzbgZ9nDwcfwWER18M8XyJkLzkWeKnzAgQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lmMWyOV0; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b0bf04716aso94631cf.1
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 12:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755632639; x=1756237439; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sbRKg2jA2OAQ/GBAnIjxqbjjLFTiafS/NzVrNjbA9ac=;
        b=lmMWyOV0zjPpHYfAsJDNe/t/tNnkHKl0I7KceXdBHEuIyKvDNPdeynikZQ8+gueufX
         bBNWkVRHgUByt32ASbJanra0T0cqZT5YlAT5ZoK05HLXkTxqJ8QU0cOUnPbonB7x8OAw
         2rHncC2T1YxUK6QFt2llPEYesOW5cWig1XqeCzKgXWEjmN3GSgzlOidTCZcVStOoA+RM
         OtJGRJQ2yxxB71QGj6Bio9gBcw6tNuz36V/g0MvfH29EYC6e7VeZh8UN4wr7zHvtymI2
         uEj1VQ+t8atczvgZMSpGi4eJ01MV4JmJC+kcdzxCTOQjOAwvBsGWr+K63uKzjm/Mee7I
         rqoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755632639; x=1756237439;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sbRKg2jA2OAQ/GBAnIjxqbjjLFTiafS/NzVrNjbA9ac=;
        b=iNnRbf5Fhrip6pREhjFNKuLXkmt0BZomqeIa88pSfaOn2Js7XDoqTp9PWrP7js7JzY
         C8DA3JiwHuzg14ShF7ZtNOtL5cwDeJi2RuhS5KMEmjWIpBZt3ZIw0/VfbD5T58iOgX52
         F9fhrIbSjNEPDR+CT3uKbb4xRytX6gTSWQxmyPhDfhtcMxULtp/P5n2q1ALIdvWFnnHz
         OxZoWqK50LHONqHRQVNXjuT1YrcJAdrrZaAECleahu2V+iSSwC+mW1yMaYpqrr6dXi8i
         iheAayaVjbpELTVMLRmwpFmMMwetx6SyIuLdyAIXfQDExAh0eWRPnlLpn7wsUF50r3e7
         OGXw==
X-Forwarded-Encrypted: i=1; AJvYcCXjX7UTRzeTtqalgVGbVmQkOX7dd7mXATpqqONBxVAos4VkWGLs0lJPjosjqZKztaAI7DZwy3+/kA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQExEAgQIJqzt6+RUPK0zRhlm8DP8tgkXHdnUwVOVGoaAiEa7i
	WDAycbhz5W0+SGOm9bbrq2I+0qfWiufKB2cdBY4PMRxqYr7KzZPnbGdgj85lNKX5D8TB9j48XzK
	YAHYuwLjk/rNyaJHtCYZ8qQ0Nxs5dMkNDdwrdA2F3
X-Gm-Gg: ASbGnculO6PtnwL+uMvbIKI475hIJ0PenAKhfAIRzKA7ABOi0nzhr9Sim7YF5IVQESv
	6XbZt72MhpEBVCJ9a/stQq3ftOOghoZ2WYsKiwVJC0CQPa42sakF/ABZmAfkmzxB2LrB6qC/N8y
	FyQJMhnfxvMRMMq3ltCBQ2f0COQ9wJrLYKiB48P0UyFZZp2OPw+Iz1QcC7eTQi6bMW76w9XEjLa
	Ma9vpjzQWNsBxS4pJ2EAn/j3qfM9v4shMGdO16ppZl5/6OXzJFQdyjP7O2i2s7QaQ==
X-Google-Smtp-Source: AGHT+IFzbmgTMllsQwidG6Y92/6CAaMpD7aJeIN5NSqfB7vUGkLJw6cipWLEHY8Trox0LsgRl4K4iCsM6CobCLztYvE=
X-Received: by 2002:a05:622a:114:b0:4a9:e17a:6288 with SMTP id
 d75a77b69052e-4b291b3f5ebmr783351cf.13.1755632639143; Tue, 19 Aug 2025
 12:43:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <51c3dd0a3a8aab6175e2915d94f7f7aece8e74d3.1755499376.git.asml.silence@gmail.com>
In-Reply-To: <51c3dd0a3a8aab6175e2915d94f7f7aece8e74d3.1755499376.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 19 Aug 2025 12:43:43 -0700
X-Gm-Features: Ac12FXy7pxgC5oceITb1cGTDtOFx_puzv-LutwCFhZgB_W6rHbLPop9FaZfQ_sU
Message-ID: <CAHS8izOs_m9nzeqC5yXiW9c1etDug4NUoGowPzzPRbB4UFL_bQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 08/23] eth: bnxt: set page pool page order
 based on rx_page_size
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 6:56=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
>
> If user decides to increase the buffer size for agg ring
> we need to ask the page pool for higher order pages.
> There is no need to use larger pages for header frags,
> if user increase the size of agg ring buffers switch
> to separate header page automatically.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [pavel: calculate adjust max_len]
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethe=
rnet/broadcom/bnxt/bnxt.c
> index 5307b33ea1c7..d3d9b72ef313 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -3824,11 +3824,13 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *b=
p,
>         pp.pool_size =3D bp->rx_agg_ring_size / agg_size_fac;
>         if (BNXT_RX_PAGE_MODE(bp))
>                 pp.pool_size +=3D bp->rx_ring_size / rx_size_fac;
> +
> +       pp.order =3D get_order(bp->rx_page_size);
>         pp.nid =3D numa_node;
>         pp.netdev =3D bp->dev;
>         pp.dev =3D &bp->pdev->dev;
>         pp.dma_dir =3D bp->rx_dir;
> -       pp.max_len =3D PAGE_SIZE;
> +       pp.max_len =3D PAGE_SIZE << pp.order;

nit: I assume this could be `pp.max_len =3D bp->rx_ring_size;` if you
wanted, since bnxt is not actually using the full compound page in the
case that bp->rx_ring_size is not a power of 2. Though doesn't matter
much, either way:

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina

