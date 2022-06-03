Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D43753C427
	for <lists+io-uring@lfdr.de>; Fri,  3 Jun 2022 07:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240351AbiFCF0S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jun 2022 01:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiFCF0R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jun 2022 01:26:17 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A2B15706
        for <io-uring@vger.kernel.org>; Thu,  2 Jun 2022 22:26:15 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id u8so4624212wrm.13
        for <io-uring@vger.kernel.org>; Thu, 02 Jun 2022 22:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=z/79ed8XDcWMLmEH6QM3M5k21QLCOT5YvoX1PrrI3L4=;
        b=0gCVCxpmTp7E54Hx3/NmqevtRNTDGgXMgp1zZl+4LsYyXu8IvpHzuGiwuI//pwR7Wz
         NpHetNngKa4iYz6qI7+zyhIJjQ8No0ypD7PPDsN6nDemzH6vtrnvjPbAVoryGtMLYmu6
         mdvUEgEk9MKtc4qBc37EO75pBStsZz1cmpzailKXkyzE+zXaE7i7RzzlIn2CDhqMdi73
         +8b3iT8ykxX3+d0BEt1qxee3TCthrh9MlcYhnd4cCZVzpp2kXPQFJ/eGco59x6JSXfYQ
         glrfJmUuSWWRc8t7Y48AmRWYmpbOhydIBq5EIsaxmcmMkZYPMHJwB0tuhm6Afs3smW26
         PxHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=z/79ed8XDcWMLmEH6QM3M5k21QLCOT5YvoX1PrrI3L4=;
        b=A9F1Hmne1pbcM/xk90GdDikEI9E+ap7d6wUggPkgNz6F0m+pEESreh/Z3GZ0iqXPCu
         YqG0/qnZHivgYCJfVYcMhdaftgp3oozreTWrqgb7F4xcrrzUc7Po75JiOzXJBaVbG2S3
         eySd8mJNetRxiU/zRPlAkCeUHjSmx4N6tqFGZdkemFgUWa/hsagsl64npzqBYygm1YdR
         3ukJup9JLmhpdnq2c3aEjymjxR6Evxxjna3s+d43k4V341TwEoP4NkVgptEkG+iN9+Xx
         JbasLRx4YDe9niv5c1k+f2+Xt6fei9auQ8TRcHc8NW/0/hAqNdx/thb9NuaHKvB1rrVe
         OhoQ==
X-Gm-Message-State: AOAM533vLtRMUKCROuuPvqcYiSo1TXkq+rKfREUOUc0d42dDTZExpxch
        ud/VpBoP12IyGyZtrpQgo0BiwbNcz2y2EQCL
X-Google-Smtp-Source: ABdhPJxLg3q5Xfd+GqG16+3XhQkEXZirLcCc00dpet4VTuok69WtbqLsdjtZc1DnLRs97TyMkZM+hw==
X-Received: by 2002:a5d:6787:0:b0:210:3470:13dd with SMTP id v7-20020a5d6787000000b00210347013ddmr6206357wru.279.1654233974022;
        Thu, 02 Jun 2022 22:26:14 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id q3-20020adff943000000b0020d07958bb3sm6531137wrr.3.2022.06.02.22.26.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 22:26:13 -0700 (PDT)
Message-ID: <bd16e13c-8260-c1c9-88b4-8756e0142f46@kernel.dk>
Date:   Thu, 2 Jun 2022 23:26:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Followup io_uring changes and fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A collection of changes since the initial pull request for the 5.19
merge window:

- A small series with some prep patches for the upcoming 5.20 split of
  the io_uring.c file. No functional changes here, just minor bits that
  are nice to get out of the way now (me)

- Fix for a memory leak in high numbered provided buffer groups,
  introduced in the merge window (me)

- Wire up the new socket opcode for allocated direct descriptors, making
  it consistent with the other opcodes that can instantiate a
  descriptor (me)

- Fix for the inflight tracking, should go into 5.18-stable as well (me)

- Fix for a deadlock for io-wq offloaded file slot allocations (Pavel)

- Direct descriptor failure fput leak fix (Xiaoguang)

- Fix for the direct descriptor allocation hinting in case of
  unsuccessful install (Xiaoguang)

Please pull!


The following changes since commit 140e40e39a29c7dbc188d9b43831c3d5e089c960:

  Merge tag 'zonefs-5.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/zonefs (2022-05-23 14:36:45 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-06-02

for you to fetch changes up to 9cae36a094e7e9d6e5fe8b6dcd4642138b3eb0c7:

  io_uring: reinstate the inflight tracking (2022-06-01 23:57:02 -0600)

----------------------------------------------------------------
io_uring-5.19-2022-06-02

----------------------------------------------------------------
Jens Axboe (8):
      io_uring: make timeout prep handlers consistent with other prep handlers
      io_uring: make prep and issue side of req handlers named consistently
      io_uring: add io_op_defs 'def' pointer in req init and issue
      io_uring: unify calling convention for async prep handling
      io_uring: move shutdown under the general net section
      io_uring: fix a memory leak of buffer group list on exit
      io_uring: wire up allocated direct descriptors for socket
      io_uring: reinstate the inflight tracking

Pavel Begunkov (1):
      io_uring: fix deadlock on iowq file slot alloc

Xiaoguang Wang (3):
      io_uring: ensure fput() called correspondingly when direct install fails
      io_uring: defer alloc_hint update to io_file_bitmap_set()
      io_uring: let IORING_OP_FILES_UPDATE support choosing fixed file slots

 fs/io_uring.c                 | 340 +++++++++++++++++++++++++++---------------
 include/uapi/linux/io_uring.h |   6 +
 2 files changed, 224 insertions(+), 122 deletions(-)

-- 
Jens Axboe

