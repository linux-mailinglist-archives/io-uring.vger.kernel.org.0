Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D68C153F9D
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 09:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgBFIAS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 03:00:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727874AbgBFIAR (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 6 Feb 2020 03:00:17 -0500
Subject: Re: [GIT PULL] io_uring fixes for 5.6-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580976016;
        bh=3Z4nVUCvy1AmCLhgXTrp7YHVxDv1FFUtpXKT3OzbeOw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=MyB53JI0phGl3H+PyH6CaRTz1l4jtqO9ue14B6cozc/Dfm94MXSl4VFfGcs0bZe6s
         f8L0mg6NyCUXv35w+c+OQ4QJ0T+BE0jD5/rv2g8hXvZsW0g8Cb3/oe1gu83qdrAW+w
         paunmJ//VMfMRpxIm9DV8QU5b9i2x1pCmIXMIHO0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <457eea2f-d344-fa09-7ddb-77ce4cb85aff@kernel.dk>
References: <457eea2f-d344-fa09-7ddb-77ce4cb85aff@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <457eea2f-d344-fa09-7ddb-77ce4cb85aff@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.6-2020-02-05
X-PR-Tracked-Commit-Id: 2faf852d1be8a4960d328492298da6448cca0279
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c1ef57a3a3f5e69e98baf89055b423da62791c13
Message-Id: <158097601679.20426.12262983573989939498.pr-tracker-bot@kernel.org>
Date:   Thu, 06 Feb 2020 08:00:16 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Wed, 5 Feb 2020 14:26:29 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.6-2020-02-05

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c1ef57a3a3f5e69e98baf89055b423da62791c13

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
