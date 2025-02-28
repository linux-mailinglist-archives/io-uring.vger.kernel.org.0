Return-Path: <io-uring+bounces-6862-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59B99A4A0C8
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 18:48:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D25F17274D
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 17:48:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44DC51F4CB1;
	Fri, 28 Feb 2025 17:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDLspk7g"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201851F4CAE
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 17:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740764914; cv=none; b=Ujv/pEVW1U8xdWBFOnBJgrL6bOryOeydnF31sA7Cuymkigqor0bGaU/XCxK0L1Yxszm6xdWd2jBldFVmITwfVrciKrLbzbLfvqUoNqs/lGSDX6DHWGemVqzvzC9fjIFDyjpvUFj+jPtfOwfCX0J3yaGNJAWMOgOVVw1Vo0rnkgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740764914; c=relaxed/simple;
	bh=BWsqRNi/dzS7Jm+/vx4NqpIs9VJYrOnTL72DTZwpVwY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=c6xJhCx7G2DtojYn+R/XwIZhr1eCnMSLaG3z0MIpkTFR16jbNceEE0enNynT1NbXO4ok14NTNfyMQYCh7LeI49kIB/EKfX3WI6LItbbPk8Hz/nLVnCWEqOL47u1hczH7vPhshAyO0GrE0u9CTq1NOSoQZWiepgEAcUjUZ+tBM5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDLspk7g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F383DC4CED6;
	Fri, 28 Feb 2025 17:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740764914;
	bh=BWsqRNi/dzS7Jm+/vx4NqpIs9VJYrOnTL72DTZwpVwY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kDLspk7gLqNgAGYYYuk1fetzUq6It8+sT7ZMYiPHKUn74doxTl5Zn+0BmKBSvvbPL
	 e8u3+O9sffFxSRDGSRVE3FEH8MBK4PoiITziua9X+yR3IY/Obd3DxnicwFp6nNKlGW
	 99nKthBM7dYCeTzn2xniPcUC97OKidtSVbvd12tQC5IeSZ/kzBOma/5rwWUcI2bKim
	 Q7vpSRY3Yp68U0yHBhkZoAfifDDShgkUlrGDeByesQN/PisNRFiSCGvn8jYnznFoWW
	 gTlDIMTOVMOwBL6YkpRf+GC9djJTqsNf7E5zFB5ceACvniI/Y12aJDU+UHPOA9NCGJ
	 R8rj1t3QW2Gxg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70E4D380CFF1;
	Fri, 28 Feb 2025 17:49:07 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.14-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <6978bfa0-3fb0-4a4b-8961-56996d3f92d7@kernel.dk>
References: <6978bfa0-3fb0-4a4b-8961-56996d3f92d7@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <6978bfa0-3fb0-4a4b-8961-56996d3f92d7@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.14-20250228
X-PR-Tracked-Commit-Id: 6ebf05189dfc6d0d597c99a6448a4d1064439a18
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3e5d15dd83e110da062d825be985529aa1d44029
Message-Id: <174076494603.2226632.17157737039361942034.pr-tracker-bot@kernel.org>
Date: Fri, 28 Feb 2025 17:49:06 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 28 Feb 2025 07:10:38 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.14-20250228

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3e5d15dd83e110da062d825be985529aa1d44029

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

