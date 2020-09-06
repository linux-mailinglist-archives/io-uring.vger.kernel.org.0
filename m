Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FFA25EF65
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 19:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgIFRzf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Sep 2020 13:55:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53972 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726209AbgIFRzb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Sep 2020 13:55:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599414930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gTVUFOjmNGPItx0yFc9PQvMYCcQKYhuaxaFrNtS52Ks=;
        b=I6pI4AZ8lHv5UjLIZyURiTXQiCkkdRWQR5udYToT0QUZ9vLUkwdH83WXrVDik21gnKcSg4
        NHWKpMPUu+UTpdOypeyZwk2VDrOGPjy/VkQPJUzFR+1BdL2rGMKEdXOy+cfP3H/Pqs+aVR
        ALSHK3usJgixRQPiKHjJ/Ad2zDhQ3NM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-43rkGDvJP8irpoLWtEcMjA-1; Sun, 06 Sep 2020 13:55:28 -0400
X-MC-Unique: 43rkGDvJP8irpoLWtEcMjA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9097B18A224C;
        Sun,  6 Sep 2020 17:55:27 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-12-98.pek2.redhat.com [10.72.12.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A2DC9CBA;
        Sun,  6 Sep 2020 17:55:25 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     bfoster@redhat.com, io-uring@vger.kernel.org
Subject: [PATCH v4 2/5] fsstress: reduce the number of events when io_setup
Date:   Mon,  7 Sep 2020 01:55:10 +0800
Message-Id: <20200906175513.17595-3-zlang@redhat.com>
In-Reply-To: <20200906175513.17595-1-zlang@redhat.com>
References: <20200906175513.17595-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The original number(128) of aio events for io_setup too big. When try
to run lots of fsstress processes(e.g. -p 1000) always hit io_setup
EAGAIN error, due to the nr_events exceeds the limit of available
events. Due to each fsstress process only does once libaio read/write
operation each time. So reduce the aio events number to 1, to make more
fsstress processes can do AIO test.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 ltp/fsstress.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 2c584ef0..b4a51376 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -28,6 +28,7 @@
 #endif
 #ifdef AIO
 #include <libaio.h>
+#define AIO_ENTRIES	1
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
-- 
2.20.1

