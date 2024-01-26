Return-Path: <io-uring+bounces-488-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F1F83E6D9
	for <lists+io-uring@lfdr.de>; Sat, 27 Jan 2024 00:25:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 328251F2AB69
	for <lists+io-uring@lfdr.de>; Fri, 26 Jan 2024 23:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6965EE89;
	Fri, 26 Jan 2024 23:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cAZmdZyi"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5675EE72
	for <io-uring@vger.kernel.org>; Fri, 26 Jan 2024 23:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706311327; cv=none; b=Zrze3STFBndIjnvH3iS/ZG4KBgXw4i6hJrsc2mdq69jeM5AlZlRj0jH9/I937Hh2X11LYbMakqGKJD9dPXJ5Fe/GwGyLXuIm7r9zI2eNe2348oXp95tEfQwVsNuXPdS5KawP0KtT3nRMsjbasNkQLxh1WBy+A9LYVPDDNt5KiXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706311327; c=relaxed/simple;
	bh=Sxj6bqWz0Yl7ZyP1XoGEGLEiIQDsdqc2EPyVkXgbmNQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=RP853mt7a0lg3ClXBoGVzwKZnCyEqr3Y75ixShULMUIAlFJo/yDCMUQvS+knDeOHxAJHrwUEoTLPoAbT5cyBQfVS8sHotyeXGqT63eqRLbYXbp2HPO1SN3rNBelwFVF8gIxTZIGxTw5Glr18g5jZh6Egd5iNpDiNfYdaywGMiRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cAZmdZyi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 806DEC43390;
	Fri, 26 Jan 2024 23:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706311327;
	bh=Sxj6bqWz0Yl7ZyP1XoGEGLEiIQDsdqc2EPyVkXgbmNQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cAZmdZyiA6VPqlPJFUjICnY9i/ordHmIk6zct+oCsAolGs+Q6M9nG0jvOvOuIFQ3J
	 MY0KVmtFMrinUKrx5Bd7rnUGxwJ3+Me4W7uY5Eew0lwEysPGrXE6TiCuhf3UI4x6qM
	 IKNZ5HSHTRlkG+5XLTWAL7IS3tfhcziIa50QeHwtpFnAfnZzc307gQq8WXF3EpBu1y
	 ztFxGbbHRMqgjIUZcF33FjEkkbiBxY16BjLiP31tJr7c/uPg7TYXZVPqPjFAKk51p/
	 Sx6+XPimBxgMeMIbRHKfPl/0uCndrPhuJXu2iCtaAkmDTsa0mQ3aAsoC4ZIl/XnXI+
	 BmMTiQK4vyncA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6FCE6DFF760;
	Fri, 26 Jan 2024 23:22:07 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.8-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <6f96ec57-ae11-4ce3-af26-1bd7eccdc248@kernel.dk>
References: <6f96ec57-ae11-4ce3-af26-1bd7eccdc248@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <6f96ec57-ae11-4ce3-af26-1bd7eccdc248@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.8-2024-01-26
X-PR-Tracked-Commit-Id: 16bae3e1377846734ec6b87eee459c0f3551692c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cced1c5e72b7466e6c9091370eaf5d55a4ddeecb
Message-Id: <170631132745.4030.7851417721747844507.pr-tracker-bot@kernel.org>
Date: Fri, 26 Jan 2024 23:22:07 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 26 Jan 2024 11:25:13 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.8-2024-01-26

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cced1c5e72b7466e6c9091370eaf5d55a4ddeecb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

