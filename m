Return-Path: <io-uring+bounces-3313-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E5C98717E
	for <lists+io-uring@lfdr.de>; Thu, 26 Sep 2024 12:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D93E01C20DC5
	for <lists+io-uring@lfdr.de>; Thu, 26 Sep 2024 10:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13E1171675;
	Thu, 26 Sep 2024 10:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b30iD0xX"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2B21ABEBC
	for <io-uring@vger.kernel.org>; Thu, 26 Sep 2024 10:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727346481; cv=none; b=JCEnlJSj+UfNCRwoeUh4bJnIvzCgsyUP4+MQ5ukCX2zHQq1tGjZuv6ym1PWX2S9xlwvCykoxiMCfPLshrjBWgbR1mmzPqI9THq2wn3dk1GZX5NF3U3tvv4CgY3/KRNKI6tVIn5PGZBO+YlRtvvVSwOVn0wbrIkmIAmlOXO4Jh8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727346481; c=relaxed/simple;
	bh=EvpvdHwuw/z1U8FaXt01QlEsuf+xQWVkBuNcbjFeUKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dOnuMtyTNeedkoYpU8pWtUto0FwLmzTipgEOKJ6D7wg/x7zhqJwxC0zBo3sKo+s46JEXKiKZGot80gYItYOzQ1cFiDIk2+T6QyhFJspCA6qQzAIrUqleXDyoaIYBWovRsOcOKfYAbAn1GTGoNoxSUWnhnjXw8YjaByhcGVHjB/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b30iD0xX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727346478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wNhVQcPxfhh+Uaxca3TRiKdPgAr9m2YKwDOWh1eVaQw=;
	b=b30iD0xXswJVFmItNJfoRjG1Qjf8hXiesWqdD+6p7KtBYYRJffvxKjHt9a1+5KXNaLPIWQ
	1egE7P6GXJUU8c9abGboa0YfP5b9IbFvao1LWDfNuGbBqVMxa+6CpTdEcR5hDrjBZnr61j
	qrXyzGF3mc//86IhhACxAMCq5gDMAaQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-520-q8gpCOvJNsyl6HIOrvmKKQ-1; Thu,
 26 Sep 2024 06:27:52 -0400
X-MC-Unique: q8gpCOvJNsyl6HIOrvmKKQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9AFB81979051;
	Thu, 26 Sep 2024 10:27:51 +0000 (UTC)
Received: from fedora (unknown [10.72.116.96])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 358B43003DEC;
	Thu, 26 Sep 2024 10:27:47 +0000 (UTC)
Date: Thu, 26 Sep 2024 18:27:42 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org
Subject: Re: [PATCH V6 0/8] io_uring: support sqe group and provide group kbuf
Message-ID: <ZvU3Hrm41txC0S-9@fedora>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912104933.1875409-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hello Pavel, Jens and Guys,

On Thu, Sep 12, 2024 at 06:49:20PM +0800, Ming Lei wrote:
> Hello,
> 
> The 1st 3 patches are cleanup, and prepare for adding sqe group.
> 
> The 4th patch supports generic sqe group which is like link chain, but
> allows each sqe in group to be issued in parallel and the group shares
> same IO_LINK & IO_DRAIN boundary, so N:M dependency can be supported with
> sqe group & io link together. sqe group changes nothing on
> IOSQE_IO_LINK.
> 
> The 5th patch supports one variant of sqe group: allow members to depend
> on group leader, so that kernel resource lifetime can be aligned with
> group leader or group, then any kernel resource can be shared in this
> sqe group, and can be used in generic device zero copy.
> 
> The 6th & 7th patches supports providing sqe group buffer via the sqe
> group variant.
> 
> The 8th patch supports ublk zero copy based on io_uring providing sqe
> group buffer.
> 
> Tests:
> 
> 1) pass liburing test
> - make runtests
> 
> 2) write/pass sqe group test case and sqe provide buffer case:
> 
> https://github.com/axboe/liburing/compare/master...ming1:liburing:sqe_group_v3
> 
> https://github.com/ming1/liburing/tree/sqe_group_v3
> 
> - covers related sqe flags combination and linking groups, both nop and
> one multi-destination file copy.
> 
> - cover failure handling test: fail leader IO or member IO in both single
>   group and linked groups, which is done in each sqe flags combination
>   test
> 
> - covers IORING_PROVIDE_GROUP_KBUF by adding ublk-loop-zc
> 
> 3) ublksrv zero copy:
> 
> ublksrv userspace implements zero copy by sqe group & provide group
> kbuf:
> 
> 	git clone https://github.com/ublk-org/ublksrv.git -b group-provide-buf_v3
> 	make test T=loop/009:nbd/061	#ublk zc tests
> 
> When running 64KB/512KB block size test on ublk-loop('ublk add -t loop --buffered_io -f $backing'),
> it is observed that perf is doubled.
> 
> 
> V6:
> 	- follow Pavel's suggestion to disallow IOSQE_CQE_SKIP_SUCCESS &
> 	  LINK_TIMEOUT
> 	- kill __io_complete_group_member() (Pavel)
> 	- simplify link failure handling (Pavel)
> 	- move members' queuing out of completion lock (Pavel)
> 	- cleanup group io complete handler
> 	- add more comment
> 	- add ublk zc into liburing test for covering
> 	  IOSQE_SQE_GROUP & IORING_PROVIDE_GROUP_KBUF 

Any comments on V6? So that I may address them in next version since
v6 has small conflict with mainline.


thanks,
Ming


