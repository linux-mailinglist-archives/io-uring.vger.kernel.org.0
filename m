Return-Path: <io-uring+bounces-7286-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14CA1A75257
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:10:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 956D517126D
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 22:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5513F1F09B0;
	Fri, 28 Mar 2025 22:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JS7pzWnp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFDD1E835F
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 22:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743199832; cv=none; b=AtXHmm1Qm7MI+FXmCms2yPisqMEopv0iHrkzZG+7IwQGkndbD6ChGRXl5eJtCfJ9tyZlI5ZwaFrt2cG9pxs+rx3zNEmRgwP6gI/wxEPo18Nb2yoVq0CKvc9lNrm5DBlH29mUAExat3ipF7Jt1LraJ8gKcKSfncG8jUO51jdXK2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743199832; c=relaxed/simple;
	bh=Z4nZM1m5j2jT/GzcDwtL4FSzsRlFeid5Nhkk3tiMs7Q=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=kEsUFLQCXOo5YGMqsA9Ytnl5QTC84tAhFs+op1P3hqeyuklXviygAlxHS6cXvbJ7CYGkFjsowuKONxgdsRJQikder5ToGU+i+KFyfVRF8f7m3qVYZzWFdGELNNCGJWLUrzww32C2Vx6+QlUghVdTh//gi/5z/RFwww5R2hKpkbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JS7pzWnp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0493AC4CEE4;
	Fri, 28 Mar 2025 22:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743199832;
	bh=Z4nZM1m5j2jT/GzcDwtL4FSzsRlFeid5Nhkk3tiMs7Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JS7pzWnpmP5nu+ij97VFN4YXpvDQ3/e1GtB87Dtlvh8ciyI9OQLVaqyI6XU0kNrbW
	 16O6TtBlKTxAFH4AgbkzcfSgTBhyrkNHaJqw8pqe0YjTx9PKwKpn7QwTDPrGpmpinf
	 FZTNCr67MKWJjNqI0v8hu04ezn4iLrazdp7tBm7o5sox9l9GUiBMx2CZOoMGugktay
	 Xt8LzwTmmTGq3OP+8ZXzH4S21FapQoYjqlguP2WteF6yDR866no4yJVhQZpPEoRbdQ
	 LR3s1N2miaEqOKGkm4R9JGezgNQ21O5zKFBWCpXscpt1dpIbJ7K3rk2qtsnAqwhffZ
	 FfS60P8hrjojA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADCE83805D89;
	Fri, 28 Mar 2025 22:11:09 +0000 (UTC)
Subject: Re: [GIT PULL] Final io_uring updates/fixes for 6.15-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <7994e6dd-e5da-4527-b08b-337b5cb3e3dd@kernel.dk>
References: <7994e6dd-e5da-4527-b08b-337b5cb3e3dd@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <7994e6dd-e5da-4527-b08b-337b5cb3e3dd@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.15/io_uring-reg-vec-20250327
X-PR-Tracked-Commit-Id: 6889ae1b4df1579bcdffef023e2ea9a982565dff
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: eff5f16bfd87ae48c56751741af41a825d5d4618
Message-Id: <174319986817.2977572.11092009295745358353.pr-tracker-bot@kernel.org>
Date: Fri, 28 Mar 2025 22:11:08 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 27 Mar 2025 08:38:25 -0600:

> git://git.kernel.dk/linux.git tags/for-6.15/io_uring-reg-vec-20250327

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/eff5f16bfd87ae48c56751741af41a825d5d4618

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

