Return-Path: <io-uring+bounces-3479-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76E0C9969D8
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 14:21:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 379B8284C6E
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 12:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88EF9192D95;
	Wed,  9 Oct 2024 12:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CkrSM04C"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD141922E5
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 12:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728476498; cv=none; b=eNaUmtxuJZ6VzPTdo2dinOfuzU3SIZC8hKScmt3Bsel4xCHqKePMmb1GR7XNbqetSnkOsRUm4c4/FhYgOrc3qO1HvlNIBI4OLdjbNLZnn6iJW6N8Hc89kpgjXDk15UmyswNSV9oC/Sb1lbYdCxfo9d2vBgoqZ+c5gMtNHaVkF7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728476498; c=relaxed/simple;
	bh=+36MbbZ3YFMbKHYG875bhfXhtE13k65KKDf0Zbw28IE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyg8/LxJwp9u8QAnUNJ6uoO0gjhS6ID8yMVZKog9AnTtIj/ex0+wDl3LRcTmmQZ1hJ8SfjbN2IL3Pchdl6w3CPZofMks8RBX9q0XSPlWV8S6XUG40vsXTQL5jUKhmpkPCCYS4bfXrZUPOX4v+5nBPbHOtfrWgtOyhdvNXaWq3v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CkrSM04C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728476495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LwlktFhfTjGsCcLB9cq/eMjPjHHHI79bmJuIpdhdsjI=;
	b=CkrSM04Cuy5+JXbnn4K6wS61bIrfTaiNvD3o+YD+gsiBYvGe2WVRmONGOfC2q7gSbiqjnd
	qnlcZIKdrHkgKzdG4NwSElo3ciM77Rhhnos420SYkYaXoW15mX/VkJA5/p/dJgRPXXI1mZ
	hTe5zlfWZDieNQ+n2Qgy3xhioX4hwLY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-2-Uzm34lEUPRi0fvD2RpQq_Q-1; Wed,
 09 Oct 2024 08:21:32 -0400
X-MC-Unique: Uzm34lEUPRi0fvD2RpQq_Q-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB4611956069;
	Wed,  9 Oct 2024 12:21:30 +0000 (UTC)
Received: from fedora (unknown [10.72.116.151])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90B681956089;
	Wed,  9 Oct 2024 12:21:26 +0000 (UTC)
Date: Wed, 9 Oct 2024 20:21:20 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH V6 6/8] io_uring: support providing sqe group buffer
Message-ID: <ZwZ1QJ8RrSXysTwg@fedora>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-7-ming.lei@redhat.com>
 <51c10faa-ac28-4c40-82c4-373dbcad6e79@gmail.com>
 <ZwJcqS61eXM5pmor@fedora>
 <e3ae3aa0-3851-4d4e-9185-c04c84efaaaf@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3ae3aa0-3851-4d4e-9185-c04c84efaaaf@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Wed, Oct 09, 2024 at 12:57:48PM +0100, Pavel Begunkov wrote:
> On 10/6/24 10:47, Ming Lei wrote:
> > On Fri, Oct 04, 2024 at 04:32:04PM +0100, Pavel Begunkov wrote:
> > > On 9/12/24 11:49, Ming Lei wrote:
> > > ...
> > ...
> > > > @@ -473,6 +494,7 @@ enum {
> > > >    	REQ_F_BUFFERS_COMMIT_BIT,
> > > >    	REQ_F_SQE_GROUP_LEADER_BIT,
> > > >    	REQ_F_SQE_GROUP_DEP_BIT,
> > > > +	REQ_F_GROUP_KBUF_BIT,
> > > >    	/* not a real bit, just to check we're not overflowing the space */
> > > >    	__REQ_F_LAST_BIT,
> > > > @@ -557,6 +579,8 @@ enum {
> > > >    	REQ_F_SQE_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEADER_BIT),
> > > >    	/* sqe group with members depending on leader */
> > > >    	REQ_F_SQE_GROUP_DEP	= IO_REQ_FLAG(REQ_F_SQE_GROUP_DEP_BIT),
> > > > +	/* group lead provides kbuf for members, set for both lead and member */
> > > > +	REQ_F_GROUP_KBUF	= IO_REQ_FLAG(REQ_F_GROUP_KBUF_BIT),
> > > 
> > > We have a huge flag problem here. It's a 4th group flag, that gives
> > > me an idea that it's overabused. We're adding state machines based on
> > > them "set group, clear group, but if last set it again. And clear
> > > group lead if refs are of particular value". And it's not really
> > > clear what these two flags are here for or what they do.
> > > 
> > >  From what I see you need here just one flag to mark requests
> > > that provide a buffer, ala REQ_F_PROVIDING_KBUF. On the import
> > > side:
> > > 
> > > if ((req->flags & GROUP) && (req->lead->flags & REQ_F_PROVIDING_KBUF))
> > > 	...
> > > 
> > > And when you kill the request:
> > > 
> > > if (req->flags & REQ_F_PROVIDING_KBUF)
> > > 	io_group_kbuf_drop();
> > 
> > REQ_F_PROVIDING_KBUF may be killed too, and the check helper can become:
> > 
> > bool io_use_group_provided_buf(req)
> > {
> > 	return (req->flags & GROUP) && req->lead->grp_buf;
> > }
> 
> ->grp_kbuf is unionised, so for that to work you need to ensure that
> only a buffer providing cmd / request could be a leader of a group,
> which doesn't sound right.

Yes, both 'req->lead->flags & REQ_F_PROVIDING_KBUF' and 'req->lead->grp_buf'
may not work because the helper may be called in ->prep(), when req->lead
isn't setup yet.

Another idea is to reuse one of the three unused flags(LINK, HARDLINK and DRAIN) 
of members for marking GROUP_KBUF, then it is aligned with BUFFER_SELECT and
implementation can be cleaner, what do you think of this approach?

Thanks,
Ming


