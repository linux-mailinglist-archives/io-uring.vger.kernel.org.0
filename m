Return-Path: <io-uring+bounces-4173-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20B3F9B58CE
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 01:45:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52A3B1C22C9A
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 00:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB3B84C70;
	Wed, 30 Oct 2024 00:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WJ9O/j27"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C559A8F5B
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 00:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730249129; cv=none; b=qy3qpfTGrRu4YY0YntzscDOgiT9djdTjMc5IeeRgPZ+kA/8TW5GlPiSJgkt0MP1KVy8/SEw/cQCjKo/Gqybgcf9kwTXAojlocVwXkrYJ6XYyOA9shGnhdimjMswHg537RyV/3nEn5VFAnbWYpVSFbppkIujPS6yFxkGLdleCEVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730249129; c=relaxed/simple;
	bh=q0XgTlrNtBGGrXXeNoFe11wWPBxeRiPJvn/YRW2CroA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dyN1Hn+BCJ5/sOFvqRv1zZm673Q5IUExmAuHDxuTmEmjiT6HhUwkS+jX1GLzu0lWcpfVWXKueS1fGVz/6V0Z1grvCTHl1PUc/4qHLJ4oiEBj6/asNNXK1adLCExAhJNYRJvXXaosIVdEHH4fNYlFT4hka9bs4GJ9noPlDfy2i+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WJ9O/j27; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730249126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FUQbGHE89Tjuuzon/UFuhihO7l7z+hPsgybfAFogew8=;
	b=WJ9O/j27guwp+3yW9AiWEELAeZFwMHb1wwww+h04D0bUaRz84hoEc9VvfsHwLEirsVNEZq
	Tl4ri30TgjmjYAaQGWzFA3SjBrODQ1Ta3HHWzIdi6/AHkMzn8wFoenPTdXXj7LrFv10Vf7
	xLQIIAv/49I2Qc6KMZ2V8rhB9/62OP8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-581-01mQZ12jNkqoKHpDuTsjSQ-1; Tue,
 29 Oct 2024 20:45:20 -0400
X-MC-Unique: 01mQZ12jNkqoKHpDuTsjSQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E07A195608A;
	Wed, 30 Oct 2024 00:45:19 +0000 (UTC)
Received: from fedora (unknown [10.72.116.45])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EFFB1956088;
	Wed, 30 Oct 2024 00:45:14 +0000 (UTC)
Date: Wed, 30 Oct 2024 08:45:09 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>
Subject: Re: [PATCH V8 5/7] io_uring: support leased group buffer with
 REQ_F_GROUP_KBUF
Message-ID: <ZyGBlWUt02xJRQii@fedora>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <20241025122247.3709133-6-ming.lei@redhat.com>
 <4576f723-5694-40b5-a656-abd1c8d05d62@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4576f723-5694-40b5-a656-abd1c8d05d62@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Tue, Oct 29, 2024 at 04:47:59PM +0000, Pavel Begunkov wrote:
> On 10/25/24 13:22, Ming Lei wrote:
> ...
> > diff --git a/io_uring/rw.c b/io_uring/rw.c
> > index 4bc0d762627d..5a2025d48804 100644
> > --- a/io_uring/rw.c
> > +++ b/io_uring/rw.c
> > @@ -245,7 +245,8 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
> >   	if (io_rw_alloc_async(req))
> >   		return -ENOMEM;
> > -	if (!do_import || io_do_buffer_select(req))
> > +	if (!do_import || io_do_buffer_select(req) ||
> > +	    io_use_leased_grp_kbuf(req))
> >   		return 0;
> >   	rw = req->async_data;
> > @@ -489,6 +490,11 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
> >   		}
> >   		req_set_fail(req);
> >   		req->cqe.res = res;
> > +		if (io_use_leased_grp_kbuf(req)) {
> 
> That's what I'm talking about, we're pushing more and
> into the generic paths (or patching every single hot opcode
> there is). You said it's fine for ublk the way it was, i.e.
> without tracking, so let's then pretend it's a ublk specific
> feature, kill that addition and settle at that if that's the
> way to go.

As I mentioned before, it isn't ublk specific, zeroing is required
because the buffer is kernel buffer, that is all. Any other approach
needs this kind of handling too. The coming fuse zc need it.

And it can't be done in driver side, because driver has no idea how
to consume the kernel buffer.

Also it is only required in case of short read/recv, and it isn't
hot path, not mention it is just one check on request flag.


Thanks,
Ming


