Return-Path: <io-uring+bounces-13112-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qBMvJGBe6GnlJgIAu9opvQ
	(envelope-from <io-uring+bounces-13112-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 07:36:32 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF294421CC
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 07:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AB22D300D552
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 05:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3454191F94;
	Wed, 22 Apr 2026 05:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oyg9qQN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADD861FFE
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 05:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776836186; cv=none; b=LkLgN4suMQUyOghs3oEC7bZdM1Bsrl1aX4OGF7+J/ch/GbhyBz9cA8264S23dkgngYdQmXvU0niBrydQYPB6a2KvFcoxUOZALNb+MDP3iMxnZAXKpahH91eM86SXpu0sO+gi0NggFNTRuFPjKbFiNXsjBV3VEv4GNYYxG7j3spk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776836186; c=relaxed/simple;
	bh=M6QXlGyATEYZNCdkmfTEvWtnth1yc1+F2f7sRGzV3uk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TyGeCh9h/RrQ5YlsB/9WturHB92vLr65R3Ma+142RN2ynhvmhIprwxlIqvFNObWVq6b4Ct1CWKDT/5gAgHJwvho6nvgzG2L1IfrMrBve4VPy0s/OwUUeiKVQKEnU/Ae0O4UVwhNAqbskEmVMZ8XW5GsKPAmOHt35c7i9nJebmHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oyg9qQN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A44C2BCB3;
	Wed, 22 Apr 2026 05:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776836186;
	bh=M6QXlGyATEYZNCdkmfTEvWtnth1yc1+F2f7sRGzV3uk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0oyg9qQNsJv/M7jzhNB+qyR+pGS5Zepjkw1ibDxQL/UozhgSM9DEt9bJS8BQyfSQ3
	 C2wxQUhyJF0mGW1gURAa/rKNSHCZbKXrwLW+m4jd5sYIMNnDTi075ZxNexmLRoNqyK
	 MmUW/LpSCw/efPtkG/t7Em0su7fgBsNZyeFFEtmY=
Date: Wed, 22 Apr 2026 07:36:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: take page references for NOMMU pbuf_ring mmaps
Message-ID: <2026042238-mantis-habitant-b112@gregkh>
References: <2026042115-body-attention-d15b@gregkh>
 <177679318887.642042.703437019420919449.b4-ty@b4>
 <dec29d85-9e79-42df-ae3d-9af65134283c@kernel.dk>
 <f1b43e56-4724-4635-b18b-bae2add37936@kernel.dk>
 <9c20876f-1cdb-429a-abb3-5ddbcd8cac00@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c20876f-1cdb-429a-abb3-5ddbcd8cac00@kernel.dk>
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TAGGED_FROM(0.00)[bounces-13112-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linuxfoundation.org:dkim]
X-Rspamd-Queue-Id: 8EF294421CC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Apr 21, 2026 at 08:26:08PM -0600, Jens Axboe wrote:
> On 4/21/26 7:56 PM, Jens Axboe wrote:
> > On 4/21/26 7:17 PM, Jens Axboe wrote:
> >> On 4/21/26 11:39 AM, Jens Axboe wrote:
> >>>
> >>> On Tue, 21 Apr 2026 15:46:16 +0200, Greg Kroah-Hartman wrote:
> >>>> Under !CONFIG_MMU, io_uring_get_unmapped_area() returns the kernel
> >>>> virtual address of the io_mapped_region's backing pages directly;
> >>>> the user's VMA aliases the kernel allocation. io_uring_mmap() then
> >>>> just returns 0 -- it takes no page references.
> >>>>
> >>>> The CONFIG_MMU path uses vm_insert_pages(), which takes a reference on
> >>>> each inserted page.  Those references are released when the VMA is torn
> >>>> down (zap_pte_range -> put_page). io_free_region() -> release_pages()
> >>>> drops the io_uring-side references, but the pages survive until munmap
> >>>> drops the VMA-side references.
> >>>>
> >>>> [...]
> >>>
> >>> Applied, thanks!
> >>>
> >>> [1/1] io_uring: take page references for NOMMU pbuf_ring mmaps
> >>>       commit: d9b7b3d9c5286a786c7fe8220c55a6e012088c2e
> >>
> >> Actually, I take that back - what prevents the io_mmap_get_region()
> >> in the newly added io_uring_nommu_vm_close() from getting the same
> >> region that we initially referenced the pages from in the nommu
> >> variant of io_uring_mmap()?
> > 
> > I think we can get rid of that and simplify the code at the same
> > time. Rather than need to re-lookup the buffer list, we can just iterate
> > the pages mapped in the vma. Since this is a file backed mapping and
> > io_uring doesn't allow remaps, that should always be the same.
> > 
> > Greg, can you test this? I will fold this in.
> 
> Here's the full patch - the incremental was missing a ')'. And
> for good measure, ensure that the vma size matches the pages in
> the region.

Cool, thanks, will test this this afternoon after I get some stable
kernels released.  Sorry to make you do this extra work for this odd
config combination.

greg k-h

