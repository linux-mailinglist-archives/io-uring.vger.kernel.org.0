Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E005AA4F3
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 03:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbiIBBSB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 21:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbiIBBSA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 21:18:00 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCDD78BC6
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 18:17:59 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.38.99])
        by gnuweeb.org (Postfix) with ESMTPSA id 43A8A80927;
        Fri,  2 Sep 2022 01:17:56 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662081479;
        bh=e9BpChXkywn48ca37KolVRO8rhHMchqKb7ODqEac+UM=;
        h=From:To:Cc:Subject:Date:From;
        b=skmByeEG1W4wS/uJUR7QFy95hrL5ikdW5gPJmB8568k3Ij6QFTBQYJiUiRDXDTxMZ
         5GytDzP3V0vD5DL0tuG0HoJzmpm6i0MPuKMBe6C3jKBvapcHRDjbc5QEJm+PnCFK1+
         asLJmbwi8Ttvb13sEvHNRtZdu0amZ0Gy3LYXVJhRt/A9nQjpRanOB4AeB71DFEzLDV
         NP9wEWPwWMP9jSkXbCpetxMMs8GMICK9sQlTnMYmK78l2+FjIXkUCwgDkYGcsp5d3A
         YSZ7yUA6N1K9RHd4XySic5BgMzo7IR2PIWma01jFlS4/5lY4V8GvPvCOmsw10aRlE9
         mBv6lPZYgCMkA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>
Subject: [RESEND PATCH liburing v1 00/12] Introducing t_bind_ephemeral_port() function
Date:   Fri,  2 Sep 2022 08:17:40 +0700
Message-Id: <20220902011548.2506938-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

[ RESEND to the correct address now. ]

Hi,

After discussing an intermittent bind() issue with Dylan, I decided to
introduce a new helper function, t_bind_ephemeral_port().

## Problem:
We have many places where we need to bind() a socket to any unused port
number. To achieve that, the current approach does one of the following
mechanisms:

  1) Randomly brute force the port number until the bind() syscall
     succeeds.

  2) Use a static port at compile time (randomly chosen too).

This is not reliable and it results in an intermittent issue (test
fails when the selected port is in use).

## Solution:
Setting @addr->sin_port to zero on a bind() syscall lets the kernel
choose a port number that is not in use. The caller then can know the
port number to be bound by invoking a getsockname() syscall after
bind() succeeds.

Wrap this procedure in a new function called t_bind_ephemeral_port().
The selected port will be returned into @addr->sin_port, the caller
can use it later to connect() or whatever they need.

## Patchset summary:
There are 12 patches in this series, summary:
1) Patch #1 introduces a new helper function t_bind_ephemeral_port().
2) Patch #2 to #6 get rid of the port number brute force mechanism.
3) Patch #7 to #12 stop using a static port number.

Link: https://lore.kernel.org/r/918facd1-78ba-2de7-693a-5f8c65ea2fcd@gnuweeb.org
Cc: Dylan Yudaken <dylany@fb.com>
Cc: Facebook Kernel Team <kernel-team@fb.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (12):
  test/helpers: Add `t_bind_ephemeral_port()` function
  t/poll-link: Don't brute force the port number
  t/socket-rw: Don't brute force the port number
  t/socket-rw-eagain: Don't brute force the port number
  t/socket-rw-offset: Don't brute force the port number
  t/files-exit-hang-poll: Don't brute force the port number
  t/socket: Don't use a static port number
  t/connect: Don't use a static port number
  t/shutdown: Don't use a static port number
  t/recv-msgall: Don't use a static port number
  t/232c93d07b74: Don't use a static port number
  t/recv-msgall-stream: Don't use a static port number

 test/232c93d07b74.c         | 10 ++++------
 test/accept.c               |  5 +----
 test/files-exit-hang-poll.c | 23 +++--------------------
 test/helpers.c              | 18 ++++++++++++++++++
 test/helpers.h              |  7 +++++++
 test/poll-link.c            | 20 ++++++--------------
 test/recv-msgall-stream.c   | 22 ++++++++++------------
 test/recv-msgall.c          | 10 ++++------
 test/shutdown.c             |  7 +++----
 test/socket-rw-eagain.c     | 14 ++------------
 test/socket-rw-offset.c     | 13 ++-----------
 test/socket-rw.c            | 13 ++-----------
 test/socket.c               | 11 ++++++-----
 13 files changed, 68 insertions(+), 105 deletions(-)


base-commit: b8c37f02662faa4f2b61840b123201ccc5678fb1
-- 
Ammar Faizi

