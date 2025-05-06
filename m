Return-Path: <io-uring+bounces-7876-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C0D8AACDB5
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 21:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1627981D6E
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 19:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E53A613D531;
	Tue,  6 May 2025 19:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ASHKxj7c"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72A3523A;
	Tue,  6 May 2025 19:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746558209; cv=none; b=ow1UGvRe9/3t2ZOxzQjiaT2yeeAJP2tDvfk/zzjATPNbnmME3UQlx1/7fR85nBAAQBeMN1q+syIx0wbf687y9UwLiN8wDXTkuX3m8MMQMYYBximntQUrqcaYPP/ftr0HzU4lg36PsQIj2D7Ssec2Ree48r2jjpEl+EDv6ghdKi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746558209; c=relaxed/simple;
	bh=44pu7eUj4ufXPS2ZipmpBRbiPVL1b0+oi3A4kSLu/AQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/Kncd/ap4zxu5bEOn6XW4crQ0RLWQ8YmuzqBTYHGT4vGF6WQew5YtF5ckJBpwfXBwuTeagAY1maxbGWCGfKHTmDHlwB+4cCmG0N4qAVAxDggfZzmDtRGuefGZPQjcr0ci86yFN3+ZNuHN6J+hw0Rxk9HxgD4pUaA6/LW8vpI1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ASHKxj7c; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBD8C4CEE4;
	Tue,  6 May 2025 19:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746558209;
	bh=44pu7eUj4ufXPS2ZipmpBRbiPVL1b0+oi3A4kSLu/AQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ASHKxj7cvlUzwZFYOyy4+DgMlGHNXyr3RPltSBsJ8qRX+rwh0KbL34lvU6xCdh+x8
	 iAzeHf39m+LP+rNNG3dpdmBJxzHZoCIHRVvK3DEpm+aNBbB+zYXMajlz0j3XwJPV0R
	 be0uAeBet12HzhfKXghjUGRzSttFiC3WU5gjUF6Ak02WYJpAAYDF3w/TkzvWTRx401
	 1L+uyvxchRq+Ew9/Rf2Z1uo+79K0cfvdGC7GBkqC29GJUgt74NZphJnfHIqsgVBIMv
	 Z+Z4cw9uM6Nqkvqk3syx/iDhxpm3osSG7HLKARpfbgdQDM7eeIpbcJPGZ/JAmiCm4p
	 MH3fvFJax/K7A==
Date: Tue, 6 May 2025 13:03:25 -0600
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshiiitr@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
	asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH v16 10/11] nvme: register fdp parameters with the block
 layer
Message-ID: <aBpc_RX3HC_zSpaI@kbusch-mbp.dhcp.thefacebook.com>
References: <CGME20250506122651epcas5p4100fd5435ce6e6686318265b414c1176@epcas5p4.samsung.com>
 <20250506121732.8211-1-joshi.k@samsung.com>
 <20250506121732.8211-11-joshi.k@samsung.com>
 <CADUfDZqqqQVHqMpVaMWre1=GZfu42_SOQ5W9m0vhSZYyp1BBUA@mail.gmail.com>
 <aBo4OiOOY3tCh_02@kbusch-mbp.dhcp.thefacebook.com>
 <CA+1E3rJx3Ch2POT_t4DWiqb2nJiX7bHPrGVMW_ZviJ_b0o9UvQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+1E3rJx3Ch2POT_t4DWiqb2nJiX7bHPrGVMW_ZviJ_b0o9UvQ@mail.gmail.com>

On Tue, May 06, 2025 at 11:44:27PM +0530, Kanchan Joshi wrote:
> On Tue, May 6, 2025 at 9:56 PM Keith Busch <kbusch@kernel.org> wrote:
> >
> > You're right, should have been min. Because "runs" is a u64 and the
> > queue_limit is a u32, so U32_MAX is the upper limit, but it's not
> > supposed to exceed "runs".
> 
> Would it be better to change write_stream_granularity to "long
> unsigned int" so that it matches with what is possible in nvme?

That type is still 4 bytes on many 32-bit archs, but I know what you
mean (unsigned long long). I didn't think we'd see reclaim units
approach 4GB, but if you think it's possible, may as well have the
queue_limit type be large enough to report it.

