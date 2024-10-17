Return-Path: <io-uring+bounces-3764-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B79F39A1CBB
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 10:12:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35A61B26578
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 08:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF481D172E;
	Thu, 17 Oct 2024 08:12:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6696C1C1AB1;
	Thu, 17 Oct 2024 08:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729152750; cv=none; b=a1GflhmyZLdGNOSlsyTyXLxpaymHWOvo8rzolGzQo+0pmraCj+wY7EHmedFw5rR5whFk2DWG44NoNqAOZ3TZ+T6qD9stQSwOjvS8HBTG97/xq0VK1ZafG21Ohy+akqJPldgO5I62OtsxiMOZiKkaitgHd+NvyAQAjRW6InfAmqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729152750; c=relaxed/simple;
	bh=4TldNJ9VBiUvGheIZBqqzqF/PH1EwQ8ZC2qgP+oYNf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iklroLQ7g8ZSa2cGyllV1dzrig2+Zr+58U40lvCm1bLdr1nidJMMVI19UACGLXp2AoJgr3JiNwrczS/Xza3yr5p2bGlXui9Zj+0dwKjoriCzHjCReX4Wsg5sxGdDQDcbydxpA4WBzKx4wXj1Ou6FmtRzlJM6llS8ku032sZDwYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E042D227A87; Thu, 17 Oct 2024 10:12:23 +0200 (CEST)
Date: Thu, 17 Oct 2024 10:12:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v4 08/11] block: introduce
 BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
Message-ID: <20241017081223.GB27241@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113750epcas5p2089e395ca764de023be64519da9b0982@epcas5p2.samsung.com> <20241016112912.63542-9-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016112912.63542-9-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 16, 2024 at 04:59:09PM +0530, Anuj Gupta wrote:
> This patch introduces BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags which
> indicate how the hardware should check the integrity payload. The
> driver can now just rely on block layer flags, and doesn't need to
> know the integrity source. Submitter of PI decides which tags to check.
> This would also give us a unified interface for user and kernel
> generated integrity.

The conversion of the existing logic looks good, but the BIP_CHECK_APPTAG
flag is completely unreferenced.


