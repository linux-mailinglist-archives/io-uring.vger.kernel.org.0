Return-Path: <io-uring+bounces-10531-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D0DC51272
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 09:43:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B97C1891BE5
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 08:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D471A2F39A1;
	Wed, 12 Nov 2025 08:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MV9dyKuN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C1A1F2380;
	Wed, 12 Nov 2025 08:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762936991; cv=none; b=iXC+OexdlOJAD2qCSTRt2/QR+/xG8pFgQwXnbBMLExNJT/ud7dcWgdb0MhQKfn2jXS0Eej6JFDv752kyn3e+5IskFl+lJzLc+E7DhaYbDCdblGplrToi5n9dpa0QGH33K3R4KOGW5sGHwaznynFVb62LupQhjIkzmdshQYOrHRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762936991; c=relaxed/simple;
	bh=/LczoiltHHVY6BkCv9TZVd8sVoWtwDEUK3HjIAwFlwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EqT2jeA0OydNPXoYgUimykSHx7ZMx0kZajUAnQ0EZonMfgJ23/7xmWmAzGmc5baB3cpgCu46rwDzVuP2pcUn7v2zd6U/7TpSclJVgaWs0cshgGbg+ldnfhzpciGZb1ysRmec60TbeQAHSo92NnPVAgRq84Qh85T1v7CuddGTds4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MV9dyKuN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6DBC4CEF5;
	Wed, 12 Nov 2025 08:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762936989;
	bh=/LczoiltHHVY6BkCv9TZVd8sVoWtwDEUK3HjIAwFlwU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MV9dyKuNGr0RyS1A32gUCODKaSsjbECo8tbz5ZuCyw2R9pYGU0+Kbo3BujT3URIMQ
	 WhorLU3/ctmiM10PjyJHG2Rb/1KhcRL+j4oZrwzI4lPL2tlGvpzRUR7tyhYRPD84fv
	 1gkFDp5J17d1nWFsEq6JoWQGMn0x2JIyTZHue6uIXS1dOwLbd1Udb1gjJ7yJb8dk+w
	 Yw9aRbRVBOvpXN6Vl5ih5+uQDZdi/OZ3PT6chK094k/JF7NcLa1/glLAA0+DV7KToC
	 gSk5UCURFAkLkqN6+zxF0vJj6QAM/aYImAUEsMYZHq8ObH9YS9gw/EiqcKzrLjyBmJ
	 fz5LHOPOU8Jrg==
Message-ID: <8c957ed5-ce4e-4207-8757-47b8ac168832@kernel.org>
Date: Wed, 12 Nov 2025 17:43:05 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: enable iomap dio write completions from interrupt context
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
 Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20251112072214.844816-1-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251112072214.844816-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/12/25 16:21, Christoph Hellwig wrote:
> Hi all,
> 
> Currently iomap defers all write completions to interrupt context.  This
> was based on my assumption that no one cares about the latency of those
> to simplify the code vs the old direct-io.c.  It turns out someone cared,
> as Avi reported a lot of context switches with ScyllaDB, which at least
> in older kernels with workqueue scheduling issues caused really high
> tail latencies.
> 
> Fortunately allowing the direct completions is pretty easy with all the
> other iomap changes we had since.
> 
> While doing this I've also found dead code which gets removed (patch 1)
> and an incorrect assumption in zonefs that read completions are called
> in user context, which it assumes for it's error handling.  Fix this by
> always calling error completions from user context (patch 2).
> 
> Against the vfs/vfs-6.19.iomap branch.
> 
> Diffstat:
>  Documentation/filesystems/iomap/operations.rst |    4 
>  fs/backing-file.c                              |    6 -
>  fs/iomap/direct-io.c                           |  149 +++++++++++--------------
>  include/linux/fs.h                             |   43 +------
>  io_uring/rw.c                                  |   16 --
>  5 files changed, 81 insertions(+), 137 deletions(-)

Where is the zonefs change ? Missing a patch ?


-- 
Damien Le Moal
Western Digital Research

