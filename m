Return-Path: <io-uring+bounces-12541-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EJt0IX9opmljPQAAu9opvQ
	(envelope-from <io-uring+bounces-12541-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 05:50:07 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDF71E9108
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 05:50:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E440830F26F5
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2026 04:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEE0C2E541E;
	Tue,  3 Mar 2026 04:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5x6ARhp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2932E06E4;
	Tue,  3 Mar 2026 04:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772513223; cv=none; b=c7FdncdkuYea5u3tUEBQUlrsU05AttinHjCghKAa5Hd7dzyQ6/TVDVMi0YIozYTsm7N5sN/qf0vZTC8hd4KlLKG5Zaic9FH/I0et7QESiqcGZiGZcB4s5BKFCTTykHjj5v5axkVsV6IkhLAi/xUz0pvZNg0dAhjo1CMKhKk0p1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772513223; c=relaxed/simple;
	bh=8p6I4ZbJF82/s3rO0jdePvWcfOlktsnXETNNgKHgesE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=OzSsJs2goloKCrU6RlVJL9laXX6pg7zpNJUUBreaEJDFbSFWduVFGRVwXx+x6e8r/JtnONvk6guVziDwxm0fGIPKE1Nn4lwIIyY9WlfxoXxlp93gDdFxOF9VQuHMs6fHI53Z6ydDyH5BvUq+U0zpDUQdBRQz2oyFygXH4ySiH3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5x6ARhp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B375C2BCAF;
	Tue,  3 Mar 2026 04:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772513223;
	bh=8p6I4ZbJF82/s3rO0jdePvWcfOlktsnXETNNgKHgesE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=F5x6ARhpK8h1ESlXGqhJY08jwOS0NojF0PKXAXvgHWzr92E5zqMYIYY/yWFfxxyRP
	 wWgQvidZSJZWdcbaUly+sHNSiLDd3MHi9Fxqbh535qf8V7pxa0LSgn6euOTTPwzwOL
	 aoOtXp8rrnx5m7h6iDozg41izePTnZoz/R8+3qUhTcxQQ9M0gKg+irkcqgplZbAGWX
	 RX7nyBhcUiOtQbu274r7f2gzcL1WemsAEvHWUjp8KxW1J63my8k9jZ+4FYwLxFPImm
	 W7QrjVc0wByqIlY5oOL88rZt/ylvmkFY7V+DqyAdaFRv7npkdB3vFlTXap8Pv8Jr5j
	 PPkwh0TvurSdA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02CAF3809A80;
	Tue,  3 Mar 2026 04:47:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] selftests: drv-net: iou-zcrx: improve
 stability
 and make the large chunk test work
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177251322454.625663.6934806010207310713.git-patchwork-notify@kernel.org>
Date: Tue, 03 Mar 2026 04:47:04 +0000
References: <20260227171305.2848240-1-kuba@kernel.org>
In-Reply-To: <20260227171305.2848240-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, andrew+netdev@lunn.ch, horms@kernel.org, dw@davidwei.uk,
 jdamato@fastly.com, asml.silence@gmail.com, io-uring@vger.kernel.org
X-Rspamd-Queue-Id: DCDF71E9108
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[davemloft.net,vger.kernel.org,google.com,redhat.com,lunn.ch,kernel.org,davidwei.uk,fastly.com,gmail.com];
	FROM_NEQ_ENVFROM(0.00)[patchwork-bot@kernel.org,io-uring@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-12541-lists,io-uring=lfdr.de,netdevbpf];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NO_DN(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 27 Feb 2026 09:13:02 -0800 you wrote:
> The iou-zcrx test hasn't been passing in NIPA, I assumed it's because
> we're missing iouring changes, but it's still failing after the merge
> window. Turns out there was a bug in the implementation which was fixed
> separately via the iouring tree. With that out of the way the tests
> are passing but flaky. Patch 1 deals with the flakiness.
> 
> While looking at this I also noticed that the large chunk test isn't
> running at all. So fix and enable it (patches 2 and 3).
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] selftests: drv-net: iou-zcrx: wait for memory provider cleanup
    https://git.kernel.org/netdev/net-next/c/27c4ab943882
  - [net-next,2/3] selftests: drv-net: iou-zcrx: rework large chunks test to use common setup
    https://git.kernel.org/netdev/net-next/c/67792dde27a6
  - [net-next,3/3] selftests: drv-net: iou-zcrx: allocate hugepages for large chunks test
    https://git.kernel.org/netdev/net-next/c/c7b228418e8b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



