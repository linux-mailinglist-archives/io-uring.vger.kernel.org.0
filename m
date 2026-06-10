Return-Path: <io-uring+bounces-13657-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id WJVJHEk3KWrySQMAu9opvQ
	(envelope-from <io-uring+bounces-13657-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 12:07:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B0486681EF
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 12:07:04 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Nrslpx/I";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13657-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13657-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8078F3003482
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 09:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D93FA3A5453;
	Wed, 10 Jun 2026 09:54:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D411F938;
	Wed, 10 Jun 2026 09:54:07 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781085248; cv=none; b=o7XtreeU9X8tWTlcB3AVkWJI3riSknQE9CHoAUG08kL554A/fbFIFXePD9fCh3BBXPcCcDoYeIgLpUhlIh4fA4q6prNNIV+F3dv8pbhGpv94f3bsdGzSMhQQ0YaaGXH6WIwrnoua0meURhYsGgNtCP8Eb+cWLYslOb4KQrpPCjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781085248; c=relaxed/simple;
	bh=kkaRSdksZ11rtBhF44HXyR+jNvAELnkbi8MzDgI55WM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lsmk2bUUgrts4jgFTACloYMQTkrkiSvJNHdTPPzxvvn6FTSB/iPZj7z4qZO0svAWvi4E5DeBho59P6IeECzC+cZOso6aFrK4aev1DevVP4YI7vb6u68xbuj+JZcKl8byTHsHWUGSc5Qfek7ow8LLbN5FmJkGZiocDWNWStiS59o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nrslpx/I; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD371F00893;
	Wed, 10 Jun 2026 09:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781085247;
	bh=AOOcC8vMo1WFVxSe0Q2hEdY4dvsi3HRkW8edOmhhaUY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Nrslpx/IDtHzrfEr6PGCpfnTV5w0wOhuIa93SI6qWJhfb0DJjsGLY0GrIJMb38TF9
	 5fdwRdTy9CcTc2RJoQPrvhc+U2n21psKLy0r21v2JMutKIDf9mQxssI5R0lbNCdqkb
	 4igKAcZHoSI65ZP97JwqonD0iAoXumtbwD4ytQaM9yOrjUEAw1ceeXikWE2w/h7qDR
	 C3JLWj0hOnQiju/bIiul8zGY8jTAhkeW+4s8FvCwphsUYNLFRPcDjNwwVUiXPGAiGo
	 0X9vaicMShGUwqSusinGGPfgY3BG+Y9JL21r3yudLPjWD8d7asyTxhOjjG0ELui978
	 7tZJkRRwInc/A==
Message-ID: <f2b5189f-10de-4685-97f3-6ee08d159743@kernel.org>
Date: Wed, 10 Jun 2026 11:54:01 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1] io_uring/rsrc: add fast path huge page handling in
 buffer registration
To: Christoph Hellwig <hch@infradead.org>
Cc: sw.prabhu6@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, dave@stgolabs.net, dongjoo.seo1@samsung.com,
 Swarna Prabhu <s.prabhu@samsung.com>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, Matthew Wilcox <willy@infradead.org>,
 Zi Yan <ziy@nvidia.com>
References: <20260608062937.804758-1-sw.prabhu6@gmail.com>
 <c924fb59-be47-4fa5-adbf-a50a831ccd7b@kernel.org>
 <aikBIESiJftxBdfL@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aikBIESiJftxBdfL@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13657-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:hch@infradead.org,m:sw.prabhu6@gmail.com,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:dave@stgolabs.net,m:dongjoo.seo1@samsung.com,m:s.prabhu@samsung.com,m:linux-mm@kvack.org,m:willy@infradead.org,m:ziy@nvidia.com,m:swprabhu6@gmail.com,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[david@kernel.org,io-uring@vger.kernel.org];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org,stgolabs.net,samsung.com,kvack.org,infradead.org,nvidia.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[david@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6B0486681EF

On 6/10/26 08:16, Christoph Hellwig wrote:
> On Tue, Jun 09, 2026 at 08:36:43PM +0200, David Hildenbrand (Arm) wrote:
>> I really don't like arbitrary GUP users to starting to special case hugetlb
>> folios, and making assumptions of how other pages they pinned look like (IOW,
>> how the page table mappings actually looked like).
> 
> Me neither, but the current interfaces are kind forcing them :P

Yeah :)

But general rule: if you're outside of MM core and test for hugetlb folios, you
are doing something very wrong.

> 
>>
>> Ideally, we'd have a pin_user_pages_fast() variant that would give you a list of
>> folio ranges instead of individual pages.
> 
> Yes.  iov_iter_extract_bvecs and thus the block direct I/O fast path
> would instantly benefit from that.
The tricky bit for such an interface is that, soon, some pages won't be folios,
but we could still end up with non-folio pages in the address space (e.g.,
vm_insert_page()) and have to pin+return them. So using folios is not future-proof.

There are some long-term plans on providing an interface that would abstract how
you refcount something you GUP'ed. (because, some pages we GUP in the future
might not even have a dedicated refcount, all still fairly unclear). But it's
all not really finalized I think.

For now, we could expose a folio+page/offset+nr_pages interface, where we,
long-term, would not be able to return non-folio pages (e.g., vm_insert_page())
and would instead, in the future, fail the request if we stumble over a
non-folio thing in the page tables. That sounds reasonable for now.

Another solution would be, exposing page-ranges (e.g., page + nr_pages), whereby
we'd say, that all pages in a range belong to the same compound page, and that
we took a single reference for all pages in the range. IOW, page_folio() would
for now be the same for all pages in a range.

As soon as some mapped pages are no longer folios, we'll likely have to modify
plenty of drivers either way, that blindly cast pages to folios ...

So maybe a folio-range based interface is good enough for now.

-- 
Cheers,

David

