Return-Path: <io-uring+bounces-4124-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46E4E9B4E38
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA53DB22323
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F18A194A63;
	Tue, 29 Oct 2024 15:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nOFAkX4N"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCA01922FA;
	Tue, 29 Oct 2024 15:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730216328; cv=none; b=RG02Ao7fsrYbBQQNxkHFSyaEXj8X441n5kRWHPZ1FxlAPx5ScBZ9nIwnTiXriIwK8v1eg4C5F9vKnqmtLYOE0uiz+z+rpERdR+dAW+Zn6tK6Lp0G70+M9u7ihyS18pirNviJj7QNWN+Jcxnex8job+mpmKE/6eTw2cYHQKkTBr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730216328; c=relaxed/simple;
	bh=sXQtAmjaRkJY/tMHB3LMtb+TU/s2sXJm8psXkmJttmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/b8KTPomdtDOEJSR1snCcPAf7Chs/lWddGh1GFZj2mPwZKwap+iMWoUMwuF8KIc5NJK8PLPQjaPHKV0ZF/FwLqRvfQl9ILhWo6YfeYleGByruk6yMxTzD5TUGL7HO2GvtsOcXvsD4IU/RZm+hJ8Dbjhmcaqe2PQ8kenoyJ9IGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nOFAkX4N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1287DC4CECD;
	Tue, 29 Oct 2024 15:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730216327;
	bh=sXQtAmjaRkJY/tMHB3LMtb+TU/s2sXJm8psXkmJttmQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nOFAkX4N8peSxGFTiKARoXGk8lIlrqPHSIHgtZvmxpCuHZQ7Wb/jrxA6nfyscj/nI
	 XF9iVuZh6jQxKRCIleVbMYQ5x2+tECaPwiaqLwl6tqHjkD37GALGQtuS0jXC8BJ5J1
	 6KKUWAy8SNR50r6VVVOjXWcBqBSW22594PWuQJYSTUrN9yyatlymsV7T8pmJMFzoyK
	 lpKc1RaOm78+UvO/8xf9yhgehdlGn0WbbpFBgHO+KSpnoSzMpOujXf1qDaSPBmZEfw
	 yatwrJZqfQurKzhw1M0l/ddZL0Xf9xs3YJw8pLegbrigBevP1F7/QkkpkZERt+9FrI
	 WsJuzYsYaUEGg==
Date: Tue, 29 Oct 2024 09:38:44 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <ZyEBhOoDHKJs4EEY@kbusch-mbp>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241029151922.459139-10-kbusch@meta.com>
 <20241029152654.GC26431@lst.de>
 <ZyEAb-zgvBlzZiaQ@kbusch-mbp>
 <20241029153702.GA27545@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029153702.GA27545@lst.de>

On Tue, Oct 29, 2024 at 04:37:02PM +0100, Christoph Hellwig wrote:
> On Tue, Oct 29, 2024 at 09:34:07AM -0600, Keith Busch wrote:
> > So then don't use it that way? I still don't know what change you're
> > expecting to happen with this feedback. What do you want the kernel to
> > do differently here?
> 
> Same as before:  don't expose them as write streams, because they
> aren't.  A big mess in this series going back to the versions before
> your involvement is that they somehow want to tie up the temperature
> hints with the stream separation, which just ends up very messy.

They're not exposed as write streams. Patch 7/9 sets the feature if it
is a placement id or not, and only nvme sets it, so scsi's attributes
are not claiming to be a write stream.

