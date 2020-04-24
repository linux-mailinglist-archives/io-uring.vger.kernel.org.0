Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840DF1B8126
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2020 22:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDXUuc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Apr 2020 16:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgDXUuT (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 24 Apr 2020 16:50:19 -0400
Subject: Re: [GIT PULL] io_uring fix for 5.7-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587761418;
        bh=JBc8Q4B5dHQlVAhtjEr935D5LS3lXUxL+JC1c5ZHMxw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=loInxj8nmvULX7CrOe9liqfsC0NBGB16V90k/1ZNREUIRs/Apl6uXrQg1vL5iPeFU
         GZifDqq27bPMbqqK7X2JsykXZqRAxXvX0mZyScejc9FfLdATvZUUNO1FDQxMm9tEBW
         lWGb6Xhk71EZ/yS05XyrRCZp0BOr1pt+rW/nLhkQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <156f8353-5841-39ad-3bc2-af9cadac3c71@kernel.dk>
References: <156f8353-5841-39ad-3bc2-af9cadac3c71@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <156f8353-5841-39ad-3bc2-af9cadac3c71@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.7-2020-04-24
X-PR-Tracked-Commit-Id: 44575a67314b3768d4415252271e8f60c5c70118
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aee1a009c9d247756b368890e3f886174776d3db
Message-Id: <158776141880.11860.3329559796611263665.pr-tracker-bot@kernel.org>
Date:   Fri, 24 Apr 2020 20:50:18 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 24 Apr 2020 12:03:28 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.7-2020-04-24

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aee1a009c9d247756b368890e3f886174776d3db

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
