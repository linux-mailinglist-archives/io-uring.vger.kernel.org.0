Return-Path: <io-uring+bounces-13778-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id HyKOAYgONGqiMgYAu9opvQ
	(envelope-from <io-uring+bounces-13778-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2026 17:28:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E916A13BD
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2026 17:28:07 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FOzwep7l;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13778-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13778-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D7EBB300C25F
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2026 15:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3603F58D9;
	Thu, 18 Jun 2026 15:23:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A09A2DC357
	for <io-uring@vger.kernel.org>; Thu, 18 Jun 2026 15:23:09 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781796191; cv=none; b=aDX419zwtnlEr9UbHI0J/irarqMm8Fm6OdhnTK7kNdPHbVm3lPNyv5vn9JB7MFpr0wt8Z7ktwx7zwEn44iLhAXDMr35GfRSqBCLyz3EyPEF4COlY6FXdEj6HdaS/uPL55mpvh+Jm/Pp0V1N1aH2pKdcKlGoIHRNlCpKZpKu8Zk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781796191; c=relaxed/simple;
	bh=1mMrOb1uDDfUkXBzxO6OEqiU2eTmFTVaMa/US1O3AHk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=gprxduKooesQOUw2bECMq3mwliYhgbSHvi0bXB/HW/+3mkoRONZmYq50+xs0TfgGfqG3GOE/gN6TJcsB3gmsg2UQIDbGRIjXetZayhUfTXBjPpGrOdzRKllLOwQeUzVehQ908Czj5jjGCB9jSI3FssivcuUSGqnzYfwcatv88Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FOzwep7l; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EAB1F000E9;
	Thu, 18 Jun 2026 15:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781796189;
	bh=gCDW+yg1ChwExP6MVzr34ojuf4RkBanCQBaVZ3Pc0Kc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=FOzwep7lf2lyhxDw3beZSq3lCeHyqsscj3v/B61Aks7afX7qIusdGtlS1kC9B3GRA
	 SG+XlRxTXa24JCkiK055+U0BvBTQBK+Hf7GL9HgcJXLVASo6aQqEZr8arpxhPu7kqU
	 +F45T2V5kkAUZulPse4I03PvTbYa4laFcaky9w3Ur9yBr0x+024wQFuKVgklr8OBu6
	 ajfDD7/OkqM1SVzbdkNrTDSayB9MAnk7k+VboF2ej7fdu9fXYTdIMX9We6YQZedpSI
	 B+BBR2clJB/8zTPY2pkOxqOWxtXUGxf8e95LtzeiN5n7n8sStGRkd5KuYPV6RWMGwx
	 OJAW5b3RCadxA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93C873A566DE;
	Thu, 18 Jun 2026 15:23:04 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring epoll cleanups for 7.2
From: pr-tracker-bot@kernel.org
In-Reply-To: <d72ad59f-f09c-49d3-8d9f-f6bf9df29ad1@kernel.dk>
References: <d72ad59f-f09c-49d3-8d9f-f6bf9df29ad1@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <d72ad59f-f09c-49d3-8d9f-f6bf9df29ad1@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-7.2/io_uring-epoll-20260616
X-PR-Tracked-Commit-Id: cfa1539b24aff18ecb71c6334e7270f810d145bb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2f9f5887b42711595e768b9dc0582dccfdf60c3b
Message-Id: <178179618325.2947725.5669507902275035174.pr-tracker-bot@kernel.org>
Date: Thu, 18 Jun 2026 15:23:03 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:torvalds@linux-foundation.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13778-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FROM_NO_DN(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 55E916A13BD

The pull request you sent on Tue, 16 Jun 2026 06:27:31 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-7.2/io_uring-epoll-20260616

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2f9f5887b42711595e768b9dc0582dccfdf60c3b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

