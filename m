Return-Path: <io-uring+bounces-3669-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CFA5C99D5C0
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 19:44:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 829C31F231BD
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 17:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537111AC45F;
	Mon, 14 Oct 2024 17:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="HDjajkp3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="m7vWbXmB"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80387134BD;
	Mon, 14 Oct 2024 17:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728927895; cv=none; b=QioYBVq456Oqx5ZnSJd/Ib7z70iK5XAGhPRgZMoBauDOT/5Kf+ap18WU4Ls6hPwQFIPmvAEY2lDK7m5iEbX+YM82KJw1hri1K695hhKMPjrDxf+yBt0IwVARWNXzKVdjE0aNXnk8hvMr7PSL7lP/mO2kDNSmKW0DY/CLIBF6Oxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728927895; c=relaxed/simple;
	bh=4rVEHlnOEH1j1Wbqr+X0wuROEA22IXIsouNQf7swzM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MjMwAmJexmf/5u2YatKesFGG/983fINMkpxFq6+oH4UlUnB3HLDIllyJexj/kYZgJpU7ExZImYgF5koWZQRjtrmBH/FBQ/7THLF+LCaE+et/Z/84Hz3dWZMCN8RRtpVxBCFMh36rUFJLebtIVjjpa1nr9mEAB/hBAIK3LKBca4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=HDjajkp3; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=m7vWbXmB; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 87B8A1140077;
	Mon, 14 Oct 2024 13:44:52 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 14 Oct 2024 13:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1728927892; x=1729014292; bh=PmV9rYdNp5
	gLq4TSZAoXs0MQXxexlHlec4t2lqiW5Dc=; b=HDjajkp3Q4LcDXEQJ1JOWMDI7h
	zn37bYzrs79J2JDlzB0QbUb9mb/Gqe5E4nAjEUn8OTVLh7G2sv0YhVjdbNpn2g/2
	/w6MxpJVDDVPEyzJubJsuY6gPOWS97DeATHX4AqoXN8pFrZe2K5ezFoTKdTK4rVF
	pXe8q8ZlhtdVMs/CcQt3MAaudqyd7fnz7JkE54Z2YTJsn6Cgla7bw+7FLRpFIUOW
	ZwvWBQOpjz0hseSh5Yu7qTHLliS7N4LFdS+yXnNxGIuNMPC40rCWLXLwj9x12xBe
	+sstZSwdNBGad0c9TG2Be9RBDCCs16oBpsUbwvscrWoQyIvGDlGZB/4JaSMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1728927892; x=1729014292; bh=PmV9rYdNp5gLq4TSZAoXs0MQXxex
	lHlec4t2lqiW5Dc=; b=m7vWbXmBW+6BjgtmvS+Mzd42SjRYswOWd9VwJ7UHOcmF
	zHDW0zk/piT87iDYYIEQGgjr+rEpHR+dVwdIEsFveeLtqz6ZF5K26Gg4nYOPAH76
	jcl9vmfbjnzLGUky7hvzYSJyn6sI6avODYTK5eld2ZY9x/Nu46NbjI8z9qRwdwlL
	TYQMm3wNSRoY//Wqxh3OL+7pXaWNNbhJrETK6wnqMyag3fA23apnnW7cOA09MhV8
	v4DKvGG/JE7r0SYqpiYopxXkQZIrGh8lTmh7cP8Rl/lK3sB8tV7Tr55IlDp0nviX
	pFdyDPBUDV+T9Id8x2ySueBspnelMRj5zNkr2fSsaA==
X-ME-Sender: <xms:lFgNZ067CPiJOimXUGWrcNrlaScDwoatPLfmNlXHy-EgpCM5q0O_8w>
    <xme:lFgNZ17w3QtKTAPlLzCoo9cw4jjsH3E6dZGUSHc-qadrBkXvUuV2SP76zjFdjeBx7
    upE_3_j77iXJxerwsY>
X-ME-Received: <xmr:lFgNZzckfIVMO11vHHdQ8jtrruHaeg6eyYOGI9dp-N6WKeIeAbYqlz_iomMk_uDud_rQ8yLYEsPZC4IZ85Nn9xOF-nI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdeghedgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddv
    necuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqne
    cuggftrfgrthhtvghrnhepkedvkeffjeellefhveehvdejudfhjedthfdvveeiieeiudfg
    uefgtdejgfefleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeefpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehmrghhrghrmhhsthhonhgvsehfsgdrtghomhdprh
    gtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:lFgNZ5JB_Lem43T3S_Mwm5PevlX7GmMOEXd9w_XBam7Jehy0COpQzg>
    <xmx:lFgNZ4LbLEQX6WjJiJpPW_fCEBZ3fpp0IgJa5avGnotdjwsCEa1aZg>
    <xmx:lFgNZ6zeDu0Sct8PXM32jhta53nRKTCYL5xE5abZ12BcAQZdM3PI8A>
    <xmx:lFgNZ8LokCw_oTv0VuPrOgpZmtUNDNkiVRHD5A3lFxnDfQbIXOhfng>
    <xmx:lFgNZ83tu7Pm2JD-gi0j0qUjgZX3eMtE-0DPDuFHwwGtzbnV7seHoN0Z>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Oct 2024 13:44:51 -0400 (EDT)
Date: Mon, 14 Oct 2024 10:44:31 -0700
From: Boris Burkov <boris@bur.io>
To: Mark Harmstone <maharmstone@fb.com>
Cc: linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v3 0/5] btrfs: encoded reads via io_uring
Message-ID: <20241014174431.GA879246@zen.localdomain>
References: <20241014171838.304953-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014171838.304953-1-maharmstone@fb.com>

On Mon, Oct 14, 2024 at 06:18:22PM +0100, Mark Harmstone wrote:
> This is a re-do of my previous patchsets: I wasn't happy with how
> synchronous the previous version was in many ways, nor quite how badly
> it butchered the existing ioctl.
> 
> This adds an io_uring cmd to btrfs to match the behaviour of the
> existing BTRFS_IOC_ENCODED_READ ioctl, which allows the reading of
> potentially compressed extents directly from the disk.
> 
> Pavel mentioned on the previous patches whether we definitely need to
> keep the inode and the extent locked while doing I/O; I think the answer
> is probably yes, a) to prevent races with no-COW extents, and b) to
> prevent the extent from being deallocated from under us. But I think
> it's possible to resolve this, as a future optimization.

What branch is this based off of? I attempted to apply it to the current
btrfs for-next and
"btrfs: change btrfs_encoded_read_regular_fill_pages to take a callback"
did not apply cleanly.

> 
> Mark Harmstone (5):
>   btrfs: remove pointless addition in btrfs_encoded_read
>   btrfs: change btrfs_encoded_read_regular_fill_pages to take a callback
>   btrfs: change btrfs_encoded_read so that reading of extent is done by
>     caller
>   btrfs: add nowait parameter to btrfs_encoded_read
>   btrfs: add io_uring command for encoded reads
> 
>  fs/btrfs/btrfs_inode.h |  23 ++-
>  fs/btrfs/file.c        |   1 +
>  fs/btrfs/inode.c       | 186 ++++++++++++++++--------
>  fs/btrfs/ioctl.c       | 316 ++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/ioctl.h       |   1 +
>  fs/btrfs/send.c        |  15 +-
>  6 files changed, 476 insertions(+), 66 deletions(-)
> 
> -- 
> 2.44.2
> 

