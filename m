Return-Path: <io-uring+bounces-3435-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F220991D8B
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 11:47:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89BD8B21A95
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 09:47:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8C216B75C;
	Sun,  6 Oct 2024 09:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DtuxEk3B"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE8214C588
	for <io-uring@vger.kernel.org>; Sun,  6 Oct 2024 09:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728208057; cv=none; b=RFpvO9Pw0jbQSyFGcCwq/JcuFOhK/psE6u2aX3q/v/2hx3MhgyiB0dLFvXocjUu5skRIeS2Rlyqcno1wYcUmDkllBZprp57QgW2JOJey1uWP03X2DGqc0aK3WiDkhi7LXeIMLUyPXL2mrS0lUDqpkInNLsFs+lGWWIAdCiboh5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728208057; c=relaxed/simple;
	bh=c2OxxeIYI72Zmzm5aHzF9XiPDspLeIrQWoS2Viiy+R4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sIqr2O11xy1IChwuSmrS0vj5/GHZpCC1STu/OhKUrJNbgVYErmS6O1EljdeOTSPhstkAgHh2wK/Yu/ANFI2Wb7MgvdHdIrG3Wama9q6TWuHeq50h5djnC2OZQ/LndtFgkD/Lefp4H6zFizipSQX5dRg3lPk1PQC8yb0hgkciWis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DtuxEk3B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728208053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jRvc6wp81Jc0dvNSIM1R4b2E7F+U8Hg12zoh665lgsI=;
	b=DtuxEk3BlLLet2h60ksMHtL0xR/Z1K6GnZXyVSqqHXcA6/efAM3liJzSwV+je6lf5rn/Rn
	g/koDn7hUu4eMi2UfEVPlzVw3UH8q/qqZsva9+6qDko8sVFG46TobeMsM2atXURGJxDrVq
	lqE6gki4stu7Zmj15rbN2Yja45XSbGE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-qai1sTzfNe-D17l_QbFHvg-1; Sun,
 06 Oct 2024 05:47:32 -0400
X-MC-Unique: qai1sTzfNe-D17l_QbFHvg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 326E5195608A;
	Sun,  6 Oct 2024 09:47:31 +0000 (UTC)
Received: from fedora (unknown [10.72.116.29])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 74D1719560A2;
	Sun,  6 Oct 2024 09:47:27 +0000 (UTC)
Date: Sun, 6 Oct 2024 17:47:21 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH V6 6/8] io_uring: support providing sqe group buffer
Message-ID: <ZwJcqS61eXM5pmor@fedora>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-7-ming.lei@redhat.com>
 <51c10faa-ac28-4c40-82c4-373dbcad6e79@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51c10faa-ac28-4c40-82c4-373dbcad6e79@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Oct 04, 2024 at 04:32:04PM +0100, Pavel Begunkov wrote:
> On 9/12/24 11:49, Ming Lei wrote:
> ...
...
> > @@ -473,6 +494,7 @@ enum {
> >   	REQ_F_BUFFERS_COMMIT_BIT,
> >   	REQ_F_SQE_GROUP_LEADER_BIT,
> >   	REQ_F_SQE_GROUP_DEP_BIT,
> > +	REQ_F_GROUP_KBUF_BIT,
> >   	/* not a real bit, just to check we're not overflowing the space */
> >   	__REQ_F_LAST_BIT,
> > @@ -557,6 +579,8 @@ enum {
> >   	REQ_F_SQE_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEADER_BIT),
> >   	/* sqe group with members depending on leader */
> >   	REQ_F_SQE_GROUP_DEP	= IO_REQ_FLAG(REQ_F_SQE_GROUP_DEP_BIT),
> > +	/* group lead provides kbuf for members, set for both lead and member */
> > +	REQ_F_GROUP_KBUF	= IO_REQ_FLAG(REQ_F_GROUP_KBUF_BIT),
> 
> We have a huge flag problem here. It's a 4th group flag, that gives
> me an idea that it's overabused. We're adding state machines based on
> them "set group, clear group, but if last set it again. And clear
> group lead if refs are of particular value". And it's not really
> clear what these two flags are here for or what they do.
> 
> From what I see you need here just one flag to mark requests
> that provide a buffer, ala REQ_F_PROVIDING_KBUF. On the import
> side:
> 
> if ((req->flags & GROUP) && (req->lead->flags & REQ_F_PROVIDING_KBUF))
> 	...
> 
> And when you kill the request:
> 
> if (req->flags & REQ_F_PROVIDING_KBUF)
> 	io_group_kbuf_drop();

REQ_F_PROVIDING_KBUF may be killed too, and the check helper can become:

bool io_use_group_provided_buf(req)
{
	return (req->flags & GROUP) && req->lead->grp_buf;
}


Thanks,
Ming


