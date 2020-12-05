Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61922CFFAC
	for <lists+io-uring@lfdr.de>; Sun,  6 Dec 2020 00:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgLEXP0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Dec 2020 18:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEXPZ (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 5 Dec 2020 18:15:25 -0500
Subject: Re: [GIT PULL] io_uring fix for 5.10-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607210085;
        bh=5D+eqg/mBxg5orM5dw9g0nAkEm6gBeQftgTuVovG3dE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=hbptiY0BhBNQ46P9aGFSjR1KDJi3+x5lINGsYDW3HMZxJu457As53D8Z4EjF4FfLW
         vwfhRYM0RG0eTtRu6e9PSAZy+uzUjQSGoq5azqZ2JF7WICcjRtTmKqEAeWpETEdRGc
         1db+IfBmhrd51nWuaom5r94gj8KPUTT/rZ5qRMd/9NLBPAVlOgMyc5hiv2vMA5f8+z
         jLepHioj0duEctfCH02x9lQ0h6k4mZo+m+ANP4rglFWjeVJiLeKqXdZCOLr4uMopO7
         Gjvakh0NyjanZwnxlESI3nB+E+BmasUG/l0wTKdSgcP8UGYOKJSd9C+EDFFS5hYyXb
         wS72Sq5Hicu7A==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <80f174fa-70b6-827e-17b9-e120cb65ec34@kernel.dk>
References: <80f174fa-70b6-827e-17b9-e120cb65ec34@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <80f174fa-70b6-827e-17b9-e120cb65ec34@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-12-05
X-PR-Tracked-Commit-Id: 2d280bc8930ba9ed1705cfd548c6c8924949eaf1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 619ca2664cc6ebf6ecaff347d15ee8093b634e0c
Message-Id: <160721008538.18780.9612498739793230252.pr-tracker-bot@kernel.org>
Date:   Sat, 05 Dec 2020 23:14:45 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 5 Dec 2020 14:42:42 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-12-05

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/619ca2664cc6ebf6ecaff347d15ee8093b634e0c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
