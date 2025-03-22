Return-Path: <io-uring+bounces-7210-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD52EA6CCDB
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 22:45:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F9A47A9D67
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 21:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42CB91BD9C6;
	Sat, 22 Mar 2025 21:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ImBuy/Ye"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED221BDCF
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 21:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742679879; cv=none; b=iNaGP3r7FhwXhafks3JJCPKIC7khjHg6DAMoJwyObMDvX+odoEjiyKKLzYQuorOjGXLprPWBeGBPLzjBnqFUOPr95DR/6amiHolHqxEHZNKQFhW8jK2bjnm96lUC70ddTi5dZu74KwZ+mj/ClCHrPGz2fc2DXdYJeUGR1YYyo4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742679879; c=relaxed/simple;
	bh=Cg8EFAbJCS+32Q7fRo16FYpMQEdEJkq6BimBpLWH4oI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=f4jcuVmrY1UAxfAnnVYnhj7EWPxsaVlwlqsw3O3uspwB+iiepc2cVUwYwmrnpPtQJzWjnf8hyqfMZjvODLWz9/kqt4xJZ/ZKh+puGPwYq0gsqDBO/oe4h4M0mp0a9vNwgL1gMN+9ypjS8S0+MgVdOK64Nkkdh0XjKqsiLOE4784=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ImBuy/Ye; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93407C4CEDD;
	Sat, 22 Mar 2025 21:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742679878;
	bh=Cg8EFAbJCS+32Q7fRo16FYpMQEdEJkq6BimBpLWH4oI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ImBuy/YeVzvdGtY9ls2NVgV7OrD/2mL1KGS9RNbPRhr0aju9kA/U4eTslYDHIcB8q
	 aC3/FJFuqsFoBSgpz/ryl6CwI/dPdRASqY+cJMsC0ktNQIkIeSR2mtNdCn/mhHlyLf
	 b9UIagI43jCLk0cttKLD6TPMJgUjz7NzlRL1vcyy3e1B51tRhBYSQdj+tQx3aEhuSh
	 jSyrpTjqV2g77HuXRaD/FdeJ+6ZXtHZf62g90cf2Ru+RBF7MotiuK6n29Ko/Xz5SdP
	 zuhc5wR0Ft/O1mncuQSRma26/GO1kMaxyuI3PwwlikCQhitwetcyAsh26lA6318QMJ
	 bTz3WlClBdxfg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAD4D380665A;
	Sat, 22 Mar 2025 21:45:15 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.14 final
From: pr-tracker-bot@kernel.org
In-Reply-To: <da6fddfa-f9a5-4c18-9804-320d7efef6a6@kernel.dk>
References: <da6fddfa-f9a5-4c18-9804-320d7efef6a6@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <da6fddfa-f9a5-4c18-9804-320d7efef6a6@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.14-20250322
X-PR-Tracked-Commit-Id: 67c007d6c12da3e456c005083696c20d4498ae72
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bb18645ac1ee5b655f07a70e63ad27213a2596c8
Message-Id: <174267991440.2912834.13192952620028027007.pr-tracker-bot@kernel.org>
Date: Sat, 22 Mar 2025 21:45:14 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 22 Mar 2025 11:14:47 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.14-20250322

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bb18645ac1ee5b655f07a70e63ad27213a2596c8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

