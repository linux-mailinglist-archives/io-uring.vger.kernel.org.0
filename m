Return-Path: <io-uring+bounces-4181-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D4789B59BD
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 03:05:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0892C1F2407E
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 02:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7ABD531;
	Wed, 30 Oct 2024 02:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WWdXzkVi"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3230910940
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 02:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730253913; cv=none; b=lud3kzqJVh/mHOYauww1Hi2wyFtWmkD1DSoqy8E/0P2Dh+vsZGLtlorWnfTlUTUUetssM3riPAUk7hxI3lOVeevDhXBMSNYs+e+z7fSGV7xrHRxG7IUjxNHSEMpSd917A1OdFmM9B2IEc4ewchwKww9P0ED0+moHbriA3vgo4n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730253913; c=relaxed/simple;
	bh=qOxo1ealBUpnYDuccw5HopU/YEp0sygcp2s1+X4YXWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P/BYV07eBe5P8l+fAUC/kc2Qvu/J+gMCNI9efAaAmJw019L/387y1Obmn3O6zNIsDZ3d0MRTFm+QfbkrGnQV0MITVZvr0B+QSXVu6u9a6rAaSSTyYu7hWECEM6/SD8R5pjZpzavVIZU+FWf/kNTJQfL8kexGYrjabOiqYU6Ob8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WWdXzkVi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730253909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=csyr4yRJRh1sAsUoP3396gbOTM4+V/kYFOHfrz5IzyU=;
	b=WWdXzkVixGwz7kVhn9SXB4/jnKEwXxSIWIC+ldnSymvynrLY5fK60ReuvIKjoVgxRcAMhd
	1MYQZZ6BcY4eMKNA5DSm6saVlkQPSrheJRe6RTGaysywHA35z5tbOIpWGZCO5vU1Y8epJx
	SDnxOOgj/zE/P5y0ZEOpf3j151a3RjQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-578-Xq5Z3oleOT-kx4HghSsGyQ-1; Tue,
 29 Oct 2024 22:05:07 -0400
X-MC-Unique: Xq5Z3oleOT-kx4HghSsGyQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B01A91955EA5;
	Wed, 30 Oct 2024 02:05:05 +0000 (UTC)
Received: from fedora (unknown [10.72.116.45])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA92919560A3;
	Wed, 30 Oct 2024 02:05:00 +0000 (UTC)
Date: Wed, 30 Oct 2024 10:04:53 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>
Subject: Re: [PATCH V8 5/7] io_uring: support leased group buffer with
 REQ_F_GROUP_KBUF
Message-ID: <ZyGURQ-LgIY9DOmh@fedora>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <20241025122247.3709133-6-ming.lei@redhat.com>
 <4576f723-5694-40b5-a656-abd1c8d05d62@gmail.com>
 <ZyGBlWUt02xJRQii@fedora>
 <bbf2612e-e029-460f-91cf-e1b00de3e656@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbf2612e-e029-460f-91cf-e1b00de3e656@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Oct 30, 2024 at 01:25:33AM +0000, Pavel Begunkov wrote:
> On 10/30/24 00:45, Ming Lei wrote:
> > On Tue, Oct 29, 2024 at 04:47:59PM +0000, Pavel Begunkov wrote:
> > > On 10/25/24 13:22, Ming Lei wrote:
> > > ...
> > > > diff --git a/io_uring/rw.c b/io_uring/rw.c
> > > > index 4bc0d762627d..5a2025d48804 100644
> > > > --- a/io_uring/rw.c
> > > > +++ b/io_uring/rw.c
> > > > @@ -245,7 +245,8 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
> > > >    	if (io_rw_alloc_async(req))
> > > >    		return -ENOMEM;
> > > > -	if (!do_import || io_do_buffer_select(req))
> > > > +	if (!do_import || io_do_buffer_select(req) ||
> > > > +	    io_use_leased_grp_kbuf(req))
> > > >    		return 0;
> > > >    	rw = req->async_data;
> > > > @@ -489,6 +490,11 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
> > > >    		}
> > > >    		req_set_fail(req);
> > > >    		req->cqe.res = res;
> > > > +		if (io_use_leased_grp_kbuf(req)) {
> > > 
> > > That's what I'm talking about, we're pushing more and
> > > into the generic paths (or patching every single hot opcode
> > > there is). You said it's fine for ublk the way it was, i.e.
> > > without tracking, so let's then pretend it's a ublk specific
> > > feature, kill that addition and settle at that if that's the
> > > way to go.
> > 
> > As I mentioned before, it isn't ublk specific, zeroing is required
> > because the buffer is kernel buffer, that is all. Any other approach
> > needs this kind of handling too. The coming fuse zc need it.
> > 
> > And it can't be done in driver side, because driver has no idea how
> > to consume the kernel buffer.
> > 
> > Also it is only required in case of short read/recv, and it isn't
> > hot path, not mention it is just one check on request flag.
> 
> I agree, it's not hot, it's a failure path, and the recv side
> is of medium hotness, but the main concern is that the feature
> is too actively leaking into other requests.
 
The point is that if you'd like to support kernel buffer. If yes, this
kind of change can't be avoided.


Thanks,
Ming


