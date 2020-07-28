Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144A8231193
	for <lists+io-uring@lfdr.de>; Tue, 28 Jul 2020 20:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732332AbgG1SXx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jul 2020 14:23:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45889 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728829AbgG1SXx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jul 2020 14:23:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595960632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hm3D3FsNVTEKu1cGCyBdM4Nc3R4HmkSQ9iUobZnA6n8=;
        b=jTpkDH9D7FQwS9vOEENWW3GuDq5wjW8EGdPTFuRDlb9GoSlj7bs1UCEOTNJws9QaqCqkKf
        e4ogXt/GrMdXjZsE/qrWKg4AA+46Kz8+DbzMRdx3y4Hz9+0PEKJqQNL4qqxNz3T2iIg+FI
        miOYH9lwW1ycn+aom6yDvPjEmmtRNrM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-q0sPd0y0NKqp9Ax5d7tOHQ-1; Tue, 28 Jul 2020 14:23:50 -0400
X-MC-Unique: q0sPd0y0NKqp9Ax5d7tOHQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A0B48017FB;
        Tue, 28 Jul 2020 18:23:49 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-12-108.pek2.redhat.com [10.72.12.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A31945D993;
        Tue, 28 Jul 2020 18:23:47 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org, jmoyer@redhat.com
Subject: [PATCH 2/4] fsstress: reduce the number of events when io_setup
Date:   Wed, 29 Jul 2020 02:23:18 +0800
Message-Id: <20200728182320.8762-3-zlang@redhat.com>
In-Reply-To: <20200728182320.8762-1-zlang@redhat.com>
References: <20200728182320.8762-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The original number(128) of aio events for io_setup is a little big.
When try to run lots of fsstress processes(e.g. -p 1000) always hit
io_setup EAGAIN error, due to the nr_events exceeds the limit of
available events. So reduce it from 128 to 64, to make more fsstress
processes can do AIO test.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 ltp/fsstress.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 388ace50..a11206d4 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -28,6 +28,7 @@
 #endif
 #ifdef AIO
 #include <libaio.h>
+#define AIO_ENTRIES	64
 io_context_t	io_ctx;
 #endif
 #ifdef URING
@@ -699,8 +700,8 @@ int main(int argc, char **argv)
 			}
 			procid = i;
 #ifdef AIO
-			if (io_setup(128, &io_ctx) != 0) {
-				fprintf(stderr, "io_setup failed");
+			if (io_setup(AIO_ENTRIES, &io_ctx) != 0) {
+				fprintf(stderr, "io_setup failed\n");
 				exit(1);
 			}
 #endif
@@ -714,7 +715,7 @@ int main(int argc, char **argv)
 				doproc();
 #ifdef AIO
 			if(io_destroy(io_ctx) != 0) {
-				fprintf(stderr, "io_destroy failed");
+				fprintf(stderr, "io_destroy failed\n");
 				return 1;
 			}
 #endif
-- 
2.20.1

