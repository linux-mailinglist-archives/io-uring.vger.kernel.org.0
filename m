Return-Path: <io-uring+bounces-12163-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id L9qzL1GkjGmgrwAAu9opvQ
	(envelope-from <io-uring+bounces-12163-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:46:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B3B5125D38
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:46:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DD300300CCAC
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 15:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08293318BB6;
	Wed, 11 Feb 2026 15:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ct67Suxf"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E61B317701;
	Wed, 11 Feb 2026 15:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770824739; cv=none; b=WlapOVzCQ7EnVIDVktiejuDCJjssGvp4x9y+rpZs5itxkwetbqYKLmqcNDdtxqtRtpa0WfQ0BNtwzg4ARqoFK0OWcpdP9/DRqHfdWk5A3Bm8/TbGWc+m5nXfD4DKT+6QwUTTwKViTUVSXuHUB0YeyHt+fmyCt1z386QKKym8SBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770824739; c=relaxed/simple;
	bh=Vi2rVLK9jD5gt4NZfmDrB+4OmvfQhlw6kIPIVrTmh3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mm5YQc2DNpEueM//Ti12oBS1AlWu3XdyYlEG92Qf/b54x6stsXqr78CA8zULdry2EEkKtcm1Kl1le1mlHuszShJ3q6805kyL/42HvxVeZuQ8VlFtsZOa6Nz0HJdjPHNQ7OmdAAPal76HzE39XYpV4QR9d+VdP719PEPEvoT2DLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ct67Suxf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=quchVHCEJxHoMugGym9DQDRQY2PW3QylUONV+ZucEdQ=; b=ct67SuxfQmejEHA6GQjo3xwOSk
	0ozgeBLfcbYcWFkgGeDFl7Fot5XhEDNDmZ1GrR0k/ysBmNyaDr/u+6EBb8NotviOKEHNvbnazWFQA
	yaEXCrt21ljw7KTPoLvissLDBJAiUPZAgiMFGASsbgbugnj31zxKOUSiG7GpU0IyxI9eGmhV3/m6N
	YKMBKgq8eKw3x5ZJJXXxL9myM+yeAtPN7+5XAZKYoQiq+gvxhMBim14bnpCXmuafKSItQZu4vWOky
	5IYuOxqBBK0EsflQThknHeT1UIZV8zeIk2BzotBRsEUfnL4B6OwVp1m1ekHkBKYuCT5FkNHM66xKS
	hp91MjXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqCPI-00000000nzI-1v5g;
	Wed, 11 Feb 2026 15:45:37 +0000
Date: Wed, 11 Feb 2026 07:45:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, axboe@kernel.dk,
	io-uring@vger.kernel.org, csander@purestorage.com, krisman@suse.de,
	bernd@bsbernd.com, hch@infradead.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
Message-ID: <aYykILfX_u9-feH-@infradead.org>
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
 <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12163-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:mid,infradead.org:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3B3B5125D38
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 04:34:47PM +0000, Pavel Begunkov wrote:
> > +	union {
> > +		/* used for pbuf rings */
> > +		__u64	ring_addr;
> > +		/* used for kmbuf rings */
> > +		__u32   buf_size;
> 
> If you're creating a region, there should be no reason why it
> can't work with user passed memory. You're fencing yourself off
> optimisations that are already there like huge pages.

Any pages mapped to userspace can be allocated in the kernel as well.

And I really do like this design, because it means we can have a
buffer ring that is only mapped read-only into userspace.  That way
we can still do zero-copy raids if the device requires stable pages
for checksumming or raid.  I was going to implement this as soon
as this series lands upstream.


