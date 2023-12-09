Return-Path: <io-uring+bounces-276-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A48D080B68B
	for <lists+io-uring@lfdr.de>; Sat,  9 Dec 2023 22:30:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6840A280FF8
	for <lists+io-uring@lfdr.de>; Sat,  9 Dec 2023 21:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD201C6BF;
	Sat,  9 Dec 2023 21:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WYR8MLCh"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05941D691;
	Sat,  9 Dec 2023 21:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58E99C433C9;
	Sat,  9 Dec 2023 21:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702157423;
	bh=6dtEISSgwJn9p7Or2IXkynPlGkMJOf4k8j6Gb1VPeh4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=WYR8MLChm3LkwfYiJ/Dxbm3EqW+O3T8BfxB0UKRmajJp3ddquv5HlpWzGVaDAejbF
	 3w/OsfKtAsUTtx2niu/ULIwEyZ+yqnWfpjMlKd1JM0oJQmJPjTf13rKQKycOZvwLPh
	 7opSkKbWlM8Q0WSpvvSHkE3UmCmfeqVaVGV2qCdfjrCQZ7N8YKqfCm20/8/bQvTy/F
	 Z3y1LGy7kxgGhkN+SpFOkuqxRM4buE/QV8JQxfFS5FWyWFKaQrz1vojIrqEjHOPEeV
	 MWHnCdSZTN95RrikzLbZo4Kk8VCVDKdCqFFhgEVXIelloJGGaz787ojFaFrjAEuBki
	 7qo0uFnQreePw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3FACCC595C5;
	Sat,  9 Dec 2023 21:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND] io_uring/af_unix: disable sending io_uring over
 sockets
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170215742325.28655.3532464326317595709.git-patchwork-notify@kernel.org>
Date: Sat, 09 Dec 2023 21:30:23 +0000
References: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
In-Reply-To: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, jannh@google.com,
 davem@davemloft.net, kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed,  6 Dec 2023 13:55:19 +0000 you wrote:
> File reference cycles have caused lots of problems for io_uring
> in the past, and it still doesn't work exactly right and races with
> unix_stream_read_generic(). The safest fix would be to completely
> disallow sending io_uring files via sockets via SCM_RIGHT, so there
> are no possible cycles invloving registered files and thus rendering
> SCM accounting on the io_uring side unnecessary.
> 
> [...]

Here is the summary with links:
  - [RESEND] io_uring/af_unix: disable sending io_uring over sockets
    https://git.kernel.org/netdev/net/c/69db702c8387

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



