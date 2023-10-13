Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CBB7C88FA
	for <lists+io-uring@lfdr.de>; Fri, 13 Oct 2023 17:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbjJMPor (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Oct 2023 11:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbjJMPor (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Oct 2023 11:44:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E532BBE;
        Fri, 13 Oct 2023 08:44:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4950CC433C8;
        Fri, 13 Oct 2023 15:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697211885;
        bh=gNiufPYZ0hqW339nlkZ0KShCby3GmH/4QjkDOxAMhRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ah9ZcLKa5+3a5lw/2RUpzEBlv25I7NYXUvEM4cIdlEAA/57SWHHmYXgZEhi+corK2
         sanaGiSfMiwMzlMD/ChiTUodBJ13U5rMtECK0R5fJivcc0o/VAo2QzbhyfJ2j+hblG
         3i3lO7CmuteU+0Cd5rJ6nVMbbTJztOZnFXy7nS/8H1WkxGeZAumrGnvOLwIvL44wZI
         42siTjyIoIzvBxCDvL3SRA71bmYwRWvKcnevi3x67vZIMt+nMm2SEcaIL7BMfnb1st
         6CQx1DQcrgJZkU9x8xaLwfPAEC1jkpEyyPjveVJNkazRClwPtM6q7sdg719PlEpXmq
         IQkqy1seFCYpA==
From:   Christian Brauner <brauner@kernel.org>
To:     Dan Clash <daclash@linux.microsoft.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-kernel@vger.kernel.org, paul@paul-moore.com, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, dan.clash@microsoft.com,
        audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] audit,io_uring: io_uring openat triggers audit reference count underflow
Date:   Fri, 13 Oct 2023 17:44:36 +0200
Message-Id: <20231013-karierte-mehrzahl-6a938035609e@brauner>
X-Mailer: git-send-email 2.34.1
In-Reply-To:  <20231012215518.GA4048@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References:  <20231012215518.GA4048@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1203; i=brauner@kernel.org; h=from:subject:message-id; bh=d37zo00rWfqEWvqv9CBNgrxFEsB2MVrLwwB/cAPjv9o=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaRqph5iehkbnpXoJ8qwaq/PM76TkusybaW+xVyfkfFFWKne 02ljRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEReNjMy9Nbt395ZrxhXcHbWoXc9Xa /1TP4cMM+48/GFREPiuqusvxj+iulVvZu9q4D57deIjKcvNYPL70caLdq4e33AfJvYr14L2AE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 12 Oct 2023 14:55:18 -0700, Dan Clash wrote:
> An io_uring openat operation can update an audit reference count
> from multiple threads resulting in the call trace below.
> 
> A call to io_uring_submit() with a single openat op with a flag of
> IOSQE_ASYNC results in the following reference count updates.
> 
> These first part of the system call performs two increments that do not race.
> 
> [...]

Picking this up as is. Let me know if this needs another tree.

---

Applied to the vfs.misc branch of the vfs/vfs.git tree.
Patches in the vfs.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.misc

[1/1] audit,io_uring: io_uring openat triggers audit reference count underflow
      https://git.kernel.org/vfs/vfs/c/c6f4350ced79
