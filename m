Return-Path: <io-uring+bounces-12189-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aMZ+EV3RjmnJFAEAu9opvQ
	(envelope-from <io-uring+bounces-12189-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 08:23:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FDB01337C3
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 08:23:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE9B53007AFC
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 07:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E65F2D46D6;
	Fri, 13 Feb 2026 07:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="miQqrRKl"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB9E2D0614;
	Fri, 13 Feb 2026 07:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770967301; cv=none; b=Rkib0REFa19LCIOoefsoNVxD9RQDpdFg+D916i62LYDhvUKM7xej1LaT1DlQK6knTnBpQDte+Z93VbqahyJCTBT96xeocc3c/cEoEE0n4OT2TsvN+VYaXQHgksCQeYOxzrk9LAJCj+cnsgVxFPmGpg1Z9PCZNg2jzo8dMxxXuvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770967301; c=relaxed/simple;
	bh=d58jNyFP4c6x62DKuHGytiRAbkeCTxY3dwORzpI699k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HhyExzikv+IHWyGH9ncnJSmpcK4lUr81mYZmU80/JQUA3hoLAVetJml9PT7+FtzXOg8UAW/bErhQ7M3VPhf0lK74WJYB3Tdk+2oJCPMz/Myg6v/xyLSTB7vaiMNPfVTvcDnR8mNY/6Kj4D1847X8wt203T8Mci+BiMpx3CkOgjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=miQqrRKl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w8XX0e+hf5Z2QUNXIEOROxGO64PWLl9iu8IzemUOXhs=; b=miQqrRKly9DqxAmRmrgTAxZ410
	BdAj/alRPQftoUVJNcJcK1B5Tzw/ExAgpbwxVwNEY6PgMWjCXpRKEL8tU7N7m5LMApL8CxujedT0i
	2qZygIOE8FJtfDFtfGb/5BP2FxA5T29oZAm65pOnFx9vPd4kHrXTJclqsZw6RVaOh9tdocmtPdbQj
	OC8o9EAX1QQh7j1S/GKUu/iZnGWXMWYQJNy5pbgIIvt2HF2sMib80NAeCJX/2l8CKGNoeuK1SG6mA
	33WfVrJZN8wZVUqIgqRGISPiJSkzTQm0vk++aIJCjtc9ed/FwCUKMCXPzD7x2+MzsVS47MGc0YEKk
	q2mRHlUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqnUh-00000003674-0qU9;
	Fri, 13 Feb 2026 07:21:39 +0000
Date: Thu, 12 Feb 2026 23:21:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Joanne Koong <joannelkoong@gmail.com>, axboe@kernel.dk,
	io-uring@vger.kernel.org, csander@purestorage.com, krisman@suse.de,
	bernd@bsbernd.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
Message-ID: <aY7RA8-65WE6Q9Fv@infradead.org>
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
 <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <CAJnrk1ZZyYmwtzcHAnv2x8rt=ZVsz7CXCVV6jtgMMDZytyxp3A@mail.gmail.com>
 <1c657f67-0862-4e13-9c71-7217aeecef61@gmail.com>
 <CAJnrk1YXmxqUnT561-J7seaicxFRJTyJ=F3_MX1rmtAROC6Ybg@mail.gmail.com>
 <aY2mdLkqPM0KfPMC@infradead.org>
 <809cd04b-007b-46c6-9418-161e757e0e80@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <809cd04b-007b-46c6-9418-161e757e0e80@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12189-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,kernel.dk,vger.kernel.org,purestorage.com,suse.de,bsbernd.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 9FDB01337C3
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 10:52:29AM +0000, Pavel Begunkov wrote:
> > I'm arguing exactly against this.  For my use case I need a setup
> > where the kernel controls the allocation fully and guarantees user
> > processes can only read the memory but never write to it.  I'd love
> > to be able to piggy back than onto your work.
> 
> IORING_REGISTER_MEM_REGION supports both types of allocations. It can
> have a new registration flag for read-only, and then you either make

IORING_REGISTER_MEM_REGION seems to be all about cqs from both your
commit message and the public documentation.  I'm confused.

> the bounce avoidance optional or reject binding fuse to unsupported
> setups during init. Any arguments against that? I need to go over
> Joanne's reply, but I don't see any contradiction in principal with
> your use case.

My use case is not about fuse, but good old block and file system
I/O.


