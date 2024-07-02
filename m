Return-Path: <io-uring+bounces-2408-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15CF8923B6D
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 12:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A367F1F234C6
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 10:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A65382D7F;
	Tue,  2 Jul 2024 10:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0UO+1oS"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C7417BBB;
	Tue,  2 Jul 2024 10:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719916230; cv=none; b=dnbsLQJWKXbF57EdKOJw7s8QbBe1Qf5Wfya2iTyxxNWhCuhdVdbqttfZXVqnqR4qwoE60eTYi+60KgZ8U4H5i3UCFiQ8WmQwoVvfLSKEUKxhXqMs8639NDtCqeHNUvGTCmzCDmvtgAn2j64VbTUcZz2mWsVcmdVGgtrMmNPsUV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719916230; c=relaxed/simple;
	bh=KecNRVmFTOnLPjBxrWyerH3YCpF8EHN80gMZ/6xqVrQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Kfa7YfoKlwcx0Hye3NW1ct20qGKSA3ahhmoRwE9tckNq0FEaxsnav6OaY8IjfkMTEwmVJK6nSqMdbYEtuqvNo6brn3rtpqu2XHlW4iEtcZzsodXDjocZ5xONz/+6rvYPEcpHySBNH+OwR4jBfdrnIUVp0A2kc6opDSH0M/fMOzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A0UO+1oS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF3BFC2BD10;
	Tue,  2 Jul 2024 10:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719916229;
	bh=KecNRVmFTOnLPjBxrWyerH3YCpF8EHN80gMZ/6xqVrQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=A0UO+1oS0FvkVSLFDt6rhthLZXH9v7ZUfvwxMbeLjr3Grj0l01qBS1OTt/gB2nlSw
	 6vNIm/a3SS9UmApbF+9TLDMUf3w1qgS5Gz5tCxflAm1xUKs9hAtZpBXCFpxEeoclgE
	 pYIGJJK8wt2ertJ9e6oTTW+VsoDggCGSSdMCKZjMgmlvLwcI29g82VgKAUPUpn0CGF
	 vojU9xm4kadsiv5ZzZ9YVBtJlwyKKG0ZQuc0OjUvPjuv5eFsvK0ewF9A85nUDgPxwB
	 BOqDjC2LDUDuOfc8jR7HsR7l3QZ6dDge8tbnq0O/6xMKWU5rDjXqC6lOp8CcYwDeA9
	 Orgw4Og6ywCvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D326FC43612;
	Tue,  2 Jul 2024 10:30:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] zerocopy tx cleanups
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171991622986.11853.7798454667700291727.git-patchwork-notify@kernel.org>
Date: Tue, 02 Jul 2024 10:30:29 +0000
References: <cover.1719190216.git.asml.silence@gmail.com>
In-Reply-To: <cover.1719190216.git.asml.silence@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, axboe@kernel.dk,
 davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
 edumazet@google.com, willemdebruijn.kernel@gmail.com

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 27 Jun 2024 13:59:40 +0100 you wrote:
> Assorted zerocopy send path cleanups, the main part of which is
> moving some net stack specific accounting out of io_uring back
> to net/ in Patch 4.
> 
> Pavel Begunkov (5):
>   net: always try to set ubuf in skb_zerocopy_iter_stream
>   net: split __zerocopy_sg_from_iter()
>   net: batch zerocopy_fill_skb_from_iter accounting
>   io_uring/net: move charging socket out of zc io_uring
>   net: limit scope of a skb_zerocopy_iter_stream var
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: always try to set ubuf in skb_zerocopy_iter_stream
    https://git.kernel.org/netdev/net-next/c/9e2db9d3993e
  - [net-next,2/5] net: split __zerocopy_sg_from_iter()
    https://git.kernel.org/netdev/net-next/c/7fb05423fed4
  - [net-next,3/5] net: batch zerocopy_fill_skb_from_iter accounting
    https://git.kernel.org/netdev/net-next/c/aeb320fc05c7
  - [net-next,4/5] io_uring/net: move charging socket out of zc io_uring
    https://git.kernel.org/netdev/net-next/c/060f4ba6e403
  - [net-next,5/5] net: limit scope of a skb_zerocopy_iter_stream var
    https://git.kernel.org/netdev/net-next/c/2ca58ed21cef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



