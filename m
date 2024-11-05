Return-Path: <io-uring+bounces-4458-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68EE29BD100
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 16:50:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AC061C21781
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 15:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F97013AD0F;
	Tue,  5 Nov 2024 15:50:20 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C95824BD;
	Tue,  5 Nov 2024 15:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730821820; cv=none; b=a7ZJoJCibRI2aZkTPkI7/qW/1vZPYySe3xtYL6fY33VXlTy3p3RZDlHSH/w+QEAdtKTxisLJY6V9kzVScebg5x6BYeE8TbjxU1s5guP3ZhaGcILgiU+noxTrcBeWJEblXEaICgDbGzz96CKp1ZQ+jAkMJeSQrhhJ8LJhSpJ7+Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730821820; c=relaxed/simple;
	bh=pAwXvMqJ49Rv70T2urpg5PJVVoIYtvl2V1GYBvvN7e0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FpD6qWQcbdpF2VE8Y7ilwIxt4FdnRIT+ZfVKQkUHwlhnmashFJd0xa4cSRlRpemeVubB6++KqhH2VXG9owgQV6AGjQiFka1i9kUrzCSlc0hQyfLRBrhQemq3z6vDtG9IFfV/vZaTLrTXvCR6jF0snzbXrPPOli12o6Im20y0aWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 933F3227AAC; Tue,  5 Nov 2024 16:50:14 +0100 (CET)
Date: Tue, 5 Nov 2024 16:50:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@lst.de, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241105155014.GA7310@lst.de>
References: <20241029151922.459139-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029151922.459139-1-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

I've pushed my branch that tries to make this work with the XFS
data separation here:

http://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xfs-zoned-streams

This is basically my current WIP xfs zoned (aka always write out place)
work optimistically destined for 6.14 + the patch set in this thread +
a little fix to make it work for nvme-multipath plus the tiny patch to
wire it up.

The good news is that the API from Keith mostly works.  I don't really
know how to cope with the streams per partition bitmap, and I suspect
this will need to be dealt with a bit better.  One option might be
to always have a bitmap, which would also support discontiguous
write stream numbers as actually supported by the underlying NVMe
implementation, another option would be to always map to consecutive
numbers.

The bad news is that for file systems or applications to make full use
of the API we also really need an API to expose how much space is left
in a write stream, as otherwise they can easily get out of sync on
a power fail.  I've left that code in as a TODO, it should not affect
basic testing.

We get the same kind of performance numbers as the ZNS support on
comparable hardware platforms, which is expected.  Testing on an
actual state of the art non-prototype hardware will take more time
as the capacities are big enough that getting serious numbers will
take a lot more time.


