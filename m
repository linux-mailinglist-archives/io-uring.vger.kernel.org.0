Return-Path: <io-uring+bounces-12188-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QH/eAonQjmnKFAEAu9opvQ
	(envelope-from <io-uring+bounces-12188-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 08:19:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 81456133743
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 08:19:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C9A693089789
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 07:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E73B296BD6;
	Fri, 13 Feb 2026 07:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r1LE8qFR"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCA01F03D2;
	Fri, 13 Feb 2026 07:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770967138; cv=none; b=Guxu4Ti7roi6gv40qJPDkAE/0H8hQOw8i/TcWJozT7xiJe7/1DHBdm5lz2B6+FJdI0saPO215DPdYVCMFxR5QoU6z65kH59gRZefm6+ZaXBJol8TL39pRlgvO3MtSR9xhZfZTjRfMnMC2si2zGVC65k5icaKICfpFqr8QJbGLYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770967138; c=relaxed/simple;
	bh=54uky7FLprRghcM/ynnTj012H7BCocpcOUwQFjdZCg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XEautsHOT1/yhXOwpwOZjfOeIfNg4heOXoVtkNgtNkgvfHaGbtmCDxtvmXCARbbryPH78RYiyYZ4iGlLl1wYejwK6A+eua7+IFLY9mjUBpY2s484VGoIMyvGFbjQa4iojEWLhAR8gOU67ztuZjpSu0iXaMrw1IzPGZRrwRkTOc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=r1LE8qFR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=853lt7steg77L6HAFxtLVXB7mTrJ/RvhkTgwi6whtgE=; b=r1LE8qFR9q+pXCbwBNNp+qvrqv
	sOTSvnQ6uAHNvi4TMh0kL+kXjKm5B3LVWvb1W3F6V4zCM4bN5/NJSZG2zVBkCNOq0YuUVKmLYcGfN
	ao2qebM5LbK1kta3iRzTsSuDSwXQ/bcxx7IHmu0bdIgt1WnHq5tOOm7xT1yHh7EQZZeLctwIdwsFZ
	AS3byAKdJ07Nzs03jMeWX8mq1kp4Mq4fEJikcReAvfNk5Wjt8NAu7A5rk1/2lGD7SKZk3t2O9UgR8
	fxp5+ybJQBjxYjHW6xtisL9L9/mJqHshmPm3D/D0ZjW+MhDzg3WWOHvygwfmvsIgUnUtHLa5CZ0I9
	YqPi0ctA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqnS3-000000035wf-29N6;
	Fri, 13 Feb 2026 07:18:55 +0000
Date: Thu, 12 Feb 2026 23:18:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Joanne Koong <joannelkoong@gmail.com>, axboe@kernel.dk,
	io-uring@vger.kernel.org, csander@purestorage.com, krisman@suse.de,
	bernd@bsbernd.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
Message-ID: <aY7QX-BIW-SMJ3h_@infradead.org>
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
 <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <aYykILfX_u9-feH-@infradead.org>
 <bd488a4e-a856-4fa5-b2bb-427280e6a053@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd488a4e-a856-4fa5-b2bb-427280e6a053@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-12188-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:mid,infradead.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 81456133743
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 10:44:44AM +0000, Pavel Begunkov wrote:
> > 
> > Any pages mapped to userspace can be allocated in the kernel as well.
> 
> pow2 round ups will waste memory. 1MB allocations will never
> become 2MB huge pages. And there is a separate question of
> 1GB huge pages. The user can be smarter about all placement
> decisions.

Sure.  But if the application cares that much about TLB pressure
I'd just round up to nice multtiple of PTE levels.

> 
> > And I really do like this design, because it means we can have a
> > buffer ring that is only mapped read-only into userspace.  That way
> > we can still do zero-copy raids if the device requires stable pages
> > for checksumming or raid.  I was going to implement this as soon
> > as this series lands upstream.
> 
> That's an interesting case. To be clear, user provided memory is
> an optional feature for pbuf rings / regions / etc., and I think
> the io_uring uapi should leave fields for the feature. However, I
> have nothing against fuse refusing to bind to buffer rings it
> doesn't like.

Can you clarify what you mean with 'pbuf'?  The only fixed buffer API I
know is io_uring_register_buffers* which always takes user provided
buffers, so I have a hard time parsing what you're saying there.  But
that might just be sign that I'm no expert in io_uring APIs, and that
web searches have degraded to the point of not being very useful
anymore.


