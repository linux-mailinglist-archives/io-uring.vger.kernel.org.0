Return-Path: <io-uring+bounces-13540-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wHSCAnoMGGpzbAgAu9opvQ
	(envelope-from <io-uring+bounces-13540-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 11:35:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 613615EFB45
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 11:35:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 175613026A8C
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 09:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CECF3AE18F;
	Thu, 28 May 2026 09:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vwFJrv3P";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WGHUy67C";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hKpjqBIJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bLDbaUfZ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F723ACF0B
	for <io-uring@vger.kernel.org>; Thu, 28 May 2026 09:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779960169; cv=none; b=DJufe41yknQl3Xs/AfKNBPeyCCXawe+boepjcmCb96WKWls2+MY7FspK+V1Gfj7LKKGUlvm/hV8YRIgRhtD4tpAAPNA9ecrl/khPmyhAHMMkjASdhkgiGWfFYzeL3L8ZXrjB72fwf9nVmvim0ZYQU/pcVj5ST9RMDUnM/3XcV0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779960169; c=relaxed/simple;
	bh=LmAHuJh+vNna2h86oEs3hhlxuhm/glTpqL0VwzrWRcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ex0nR1xSS42w1WZX7ERj9gg8sXWS0tuvVjnqXgDbW3Yq+cbSVhnbUfhfJrGwkFy+8W+NdN0xM+OnscVZD5VG5l5+wGDbeU/oE07qfMi/2wNMs1lMNIwD28B0mCQR3TDpYNrz4QlVBp6tpkFcbzmq4dtVLho8+AWVENsNE3MTJGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vwFJrv3P; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WGHUy67C; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hKpjqBIJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bLDbaUfZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 68A9767380;
	Thu, 28 May 2026 09:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779960163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=txEsarQVyN8eunFyNH+dCTUvcxmT63EdhouQVd3C0+E=;
	b=vwFJrv3PTA+YrYJJW4Ms+yETvFyZi8cym5fOaaG8hQgh4LCo5WZf7c6TVMngafgPJx0pCT
	NQmqTDY07CoKXY38uKajNl5AsKEJZW7MfCJxIhL2pzCbMkyN3j1Q6CGtzoTcH6R50t83E4
	sTP61OA3EbjACQ/o/eGw7NxYku7OdPk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779960163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=txEsarQVyN8eunFyNH+dCTUvcxmT63EdhouQVd3C0+E=;
	b=WGHUy67CH801700ZCizCQlnjNSXm4CGoaVzR0qm/EjUFuHjILBX1re9DUybIDWSOks31IJ
	g1zOezv0ur6I5YBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779960162; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=txEsarQVyN8eunFyNH+dCTUvcxmT63EdhouQVd3C0+E=;
	b=hKpjqBIJJJWkh7JFOAcIDpZgZddY1JA+3wYGfTHxv8D+49orws0VVkj4P4mq/UPUgGnlEP
	mesj/2kJXNRPv+79Jp0Jzzt0tj+yOivO3CwhDokCT3bv3c6jNhbQMFT0Kj+HSt9Mb4QpT4
	RW7v6uw3F767X5AzIC0jgOs3FJhLzM8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779960162;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=txEsarQVyN8eunFyNH+dCTUvcxmT63EdhouQVd3C0+E=;
	b=bLDbaUfZVoUHAoN5AsJRKhcMzI5Rj+pD0en3A8mlT5fyi513884lGAzCBNkv2qrVLsaiCr
	CUHd9zMd8UuGzvBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D0BE5ACF1;
	Thu, 28 May 2026 09:22:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VpaxFmIJGGrOQQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 28 May 2026 09:22:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0286FA0905; Thu, 28 May 2026 11:22:37 +0200 (CEST)
Date: Thu, 28 May 2026 11:22:37 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 00/11] mm/filemap: split out folio wait and VFS code
Message-ID: <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
X-Spam-Level: 
X-Spam-Score: -3.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,suse.cz:dkim,suse.com:email];
	DMARC_NA(0.00)[suse.cz];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13540-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.cz:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jack@suse.cz,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 613615EFB45
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed 20-05-26 16:48:51, Tal Zussman wrote:
> mm/filemap.c has accumulated additional infrastructure over the years
> that is not directly related to the page cache. It is currently nearly
> 5000 lines long. This series splits out the folio bit-lock and wait
> queue code into separate files, and moves the VFS-level
> generic_file_{read,write}_iter() family of files to fs/read_write.c, in
> order to provide better separation of concerns. This also slims down
> mm/filemap.c by ~1000 lines.
> 
> The folio wait infrastructure is centralized in mm/folio_wait.c and
> include/linux/folio_wait.h, with functions moved from mm/filemap.c,
> mm/page-writeback.c, and include/linux/pagemap.h. Afterwards, the code
> is cleaned up a little, with functions and data types renamed to refer
> to folios rather than pages.
> 
> generic_file_{read,write}_iter() implement the VFS-level read/write path
> for filesystems, including support for direct I/O. These functions and
> their helpers are moved to fs/read_write.c, along with other VFS-level
> read/write functions. dir_pages() is also moved to include/linux/fs.h.
> i_blocks_per_folio() is not moved from include/linux/pagemap.h, as it
> requires folio_size(), which is not currently available in
> include/linux/fs.h.
> 
> No functional change is intended.
> 
> Note: I have additional cleanups to mm/filemap.c ready to go, foremost
> among them centralizing on the filemap_*() naming convention and making
> the exposed page cache API clearer and more consistent, but I've split
> these patches off from that in order to avoid sending these logically
> separate patches to ~60 maintainers.

