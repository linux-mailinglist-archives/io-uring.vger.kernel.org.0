Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A3D667A50
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 17:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbjALQG0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 11:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjALQGA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 11:06:00 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CC560C0;
        Thu, 12 Jan 2023 07:57:33 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 3ABB57E74D;
        Thu, 12 Jan 2023 15:57:29 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673539053;
        bh=rH47GSDKKNn4IUUqXJmB8n2oZPbSj4OOp9WUqqpcbh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxvkGyjNUSjXd+lzOaZ4g9MRsycP+OfBHdwmVdPKMl1n+VWlEZdzKXk5V5smNWzyM
         AkeVdWcijkmoasznjtf/79Ke2SAXtVV8O5agAVVP5Q6iMvFvRYxxxIaIGDGKSGDGu2
         toBr5Xra526B60HRmVfd3bb+4csF84dSkiLPRJOG6H2OvR5mliIwZBrWPJbQUDXKK1
         O/LTV6P1zi1bTINjXGWcw6mFug5K1Xz+pwaKY0in6LW8CDx6f9m/3H2hU11JTTcYot
         KHtdqmPGtAddaMn0XHzGcJJKtPVcu5hiTZzijsgrbKcskT6y8OxDMMeSl/6dKbtPWw
         XvE679r7y4xLg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Breno Leitao <leitao@debian.org>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 4/4] man/io_uring_prep_splice.3: Explain more about io_uring_prep_splice()
Date:   Thu, 12 Jan 2023 22:57:09 +0700
Message-Id: <20230112155709.303615-5-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112155709.303615-1-ammar.faizi@intel.com>
References: <20230112155709.303615-1-ammar.faizi@intel.com>
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

I have found two people confused about the io_uring_prep_splice()
function, especially on the offset part. The current manpage for
io_uring_prep_splice() doesn't tell about the rules of the offset
arguments.

Despite these rules are already noted in "man 2 io_uring_enter",
people who want to know about this prep function will prefer to read
"man 3 io_uring_prep_splice".

Let's explain it there!

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Stolen from liburing comment (with some modifications):

  If `fd_in` refers to a pipe, `off_in` must be -1.

  If `fd_in` does not refer to a pipe and `off_in` is -1, then bytes are
  read from `fd_in` starting from the file offset and it is adjusted
  appropriately.

  If `fd_in` does not refer to a pipe and `off_in` is not -1, then the
  starting offset of `fd_in` will be `off_in`.

  The same rules apply to `fd_out` and `off_out`.

  Note that even if `fd_in` or `fd_out` refers to a pipe, the splice
  operation can still failed with `EINVAL` if one of the fd doesn't
  explicitly support splice operation, e.g. reading from terminal is
  unsupported from kernel 5.7 to 5.11.

 man/io_uring_prep_splice.3 | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/man/io_uring_prep_splice.3 b/man/io_uring_prep_splice.3
index cb82ad0..a177bc6 100644
--- a/man/io_uring_prep_splice.3
+++ b/man/io_uring_prep_splice.3
@@ -52,6 +52,34 @@ and
 .I fd_in
 given as a registered file descriptor offset.
 
+If
+.I fd_in
+refers to a pipe,
+.IR off_in
+must be -1.
+
+If
+.I fd_in
+does not refer to a pipe and
+.I off_in
+is -1, then bytes are read from
+.I fd_in
+starting from the file offset and it is adjusted appropriately.
+
+If
+.I fd_in
+does not refer to a pipe and
+.I off_in
+is not -1, then the starting offset of
+.I fd_in
+will be
+.IR off_in .
+
+The same rules apply to
+.I fd_out
+and
+.IR off_out .
+
 This function prepares an async
 .BR splice (2)
 request. See that man page for details.
@@ -78,3 +106,13 @@ field.
 .BR io_uring_submit (3),
 .BR io_uring_register (2),
 .BR splice (2)
+
+.SH NOTES
+Note that even if
+.I fd_in
+or
+.I fd_out
+refers to a pipe, the splice operation can still failed with
+.B EINVAL
+if one of the fd doesn't explicitly support splice operation, e.g. reading from
+terminal is unsupported from kernel 5.7 to 5.11.
-- 
Ammar Faizi

