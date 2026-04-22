Return-Path: <io-uring+bounces-13121-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kFwcBm3H6GmYQAIAu9opvQ
	(envelope-from <io-uring+bounces-13121-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 15:04:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D72A04466C9
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 15:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 76211300CA01
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC5A35838E;
	Wed, 22 Apr 2026 13:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bC0asDaL"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D49212554
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 13:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776862994; cv=none; b=Imzyxq0nTvQbcu0o9/LYN46pdrREW8ImDxg2r9CicJYTvde9ymRHsuhbfCgU+D8EdRmkjOdVXj13FHlcoT7jLu0LtOBkCaEFXuOBIe4eBAsnyLdgUkU8aw6mPmG8mxqP1cTUWAhirylWRkhHbtEH36/kd1oD9FlNEGAN6ow42Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776862994; c=relaxed/simple;
	bh=GBN3jwDn6bo4Tibm1BrX0MIn2ftYBAN5f5do3Y3FhPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oUdul+QvMir74F3FYddQny187/AIjh39P6GPQraL5zHMbHCxfQF+ZDKIvkzC/QZNrWj4EnRQZ7oqEP5J6TuQDtsd3YjZurwoH4lZbO3DMyI4lS0TOP2m9zI4mPbqFokBtl/9wr3Gi1sFMjAULwo4twaTg1gomq0MyTrmj93YNr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bC0asDaL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26828C19425;
	Wed, 22 Apr 2026 13:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776862993;
	bh=GBN3jwDn6bo4Tibm1BrX0MIn2ftYBAN5f5do3Y3FhPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bC0asDaLNTu2iSdNA8WmsfSl4/kzLELsMVxfoXFooFBtASZiGpI0J4Yh2T1LoXC2E
	 rWPdXRlMBbqiAoLOztXCR6VcMxc5SusDTxh++JkPbUmvDEOwfdL2cAJUDkmS9juf/z
	 9+qHmgAh2Np2JYErANk6iizXQ6UkGCXi8KYEcHMY=
Date: Wed, 22 Apr 2026 15:03:11 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: take page references for NOMMU pbuf_ring mmaps
Message-ID: <2026042236-alienable-lilac-f857@gregkh>
References: <2026042115-body-attention-d15b@gregkh>
 <177679318887.642042.703437019420919449.b4-ty@b4>
 <dec29d85-9e79-42df-ae3d-9af65134283c@kernel.dk>
 <f1b43e56-4724-4635-b18b-bae2add37936@kernel.dk>
 <9c20876f-1cdb-429a-abb3-5ddbcd8cac00@kernel.dk>
 <2026042205-coroner-animosity-51b2@gregkh>
 <fdbf153e-d064-4992-9c99-f6aabac030ba@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdbf153e-d064-4992-9c99-f6aabac030ba@kernel.dk>
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13121-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: D72A04466C9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 22, 2026 at 06:40:37AM -0600, Jens Axboe wrote:
> On 4/22/26 2:11 AM, Greg Kroah-Hartman wrote:
> > On Tue, Apr 21, 2026 at 08:26:08PM -0600, Jens Axboe wrote:
> >> On 4/21/26 7:56 PM, Jens Axboe wrote:
> >>> On 4/21/26 7:17 PM, Jens Axboe wrote:
> >>>> On 4/21/26 11:39 AM, Jens Axboe wrote:
> >>>>>
> >>>>> On Tue, 21 Apr 2026 15:46:16 +0200, Greg Kroah-Hartman wrote:
> >>>>>> Under !CONFIG_MMU, io_uring_get_unmapped_area() returns the kernel
> >>>>>> virtual address of the io_mapped_region's backing pages directly;
> >>>>>> the user's VMA aliases the kernel allocation. io_uring_mmap() then
> >>>>>> just returns 0 -- it takes no page references.
> >>>>>>
> >>>>>> The CONFIG_MMU path uses vm_insert_pages(), which takes a reference on
> >>>>>> each inserted page.  Those references are released when the VMA is torn
> >>>>>> down (zap_pte_range -> put_page). io_free_region() -> release_pages()
> >>>>>> drops the io_uring-side references, but the pages survive until munmap
> >>>>>> drops the VMA-side references.
> >>>>>>
> >>>>>> [...]
> >>>>>
> >>>>> Applied, thanks!
> >>>>>
> >>>>> [1/1] io_uring: take page references for NOMMU pbuf_ring mmaps
> >>>>>       commit: d9b7b3d9c5286a786c7fe8220c55a6e012088c2e
> >>>>
> >>>> Actually, I take that back - what prevents the io_mmap_get_region()
> >>>> in the newly added io_uring_nommu_vm_close() from getting the same
> >>>> region that we initially referenced the pages from in the nommu
> >>>> variant of io_uring_mmap()?
> >>>
> >>> I think we can get rid of that and simplify the code at the same
> >>> time. Rather than need to re-lookup the buffer list, we can just iterate
> >>> the pages mapped in the vma. Since this is a file backed mapping and
> >>> io_uring doesn't allow remaps, that should always be the same.
> >>>
> >>> Greg, can you test this? I will fold this in.
> >>
> >> Here's the full patch - the incremental was missing a ')'. And
> >> for good measure, ensure that the vma size matches the pages in
> >> the region.
> > 
> > Yes, this works, thanks!
> > 
> > Tested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> I kept your attribution with the changes folded in, it's here
> since last night:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/commit/?h=io_uring-7.1&id=d0be8884f56b0b800cd8966e37ce23417cd5044e
> 
> Let me know if that's still fine with you.

No objection at all, looks fine, thanks.

And sorry for this, no-mmu is odd, hopefully the 3 users of it and
io_uring are thankful for this work :)

greg k-h

