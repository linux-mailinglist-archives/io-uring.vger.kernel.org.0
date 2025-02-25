Return-Path: <io-uring+bounces-6767-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DFBCA45095
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 23:57:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A513F189BAD3
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 22:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F31204F9B;
	Tue, 25 Feb 2025 22:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EdSNvqfR"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421042327AE
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 22:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740524217; cv=none; b=trEYGZaAeOo5E2U8eof/ZX0Y+jZZT70EfqAEkf843aDaCIEPL1A3IP6Nxw82+m0TzvmIud8Jj6JOzJawV0NmMAMIl+iKJQa/6mfSgfX8KmdM52o3Iz1eurDqBiDb1Ge3aDaO12P3pacjmuA+ezFX+nJlz7ci8un/x8CNkkdaOhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740524217; c=relaxed/simple;
	bh=GMPzrLo8gcPNCb+c1FxvtRjNMUFwtEy138bRJue0iJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UiU436hTr0xNXk8pwJfORsaMb1A/JcXNz1njCFBI702NUphHDVZb0B7s/MDwuW6m2oTNe3clcf3CYRRrNBedFews/Kl6JLgmgB9vF3yNOpBiNlJ1beMfuABq7W5GPeJFFwfZUmvnen8FIB4g4NdHS+9NoOe6pd26KPL/wvMmPGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EdSNvqfR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740524215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1MIExbY5lASb2t4DcFKWsWFPWydwcu/0GgTo18o9k4g=;
	b=EdSNvqfRTj0CTEIt8qMjufse4IGxO6Q3wlk3YmtDP2IvYLU9jfHl59GXVFi54k4HzL8UdX
	hHsE9EsR+pmnEGKfS5efSR4N5UOO6WBJ8yGvGz7bTHws0a+7bKhdjwkl+2E/y9xfEhsGGR
	X6JvZEgD4igpTU+UAOmmkZVm91dNFWY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-gxNZfSALOQ-X3pKRAckKrQ-1; Tue,
 25 Feb 2025 17:56:53 -0500
X-MC-Unique: gxNZfSALOQ-X3pKRAckKrQ-1
X-Mimecast-MFC-AGG-ID: gxNZfSALOQ-X3pKRAckKrQ_1740524212
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B5EE180034E;
	Tue, 25 Feb 2025 22:56:52 +0000 (UTC)
Received: from fedora (unknown [10.72.116.21])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6D5C300018D;
	Tue, 25 Feb 2025 22:56:46 +0000 (UTC)
Date: Wed, 26 Feb 2025 06:56:41 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com, csander@purestorage.com
Subject: Re: [PATCHv5 09/11] ublk: zc register/unregister bvec
Message-ID: <Z75KqctKnQCyyRiR@fedora>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-10-kbusch@meta.com>
 <Z72itckfQq5p6xC2@fedora>
 <Z73xUhaRezPMy_Dz@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z73xUhaRezPMy_Dz@kbusch-mbp>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Feb 25, 2025 at 09:35:30AM -0700, Keith Busch wrote:
> On Tue, Feb 25, 2025 at 07:00:05PM +0800, Ming Lei wrote:
> > On Mon, Feb 24, 2025 at 01:31:14PM -0800, Keith Busch wrote:
> > >  static inline bool ublk_dev_is_user_copy(const struct ublk_device *ub)
> > >  {
> > > -	return ub->dev_info.flags & UBLK_F_USER_COPY;
> > > +	return ub->dev_info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY);
> > >  }
> > 
> > I'd suggest to set UBLK_F_USER_COPY explicitly either from userspace or
> > kernel side.
> > 
> > One reason is that UBLK_F_UNPRIVILEGED_DEV mode can't work for both.
> 
> In my reference implementation using ublksrv, I had the userspace
> explicitly setting F_USER_COPY automatically if zero copy was requested.
> Is that what you mean? Or do you need the kernel side to set both flags
> if zero copy is requested too?

Then the driver side has to validate the setting, and fail ZERO_COPY if
F_USER_COPY isn't set.

> 
> I actually have a newer diff for ublksrv making use of the SQE links.
> I'll send that out with the next update since it looks like there will
> need to be at least one more version.
> 
> Relevant part from the cover letter,
> https://lore.kernel.org/io-uring/20250203154517.937623-1-kbusch@meta.com/

OK, I will try to cook a ublk selftest in kernel tree so that the
cross-subsystem change can be covered a bit easier.



Thanks,
Ming


