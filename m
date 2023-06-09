Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDBC728D51
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 03:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjFIBy1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jun 2023 21:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbjFIBy0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jun 2023 21:54:26 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3021FDF;
        Thu,  8 Jun 2023 18:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1686275664;
        bh=3ljPQmDJI0BubglR2nNAPuUiDuj6mXsBY7G7L13axWQ=;
        h=From:To:Cc:Subject:Date;
        b=k0rB+eXaRxv/qWV1WhvGuUtKePrcHtirv0eQHpz//N/X52kMMrezwwttrR2jaqzpv
         MAkm2thVRyvt57K6kexhZy5m1dNpPnIlX46YXfpvHhnJMFFMNSGd0EyCEd3kin/dwi
         O/tP9UK7InqbZGPNPvOcJvDSq1Aa852Kyz8NmuJ3J3rosxjJwBsv3Lx3ySTaV9m1C4
         MuwCNHTZ0AbNlvQncnrPG1n+SORYfZnCIn753qYOooCbHJYvZUL0nWy2EiD64zC/2r
         BTvFlyXCZAr20evYhJFyTT/B8iNMpnYdGkaoJG8Nub+unTbU7F9QmUFdpxo1bgOW47
         +DGSl6cmCiPYw==
Received: from integral2.. (unknown [103.74.5.63])
        by gnuweeb.org (Postfix) with ESMTPSA id 86A3A23EC0A;
        Fri,  9 Jun 2023 08:54:22 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing v1 0/2] Fixes for io_uring_for_each_cqe
Date:   Fri,  9 Jun 2023 08:54:01 +0700
Message-Id: <20230609015403.3523811-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

Please consider taking these last-minute fixes for liburing-2.4
release. There are two patches in this series:

## 1. man/io_uring_for_each_cqe: Fix return value, title, and typo

  - Fix the return value. io_uring_for_each_cqe() doesn't return an int.

  - Fix the title, it was io_uring_wait_cqes(), it should be
    io_uring_for_each_cqe().

  - Fix typo: s/io_uring_for_each_cqes/io_uring_for_each_cqe/.

## 2. Explicitly tell it's a macro and add an example

Let the reader directly know that it's not a function, but a macro.
Also, give a simple example of its usage.

Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (2):
  man/io_uring_for_each_cqe: Fix return value, title, and typo
  man/io_uring_for_each_cqe: Explicitly tell it's a macro and add an example

 man/io_uring_for_each_cqe.3 | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

base-commit: b4ee3108b93f7e4602430246236d14978abad085
-- 
Ammar Faizi

