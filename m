Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B956593EF
	for <lists+io-uring@lfdr.de>; Fri, 30 Dec 2022 02:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbiL3BBK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Dec 2022 20:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiL3BBI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Dec 2022 20:01:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3CB62D1
        for <io-uring@vger.kernel.org>; Thu, 29 Dec 2022 17:01:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB81B61A01
        for <io-uring@vger.kernel.org>; Fri, 30 Dec 2022 01:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F1F5C433D2;
        Fri, 30 Dec 2022 01:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672362067;
        bh=J9J3+BjZLAK0RHZr5ul+Z0XJnrGb08uVzf/XiH75xPA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=qkbAzEBTGQnWav1H+B6wyKOPUmlNwA7IcKKY7NIzoyCsYFhTEZPK6AD6sbJrKWzfx
         ndgToCHrKkv1NVa+OVFCKvsamdhpLlWnSeBAhfFJhGgSqNt9Bc7MqqK/GPE8iTOAqJ
         4peWN2PCu4uWpjQXHiwn8mKuZjViOLqSkoEmjUDpdounYxZsdKk6A2P7aqO88vI72A
         j0IWBwxjRtsTmUW0VAgHsOJNmodErJrpmMLF/VFBHC2P6ssdFBjpKr+AAYd1UyHd9x
         R9saena8KXT5qGqED/RiteQoyM+n0G7h6OQeDZWsGteuqVPM5P3swpFpLB4L2gvNhy
         sxTV0u7VW/VgA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D2B3C197B4;
        Fri, 30 Dec 2022 01:01:07 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.2-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <89c38b66-a3eb-1674-a135-d905de0264c6@kernel.dk>
References: <89c38b66-a3eb-1674-a135-d905de0264c6@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <89c38b66-a3eb-1674-a135-d905de0264c6@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.2-2022-12-29
X-PR-Tracked-Commit-Id: 9eb803402a2a83400c6c6afd900e3b7c87c06816
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ac787ffa5a246e53675ae93294420ea948600818
Message-Id: <167236206718.9684.1490636779591539327.pr-tracker-bot@kernel.org>
Date:   Fri, 30 Dec 2022 01:01:07 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Thu, 29 Dec 2022 16:32:57 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.2-2022-12-29

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ac787ffa5a246e53675ae93294420ea948600818

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
