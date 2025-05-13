Return-Path: <io-uring+bounces-7960-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B56FAB4FC9
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 11:30:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D511219E0F25
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 09:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2111227EAB;
	Tue, 13 May 2025 09:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJ5StDbd"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82408227E8C;
	Tue, 13 May 2025 09:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747128606; cv=none; b=O5Nk4olKc0C6MSTowdRXg3BAJsgb7An9/yQqweOHpc7tFXoLTYMpzFoVUvvAkePms9wlWaqKzm1TeEPP8UD/87f/DuHuuxYmCRGEozNBBPkC2gWxOJAYC1pIGXXoYxN/kSk+PcGRg7uIHH0Bl2ACbVzxrOLZu10jroNaLmp9KLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747128606; c=relaxed/simple;
	bh=982jXf6QjefdLWj60I4V7qnuv7iqFenReu2jMD1Hcfw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=q3qJdNxfBktA4+CSxShq8fZpzdt7yocr342ltES4cNSJCG900LA9dVvswKQx9ySvQfiy42l6msW9WPP1wWhrftFHtohA+9L3OBkedsr3MVpdtMCd2b0lf3oIw4oTywWSgqWqMgDxlTzWlxPOFb0lzGjHxrJhqNicbXBFk+V4aAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJ5StDbd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC583C4CEE4;
	Tue, 13 May 2025 09:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747128605;
	bh=982jXf6QjefdLWj60I4V7qnuv7iqFenReu2jMD1Hcfw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=cJ5StDbdMUqgFU1nibcKTcrE/lbpar8UNz+17VvmArjbq84lV9qpZZqyb1B0AE5F0
	 hzLxOV7veV6tbS1CpfJ5d1udD1Dmx22doiZvU3S0D+beoc4jKqsLWChkqyUjXAbTBc
	 Ps0hpLc4ENGfEhFxB+Z7bfRoPm7cZZJQGXKVzgPS3fIJHygsFh1GgJSna8BIaytCHN
	 GX1bgSWC8ATTt5ym2XRwjuH+nZnROAbHmox5yXjEnIlbQmRPsCOY21TaZtoxqCkY0p
	 pAJSg1K3OfodDaqE8/TZ+2gCV0N+JrRw2vwA4f76drx+Dp6A1beSfuE3d/BFT6at2z
	 YZiYii6kMOuqA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF8839D6553;
	Tue, 13 May 2025 09:30:44 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v14 0/9] Device memory TCP TX
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174712864353.1250182.17683820324947823076.git-patchwork-notify@kernel.org>
Date: Tue, 13 May 2025 09:30:43 +0000
References: <20250508004830.4100853-1-almasrymina@google.com>
In-Reply-To: <20250508004830.4100853-1-almasrymina@google.com>
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, io-uring@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, donald.hunter@gmail.com, kuba@kernel.org,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 horms@kernel.org, corbet@lwn.net, andrew+netdev@lunn.ch, jeroendb@google.com,
 hramamurthy@google.com, kuniyu@amazon.com, willemb@google.com,
 axboe@kernel.dk, asml.silence@gmail.com, dsahern@kernel.org,
 ncardwell@google.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, stefanha@redhat.com,
 sgarzare@redhat.com, shuah@kernel.org, sdf@fomichev.me, dw@davidwei.uk,
 jhs@mojatatu.com, victor@mojatatu.com, pctammela@mojatatu.com,
 skhawaja@google.com

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu,  8 May 2025 00:48:20 +0000 you wrote:
> v14: https://lore.kernel.org/netdev/20250429032645.363766-1-almasrymina@google.com/
> ===
> 
> Picked up acks from Paolo, and addressed feedback from Paolo and Jakub.
> 
> Changelog:
> - Fix issue in patch 4 where sockc_valid == false but err is
>   overwritten.
> - Addressed nits.
> 
> [...]

Here is the summary with links:
  - [net-next,v14,1/9] netmem: add niov->type attribute to distinguish different net_iov types
    https://git.kernel.org/netdev/net-next/c/03e96b8c11d1
  - [net-next,v14,2/9] net: add get_netmem/put_netmem support
    https://git.kernel.org/netdev/net-next/c/e9f3d61db5cb
  - [net-next,v14,3/9] net: devmem: TCP tx netlink api
    https://git.kernel.org/netdev/net-next/c/8802087d20c0
  - [net-next,v14,4/9] net: devmem: Implement TX path
    https://git.kernel.org/netdev/net-next/c/bd61848900bf
  - [net-next,v14,5/9] net: add devmem TCP TX documentation
    https://git.kernel.org/netdev/net-next/c/17af8cc06a5a
  - [net-next,v14,6/9] net: enable driver support for netmem TX
    https://git.kernel.org/netdev/net-next/c/383faec0fd64
  - [net-next,v14,7/9] gve: add netmem TX support to GVE DQO-RDA mode
    https://git.kernel.org/netdev/net-next/c/c32532670cec
  - [net-next,v14,8/9] net: check for driver support in netmem TX
    https://git.kernel.org/netdev/net-next/c/ae28cb114727
  - [net-next,v14,9/9] selftests: ncdevmem: Implement devmem TCP TX
    https://git.kernel.org/netdev/net-next/c/2f1a805f32ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



