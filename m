Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C8C57E7EE
	for <lists+io-uring@lfdr.de>; Fri, 22 Jul 2022 22:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbiGVUH6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jul 2022 16:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236698AbiGVUHz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jul 2022 16:07:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F41A723D
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 13:07:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C9B961F5E
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 20:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA893C341C6;
        Fri, 22 Jul 2022 20:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658520473;
        bh=MuRQEsTSPZI+QRvv2sAElqcKZX+mrg75Wig2W3x7PF8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=OLMehETwafWvHEvUvHWYAXMTyANa+YBQRD+ZKM/bVsEsJ/H/RoWTpQYPC1ZqD/lxI
         yTkeJzu87rWvlcs0Z2x+D3ktrE8LlWxujBrcND8QAEfNfemP/ELHUYIoE7CnyfxGez
         PMyJcRmMkmGfIRkJ1/H7Nb/oxTOp1+99NRmXOzYdudEwHBA+vEKqSwNbfKFcwisHTY
         uTbjTcMzxZIokWT9iXsd3/p8AfPVoonu+FsXCq2DVQ8RbvcO5HsTTyt4LXZkKzO8Sq
         6KPkXVQLCFS31eG+dUs8Q8+IHKzetGgy2gjC9QOb5altvSiadyp7v7UZtxBHQKMJt1
         iZi0mTb/Wtgow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4A61D9DDDD;
        Fri, 22 Jul 2022 20:07:53 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.19-rc8
From:   pr-tracker-bot@kernel.org
In-Reply-To: <bb6d41af-7343-a8c5-92c9-100e13fe43a1@kernel.dk>
References: <bb6d41af-7343-a8c5-92c9-100e13fe43a1@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <bb6d41af-7343-a8c5-92c9-100e13fe43a1@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-07-21
X-PR-Tracked-Commit-Id: 934447a603b22d98f45a679115d8402e1efdd0f7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a5235996e1b04405fbd6deea37b051715214fd2a
Message-Id: <165852047373.15752.6283063404763887610.pr-tracker-bot@kernel.org>
Date:   Fri, 22 Jul 2022 20:07:53 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 22 Jul 2022 10:18:45 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-07-21

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a5235996e1b04405fbd6deea37b051715214fd2a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
