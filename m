Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E693B46865B
	for <lists+io-uring@lfdr.de>; Sat,  4 Dec 2021 17:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355398AbhLDQ71 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Dec 2021 11:59:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53984 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355427AbhLDQ71 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Dec 2021 11:59:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3834860EC0
        for <io-uring@vger.kernel.org>; Sat,  4 Dec 2021 16:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9076EC341C3;
        Sat,  4 Dec 2021 16:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638636960;
        bh=gmBf0vXWOURzvys3DibQ5ri0ndbLYpSMM2F4FIzWclA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=lgdQgoJuP1DWYA3Rtk0un9f9SvSkjQBHE4uattCq7VeUf4RGlnUvzOTdd1zmX71tM
         b8ig4G1acTzV8ywpl0gqlF5yd857CtErlcqdXCE96bIK8nS5f8fO4T0DybqCg7F7Sz
         rUkbQABAoI+P1hMQZJlv3wUhSe3UkipdrMUn/I/aUjKn2+qqC46UK163Y+tKAESkPF
         83JGxPQQ/OqJo37sUU6+c3k6x2jOWtqWWnRkm4AXSnFhXwHfdhQ4dEfDoquYFO+GUx
         rNIeh3s/OltbW7XeH1jIuuM6cw4pED3S9LJ1olZhJ8rUmUbDza2ExfD2NTZ5/r1IZ4
         Yzt9j9j6rHbzA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8011260A94;
        Sat,  4 Dec 2021 16:56:00 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 5.16-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <259cf13f-2013-bf3b-4e73-cf38fb78629b@kernel.dk>
References: <259cf13f-2013-bf3b-4e73-cf38fb78629b@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <259cf13f-2013-bf3b-4e73-cf38fb78629b@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-12-03
X-PR-Tracked-Commit-Id: a226abcd5d427fe9d42efc442818a4a1821e2664
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8b9a02280ebe209ae14fc478b0285745544a257c
Message-Id: <163863696051.3540.7302482791984534604.pr-tracker-bot@kernel.org>
Date:   Sat, 04 Dec 2021 16:56:00 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Sat, 4 Dec 2021 08:17:32 -0700:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-12-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8b9a02280ebe209ae14fc478b0285745544a257c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
