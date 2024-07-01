Return-Path: <io-uring+bounces-2405-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 81D6E91E76C
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 20:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 387E21F220DA
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 18:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDEE916EC0B;
	Mon,  1 Jul 2024 18:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DrF80tO+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4909616E898;
	Mon,  1 Jul 2024 18:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719858483; cv=none; b=LnfNtk3H+icgkzmJ0c5gaC2Xj3TEPERrCaQMlZjkwh8SGnTs0MdGSzAMa8bBh/8uTrb6U4ce+XqqRE0w+AevMy1XSDhX6LRhP7hcgD7kyfSG2K/rUEaEQ5kaHa4AKq4nmOUWoKSTuwF6U+9WHbUSfjtHtB4hdAWhR9rSJaFn9jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719858483; c=relaxed/simple;
	bh=wM4Slqs4VxfOf76vbRhq1KoayyAF+k6Lwllcv5RuEFM=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=io0GRVoxyXv6pyFgOPrWXHZGyljjLqjvAgCJ7Fb2FCZ9zqcIzW3eSOrR2N9QQ79dp298eX6ntMTW5NZG/ZvtDRQS67LJlNdIIYJOfu3ktGMVGUW7BvPKgkATD3B/GoMtdx9e8h225n+3uHCVJbVShTPp6OHrIpyPtB+B8buI+V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DrF80tO+; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-79c076c0e1aso201165485a.2;
        Mon, 01 Jul 2024 11:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719858481; x=1720463281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6oSp3l4wwYQ26AYzu7qjLI3czOigk340zazQ1P36CGo=;
        b=DrF80tO+rWoBAQ6n6YYysvj7Xh3iO4HyEH75pQahxckZdeuP8nKyEv/la/lC1jQZ3L
         Qe+TBRwIlevbZ2Rl4JFXRKvLW0NnxjVGXTk/guCKWGZn61EzBWGACgWzplvrmUyrYLrK
         oUsEzo/WMjKG2NYjUrQBXhfAUksWNMQG36ONQEv5RUos9SRJgF6XXPY++WGbpoH1Foak
         IThELt09TPLFzKZnSfO9lewuk3Biy//XwpVKtIb3kWjRia87tMDPZKRetW9j2ikzLZnJ
         7t6QoTZ9XdW+olUEVt5uczBuOFu6kN7onokM/fMwOUSpPCMhaIvW+sIX6gn2mG+vjlFS
         vMdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719858481; x=1720463281;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6oSp3l4wwYQ26AYzu7qjLI3czOigk340zazQ1P36CGo=;
        b=FpsJMetEgM+XK+qZkM70i795mlDx3+tjjYGYV7S5YnGHsDMw8iSjuCTUBG1txfDIan
         C1n6f2bk1oLiS29js9sZqCJSsDil0aUjxTyxSAA27c3MIaYn4t+OMb8iZhVqduUzIYS0
         mzwM2Dz9cAJsfpZvoPZXaOlTPmcZrexuOwHsI4b5zO5nwWkXKQ9ecB/ZbxPRxX2xB7DT
         rCO3mnvcF0BWS9MHCKvEVAzClPmMCUoIuIkWhiYZ284CjYi7UFgIS8Ybhd2nqvfE9M3I
         i/XAxXP1uDiLd7lZTsCg/WSKeYxTg6IVenGrd1KsCyXr/SrmOcDAFNHm4OKqx6KV1DaR
         UGLA==
X-Forwarded-Encrypted: i=1; AJvYcCXy/NPoyE5uqQRYC7eCu7fruGEocsjZvYGOY+MvzdrWzn8qzqH+abfRzZXio01M7haalTtgf4WLOhojlT9RvjKACE27Q7Ypl6nhVfM6zPUEEyrR9IQaGeLKMCZnZSboUY0=
X-Gm-Message-State: AOJu0YzwcfQ8hBvbIhYY1Rml/G9vRp68lccf3bKZMWvUAsfATpMB5ubU
	eudv6ZPT5woxgLPkC9xnEqFYwzTQ9xRX1U2oN8icklyU875mJH93
