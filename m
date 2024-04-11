Return-Path: <io-uring+bounces-1510-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 971198A1C73
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 19:48:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B886E1C20F40
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 17:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B9C1A0AEC;
	Thu, 11 Apr 2024 16:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XIsGPPx3"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156CA1A0AE7;
	Thu, 11 Apr 2024 16:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712852604; cv=none; b=oQn7tJgrdFHQ3nqLFBhStEqjZ+u9YqToXIhcoCRtlmAxbBioEDFfAtXBbh9qpc1L0MAPgO2i9jJcbTk7a2AsNrT41MPabIZesFB+7qZV8FKqFnx2vJGq9J/swZM1uJt+7YJRWUqvBbK66Nia+B1YGPy56RwHGjGhJ8dE6kyG8uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712852604; c=relaxed/simple;
	bh=nN/Hr+UlT6emx/RUIJVSa74QG/O0VgJ/byKbQpUfmyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWVaNTMrArzwXpUAPHTmX9pqckVf8Y9iEtFipuXz7cMNaIXCIqHf/GgUa7hmk+GHQ4qVqOJ2dS/2zrRgt0iPNlEDUG7Xtxh9OW7yoVsaz55FTL2ANhPZ2NsqZAxdRf+HPKGhb+VaVxmAouLKeTQP8C3h/UcUXuKOQxqloIgOpy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XIsGPPx3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=w8fDcPBM4Ze2RPgrAoXs/w5z2M5QE6GW5bGItfgRyJ8=; b=XIsGPPx3mZgUgXDqmsW3zFEUMM
	hrAF6AwyKjg5u/7JpKuZqbRzY4v8HjoVwEuBNAQVw14POMEREkb9sOqKwAN3ZchA3+E1NH+q43G9i
	h89UzTlMT34ILaOSNIjqzh/1hopUZTMHNrak55UHbof7sc3viEOIyBCwxIJ6BThh3W7K7EUlGy4np
	TJb5EIRDb4TXgd7PW5tv8xQPgKoVmMRy+YgpCoXVAMMOQ9WQZGo/nl38Gs8Cc4AV4c2NEYmM7UFcA
	N6nfqhSWnnj5rSE7+/wwPBIg+h68sSddrjQYwRJvDbTOvqfFAn0OFruiNIfUzQl1/VooT2EV9uDuG
	6YpTaT4w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruxCN-0000000D38A-1CHz;
	Thu, 11 Apr 2024 16:22:51 +0000
Date: Thu, 11 Apr 2024 09:22:51 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Dan Helmick <dan.helmick@samsung.com>, axboe@kernel.dk,
	kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, djwong@kernel.org,
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
Message-ID: <ZhgOW8yBPuuae4ni@bombadil.infradead.org>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <20240326133813.3224593-11-john.g.garry@oracle.com>
 <Zhcu5m8fmwD1W5bG@bombadil.infradead.org>
 <143e3d55-773f-4fcb-889c-bb24c0acabba@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <143e3d55-773f-4fcb-889c-bb24c0acabba@oracle.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Thu, Apr 11, 2024 at 09:59:57AM +0100, John Garry wrote:
> On 11/04/2024 01:29, Luis Chamberlain wrote:
> > On Tue, Mar 26, 2024 at 01:38:13PM +0000, John Garry wrote:
> > > From: Alan Adamson <alan.adamson@oracle.com>
> > > 
> > > Add support to set block layer request_queue atomic write limits. The
> > > limits will be derived from either the namespace or controller atomic
> > > parameters.
> > > 
> > > NVMe atomic-related parameters are grouped into "normal" and "power-fail"
> > > (or PF) class of parameter. For atomic write support, only PF parameters
> > > are of interest. The "normal" parameters are concerned with racing reads
> > > and writes (which also applies to PF). See NVM Command Set Specification
> > > Revision 1.0d section 2.1.4 for reference.
> > > 
> > > Whether to use per namespace or controller atomic parameters is decided by
> > > NSFEAT bit 1 - see Figure 97: Identify – Identify Namespace Data
> > > Structure, NVM Command Set.
> > > 
> > > NVMe namespaces may define an atomic boundary, whereby no atomic guarantees
> > > are provided for a write which straddles this per-lba space boundary. The
> > > block layer merging policy is such that no merges may occur in which the
> > > resultant request would straddle such a boundary.
> > > 
> > > Unlike SCSI, NVMe specifies no granularity or alignment rules, apart from
> > > atomic boundary rule.
> > 
> > Larger IU drives a larger alignment *preference*, and it can be multiples
> > of the LBA format, it's called Namespace Preferred Write Granularity (NPWG)
> > and the NVMe driver already parses it. So say you have a 4k LBA format
> > but a 16k NPWG. I suspect this means we'd want atomics writes to align to 16k
> > but I can let Dan confirm.
> 
> If we need to be aligned to NPWG, then the min atomic write unit would also
> need to be NPWG. Any NPWG relation to atomic writes is not defined in the
> spec, AFAICS.

NPWG is just a preference, not a requirement, so it is different than
logical block size. As far as I can tell we have no block topology
information to represent it. LBS will help users opt-in to align to
the NPWG, and a respective NAWUPF will ensure you can also atomically
write the respective sector size.

For atomics, NABSPF is what we want to use.

The above statement on the commit log just seems a bit misleading then.

> We simply use the LBA data size as the min atomic unit in this patch.

I thought NABSPF is used.

> > > Note on NABSPF:
> > > There seems to be some vagueness in the spec as to whether NABSPF applies
> > > for NSFEAT bit 1 being unset. Figure 97 does not explicitly mention NABSPF
> > > and how it is affected by bit 1. However Figure 4 does tell to check Figure
> > > 97 for info about per-namespace parameters, which NABSPF is, so it is
> > > implied. However currently nvme_update_disk_info() does check namespace
> > > parameter NABO regardless of this bit.
> > 
> > Yeah that its quirky.
> > 
> > Also today we set the physical block size to min(npwg, atomic) and that
> > means for a today's average 4k IU drive if they get 16k atomic the
> > physical block size would still be 4k. As the physical block size in
> > practice can also lift the sector size filesystems used it would seem
> > odd only a larger npwg could lift it.
> It seems to me that if you want to provide atomic guarantees for this large
> "physical block size", then it needs to be based on (N)AWUPF and NPWG.

For atomicity, I read it as needing to use NABSPF. Aligning to NPWG will just
help performance.

The NPWG comes from an internal mapping table constructed and kept on
DRAM on a drive in units of an IU size [0], and so not aligning to the
IU just causes having to work with entries in the able rather than just
one, and also incurs a read-modify-write. Contrary to the logical block
size, a write below NPWG but respecting the logical block size is allowed,
its just not optimal.

[0] https://kernelnewbies.org/KernelProjects/large-block-size#Indirection_Unit_size_increases

  Luis

