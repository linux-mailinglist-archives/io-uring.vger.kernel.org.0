Return-Path: <io-uring+bounces-2530-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25CC19371BF
	for <lists+io-uring@lfdr.de>; Fri, 19 Jul 2024 03:04:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56D7A1C21436
	for <lists+io-uring@lfdr.de>; Fri, 19 Jul 2024 01:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DAF1B86DD;
	Fri, 19 Jul 2024 01:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IqpEV2Lb"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32262184D
	for <io-uring@vger.kernel.org>; Fri, 19 Jul 2024 01:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721351055; cv=none; b=qGygrDhzpYrF8lQ6OEEyKSkk7zrmKCoYrSksD7QaRj4qiYCWiYhJOjuOtEYKrlAcCqDyRLfTdm82hgX1nV35kIwBE80mF6YY8UM9m2GYDOYzf89HTF3Eu9n7rbJ0UF/BQYiq92vHrlAqG2DftVWb77xPyn9KDqzpPkkbTA4z1KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721351055; c=relaxed/simple;
	bh=xoVkdnLCPDYd+igZTdcJKttbVbNiO2wwJ2WdEWrv6f4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uK8X9qKn4rmAuITblUq2Y7lHkQWS1irHzPuF0YUPIe+ZJbY8IiSdGLHlexc4yuucbkFRGSnMHiY9m5Y5kDGSS2cauflqTql7AlC4Y67FWIpJk+IjEiTx+H4Z4sljkUjBc8ZE0b5r5+O3N68uwAl2JVqBpYuU2fSgIGF6GBTlKf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IqpEV2Lb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721351052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0/+m/ahUJGV3RhkazPV+AXppEPQ0PlekRSmpcfSfqXQ=;
	b=IqpEV2LbBVzEq7j47jU/e1q9cN0XuzTswAjSMc/hcpbuc+6f0V6Q8hv28+Y0Teo6RMuclL
	xVYwdevlFme2+mlIcoY9LDer2h4rYJD0bM9g4MHF0LS2J4eDgfGG1kfc0ACGXcliMC7Nr/
	cLPsVGkLRmwvmZb8V2PqDl49mvd6K/c=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-260-LKFZxmK4PPOKPqarqu-NVQ-1; Thu,
 18 Jul 2024 21:04:07 -0400
X-MC-Unique: LKFZxmK4PPOKPqarqu-NVQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01DD419560AA;
	Fri, 19 Jul 2024 01:04:06 +0000 (UTC)
Received: from fedora (unknown [10.72.116.76])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13ACB195605A;
	Fri, 19 Jul 2024 01:04:01 +0000 (UTC)
Date: Fri, 19 Jul 2024 09:03:56 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	ming.lei@redhat.com
Subject: Re: [PATCH V4 0/8] io_uring: support sqe group and provide group kbuf
Message-ID: <Zpm7fLVsZHpFRWPq@fedora>
References: <20240706031000.310430-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240706031000.310430-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Sat, Jul 06, 2024 at 11:09:50AM +0800, Ming Lei wrote:
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
> 2) write/pass two sqe group test cases:
> 
> https://github.com/axboe/liburing/compare/master...ming1:liburing:sqe_group_v2
> 
> - covers related sqe flags combination and linking groups, both nop and
> one multi-destination file copy.
> 
> - cover failure handling test: fail leader IO or member IO in both single
>   group and linked groups, which is done in each sqe flags combination
>   test
> 
> 3) ublksrv zero copy:
> 
> ublksrv userspace implements zero copy by sqe group & provide group
> kbuf:
> 
> 	git clone https://github.com/ublk-org/ublksrv.git -b group-provide-buf_v2
> 	make test T=loop/009:nbd/061	#ublk zc tests
> 
> When running 64KB/512KB block size test on ublk-loop('ublk add -t loop --buffered_io -f $backing'),
> it is observed that perf is doubled.
> 
> Any comments are welcome!
> 
> V4:
> 	- address most comments from Pavel
> 	- fix request double free
> 	- don't use io_req_commit_cqe() in io_req_complete_defer()
> 	- make members' REQ_F_INFLIGHT discoverable
> 	- use common assembling check in submission code path
> 	- drop patch 3 and don't move REQ_F_CQE_SKIP out of io_free_req()
> 	- don't set .accept_group_kbuf for net send zc, in which members
> 	  need to be queued after buffer notification is got, and can be
> 	  enabled in future
> 	- add .grp_leader field via union, and share storage with .grp_link
> 	- move .grp_refs into one hole of io_kiocb, so that one extra
> 	cacheline isn't needed for io_kiocb
> 	- cleanup & document improvement

Hello Pavel, Jens and Guys,

Gentle ping...


thanks,
Ming


