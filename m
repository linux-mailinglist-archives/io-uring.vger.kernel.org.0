Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D333958F825
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 09:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbiHKHLy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 03:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiHKHLx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 03:11:53 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF228E451
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 00:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=hNCklKwhnkxgpegKG9vOA7heL6xIAzE/3BG7ocIh58U=; b=iLCkDFXjuYJ/Iiyv4rxmDZ/8OC
        LaMbM97xPtLbLOdqmFLD+A7tSLekeme2dqVF71dSuTnjXDCFlBEnZLdBB8Lhr7P4J2Qb7lXAOyN2I
        W6OTXN6NkGOr6AoUVjS7P5AH/3kF0oc86OauUMfj1/uV9FlVaKloZFymOUdkwMbD/2prCNzsVg1/7
        U4lqzhoKEMl13wJSe6x0YRQYg8l74AaeUNm9udIUIuEW0SJTgh5CUH6U/uw+BQjjxbL2BrfSk1HRa
        ql1PP2JBWr0z16js6b+d1crP56RAl4KDM9aSZklfV2NoI5pegW3b8xiL8S4Q7WG5677E7PzTSVT0T
        wxZ+JqNrOM7K2g/smfSaLOtU5agzOojN5z7J0kBwh75FlKTvaXKuVLrsgCsq0lYyyGAvSs5qPwif5
        fl7Fbaa7XgEGCdK/e8ihuJMtOY6WmlUHyAQrpoRwzgqTFiguPyp0ylE8U/JzUzbI0oBP33qgnqWx3
        ZEEBJC9j1Se34e3XIpJKweey;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oM2M7-0099uF-JA; Thu, 11 Aug 2022 07:11:49 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 0/3] typesafety improvements on io_uring-6.0
Date:   Thu, 11 Aug 2022 09:11:13 +0200
Message-Id: <cover.1660201408.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

with the split into individual files (which is gread)
and the introduction of the generic struct io_cmd_data,
we now have the risk do incompatible casting in
io_kiocb_to_cmd().

My patches catch casting problems with BUILD_BUG_ON() now.
While there I added missing BUILD_BUG_ON() checks
for new io_uring_sqe fields.

Stefan Metzmacher (3):
  io_uring: consistently make use of io_notif_to_data()
  io_uring: make io_kiocb_to_cmd() typesafe
  io_uring: add missing BUILD_BUG_ON() checks for new io_uring_sqe
    fields

 include/linux/io_uring_types.h |  9 +++++++-
 io_uring/advise.c              |  8 +++----
 io_uring/cancel.c              |  4 ++--
 io_uring/epoll.c               |  4 ++--
 io_uring/fs.c                  | 28 +++++++++++------------
 io_uring/io_uring.c            | 19 ++++++++++++---
 io_uring/kbuf.c                |  8 +++----
 io_uring/msg_ring.c            |  8 +++----
 io_uring/net.c                 | 42 +++++++++++++++++-----------------
 io_uring/notif.c               |  4 +---
 io_uring/notif.h               |  2 +-
 io_uring/openclose.c           | 16 ++++++-------
 io_uring/poll.c                | 16 ++++++-------
 io_uring/rsrc.c                | 10 ++++----
 io_uring/rw.c                  | 28 +++++++++++------------
 io_uring/splice.c              |  8 +++----
 io_uring/statx.c               |  6 ++---
 io_uring/sync.c                | 12 +++++-----
 io_uring/timeout.c             | 26 ++++++++++-----------
 io_uring/uring_cmd.c           | 11 +++++----
 io_uring/xattr.c               | 18 +++++++--------
 21 files changed, 154 insertions(+), 133 deletions(-)

-- 
2.34.1

