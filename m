Return-Path: <io-uring+bounces-1498-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67C258A04CB
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 02:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6B3B1F22BBC
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 00:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DDE0ECF;
	Thu, 11 Apr 2024 00:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E1FrgkpT"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3518A20;
	Thu, 11 Apr 2024 00:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712795377; cv=none; b=OjbnGUc+f+vM8EVsYeaBAnMKjESC3k9MprySx3Vlk8IfBrRO7vDiZtCQbTdFQYJ2SpVH9TunYiCWZr0yniy+hyBaUbJxnUX9rJCX6tSa+BPTTe3uVZ5jazTbzn8LBVEalJImyhfnOMvQDI26tx8yqsyjblbqhR0SJ8zdQdFhCBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712795377; c=relaxed/simple;
	bh=QdsQnt3txY9gDH2lxm3+740bKPbpAPbhqFo4MX60rg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fh07NAQ7bg3Bh/xf23baf5dar/XpKLH/3qjuNI3Eh/1pgnZoQ7tNj16BWiRakWH4O4MXiFYuRJkVHUa/TNyS2yQoupTANqQSfzUyAyy3zzSkzWc4hUt2aTe8A3EsAId+WAr/fcwd8mNqFC6JBp+aC0nRlP3wYXEZwef2EzHgb/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E1FrgkpT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=OEIc3BFOzXRSk9xarIrXi9oKkK8pwQS/Tvtu7+e+Hyc=; b=E1FrgkpTEZ/tmqWWQoF1YqWZ60
	poyZ7C2ZyE8mol0NdDa1wrg3P/YePSkGdrYySlPsVUTH81yL4K6Te7hCQEQeiYQK8qIj3UIYw8agA
	ayvfZ+XayHpqzFEmR/6CIqEgAOCGLl/HSLivl9TAk0FOaBqlcpKaLBJ6+GJYXItLRPuQAX6OFQW/h
	+QxlwFpdrGDCweYnoNOulSzX0RmvQCJaH/06G7wO+ViF0fp9ZarkXj+HyPYKvMcDVJ09dbmabHyq9
	jWl38gdjav7aAfRfTZN5KJcHKJo8sEBE/S4E3gg1T0RgasrhZlyY8vwgNKCr3nMIh5f7kE1vt0nei
	Eg9QFEbA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruiJi-00000009fsy-1o2Q;
	Thu, 11 Apr 2024 00:29:26 +0000
Date: Wed, 10 Apr 2024 17:29:26 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: John Garry <john.g.garry@oracle.com>,
	Dan Helmick <dan.helmick@samsung.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org,
	Alan Adamson <alan.adamson@oracle.com>
Subject: Re: [PATCH v6 10/10] nvme: Atomic write support
Message-ID: <Zhcu5m8fmwD1W5bG@bombadil.infradead.org>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <20240326133813.3224593-11-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240326133813.3224593-11-john.g.garry@oracle.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Tue, Mar 26, 2024 at 01:38:13PM +0000, John Garry wrote:
> From: Alan Adamson <alan.adamson@oracle.com>
> 
> Add support to set block layer request_queue atomic write limits. The
> limits will be derived from either the namespace or controller atomic
> parameters.
> 
> NVMe atomic-related parameters are grouped into "normal" and "power-fail"
> (or PF) class of parameter. For atomic write support, only PF parameters
> are of interest. The "normal" parameters are concerned with racing reads
> and writes (which also applies to PF). See NVM Command Set Specification
> Revision 1.0d section 2.1.4 for reference.
> 
> Whether to use per namespace or controller atomic parameters is decided by
> NSFEAT bit 1 - see Figure 97: Identify – Identify Namespace Data
> Structure, NVM Command Set.
> 
> NVMe namespaces may define an atomic boundary, whereby no atomic guarantees
> are provided for a write which straddles this per-lba space boundary. The
> block layer merging policy is such that no merges may occur in which the
> resultant request would straddle such a boundary.
> 
> Unlike SCSI, NVMe specifies no granularity or alignment rules, apart from
> atomic boundary rule.

Larger IU drives a larger alignment *preference*, and it can be multiples
of the LBA format, it's called Namespace Preferred Write Granularity (NPWG)
and the NVMe driver already parses it. So say you have a 4k LBA format
but a 16k NPWG. I suspect this means we'd want atomics writes to align to 16k
but I can let Dan confirm.

> Note on NABSPF:
> There seems to be some vagueness in the spec as to whether NABSPF applies
> for NSFEAT bit 1 being unset. Figure 97 does not explicitly mention NABSPF
> and how it is affected by bit 1. However Figure 4 does tell to check Figure
> 97 for info about per-namespace parameters, which NABSPF is, so it is
> implied. However currently nvme_update_disk_info() does check namespace
> parameter NABO regardless of this bit.

Yeah that its quirky.

Also today we set the physical block size to min(npwg, atomic) and that
means for a today's average 4k IU drive if they get 16k atomic the
physical block size would still be 4k. As the physical block size in
practice can also lift the sector size filesystems used it would seem
odd only a larger npwg could lift it. So we may want to revisit this
eventually, specially if we have an API to do atomics properly across the
block layer.

  Luis