X-Google-Smtp-Source: AGHT+IH0XXpVfAMfbw7Nlxwcrwpa4nXmY/qrHWExNG0IApOFkD4wwXF/vFpWs2GbZv8b3SYg4AtzPQ==
X-Received: by 2002:a05:620a:e10:b0:79d:5c93:4bd with SMTP id af79cd13be357-79d7bac3fd2mr726497485a.74.1719858480714;
        Mon, 01 Jul 2024 11:28:00 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d6927a828sm372322685a.38.2024.07.01.11.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 11:28:00 -0700 (PDT)
Date: Mon, 01 Jul 2024 14:27:59 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 io-uring@vger.kernel.org, 
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 David Ahern <dsahern@kernel.org>, 
 Eric Dumazet <edumazet@google.com>
Message-ID: <6682f52fd5a96_4208e294c8@willemb.c.googlers.com.notmuch>
In-Reply-To: <330dbf5b-4022-4ceb-a658-a182c16f9f59@gmail.com>
References: <cover.1719190216.git.asml.silence@gmail.com>
 <a916f99aa91bc9066411015835cadd5677a454fb.1719190216.git.asml.silence@gmail.com>
 <667eed8350f89_2185b294e2@willemb.c.googlers.com.notmuch>
 <330dbf5b-4022-4ceb-a658-a182c16f9f59@gmail.com>
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
> On 6/28/24 18:06, Willem de Bruijn wrote:
> > Pavel Begunkov wrote:
> >> Instead of accounting every page range against the socket separately, do
> >> it in batch based on the change in skb->truesize. It's also moved into
> >> __zerocopy_sg_from_iter(), so that zerocopy_fill_skb_from_iter() is
> >> simpler and responsible for setting frags but not the accounting.
> >>
> >> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > 
> > Reviewed-by: Willem de Bruijn <willemb@google.com>
> 
> Thanks for reviews!
> 
> >> ---
> >>   net/core/datagram.c | 31 ++++++++++++++++++-------------
> >>   1 file changed, 18 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/net/core/datagram.c b/net/core/datagram.c
> >> index 7f7d5da2e406..2b24d69b1e94 100644
> >> --- a/net/core/datagram.c
> >> +++ b/net/core/datagram.c
> >> @@ -610,7 +610,7 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
> >>   }
> >>   EXPORT_SYMBOL(skb_copy_datagram_from_iter);
> >>   
> >> -static int zerocopy_fill_skb_from_iter(struct sock *sk, struct sk_buff *skb,
> >> +static int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
> >>   					struct iov_iter *from, size_t length)
> >>   {
> >>   	int frag = skb_shinfo(skb)->nr_frags;
> >> @@ -621,7 +621,6 @@ static int zerocopy_fill_skb_from_iter(struct sock *sk, struct sk_buff *skb,
> >>   		int refs, order, n = 0;
> >>   		size_t start;
> >>   		ssize_t copied;
> >> -		unsigned long truesize;
> >>   
> >>   		if (frag == MAX_SKB_FRAGS)
> >>   			return -EMSGSIZE;
> > 
> > Does the existing code then incorrectly not unwind sk_wmem_queued_add
> > and sk_mem_charge if returning with error from the second or later
> > loop..
> 
> As long as ->truesize matches what's accounted to the socket,
> kfree_skb() -> sock_wfree()/->destructor() should take care of it.
> With sk_mem_charge() I assume __zerocopy_sg_from_iter -> ___pskb_trim()
> should do it, need to look it up, but if not, it sounds like a temporary
> over estimation until the skb is put down. I don't see anything
> concerning. Is that the scenario you're worried about?

Oh indeed. Thanks. I don't see ___pskb_trim adjusting except for the
cases where it calls skb_condese, but neither does it adjust truesize.
So indeed a temporary over estimation until e.g., tcp_wmem_free_skb.
Sounds fine.

