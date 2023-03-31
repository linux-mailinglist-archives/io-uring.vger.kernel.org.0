Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433236D290E
	for <lists+io-uring@lfdr.de>; Fri, 31 Mar 2023 22:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbjCaUBc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Mar 2023 16:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbjCaUA6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Mar 2023 16:00:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BFF1EA1F
        for <io-uring@vger.kernel.org>; Fri, 31 Mar 2023 13:00:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AD5FB83223
        for <io-uring@vger.kernel.org>; Fri, 31 Mar 2023 20:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DE4AC433D2;
        Fri, 31 Mar 2023 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680292805;
        bh=BLBVl31son+rQfSSJKd1tGS0FiqK6lSAXi8LYHiIjtU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=DTenFPDKuaElaRDGi+mXmWtcMrvsmAEf02sdIXrGHSlqobzRN2Ep/io81n2JqHGu3
         SEfbZvVnIBTo6OTKIhiuVhnqUSfsTbpiekc2ZRsp6G72DOIdBhY5MjfyEZVZ2p3bxH
         Bkso6qtu2mZd/vPoXRKaUn4AO/WsG9ytkYgXPgbiXHxlaj1QSNlSfxoxsj1x8GGBUI
         aAamXnS9YG7+4utK1YAYQxxQZFW6CXBrkXpvn2abDkkkDnSBfSsqtP1c7wG9dsTmNm
         HKymGsUohwqUFHrZJDrlTv1lAJneGeOhpa9+OOukQidWDGIFf6qc9TE2T6n9NOFI+k
         vjaES7Zh+gMsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08D2CC395C3;
        Fri, 31 Mar 2023 20:00:05 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.3-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <64cfabee-4458-5ce1-4415-f392262f34ec@kernel.dk>
References: <64cfabee-4458-5ce1-4415-f392262f34ec@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <64cfabee-4458-5ce1-4415-f392262f34ec@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-03-30
X-PR-Tracked-Commit-Id: fd30d1cdcc4ff405fc54765edf2e11b03f2ed4f3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f3fa7f026e5faf10f730b0655b2f96f86d3c7dd8
Message-Id: <168029280502.14353.17790290467432030069.pr-tracker-bot@kernel.org>
Date:   Fri, 31 Mar 2023 20:00:05 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The pull request you sent on Fri, 31 Mar 2023 09:26:01 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-03-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f3fa7f026e5faf10f730b0655b2f96f86d3c7dd8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
