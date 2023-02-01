Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C22686DF0
	for <lists+io-uring@lfdr.de>; Wed,  1 Feb 2023 19:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjBASat (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Feb 2023 13:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjBASaq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Feb 2023 13:30:46 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E35E7F69D
        for <io-uring@vger.kernel.org>; Wed,  1 Feb 2023 10:30:39 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.183.234])
        by gnuweeb.org (Postfix) with ESMTPSA id 586A482F53;
        Wed,  1 Feb 2023 18:30:37 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1675276238;
        bh=63brBCmcnH6IAEiOWsO8rHyPazhl8h8YqS0UceaLz4A=;
        h=Date:To:Cc:From:Subject:From;
        b=dwrd6Ejn0TpRF8SISFKRRLq7otGVONjgSkVxb+KD86yIj/Fr0lQIEXf91ZlLWwMNR
         TRMvHpTiqEC0HOC0ujH0w/Afs/aYwdysTNTVlaPb/nyPz3uQEVF8FtsuRx5CV8Uhzg
         hi/ahADYis5P3BEHOp9m2DBihWrlNntuzDgt96wr++OzBgyniwbdwaakmk0jVLIFfZ
         hcc4QDJnfh2u4GvK34k3iAKCWhBhYXKmhufTVvGV2siQwohEjHAbTmZOUGLy6sA5gI
         kzmazHV1wRdyn2aLCvFoUGW9RAzI+aYPy0lVF+6U3Z+JdNheu7BhCZXdQ6PsHFCbiy
         D3d9SaLR1ZPCA==
Message-ID: <a9aac5c7-425d-8011-3c7c-c08dfd7d7c2f@gnuweeb.org>
Date:   Thu, 2 Feb 2023 01:30:34 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [GIT PULL] Upgrade to clang-17 (for liburing's CI)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

clang-17 is now available. Upgrade the clang version in the liburing's
CI to clang-17.

Two prep patches to address `-Wextra-semi-stmt` warnings:

   - Remove unnecessary semicolon (Alviro)

   - Wrap the CHECK() macro with a do-while statement (Alviro)

A patch for the CI:

   - Upgrade the clang version to 17 and append -Wextra-semi-stmt (me)

Please pull!

The following changes since commit 313aece03ab7dc7447a19cff5b5f542d0c1b2a1e:

   multicqes_drain: make trigger event wait before reading (2023-01-30 09:26:42 -0700)

are available in the Git repository at:

   https://github.com/ammarfaizi2/liburing.git tags/upgrade-to-clang17-2023-02-02

for you to fetch changes up to c1b65520c05413dbf8aa4ed892dbe730a8379de3:

   github: Upgrade the clang version to 17 (2023-02-02 01:12:17 +0700)

----------------------------------------------------------------
Pull CI updates from Ammar Faizi:

   Two prep patches to address `-Wextra-semi-stmt` warnings:

     - Remove unnecessary semicolon (Alviro)

     - Wrap the CHECK() macro with a do-while statement (Alviro)

   A patch for the CI:

     - Upgrade the clang version to 17 and append -Wextra-semi-stmt (me)

----------------------------------------------------------------
Alviro Iskandar Setiawan (2):
       tests: Remove unnecessary semicolon
       tests: Wrap the `CHECK()` macro with a do-while

Ammar Faizi (1):
       github: Upgrade the clang version to 17

  .github/workflows/build.yml |  8 ++++----
  test/accept-link.c          |  2 +-
  test/defer-taskrun.c        | 11 ++++++++---
  test/defer.c                |  2 +-
  test/fixed-link.c           |  2 +-
  test/lfs-openat-write.c     |  9 +++++----
  test/lfs-openat.c           |  9 +++++----
  test/pipe-bug.c             | 10 +++++++---
  test/recv-multishot.c       |  2 +-
  test/timeout.c              |  2 +-
  10 files changed, 34 insertions(+), 23 deletions(-)

-- 
Ammar Faizi
