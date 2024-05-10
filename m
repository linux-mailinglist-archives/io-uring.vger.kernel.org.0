Return-Path: <io-uring+bounces-1857-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 057D68C263C
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 16:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84F792842DE
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 14:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 765D312C7FB;
	Fri, 10 May 2024 14:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VAGoeDeO"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CC712C7E8
	for <io-uring@vger.kernel.org>; Fri, 10 May 2024 14:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715349744; cv=none; b=teexzT7pA0Dfws78Bysed6eduWsKCTN41cFFRD2Yr2jfet4r+2c1GwTeyFoq9X9k863fERyHqa5VBSrBC+hnVWJ3AxvCspYrQtmDhKBzBbYWd3pOUeZMfnqy0t2+8O2AKSxDmIG/xhk+nMmd/DP6oXXHt1tCpIzkcPwCeZkJHZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715349744; c=relaxed/simple;
	bh=qNrQblarQm/eAKeHXbimZo9JwH2CpESovcKUE0JuP/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i7w9ORFJbI/lTOti6ScZNoBapjehrVWNU+tl6s7PlgirzPdbOoAjvJN5G9gp7x7UKZJ5NC27OwjpMHV4rf4/uD4qbOGPeMnnUtq8XttjnsKC0L9DsK1GbB4QGH5kYZ6tUIcSHAFvaeslYuYEKJP3a5tLqH2SmvaAXy35kBirpuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VAGoeDeO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715349741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D1dqZxcbBRaFgQ3CYFJI1laffgSrUenXWyya9D4bc6s=;
	b=VAGoeDeOqUa9mouhuA4QKh+LfXPPdJnVk2+G+zvhGHsq0mZGJGBaUmqXhZtDTVScYIhmoQ
	3CzvhuPwiJgCVTdRRSFRtr8IaHlR9ZXXZgz7Nttg1dDdBlgyuRUmRXLs0Wyv2OhNTukAfl
	8n+GBerCvqld29B/Yz7el8QX4ANEEcE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-_mDPlR_MNkaHfJKcasvu6w-1; Fri, 10 May 2024 10:02:19 -0400
X-MC-Unique: _mDPlR_MNkaHfJKcasvu6w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BD578016FA;
	Fri, 10 May 2024 14:02:19 +0000 (UTC)
Received: from fedora (unknown [10.72.116.93])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A1641D6946B;
	Fri, 10 May 2024 14:02:15 +0000 (UTC)
Date: Fri, 10 May 2024 22:02:12 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>
Subject: Re: [RFC PATCH V2 0/9] io_uring: support sqe group and provide group
 kbuf
Message-ID: <Zj4o5LjuLo6fGeDd@fedora>
References: <20240506162251.3853781-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506162251.3853781-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Tue, May 07, 2024 at 12:22:36AM +0800, Ming Lei wrote:
> Hello,
> 
> The 1st 4 patches are cleanup, and prepare for adding sqe group.
> 
> The 5th patch supports generic sqe group which is like link chain, but
> allows each sqe in group to be issued in parallel, so N:M dependency can be
> supported with sqe group & io link together.
> 
> The 6th patch supports one variant of sqe group: allow members to depend
> on group leader, so that kernel resource lifetime can be aligned with
> group leader or group, then any kernel resource can be shared in this
> sqe group, and can be used in generic device zero copy.
> 
> The 7th & 8th patches supports providing sqe group buffer via the sqe
> group variant.
> 
> The 9th patch supports ublk zero copy based on io_uring providing sqe
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
> covers related sqe flags combination and linking groups, both nop and
> one multi-destination file copy.
> 
> 3) ublksrv zero copy:
> 
> ublksrv userspace implements zero copy by sqe group & provide group
> kbuf:
> 
> 	git clone https://github.com/ublk-org/ublksrv.git -b group-provide-buf_v2
> 	make test T=loop/009:nbd/061:nbd/062	#ublk zc tests
> 
> When running 64KB block size test on ublk-loop('ublk add -t loop --buffered_io -f $backing'),
> it is observed that perf can be doubled.
> 
> Any comments are welcome!
> 
> V2:
> 	- add generic sqe group, suggested by Kevin Wolf
> 	- add REQ_F_SQE_GROUP_DEP which is based on IOSQE_SQE_GROUP, for sharing
> 	  kernel resource in group wide, suggested by Kevin Wolf
> 	- remove sqe ext flag, and use the last bit for IOSQE_SQE_GROUP(Pavel),
> 	in future we still can extend sqe flags with one uring context flag
> 	- initialize group requests via submit state pattern, suggested by Pavel
> 	- all kinds of cleanup & bug fixes

Please ignore V2, and will send V3 with simplification & cleanup, and
many fixes on error handling code path.


Thanks,
Ming


