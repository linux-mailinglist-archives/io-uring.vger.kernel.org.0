Return-Path: <io-uring+bounces-1341-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E50F7892874
	for <lists+io-uring@lfdr.de>; Sat, 30 Mar 2024 01:43:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 222DE1C2074B
	for <lists+io-uring@lfdr.de>; Sat, 30 Mar 2024 00:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418DA7E2;
	Sat, 30 Mar 2024 00:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J7O069kT"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54113197
	for <io-uring@vger.kernel.org>; Sat, 30 Mar 2024 00:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711759402; cv=none; b=V4OPGwKCs35iuweF9k7ygvow42kbnJ49I/fqgriH8VIWlM3EjDs9ktnxR9pxemoxBQCyFfQT1+pseelXLhWmi0b1aCttUwGcIND+Kl5mp3tl9ok9jA9DY7Atyhl+bkZsvEuel5G1Kb26JLRF2e18SSF8k/5L7yBgRvaLLBoWxC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711759402; c=relaxed/simple;
	bh=3NbXAO4Bb8KWw33TNLEhadLy7oYYmDFojtGGQb72iL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kfIW9fIieeU9lt50DJMYikbsdgqBFRYpqS1mFPKIz2FzwTzupJ1mHbjC6Ms2tiGZZU237rsL7M8zQLfd3FQWY9Lc1gR+O9r0ysPrPc/Jo0mnvmdm5DJx0Plsv0pkEgP2vaNx9p+Mk42+8D8XaOJI8q+oAcH5NO5gGINrd4rocbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J7O069kT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711759399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VqB2jD8/19RbI+263ejAlp8LZreF64HFha6hrAxivAc=;
	b=J7O069kTvALb34z4/c499svKodi3R4Du+Q5oDWZ4SFyNQDkPtAUA9Q7sE4qHHCDMCyv2eS
	k4ww8FKifkhYMZwPiGhVaFEWj9bSCAp25qN5MT0kj7w04hZgnRwqEkMtskDqvbSiJc4e4f
	+RCWTgyHsErihm8y7uqODnrkt2mYvMc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-vLAYKR5qNmi0lW3pXBLWRg-1; Fri,
 29 Mar 2024 20:43:17 -0400
X-MC-Unique: vLAYKR5qNmi0lW3pXBLWRg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBA191C05EA7;
	Sat, 30 Mar 2024 00:43:16 +0000 (UTC)
Received: from fedora (unknown [10.72.116.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDB2F10189;
	Sat, 30 Mar 2024 00:43:14 +0000 (UTC)
Date: Sat, 30 Mar 2024 08:43:06 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: return void from io_put_kbuf_comp()
Message-ID: <ZgdgGrSosHxqBaIf@fedora>
References: <20240329155054.1936666-1-ming.lei@redhat.com>
 <4387133d-1b5c-477c-bff3-f1b7956fbc4a@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4387133d-1b5c-477c-bff3-f1b7956fbc4a@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Fri, Mar 29, 2024 at 10:07:13AM -0600, Jens Axboe wrote:
> On 3/29/24 9:50 AM, Ming Lei wrote:
> > The two callers don't handle the return value of io_put_kbuf_comp(), so
> > change its return type into void.
> 
> We might want to consider changing the name of it too, it's a bit
> different in that it's just recyling/dropping this kbuf rather than
> posting a completion on behalf of it.
> 
> Maybe io_kbuf_drop() would be better. Would distuingish it from the
> normal use cases of "drop this kbuf and return the cflags representation
> of it, as I'm posting a completionw ith it".
> 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  io_uring/kbuf.h | 12 +++---------
> >  1 file changed, 3 insertions(+), 9 deletions(-)
> > 
> > diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
> > index 1c7b654ee726..86931fa655ad 100644
> > --- a/io_uring/kbuf.h
> > +++ b/io_uring/kbuf.h
> > @@ -119,18 +119,12 @@ static inline void __io_put_kbuf_list(struct io_kiocb *req,
> >  	}
> >  }
> >  
> > -static inline unsigned int io_put_kbuf_comp(struct io_kiocb *req)
> > +static inline void io_put_kbuf_comp(struct io_kiocb *req)
> >  {
> > -	unsigned int ret;
> > -
> >  	lockdep_assert_held(&req->ctx->completion_lock);
> >  
> > -	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
> > -		return 0;
> > -
> > -	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
> > -	__io_put_kbuf_list(req, &req->ctx->io_buffers_comp);
> > -	return ret;
> > +	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
> > +		__io_put_kbuf_list(req, &req->ctx->io_buffers_comp);
> >  }
> 
> If you post a v2 with the above suggestion, let's please just keep the
> flags checking how it is. It's consistent with what we do elsewhere.

OK, I can rename it as io_kbuf_drop() in v2 and keep the original check style.

Also the following patch removes one io_put_kbuf_comp(), I will post v2
when that patch gets feedback or merged.

https://lore.kernel.org/io-uring/20240329154712.1936153-1-ming.lei@redhat.com/


thanks,
Ming


