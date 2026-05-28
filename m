Return-Path: <io-uring+bounces-13544-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4IihNsEiGGocdggAu9opvQ
	(envelope-from <io-uring+bounces-13544-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 13:10:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 634345F1150
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 13:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F4129302BE3E
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 11:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4550B3DEFF7;
	Thu, 28 May 2026 11:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YCbfHbhj"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2486C3D300F;
	Thu, 28 May 2026 11:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779966295; cv=none; b=nU6CevhDNkHkfXU0nXHtQwDGDvypUHLROuRyFbWED212zReD4tbXzf2fZGpRE+dSEBDv2X1ugwkVIMfh3Mo8lG1krBmuG53ZC2dZWe4UzyHegfKsRhdrFsHhXtyKvcobNce82fZ8PA1ibVWdfh8z4e8HlFFb7wWpovrFPSdCpiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779966295; c=relaxed/simple;
	bh=T6JB05hAGxyMFGAmY03iZ7VbcaWbUyLPPRrLFW52GWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oo8M52dWaCKqfiCUK9js3MAnvNQrTcG4arZm023z1PhXRcwvRaikqMvutq/d0H3JQpKmUPezpEt7AFJR4PcuT40liI3Ojr9btYEJZEfCKktqqOs0CWyHLWQB0UX0MkblGulPqZx8RKfFQxVHNWqXqM5NZ50sYtMlAubtREV9Oa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YCbfHbhj; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9901F000E9;
	Thu, 28 May 2026 11:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779966293;
	bh=1CtNhjUDYMnWJZV/Dh2r76Lj7h4Wsj50+rJVpRB4uMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YCbfHbhjlXZWCfKJpb2O3XC8LEjKZ6k7AbSaY2ch87NRacAc53wORdw1mKyoXIgTL
	 nHJCayohntixBeIdQyNTUJpDEZjs7f9dumba6qLLN2tG5FUt5xlsrJgvGcNSzEDxh7
	 +Eg9MhxtvjAWmve64F8Rd+VRQ6h4s/oZzvqlmII6656WaN9KHGu647gDmLcRkPpmc4
	 Y44VW/9OJnMgIy1Vfn2+qwKUOvdaBoA25LhoN+Tu+5hUcN7hBPNuQCV2Wb5vxTBe5r
	 5IC0/ksIxwXEwETTdi6Q2I08V4f1Q+m278bVLidsQOPbhIlAdioVG86tnMtrbCwfUA
	 gFkqKdWD02dUg==
Date: Thu, 28 May 2026 13:04:47 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Tal Zussman <tz2294@columbia.edu>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 00/11] mm/filemap: split out folio wait and VFS code
Message-ID: <20260528-gepflanzt-losging-ballen-75e4489d9b9f@brauner>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
 <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13544-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 634345F1150
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, May 28, 2026 at 11:22:37AM +0200, Jan Kara wrote:
> On Wed 20-05-26 16:48:51, Tal Zussman wrote:
> > mm/filemap.c has accumulated additional infrastructure over the years
> > that is not directly related to the page cache. It is currently nearly
> > 5000 lines long. This series splits out the folio bit-lock and wait
> > queue code into separate files, and moves the VFS-level
> > generic_file_{read,write}_iter() family of files to fs/read_write.c, in
> > order to provide better separation of concerns. This also slims down
> > mm/filemap.c by ~1000 lines.
> > 
> > The folio wait infrastructure is centralized in mm/folio_wait.c and
> > include/linux/folio_wait.h, with functions moved from mm/filemap.c,
> > mm/page-writeback.c, and include/linux/pagemap.h. Afterwards, the code
> > is cleaned up a little, with functions and data types renamed to refer
> > to folios rather than pages.
> > 
> > generic_file_{read,write}_iter() implement the VFS-level read/write path
> > for filesystems, including support for direct I/O. These functions and
> > their helpers are moved to fs/read_write.c, along with other VFS-level
> > read/write functions. dir_pages() is also moved to include/linux/fs.h.
> > i_blocks_per_folio() is not moved from include/linux/pagemap.h, as it
> > requires folio_size(), which is not currently available in
> > include/linux/fs.h.
> > 
> > No functional change is intended.
> > 
> > Note: I have additional cleanups to mm/filemap.c ready to go, foremost
> > among them centralizing on the filemap_*() naming convention and making
> > the exposed page cache API clearer and more consistent, but I've split
> > these patches off from that in order to avoid sending these logically
> > separate patches to ~60 maintainers.
> 
> Overall this makes sense to me. In particular I agree it makes sense to
> move the file read/write helpers into fs. Regarding the page waiting bits

Seconded.

> it makes some sense to me as well although there it's more of "I don't
> really care" opinion so let's see what Matthew and others think...

Agreed.

