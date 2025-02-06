Return-Path: <io-uring+bounces-6288-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E813A2AC70
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2025 16:28:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55A091884823
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2025 15:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600861EDA27;
	Thu,  6 Feb 2025 15:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aoc3SRQx"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EAE1C700E;
	Thu,  6 Feb 2025 15:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738855698; cv=none; b=DONuHZ1F/fPtW92PFIL/e+UvNjq8b+joz3H6mU4JJbwKLUenC50VrFjIcqOw2+0GAyo7rYdMkfLao2EAi5+nWl7gEsM5cvXchZSn4cDVTAoVFseX62aOQ/4v5MzVZ4n/3pOx+fI4pPLzQq8RshM4IZU9i5ix2+v0i7F2y0GfHPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738855698; c=relaxed/simple;
	bh=YFM96TimLftIQcPo7yQ5XjDyl/LRN+ingKQpzSWqN54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MzTSG84+WZpA7/lKpMZMVv2uF6jqCZg1DOqBrFfHV2dtnErR9zLx0T9Ln2m+sr58F0gMf6G6JcbIXrQi1WXj1/Z/0MAVo94WRWUTQKtS8Y3UWCbtSGVdPjeC014EWw1Dfr7UgPtpbAPXt0guBX2oDy4suzPAvI42iNId20Pv+1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aoc3SRQx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F37FC4CEDF;
	Thu,  6 Feb 2025 15:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738855697;
	bh=YFM96TimLftIQcPo7yQ5XjDyl/LRN+ingKQpzSWqN54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Aoc3SRQxDoRSE6HPqESrw5uUPbP/dFfZzgdx61UNOzn0rXYGl0Pgz50uirR5cVTVj
	 zSMB+4NRuHjckbwkBzU03ie/1kER4hbQxk77BlqlPS4JnOepLqJn7Ew6dAEK9W8GNk
	 G6UdBcQQF9da5m9kXrQP3hJloO4iZf6p5/Jn8IPnJkiZeMjYKum9iy+5bN1Ml91x0s
	 oGBkxvKWMEY/fL/gl+50GQsw2dZb+wxcJJAN0fC6M02wy0An2pynWHNb+pGDBj/y9C
	 +K6IspXohAhr+PQgmW7GHmceF2D49SXPXTcNPJN7Mi2MdHQlZnjsSRbYvo4uqkPNEB
	 zQnZjPOrqGG5w==
Date: Thu, 6 Feb 2025 08:28:15 -0700
From: Keith Busch <kbusch@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	ming.lei@redhat.com, axboe@kernel.dk, asml.silence@gmail.com
Subject: Re: [PATCH 0/6] ublk zero-copy support
Message-ID: <Z6TVD5KuRSQKsPVJ@kbusch-mbp>
References: <20250203154517.937623-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203154517.937623-1-kbusch@meta.com>

On Mon, Feb 03, 2025 at 07:45:11AM -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> This is a new look at supporting zero copy with ublk.

Just to give some numbers behind this since I didn't in the original
cover letter. The numbers are from a 1.6GHz Xeon platform.

Using the ublksrv patch I provided in the cover letter, created two ublk
block devices with null_blk backings:

  ublk add -t loop -f /dev/nullb0
  ublk add -t loop -f /dev/nullb1 -z

Using t/io_uring, comparing the ublk device without zero-copy vs the one
with zero-copy (-z) enabled

4k read:
 Legacy:
  IOPS=387.78K, BW=1514MiB/s, IOS/call=32/32
  IOPS=395.14K, BW=1543MiB/s, IOS/call=32/32
  IOPS=395.68K, BW=1545MiB/s, IOS/call=32/31

 Zero-copy:
  IOPS=482.69K, BW=1885MiB/s, IOS/call=32/31
  IOPS=481.34K, BW=1880MiB/s, IOS/call=32/32
  IOPS=481.66K, BW=1881MiB/s, IOS/call=32/32

64k read:
 Legacy:
  IOPS=73248, BW=4.58GiB/s, IOS/call=32/32
  IOPS=73664, BW=4.60GiB/s, IOS/call=32/32
  IOPS=72288, BW=4.52GiB/s, IOS/call=32/32

 Zero-copy:
  IOPS=381.76K, BW=23.86GiB/s, IOS/call=32/31
  IOPS=378.18K, BW=23.64GiB/s, IOS/call=32/32
  IOPS=379.52K, BW=23.72GiB/s, IOS/call=32/32

The register/unregister overhead is low enough to show a decent
improvement even at 4k IO. And it's using half the memory with lower CPU
utilization per IO, so all good wins.

