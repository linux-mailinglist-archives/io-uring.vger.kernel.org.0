Return-Path: <io-uring+bounces-616-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 32455858864
	for <lists+io-uring@lfdr.de>; Fri, 16 Feb 2024 23:10:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6C161F229F4
	for <lists+io-uring@lfdr.de>; Fri, 16 Feb 2024 22:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21C2012CDBC;
	Fri, 16 Feb 2024 22:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n0ukwVI+"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1951148FFB
	for <io-uring@vger.kernel.org>; Fri, 16 Feb 2024 22:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708121404; cv=none; b=svacZAfzYzQiM3dVFHJyRINDB1l39LDvNfV9uTsXhF4PVSlv6UmTxNo3XgbPAsN+yu8UPx77oCyV6BiIN5TeECNfGaksgEsQHeu092bcJiMijF7xBfUGtuxpvQwEyTJthMtTUmF70OCtV4nwGKqv0Hebc2UHIk02eVGatK56Xmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708121404; c=relaxed/simple;
	bh=tNXiFjWjCfIUPFEnl1HE9j16T/LN+2b7qzfL1Jnc4xQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eS9BKKWUcPhOsp5XG0P3TFx+VncQSF7oT4RutcvnCUDXMj5s0vjwPHkV4SAUR9rhLXhNCyPgyTNTDNyT8lD+67Qy995Myvri85GKdsaTXQVddXvQIO1UcpLdVuHCXPKXAJjloVl59Ux7bQl23sB4dyIUr6SCjik2JqBGqIUs3MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n0ukwVI+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7532C433F1;
	Fri, 16 Feb 2024 22:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708121403;
	bh=tNXiFjWjCfIUPFEnl1HE9j16T/LN+2b7qzfL1Jnc4xQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=n0ukwVI+n/BmnSOJCGcKOzQsdEDq34WQiAM1CIVwAvDpr699/ZIDg3jJuZSiry6oP
	 VOhxrKlF/RhqYhMAyt5aicxHpPOxT8xdmhKpJLFQ3xTdAXNCEZheLFyma3KUuHCCn3
	 XgXud81NwKby5ZyS0/gJqh2C4ZJrycCY54OUQ1YBErK3E2rXfjONcWcQQf7usWQhpb
	 /2BK2KWz0d7kf47Ypo6lc5X+JJj8mr9Lq0/KRhGXhh7hv5NzK+x4U+xUHGcaqe/U6S
	 rJDbqorczfXNj64/83YFxGHWWtOZ4UfLptj7Ju9iIeIcV9nKrwO+pUXIAuRgF6PutI
	 MTB+wUzU6DAGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AFE7CDC9A08;
	Fri, 16 Feb 2024 22:10:03 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.8-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <117cdb52-5e35-475b-8a05-e6f4da70849c@kernel.dk>
References: <117cdb52-5e35-475b-8a05-e6f4da70849c@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <117cdb52-5e35-475b-8a05-e6f4da70849c@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.8-2024-02-16
X-PR-Tracked-Commit-Id: a37ee9e117ef73bbc2f5c0b31911afd52d229861
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8096015082592cf282fdee9d052aa1d3bbadb805
Message-Id: <170812140370.30067.10410703974597236560.pr-tracker-bot@kernel.org>
Date: Fri, 16 Feb 2024 22:10:03 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 16 Feb 2024 12:11:53 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.8-2024-02-16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8096015082592cf282fdee9d052aa1d3bbadb805

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

