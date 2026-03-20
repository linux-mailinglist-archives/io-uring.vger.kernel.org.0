Return-Path: <io-uring+bounces-12762-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eIoVBp+CvWk4+gIAu9opvQ
	(envelope-from <io-uring+bounces-12762-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 18:23:43 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9EA2DE8C4
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 18:23:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8C0BC3057026
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 17:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FF823D1CB6;
	Fri, 20 Mar 2026 17:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmXXV6hx"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E6E3D171D
	for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 17:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774026854; cv=none; b=QEFyWabX55VZ3aBAJZElbJUv9/1Fc89EhYeVPRlUyxNvtFMi3OZPRvim/WdkcWgiV3zckzK/lRjvPjAcpK0pizGrWlLG+dCw7cLveQSddysNA5IoUS7qlOt/cBCGwaoub5dDTI0kopkJYswJ4J6xw7ZaRdHnWSeYpYL/Uh0jeQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774026854; c=relaxed/simple;
	bh=tLKiFxpCbh7YNuVydConEIMGy91AqspfC7A4qSgNbYI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=s0/GG4OHuYOGe/LZ7J/gop0Rsn4Qf1HjgcutfmUVSp4wdS8L27fWtRaD6waHjd05ZSXcTlklWqw2m0sCZxTVV8MQ0Tml0S4vyCE8lbjUQCCB2X11k8A3hoHCmFVLWyws2fCwW+B33p7kHyWwgvwTq9v08t2XlPeMUWV6r0T2dm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmXXV6hx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C07C4CEF7;
	Fri, 20 Mar 2026 17:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774026854;
	bh=tLKiFxpCbh7YNuVydConEIMGy91AqspfC7A4qSgNbYI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=LmXXV6hx108NUk0lxG2yTb5ju2rZc5eugUe0/Jlq/jaFG7l6hYQnjT5umSkSO3UpN
	 o/GqqSWr7VpGenyxaLW+Qk7s2YdaXOx/eVmKZRhnT/Q1GrQkaZXuyUfDpgvQLpO3zP
	 waN0H56a8k9ek2L4bRQ0Odzm8SZ9PFsObIeUC2ifXESMyuJdo21mw7IB793rfz1L+7
	 in5SW2HS6CffdA1/J3atHtULpLcW7H8g6u1JSL5fdu6p7/leYCLytQ0OEnYPMGVo7i
	 /fkAuf+LqGU8u7DRk25O3nUUpic9Yg2UvXMyDSOr2WGjhFPw9GPeZI3K0SUIy3seeL
	 TZ6Dm3tjvglHA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CF8E380820D;
	Fri, 20 Mar 2026 17:14:05 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 7.0-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <40c31f28-a227-4123-91fd-5a4b0c044bef@kernel.dk>
References: <40c31f28-a227-4123-91fd-5a4b0c044bef@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <40c31f28-a227-4123-91fd-5a4b0c044bef@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260320
X-PR-Tracked-Commit-Id: 418eab7a6f3c002d8e64d6e95ec27118017019af
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c612261bedd6bbab7109f798715e449c9d20ff2f
Message-Id: <177402684409.2580860.6058246581036941118.pr-tracker-bot@kernel.org>
Date: Fri, 20 Mar 2026 17:14:04 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-12762-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_NO_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.985];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2E9EA2DE8C4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The pull request you sent on Fri, 20 Mar 2026 10:16:19 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260320

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c612261bedd6bbab7109f798715e449c9d20ff2f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

