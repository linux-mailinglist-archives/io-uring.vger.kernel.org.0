Return-Path: <io-uring+bounces-1782-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 986FB8BD278
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 18:20:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54AEA2811EE
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 16:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B24D5156F2B;
	Mon,  6 May 2024 16:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bMuxHhF2"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6381815749F;
	Mon,  6 May 2024 16:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715012314; cv=none; b=qfnwyr4ZF91xrve52VRKVD/bPhgK0+66Dn4SO3yke3psV3+iD3QAxj9o8dCZn/JPp+Do9GTODnrzdv3xPRC0tmsphuUMpmE7yWpkwWUNNjM4aQOYEx0AJFzvg7JLLTJggntds6tNL5Z/M/Li7vLibFwdtMA7HXDG0uVmZS0iIOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715012314; c=relaxed/simple;
	bh=B+l+Vceb5iUkpUiQegPKcQBQ6e7ieWSDk2oBGPQNb0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=peStWZgOjXlEyHKYYsHbO4tT+HgEGkCXpSOZMnAkgOs/ePdi9H6oyDC28DiUQzph8SAPEVLFDsg2Hu3Vd4IeEp5FBnhn9T1+i11zCx5wA+qgG5VNRdfbOrbeXvJDYhJEbcxM5acvgMFHKqAbA8Vl3lX4PFgUJNicWcoMF6V4svk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bMuxHhF2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=h1ODgGE2m2OEgAd8jHSSbz3SpjDDWzrnbcCs/Pk5lAc=; b=bMuxHhF23V2OWvmdmi4hKXKgc1
	ZzTQu/fmdHL4ph7ohGu1qlDG6jTXSmG7rU1UUbY09BURxmrKdDTriz7tPK9FKnYdqn4XHFDKQ+JN7
	8Hfc5AR9xQzTtQ/3abdN4woK/Na7wyH2o5JYueuWFCeWPJzElAg/wjx6OTiXiSo3vjukUk47M/HrJ
	pFv2WUBehexhoJHOMK9/JQEg8sv0AM1smhToD3pH4UQwccAZInCVdkwQaiQweO+cIgRdGTSyQ1EQ9
	e3/yUN6O/GBIuc3cNvd823V2dLpUkS/qNmLdtUV+00RwAfWw91vaWaQpXaQiZV/0GfkBXnYEgRHqh
	rVccTsog==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s412q-000000082GK-2Fr1;
	Mon, 06 May 2024 16:18:28 +0000
Date: Mon, 6 May 2024 09:18:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, bp@alien8.de,
	bpf@vger.kernel.org, broonie@kernel.org,
	christophe.leroy@csgroup.eu, dan.j.williams@intel.com,
	dave.hansen@linux.intel.com, debug@rivosinc.com, hpa@zytor.com,
	io-uring@vger.kernel.org, keescook@chromium.org,
	kirill.shutemov@linux.intel.com, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-s390@vger.kernel.org,
	linux-sgx@vger.kernel.org, luto@kernel.org, mingo@redhat.com,
	nvdimm@lists.linux.dev, peterz@infradead.org,
	sparclinux@vger.kernel.org, tglx@linutronix.de, x86@kernel.org
Subject: Re: [PATCH] mm: Remove mm argument from mm_get_unmapped_area()
Message-ID: <ZjkC1KgTTbR4qzhC@infradead.org>
References: <20240506160747.1321726-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506160747.1321726-1-rick.p.edgecombe@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 06, 2024 at 09:07:47AM -0700, Rick Edgecombe wrote:
>  	if (flags & MAP_FIXED) {
>  		/* Ok, don't mess with it. */
> -		return mm_get_unmapped_area(current->mm, NULL, orig_addr, len, pgoff, flags);
> +		return current_get_unmapped_area(NULL, orig_addr, len, pgoff, flags);

The old name seems preferable because it's not as crazy long.  In fact
just get_unmapped_area would be even better, but that's already taken
by something else.

Can we maybe take a step back and sort out the mess of the various
_get_unmapped_area helpers?

e.g. mm_get_unmapped_area_vmflags just wraps
arch_get_unmapped_area_topdown_vmflags and
arch_get_unmapped_area_vmflags, and we might as well merge all three
by moving the MMF_TOPDOWN into two actual implementations?

And then just update all the implementations to always pass the
vm_flags instead of having separate implementations with our without
the flags.

And then make __get_unmapped_area static in mmap.c nad move the
get_unmapped_area wrappers there.  And eventually write some
documentation for the functions based on the learnings who actually
uses what..

