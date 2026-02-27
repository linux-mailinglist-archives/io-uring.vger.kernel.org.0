Return-Path: <io-uring+bounces-12448-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iHFHN9AWoWkUqQQAu9opvQ
	(envelope-from <io-uring+bounces-12448-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 05:00:16 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 536EE1B2753
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 05:00:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 259BD310AEC2
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 04:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B6333E350;
	Fri, 27 Feb 2026 04:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9Cq02MO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3151B33DEFB;
	Fri, 27 Feb 2026 04:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772164802; cv=none; b=f8u0w3jh16pT9JfRM4kvIne9JVapfJWiCASNbWba+35d44f8DxXE1ZNEnD1e6VXWOGJLyLEb0xGeCDOC7SRSO3FngPyrJMw7+IC5Vt/WzFa7MHOHZCXHapIu5g9vxWe/ekLBbduy+ZQmIwPfvrmMXS2J2uBL4L48KnC2ES0dVUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772164802; c=relaxed/simple;
	bh=1+lZ0E55IZSnlIC8aQoz0il+erk4zax1IShpIXOWWWE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=KtQvBGi8FXbGWc1wefn0kDMxMTSvnILukuTJ2c8gQ0bnzqfgRgGaLLB8FktNVflu04IcokH583Xpt2GpPHEBO4bivnvUbLgQSQL+4AWSZMpt8+G/WG0rUXva3vw17xvC3yDiJZFwaul/sI7ebL4QuJxE3d/nTeFcul/HP1qJZy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9Cq02MO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8791C19421;
	Fri, 27 Feb 2026 04:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772164802;
	bh=1+lZ0E55IZSnlIC8aQoz0il+erk4zax1IShpIXOWWWE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=J9Cq02MOZz927TYLviYPTRy5DWxNgVdrOf9xFcrbrc3tbBR/HmexUgcCuLgDKBEFJ
	 +fVvEagzJ5cI4qpkKtOszq9KN2TTk4zzzp21aWa4I6Cg75eJ9crAHf1jbVOlYrFMRq
	 wLSotxJBw1IDOBnYnCuoZK5g8jFd5fiSEwFgKARaeLt1hKb7GmTtQBKSpre2AAa0zA
	 PQ/zh8rUizHBbH9dwVifUIHul0ZV5T/NgvOa5YTJP/s3AWEo2MIikVpbd+8JPoSPCA
	 k9EzevIjsvieLAAJeTQPQ3876jMGtGk4CDtmDuIfOLuoE5D0f/uDs4s8h40WOfupoE
	 fps+qgy5TlhOQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9E9839310A2;
	Fri, 27 Feb 2026 04:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH net-next] netmem: remove the pp fields from net_iov
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177216480555.1965102.13851630546170350105.git-patchwork-notify@kernel.org>
Date: Fri, 27 Feb 2026 04:00:05 +0000
References: <20260224061424.11219-1-byungchul@sk.com>
In-Reply-To: <20260224061424.11219-1-byungchul@sk.com>
To: Byungchul Park <byungchul@sk.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, hawk@kernel.org,
 andrew+netdev@lunn.ch, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, ziy@nvidia.com, willy@infradead.org,
 toke@redhat.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, asml.silence@gmail.com, axboe@kernel.dk,
 ncardwell@google.com, kuniyu@google.com, dsahern@kernel.org,
 almasrymina@google.com, sdf@fomichev.me, dw@davidwei.uk, ap420073@gmail.com,
 dtatulea@nvidia.com, shivajikant@google.com, io-uring@vger.kernel.org
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12448-lists,io-uring=lfdr.de,netdevbpf];
	FREEMAIL_CC(0.00)[vger.kernel.org,kvack.org,skhynix.com,oracle.com,kernel.org,lunn.ch,suse.cz,nvidia.com,infradead.org,redhat.com,davemloft.net,google.com,gmail.com,kernel.dk,fomichev.me,davidwei.uk];
	FROM_NEQ_ENVFROM(0.00)[patchwork-bot@kernel.org,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[32];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_NO_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,sk.com:email]
X-Rspamd-Queue-Id: 536EE1B2753
X-Rspamd-Action: no action

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 Feb 2026 15:14:24 +0900 you wrote:
> Now that the pp fields in net_iov have no users, remove them from
> net_iov and clean up.
> 
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
> The original post was:
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next] netmem: remove the pp fields from net_iov
    https://git.kernel.org/netdev/net-next/c/fd6dad4e1ae2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



