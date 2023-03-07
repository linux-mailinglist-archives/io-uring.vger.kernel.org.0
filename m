Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515FE6AF6D5
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 21:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjCGUjX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 15:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjCGUjV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 15:39:21 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91E999273;
        Tue,  7 Mar 2023 12:39:12 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.169])
        by gnuweeb.org (Postfix) with ESMTPSA id ECC2D7E3C0;
        Tue,  7 Mar 2023 20:39:09 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1678221552;
        bh=CsORVV9sXXTWCJ7OUgvpgf+wT1IVTb5A5E+oXyKczKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpnP3sP2Qs+MeTu23VU2NMj+Eu2P6MdRvpdfDH/WII0Uh/v/VAhDfU51kn+D+q/MB
         yDNKGuZwwxfcgXElFX3xw1m/N4u4p2sEE89EAmoaDPn6Y0ayIOW6zfB4GKmh1IFLTX
         QRP1ZlHhTSelK2T5w89iek6i+lnhgV7RnHd4sIrN3EAVnjkf8MjDvxMwpYF6+dxt34
         wBYcEWo6VmFu8/eXd8FKIEJA3f9tTz7L+wuTxmY0HaBPLcEHqKqMyxzpeIBuHp7xAr
         gJqPlM6ttf3W7kuJeq4B3l3jmri9XpXwb9mFxjO4+bna89NIrpZmAaHiLIF7RIWK0T
         P6/Nu4WFvz0ZA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Rutvik Patel <heyrutvik@gmail.com>
Subject: [PATCH liburing v1 3/3] man/io_uring_register_{buffers,files}: Kill trailing whitespaces
Date:   Wed,  8 Mar 2023 03:38:30 +0700
Message-Id: <20230307203830.612939-4-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307203830.612939-1-ammarfaizi2@gnuweeb.org>
References: <20230307203830.612939-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Kill trailing whitespaces introduced in e628f65b6a6e and e709d2cf2f39.
The "git am" would have noticed this, but those commits were merged via
a pull request.

Cc: Rutvik Patel <heyrutvik@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 man/io_uring_register_buffers.3 | 10 +++++-----
 man/io_uring_register_files.3   | 22 +++++++++++-----------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/man/io_uring_register_buffers.3 b/man/io_uring_register_buffers.3
index 4f7d25a9fc1a887c..00861d917ed08566 100644
--- a/man/io_uring_register_buffers.3
+++ b/man/io_uring_register_buffers.3
@@ -40,9 +40,9 @@ belonging to the
 
 The
 .BR io_uring_register_buffers_tags (3)
-function behaves the same as 
+function behaves the same as
 .BR io_uring_register_buffers (3)
-function but additionally takes 
+function but additionally takes
 .I tags
 parameter. See
 .B IORING_REGISTER_BUFFERS2
@@ -69,8 +69,8 @@ manipulating the page reference counts for each IO.
 
 The
 .BR io_uring_register_buffers_update_tag (3)
-function updates registered buffers with new ones, either turning a sparse 
-entry into a real one, or replacing an existing entry. The 
+function updates registered buffers with new ones, either turning a sparse
+entry into a real one, or replacing an existing entry. The
 .I off
 is offset on which to start the update
 .I nr
@@ -90,7 +90,7 @@ On success
 .BR io_uring_register_buffers_tags (3)
 and
 .BR io_uring_register_buffers_sparse (3)
-return 0. 
+return 0.
 .BR io_uring_register_buffers_update_tag (3)
 return number of buffers updated.
 On failure they return
diff --git a/man/io_uring_register_files.3 b/man/io_uring_register_files.3
index 10ea665448b1694c..a4b00abf021edd09 100644
--- a/man/io_uring_register_files.3
+++ b/man/io_uring_register_files.3
@@ -46,9 +46,9 @@ for subsequent operations.
 
 The
 .BR io_uring_register_files_tags (3)
-function behaves the same as 
+function behaves the same as
 .BR io_uring_register_files (3)
-function but additionally takes 
+function but additionally takes
 .I tags
 parameter. See
 .B IORING_REGISTER_BUFFERS2
@@ -72,9 +72,9 @@ shared, for example if the process has ever created any threads, then this
 cost goes up even more. Using registered files reduces the overhead of
 file reference management across requests that operate on a file.
 
-The 
-.BR io_uring_register_files_update (3) 
-function updates existing registered files. The 
+The
+.BR io_uring_register_files_update (3)
+function updates existing registered files. The
 .I off
 is offset on which to start the update
 .I nr_files
@@ -83,13 +83,13 @@ number of files defined by the array
 belonging to the
 .IR ring .
 
-The 
+The
 .BR io_uring_register_files_update_tag (3)
-function behaves the same as 
-.BR io_uring_register_files_update (3) 
-function but additionally takes 
+function behaves the same as
+.BR io_uring_register_files_update (3)
+function but additionally takes
 .I tags
-parameter. See 
+parameter. See
 .B IORING_REGISTER_BUFFERS2
 for the resource tagging description.
 
@@ -99,7 +99,7 @@ On success
 .BR io_uring_register_files_tags (3)
 and
 .BR io_uring_register_files_sparse (3)
-return 0. 
+return 0.
 .BR io_uring_register_files_update (3)
 and
 .BR io_uring_register_files_update_tag (3)
-- 
Ammar Faizi

