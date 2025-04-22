Return-Path: <io-uring+bounces-7607-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A88BA96387
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 11:06:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03D443B04CC
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 08:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 574AF253B75;
	Tue, 22 Apr 2025 08:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RvUW60B3"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2320C23AE96;
	Tue, 22 Apr 2025 08:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745312234; cv=none; b=DhysVlluWlGxDcMv6xn3tUmm5zF1hb/YZcvZGCZVWG3aVX2pJHsmNudZTjYSqBhRM1lxFNDIHIbZmh7y5eaoCkPt5qTzU4XjGO23YRG6YPdQQ25M6eBfMCvmEdfR7p/1/6QN3mtMX3GrLkJBr0SDVqXJyvEaok92jNwitBitLmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745312234; c=relaxed/simple;
	bh=iNeu6FUL9ZADGsOfxWp6cq8Oa+3XDbpFHSP8nB50UrM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=rS+eOnrZm0Bqe7MEGjKp8z+1+tpQMZ7b4rdMb4uts74UQdUprIlqdiyYDvFUOHND9psFYZ6QL870Hi/lyWKAcxUGyohYk7ndgqDj1iaXz/RMO1LnpaVVQz8ezi62asn8m95BJmzZb9TO6gGXnk7L2oojxNG2wEWiXSd+xCUrwrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RvUW60B3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE88C4CEE9;
	Tue, 22 Apr 2025 08:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745312233;
	bh=iNeu6FUL9ZADGsOfxWp6cq8Oa+3XDbpFHSP8nB50UrM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=RvUW60B3K1ejmsBW+RomvJWB+aaQWWDP0OOixpqQBVCEaOcxWfaEEdL//AW7ai5w2
	 lDISygDaRKCZ6Og2MIfS6TS/AU2i0iPCxZ77OSh5G3DrRV4qQBEjGQ+HBTz8FwVHLz
	 600id4o3r5oITf0e9x4ND07Eh6djoUUe48gLXJXB3hv9GDl+CoraEWZk4O8bqitkjA
	 evXelmkwOp/5fP1lh2zMqX5t22/bJeFN0RVHa1DSweEbLHN+1JKs5uYJ+B+2S4b/08
	 cbRLSUgaO+G/MsWz9Q/bl1KUcn6nWTPsoBGlDumdHoD1QrMWwZXopewOcepIrd+4qX
	 bllwoZRc5iMCg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D1939D6546;
	Tue, 22 Apr 2025 08:57:53 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH io_uring-6.15] io_uring/zcrx: fix late dma unmap for a dead
 dev
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174531227199.1477965.208834710811336342.git-patchwork-notify@kernel.org>
Date: Tue, 22 Apr 2025 08:57:51 +0000
References: <ef9b7db249b14f6e0b570a1bb77ff177389f881c.1744965853.git.asml.silence@gmail.com>
In-Reply-To: <ef9b7db249b14f6e0b570a1bb77ff177389f881c.1744965853.git.asml.silence@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, dw@davidwei.uk, toke@redhat.com,
 kuba@kernel.org, almasrymina@google.com, netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Jens Axboe <axboe@kernel.dk>:

On Fri, 18 Apr 2025 13:02:27 +0100 you wrote:
> There is a problem with page pools not dma-unmapping immediately
> when the device is going down, and delaying it until the page pool is
> destroyed, which is not allowed (see links). That just got fixed for
> normal page pools, and we need to address memory providers as well.
> 
> Unmap pages in the memory provider uninstall callback, and protect it
> with a new lock. There is also a gap between a dma mapping is created
> and the mp is installed, so if the device is killed in between,
> io_uring would be hodling dma mapping to a dead device with no one to
> call ->uninstall. Move it to page pool init and rely on ->is_mapped to
> make sure it's only done once.
> 
> [...]

Here is the summary with links:
  - [io_uring-6.15] io_uring/zcrx: fix late dma unmap for a dead dev
    https://git.kernel.org/bpf/bpf/c/f12ecf5e1c5e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



