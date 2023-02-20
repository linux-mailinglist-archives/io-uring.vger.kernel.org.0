Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A53A69D6E4
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 00:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbjBTXA0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 18:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbjBTXAX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 18:00:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09859227AA
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 15:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0A7D60F59
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 23:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE360C433A8;
        Mon, 20 Feb 2023 23:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676934018;
        bh=0wY5VXLaR/6dIZeyRkbcV3FCalfxreMaMymmsS4iBmc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=JVTgWAW5yBDRulKAISQ0dOY3VtVaYeD3PIzn9bN4TdmnEMNLa4aUMuOpxfPnN7I0R
         O4eJXXGJd9CJamXYJTouXndefn7FbLA4vUF1WfP5dAFuMVEakLtMzp96OpyDJ8QhCc
         yBucTbx8yuZ6GOWtRMZLuCjUv1efxMJabpVx4uEu1LdkcgyqqPHwxSaBLZx/WV1cKq
         Lc1SPX2SYhDUpCTyo7EVZC0YtFOjukIQHd+TUpIWROixJkHCLD3XQVouLiH/0VI7Br
         AyJepAEBtym1AF1wpuStQ0qmyhsBg/BRELAGux1GYvCa3sMqEyym32jjiaOx+fD/SN
         bOGBcwGe4061A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98F0DC43161;
        Mon, 20 Feb 2023 23:00:18 +0000 (UTC)
Subject: Re: [GIT PULL for-6.3] Switch io_uring to ITER_UBUF
From:   pr-tracker-bot@kernel.org
In-Reply-To: <7ec9c3d0-1028-4d58-8ef1-0cce3083696c@kernel.dk>
References: <7ec9c3d0-1028-4d58-8ef1-0cce3083696c@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <7ec9c3d0-1028-4d58-8ef1-0cce3083696c@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.3/iter-ubuf-2023-02-16
X-PR-Tracked-Commit-Id: d46aa786fa53cbc92593089374e49c94fd9063ae
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c1ef5003079531b5aae12467a350379496752334
Message-Id: <167693401862.6080.4100971499432581904.pr-tracker-bot@kernel.org>
Date:   Mon, 20 Feb 2023 23:00:18 +0000
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

The pull request you sent on Thu, 16 Feb 2023 19:54:20 -0700:

> git://git.kernel.dk/linux.git tags/for-6.3/iter-ubuf-2023-02-16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c1ef5003079531b5aae12467a350379496752334

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
