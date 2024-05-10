Return-Path: <io-uring+bounces-1850-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1E68C1CCC
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 05:08:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6C88B2084A
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 03:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E96CA14882B;
	Fri, 10 May 2024 03:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Breyoc4h"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA18148837
	for <io-uring@vger.kernel.org>; Fri, 10 May 2024 03:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715310483; cv=none; b=NC1EBGPpi8aKY1wo4k0682ZjK7yDG+jzpJl6cyz+XA8707C/OmlsZmJxHOxRHlmUXieACeBnZMoJR7XGctL1+iSvNKdgrN8qxjYQlijnRy423aULb2ehhcUjmYMi8T8z9vmIN8bpGu3H9xO8TxeAEQKBkwwHX6nDEnclHz4VHw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715310483; c=relaxed/simple;
	bh=4865ua1/UwesQRyq3hAgRbP9S7UazmTprrOBjPdlktk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qpBnzt2h4nkbnabHjtE3kUV1Ic6lkHQU0fnD1lRY9zPKx9ZtmZKb0nTBS1U1naWOPvFCSrcsRP9Zx3xWELh9U7yOKvKOQkz/0ftJXhv+7PNBaQt0OZXldMWP1rUnOlpdt3VN98Y+lZbkFNqNq22xvZsSqZW9gv1ZSveYs8hUe9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Breyoc4h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715310479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CvaGrAjIX4s0umG7iEeNdopQquls1x3AHgPG8iYyYi0=;
	b=Breyoc4hL1dcyXF5wD6xEGPH3rl2Pj051p/4d+06dB8r4orbPDS8jOZakDnGvPK03BzV7e
	bz6EQCfO+eExr4LU3t7FiH3pwDbvtGv6cxmMhJS/+RdEwuxg6AT8xiTbrU5g8i20V+L6Di
	GKF5y4QqpPqimsvUyfrZlbUr4/Zpp1A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-TwJ8pHBRNvq2rmNSGGmJYQ-1; Thu, 09 May 2024 23:07:57 -0400
X-MC-Unique: TwJ8pHBRNvq2rmNSGGmJYQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89EFD185A780;
	Fri, 10 May 2024 03:07:57 +0000 (UTC)
Received: from fedora (unknown [10.72.116.53])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F6D7121661D;
	Fri, 10 May 2024 03:07:55 +0000 (UTC)
Date: Fri, 10 May 2024 11:07:51 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: support to inject result for NOP
Message-ID: <Zj2Ph2tzYb7jrNsZ@fedora>
References: <20240510011421.55139-1-ming.lei@redhat.com>
 <a9cdda78-99f5-4546-863f-8f17f278610f@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9cdda78-99f5-4546-863f-8f17f278610f@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Thu, May 09, 2024 at 08:19:40PM -0600, Jens Axboe wrote:
> On 5/9/24 7:14 PM, Ming Lei wrote:
> > Support to inject result for NOP so that we can inject failure from
> > userspace. It is very helpful for covering failure handling code in
> > io_uring core change.
> > 
> > With nop flags, it could be possible to add more test feature for NOP in
> > future, but the NOP behavior of direct completion has to be kept.
> > 
> > Cleared NOP SQE is required, look both liburing and Rust io-uring crate
> > clears SQE, and it shouldn't be one big deal for raw, especially it is
> > just NOP.
> 
> I think this implementation looks fine, but probably would be best if
> you first had a prep patch that adds nop_flags to io_uring_sqe, and
> checks it in io_nop_prep() and fails if it's non-zero. Then we can mark
> that for stable, rather than need to do the whole thing.
> 
> Then patch 2 adds the actual meat of this patch, and now adds the proper
> check in io_nop_prep() for whether any unknown flags are set.
> 
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index 922f29b07ccc..5db3a209b302 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -48,7 +48,10 @@ struct io_uring_sqe {
> >  			__u32	optname;
> >  		};
> >  	};
> > -	__u32	len;		/* buffer size or number of iovecs */
> > +	union {
> > +		__u32	len;		/* buffer size or number of iovecs */
> > +		__s32	result;		/* for NOP to inject result only */
> > +	};
> >  	union {
> 
> And I'd drop that, just use 'len' throughout.
> 
> Rest of the patch looks fine as-is.

OK, will do both two in V2.

Thanks,
Ming


