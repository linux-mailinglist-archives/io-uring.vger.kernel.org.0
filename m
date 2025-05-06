Return-Path: <io-uring+bounces-7873-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21FCEAACAF2
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 18:28:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A3FE4A1E7A
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 16:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1C6D284B21;
	Tue,  6 May 2025 16:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gIhl+hDV"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38BA283FD9;
	Tue,  6 May 2025 16:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746548889; cv=none; b=EbBF2vkWCu1ASwjr/qN7REtFs/IZpEs5AVm7BKhh3amUCOWqbdMp1I0GfwHVRamNOcpdTQQb7s9ei7E7p/MFJv0AOkFgROz65F4aLycz/wd9ruRjmCqARjID2aeB84iraDqAkoNbPkZv0rvCQRGjPUHXcIquG2U0P1fiMvDBmoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746548889; c=relaxed/simple;
	bh=l+1Yy2LMZkqI2UGfxB7y8XrZgZuxgFkcvjxpPhz2zqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BhP2HLn15ScVnnfreByYMnlUqj709xx0XJ42YYPkJt/vKy/CIgQYBLs/bfoNHffeX18ADzw1E36XhNF0SNVvviKKsQ8NeKTN6bLwWIdARg1NimNnZArK9h1xD2GsDKyHzOyieL9KXGEBcdis/fBDmGYKTt3DY/xhRMrTBI/uziQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gIhl+hDV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDE0C4CEE4;
	Tue,  6 May 2025 16:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746548889;
	bh=l+1Yy2LMZkqI2UGfxB7y8XrZgZuxgFkcvjxpPhz2zqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gIhl+hDVvP+N5Eh4G9K1CizeYtMvMU01L+FIsjtrktrJ9Ebu4F7MtceO//hyZL4fp
	 7GFzJjO2G1GpkHuA6FzORzvdhaNP5QFyMBp+u507XpkQY81nxLtCYm/F7IZaiH+J9G
	 cK839Cfq48TW8EMmD4eK5euk5pRgJHXHV+jWypZlEL19olcTCZglL246EiwD8TAd/y
	 4J9v1IQ5MRD2iF0reTzV7Mw8FtLdQEZqqRP+mvl8DcDV3JMHG9qU19Z1EqAHVk8+lb
	 WCEap/Nrd6PDEHPo5sZruY3WjtxbfpnukLOiD3EXtcuNPIrVOJon5yV6rRxYCofZ/K
	 SSiqGymysJW/w==
Date: Tue, 6 May 2025 10:28:06 -0600
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
	asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH v16 11/11] nvme: use fdp streams if write stream is
 provided
Message-ID: <aBo4lkbeq1IU3RDU@kbusch-mbp.dhcp.thefacebook.com>
References: <CGME20250506122653epcas5p1824d4af64d0b599fde2de831d8ebf732@epcas5p1.samsung.com>
 <20250506121732.8211-1-joshi.k@samsung.com>
 <20250506121732.8211-12-joshi.k@samsung.com>
 <CADUfDZrWstGcx+EqsmaQvSJJrMAK-Ls+HtGyS8j3okZQ+N4FKQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADUfDZrWstGcx+EqsmaQvSJJrMAK-Ls+HtGyS8j3okZQ+N4FKQ@mail.gmail.com>

On Tue, May 06, 2025 at 09:14:19AM -0700, Caleb Sander Mateos wrote:
> > +       head->plids = kcalloc(head->nr_plids, sizeof(head->plids),
> > +                             GFP_KERNEL);
> 
> Should this be sizeof(*head->plids)?

Indeed it should. This as-is overallocates the array size, so wouldn't
have easily found it at runtime.

