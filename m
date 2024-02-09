Return-Path: <io-uring+bounces-589-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70A6C84FC48
	for <lists+io-uring@lfdr.de>; Fri,  9 Feb 2024 19:50:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19F351F2141A
	for <lists+io-uring@lfdr.de>; Fri,  9 Feb 2024 18:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6135E5465C;
	Fri,  9 Feb 2024 18:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hiR84NoS"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C86364D6;
	Fri,  9 Feb 2024 18:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707504629; cv=none; b=aPo3zXfwXJXl/uE2A4FY/dn36NYXZKHZHzm+19heDP1Ej4tchbSQhTWebqny/Q1JgAqvYdkaNXc8UHi04LwniI6UXpNvqdcY6bzNvEuBOdqmHDW6pWZVrUeYiPhMCmASMzUdheRPM+Y/ujn8YwCy3AGL2vb1j9W91DCcA3DQ/Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707504629; c=relaxed/simple;
	bh=WYtSGd1zqOC1K+nye/ux7LVCcCN8yryEiprdLO9TkTU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Ryar+rue7q/R/3nrpY4M/Mmz27Et81DjDnaz4t4GWVrGlYwh6G896b0OvhWjAobT2DwRupH4Hw2B0xnWnlpfVFefKBI1Wj4C4/tFgtNA9j52Lh/V/Mc/Ig0SZCAX6erwlqz0Lg21gGJXib3gHj80OO65sNNUILRl5BxjdKSt/1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hiR84NoS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00E35C433F1;
	Fri,  9 Feb 2024 18:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707504629;
	bh=WYtSGd1zqOC1K+nye/ux7LVCcCN8yryEiprdLO9TkTU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hiR84NoSdPEUseuNRVNxrzUNYcVLA8gylpgOP9Rh8173lLHYvOXqm5Zgd7wb9KDBK
	 M+ez9B/mKvc8WooJNHU+3IFDiGJroSzLyXqLp6cDAVu9Rta9cw8J12FBRbjGC+UVII
	 m1t4eEv9JEEOS6dbdMjTvTAa/nCgVa/otzgrO0p3zXeNtsP4wqlRUysogsyz2co1CX
	 1jyg3rwrKXCIYBUb+2SisH+lO/W6BCx+BD22EwBBOe0WMDPJHMUkm2eLkrClhOdnBi
	 SlykMiUdrPNq/Y3LUExAaXX4pevRmOnUaVCgJbv5KKvKRZTtC7JUQdkMQF4GvNmg0P
	 Q+lGFJEDHrqhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D538FE2F312;
	Fri,  9 Feb 2024 18:50:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHSET v16 0/7] io_uring: add napi busy polling support
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170750462886.3616.4778808690452613932.git-patchwork-notify@kernel.org>
Date: Fri, 09 Feb 2024 18:50:28 +0000
References: <20240206163422.646218-1-axboe@kernel.dk>
In-Reply-To: <20240206163422.646218-1-axboe@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
 olivier@trillion01.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  6 Feb 2024 09:30:02 -0700 you wrote:
> Hi,
> 
> I finally got around to testing this patchset in its current form, and
> results look fine to me. It Works. Using the basic ping/pong test that's
> part of the liburing addition, without enabling NAPI I get:
> 
> Stock settings, no NAPI, 100k packets:
> 
> [...]

Here is the summary with links:
  - [1/7] net: split off __napi_busy_poll from napi_busy_poll
    https://git.kernel.org/netdev/net-next/c/13d381b440ed
  - [2/7] net: add napi_busy_loop_rcu()
    https://git.kernel.org/netdev/net-next/c/b4e8ae5c8c41
  - [3/7] io-uring: move io_wait_queue definition to header file
    (no matching commit)
  - [4/7] io-uring: add napi busy poll support
    (no matching commit)
  - [5/7] io-uring: add sqpoll support for napi busy poll
    (no matching commit)
  - [6/7] io_uring: add register/unregister napi function
    (no matching commit)
  - [7/7] io_uring: add prefer busy poll to register and unregister napi api
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



