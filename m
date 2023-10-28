Return-Path: <io-uring+bounces-3-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B5AC7DA44C
	for <lists+io-uring@lfdr.de>; Sat, 28 Oct 2023 02:14:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFF14B21577
	for <lists+io-uring@lfdr.de>; Sat, 28 Oct 2023 00:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED616385;
	Sat, 28 Oct 2023 00:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPtPc0Li"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAC537E
	for <io-uring@vger.kernel.org>; Sat, 28 Oct 2023 00:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B199C433C8;
	Sat, 28 Oct 2023 00:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698452088;
	bh=vDJGvrfqRAQ0jqnE4iQVQThr75fbkWOvuxnz1YIZmFg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=aPtPc0LiN58+pAvsZA+IynzjpJbalMr8VsRNOsmeOS7xxMOp+a7WUP9mcHtt4gIye
	 fwypVgwYE22ep24zCnf/qfYu5CaGUjekczMiKPJqYg0N4ge0df0UiArvh5VR/taOFn
	 DWPimGjzXGAC478RmUicoEbqTohokffsTvpTXuvOQ2xqM6Gm72Wz1j0Hu+uPM9jKJY
	 kPCRvozLWkGvdSxHRzkzssi/3Cct/f5NxHUA8bk3jUm6XSVByOng5q0BRA90Or6uuv
	 X+L3ZsRyqxciLbbJi56tJAld1B1JMT2WU7I0/rr1nzeZNSsVx70nip3uwW9O5sLk6b
	 Df5cStW4I94xA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 355FDC04E32;
	Sat, 28 Oct 2023 00:14:48 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.6-final
From: pr-tracker-bot@kernel.org
In-Reply-To: <4d88d020-6d8d-4662-b2d3-abd43ebe0d61@kernel.dk>
References: <4d88d020-6d8d-4662-b2d3-abd43ebe0d61@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <4d88d020-6d8d-4662-b2d3-abd43ebe0d61@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-10-27
X-PR-Tracked-Commit-Id: 838b35bb6a89c36da07ca39520ec071d9250334d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 56567a20b22bdbf85c3e55eee3bf2bd23fa2f108
Message-Id: <169845208821.29306.8541461646795853497.pr-tracker-bot@kernel.org>
Date: Sat, 28 Oct 2023 00:14:48 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 27 Oct 2023 13:53:52 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-10-27

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/56567a20b22bdbf85c3e55eee3bf2bd23fa2f108

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

