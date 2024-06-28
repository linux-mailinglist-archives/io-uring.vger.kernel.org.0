Return-Path: <io-uring+bounces-2380-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 605D691C468
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 19:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4A561F22B9D
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 17:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CFE1CB31D;
	Fri, 28 Jun 2024 17:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mqKgZln1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A651C8FAC;
	Fri, 28 Jun 2024 17:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594374; cv=none; b=EsgTQtxjOtsSrIbNn+2UKAMFmAMqH1ELgfnUJCWtjIMsnKEGn202nlFp5b69GmqWYFd6Lcbrk0xP1z7b1t9l7dPn40x6ZCiT92wFL5F8dYM0oPzV3xRrnULz95Pq5emfNNDIbiBICRT+Njm+DtTcbjPmXnVlau789EUMNGG3zFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594374; c=relaxed/simple;
	bh=gXoJVXrNRt1XSWpMc1PQ4ligQNMz7PkriCf1kZ0RAOY=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=ss3pkw9mur8T1fDGrviCuXTPAb18dqzMqNKaphH5wJ7k5+8nzNvzRnHip8/ANqrecP3aG2r2fElAadxMsnKahKYxClIE53cdHU/l4nrHPII8GtBbim8PRNfTmM2gmI5tQkjnKiweN8e7ePDaCnR38421rcjc7O4pO0t4Gi5aFZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mqKgZln1; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4463b71d5b0so7200251cf.1;
        Fri, 28 Jun 2024 10:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719594372; x=1720199172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2eAP/3di2Yz9vLyRnezp3gLROdvAFX1rwp7gVglmA2Y=;
        b=mqKgZln1ZneVPEvzk18Bmg6DzIIsM++UhWQQz+8P2d6JPbxoCzjxxDrF12vhiG9XJY
         wLC0RwATyoOYdbzV/CVw2IR33qeIw55Y581UWcZ7LBqHYrCVRXBqFDKU7Ka5/llHHaGn
         JF6ZVDouyCOhceT4ZtuYndeEPxzJnqSDyykDVP0H4trSH6QRE4tAz9XeVzBxYu05dSKq
         IgA8XTv1DpdLU7BJPHo1Itw2AEba8/1z2HsHSsx3SyG+w9sndv6apHkFSxcQaS/fjs8O
         STHux+idvL7nlbj6sEtFQSxl/aarraymB1oOEs/rM6BNmzKXfNDhr7egovohdm4Hl6zJ
         I09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594372; x=1720199172;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2eAP/3di2Yz9vLyRnezp3gLROdvAFX1rwp7gVglmA2Y=;
        b=KI32uhmqnZ27XvEbVK8cvkVyEGPO5Ij5D1sW+7bi6db1Ymv/EuwccvcDJu5xOIRCsd
         IJQs3b+YjZiSv5G6s4TCkp7cCUPUMMq/6qpXat0wcKTGUvAay91S8Z+e3ny1QctHJS/m
         zbHcCRe6FAmrILX212pth4TnXlMTlGr63c9GQlyHvo8IpsxWz9ye5TmcHCItSU6xS0uU
         1THr4Tmm6xT4NzR5de2HPznKLX5NIUAHeXmCv5P3lTKa58R2V4wwDdQGxixXb0EoJwBy
         ZCzXygZD8v4iHmE4QN3ivOg5NTVg10FLnF0BQuER4XjsQGOAoxy5ZfG+SVCP/bSTmePp
         79Iw==
X-Forwarded-Encrypted: i=1; AJvYcCWVVDQmCRYhnrVN3GwerR+y1z2mMGt53aXmei0p5B+sJiyIhW/jn3dr9OpYf71ApPZkPVNwWnYDCP3dY+OU4EORDhHkFwJvio1wLlxtdae2+C4v9SKDDQFxVBX5TV9/a78=
X-Gm-Message-State: AOJu0YxyFxYWro2siF8hFsQnhEHnDjB1NfZy/l03A7oAkuxR+BWXwEZA
	XXCqYXBTYyvu3EeFbcLV7nzN94DAbuJUyQV69iy76d/46O0IjOvZ
X-Google-Smtp-Source: AGHT+IEY19D7pPO10t/O+dRdYMk7NqQAUcOrIComPVc74I1hBqAGqXByqbdKTPVY9AXDHQu605IQkw==
X-Received: by 2002:ac8:5d42:0:b0:445:41e:2e97 with SMTP id d75a77b69052e-4465561b0dbmr41468431cf.3.1719594372098;
        Fri, 28 Jun 2024 10:06:12 -0700 (PDT)
