Return-Path: <io-uring+bounces-3781-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC8479A253A
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 16:37:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 645C51F2307E
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 14:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A0BA1DDC1D;
	Thu, 17 Oct 2024 14:37:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C851DDC0C;
	Thu, 17 Oct 2024 14:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729175828; cv=none; b=frJmUt8MIANwLgWDzBE91TOhBvDpPeu+hCeDtJHYHpXseEueHLpwOhycOQydI8NQTJotfTXaj2iJ8md/kM5qrRzPmTQsefNkCS6YFZwFC3u2YtUKwBFxKni2v0UpXon3WthcLQ9JxFM9bJJzjVwW6FEQhT2VsAjduIrIMUqTfL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729175828; c=relaxed/simple;
	bh=oAD6jcl5h5s72DdkijnT1cyHuGb1B6GX3PJBfs6ht+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YqIlTVHUwQiJIXo5c1rB7fQdSxGb8pR7WPU0nedc0EHwOvTMTcudSRMm9a4Dxc2rTiriNtuwHWnafAcziCGCfUElMMqOWbf38qTNIV5L5pMcLqtmd0rUXwOy+bwVqsK5eOuqKDCsLCwRL/lUvduepW76azWmw2/92GmgAEhrYY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1E4BB227AAA; Thu, 17 Oct 2024 16:37:02 +0200 (CEST)
Date: Thu, 17 Oct 2024 16:37:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v4 08/11] block: introduce
 BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
Message-ID: <20241017143701.GB21905@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113750epcas5p2089e395ca764de023be64519da9b0982@epcas5p2.samsung.com> <20241016112912.63542-9-anuj20.g@samsung.com> <20241017081223.GB27241@lst.de> <20241017104613.GB1885@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017104613.GB1885@green245>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 17, 2024 at 04:16:13PM +0530, Anuj Gupta wrote:
> On Thu, Oct 17, 2024 at 10:12:23AM +0200, Christoph Hellwig wrote:
> > On Wed, Oct 16, 2024 at 04:59:09PM +0530, Anuj Gupta wrote:
> > > This patch introduces BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags which
> > > indicate how the hardware should check the integrity payload. The
> > > driver can now just rely on block layer flags, and doesn't need to
> > > know the integrity source. Submitter of PI decides which tags to check.
> > > This would also give us a unified interface for user and kernel
> > > generated integrity.
> > 
> > The conversion of the existing logic looks good, but the BIP_CHECK_APPTAG
> > flag is completely unreferenced.
> 
> It's being used by the nvme and scsi patch later. Should I introduce this
> flag later in either nvme or scsi patch where we actually use it.

Maybe a separate one?  Or at least very clearly state that the other two
are conversion of the existing semantics, while this one is new.


