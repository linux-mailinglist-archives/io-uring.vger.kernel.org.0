Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630571AE3FC
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2020 19:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgDQRph (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Apr 2020 13:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729980AbgDQRpY (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 17 Apr 2020 13:45:24 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.7-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587145524;
        bh=wGk0LXuZYBVR4hODFAnkMfse1qV2ImAwUBFhTCPCsXU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=D2ZS4ftf/zf8JrsZuMXHfCM9dv1zj9CKEhLL5Nt3BK1umkiDsyDxbM0PsdfJ/AWxI
         sTJrwxQcuz6ThyHATDJCQdv1ZYqbTPslNFKD/F9cDCSjDZw/dDlLJrUZJtXzxpbRZq
         Iq5tfAAScDaY5mwjeMBRu1z179sIeVQMWJocG6XE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <2750fd4f-8edc-18c2-1991-c1dc794a431f@kernel.dk>
References: <2750fd4f-8edc-18c2-1991-c1dc794a431f@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <2750fd4f-8edc-18c2-1991-c1dc794a431f@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.7-2020-04-17
X-PR-Tracked-Commit-Id: 31af27c7cc9f675d93a135dca99e6413f9096f1d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a2286a449baf11624d393aad28c1081cee3f47fb
Message-Id: <158714552412.1625.18228217450522878481.pr-tracker-bot@kernel.org>
Date:   Fri, 17 Apr 2020 17:45:24 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 17 Apr 2020 09:16:38 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.7-2020-04-17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a2286a449baf11624d393aad28c1081cee3f47fb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
