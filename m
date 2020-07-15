Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434B8221201
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 18:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgGOQJJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 12:09:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56576 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726858AbgGOQIq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 12:08:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594829292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hm3D3FsNVTEKu1cGCyBdM4Nc3R4HmkSQ9iUobZnA6n8=;
        b=eKqiqjL54IibxoZaiaaGh7PI3dEHtrc1vs0vmBZdd+gC4KLMekYtg15C2RREdoGYisZB6L
        MTEgNuUguMnjNsjstS5/X6MkrFC4NSeqiNREdcbzQkElWbS80pAKRYuwxOQYFxScpPvfT9
        qziQPiYz8RIViiVJG5G2tDOXQFr80D8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-lGWndESUPg2E1HhnmeIKmA-1; Wed, 15 Jul 2020 12:08:09 -0400
X-MC-Unique: lGWndESUPg2E1HhnmeIKmA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5E141083;
        Wed, 15 Jul 2020 16:08:08 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-13-249.pek2.redhat.com [10.72.13.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DBCE79D04;
        Wed, 15 Jul 2020 16:08:06 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/3] fsstress: reduce the number of events when io_setup
Date:   Thu, 16 Jul 2020 00:07:54 +0800
Message-Id: <20200715160755.14392-3-zlang@redhat.com>
In-Reply-To: <20200715160755.14392-1-zlang@redhat.com>
References: <20200715160755.14392-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

