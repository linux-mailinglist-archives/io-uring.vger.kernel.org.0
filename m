Return-Path: <io-uring+bounces-6320-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3FDEA2D421
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 06:45:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EDBC16B7C7
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 05:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 978661922E6;
	Sat,  8 Feb 2025 05:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fhr1A5Wi"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5100217BA6
	for <io-uring@vger.kernel.org>; Sat,  8 Feb 2025 05:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738993500; cv=none; b=TFncM2pWuIY4h6v9G3Vbr0lblWA/61QEpbQkOEoSESwLj3/1sp9WSmSlfK2zgguoXbi+fC3LX2bBMs6SAC3cIjkoe0h4cUmkNWmeQne8eSEszgE/8Rwy1h+rcupxIAcdr73yQOyJ/QXDhhFRxUaI5eGol6IMRwHOGaKC95u982A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738993500; c=relaxed/simple;
	bh=HCLsf4sQEPAkX2tGBlakyy3P71L12YFAA7O5FJuV0XY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VCv88rXTbdrBDJi29qg39djbkaIvclBBH5t88EsfpGf74cSR28LbXHmeG3vJN1mzS05JPEtBnSggVJZNFRLqEEa4272oiTHmhd78wKSfBZx4xi7yfSh0ekD1ut7jDaP8wKfEVNb9tSPpxGS81voDcavXVbwTQCL8voDGA4M63b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fhr1A5Wi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738993497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oUoj/JcO/VGeP5HTSaARU9Gk1pFsiswYLtO8vGKWA30=;
	b=fhr1A5Wi5FVJuDZ2R84DUDBTuAf5yXI+Ka++KwOYmO1YAHQmuul3pmw4wYkLPBvjYrBjcl
	mmkny8I5YPys4aLMu2XGojYXQlCXhn+a26LvaPcLkvDzKNGNfGD0UK5CUDWgqupAvf3ak7
	bO6m4nUWkSVJ9dFhjRg4ETagln4Aavs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-457-uPGeYrcTPAaHEqC4_b_JPQ-1; Sat,
 08 Feb 2025 00:44:54 -0500
X-MC-Unique: uPGeYrcTPAaHEqC4_b_JPQ-1
X-Mimecast-MFC-AGG-ID: uPGeYrcTPAaHEqC4_b_JPQ
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A540419560B1;
	Sat,  8 Feb 2025 05:44:52 +0000 (UTC)
Received: from fedora (unknown [10.72.116.41])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51AD419560AE;
	Sat,  8 Feb 2025 05:44:46 +0000 (UTC)
Date: Sat, 8 Feb 2025 13:44:41 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, axboe@kernel.dk,
	asml.silence@gmail.com, Bernd Schubert <bernd@bsbernd.com>
Subject: Re: [PATCH 0/6] ublk zero-copy support
Message-ID: <Z6bvSXKF9ESwJ61r@fedora>
References: <20250203154517.937623-1-kbusch@meta.com>
 <Z6WDVdYxxQT4Trj8@fedora>
 <Z6YTfi29FcSQ1cSe@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6YTfi29FcSQ1cSe@kbusch-mbp>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Feb 07, 2025 at 07:06:54AM -0700, Keith Busch wrote:
> On Fri, Feb 07, 2025 at 11:51:49AM +0800, Ming Lei wrote:
> > On Mon, Feb 03, 2025 at 07:45:11AM -0800, Keith Busch wrote:
> > > 
> > > The previous version from Ming can be viewed here:
> > > 
> > >   https://lore.kernel.org/linux-block/20241107110149.890530-1-ming.lei@redhat.com/
> > > 
> > > Based on the feedback from that thread, the desired io_uring interfaces
> > > needed to be simpler, and the kernel registered resources need to behave
> > > more similiar to user registered buffers.
> > > 
> > > This series introduces a new resource node type, KBUF, which, like the
> > > BUFFER resource, needs to be installed into an io_uring buf_node table
> > > in order for the user to access it in a fixed buffer command. The
> > > new io_uring kernel API provides a way for a user to register a struct
> > > request's bvec to a specific index, and a way to unregister it.
> > > 
> > > When the ublk server receives notification of a new command, it must
> > > first select an index and register the zero copy buffer. It may use that
> > > index for any number of fixed buffer commands, then it must unregister
> > > the index when it's done. This can all be done in a single io_uring_enter
> > > if desired, or it can be split into multiple enters if needed.
> > 
> > I suspect it may not be done in single io_uring_enter() because there
> > is strict dependency among the three OPs(register buffer, read/write,
> > unregister buffer).
> 
> The registration is synchronous. io_uring completes the SQE entirely
> before it even looks at the read command in the next SQE.

Can you explain a bit "synchronous" here?

In patch 4, two ublk uring_cmd(UBLK_U_IO_REGISTER_IO_BUF/UBLK_U_IO_UNREGISTER_IO_BUF)
are added, and their handlers are called from uring_cmd's ->issue().

> 
> The read or write is asynchronous, but it's prep takes a reference on
> the node before moving on to the next SQE..

The buffer is registered in ->issue() of UBLK_U_IO_REGISTER_IO_BUF,
and it isn't done yet when calling ->prep() of read_fixed/write_fixed,
in which buffer is looked up in ->prep().

> 
> The unregister is synchronous, and clears the index node, but the
> possibly inflight read or write has a reference on that node, so all
> good.

UBLK_U_IO_UNREGISTER_IO_BUF tells ublk that the buffer isn't used any
more, but it is being used by the async read/write.

It might work, but looks a bit fragile, such as:

One buggy application may panic kernel if the IO command is completed
before read/write is done.

> 
> > > +		ublk_get_sqe_three(q->ring_ptr, &reg, &read, &ureg);
> > > +
> > > +		io_uring_prep_buf_register(reg, 0, tag, q->q_id, tag);
> > > +
> > > +		io_uring_prep_read_fixed(read, 1 /*fds[1]*/,
> > > +			0,
> > > +			iod->nr_sectors << 9,
> > > +			iod->start_sector << 9,
> > > +			tag);
> > > +		io_uring_sqe_set_flags(read, IOSQE_FIXED_FILE);
> > > +		read->user_data = build_user_data(tag, ublk_op, 0, 1);
> > 
> > Does this interface support to read to partial buffer? Which is useful
> > for stacking device cases.
> 
> Are you wanting to read into this buffer without copying in parts? As in
> provide an offset and/or smaller length across multiple commands? If
> that's what you mean, then yes, you can do that here.

OK.

>  
> > Also does this interface support to consume the buffer from multiple
> > OPs concurrently? 
> 
> You can register as many kernel buffers from as many OPs as you have
> space for in your table, and you can use them all concurrently. Pretty
> much the same as user registered fixed buffers. The main difference from
> user buffers is how you register them.

Here it depends on if LINK between buffer register and read/write are
required. If it is required, multiple OPs consuming the buffer have to
be linked one by one, then they can't be issue concurrently.


Thanks,
Ming


