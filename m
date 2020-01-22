Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9C5145A17
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 17:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgAVQpD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 11:45:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgAVQpD (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 22 Jan 2020 11:45:03 -0500
Subject: Re: [GIT PULL] io_uring fix for 5.5-final
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579711503;
        bh=uGjrTHCdwEkaGz0TKkWQ87s36aRmGMZyWxrsVLcn7Jk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ZBKBQMHYJNZVqWzwFEzIpoIf234hJP3DXZ3+13DpLuN56vMkhtQ0J8yB43gaeYr4K
         7JWsEAeRh6qaO5m5mlZXVQ0fCp6ZFWiuz8s66FTwK7nDXPEjpPGuPQORH0ZbirtGtJ
         uQle6ThI0aWNMDFdxO4Z07pA1doxrG5TseMKY0oI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <98957d45-ad2a-9505-9771-63828538f3bf@kernel.dk>
References: <98957d45-ad2a-9505-9771-63828538f3bf@kernel.dk>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <98957d45-ad2a-9505-9771-63828538f3bf@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git
 tags/io_uring-5.5-2020-01-22
X-PR-Tracked-Commit-Id: 1292e972fff2b2d81e139e0c2fe5f50249e78c58
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dbab40bdb42c03ab12096d4aaf2dbef3fb55282c
Message-Id: <157971150312.16455.7117089842496735430.pr-tracker-bot@kernel.org>
Date:   Wed, 22 Jan 2020 16:45:03 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Wed, 22 Jan 2020 08:51:31 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.5-2020-01-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dbab40bdb42c03ab12096d4aaf2dbef3fb55282c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
