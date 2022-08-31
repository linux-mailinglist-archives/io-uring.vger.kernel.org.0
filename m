Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E31D5A841E
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 19:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiHaRUG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Aug 2022 13:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiHaRUE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Aug 2022 13:20:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAEC1704E;
        Wed, 31 Aug 2022 10:20:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CC0361AC6;
        Wed, 31 Aug 2022 17:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF9D4C433D7;
        Wed, 31 Aug 2022 17:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661966401;
        bh=WTWRD0BewWcybzs3Gf+UKMcXSrO+Qg55dE7q+/5iXR4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=o6Pg/kvY7owQVkNAjaF/sjL4BWe/hbRYMWSxTCwG5p1unRXA8bTqhQ801fw4DlqAT
         i9/ltxMRgGVWErUYJo7Nk4yiyrL3Mi1QGORCbX7dcNOMRXqZeFv8VnWTXTdkGljPYC
         uxOfz2D1wCd9A0LB0FSyKcZ0k+gxaSD7AtaZUgSlq7lkDLKDvRGDjSRHVguoZzdoTM
         MOL3V0UaXL3JGYctgX6DELG4/LPvnzPknMPWmfIh3K0gFo40tKYyej39xIk0cXfemc
         rj1k1ZO55j4/Y29FdZJK6V3PQ+mRdVf8sG6xhze++8Z1BbxifAF1gMOQRNeU037wjo
         8GXTUJYqj5tDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA784C4166F;
        Wed, 31 Aug 2022 17:20:01 +0000 (UTC)
Subject: Re: [GIT PULL] LSM fixes for v6.0 (#1)
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAHC9VhQu7vuXMqpTzdZp2+M4pBZXDdWs7FtWdEt_3abW-ArUDA@mail.gmail.com>
References: <CAHC9VhQu7vuXMqpTzdZp2+M4pBZXDdWs7FtWdEt_3abW-ArUDA@mail.gmail.com>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAHC9VhQu7vuXMqpTzdZp2+M4pBZXDdWs7FtWdEt_3abW-ArUDA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/lsm.git tags/lsm-pr-20220829
X-PR-Tracked-Commit-Id: dd9373402280cf4715fdc8fd5070f7d039e43511
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9c9d1896fa92e05e7af5a7a47e335f834aa4248c
Message-Id: <166196640167.5012.16214012113976106407.pr-tracker-bot@kernel.org>
Date:   Wed, 31 Aug 2022 17:20:01 +0000
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        selinux@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Mon, 29 Aug 2022 17:02:28 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/lsm.git tags/lsm-pr-20220829

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9c9d1896fa92e05e7af5a7a47e335f834aa4248c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
