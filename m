Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA337635F08
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 14:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbiKWNMp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 08:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbiKWNMW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 08:12:22 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408F1F72DE
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 04:54:30 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 0FCD8816E8;
        Wed, 23 Nov 2022 12:53:59 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669208043;
        bh=9wtLnxSZR7iluiSivJYmlixu+O5bLsOm2cbIjp8hQpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpsfRyysxeY5Ae29j5hqT3vjOmXCNPRbyf2VDjbnc1gBVj6kKdkw3Not71NHAxhue
         KRxWwuMYXJlC8ONsdEf8SUuLS5ViuDnmVVcWlag5lYi39cooGnYujotF9o0YO+c85S
         P/RjoF8Pw8u8neqDRrPmF4Qo9jwKMDh95qKNY1QyVN6mEgjTYGmjEk0BK7KjC99Og6
         Ww6p0VNI+71ddMeME5pU74KL084TrwNZLn4Em7TmWOsjL3GNf/oHVR9LlTbU3wlH98
         XRVlcn5L3NGJ2sR3A4S6T16lKvAkwjwRXhjT/c4tctTW1MhOu3Re30ZRPo4pBdNa4s
         ALf05PcJIy+qQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>, kernel@vnlx.org,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v1 2/5] register: Remove useless branches in {un,}register buffers
Date:   Wed, 23 Nov 2022 19:53:14 +0700
Message-Id: <20221123124922.3612798-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221123124922.3612798-1-ammar.faizi@intel.com>
References: <20221123124922.3612798-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

IORING_REGISTER_BUFFERS and IORING_UNREGISTER_BUFFERS don't return a
positive value. These bracnes are useless. Remove them.

[1]: io_sqe_buffers_register
[2]: io_sqe_buffers_unregister

Kernel-code-ref: https://github.com/torvalds/linux/blob/v6.1-rc6/io_uring/rsrc.c#L1250-L1307 [1]
Kernel-code-ref: https://github.com/torvalds/linux/blob/v6.1-rc6/io_uring/rsrc.c#L1036-L1054 [2]
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/register.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/src/register.c b/src/register.c
index 6cd607e..adb64cc 100644
--- a/src/register.c
+++ b/src/register.c
@@ -54,20 +54,14 @@ int io_uring_register_buffers_sparse(struct io_uring *ring, unsigned nr)
 int io_uring_register_buffers(struct io_uring *ring, const struct iovec *iovecs,
 			      unsigned nr_iovecs)
 {
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_BUFFERS,
-				      iovecs, nr_iovecs);
-	return (ret < 0) ? ret : 0;
+	return __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_BUFFERS,
+				       iovecs, nr_iovecs);
 }
 
 int io_uring_unregister_buffers(struct io_uring *ring)
 {
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_BUFFERS,
-				      NULL, 0);
-	return (ret < 0) ? ret : 0;
+	return __sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_BUFFERS,
+				       NULL, 0);
 }
 
 int io_uring_register_files_update_tag(struct io_uring *ring, unsigned off,
-- 
Ammar Faizi

