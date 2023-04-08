Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E986DBC82
	for <lists+io-uring@lfdr.de>; Sat,  8 Apr 2023 21:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjDHTBT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Apr 2023 15:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjDHTBR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Apr 2023 15:01:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A58572B6
        for <io-uring@vger.kernel.org>; Sat,  8 Apr 2023 12:01:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3911360A3D
        for <io-uring@vger.kernel.org>; Sat,  8 Apr 2023 19:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2639C433EF;
        Sat,  8 Apr 2023 19:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680980475;
        bh=OvT5pjALMvXM4pAs4Kjv5YPBj9A+GFWedF9mZ6jYPGw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=k6xzm0+FLeKpFw4lkTdYPVbdIWiYmemi+ERfx3zWpwuBf6rJFPI0ihAtwnkPs9rwi
         Yr3g5leX+W/9q2l7Cgk3uPBuH5fU6n2wBHg+0CggaCO+y61xlFTf8rk9bpxJUx1UjI
         NoI6jC8ADDLI4z6x2edR9o3EH0k2Fvih6RX+q2D9mqx7k70Vf3OqvKjI89Yln6XZxi
         JDlq+0VOs7yrZdF/pBhDiYvdSetU+26CF85bEGSufYMs7kRs2bHf3K7XlKcRGMr9wx
         atoImyqHfszKmdhp3PDovO2gkn0xGL8Eg8Cz3dnRVA1pUiJgyWbirpVDiZ6CVH1hoj
         lCccVwulMiNRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 907E0C4167B;
        Sat,  8 Apr 2023 19:01:15 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.3-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <07df0b3d-4086-d2a4-efa8-0229579726fa@kernel.dk>
References: <07df0b3d-4086-d2a4-efa8-0229579726fa@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <07df0b3d-4086-d2a4-efa8-0229579726fa@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-04-06
X-PR-Tracked-Commit-Id: b4a72c0589fdea6259720375426179888969d6a2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d3f05a4c428565163f26b5d34f60f02ee4ea4009
Message-Id: <168098047558.1995.6791483529172437058.pr-tracker-bot@kernel.org>
Date:   Sat, 08 Apr 2023 19:01:15 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 7 Apr 2023 10:48:12 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-04-06

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d3f05a4c428565163f26b5d34f60f02ee4ea4009

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
