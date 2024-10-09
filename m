Return-Path: <io-uring+bounces-3494-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 384C299719F
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:33:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D83321F291E1
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 16:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5955A38DE5;
	Wed,  9 Oct 2024 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mL3RECTy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC02B7BAEC;
	Wed,  9 Oct 2024 16:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491306; cv=none; b=X8jqHUU3dsc76QNQV0whuQ+kvJQ9PXQJv6ifewHyVSuf+QzBGc74koDWmhlK3pvMbGyzgx/eL7BjqPiVgxhEe+Sl6XDd3zLpczzH556LBSZPoWAzovLAE+25moeQJNX6W8m5s1h0lBnIBNVkivmo/3uqbd63g9R6q+uOThMoUPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491306; c=relaxed/simple;
	bh=od0tAH3/rCJbrl8G8rGMfLSYEfP2DV1tPP6XnEekH7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npqAGHXDeWxx3E0eerwjpKvBUbYwtE22WbN1JnaHIeANL1/99DHnlzxMD/JIzsRtOdEYrle+GD5+wui1I/fxbfiCislcJuFf54aMty5fhSQJql83CHNNgCbEjQNkM/w67cWxwHlZpdjKS7CMGV1u1aOtIUIQ4+xrVTBWYEHxJgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mL3RECTy; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7e9fdad5af8so2849646a12.3;
        Wed, 09 Oct 2024 09:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728491304; x=1729096104; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3SlEKMU6Yovy/NNNEw6pYL/e2D6bAzvVuRCK5L6mdaQ=;
        b=mL3RECTyMznHWbM2/nPYiLKIe6VMV1kvjUI8ufynQVeF0FnUIFoTd+d6f2och8192n
         +zLb2pMZfEHw6IsiiFBfKuYpI0SuKKJLW2C0La7mcfrhj/PATZe1fHZrG4g09jpO2vJS
         dYpjX72us1qClz+bLw+LPHy9/vrhlc1C3yx29aXdQn0pC3gP0Lx0HBuBjOf4GBy0aWeV
         w0hviMFB15HXS+O7fevCB7VMd2A0s+twuXWpp2b0wP22tUhyyY6iiLpBXDt4L0tbFhbp
         sTSyhJqRvwz73nSQY7CvXyEv8LAGr0d/1+b7gr0aR0FcUE/Vt2kUlXB2r2tW1qCjmFkP
         c8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728491304; x=1729096104;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3SlEKMU6Yovy/NNNEw6pYL/e2D6bAzvVuRCK5L6mdaQ=;
        b=qfG78ZOavTlqfT19TGUEuMq57c8sstw53opFvVgiCEjTXGsENB4Vh6YKDvPMMg3zso
         P8ZCEac7KvutqECzq6xPH8v4UbwDL/63rZzqkpm3KFv895El5r+xE27pKsKYzjRLoXYC
         ggTKH6bo0q8xiM1fzk5a6RBEHw6MSRWbvJF0/d8+PP9mwlHUwikhRjXZ+EDWLiLjCZ1z
         01DrAcBjhFHDeYy5cqbO61+Dc9y3tQ10JpyAbkgUoGjdwiRXbzGjT4aEF31BoE7Of5GJ
         1sfinl46bLh5HbW/GvvSxbhhoOBaZGYLWz1tBPHCb06Eg5ELIv+5muGjK/YzRs3aJ8ho
         BaMA==
X-Forwarded-Encrypted: i=1; AJvYcCUyQz1e+x9shXGmz6pUQMFkCYWUjvYYmicWG4O6os7ovDUO/PpSHQwSnvJ7yRrPFWc/gDwI7djcCQ==@vger.kernel.org, AJvYcCWVx8P/lzlBoVXkFVAM3WP5O6g21w4zmx9qVzGJPH4l+TncqqQ1QaGLpG+ECQiu2Uqqjnu7IGtc@vger.kernel.org
X-Gm-Message-State: AOJu0Yx61qEhm0h5JlmArrE6xC/Sr9W5SRim7/Oa/QQNB5al7KwwJn0d
	XSaEPzogvD9LXnGC3Ef+2i2aQgd9YjmxCAfE2gUIFErbKeaYmwQ=
X-Google-Smtp-Source: AGHT+IELN89y5xMl4I0rWop66l6mY6j/Zo75tfC26y0z/ZMbJ7Y0GLy57WcDdSU7ccxymCHbXiowUw==
X-Received: by 2002:a05:6a20:7b02:b0:1d8:a759:5251 with SMTP id adf61e73a8af0-1d8a7595303mr2590367637.21.1728491303946;
        Wed, 09 Oct 2024 09:28:23 -0700 (PDT)
Received: from localhost ([2601:646:9e00:f56e:123b:cea3:439a:b3e3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e2a55ff9f2sm1891006a91.15.2024.10.09.09.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 09:28:23 -0700 (PDT)
Date: Wed, 9 Oct 2024 09:28:22 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
	netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH v1 03/15] net: generalise net_iov chunk owners
Message-ID: <ZwavJuVI-6d9ZSuh@mini-arch>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-4-dw@davidwei.uk>
 <ZwVT8AnAq_uERzvB@mini-arch>
 <ade753dd-caab-4151-af30-39de9080f69b@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ade753dd-caab-4151-af30-39de9080f69b@gmail.com>

On 10/08, Pavel Begunkov wrote:
> On 10/8/24 16:46, Stanislav Fomichev wrote:
> > On 10/07, David Wei wrote:
> > > From: Pavel Begunkov <asml.silence@gmail.com>
> > > 
> > > Currently net_iov stores a pointer to struct dmabuf_genpool_chunk_owner,
> > > which serves as a useful abstraction to share data and provide a
> > > context. However, it's too devmem specific, and we want to reuse it for
> > > other memory providers, and for that we need to decouple net_iov from
> > > devmem. Make net_iov to point to a new base structure called
> > > net_iov_area, which dmabuf_genpool_chunk_owner extends.
> > > 
> > > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > > Signed-off-by: David Wei <dw@davidwei.uk>
> > > ---
> > >   include/net/netmem.h | 21 ++++++++++++++++++++-
> > >   net/core/devmem.c    | 25 +++++++++++++------------
> > >   net/core/devmem.h    | 25 +++++++++----------------
> > >   3 files changed, 42 insertions(+), 29 deletions(-)
> > > 
> > > diff --git a/include/net/netmem.h b/include/net/netmem.h
> > > index 8a6e20be4b9d..3795ded30d2c 100644
> > > --- a/include/net/netmem.h
> > > +++ b/include/net/netmem.h
> > > @@ -24,11 +24,20 @@ struct net_iov {
> > >   	unsigned long __unused_padding;
> > >   	unsigned long pp_magic;
> > >   	struct page_pool *pp;
> > > -	struct dmabuf_genpool_chunk_owner *owner;
> > > +	struct net_iov_area *owner;
> > 
> > Any reason not to use dmabuf_genpool_chunk_owner as is (or rename it
> > to net_iov_area to generalize) with the fields that you don't need
> > set to 0/NULL? container_of makes everything harder to follow :-(
> 
> It can be that, but then io_uring would have a (null) pointer to
> struct net_devmem_dmabuf_binding it knows nothing about and other
> fields devmem might add in the future. Also, it reduces the
> temptation for the common code to make assumptions about the origin
> of the area / pp memory provider. IOW, I think it's cleaner
> when separated like in this patch.

Ack, let's see whether other people find any issues with this approach.
For me, it makes the devmem parts harder to read, so my preference
is on dropping this patch and keeping owner=null on your side.

