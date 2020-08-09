Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078C923FD02
	for <lists+io-uring@lfdr.de>; Sun,  9 Aug 2020 08:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgHIGa5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Aug 2020 02:30:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26885 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725988AbgHIGa5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Aug 2020 02:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596954656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HZ3iGdp7OPMi+6kd9idtublBxHGrjAF6VXW9ZEuiXd8=;
        b=X1pVvkoebFA2L23Mb+QxpEv03dW/DG/lds5fH+W1pvDXIvUqHUyI7BUHAqQ31ycamT7W4L
        CEaOD2gWchMlUUYyIWCPnXpLQ7wF0t+xnDLFZhvH+upYLursXXSVckAxkmUXUN0RkKRi3X
        GTv9loqnk3fYF/RETCxalAJ4wz+MUaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-PmCrZAXOM9-BDZdJmV-bVQ-1; Sun, 09 Aug 2020 02:30:54 -0400
X-MC-Unique: PmCrZAXOM9-BDZdJmV-bVQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13D5A107B806;
        Sun,  9 Aug 2020 06:30:53 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-33.pek2.redhat.com [10.72.12.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F91F5C6DD;
        Sun,  9 Aug 2020 06:30:51 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org, jmoyer@redhat.com
Subject: [PATCH v2 2/4] fsstress: reduce the number of events when io_setup
Date:   Sun,  9 Aug 2020 14:30:38 +0800
Message-Id: <20200809063040.15521-3-zlang@redhat.com>
In-Reply-To: <20200809063040.15521-1-zlang@redhat.com>
References: <20200809063040.15521-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index a4188e1c..0e7be6bb 100644
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

