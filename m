Return-Path: <io-uring+bounces-3467-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F609953BD
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 17:47:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B76D288C2F
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 15:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDD884A35;
	Tue,  8 Oct 2024 15:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WGzOUmgT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D871DED76;
	Tue,  8 Oct 2024 15:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728402419; cv=none; b=OiG9KIdfZKxtjgtiB1wIY6YJ0N+6/2pXW8WBBZxcrfEzMzQXz0iFSSLHXfVish87cwhnUqNKq+3nqJY2zPj6BSHSzpJku+lQ+31GkswBeZkku0oN8txjKhr4lAZKrI8J1w5CqOHy3U0Ql+FFpMGop3Mc0+/c+fS935v9nk39Vwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728402419; c=relaxed/simple;
	bh=l4wNK6PiJkzxn8jIFwiyFhdr3ybYOiXl3DDP6fl3waY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pR6rAINtn7Ziz4gpb5tDadMk6OZM+yixZTyZtMnm/qsVBWgpRseqtYbUiI46fclNcQc9L0CZeRcsuei0wURBvOFn1HFC4fxwyYGb0/d+OmhQIPHEGdcfkAkM6LwNPH1rKmmDzIMLU/lrE/iRyo2hT4cpkKhSWmBzLXI5nAOVbrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WGzOUmgT; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7ea07610762so1688778a12.0;
        Tue, 08 Oct 2024 08:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728402417; x=1729007217; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VtU1ZZyIwTEZSxGB/HOKdVSAliGlG5JgwT+I+ACu19U=;
        b=WGzOUmgTyXooqXhIjlGeYHHI97VKq8GrMZW2n5MdAjHO9Lr4sMu1T4dWySsdxS9KHR
         IuOr3zHNp4lZC0yEmHJJSYIxqzrNCUsM8vQqoRzL6rVdvcouulBtdLuFw740tqAArD43
         rOkXEyHeyD+Zx+c/0p6bBk6z01APOeCYZiGWmsUL2FAWERXrs/aez2eWmS5aG1/3xnfg
         ws4shG02TgU1lQLhw9VEPMqgK7DCZ8RPZhZYjyImMfFsxDRQ2N69zmrOzx4CQ+lFZPC4
         Wui+D2gNEZMCVmOEsjSfENaIBQ9YhIl6aD3b1/Jya5VIYk1usv7pKOuQmlZUem9FYFvE
         x9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728402417; x=1729007217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VtU1ZZyIwTEZSxGB/HOKdVSAliGlG5JgwT+I+ACu19U=;
        b=ccjvJojuP/D7ebR+l1zCAfwTvTsy3cMtdVIZN7m7OC4rBOD+TqNwe5AaslDpbgwM8z
         YIqGfZIecz/Mo2hv15AEZ7e26Rez1m/O9dEWY8NIjFZv+YYlvprLdzbQ9wgGZa4vIM1n
         buW6CzUmvl6y8Y5fZFtmtiSwKRv/x18e7easVupbsIUKmxWsraJiZiKMq23zYPLlfqgh
         mo9erRBPWiPdF6kjoOVs0kWGRsmqWf74e+B4B5a8MwAj9zBOZVlamuouZpJ5XZXoFCK/
         /bs3h61D9PrkaOakjZIHB0mEZGugswKxAL4cBom4Cwva40O57h2EULBzhCPO4QZ4mZsG
         bQMg==
X-Forwarded-Encrypted: i=1; AJvYcCWygDk9++HA0DxPGjNBfYPkk/pknHj4AvIgoY5bTeqV+YFVPgbi/m04sb0aHtzkK8AdPrXoco8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyczn4Ijj2ymm65i1xTjhO9W1VbJxiHMp4d67uZ7eiQsk735o7w
	bFn5EmHsMZSdDiX7Zz+Rfou7RvoohuFtPnixEl8VdYLxX8i5vQ4=
X-Google-Smtp-Source: AGHT+IHIOzdwte8o1uQwxWtkKmuJUBZaXSBT+bPtENqbx96J6LgE5127/5E7sXXucQwacV+3HVndcw==
X-Received: by 2002:a05:6a21:39a:b0:1cf:440a:d756 with SMTP id adf61e73a8af0-1d6dfabadf4mr22784035637.40.1728402417094;
        Tue, 08 Oct 2024 08:46:57 -0700 (PDT)
Received: from localhost ([2601:646:9e00:f56e:123b:cea3:439a:b3e3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d651f6sm6269283b3a.164.2024.10.08.08.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 08:46:56 -0700 (PDT)
Date: Tue, 8 Oct 2024 08:46:56 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH v1 03/15] net: generalise net_iov chunk owners
Message-ID: <ZwVT8AnAq_uERzvB@mini-arch>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-4-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241007221603.1703699-4-dw@davidwei.uk>

On 10/07, David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> Currently net_iov stores a pointer to struct dmabuf_genpool_chunk_owner,
> which serves as a useful abstraction to share data and provide a
> context. However, it's too devmem specific, and we want to reuse it for
> other memory providers, and for that we need to decouple net_iov from
> devmem. Make net_iov to point to a new base structure called
> net_iov_area, which dmabuf_genpool_chunk_owner extends.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  include/net/netmem.h | 21 ++++++++++++++++++++-
>  net/core/devmem.c    | 25 +++++++++++++------------
>  net/core/devmem.h    | 25 +++++++++----------------
>  3 files changed, 42 insertions(+), 29 deletions(-)
> 
> diff --git a/include/net/netmem.h b/include/net/netmem.h
> index 8a6e20be4b9d..3795ded30d2c 100644
> --- a/include/net/netmem.h
> +++ b/include/net/netmem.h
> @@ -24,11 +24,20 @@ struct net_iov {
>  	unsigned long __unused_padding;
>  	unsigned long pp_magic;
>  	struct page_pool *pp;
> -	struct dmabuf_genpool_chunk_owner *owner;
> +	struct net_iov_area *owner;

Any reason not to use dmabuf_genpool_chunk_owner as is (or rename it
to net_iov_area to generalize) with the fields that you don't need
set to 0/NULL? container_of makes everything harder to follow :-(

