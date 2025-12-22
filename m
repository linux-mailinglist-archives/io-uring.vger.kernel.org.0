Return-Path: <io-uring+bounces-11249-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5642FCD73DA
	for <lists+io-uring@lfdr.de>; Mon, 22 Dec 2025 23:09:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E73ED3006E16
	for <lists+io-uring@lfdr.de>; Mon, 22 Dec 2025 22:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83EC5266EE9;
	Mon, 22 Dec 2025 22:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YeLb2vM9"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0828C1DE4E1;
	Mon, 22 Dec 2025 22:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766441335; cv=none; b=geKYWB93YEU4jDxrAY0bWBY8RiTDItIqYxtVD2AK+1tV2PBW2SZtJI5W72v+2QP36P7wykybfl2OEqpLD8vIAlVbvirndf1MR1Fpu/B+3EPJSEAMc6LU+7xCKvko71oCM/RDPuIEUKd8q9YnqaDhH9VRTDhA4jPYgVfmDZu59R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766441335; c=relaxed/simple;
	bh=QNVGTM+Uotfoy8TK2T1baw0u45BsuGp1i9xX+mENfGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NrGlp+P+B5tZ+Afr8o0ImqXp/wH1OTTdHwwqjT2RM3s7/BXIwgiaLsP+bITC5AUjwOw8SlXxcMs40CVpd0aLvaMDHNN+yU9GuxCjDpp6XZ7sSFdyDwXaxWCnq1CP7RyOwo4Cb83ZZ360njD4x8b56j4fRrCBQl9AvD/+rtG8LYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YeLb2vM9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8BI4ypHtw1IoG6TaJJZ9Yf51Wo2viuSjxasakAnPzmg=; b=YeLb2vM9S41h04dstwCD58x3zV
	mg06LgDq9qdpYBzEdgnhdDdwf6bdKVo+lzAwAwAUKPOhffAGsg+xv/aYo6OrVRgivDbUGrdPnW41w
	MJPtiYXZKQ2SD/y9wf3mPgJkGRDEmltfjfwRXhxgU5/MEBYcHTW7i1GVOZgO8CBC9tZxEOc4LUx3Z
	37mycDZdYEOdCnd06xbO3pNYR2j3TJ92z/YFybkdQVbEuU+9ZtjluYUP3kka54P0G1C6LqGfcm4lB
	521Nj5ajjBwnx0npL11lps9wbSnwRblz/pJ75kfFQ7mvVa8f2QeR6V3fEVLW/FfPTjU4pxLZE2XIl
	i7XFj71g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXo5A-0000000EDOj-0rv5;
	Mon, 22 Dec 2025 22:08:48 +0000
Date: Mon, 22 Dec 2025 14:08:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, veygax <veyga@veygax.dev>,
	Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	Caleb Sander Mateos <csander@purestorage.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rsrc: fix slab-out-of-bounds in
 io_buffer_register_bvec
Message-ID: <aUnBcNG1j5usNBtu@infradead.org>
References: <20251217210316.188157-3-veyga@veygax.dev>
 <aUNLs5g3Qed4tuYs@fedora>
 <f1522c5d-febf-4e51-b534-c0ffa719d555@veygax.dev>
 <aUNRS1Qiaiqo1scX@kbusch-mbp>
 <aUTjxJEDYYfOT_QG@infradead.org>
 <aUiC2615oUTgF_PT@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUiC2615oUTgF_PT@kbusch-mbp>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 22, 2025 at 07:29:31AM +0800, Keith Busch wrote:
> > The above is simply an open coded version of doing repeated
> > __bio_add_page calls.  Which would be rather suboptimal, but perfectly
> > valid.
> 
> Yeah, there's nothing stopping someone from using it that way, but a
> quick survey of __bio_add_page() users appear to be special cases that
> allocate a single vector bio, so its existing use is a short-cut that
> bio_add_page() will inevitiably reach anyway. Did you intend for it to
> be called directly for multiple vector uses too? It is suboptimal as you
> said, so it still feels like a misuse if someone did that.

We can't even force users to use __bio_add_page.  Take a look at
drivers/md/bcache/util.c:bch_bio_map() for a real-life example for
something that could create this bvec pattern.

