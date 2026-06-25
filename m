Return-Path: <io-uring+bounces-13839-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id XWLpGclhPWoi2QgAu9opvQ
	(envelope-from <io-uring+bounces-13839-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 19:13:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E7416C7BC9
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 19:13:44 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PrUIvCHD;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13839-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13839-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 356DE302EE90
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 17:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F11093EB10D;
	Thu, 25 Jun 2026 17:10:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38053EB112
	for <io-uring@vger.kernel.org>; Thu, 25 Jun 2026 17:10:32 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782407435; cv=none; b=MSBtzf4T9+/TZhhEjnYeaOUV9mABSQ62IjeQQL4FaSs5fUt3sURCpWI41PvjQevcA6p03afqBqIsBZHwgW8GEbhrTA9r1awBBpVixsFQuLkjfQpO8TckGZA249JJ52O5Z3Q/Xg3DlHcWaTVD+wf5s2AaUFap+BE68KOJOigOL4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782407435; c=relaxed/simple;
	bh=TLip3Su2r+E0iCxceOgAVUMAgZWsZFGCoaLlVwFRqTY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=c2JkUH6dXdjMPbK6z4zQLLD1IWFUyhO27ELVSWwqpK/H4lTwSHLj3V3kLQ1k/p87vPDacNsqvuutNPUIuq4pTWedf8ZAumWQOMUtpeKAcczbCyzFd0Hzpq2lQ5vRtvl2tAOQjsRLqBAN4noHaz2TqOG5x9AWIIULq8ECUanGzQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PrUIvCHD; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B179A1F00ADF;
	Thu, 25 Jun 2026 17:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782407431;
	bh=/XG0L8RuBdHJlBbm9tQ2eMohpkRpYtOsxDadB1dE5lI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=PrUIvCHDDT5djElJUbhQrwt2SegZ5trdiWYO6kFuwh4zwI2XuyETNzTEm1wtksW8y
	 PXvDOsOemR4/OqBoERW7X+lGJP2q1Bte7GcwR2fU5NVHa9/Fzp4Rop0w8qZS1+1QNH
	 7HQpXxte270xuZ/nfxT9GO5H2UCQrsuXSFRt/Ks0vLisa1jDUA3rVa5NzxqhAfDyWe
	 50tsSmw/W/OcAPYB3DnPAqTbEwYG2XS1qRhd2MTcVRuL8DYZlFBniI2IUfhEqfcUn3
	 gc1Pnmi8U9+IvJwROznMSbp1qXQT5sJ4W/WfJfPtT9JMhw3cFDsVX7hUQNlengttjL
	 QB4FBbe9eBsLw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93B0B393878E;
	Thu, 25 Jun 2026 17:10:20 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 7.2-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <8762b3ca-0f33-4aa1-9d81-76dcbd222676@kernel.dk>
References: <8762b3ca-0f33-4aa1-9d81-76dcbd222676@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <8762b3ca-0f33-4aa1-9d81-76dcbd222676@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.2-20260625
X-PR-Tracked-Commit-Id: 3996771b8f759729cba0a28007438c085f814d61
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c58ddac1aa507b71cb5a95a95c641bdd73a3f075
Message-Id: <178240741922.72942.15818937240139879657.pr-tracker-bot@kernel.org>
Date: Thu, 25 Jun 2026 17:10:19 +0000
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:torvalds@linux-foundation.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13839-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8E7416C7BC9

The pull request you sent on Thu, 25 Jun 2026 06:08:47 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.2-20260625

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c58ddac1aa507b71cb5a95a95c641bdd73a3f075

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

