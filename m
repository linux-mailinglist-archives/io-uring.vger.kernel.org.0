Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B215E279BD4
	for <lists+io-uring@lfdr.de>; Sat, 26 Sep 2020 20:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbgIZSXt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Sep 2020 14:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbgIZSXt (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 26 Sep 2020 14:23:49 -0400
Subject: Re: [GIT PULL] io_uring fixes for 5.9-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601144629;
        bh=CCaPW70/W86IyoAzp3UaS/yVMAYKLN1wJjuCAZct1B0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=g3VJzzQsm7PUYJ+rfWDs+Qxt3lUXyZ2MFYsuyVLgz0d8CJRwwJphFghgT5er73+d2
         qIB2eKbcizmbpKVazn6YRUSnwOI+p/N2RLj6HtKiXtMLe2UACWdw7qtH6PVDtn94G2
         QDigfr8B33rFU/GJOP1CxojRwiDiju7MyHHMJy5M=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <e5c4b3b9-84c2-adf8-6449-459524695431@kernel.dk>
References: <e5c4b3b9-84c2-adf8-6449-459524695431@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <e5c4b3b9-84c2-adf8-6449-459524695431@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-09-25
X-PR-Tracked-Commit-Id: f38c7e3abfba9a9e180b34f642254c43782e7ffe
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 692495baa377e373cc9cd930af03e9b8b77eacdf
Message-Id: <160114462898.21242.9643825992755912152.pr-tracker-bot@kernel.org>
Date:   Sat, 26 Sep 2020 18:23:48 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 26 Sep 2020 04:38:07 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-09-25

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/692495baa377e373cc9cd930af03e9b8b77eacdf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
