Return-Path: <io-uring+bounces-13739-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id HMuDBQZhMGo3SQUAu9opvQ
	(envelope-from <io-uring+bounces-13739-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 22:31:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A36A689DBF
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 22:31:01 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+1QuY9d;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13739-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13739-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8FA6530325B8
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 20:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F039F3B71A8;
	Mon, 15 Jun 2026 20:30:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA553B5841;
	Mon, 15 Jun 2026 20:30:13 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781555414; cv=none; b=Uuc1j4Oz3FvY8w0DaRpphX6OUsLPwm9MeKHPsWUkwEtigYjv9MLCiOLCSr+2K//6IKbQK+l8eKC2I0SBzBT8U3InCLUy147/y5v8xjkcDZmmSx4+dSrRscH79iNDSL/KnkUnf12DiiNc5tli0kQlTz8zH6LRf6TEe33mP70HgD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781555414; c=relaxed/simple;
	bh=bRQr9t8wtT837TG2tr0GdAxazaLA4sfobrPIOzlVmIY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=QMVaYgl/COGczKPUqGmAKOjvYLfBo4vbG1ihTKmLp4VKxzNYHaGZ7lieGz8g6AjuG59fkVHjf05Chv9UsmpdzKwwryZAYvQYmNtFoNZ4jV/FPNOt11mWf5KlASRvyVtXHE6QlnOpFc1kwiZyeCx56Me6HEbfnkEoFodL6a8ltzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+1QuY9d; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AFC1F000E9;
	Mon, 15 Jun 2026 20:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781555413;
	bh=5aMDLIE5PrNUelkHErz/IH1DPJ9zEL4jKjoADG/7r1c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=O+1QuY9dSV6txVh9SRYv2Trkgbf5SsM9wyjpKZOGTIzfUNa7EMlwhPY0zf1fYFkGZ
	 H5QhLiO25gmCrNaa+MQT7fiMlMszGd8OAcox0m5hYv9cDiFdw1/QBnIbpcykKPCNpG
	 nLjuemRS0BC1X9DLo2b2AcBftZBha5x2QM8aI9fi/TVfB2O1VmDk4HqDpWTQB3iNbA
	 lZd59XyM7UBk+CYmO8Pxb2Vs3pedcO2xEV0D4TbReqwKyrpN/8FpWai+I+weRj8r/h
	 mDxhF+xfTW6NAxIsxg5XV/c2wm8/k13OieJFxt76KtdQO5c8+9a2kvdZXrsqxLmc0q
	 SIS9sg5SaQO4g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0D0E3839A06;
	Mon, 15 Jun 2026 20:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] netdev: expose page pool order via
 netlink
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178155540839.284807.2185512260142204749.git-patchwork-notify@kernel.org>
Date: Mon, 15 Jun 2026 20:30:08 +0000
References: <20260612211709.1456966-2-dtatulea@nvidia.com>
In-Reply-To: <20260612211709.1456966-2-dtatulea@nvidia.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, donald.hunter@gmail.com,
 andrew+netdev@lunn.ch, asml.silence@gmail.com, axboe@kernel.dk,
 shuah@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[davemloft.net,google.com,kernel.org,redhat.com,gmail.com,lunn.ch,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13739-lists,io-uring=lfdr.de,netdevbpf];
	RCPT_COUNT_TWELVE(0.00)[15];
	FORGED_SENDER(0.00)[patchwork-bot@kernel.org,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:dtatulea@nvidia.com,m:davem@davemloft.net,m:edumazet@google.com,m:kuba@kernel.org,m:pabeni@redhat.com,m:horms@kernel.org,m:donald.hunter@gmail.com,m:andrew+netdev@lunn.ch,m:asml.silence@gmail.com,m:axboe@kernel.dk,m:shuah@kernel.org,m:netdev@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:linux-kselftest@vger.kernel.org,m:donaldhunter@gmail.com,m:andrew@lunn.ch,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[patchwork-bot@kernel.org,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	FROM_NO_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6A36A689DBF

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 13 Jun 2026 00:17:02 +0300 you wrote:
> This small series exposes io_uring's high order page configuration
> via the page_pool netlink interface and updates the appropriate
> selftest to check this value.
> 
> ---
> v2:
> - Switched from exposing page_pool order to rx_buf_len via nl_fill of
>   the io_uring memory provider.
> - Updated selftest to check rx_buf_len.
> - v1: https://lore.kernel.org/all/20260611161235.3807332-1-dtatulea@nvidia.com/
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] netdev: expose io_uring rx_page_order order via netlink
    https://git.kernel.org/netdev/net-next/c/5c4adb7fb46f
  - [net-next,v2,2/2] io_uring/zcrx: selftests: verify rx_buf_len for large chunks
    https://git.kernel.org/netdev/net-next/c/18f65355e112

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



