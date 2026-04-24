Return-Path: <io-uring+bounces-13140-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OH1kIsPs62lHTAAAu9opvQ
	(envelope-from <io-uring+bounces-13140-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 25 Apr 2026 00:20:51 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 87C34463C6A
	for <lists+io-uring@lfdr.de>; Sat, 25 Apr 2026 00:20:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C64CA3009835
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 22:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB5426059D;
	Fri, 24 Apr 2026 22:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPGa605a"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A820EEC0
	for <io-uring@vger.kernel.org>; Fri, 24 Apr 2026 22:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777069244; cv=none; b=ZTtbxbVW0vvrd1QrJGmGNUi6ytECkIsF/BfGPlGdnt/RXjB4+dQR9CiIW0c1wFOhO1wG1lkXC9kI/BBAU9m6SUXA+4AwEhoUf/cenzoz6D/bHQutoL9IBaK5XZY1+UIa5TtZrAWyw6gR+L7chJj8S17rv4PPBEkQzzEVFe19ioM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777069244; c=relaxed/simple;
	bh=Nga4X+PbH/W3WVVjbqyShFdUNjF3iwlHlDf2h1TZym8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ginYe5Wxf1w/qgsf9ZoNUEA0kAucwKZcL71RxzFNmXpn2CfKMzxYEVnLM6R6+7CQRLi6UfQrr3bwGwyP36n6PFlRyxt9ExLsy8LsZ6cqy3i6aS7Ptyo8WbVZRFJMALqcWm5xtQKEE9Ev4W1mWlj3uL4x+SGF9hto7UIz32O3tCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPGa605a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A805C19425;
	Fri, 24 Apr 2026 22:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777069244;
	bh=Nga4X+PbH/W3WVVjbqyShFdUNjF3iwlHlDf2h1TZym8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hPGa605a/dGOC+c9XD5AUyH3jq1lzhIkSa4DvYL6bpHdQ9Y0igmAv2eGnnFnCejAw
	 h0ogaDKJAzroxYlZBVltz0Xlu/au++Y4FtkNPg5JvJrp6AI6cqHN0Btnm9teyML/x6
	 AG2k0lahnp78UAlb4wHyIQdTTL0I/H+nHbiaQB2k9BmX0BbXy5RWHTrmAoaqxU7qpK
	 JmEqg/BUV0Y6E8sKbkM03M4uOIL58K/AG2CfSDep+MayyR2RbSupqs+iyqrirWsgKm
	 SNTfjtyO46Ay/qmNxeAIxlGy6SJNO+9R+8nNQ5EOcDCcYY6tPkk0qAp+2ApFcwzOZa
	 6186i625JisRQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9F7938119C3;
	Fri, 24 Apr 2026 22:20:05 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <9897da58-1661-4bd8-80d3-0e6708b8c0d7@kernel.dk>
References: <9897da58-1661-4bd8-80d3-0e6708b8c0d7@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <9897da58-1661-4bd8-80d3-0e6708b8c0d7@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260424
X-PR-Tracked-Commit-Id: d0be8884f56b0b800cd8966e37ce23417cd5044e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fa58e6e9000c1cc76a7a0c06ea3e68d728cc4247
Message-Id: <177706920478.1737979.14108965520437617374.pr-tracker-bot@kernel.org>
Date: Fri, 24 Apr 2026 22:20:04 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: 87C34463C6A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-13140-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

The pull request you sent on Fri, 24 Apr 2026 09:19:14 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260424

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fa58e6e9000c1cc76a7a0c06ea3e68d728cc4247

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

