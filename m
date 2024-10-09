Return-Path: <io-uring+bounces-3478-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B309969B9
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 14:15:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7198728418A
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 12:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A70919006F;
	Wed,  9 Oct 2024 12:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dHPwNwRJ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EA518A926
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 12:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728476099; cv=none; b=JWmK4dym7dASmrfiJyqr/Ocz7OeqNSfQWlzxIm2lU2uyX/JSnwhNM3J+xQdEpNox3g1fHe3UYuHiYZaAZ3GYD8ZjFNH3sBjQUG+jyjLs8paXrhM3NQAvITas0Fo9cwDAlp93fdbkkjQrGXxbJ8ars5AKw7p+D0czkA7jB4ubn9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728476099; c=relaxed/simple;
	bh=S7XV0g838A+wpsRaA1+7F4DGCNrRuUHJPoP7wqLdytI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8J0T0I2JImomvOMRdxTRpSatC690a7+HmwVNtJS0gN9l3MRWBKM/4kXJJvcmX9CXKId3PnXom8b1JD995y57oQmv7+rRcqaiYDY7Ay9JAU7aAZW0pvwzckxPpAIUz3rYxga4urscXm99RnGyXJxQj6lNzhYvqWspwetnlJ0Ph8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dHPwNwRJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728476096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y1cNJxjwKqdMBaeIDmPd/sWtHGKew0csxmc2Eusb3TA=;
	b=dHPwNwRJGcry+NfpfxFOplwgUu3NXRGvEaxDGJBCQ2pbW/mCasqPC8shEfWAYBQ6uDOsm7
	6eeXsFRpNiRzUJaV7SNbGIGfy9yziD0XsdWHB/I9YfEDnNUCUE1fY+r4CZ2vStj/AeAQxz
	kjRwlYHRtjROaPOzsXqV+KtfsVfkXrI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-498-jnSVe-t5PyO7c5JtcOUEjA-1; Wed,
 09 Oct 2024 08:14:53 -0400
X-MC-Unique: jnSVe-t5PyO7c5JtcOUEjA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7FB1A1956057;
	Wed,  9 Oct 2024 12:14:52 +0000 (UTC)
Received: from fedora (unknown [10.72.116.151])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D6F119560A2;
	Wed,  9 Oct 2024 12:14:46 +0000 (UTC)
Date: Wed, 9 Oct 2024 20:14:40 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH V6 4/8] io_uring: support SQE group
Message-ID: <ZwZzsPcXyazyeZnu@fedora>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-5-ming.lei@redhat.com>
 <239e42d2-791e-4ef5-a312-8b5959af7841@gmail.com>
 <ZwIJ4Hn52-tm22Z8@fedora>
 <f6d34a4d-bf46-4120-8e2d-9585912a8867@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6d34a4d-bf46-4120-8e2d-9585912a8867@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Oct 09, 2024 at 12:53:34PM +0100, Pavel Begunkov wrote:
> On 10/6/24 04:54, Ming Lei wrote:
> > On Fri, Oct 04, 2024 at 02:12:28PM +0100, Pavel Begunkov wrote:
> > > On 9/12/24 11:49, Ming Lei wrote:
> > > ...
> > > > --- a/io_uring/io_uring.c
> > > > +++ b/io_uring/io_uring.c
> > > > @@ -111,13 +111,15 @@
> > > ...
> > > > +static void io_complete_group_member(struct io_kiocb *req)
> > > > +{
> > > > +	struct io_kiocb *lead = get_group_leader(req);
> > > > +
> > > > +	if (WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP) ||
> > > > +			 lead->grp_refs <= 0))
> > > > +		return;
> > > > +
> > > > +	/* member CQE needs to be posted first */
> > > > +	if (!(req->flags & REQ_F_CQE_SKIP))
> > > > +		io_req_commit_cqe(req->ctx, req);
> > > > +
> > > > +	req->flags &= ~REQ_F_SQE_GROUP;
> > > 
> > > I can't say I like this implicit state machine too much,
> > > but let's add a comment why we need to clear it. i.e.
> > > it seems it wouldn't be needed if not for the
> > > mark_last_group_member() below that puts it back to tunnel
> > > the leader to io_free_batch_list().
> > 
> > Yeah, the main purpose is for reusing the flag for marking last
> > member, will add comment for this usage.
> > 
> > > 
> > > > +
> > > > +	/* Set leader as failed in case of any member failed */
> > > > +	if (unlikely((req->flags & REQ_F_FAIL)))
> > > > +		req_set_fail(lead);
> > > > +
> > > > +	if (!--lead->grp_refs) {
> > > > +		mark_last_group_member(req);
> > > > +		if (!(lead->flags & REQ_F_CQE_SKIP))
> > > > +			io_req_commit_cqe(lead->ctx, lead);
> > > > +	} else if (lead->grp_refs == 1 && (lead->flags & REQ_F_SQE_GROUP)) {
> > > > +		/*
> > > > +		 * The single uncompleted leader will degenerate to plain
> > > > +		 * request, so group leader can be always freed via the
> > > > +		 * last completed member.
> > > > +		 */
> > > > +		lead->flags &= ~REQ_F_SQE_GROUP_LEADER;
> > > 
> > > What does this try to handle? A group with a leader but no
> > > members? If that's the case, io_group_sqe() and io_submit_state_end()
> > > just need to fail such groups (and clear REQ_F_SQE_GROUP before
> > > that).
> > 
> > The code block allows to issue leader and members concurrently, but
> > we have changed to always issue members after leader is completed, so
> > the above code can be removed now.
> 
> One case to check, what if the user submits just a single request marked
> as a group? The concern is that we create a group with a leader but
> without members otherwise, and when the leader goes through
> io_submit_flush_completions for the first time it drops it refs and
> starts waiting for members that don't exist to "wake" it. I mentioned
> above we should probably just fail it, but would be nice to have a
> test for it if not already.

The corner case isn't handled yet, and we can fail it by calling
req_fail_link_node(head, -EINVAL) in io_submit_state_end().


thanks,
Ming


