Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1655638E5
	for <lists+io-uring@lfdr.de>; Fri,  1 Jul 2022 20:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiGASCo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Jul 2022 14:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiGASCl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Jul 2022 14:02:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0563FDAC
        for <io-uring@vger.kernel.org>; Fri,  1 Jul 2022 11:02:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C2F2B83119
        for <io-uring@vger.kernel.org>; Fri,  1 Jul 2022 18:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34935C341CD;
        Fri,  1 Jul 2022 18:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656698559;
        bh=FKQO3sp6Y835XHyC4GFwZCHHu4DZglFiixz4LU0ZfMs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=oN81w9FZ2pFBDgaSRKmaTzuSD1XQ3BZi1PKnTDEzwKkxZJXQ0ZNdEzjT8HEWTM7rV
         RqckLH+8DU9GdcYkh2q5MtmZag80zH3vjfhSkMXU/2+2g6N+Za9T8MCfppYV4GLeuN
         7Q6kYWA759ZREnjGFNg5r1embMK00ShnQTKgO8L2pqAfFaEdaD6gODZvAWvNyU/dnA
         Z4gk/yfl5Nt/oSLSQtesJflCPAvNv1UOvi9xqqfJLDjAimZ+dU9kFixSHtXOPVJPro
         tlIRqcJeYR7Esic+Xwhx/Qtm7ezqfnl63HnM+G7mLrzsxe7hJqMxDb3tedmYRkNqoO
         lN4AilVilmt0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1FCC5E49BB8;
        Fri,  1 Jul 2022 18:02:39 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 5.19-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <4cfbd928-95d2-f183-5d6e-2e514d85d0f0@kernel.dk>
References: <4cfbd928-95d2-f183-5d6e-2e514d85d0f0@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <4cfbd928-95d2-f183-5d6e-2e514d85d0f0@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-07-01
X-PR-Tracked-Commit-Id: 09007af2b627f0f195c6c53c4829b285cc3990ec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0a35d1622d5cd7693d75b7124913c75a7e3fabd0
Message-Id: <165669855912.14842.13943559868151586846.pr-tracker-bot@kernel.org>
Date:   Fri, 01 Jul 2022 18:02:39 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 1 Jul 2022 09:31:56 -0600:

> git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-07-01

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0a35d1622d5cd7693d75b7124913c75a7e3fabd0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
