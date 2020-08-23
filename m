Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5612B24EBD2
	for <lists+io-uring@lfdr.de>; Sun, 23 Aug 2020 08:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgHWGa5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Aug 2020 02:30:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726187AbgHWGa5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Aug 2020 02:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598164256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KHSsubvm3481rzFN/9D/VRLXq7EY6wiu1vfSQsn/ZoE=;
        b=GXjiS7aQoUqvoGqopKuypw82HDPVhjpEo2vEzR40sywDzERww8ohgjcf/Fkr7bfm1Ar33Z
        M8VQfbp+tjoRaDc9psoFKw/4iiWXYPsgJ7moD6dbqWXa7usZSNYKd3vIBJLljWH2ULF3YN
        LnUAOyVzCpK/mOEhYDDAkI9R7tR0ppA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-F9togBYzMzeVN4mhdazErA-1; Sun, 23 Aug 2020 02:30:54 -0400
X-MC-Unique: F9togBYzMzeVN4mhdazErA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3239425CD;
        Sun, 23 Aug 2020 06:30:52 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-77.pek2.redhat.com [10.72.12.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A2EC60F96;
        Sun, 23 Aug 2020 06:30:51 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH v3 2/4] fsstress: reduce the number of events when io_setup
Date:   Sun, 23 Aug 2020 14:30:30 +0800
Message-Id: <20200823063032.17297-3-zlang@redhat.com>
In-Reply-To: <20200823063032.17297-1-zlang@redhat.com>
References: <20200823063032.17297-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index 7a0e278a..ef2017a8 100644
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

