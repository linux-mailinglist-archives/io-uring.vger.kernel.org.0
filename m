Return-Path: <io-uring+bounces-5235-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 182AD9E43C7
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 19:53:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD8AD288AD3
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4A271B81B2;
	Wed,  4 Dec 2024 18:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iZZGSebo"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FF726AC1;
	Wed,  4 Dec 2024 18:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733338291; cv=none; b=r5XHcm5SNcYAgMFVYowD+4U5Yf28Jhzc902JFGKpNc5/+I774qqz+Mn4RMCAorWiOPPlRMjareDR2pkNNnAldXbDgSwzb7ABKC0jos1BEmQ1LAFQldWRZvI/kaNIg6oflPFQepkPExu2kH1nhRYt1F3mOcqfWquEX2uRWEUIANY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733338291; c=relaxed/simple;
	bh=l9Gq4VrWql6pFYa/zpV4swTzVUCQHgcZyumww0xkHz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j7Jn+cPAkqidpvnzEi6JbuErho6uFoQbcls3gkf4V+9//xn1NnTFKwRNVACHafX+2OucS5KyNBzhSJzX6QUUNwBsW2TOFbFbUfyt5n2wkE5AE2RKWHyZVX3KRGu5S3/QdegSNGKok1viVHv0/daUuSf89LuhICO/eZQxKrImHyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iZZGSebo; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gzwaDKFITa3a1kTuMDLUi8RHqXoRF8SnJ574ygIwsd8=; b=iZZGSeboGs336wLmOOqXq+foP+
	nAGvWZZ+SPmzamZr8qKmSDivHHisRlQa2H+KQPjwIRJLsX7JdQMiS/CDOBE7U/g7Ti4GJKrbjPNlb
	oS4d94OeCdyOm1vcyKt3uoY63qF0oCAYsVgs7HjrdUcZVxcjzc05gKIyj9tHwOxk/5i/FI9icc7XJ
	v+MW324n61ZHgRmXDo/39K9ECJsUKMJNmd+kdQFCkxlvJ6DfKSn9bjpEuRYofCnMR65WDqjMHbP+c
	s0zoZY/AixFtSfsgH+8KCw1jQaICZPXV0LynPTnRMp3MY/EvJL0rfcJGyuzx6qstLCQ8PsAtr+vOi
	LASG/mfg==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tIuT8-0000000BocF-1oSK;
	Wed, 04 Dec 2024 18:51:26 +0000
Date: Wed, 4 Dec 2024 18:51:26 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Tamir Duberstein <tamird@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot <syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com>,
	asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Write in
 sys_io_uring_register
Message-ID: <Z1Ckrl-gC3HpPj0W@casper.infradead.org>
References: <67505f88.050a0220.17bd51.0069.GAE@google.com>
 <6be84787-b1d9-4a20-85f3-34d8d9a0d492@kernel.dk>
 <a41eb55f-01b3-4388-a98c-cc0de15179bd@kernel.dk>
 <CAJ-ks9kN_qddZ3Ne5d=cADu5POC1rHd4rQcbVSD_spnZOrLLZg@mail.gmail.com>
 <1ab4e254-0254-4089-888b-2ec2ce152302@kernel.dk>
 <Z1CCbyZVOXQRDz_2@casper.infradead.org>
 <CAJ-ks9k5BZ1eSezMZX2oRT8JbNDra1-PoFa+dWnboW_kT4d11A@mail.gmail.com>
 <CAJ-ks9mfswrDNPjbakUsEtCTY-GbEoOGkOCrfAymDbDvUFgz5g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ-ks9mfswrDNPjbakUsEtCTY-GbEoOGkOCrfAymDbDvUFgz5g@mail.gmail.com>

On Wed, Dec 04, 2024 at 01:39:37PM -0500, Tamir Duberstein wrote:
> > I thought I did, but when I ran it again just now, this test did catch
> > it. So there is coverage.
> 
> Matthew, would you consider a patch that migrates the xarray tests to kunit?

how would that help?  it's already a kernel module as well as being a
userspace testsuite.  kunit just seemed to add useless boilerplate last
tie i looked.

