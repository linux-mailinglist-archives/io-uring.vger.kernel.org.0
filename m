Return-Path: <io-uring+bounces-1342-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF63B892914
	for <lists+io-uring@lfdr.de>; Sat, 30 Mar 2024 04:50:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B7FDB21D6B
	for <lists+io-uring@lfdr.de>; Sat, 30 Mar 2024 03:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31DB26FB9;
	Sat, 30 Mar 2024 03:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s3NYFOpK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="993feCE0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0216463CB
	for <io-uring@vger.kernel.org>; Sat, 30 Mar 2024 03:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711770616; cv=none; b=RqncHVGzQR6onZRoDEF+gWQOexteZU+58wPqGzF8OrBiCopWaYWdZJiO3C/07VxmS0AoYLWrUnE+ul9OB12/rBwRhjZkFPn6Q3g1v7bz/MHt+t0d+j0RhhFGG3PNVhsStHNiSg/+pNF8GQcvbQw3ZbKXF19ik9oDoSQtRP+Dyiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711770616; c=relaxed/simple;
	bh=FM26tu8bNISAFcLz903tHHuJP6+xKzBx9J3zeXpIwdE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QcMvjDXpTFVEZiklFJQl+yMF0eXX7grJE7tFBZXISZ1bnMgZ2+H2hhRxPlqREkvXZX1XYxgFMiLTZsxylDsVhcEnsSrADXVO7PS24Gzgn5KJynhpvPbdUU69F6NA0vAkhWPURL1D4jC/TulGHA7GoSekNEA+6w8mO2Bj2DE5OQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=s3NYFOpK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=993feCE0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 01FB7224A1;
	Sat, 30 Mar 2024 03:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711770612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MZepWYPap/ZAoVqZTbYPLjCyrTlHa3yNwuHcKiyU3eE=;
	b=s3NYFOpK01IaHy5XGXNJY8SgX6NzvSFb07H5RfP1D9tpt+XYjEL7usG65IJuPBPDgiej0L
	5b6qTyvw/RrlvLQl+p6XPvLBxZPyK4LDPWqIlJdBJg5lVvqkSMddNFOoccHF4vvh2A/grr
	oJwhKIO3iGnFsD+pt4rNCMYwqRQU/h4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711770612;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MZepWYPap/ZAoVqZTbYPLjCyrTlHa3yNwuHcKiyU3eE=;
	b=993feCE03iroJ26d3oR+Uvj/GA52lltY6UXHZTO7BGJjzNw8ZdTiOiwBn+AUOktYKbvGqj
	9aFhePgBMDNFraAg==
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id B8446138F1;
	Sat, 30 Mar 2024 03:50:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id 69e7IPOLB2YnKgAAn2gu4w
	(envelope-from <krisman@suse.de>); Sat, 30 Mar 2024 03:50:11 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,  hannes@cmpxchg.org
Subject: Re: [PATCH 02/11] io_uring: get rid of remap_pfn_range() for
 mapping rings/sqes
In-Reply-To: <20240328233443.797828-3-axboe@kernel.dk> (Jens Axboe's message
	of "Thu, 28 Mar 2024 17:31:29 -0600")
References: <20240328233443.797828-1-axboe@kernel.dk>
	<20240328233443.797828-3-axboe@kernel.dk>
Date: Fri, 29 Mar 2024 23:50:05 -0400
Message-ID: <87bk6w5qfm.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spamd-Result: default: False [-0.30 / 50.00];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	BAYES_HAM(-0.00)[42.45%];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_THREE(0.00)[3]
X-Spam-Score: -0.30
X-Spam-Level: 
X-Spam-Flag: NO

Jens Axboe <axboe@kernel.dk> writes:

> Rather than use remap_pfn_range() for this and manually free later,
> switch to using vm_insert_pages() and have it Just Work.
>
> If possible, allocate a single compound page that covers the range that
> is needed. If that works, then we can just use page_address() on that
> page. If we fail to get a compound page, allocate single pages and use
> vmap() to map them into the kernel virtual address space.
>
> This just covers the rings/sqes, the other remaining user of the mmap
> remap_pfn_range() user will be converted separately. Once that is done,
> we can kill the old alloc/free code.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/io_uring.c | 136 +++++++++++++++++++++++++++++++++++++++++---
>  io_uring/io_uring.h |   2 +
>  2 files changed, 130 insertions(+), 8 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 104899522bc5..982545ca23f9 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2594,6 +2594,33 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
>  }
>  
> +static void io_pages_unmap(void *ptr, struct page ***pages,
> +			   unsigned short *npages)
> +{
> +	bool do_vunmap = false;
> +
> +	if (*npages) {
> +		struct page **to_free = *pages;
> +		int i;
> +
> +		/*
> +		 * Only did vmap for the non-compound multiple page case.
> +		 * For the compound page, we just need to put the head.
> +		 */
> +		if (PageCompound(to_free[0]))
> +			*npages = 1;
> +		else if (*npages > 1)
> +			do_vunmap = true;
> +		for (i = 0; i < *npages; i++)
> +			put_page(to_free[i]);
> +	}

Hi Jens,

wouldn't it be simpler to handle the compound case separately as a
folio?  Then you folio_put the compound page here and just handle the
non-continuous case after.

-- 
Gabriel Krisman Bertazi

