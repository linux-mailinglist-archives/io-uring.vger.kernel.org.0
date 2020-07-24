Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D5E22D142
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 23:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgGXVkH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 17:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbgGXVkG (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 24 Jul 2020 17:40:06 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.8-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595626806;
        bh=0+600BdVgHoptk4/RtcfOxs3DdcwnpXeQwal0/gJBcI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=eJYDmW1t3qOqGR5HkPSvYn2MJqvhkjo80sOevbwJ2MGybM2g1OH3WmvOsZ+t3Iawn
         z+gg+Gzj5od6l5WoLsnhmBAb68pTnOFrTe6CZXXKDez5iFCEViu2YO4JmjXWcSxOvI
         RaT4OTV64w3EgSJwX2xTdeotbQgasLBv7hqRob/4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <c07ebe12-2b16-3811-9abc-d3e8d99b54db@kernel.dk>
References: <c07ebe12-2b16-3811-9abc-d3e8d99b54db@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <c07ebe12-2b16-3811-9abc-d3e8d99b54db@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.8-2020-07-24
X-PR-Tracked-Commit-Id: 3e863ea3bb1a2203ae648eb272db0ce6a1a2072c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1f68f31b51507e1ad647aa3a43c295eb024490ad
Message-Id: <159562680626.3064.10524082755470255037.pr-tracker-bot@kernel.org>
Date:   Fri, 24 Jul 2020 21:40:06 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 24 Jul 2020 10:49:14 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-07-24

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1f68f31b51507e1ad647aa3a43c295eb024490ad

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
