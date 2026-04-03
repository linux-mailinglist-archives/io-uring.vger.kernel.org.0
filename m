Return-Path: <io-uring+bounces-12955-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YIyXITob0Gmr3QYAu9opvQ
	(envelope-from <io-uring+bounces-12955-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 21:55:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DEA58397F57
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 21:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 54FA6305DEEF
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2026 19:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 964713630A2;
	Fri,  3 Apr 2026 19:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U+DKc9H3"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C4730B502
	for <io-uring@vger.kernel.org>; Fri,  3 Apr 2026 19:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775245961; cv=none; b=Hnn+vdYjsJe8UQRwmzmSCT2xRbK/KZCeEjJGM/dEzlnXd49d1JNcj5HgP99+KazeUS/M7Hl7RAHlv6uf6yZN/yrYZBmSsj8rxV1opAw6FQrxLuaBz4p9rIji9W6crOi/tGf5OPmPUKpEeVbw0dZjiSxOEbYsabt9NQ5IulJXS3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775245961; c=relaxed/simple;
	bh=0bTQiNiYYC3/66kyUCzKmkyjO1pWKkQ7J3Mw00rHMbc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=MAtf0bNM0gWpsZTl7rrgp7Xk3MGdu9esk9qI3v3Lcn6ntm+DpZzI8FVCyjwZuOK2KYONyZ7Qe8oPT2R91T+EKwF46SJtQ6pVRPK4EhYxczo/Zg8xomhJR1cJ0uUfINBd0f8zWxlz2xJaRh0/Gu43xWHwIvv4TVnnVEheYp6g93c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U+DKc9H3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F29BC4CEF7;
	Fri,  3 Apr 2026 19:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775245961;
	bh=0bTQiNiYYC3/66kyUCzKmkyjO1pWKkQ7J3Mw00rHMbc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=U+DKc9H3OhzbKKmyUrrZ+Df/RNpYNMFT43CzlBS8SkPp6OOiedj/w94JJ2R88xilZ
	 q4Ze3VtvTIGC8ORGIrNTyaylXUHYWxB2zlir5tUz2vZm3nMhd6pXXXqaKVhKlfPuNz
	 fK1+v1Ad4pyCKkpQ7a9+yxY7yhJ+CFKu+bsUj/+xkEc4yiPqjVGXCDS3Vj1wGZU5fY
	 W0HK7npzF/p7+pfyYVOZxA4w+e6fKX3TwHKU+sANc0G+aTWWYagg9ORi47W0I+jO1L
	 U2TvJSvFgK4Eb+z4kOGgOEmqt7O1PbzWd16haFaeirMWa8sOH92t7aXDz3iq+/fjuU
	 46QCNo5S3EslQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02D7E3809A14;
	Fri,  3 Apr 2026 19:52:24 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 7.0-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20d0c66c-191f-4021-baf7-4a846e6e985f@kernel.dk>
References: <20d0c66c-191f-4021-baf7-4a846e6e985f@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <20d0c66c-191f-4021-baf7-4a846e6e985f@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260403
X-PR-Tracked-Commit-Id: aa35dd6bdd033dea8aa3e20cbbbe10e06b2d044f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e41255ce7acc4a3412ecdaa74b32deee980d27f7
Message-Id: <177524594257.1431632.12969749452385365215.pr-tracker-bot@kernel.org>
Date: Fri, 03 Apr 2026 19:52:22 +0000
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-12955-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_NO_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DEA58397F57
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The pull request you sent on Fri, 3 Apr 2026 08:54:50 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260403

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e41255ce7acc4a3412ecdaa74b32deee980d27f7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

