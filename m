Return-Path: <io-uring+bounces-1563-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA1E8A5CCE
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 23:18:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80E841F2029D
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 21:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EAE8156974;
	Mon, 15 Apr 2024 21:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k1gFawta"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88FB25601;
	Mon, 15 Apr 2024 21:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713215927; cv=none; b=ICTQH6RfwE2lrHU1YC78CNwH2tyXc6TcI5yoAZJ4al6LTbWtVc+c+phf2lpWiZMqK8H2EDHsdamrK8Hao3GDXPl8UKKPjFX3dsj4ke6z+gYlxN6hMoemVBK7W7n8Fo4WKd5Gov/ldS6CKXN0CAUDFVroLoAar/k/wfD2I+twvjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713215927; c=relaxed/simple;
	bh=EIMA/Lom4s4J3a8zeR2nuXbkOuAimmCY/e6T8tXxKbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QAQZfdA0ESSUJFjI7K/EXmRtYcSbObQnArbvU+QX8aZ14ZxoE2f+/vX5boEtGipBI2AfrurQfNggeUsV6Rp+maAQ+OiSnJJXyDvN0VUYRTf98YUcRl4UNKrgSChZ/lVjzQ+xq/hv5Jcdp/7seK/kGTHtIq4cdsfEME5gp+lsSnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k1gFawta; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oq3OSv09Zcq3l/SCWQSioSa37PYcwwKSz6uiDlE9w/E=; b=k1gFawtalSNyx93OW2ft4AbbZm
	mL+127agePKR7DWE1EgzM8K2Sdu0btd1XQeD8Wzl2tmTNdgWmn92sRrCehFh8u/+qHAagyvQyrV+I
	wglcZ0HQmPiryp3ay1AfYi9TzgEYQTdT7rPBLPlWeJzkacLKZXrdbwV9HsWzpaSjGI3Si8Mpfr2S0
	0hiTTpWQOGyNpghwLESRQBYRaWfsk2cg6KJWgLE1zDszdu8yt8sfPIvBeNWyhWxqIe1CYWPFC33pc
	4OQTnxL2Sln3ZByHLOn89dz27uUzxYSHVKBEuo/ChmtRraFlSsjkqf650IGawzGSeX5oHG74Pa4Vl
	djp37vKQ==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwTig-0000000GWYM-3AgF;
	Mon, 15 Apr 2024 21:18:30 +0000
Date: Mon, 15 Apr 2024 22:18:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>,
	axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com
Subject: Re: [PATCH v6 00/10] block atomic writes
Message-ID: <Zh2ZptLxnwa_jtSk@casper.infradead.org>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
 <c4c0dad5-41a4-44b4-8f40-2a250571180b@oracle.com>
 <Zg7Z4aJtn3SxY5w1@casper.infradead.org>
 <f3c1d321-0dfc-466f-9f6a-fe2f0513d944@oracle.com>
 <ZhQud1NbO4aMt0MH@bombadil.infradead.org>
 <ZhYQANQATz82ytl1@casper.infradead.org>
 <ZhxBiLSHuW35aoLB@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhxBiLSHuW35aoLB@bombadil.infradead.org>

On Sun, Apr 14, 2024 at 01:50:16PM -0700, Luis Chamberlain wrote:
> On Wed, Apr 10, 2024 at 05:05:20AM +0100, Matthew Wilcox wrote:
> > Have you tried just using the buffer_head code?  I think you heard bad
> > advice at last LSFMM.  Since then I've landed a bunch of patches which
> > remove PAGE_SIZE assumptions throughout the buffer_head code, and while
> > I haven't tried it, it might work.  And it might be easier to make work
> > than adding more BH hacks to the iomap code.
> 
> I have considered it but the issue is that *may work* isn't good enough and
> without a test plan for buffer-heads on a real filesystem this may never
> suffice. Addressing a buffere-head iomap compat for the block device cache
> is less error prone here for now.

Is it really your position that testing the code I already wrote is
harder than writing and testing some entirely new code?  Surely the
tests are the same for both.

Besides, we aren't talking about a filesystem on top of the bdev here.
We're talking about accessing the bdev's page cache directly.

