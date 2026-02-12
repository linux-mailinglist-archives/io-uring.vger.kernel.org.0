Return-Path: <io-uring+bounces-12176-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iBzhOHymjWkM5wAAu9opvQ
	(envelope-from <io-uring+bounces-12176-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 11:07:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C3B12C429
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 11:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F0B32301CF9C
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 10:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B74AD2D6E58;
	Thu, 12 Feb 2026 10:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YWH/5Izb"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F339E246BA7;
	Thu, 12 Feb 2026 10:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770890874; cv=none; b=leDY7TAtojcmdOoNrOnI2lT8aFcLEcNSJzle3QsynJDduWuK/2hVoNC0iH3KLs1JF8IRfMwEA7zI91xJJ2y7EjJw39Kb17HpnDb50zOCiHSRTFd3iNpx0oUtHWZHURebbuTnAU0H3J3GAgzU0G6JUp4ThTbb/pbkzQGwFv9eMjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770890874; c=relaxed/simple;
	bh=uTyItwhkWyUdGHdWTNVgB/OwNLaAluY2qSDBafx/3dU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sx++4e1/RCB+Hxn3e7z0kH5NhFtB3D8En37dPrZC2StUTAyOSwXeshDdN+Oho1WYZ+40UhfMdRwGLAMJC0d44bEBSEyI0lD90r1ZMl9ws9DqNxU7B4NMFgrGOW9V3qgGvGkbu/3OQ/pE1/C4vT453OzxnqhsHLu4JX7HraWJB/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YWH/5Izb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jSlX9h8f/KU7AnNLwZBHlCdwR/NrX+FSMXQajoFNUxM=; b=YWH/5IzbWtN6t6m9InMkRDgPEa
	dc6Fov4F7pnYfAY6Foqeaqu3e/ph7K4ikhMfu2iwY75Hxui4x6QOdCzsosdpdukZD81HIwk74H4UE
	gVLWa4AMOovmCpmM6+DbcJp3xgPnYY2KeA/FAHFKS1OE77FFUJLii+sdJFkDeFWfEvHBbJ2nvSlAr
	Ga0wyfoqOjrDWzyU6FNDLaYIXp34DoRWhUh386XdxLzwiuv2e5cRHe3mvDPR0iUfNfG64et1Ugzc6
	KXOtHkASTjm7qtPDsL5TV1rHBltpX8mOBydYleC9WHZSH8heK3BhAzpEf/sxbWO6JhZVP0uEXim47
	KUXG4oIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqTbw-00000001tyA-08vU;
	Thu, 12 Feb 2026 10:07:48 +0000
Date: Thu, 12 Feb 2026 02:07:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
	io-uring@vger.kernel.org, csander@purestorage.com, krisman@suse.de,
	bernd@bsbernd.com, hch@infradead.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
Message-ID: <aY2mdLkqPM0KfPMC@infradead.org>
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
 <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <CAJnrk1ZZyYmwtzcHAnv2x8rt=ZVsz7CXCVV6jtgMMDZytyxp3A@mail.gmail.com>
 <1c657f67-0862-4e13-9c71-7217aeecef61@gmail.com>
 <CAJnrk1YXmxqUnT561-J7seaicxFRJTyJ=F3_MX1rmtAROC6Ybg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1YXmxqUnT561-J7seaicxFRJTyJ=F3_MX1rmtAROC6Ybg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12176-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org,purestorage.com,suse.de,bsbernd.com,infradead.org];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 47C3B12C429
X-Rspamd-Action: no action

On Wed, Feb 11, 2026 at 02:06:18PM -0800, Joanne Koong wrote:
> > I don't think I follow. I'm saying that it might be interesting
> > to separate rings from how and with what they're populated on the
> > kernel API level, but the fuse kernel module can do the population
> 
> Oh okay, from your first message I (and I think christoph too) thought
> what you were saying is that the user should be responsible for
> allocating the buffers with complete ownership over them, and then
> just pass those allocated to the kernel to use. But what you're saying
> is that just use a different way for getting the kernel to allocate
> the buffers (eg through the IORING_REGISTER_MEM_REGION interface). Am
> I reading this correctly?

I'm arguing exactly against this.  For my use case I need a setup
where the kernel controls the allocation fully and guarantees user
processes can only read the memory but never write to it.  I'd love
to be able to piggy back than onto your work.


