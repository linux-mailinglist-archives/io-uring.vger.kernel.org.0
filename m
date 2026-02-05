Return-Path: <io-uring+bounces-12070-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0Kj0AAsphWkk9QMAu9opvQ
	(envelope-from <io-uring+bounces-12070-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 00:34:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F39CF85C6
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 00:34:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 244C6300C019
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 23:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7FCB33B97E;
	Thu,  5 Feb 2026 23:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXl6M4X2"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A1A1482E8
	for <io-uring@vger.kernel.org>; Thu,  5 Feb 2026 23:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770334472; cv=none; b=Ym90N6g47I4RgTuLuIBfWTBW3nD8F58PjO8rj2M+fv1Bie05sb957xsuom6fWT9CiiOhSXzaL1fuGUcMhJzb2FPIA2AQC1+t6R3jVQzApWtRnCCAhAxs/ITugXIRuIW1oFLJ6jaD0gUxclDTgvsc/cxsirpNFpxYragBzKxoGII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770334472; c=relaxed/simple;
	bh=2DmrnY0qgxJ/sZG9Qccd75EmsQfpbVAA9JaViYsOQJs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fpy5JDl8n6+BZFq/a/wwmuNhMzWMbrRCl3QPwB7+EdxtKIsg7+GBBh+geS2tPZQ4DmuUqw6qpD+Q9USNexIr82sa02UJBqhrvLsyrKKJNXDH2L0xH8W5SQsys9b4Y1j+XZA4ygLvxJ/6zvp/8BVA0qjjC1dAz6Uxw0eq+e1jWMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXl6M4X2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69743C4CEF7;
	Thu,  5 Feb 2026 23:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770334472;
	bh=2DmrnY0qgxJ/sZG9Qccd75EmsQfpbVAA9JaViYsOQJs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jXl6M4X2yVnzNUEZPNHJmQrCKWMzsqcnOmxoI9H/uWNmcqG+hxCUAWMrf6+UUWU4Z
	 sqsKjFP72ulZ6m+IGGXRssCoSXZyvap/OQJSCsJ813VAjjbNAbNWpvDJJ+6JSxHmSj
	 kUL4W+YrO6RdOMcYpJITTWFGCUiYFCXkWtsEaFHt+ue12y47qOwISZ1lDpTqCjkz+6
	 rF3wOVIco6hoAIpw1tKLJ9WCIGTRuVI55tX58Cv40YBLhjdKi1dlPkInMNPP0s5iki
	 1EfRl+LuiiufWXqiTcyXrZiNWEDtM4LRdFxeidiU7fSRp7w4817VZphNOwbwDxW3rx
	 kn+mLnILRJuhg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 483DC3808200;
	Thu,  5 Feb 2026 23:34:31 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.19-final
From: pr-tracker-bot@kernel.org
In-Reply-To: <1a5a4c44-e073-43e1-8eec-59d8c3bac2b4@kernel.dk>
References: <1a5a4c44-e073-43e1-8eec-59d8c3bac2b4@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <1a5a4c44-e073-43e1-8eec-59d8c3bac2b4@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260205
X-PR-Tracked-Commit-Id: 38cfdd9dd279473a73814df9fd7e6e716951d361
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 92f778a0b17a3d4d0b0200a5fb164c5107063044
Message-Id: <177033446986.607944.10748796671793014764.pr-tracker-bot@kernel.org>
Date: Thu, 05 Feb 2026 23:34:29 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12070-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_NO_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org]
X-Rspamd-Queue-Id: 6F39CF85C6
X-Rspamd-Action: no action

The pull request you sent on Thu, 5 Feb 2026 15:22:54 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260205

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/92f778a0b17a3d4d0b0200a5fb164c5107063044

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

