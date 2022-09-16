Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7EF5BB3F9
	for <lists+io-uring@lfdr.de>; Fri, 16 Sep 2022 23:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiIPVh0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Sep 2022 17:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiIPVhY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Sep 2022 17:37:24 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1DAAB415
        for <io-uring@vger.kernel.org>; Fri, 16 Sep 2022 14:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=LtWppax3VNvnO+oBcWBlyM5t4xEjDHT265kj0XBPKBg=; b=iDQTFhQxs0xfiWLMeQZdsPl2Fg
        LP6wMsNk8dBsaouct4sYeSDtunCJkgzrfE8AozR+nbth/OrvU141GVfzWsrucVr4x9WJ3ayLXmqIW
        KI67KjtANNSZ5r1yxrLtmzkXyQC7m19B86dimDoNp4f9vdeJ+b1t1co+e+umezgODj1/mk9a+mXdR
        dEgekDIef3xxIks/ET5J7KWLkRHXCTgvpF6qanxNcXxVqEJkA43rWhxCIYTL2hiQJSIqdckGwsUxe
        Knn4+Tw+vnIbGTZu+Fklly51fTZEvlDn7N15rf2ihzLm4KD091ttb7dNAszH/ceyhMfSrllEUiVI0
        iXbYJv8gqyy3Jx0bTRTYx/hr2IQ2WSoFkQiOTtBkDRx1Z5S/ljMRQTyfwSYxOxAt3qp99pgfZbafO
        DJnVk3j4Znt6vmj6XXSwk/v5zb8xfpmfKKpnDjRS3h/98XaEbtZCQFmSX/6iJOhOFKQD5Hl/0XNaI
        SaKZFkA4NTLz5vI9vM71ZkCc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oZJ1T-000j5l-Bl; Fri, 16 Sep 2022 21:37:19 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH for-6.0 0/5] IORING_OP_SEND_ZC improvements
Date:   Fri, 16 Sep 2022 23:36:24 +0200
Message-Id: <cover.1663363798.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Pavel, hi Jens,

I did some initial testing with IORING_OP_SEND_ZC.
While reading the code I think I found a race that
can lead to IORING_CQE_F_MORE being missing even if
the net layer got references.

While there I added some code to allow userpace to
know how effective the IORING_OP_SEND_ZC attempt was,
in order to avoid it it's not used (e.g. on a long living tcp
connection).

This change requires a change to the existing test, see:
https://github.com/metze-samba/liburing/tree/test-send-zerocopy

Stefan Metzmacher (5):
  io_uring/opdef: rename SENDZC_NOTIF to SEND_ZC
  io_uring/core: move io_cqe->fd over from io_cqe->flags to io_cqe->res
  io_uring/core: keep req->cqe.flags on generic errors
  io_uring/net: let io_sendzc set IORING_CQE_F_MORE before
    sock_sendmsg()
  io_uring/notif: let userspace know how effective the zero copy usage
    was

 include/linux/io_uring_types.h |  6 +++---
 io_uring/io_uring.c            | 18 +++++++++++++-----
 io_uring/net.c                 | 19 +++++++++++++------
 io_uring/notif.c               | 18 ++++++++++++++++++
 io_uring/opdef.c               |  2 +-
 net/ipv4/ip_output.c           |  3 ++-
 net/ipv4/tcp.c                 |  2 ++
 net/ipv6/ip6_output.c          |  3 ++-
 8 files changed, 54 insertions(+), 17 deletions(-)

-- 
2.34.1

