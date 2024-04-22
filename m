Return-Path: <io-uring+bounces-1604-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 025D98AD2F6
	for <lists+io-uring@lfdr.de>; Mon, 22 Apr 2024 19:02:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD5C01F21C86
	for <lists+io-uring@lfdr.de>; Mon, 22 Apr 2024 17:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21215153BFB;
	Mon, 22 Apr 2024 16:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBosjj3j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE9F153825;
	Mon, 22 Apr 2024 16:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713805171; cv=none; b=GDnKWkZ6nOJPf2awMxFl3kve3tR6LmOWU5++cH6kN49/hM8yX32D4MSJUmZywcNX/odYMMldOyjHeJJJxv/gVdr8HElBMCNmYMYYzQXsqqGwQGeFCg9GauXAFP093GkX1HlWf3L+Pj2E6I2CDjWjtgkzOQJAwaGKNJMtSOUHQDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713805171; c=relaxed/simple;
	bh=HJMGmF3SYu4yTESElcXXrvUpfg3wITeaCnIFmbGW8Ww=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=lXgaTaWzICFd3Obtw2Yv6aQNah5ukfBV9mWXhObS5k28iVcoaJkRKpv//r0ca87rGar+0HPypumAvkau/XeK+AiMfcg5Y3EK5TX3g+4gIgNaQe0i8Pkq293Y+W5KOpaO2QJZxhM8qb1yxDGY98KI+aTSteMV3u0hDHieP8VuONE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBosjj3j; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-78f05b62602so308305885a.0;
        Mon, 22 Apr 2024 09:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713805168; x=1714409968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mrIzzRd5SEQLFvdzQYqOFzNQkQZWaPc3JGD8u2+BkdA=;
        b=UBosjj3jml2A949sKHX8CrpZKIVul6ZAC8ofXI6VyhAoO6sO6lyPhTHCHb+AbkZ20n
         10AWV9c2eFsAqzh5i0YoSkFZh71lQOYylkHZ3wF6drItb8a+uYvE181DjpY2MWEVaV11
         5py0TQxcTSeqMYUQfCD4dSU+saALCieciqhaj5l5HlV0H+s8qOXOzfNU31QuFUqlpk3j
         O9tttob6r9oFZewv/tHZ3sX5Yi4ViosV0DahpnsZR2d/x6z03577Lz8cuNXh2v5IjoHN
         D9xkFFOr6VPh7Kdn3Bsyicy040CMjZb8ZKN8MoxERTAfM530SDGXfQtAAm0/lEsVBhTX
         I5uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713805168; x=1714409968;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mrIzzRd5SEQLFvdzQYqOFzNQkQZWaPc3JGD8u2+BkdA=;
        b=cjc6nUxO9YmV/wCopboC5iFDimwGDyTq6j9XpDQ3+mM0IkAyVqNaS3flmwQMZBYp+d
         cfDgajPJXKfbLXKCKpaSRgfc+JbQZM1ih2jXaLGdRRofmpqWb0WhPXclNHGfC1FpIC7B
         OdAWJHqNzlVqM1Mu1MziHBwZXgImn5Ca61Ldt1qBgDyeyDhz1TMpsgpCwJGOrqi15nM9
         3UrLNRAXFbE0IQHH25l+G2rAW33mBERcBXk353HF6wfWJmrPCKKwJXjou2gFvu7Aking
         +Tj61k0NSX8iH0emi6gK+8BTytI8eYo3qxPC07x+2DBLgG7/ZXXcAADTB0i9ifP47pK+
         7PRw==
X-Forwarded-Encrypted: i=1; AJvYcCUoDiE+MjCbb75UaXSRi65P8ngBGbzurp74vPe4Vx41j2DR8Nt5neHbpI4qC/o1EawJc0kK2I05qeE0J/j3dW40aEeJ+8SA6RZU2VyoVtarNVUM4TqMj3LxP2UaTOKhtreImshjyiiqrnU4FW209mpZUBk5f0o=
X-Gm-Message-State: AOJu0Yz99Svs3ZRCFrd+cPHVZiz5KycLwzRCB4ej8o6JiHRkjG/hDcvA
	8+WbPrt2em14Q12viTGmLHz4EViVq4fPO3P8bkyEJecLZUw/NQqg
X-Google-Smtp-Source: AGHT+IHHhU+Nvb87eCaQ76wWE1qXHzhzlsCm3OuWWbw2sH1hLhYIGaE9ghQG7Vrg+ndmJ6yOx+FQnA==
X-Received: by 2002:ad4:524f:0:b0:69b:12a0:296f with SMTP id s15-20020ad4524f000000b0069b12a0296fmr10630701qvq.54.1713805168003;
        Mon, 22 Apr 2024 09:59:28 -0700 (PDT)
Received: from localhost (164.146.150.34.bc.googleusercontent.com. [34.150.146.164])
        by smtp.gmail.com with ESMTPSA id s16-20020a0cdc10000000b006a0426f2bdasm4405853qvk.57.2024.04.22.09.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 09:59:27 -0700 (PDT)
Date: Mon, 22 Apr 2024 12:59:27 -0400
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
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Jason Wang <jasowang@redhat.com>, 
 Wei Liu <wei.liu@kernel.org>, 
 Paul Durrant <paul@xen.org>, 
 xen-devel@lists.xenproject.org, 
 "Michael S . Tsirkin" <mst@redhat.com>, 
 virtualization@lists.linux.dev, 
 kvm@vger.kernel.org
Message-ID: <6626976f4e91a_75392949e@willemb.c.googlers.com.notmuch>
In-Reply-To: <a62015541de49c0e2a8a0377a1d5d0a5aeb07016.1713369317.git.asml.silence@gmail.com>
References: <cover.1713369317.git.asml.silence@gmail.com>
 <a62015541de49c0e2a8a0377a1d5d0a5aeb07016.1713369317.git.asml.silence@gmail.com>
Subject: Re: [PATCH io_uring-next/net-next v2 1/4] net: extend ubuf_info
 callback to ops structure
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
> We'll need to associate additional callbacks with ubuf_info, introduce
> a structure holding ubuf_info callbacks. Apart from a more smarter
> io_uring notification management introduced in next patches, it can be
> used to generalise msg_zerocopy_put_abort() and also store
> ->sg_from_iter, which is currently passed in struct msghdr.
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

