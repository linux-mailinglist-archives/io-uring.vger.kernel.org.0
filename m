Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081376EAA66
	for <lists+io-uring@lfdr.de>; Fri, 21 Apr 2023 14:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjDUMeO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Apr 2023 08:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDUMeO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Apr 2023 08:34:14 -0400
X-Greylist: delayed 203 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 21 Apr 2023 05:34:12 PDT
Received: from out203-205-251-84.mail.qq.com (unknown [203.205.251.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666391AE;
        Fri, 21 Apr 2023 05:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682080450;
        bh=E5ogk5vGgouYtZylPwN/B6rVm8IFTTc1usoLg+OEchk=;
        h=From:To:Cc:Subject:Date;
        b=p+PSrKxtxClZK+y6YlMT46HV8RUuouo/kBdbdDZfph68+lKCcc+8iyVnCw8YIuLqL
         eg6Yy3t8KJgXUbTPi/mFhlhvTFc2vf3hnDdlZiih3VwK+hg8WLXyZ2FI12ove4TBY4
         s6RFHYNAKjoqUaw3B/v/mKPoJclNDe5XBmxt67C0=
Received: from localhost.localdomain ([39.156.73.13])
        by newxmesmtplogicsvrsza12-0.qq.com (NewEsmtp) with SMTP
        id 6A93EC29; Fri, 21 Apr 2023 20:26:41 +0800
X-QQ-mid: xmsmtpt1682080001tyjygpl3a
Message-ID: <tencent_7654045EAF47B511E90DE4848CB2342E7509@qq.com>
X-QQ-XMAILINFO: Mee1Vp/QiDAWXMQ6xzehAwpwdutSjxTnc1irddOHDbiCsu/oUI2GYLkOoNwLet
         i7HyvtvvuTcleQgwXv4AnQzPlLQxl14muN4BkkjsRw6OF1HZJUWTGB6IyT6dDOhQaAzzUCWUh5SB
         oYLAgZtiQABcu7XR/O/Sq40hOPiGeBUstVIuvEHX9VzsRWZ9jrvG8V8TO8NSsml28tQOVehylz+j
         qVyfUge0kfb+7KZzxHnVn6JdzjpW5Fvpq8C8cIqJYQVTpQtSf43HuAlrdMEL/OpBjTrUVXWjoDG1
         AfjFf7tTGZbZic3A6PxL2dSCSm94lDI2DP5zb8ooox64SbdCgA5vMEmnRseZEy5NrbkWhJ+VTAnx
         e1NNjFyhMRgObLpv45m97RKqXqgXU95n0QxdaXzGCQ/jrLJvG1rMSIoAd3HQSVlAHV9Xqd0+Tp2a
         msaiPfIBsfcOptxQk8pz/ZP2/BjaRmq5IIjhuoyEkIH+el+lP1mtEeVdLrpCmh3mSxAODEynHMvT
         RLYsDNMHiGSepaDhtHKRzYz6a2aUJtO7SZMB/hzMsBZt+hbx3sAGyUdrjwWOQTIEecjZFxOdM2nt
         EgcN905INWq/gCmb9/lNYHGdpn5t/VA3C5S1c3Hb1+/tQRgivPW6/Hv5HLi03kM3VvXD/ikxokZm
         wyGZw4PfQ8UHlgHRdb58jwZOMOwi9xTzi8uOU+VvuMTbEDGCT9lNgHr/k8TGA1Vqz7BsJz33KaYe
         a0DuIOBPp7lBdLgc9yeYi3QL6PiOEZzUCl9Sj8jhY3n5x2JPf7Y7QE2PrWvJXDI9qI3JF7SGZcoo
         M1i6N1UGoj+4+hrfmeP+9gS5Ai4oJ7peq/mW05y5bmFm0HdVLC1FBYX6UZpQP0ZRAl7h4VdZhn06
         qnk8SgCWE2In/lH/DyOzXC/QRzQOCVjT4o0KhEyJxB659GJN2schXfFD3mVp8rb5z+4XXxNr/l0m
         91mfS0pI31ggS/3IwzTen/poBuA6X9/iuH+mHaDGhvwKczn2ZnmRdSHB65rkP51ak7aCEWe0HMB9
         h23D81Qw==
From:   Rong Tao <rtoax@foxmail.com>
To:     axboe@kernel.dk
Cc:     Rong Tao <rongtao@cestc.cn>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org (open list:IO_URING),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] tools/io_uring/io_uring-cp: Fix two compile warings
Date:   Fri, 21 Apr 2023 20:26:35 +0800
X-OQ-MSGID: <20230421122635.242293-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Rong Tao <rongtao@cestc.cn>

Resolve compilation warnings:

    $ make
    ...
    cc -Wall -Wextra -g -D_GNU_SOURCE -o io_uring-cp io_uring-cp.c \
        setup.o syscall.o queue.o
    io_uring-cp.c: In function ‘copy_file’:
    io_uring-cp.c:158:31: warning: comparison of integer expressions of
    different signedness: ‘int’ and ‘long unsigned int’ [-Wsign-compare]
    158 |                 if (had_reads != reads) {
        |                               ^~
    io_uring-cp.c:201:45: warning: comparison of integer expressions of
    different signedness: ‘__s32’ {aka ‘int’} and ‘size_t’ {aka ‘long
    unsigned int’} [-Wsign-compare]
    201 |                    } else if (cqe->res != data->iov.iov_len) {
        |                                        ^~

Signed-off-by: Rong Tao <rongtao@cestc.cn>
---
 tools/io_uring/io_uring-cp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/io_uring/io_uring-cp.c b/tools/io_uring/io_uring-cp.c
index d9bd6f5f8f46..8a0ecaf78bda 100644
--- a/tools/io_uring/io_uring-cp.c
+++ b/tools/io_uring/io_uring-cp.c
@@ -131,7 +131,8 @@ static int copy_file(struct io_uring *ring, off_t insize)
 	writes = reads = offset = 0;
 
 	while (insize || write_left) {
-		int had_reads, got_comp;
+		unsigned long had_reads;
+		int got_comp;
 
 		/*
 		 * Queue up as many reads as we can
@@ -198,7 +199,7 @@ static int copy_file(struct io_uring *ring, off_t insize)
 				fprintf(stderr, "cqe failed: %s\n",
 						strerror(-cqe->res));
 				return 1;
-			} else if (cqe->res != data->iov.iov_len) {
+			} else if ((size_t)cqe->res != data->iov.iov_len) {
 				/* Short read/write, adjust and requeue */
 				data->iov.iov_base += cqe->res;
 				data->iov.iov_len -= cqe->res;
-- 
2.39.1

