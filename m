Return-Path: <io-uring+bounces-12275-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aOfPDWH+k2lN+QEAu9opvQ
	(envelope-from <io-uring+bounces-12275-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 06:36:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ECBE148D58
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 06:36:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8BA6630056E4
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 05:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 455FD21FF4D;
	Tue, 17 Feb 2026 05:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3OXEl1VB"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6981A9F91;
	Tue, 17 Feb 2026 05:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771306587; cv=none; b=BqznZvBYBzrGpZeZlm/f2BKwIEqijSJ5ScMh9SlTzdNU28tVD992tkSfHkw9zJZCSFUeUgYaSIeYGi4Ge2lIFmwWsgclhBG9Hzjzo46KD5hLSha6C5mhY9OIPzOVg59QX69rV7tdNU97jig5UeVc+cVZEKBDwRjGLXsrsx6Q76s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771306587; c=relaxed/simple;
	bh=Vw1yWF0Y4bPZu/NH62MxUlVYzxnY8/zuN6APZzd3cr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ghq3iByGR5x1V6BD6Uu1kl3UEJtYObQdf6iYngTrb6/DlDTps25p/1ZjnCIFvw82lsju3ObNFE7kPjVl+zOMAYRCzPvHeIFPAL3kL/ja2ANWSq0pxpCcKlKjy6omxVk4nw7BuobBTeEWeyJmEiL7ydqddj0jWdz33JiA903Bvco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3OXEl1VB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oUQd9aN1YNBwK0GRI+zqCnDPDmHN4dFR3i34SLyEQnM=; b=3OXEl1VBLrOHijeRAD7VI3lMfQ
	Cpgb3Mg3Gc2RQLyXOxxwIobsVsAAYJfMIJG9W/ketJBmeyfCBOeNv2XvoA8X/p5CNadtxEfaFei3q
	37xEDroiFdq4W1Dd8+fOqZ+g4ZIzEfjSZJnLdCcun4RQt0W08KidCpQkXz/dKCBB7ZXd67Cd4vRfI
	iWRoCo3qnuhevqmU4+NKVthLbRMe4GO9FWLr0fycnwy4l/+7fuY7yeLo/uNrPGAUUbWpbbutWgQ9N
	HCCuEbqQ0fWKstEdO9Lnqwjbnw7h6mbIO0sd8tr2Ujb7mtWaL+wjX9p5pe7wWTfhUQyCS35i1/v/Y
	Ii1SsKDw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsDky-00000007eLL-2Ka6;
	Tue, 17 Feb 2026 05:36:20 +0000
Date: Mon, 16 Feb 2026 21:36:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
	io-uring@vger.kernel.org, csander@purestorage.com, krisman@suse.de,
	bernd@bsbernd.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
Message-ID: <aZP-VOoX1OyuVQ3B@infradead.org>
References: <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <CAJnrk1ZZyYmwtzcHAnv2x8rt=ZVsz7CXCVV6jtgMMDZytyxp3A@mail.gmail.com>
 <1c657f67-0862-4e13-9c71-7217aeecef61@gmail.com>
 <CAJnrk1YXmxqUnT561-J7seaicxFRJTyJ=F3_MX1rmtAROC6Ybg@mail.gmail.com>
 <aY2mdLkqPM0KfPMC@infradead.org>
 <809cd04b-007b-46c6-9418-161e757e0e80@gmail.com>
 <CAJnrk1Y6YSw6Rkdh==RfL==n4qEYrrTcdbbS32sBn12jaCoeXg@mail.gmail.com>
 <aY7ScyJOp4zqKJO7@infradead.org>
 <7c241b57-95d4-4d58-8cd3-369751f17df1@gmail.com>
 <CAJnrk1b2BHwBzz+AS7x0WuJSpf98x1xGhf1ys2rm4Ffb0_5TOA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1b2BHwBzz+AS7x0WuJSpf98x1xGhf1ys2rm4Ffb0_5TOA@mail.gmail.com>
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
	TAGGED_FROM(0.00)[bounces-12275-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,infradead.org,kernel.dk,vger.kernel.org,purestorage.com,suse.de,bsbernd.com];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:mid,infradead.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1ECBE148D58
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 11:09:13AM -0800, Joanne Koong wrote:
> 
> I think the circular buffer will be useful for Christoph's use case in
> the same way it'll be useful for fuse's. The read payload could be
> differently sized across requests, so it's a lot of wasted space to
> have to allocate a buffer large enough to support the max-size request
> per entry in the io_ring.

Yes.

> With using a circular buffer, buffers have a
> way to be shared across entries, which means we can significantly
> reduce how much memory needs to be allocated.

Or enable such flexible use cases at all.