Received: from localhost (56.148.86.34.bc.googleusercontent.com. [34.86.148.56])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-446513dba45sm8730981cf.6.2024.06.28.10.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 10:06:11 -0700 (PDT)
Date: Fri, 28 Jun 2024 13:06:11 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 io-uring@vger.kernel.org, 
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, 
 asml.silence@gmail.com, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 David Ahern <dsahern@kernel.org>, 
 Eric Dumazet <edumazet@google.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Message-ID: <667eed8350f89_2185b294e2@willemb.c.googlers.com.notmuch>
In-Reply-To: <a916f99aa91bc9066411015835cadd5677a454fb.1719190216.git.asml.silence@gmail.com>
References: <cover.1719190216.git.asml.silence@gmail.com>
 <a916f99aa91bc9066411015835cadd5677a454fb.1719190216.git.asml.silence@gmail.com>
Subject: Re: [PATCH net-next 3/5] net: batch zerocopy_fill_skb_from_iter
 accounting
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Pavel Begunkov wrote:
> Instead of accounting every page range against the socket separately, do
> it in batch based on the change in skb->truesize. It's also moved into
> __zerocopy_sg_from_iter(), so that zerocopy_fill_skb_from_iter() is
> simpler and responsible for setting frags but not the accounting.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

> ---
>  net/core/datagram.c | 31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index 7f7d5da2e406..2b24d69b1e94 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -610,7 +610,7 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
>  }
>  EXPORT_SYMBOL(skb_copy_datagram_from_iter);
>  
> -static int zerocopy_fill_skb_from_iter(struct sock *sk, struct sk_buff *skb,
> +static int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
>  					struct iov_iter *from, size_t length)
>  {
>  	int frag = skb_shinfo(skb)->nr_frags;
> @@ -621,7 +621,6 @@ static int zerocopy_fill_skb_from_iter(struct sock *sk, struct sk_buff *skb,
>  		int refs, order, n = 0;
>  		size_t start;
>  		ssize_t copied;
> -		unsigned long truesize;
>  
>  		if (frag == MAX_SKB_FRAGS)
>  			return -EMSGSIZE;

Does the existing code then incorrectly not unwind sk_wmem_queued_add
and sk_mem_charge if returning with error from the second or later
loop..

> @@ -633,17 +632,9 @@ static int zerocopy_fill_skb_from_iter(struct sock *sk, struct sk_buff *skb,
>  
>  		length -= copied;
>  
> -		truesize = PAGE_ALIGN(copied + start);
>  		skb->data_len += copied;
>  		skb->len += copied;
> -		skb->truesize += truesize;
> -		if (sk && sk->sk_type == SOCK_STREAM) {
> -			sk_wmem_queued_add(sk, truesize);
> -			if (!skb_zcopy_pure(skb))
> -				sk_mem_charge(sk, truesize);
> -		} else {
> -			refcount_add(truesize, &skb->sk->sk_wmem_alloc);
> -		}
> +		skb->truesize += PAGE_ALIGN(copied + start);
>  
>  		head = compound_head(pages[n]);
>  		order = compound_order(head);
> @@ -691,10 +682,24 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
>  			    struct sk_buff *skb, struct iov_iter *from,
>  			    size_t length)
>  {
> +	unsigned long orig_size = skb->truesize;
> +	unsigned long truesize;
> +	int ret;
> +
>  	if (msg && msg->msg_ubuf && msg->sg_from_iter)
>  		return msg->sg_from_iter(sk, skb, from, length);
> -	else
> -		return zerocopy_fill_skb_from_iter(sk, skb, from, length);
> +
> +	ret = zerocopy_fill_skb_from_iter(skb, from, length);
> +	truesize = skb->truesize - orig_size;
> +
> +	if (sk && sk->sk_type == SOCK_STREAM) {
> +		sk_wmem_queued_add(sk, truesize);
> +		if (!skb_zcopy_pure(skb))
> +			sk_mem_charge(sk, truesize);
> +	} else {
> +		refcount_add(truesize, &skb->sk->sk_wmem_alloc);
> +	}
> +	return ret;
>  }
>  EXPORT_SYMBOL(__zerocopy_sg_from_iter);
>  
> -- 
> 2.44.0
> 



