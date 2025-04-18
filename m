Return-Path: <io-uring+bounces-7544-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E744AA9391C
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 17:07:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 617457AD6A7
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 15:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93DA1202C36;
	Fri, 18 Apr 2025 15:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="fzagOU5j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1184E1FAC29
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 15:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744988847; cv=none; b=lF9B1PsbR9Wqf67hiMSCZLHH8+Gkil4bEMW1lI5je9NlsiTj6jYYdGHnfXyGJlwNs7rKvGnmo01YC+CFKz24VSAQQkeW9hXha+5QEfPrZvQe72WI4HZ0ifxT4qO6TRXAIsiFAujPU/s4uQ+G781I7mkbcI6x6B3AUUbmhduHiUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744988847; c=relaxed/simple;
	bh=6kAQNZAfz+iYhnACljfCfh2JQaVthf3j1Xv6f2Cr66o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iurmz9+T1JPUYuoeCOw9D3qGBoYKb1EoSAyw3kPeaK6Rq+PD1NoekKR5nHrtBBtM4rE5FhZyTCMxbZ1ti3MkZqKlW2IYnkXVsYDDzeJ417BAE+IGsTBbL+2ZMK/p8hST5wM3Td0MvYqjCNsmLkYhfUGvrodsZ7Ou2PLhK8tGBYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=fzagOU5j; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-736aaeed234so1714903b3a.0
        for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 08:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1744988845; x=1745593645; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bMIJt+EyKfC3/LUEkBckhQrIwUPO9KqLXOx9Va9nBH4=;
        b=fzagOU5j3q+N6Ie7xGjIdmxxOIrCUfkjhwp7EFU9w7nLXsM3aC8l8/j+MMf1xvxNXv
         wibZ/gCmSfJ+4h9T4CSq992gH9umhzf5e2vAsg+9zUfgfsj7yF1OIshwNqe0EnMkOnOk
         J9+PxKEQI3ufh7jdltJYih4m3KAl5sYBVP11RpVm9QAR2SDWnRS0pSGOUTx2RWvU4fAn
         ot8W1x8P+7cq1MpINZmxni00C95vcnT3wW6yOgxMLwBr8Y+KsRmxoeg60SHSQkvmFtGn
         CnFSoFwWSIw30UGAKRTdnv68aCaRF/Ib8iYgx45yURvKltEOEDn3WjLcMRpr5uYSrdCO
         43sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744988845; x=1745593645;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bMIJt+EyKfC3/LUEkBckhQrIwUPO9KqLXOx9Va9nBH4=;
        b=nl0JhPwJLj4XO4NoOcAGpgO9v6TsUW1HdetPtit7dHROFAYVbMgHPEf5/SNg2NV66+
         Vt00e9j5Ez8LFpS/kDDWXT2s9G/nxwYD0gQGWZQfnFd4hZe4Oly0fO5gq1zeR05drm/A
         qJe8ptQHuF25YsPkPOSRSshwOdBSKOZoVjgPdSfNpg0qayvfbzY09ecekHv6JKM3Tt+x
         0gDWlL2l+eblC/6SvcH9GJRJ2LUidd/8GQYa4HqptbYGGJUrscHmRE8IZ5ebXQBEyei9
         KQ7oQd4FxOlKYGD3F9DufkET4AD3/0JMonuuiZckI89Y2/UBkVqFJSx06sRxOk0RL4D3
         nEGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSs3uS2tefblegMdpa0DQxqIa0XbN+y3RpTmh0MeO6TBlk7GqC3X+FF7AkQ5ugRQqgR8s/lpFtdA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/uW4RZoXuX8s+dyXxCThPeI5axFv/d39NHX6MIfJtAl6NKWVX
	sjnYbHJs5fI6Z88EN+fJ6Y3mRwYYhlbT2sS8Lbb8RJLr2R8O6wj8gPP6u5hizvJ9weGxKPgUDz9
	9
X-Gm-Gg: ASbGncueWOqyqDXMzZNa+U73nUcg1Oc3iY3HQ7V6akBTcxtCPKY9RgiKDLTliKD5OI0
	Iup/gjF1HgFXZt00JCkS8Ps0bIDDopNBm15Us39m8elnHu5c69Ft8SjZPZy7kp5m7aQX8W4wG1K
	gqwttQcfLDAKds1sgji441cR3KN28WULSym+AcYcMeJ6MqYXgaq8WYfDvmIqmxvBSU90yZRIxXm
	KlSprlVBkZQdFcBabjTyq4hKLrT8t54WSIXAA6uwQ2EVyFF1SFrhz1p5o5krJF+8ZHgCNfzmLMC
	stPEmcPCeJFZS3lKHXFFMQuOh7g7zbj9ZFA+wBbr+hSuyo+tyvEzRjza9249/UQ5rHJ2+3IPNnv
	BOB0=
X-Google-Smtp-Source: AGHT+IFzEryB7Ub+iWgYFmfzJoIdmCKAst3Ak9MuQLhOr9XLgdLveK/SM/tur5knJWzdHqL8b8yx4A==
X-Received: by 2002:a05:6a00:3d02:b0:736:4e0a:7e82 with SMTP id d2e1a72fcca58-73dc1480119mr3719035b3a.10.1744988845191;
        Fri, 18 Apr 2025 08:07:25 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:1cf1:8569:9916:d71f? ([2620:10d:c090:500::6:5122])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbfa57508sm1756303b3a.104.2025.04.18.08.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 08:07:24 -0700 (PDT)
Message-ID: <ea4d80b2-ade4-4d98-95c2-0c3f22f0d246@davidwei.uk>
Date: Fri, 18 Apr 2025 08:07:23 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] io_uring/zcrx: move io_zcrx_iov_page
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1744815316.git.asml.silence@gmail.com>
 <af1f2e0947fcbee59c4f9e3707133d503d5589f0.1744815316.git.asml.silence@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <af1f2e0947fcbee59c4f9e3707133d503d5589f0.1744815316.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-04-16 08:21, Pavel Begunkov wrote:
> We'll need io_zcrx_iov_page at the top to keep offset calculations
> closer together, move it there.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/zcrx.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 659438f4cfcf..0b56d5f84959 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -31,6 +31,20 @@ static inline struct io_zcrx_ifq *io_pp_to_ifq(struct page_pool *pp)
>  	return pp->mp_priv;
>  }
>  
> +static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
> +{
> +	struct net_iov_area *owner = net_iov_owner(niov);
> +
> +	return container_of(owner, struct io_zcrx_area, nia);
> +}
> +
> +static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
> +{
> +	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
> +
> +	return area->pages[net_iov_idx(niov)];
> +}
> +
>  #define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
>  
>  static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
> @@ -111,13 +125,6 @@ struct io_zcrx_args {
>  
>  static const struct memory_provider_ops io_uring_pp_zc_ops;
>  
> -static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
> -{
> -	struct net_iov_area *owner = net_iov_owner(niov);
> -
> -	return container_of(owner, struct io_zcrx_area, nia);
> -}
> -
>  static inline atomic_t *io_get_user_counter(struct net_iov *niov)
>  {
>  	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
> @@ -140,13 +147,6 @@ static void io_zcrx_get_niov_uref(struct net_iov *niov)
>  	atomic_inc(io_get_user_counter(niov));
>  }
>  
> -static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
> -{
> -	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
> -
> -	return area->pages[net_iov_idx(niov)];
> -}
> -
>  static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
>  				 struct io_uring_zcrx_ifq_reg *reg,
>  				 struct io_uring_region_desc *rd)

Reviewed-by: David Wei <dw@davidwei.uk>

