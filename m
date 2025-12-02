Return-Path: <io-uring+bounces-10892-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 20029C9CC0D
	for <lists+io-uring@lfdr.de>; Tue, 02 Dec 2025 20:23:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8D55C34AC40
	for <lists+io-uring@lfdr.de>; Tue,  2 Dec 2025 19:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 081EA2DC345;
	Tue,  2 Dec 2025 19:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gHejWwrM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F07270557;
	Tue,  2 Dec 2025 19:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764703388; cv=none; b=GeU6u5bsdkNCrnWqTqD+qt/3lIeyd+rN5Ux8NVbxd1KC3BhgqMWvv6gpN+r+Wd9rcCkbRNDY1a2nT+6umJ1S2HpkpK0PmNcrwvdK52weA9a9Fq+te/iab+jARbQHWGB+6J2oiXdYpkKfVQURMvnVnYAEFWf4m/gnBKK+Xk/Fnsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764703388; c=relaxed/simple;
	bh=EGyOpohOwzTtiUd+9I5sQQAC0CR9xpQG9+BZRONdd2U=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=W6FKrS+zMV5J29msIkxsdKpcmSYR5M8dhCVKpxX7NZwz0p7xAsn0SXHCm2KzK5LFTPYgAr2cLHqTD7B3uiNnGg8a/5OfCDmvrWoeSci+ECbU9khIxIoqSMDXJ2i8p7bXDeL3Ztb63+HC5fUWua6+IX4CAm29rf9Gdqn03rUClVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gHejWwrM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626F2C4CEF1;
	Tue,  2 Dec 2025 19:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764703388;
	bh=EGyOpohOwzTtiUd+9I5sQQAC0CR9xpQG9+BZRONdd2U=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=gHejWwrMmIeQ0nCCnyCC9FuC2DvU1D4lE7+z89YDlMbEfLFvdtDJlycerGtrLDwt0
	 pGV3v5+mtWw30cdk9ILkHc39QdEhdV1zyDFv0P6dX6TYDetEv8G1v/WoZQbTaaqzdh
	 qbjkcRPIhFURD5oLguINbj0iTIM5nxpH+mVlkZg9NZhLLJTW3iwhfCZvw2eXr88IQt
	 8dSll7bCXbYvwyM+RsPfKHqDZ3VUYnOHIixQfeAG0KoZEaiufDGYlr9qJhl8DzqW8f
	 zua63E6DjXYdxszi2Uuoeq98s0wK1nc1hq5z3hAfh63KXKOThPLXeH8S8WOnf/rv8I
	 UwTdj1rJEVMyg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F29CF3A54A3B;
	Tue,  2 Dec 2025 19:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v7 0/9] Add support for providers with large rx
 buffer
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176470320779.3356190.12546474842155040451.git-patchwork-notify@kernel.org>
Date: Tue, 02 Dec 2025 19:20:07 +0000
References: <cover.1764542851.git.asml.silence@gmail.com>
In-Reply-To: <cover.1764542851.git.asml.silence@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, corbet@lwn.net,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, andrew+netdev@lunn.ch,
 ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, ilias.apalodimas@linaro.org, shuah@kernel.org,
 almasrymina@google.com, sdf@fomichev.me, yuehaibing@huawei.com,
 dw@davidwei.uk, haiyuewa@163.com, axboe@kernel.dk, jdamato@fastly.com,
 horms@kernel.org, vishs@fb.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-kselftest@vger.kernel.org, io-uring@vger.kernel.org,
 dtatulea@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 30 Nov 2025 23:35:15 +0000 you wrote:
> Note: it's net/ only bits and doesn't include changes, which shoulf be
> merged separately and are posted separately. The full branch for
> convenience is at [1], and the patch is here:
> 
> https://lore.kernel.org/io-uring/7486ab32e99be1f614b3ef8d0e9bc77015b173f7.1764265323.git.asml.silence@gmail.com
> 
> Many modern NICs support configurable receive buffer lengths, and zcrx and
> memory providers can use buffers larger than 4K/PAGE_SIZE on x86 to improve
> performance. When paired with hw-gro larger rx buffer sizes can drastically
> reduce the number of buffers traversing the stack and save a lot of processing
> time. It also allows to give to users larger contiguous chunks of data. The
> idea was first floated around by Saeed during netdev conf 2024 and was
> asked about by a few folks.
> 
> [...]

Here is the summary with links:
  - [net-next,v7,1/9] net: page pool: xa init with destroy on pp init
    https://git.kernel.org/netdev/net-next/c/854858848bc7
  - [net-next,v7,2/9] net: page_pool: sanitise allocation order
    https://git.kernel.org/netdev/net-next/c/9954464d737d
  - [net-next,v7,3/9] net: memzero mp params when closing a queue
    (no matching commit)
  - [net-next,v7,4/9] net: let pp memory provider to specify rx buf len
    (no matching commit)
  - [net-next,v7,5/9] eth: bnxt: store rx buffer size per queue
    (no matching commit)
  - [net-next,v7,6/9] eth: bnxt: adjust the fill level of agg queues with larger buffers
    (no matching commit)
  - [net-next,v7,7/9] eth: bnxt: allow providers to set rx buf size
    (no matching commit)
  - [net-next,v7,8/9] io_uring/zcrx: document area chunking parameter
    (no matching commit)
  - [net-next,v7,9/9] selftests: iou-zcrx: test large chunk sizes
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



