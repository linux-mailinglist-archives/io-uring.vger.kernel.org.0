Return-Path: <io-uring+bounces-13017-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eCJnF1T012llVAgAu9opvQ
	(envelope-from <io-uring+bounces-13017-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 20:47:48 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B75903CED53
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 20:47:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D1AB6302206D
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2026 18:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3BB3321DE;
	Thu,  9 Apr 2026 18:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="owuKJyaN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31E131E832;
	Thu,  9 Apr 2026 18:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775760438; cv=none; b=uoeAO6bZLUxIWc3P92ixceBvNZRX+lG5vU7rrsLEBcOD8rnJULRL0hQyCycLYFiCAWI2YT6A9v8K/F2UuTCcsSj0F94c017CGW79SZrKbWgx4IgNWO5R6cRMT/yGV3EnJz0FiV+qxU5qJPkE/zSJYf1rwdUqytFs3AgQZVE3xoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775760438; c=relaxed/simple;
	bh=wN7F9fKA4JbTA7CrHbrx+JQKhgCNMy1dmZE3mrBVygs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RguChvrP5cG/D5YYRq4a3PtEvJfaqsqe6WbqV1ZTfInOcBWkGCM6TZDzQpyQ1OcEbfbLwAXJRXvEsXWYYkjHrrktEY04v3AA4dsq2KnwqcXH4PR+D8oSw0tEuyS4U1VXDnCiMIwUMUrp1sKsFphxHwBUejjIoqcLUIyd8LhyRd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=owuKJyaN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375EBC4CEF7;
	Thu,  9 Apr 2026 18:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775760437;
	bh=wN7F9fKA4JbTA7CrHbrx+JQKhgCNMy1dmZE3mrBVygs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=owuKJyaNvfKZGn7M9p437+zqIiaBIW/76VhQXhB5XG4mopCJ0v7M3eZfMO8GBmg4f
	 pXYEKtK3X6JByMf6/K5Kz4GQmE3fVh5OnPMmfyV7O1rfWrQ5escXD9UKfMdeyIeMnD
	 bIMM5TfxCVqRqvluSTqQ6SpTcfaJO5JrfXsW4cOEyX5aeol6ot1VhTjo+Nip2jz0jS
	 pBBBkfb6T5o49dZPSNnXXTPmS2C9nqAenKbw78Z7/IwAHi+MHWMGeVdkEbcNBxGLT8
	 Jb4NiKlMCy/tNQn4pL68drhnCCPrmlLiwBFNQFhUGtc31v/H9nCrk309ydrD3oAUvt
	 QJOtzGeE1OjZA==
Message-ID: <4edea589-26b0-486a-9703-3b8c2d528a42@kernel.org>
Date: Thu, 9 Apr 2026 20:47:07 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] Separate compound page from folio
To: Zi Yan <ziy@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jens Axboe <axboe@kernel.dk>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20260130034818.472804-1-ziy@nvidia.com>
 <c1a2a49b-8141-418f-b239-167ef031451b@kernel.org>
 <3C342301-A8E4-4EC4-BB9E-9C8246F8D6F7@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3C342301-A8E4-4EC4-BB9E-9C8246F8D6F7@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13017-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[david@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B75903CED53
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


Sorry for the late reply on this.

>> As discussed, the issue is still that interpret non-folio page
>> allocations as folios, which can also be compound pages.
>>
>> Now, there are PFN walkers that do that, but also page table handling code.
>>
>> Most prominently, when mapping such pages through vm_insert_pages(), we
>> will call into folio_add_file_rmap_pte() and essentially touch mapcount
>> related stuff.
>>
>> Once in the page tables, users can GUP them and modify the pincount.
>> Other page table walkers can just similarly find them and look them up.
>>
>> To stop messing with mapcounts is easy once we can reliably identify
>> such pages when mapping/unmapping them.
> 
> My current way of doing that is to mark every page “NotRmappable” page_type
> in post_alloc_hook() and clear this page_type at page_rmappable_folio().
> Any user wants to set their own page_type can overwrite “NotRmappable”.
> And folio_test_rmappable() is just !folio_has_type(). One exception
> is hugetlb, since it has page_type and is rmappable. Fortunately or
> unfortunately, rmap.c has special handling code for hugetlb, so there
> should be no problem.
> 
> I did some test using io_uring (via nvim), which uses compound page instead of
> folio and does vm_insert*(). At least no crash was present.
> 

We discussed that in the meantime elsewhere. :)

>>
>> GUP and other page table walkers are more problematic and need more
>> thought (and work :( ).
>>
>> Essentially, vm_normal_folio() would have to fail on these pages. But
>> what to do about vm_normal_page() users? The page_folio() would have to
>> fail. But then we must keep some page table walkers working.
>>
>> And we have to figure out what to do with GUP.
> 
> Since _pincount will not be present after my change, GUP cannot be applied
> on these pages.
> 
> OK, my memory comes back. I think my original proposal of separating
> compound page from folio might not be right, since that defeats the
> purpose of folio, which is a group of pages managed as a whole.
> 
> Basically a compound page should still be regarded as a folio, but rmappable
> related fields (e.g., _large_mapcount, _nr_pages_mapped, _mm_ids)
> should not be initialized and user is free to use them differently.
> In this way, _pincount can be a common folio field to initialize and use.

At least long term a non-folio page should not be regarded a folio.

There are quite some changes required to teach page table walkers (incl.
GUP) about that.

In GUP code, we would not mess with the _pincount for non-folio things.
It will be a bit tricky.

Handling the rmap (skip it) as a first step might be easier.

> 
>>
>> So compound pages are just the tip of the iceberg :)
>>
>>
>> We could maybe forbid mapping them through vm_insert_pages() in the
>> first place, requiring all callers to do order-0 page allocations. Hm.
>>
>> Then at least they would not end up in user page tables.
> 
> Will it kill performance? If only order-0 pages are allowed.

I don't think this is really performance-relevant for the
vm_insert_pages() interface. We never get PMD-THPs either way.

But yea, if we could keep that compound pages working that would also
make our life easier.

> 
>>
>> But there is other code where compound pages are interpreted as folios
>> and the other way around that must be sorted out.
> 
> I think we might want to have some sub-class of folios, like rmappable folios,
> not rmappable folios, and others, otherwise, we are going back
> to mixing page and folio.

I think it's pretty clear that a folio will be mappable.

If you want something that is not mappable, then you shouldn't be
allcoating a folio that carries metadata for storing all that information.

-- 
Cheers,

David

