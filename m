Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655F65AB6B4
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 18:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbiIBQhi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 12:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbiIBQhg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 12:37:36 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A34DF4C9D
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 09:37:34 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id d68so2034828iof.11
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 09:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=92u+Oz7epeLsXlQb8vzZRBTIP3oSa4A2Z9E9O/4PymM=;
        b=VRWmENqzCV0m/70l9WtdAcIloCQZjfUXWOhGzzO1splGN8CqbVrPYtZj2v5QHSANDD
         /eN+80GTkOsSUNBWe+CVvGEsaznuaXvQP7y+FqvGjvxhrpX6G72TwpAh0TBdxqHtn4qQ
         vgtaA/MJ7d5wWcayBlpksfIP4rlBbE81DCRbIeTts1+h8Ay/sFgAD5A863keg5LYDxBN
         ie3Z11DjDiVWhV+QB1oJUrG6pD99h/MpcaHqL+W9+LTELg7TcaGvPJRo+vpWjah7MIGP
         7MK+oGgvpbd0qbxAWsSDL8h/Zf798hrwVKzMWmiuV2VnQCH+Fo4MvNzzLj3IrfCnVm4D
         /oSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=92u+Oz7epeLsXlQb8vzZRBTIP3oSa4A2Z9E9O/4PymM=;
        b=vNd0SD3SlecxgKeioRvcYeOlWj3ZXg0GhZUykUfaMQDncoQETwlqauCRhn8e6s3Gqd
         V2Ddz3iUWJBL84yLAhsYdzptDHLdz5PBT4elH/Q8inD/kqr+qGz+eG+9DOUR1A6bg5oD
         fVTdRXpvK2cpl7vwD7SFRBqIubZppXh2zmGlSThiG2SVx6Ob19N1O/Y20LoTrarLQ+0v
         hAFIb6QXk5TUZZC2bjE7uKRyqWzoKYQGTadl+UGgwfrYa7l2bMA/GC/WfIXVQOt9+LGU
         0YjoMa8P4ciyocEVzBhkqt5oLzMTds9OfNV0g5bwZG20yUhfej3fY2wjQ1vhjnyAAQY4
         zBbg==
X-Gm-Message-State: ACgBeo2xIap56kirQOTUILmruA9Yr6f3lBAykgAFfgZla5OIuBGXVAX3
        7D1B6z7rZxRvnMlYb9PiYQD//UtvU0mEVQ==
X-Google-Smtp-Source: AA6agR6GucJts6u9knW27wq2Otq0eeMuGnIpcpXDlJJojq+z4j7rgPF05iuRadsAojffQ8IfjH54xw==
X-Received: by 2002:a5e:a508:0:b0:689:a16c:fbc7 with SMTP id 8-20020a5ea508000000b00689a16cfbc7mr16942227iog.143.1662136653878;
        Fri, 02 Sep 2022 09:37:33 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o17-20020a02a1d1000000b0034e2ed44d5bsm1034247jah.147.2022.09.02.09.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 09:37:33 -0700 (PDT)
Message-ID: <2f02c7b9-4b7a-61fc-d8d6-4de76a15fc9f@kernel.dk>
Date:   Fri, 2 Sep 2022 10:37:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.0-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Two parts in this pull request:

- Single fix for over-eager retries for networking (Pavel)

- Revert of the notification slot support for zerocopy sends. Turns out
  that even after more than a year or development and testing, there's
  not full agreement on whether just using plain ordered notifications
  is Good Enough to avoid the complexity of using the notifications
  slots. Because of that, we decided that it's best left to a future
  final decision. We can always bring back this feature, but we can't
  really change it or remove it once we've released 6.0 with it enabled.
  The reverts leave the usual CQE notifications as the primary interface
  for knowing when data was sent, and when it was acked. (Pavel)

Please pull!


The following changes since commit 581711c46612c1fd7f98960f9ad53f04fdb89853:

  io_uring/net: save address for sendzc async execution (2022-08-25 07:52:30 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-09-02

for you to fetch changes up to 916d72c10a4ca80ea51f1421e774cb765b53f28f:

  selftests/net: return back io_uring zc send tests (2022-09-01 09:13:33 -0600)

----------------------------------------------------------------
io_uring-6.0-2022-09-02

----------------------------------------------------------------
Pavel Begunkov (7):
      io_uring/net: fix overexcessive retries
      selftests/net: temporarily disable io_uring zc test
      Revert "io_uring: add zc notification flush requests"
      Revert "io_uring: rename IORING_OP_FILES_UPDATE"
      io_uring/notif: remove notif registration
      io_uring/net: simplify zerocopy send user API
      selftests/net: return back io_uring zc send tests

 include/uapi/linux/io_uring.h                      |  28 ++----
 io_uring/io_uring.c                                |  14 +--
 io_uring/net.c                                     |  59 +++++++-----
 io_uring/net.h                                     |   1 +
 io_uring/notif.c                                   |  83 +----------------
 io_uring/notif.h                                   |  54 +----------
 io_uring/opdef.c                                   |  12 +--
 io_uring/rsrc.c                                    |  55 +----------
 io_uring/rsrc.h                                    |   4 +-
 tools/testing/selftests/net/io_uring_zerocopy_tx.c | 101 ++++++++-------------
 .../testing/selftests/net/io_uring_zerocopy_tx.sh  |  10 +-
 11 files changed, 99 insertions(+), 322 deletions(-)

-- 
Jens Axboe
