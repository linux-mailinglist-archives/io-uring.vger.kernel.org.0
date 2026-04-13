Return-Path: <io-uring+bounces-13033-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ABkCOktv3WnweAkAu9opvQ
	(envelope-from <io-uring+bounces-13033-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 00:33:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D0D3F3E7E
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 00:33:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F65E3071C5F
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2026 22:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1092347520;
	Mon, 13 Apr 2026 22:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jc9KVN6Z"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB5C3101B4;
	Mon, 13 Apr 2026 22:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776119448; cv=none; b=rRSJ1+d4c77UDbQ/gO2/V1C+4Z9pLNAXZns3qJTMmEPrRPNjEz0A88URA89daMw3uW6r2VT7YvpYAcNSADvKe4OwFuEBgnwPWK/xvBcbAGgW+xzMgI41NzlmjlX9yMohq8RSv+HQlL68WZa/5tisyrdZGe/jha/2/xD6Z+5jfEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776119448; c=relaxed/simple;
	bh=fAigQ1D/FVo+PjqGeZBeMetY9HLBMWz14oCAZ2q4UKY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=u/8ApJEA5/Xa7BqEn0xVWvE6zlZaVhvSdPJ+DYcid1lQDspMsmOAQRAWCZdzYWQOFLREixlX5g5eHT/iLftVYQN0IVBrq+4SRBSGbPpaFUKK4/OU82bOvDyO8epNu6MmC9qFoejtZ+edhb6C7Zrx6RU3QuHAePgZu+L73zKqHFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jc9KVN6Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87BCC2BCAF;
	Mon, 13 Apr 2026 22:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776119447;
	bh=fAigQ1D/FVo+PjqGeZBeMetY9HLBMWz14oCAZ2q4UKY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=jc9KVN6Z42lJDIZlmAlf2YDtzHi1vYCPOj/8MQsjz6KN19yJWfVx6/ttb3pg7ZlKI
	 Bm7JMgxziCJ5tP2hyLiu24MY6eR1/h/R7ojHIK2OOv+XNGsU6zldqE0S9E/WR7Yp5j
	 uX3gaFes3nFq7+BNtGCp+KF+7RMOFXr4VR6iGxpZOSIP4bzvXKR3Uor1RjtbXslmni
	 w/7nggwFueOkXBs9UBHvW7eeGbQg4ktf2bLQKe55YDQ1Sl+FjRm8ZQK1jVTzUR7Seu
	 lAWlueD/bHbijpO6Un1XvcdHINf3thqyc0d4tTeVz8daIYbqocDa/ZPEcWjd5dNWtH
	 96f4QYnLUJbTQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FDEF3809A0C;
	Mon, 13 Apr 2026 22:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] net: move .getsockopt away from __user
 buffers
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177611941889.575225.5185845042470136876.git-patchwork-notify@kernel.org>
Date: Mon, 13 Apr 2026 22:30:18 +0000
References: <20260408-getsockopt-v3-0-061bb9cb355d@debian.org>
In-Reply-To: <20260408-getsockopt-v3-0-061bb9cb355d@debian.org>
To: Breno Leitao <leitao@debian.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, kuniyu@google.com, willemb@google.com,
 metze@samba.org, axboe@kernel.dk, sdf@fomichev.me, io-uring@vger.kernel.org,
 bpf@vger.kernel.org, netdev@vger.kernel.org, torvalds@linux-foundation.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13033-lists,io-uring=lfdr.de,netdevbpf];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[patchwork-bot@kernel.org,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NO_DN(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 54D0D3F3E7E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 08 Apr 2026 03:30:28 -0700 you wrote:
> Currently, the .getsockopt callback requires __user pointers:
> 
>   int (*getsockopt)(struct socket *sock, int level,
>                     int optname, char __user *optval, int __user *optlen);
> 
> This prevents kernel callers (io_uring, BPF) from using getsockopt on
> levels other than SOL_SOCKET, since they pass kernel pointers.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] net: add getsockopt_iter callback to proto_ops
    https://git.kernel.org/netdev/net-next/c/67fab22a7adc
  - [net-next,v3,2/4] net: call getsockopt_iter if available
    https://git.kernel.org/netdev/net-next/c/5bd0dec150f5
  - [net-next,v3,3/4] af_packet: convert to getsockopt_iter
    https://git.kernel.org/netdev/net-next/c/9c99d6270569
  - [net-next,v3,4/4] can: raw: convert to getsockopt_iter
    https://git.kernel.org/netdev/net-next/c/5b75e7d67695

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



