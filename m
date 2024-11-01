Return-Path: <io-uring+bounces-4290-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EB27D9B882D
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 02:05:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4BDF3B224D6
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 01:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FFA975809;
	Fri,  1 Nov 2024 01:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RLnScrU0"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3088920328
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 01:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730423095; cv=none; b=d7YOvPi3exvwmtNuOmCClJZrasK6qIXTKZJ4HJIH9qoOkDWBhtF7cIgAIZYwE8erMUBZ0q9cYE5+GxpK90VcUVpcrdM33GQHA4Qab3j539IVuiOfZ09ZT1GX4WmiWZkTVbCMbhnUNIzEc7A2rPprTo2nbV0WT0y5N+09PB7jBjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730423095; c=relaxed/simple;
	bh=KIwfnWgY5nC44Ns8o8IaUAacedRAE3vniwTAJcLOInw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tkw/WOzZ7otXS4apcYnd+KgJli8Z4qzKAOknZwbDzpzpG06C7zbE1+5eHMBcxLHIX2E5aEM2NEBzp7rqaWsQg9tcD/UCfBnFppO2ITwAq4TWd/qtatK00rLQOHxnNdnDoDH0ckXbxR2vbd8vUc7ITy7FEnig5fHdSeiI8F8y3qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RLnScrU0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730423087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dA/8Zid0UhQ0KPn5cvvbzv/Vh/itSj5gGvrGBM9gzKM=;
	b=RLnScrU0iOg0ND/fdKWlXaIN+tmP8OP9FfF0DTj+xDEhW/5yJMyQlvVqPiUN+NToHG+VBL
	VkZbl3WbcrbQv9mVEEKRfHZi58DmBnUdwDoUqd3N0WBSkzLgO9bJfJIZw7JcK1HCzkwoPv
	4DOqaRBysNZZ1P7+b4+oKCKlI3wqgvI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-111-8TIlRJlaO1usRbpPte6V5w-1; Thu,
 31 Oct 2024 21:04:43 -0400
X-MC-Unique: 8TIlRJlaO1usRbpPte6V5w-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD1E519560BD;
	Fri,  1 Nov 2024 01:04:41 +0000 (UTC)
Received: from fedora (unknown [10.72.116.63])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4B4B1956088;
	Fri,  1 Nov 2024 01:04:36 +0000 (UTC)
Date: Fri, 1 Nov 2024 09:04:31 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>
Subject: Re: [PATCH V8 5/7] io_uring: support leased group buffer with
 REQ_F_GROUP_KBUF
Message-ID: <ZyQpH8ttWAhS9C5G@fedora>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <20241025122247.3709133-6-ming.lei@redhat.com>
 <4576f723-5694-40b5-a656-abd1c8d05d62@gmail.com>
 <ZyGBlWUt02xJRQii@fedora>
 <bbf2612e-e029-460f-91cf-e1b00de3e656@gmail.com>
 <ZyGURQ-LgIY9DOmh@fedora>
 <40107636-651f-47ea-8086-58953351c462@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40107636-651f-47ea-8086-58953351c462@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Thu, Oct 31, 2024 at 01:16:07PM +0000, Pavel Begunkov wrote:
> On 10/30/24 02:04, Ming Lei wrote:
> > On Wed, Oct 30, 2024 at 01:25:33AM +0000, Pavel Begunkov wrote:
> > > On 10/30/24 00:45, Ming Lei wrote:
> > > > On Tue, Oct 29, 2024 at 04:47:59PM +0000, Pavel Begunkov wrote:
> > > > > On 10/25/24 13:22, Ming Lei wrote:
> > > > > ...
> > > > > > diff --git a/io_uring/rw.c b/io_uring/rw.c
> > > > > > index 4bc0d762627d..5a2025d48804 100644
> > > > > > --- a/io_uring/rw.c
> > > > > > +++ b/io_uring/rw.c
> > > > > > @@ -245,7 +245,8 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
> > > > > >     	if (io_rw_alloc_async(req))
> > > > > >     		return -ENOMEM;
> > > > > > -	if (!do_import || io_do_buffer_select(req))
> > > > > > +	if (!do_import || io_do_buffer_select(req) ||
> > > > > > +	    io_use_leased_grp_kbuf(req))
> > > > > >     		return 0;
> > > > > >     	rw = req->async_data;
> > > > > > @@ -489,6 +490,11 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
> > > > > >     		}
> > > > > >     		req_set_fail(req);
> > > > > >     		req->cqe.res = res;
> > > > > > +		if (io_use_leased_grp_kbuf(req)) {
> > > > > 
> > > > > That's what I'm talking about, we're pushing more and
> > > > > into the generic paths (or patching every single hot opcode
> > > > > there is). You said it's fine for ublk the way it was, i.e.
> > > > > without tracking, so let's then pretend it's a ublk specific
> > > > > feature, kill that addition and settle at that if that's the
> > > > > way to go.
> > > > 
> > > > As I mentioned before, it isn't ublk specific, zeroing is required
> > > > because the buffer is kernel buffer, that is all. Any other approach
> > > > needs this kind of handling too. The coming fuse zc need it.
> > > > 
> > > > And it can't be done in driver side, because driver has no idea how
> > > > to consume the kernel buffer.
> > > > 
> > > > Also it is only required in case of short read/recv, and it isn't
> > > > hot path, not mention it is just one check on request flag.
> > > 
> > > I agree, it's not hot, it's a failure path, and the recv side
> > > is of medium hotness, but the main concern is that the feature
> > > is too actively leaking into other requests.
> > The point is that if you'd like to support kernel buffer. If yes, this
> > kind of change can't be avoided.
> 
> There is no guarantee with the patchset that there will be any IO done
> with that buffer, e.g. place a nop into the group, and even then you

Yes, here it depends on user. In case of ublk, the application has to be
trusted, and the situation is same with other user-emulated storage, such
as qemu.

> have offsets and length, so it's not clear what the zeroying is supposed
> to achieve.

The buffer may bee one page cache page, if it isn't initialized
completely, kernel data may be leaked to userspace via mmap.

> Either the buffer comes fully "initialised", i.e. free of
> kernel private data, or we need to track what parts of the buffer were
> used.

That is why the only workable way is to zero the remainder in
consumer of OP, imo.


Thanks,
Ming


