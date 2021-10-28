Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCF843DCA8
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 10:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhJ1IKz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 04:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhJ1IKz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 04:10:55 -0400
Received: from out10.migadu.com (out10.migadu.com [IPv6:2001:41d0:2:e8e3::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D081DC061570;
        Thu, 28 Oct 2021 01:08:20 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1635408499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZvZCJVuHX1kdtjJ4rxf8UDdnwoMvm6VexH1bwaTv270=;
        b=QfaZMLJyeQRs44fTwoBALQer/jqyU/AAhwcF4IkLbIRHlBopkYQMZYx10tkG/6+zvcI0Xa
        j+fqD6jtlr/AmsYJ39VvsSC+DOvs+VB/hIzxel7ABaGbk1+JFYQVv5R9wt7TsDIYscA0Yc
        q3vEJsbMKeGN0ItGaVuN/TE3ZJwHzgDpsC2F/DerxctjxatFoRQYOeYNFdjsceeyT8zSmI
        5CH86ZLa93U8kgmF0sEn0htGncZihQkK8ChPzqP/V8D5sqKgntwhHcTjx023RMKTilcPv0
        RkYbjLgO16uy9K/L91MHu+0I89daD0lZOiqrBHHf9jQVVZpEUByjxQkSnkFDNA==
From:   Drew DeVault <sir@cmpwn.com>
To:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     Drew DeVault <sir@cmpwn.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Date:   Thu, 28 Oct 2021 10:08:13 +0200
Message-Id: <20211028080813.15966-1-sir@cmpwn.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This limit has not been updated since 2008, when it was increased to 64
KiB at the request of GnuPG. Until recently, the main use-cases for this
feature were (1) preventing sensitive memory from being swapped, as in
GnuPG's use-case; and (2) real-time use-cases. In the first case, little
memory is called for, and in the second case, the user is generally in a
position to increase it if they need more.

The introduction of IOURING_REGISTER_BUFFERS adds a third use-case:
preparing fixed buffers for high-performance I/O. This use-case will
take as much of this memory as it can get, but is still limited to 64
KiB by default, which is very little. This increases the limit to 8 MB,
which was chosen fairly arbitrarily as a more generous, but still
conservative, default value.
---
It is also possible to raise this limit in userspace. This is easily
done, for example, in the use-case of a network daemon: systemd, for
instance, provides for this via LimitMEMLOCK in the service file; OpenRC
via the rc_ulimit variables. However, there is no established userspace
facility for configuring this outside of daemons: end-user applications
do not presently have access to a convenient means of raising their
limits.

The buck, as it were, stops with the kernel. It's much easier to address
it here than it is to bring it to hundreds of distributions, and it can
only realistically be relied upon to be high-enough by end-user software
if it is more-or-less ubiquitous. Most distros don't change this
particular rlimit from the kernel-supplied default value, so a change
here will easily provide that ubiquity.

 include/uapi/linux/resource.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/resource.h b/include/uapi/linux/resource.h
index 74ef57b38f9f..c858c3c85fae 100644
--- a/include/uapi/linux/resource.h
+++ b/include/uapi/linux/resource.h
@@ -66,10 +66,17 @@ struct rlimit64 {
 #define _STK_LIM	(8*1024*1024)
 
 /*
- * GPG2 wants 64kB of mlocked memory, to make sure pass phrases
- * and other sensitive information are never written to disk.
+ * Limit the amount of locked memory by some sane default:
+ * root can always increase this limit if needed.
+ *
+ * The main use-cases are (1) preventing sensitive memory
+ * from being swapped; (2) real-time operations; (3) via
+ * IOURING_REGISTER_BUFFERS.
+ *
+ * The first two don't need much. The latter will take as
+ * much as it can get. 8MB is a reasonably sane default.
  */
-#define MLOCK_LIMIT	((PAGE_SIZE > 64*1024) ? PAGE_SIZE : 64*1024)
+#define MLOCK_LIMIT	((PAGE_SIZE > 8*1024*1024) ? PAGE_SIZE : 8*1024*1024)
 
 /*
  * Due to binary compatibility, the actual resource numbers
-- 
2.33.1

