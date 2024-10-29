Return-Path: <io-uring+bounces-4122-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B92069B4E10
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:34:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70CBD1F242DE
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7699190049;
	Tue, 29 Oct 2024 15:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LKMZcW8s"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6092BAF9;
	Tue, 29 Oct 2024 15:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730216050; cv=none; b=YumoSNY+RQeA1U7PSfEjgGKAc+xiesqdpWujA5K17VLh0bKPXc0A+ETdUiOxPpfsjhqaFKntq3qaS8++WA4jhIFKoKM4nf8YRGZneMFIAGR7Mt2kcMTZxrqiMMPwWlz36QK9yg186oIX4xue5s8SbgQdpdWo2nRgkwYCkDW754A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730216050; c=relaxed/simple;
	bh=xGZIo//+rd5EBLgfh1sz1cn7TPzNY0b3vgJcMFqWpsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BZcfYcfQ+cTMpmsQjdo24ievy9/Dttpue9WWV+fLJe0DfVvGBvFjMhbMWlnWPb+3SN1dokgLwpSTja7NPu11Ir1Xht6gGjg7oKPfwZsK5EZk8UkCEjKF3+GfP4bSkOME5ufwkZ/sNs4TGm35kjl/jd4P8oq+35PORYYyZivBx1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LKMZcW8s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A7DC4CECD;
	Tue, 29 Oct 2024 15:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730216050;
	bh=xGZIo//+rd5EBLgfh1sz1cn7TPzNY0b3vgJcMFqWpsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LKMZcW8sQFWxRSd3qgVIcjnTz4uwpTSxTNx15MUBFfRZkSQJ8Rl9WuB7YBxEPmV40
	 WHC02F4hb3r9/hQhfVTHnuuxWYFhfurX+RuGsUi1At+rmEmjj3mgKy82m1969vV9+1
	 F2HIjcPy6SNENoihV2/ZDUCcjFokBmMnl6Lb+IrYd+TwT+xcBhwCDhxyQ5Pn/ciHcZ
	 4IKjJZlFT31bKKU9bnR9ik3sf4d6QePkswE6uyo20RAnJHBWVVRN2fuN9Clmdp2Ri6
	 y6TFOHJPXLPx8FIeSFwRBvmM9yH/7H+b8Vy9f+JDF/v4Q8K9G6vVethOi/xt9oDq/S
	 QVWr2m9MGX6Mg==
Date: Tue, 29 Oct 2024 09:34:07 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <ZyEAb-zgvBlzZiaQ@kbusch-mbp>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241029151922.459139-10-kbusch@meta.com>
 <20241029152654.GC26431@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029152654.GC26431@lst.de>

On Tue, Oct 29, 2024 at 04:26:54PM +0100, Christoph Hellwig wrote:
> On Tue, Oct 29, 2024 at 08:19:22AM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > The block limits exports the number of write hints, so set this limit if
> > the device reports support for the lifetime hints. Not only does this
> > inform the user of which hints are possible, it also allows scsi devices
> > supporting the feature to utilize the full range through raw block
> > device direct-io.
> > 
> > Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Keith Busch <kbusch@kernel.org>
> 
> Despite the reviews this is still incorrect.  The permanent streams have
> a relative data temperature associated with them as pointed out last
> round and are not arbitrary write stream contexts despite (ab)using
> the SBC streams facilities.

So then don't use it that way? I still don't know what change you're
expecting to happen with this feedback. What do you want the kernel to
do differently here?

