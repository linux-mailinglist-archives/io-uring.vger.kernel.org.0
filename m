Return-Path: <io-uring+bounces-7141-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77A6AA6A0A1
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 08:42:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E826742597E
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 07:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 552F51F869E;
	Thu, 20 Mar 2025 07:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F2PBYwek"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D6C1F4CAE
	for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 07:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742456542; cv=none; b=iPlaewvkgmYMQA99mBZuwo846nbQtAGwDI8vgNGtsF77Eo7Dfy7jNmX1375T9RZSzliUrmyJDJA1l1IBTX8PD1ZbadoXuvGONvlM9InRjAow0kvDRMOaTU4YSrTvY3mXjL9LX1Y6MWyfUiVnv7OBe7BDKxn/aBiKX9K2HwE12ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742456542; c=relaxed/simple;
	bh=DJzXSmy/bbs+qKb+f67Qgl7ywvF5y9oAZVpOItOiVZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRyGnHo0YhQL0n9N3TZQ90XOerfPSLSfJvS3CRB6qC4eIhdXTrz0pN5oyCI+x9Khy+345iu8ZoLdhrio083EbcodF17X3bMw+JtHTEOEHvaFpguzqPzEVh3CaUJoK5GCHIN21mnaC59ftRmtwuRbq5hFu1L7enYf/3ZMeGJ8FvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F2PBYwek; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742456539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U8pGM+K1r9HJttHN9XN8AarpXIQG27tn6vD2t40C+P8=;
	b=F2PBYwekMUhhaErAsvVYQj5Fo8eFyudZ6OJbfOZwTDpJXv82N8RcQ9IMn3o/+yIyd1f9Gy
	+3VOnYUefaTN7wcPf6wW+H3CoA5cRHbPFkogfGDPAAbjd50knhP4sfkO0rDRHOujEm9Hza
	QevaQ+w9om8OK/eRKoMyMpgfqs4mtC8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-157-ncbbwjXyPlqHiGYBctJwvg-1; Thu,
 20 Mar 2025 03:42:16 -0400
X-MC-Unique: ncbbwjXyPlqHiGYBctJwvg-1
X-Mimecast-MFC-AGG-ID: ncbbwjXyPlqHiGYBctJwvg_1742456534
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64D8D19560B0;
	Thu, 20 Mar 2025 07:42:14 +0000 (UTC)
Received: from fedora (unknown [10.72.120.32])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 684B81828A87;
	Thu, 20 Mar 2025 07:42:03 +0000 (UTC)
Date: Thu, 20 Mar 2025 15:41:58 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>,
	Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z9vGxrPzJ6oswWrS@fedora>
References: <a8e5c76a-231f-07d1-a394-847de930f638@redhat.com>
 <Z8-ReyFRoTN4G7UU@dread.disaster.area>
 <Z9ATyhq6PzOh7onx@fedora>
 <Z9DymjGRW3mTPJTt@dread.disaster.area>
 <Z9FFTiuMC8WD6qMH@fedora>
 <7b8b8a24-f36b-d213-cca1-d8857b6aca02@redhat.com>
 <Z9j2RJBark15LQQ1@dread.disaster.area>
 <Z9knXQixQhs90j5F@infradead.org>
 <Z9k-JE8FmWKe0fm0@fedora>
 <Z9u-489C_PVu8Se1@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9u-489C_PVu8Se1@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Thu, Mar 20, 2025 at 12:08:19AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 18, 2025 at 05:34:28PM +0800, Ming Lei wrote:
> > On Tue, Mar 18, 2025 at 12:57:17AM -0700, Christoph Hellwig wrote:
> > > On Tue, Mar 18, 2025 at 03:27:48PM +1100, Dave Chinner wrote:
> > > > Yes, NOWAIT may then add an incremental performance improvement on
> > > > top for optimal layout cases, but I'm still not yet convinced that
> > > > it is a generally applicable loop device optimisation that everyone
> > > > wants to always enable due to the potential for 100% NOWAIT
> > > > submission failure on any given loop device.....
> > 
> > NOWAIT failure can be avoided actually:
> > 
> > https://lore.kernel.org/linux-block/20250314021148.3081954-6-ming.lei@redhat.com/
> 
> That's a very complex set of heuristics which doesn't match up
> with other uses of it.

I'd suggest you to point them out in the patch review.

> 
> > 
> > > 
> > > Yes, I think this is a really good first step:
> > > 
> > > 1) switch loop to use a per-command work_item unconditionally, which also
> > >    has the nice effect that it cleans up the horrible mess of the
> > >    per-blkcg workers.  (note that this is what the nvmet file backend has
> > 
> > It could be worse to take per-command work, because IO handling crosses
> > all system wq worker contexts.
> 
> So do other workloads with pretty good success.
> 
> > 
> > >    always done with good result)
> > 
> > per-command work does burn lots of CPU unnecessarily, it isn't good for
> > use case of container
> 
> That does not match my observations in say nvmet.  But if you have
> numbers please share them.

Please see the result I posted:

https://lore.kernel.org/linux-block/Z9FFTiuMC8WD6qMH@fedora/


Thanks,
Ming


