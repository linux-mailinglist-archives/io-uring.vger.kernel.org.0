Return-Path: <io-uring+bounces-13576-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ILD0IWBFHWpbXwkAu9opvQ
	(envelope-from <io-uring+bounces-13576-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 10:40:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A574E61B99B
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 10:39:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2AC123012C4F
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2026 08:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1866F388E66;
	Mon,  1 Jun 2026 08:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pCo8u5/E"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D64349CD7;
	Mon,  1 Jun 2026 08:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780303051; cv=none; b=fSkm8n3mkuWeN2IHgZNfNW8xWGFjaR1Dmb7rM9eMyuJPCLoolEoC1JWIVvkkqvTDPNIJkNFCH7wsXzAao+igDu6x/WZ5exI08F2gbmHjQuG1L/JnY5eJLtYkJItdS4A1SJynOsDlLZpzlBqqMzYZQH2lPXreEEFn+v7wYrXPFKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780303051; c=relaxed/simple;
	bh=nl6p8HLHC286uT4ikfAHUI8B6U9Db6HbVPCH/fT5W64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dQbx+n3OHH2FXgr2zp8OM6DeIC92iORxpmLkVVEhqo7ANjfxKr5zm+wJRhcm+CEivcoWNKCYaQOr7iM+hwH9YAVyofjHFUyJDZ3gvvlapnmSCKrPjxXCrKYASyn1g5ZPybP0fn5TGFZtjFaoq+/HO5JAcZNzY/uWBLmL//eL1zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pCo8u5/E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kbipd5my0kxdieuohQ54gw7V4ZjO4rD65DLmWgf5FoU=; b=pCo8u5/EGo61wq7DLV4otnZqdD
	OMKAhmp+oGDMcYMT7Ta0Gra/svzVEhzB9h4Mlyr6qhbqnHyzJRuakcf9K2wnhh4Xs5svWnMG3nU39
	nEFEwBIbWdCzHAa6ZQkLfL8Z9u4Du4KKPYJSY8uDCe7irg541ag9s+9qsPiZklhNsBKlzzXNQKtv3
	i9m0sjGUjA1z4hn2Wy0EtQdYV8IChJPs05aiIkFxoYXU65kECrcx7M4vBe/jpoV/uSwO3BBjMcFtY
	Jr6zC9JTzuHWs9fNDLqK9lWXUH95ZY0YIoMRqh6Vyvg1M7o2fyRtr0zo5aAT5aGrduWeDV17HwtHc
	OF6Pvsiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wTy9F-0000000AN5J-1YMj;
	Mon, 01 Jun 2026 08:37:25 +0000
Date: Mon, 1 Jun 2026 01:37:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 00/11] mm/filemap: split out folio wait and VFS code
Message-ID: <ah1ExWQdq4yhnmqC@infradead.org>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
 <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
 <ahg55Ei8Fc3iRsnA@infradead.org>
 <fb59cca8-28b0-4231-a109-a6ae0ea12a03@columbia.edu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb59cca8-28b0-4231-a109-a6ae0ea12a03@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13576-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[infradead.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:mid,infradead.org:dkim,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Queue-Id: A574E61B99B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, May 29, 2026 at 06:54:07PM -0400, Tal Zussman wrote:
> On 5/28/26 8:49 AM, Christoph Hellwig wrote:
> > On Thu, May 28, 2026 at 11:22:37AM +0200, Jan Kara wrote:
> >> Overall this makes sense to me. In particular I agree it makes sense to
> >> move the file read/write helpers into fs.
> > 
> > I disagree very strongly.  Mixing default implementations with the
> > higher level APIs is a really bad idea and leads to people taking
> > stupid shortcuts and other layering violations.
> 
> fs/read_write.c already contains some of these "generic" function
> implementations, including generic_write_checks(), which is called by
> generic_file_write_iter() in mm/filemap.c. Right now the two files are
> unnecessarily interdependent. I do think fs/read_write.c is the natural home
> for these functions.

generic_write_checks is a very different beast.  It is a generic helper
that every implementation must call. The implementations have to call
it with the right locks held, and this it can't be done before calling
into the method.

> > Splitting up filemap.c makes sense, but I'd rather keep the generic copy
> > into and out of the pagecache code with the MM infrastructure for it,
> > as it is not VFS code, and making that clear to anyone touching the code
> > is important.
> 
> About half the code moved is implementing direct I/O or multiplexing between
> page cache I/O and direct I/O.

This will hopefully change quite a bit once we move everyone off the
legacy direct I/O code and the helpers for it.  Another reason not to
move the code around for now as it should change a bit.

> It definitely shouldn't be in the page cache,
> and I do think it is VFS code.

For the higher level stuff I'd agree.  But I'm not sure how much
is left after the above.  If we have good helpers left something like
libfs.c or a new library might be a better place.

> The one exception I see is
> generic_perform_write(), which is analogous to filemap_read() and should stay
> in filemap.c (and probably be renamed to something like filemap_write()).

Agreed on that.

