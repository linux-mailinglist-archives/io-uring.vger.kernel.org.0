Return-Path: <io-uring+bounces-4059-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B7B9B2F37
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 12:50:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5485A1C217C7
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 11:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0841D9323;
	Mon, 28 Oct 2024 11:49:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCA41D88AC;
	Mon, 28 Oct 2024 11:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730116170; cv=none; b=KoMRZYOKdBkZLeW/qxrR9Nj15WCpOgIKofOo5EDp/7lHeE3JzRupZemRX50SRwAAQAL6jFiP4bJkK3AB5HagvSNgOsd0McFkcrSpCZyxcfBHpJL94NHLK2oRoKVGHKA1s7DA106EGsrx6hEvQYmRnO7tY7jPV89saxQ2t02lu/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730116170; c=relaxed/simple;
	bh=cVr1zCxn+ptAwIL7+9G7zhkffSyWIQhNmVEyPEbb+VI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qUxx+Yq/EUt9rxJuMRpivornq3rTkICEo8RmEH+pXDvk1eH4UJAe+ni7SG015VN0eQosx+Jf+TVDVckxfR6G1UWdvSIH5Lww7YxIcw0SXcZ+lkFOhkldn1GvSItMm1xDhqU582zCLtkco+o4HSPT54whLyHIgmumk4C51f0hHyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 09616227A88; Mon, 28 Oct 2024 12:49:16 +0100 (CET)
Date: Mon, 28 Oct 2024 12:49:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@lst.de, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv9 0/7] write hints with nvme fdp, scsi streams
Message-ID: <20241028114913.GA8517@lst.de>
References: <20241025213645.3464331-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025213645.3464331-1-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 25, 2024 at 02:36:38PM -0700, Keith Busch wrote:
> Upfront, I really didn't get the feedback about setting different flags
> for stream vs. temperature support. Who wants to use it, and where and
> how is that information used?

The SBC permanent streams have a 'relative lifetime' associated with
them.  So if you expose them as plain write streams you violate the
contract with the device.