Overall this makes sense to me. In particular I agree it makes sense to
move the file read/write helpers into fs. Regarding the page waiting bits
it makes some sense to me as well although there it's more of "I don't
really care" opinion so let's see what Matthew and others think...

								Honza

> 
> ---
> Tal Zussman (11):
>       mm: add folio_wake_writeback() helper
>       folio_wait: move folio bit-lock and wait implementation to mm/folio_wait.c
>       folio_wait: move folio bit-lock and wait declarations to include/linux/folio_wait.h
>       folio_wait: move folio_wait_writeback() family to mm/folio_wait.c
>       folio_wait: reformat comments and fix alignment
>       folio_wait: rename wait_page_* infrastructure to wait_folio_*
>       folio_wait: convert VM_BUG_ON_FOLIO() to VM_WARN_ON_ONCE_FOLIO()
>       MAINTAINERS: add folio_wait files to MEMORY MANAGEMENT - CORE
>       fs: move dir_pages() from <linux/pagemap.h> to <linux/fs.h>
>       fs: move generic_file_read_iter() to fs/read_write.c
>       fs: move generic_file_write_iter() family to fs/read_write.c
> 
>  MAINTAINERS                |   2 +
>  fs/read_write.c            | 358 ++++++++++++++++
>  include/linux/folio_wait.h | 183 +++++++++
>  include/linux/fs.h         |  19 +-
>  include/linux/pagemap.h    | 184 +--------
>  io_uring/rw.c              |  14 +-
>  io_uring/rw.h              |   6 +-
>  mm/Makefile                |   2 +-
>  mm/filemap.c               | 993 +--------------------------------------------
>  mm/folio_wait.c            | 710 ++++++++++++++++++++++++++++++++
>  mm/internal.h              |   4 +
>  mm/page-writeback.c        |  66 ---
>  12 files changed, 1285 insertions(+), 1256 deletions(-)
> ---
> base-commit: e9add7501ad3297dad9b90ce201266830a68ab47
> change-id: 20260511-filemap-split-871b5c18e98c
> 
> Best regards,
> -- 
> Tal Zussman <tz2294@columbia.edu>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

