Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFDD716820A
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 16:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgBUPm0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 10:42:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36353 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728177AbgBUPmZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 10:42:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582299744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=d1xiBHabr0cI0nVkv2W8qe7S3hdWOCkmluHZNS5Fdjo=;
        b=hn4c3G4/npfbIp3Q2/aPDvED3kNInUK2pxKzBO30oVUNcgA9hRyaqvPSAjZkLrkUUUt457
        WKVE3NRfYpaK5eyJDrCR7c0Qqun10nTKR3Z8b38Yi3MawuZ9jGxdr4mN3z1KVdcywIpd/S
        WBeNMhKku7DkebKSAdLHE7odSY/7k6w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-S1ZPMpjsMIiJOqjxNltFAA-1; Fri, 21 Feb 2020 10:42:21 -0500
X-MC-Unique: S1ZPMpjsMIiJOqjxNltFAA-1
Received: by mail-wm1-f69.google.com with SMTP id f207so733315wme.6
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 07:42:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d1xiBHabr0cI0nVkv2W8qe7S3hdWOCkmluHZNS5Fdjo=;
        b=BAXkujciAvJdEfF1RakrdxIgOo5K89sXUm+CnhA95XAVHf2Lw3b72YMrBwxESiwPYC
         I1wH+vSTFH5kxZpy2rOvMFNom4q3wSipKVwSk6X1hCtNkHM7OZLj6QHY6XGtxTLsF2lQ
         kaZP2YUJ0zpT572B7y4XBECfFRzRxlInIicz5gAIskAHqRaiEnZmMCJs6FwloM0frlXs
         vonkHRQPJ3bKFptC6g7e28JAuFCv70BOhzO0n4l3roCp0Noui4LV8BARZfh2pa4BSrxk
         7gFviZe6sbvCDxhcy5/aREVVtXrJTU6rO3CG7hwUIOqjeVkY9KdcBJpZrFfwdzp2NTbl
         LlSA==
X-Gm-Message-State: APjAAAV4blsqdxEFlxe8KVnh9+km3JyeFhKVmR44jcG6FV/NjFB9OsoX
        9g6vCyf4GAw5boBwgTazNFEQ0Bo2xCywDCN9CBgiPOnbxSEHYUF+cOoc9C7aYKZleXGwb0oHBqv
        HZdi636PxvV1CXrDfckk=
X-Received: by 2002:a7b:c753:: with SMTP id w19mr4665153wmk.34.1582299738379;
        Fri, 21 Feb 2020 07:42:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqzSWhT4n2jDvp8FWxa5PtF0QnBD+5CXqoCnpF/WyJoVcrZZSoX+kB/LMcPcy2QzVI9BPmha7Q==
X-Received: by 2002:a7b:c753:: with SMTP id w19mr4665132wmk.34.1582299738067;
        Fri, 21 Feb 2020 07:42:18 -0800 (PST)
Received: from steredhat.redhat.com (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id c9sm4238078wme.41.2020.02.21.07.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 07:42:17 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hannes Reinecke <hare@suse.com>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: prevent sq_thread from spinning when it should stop
Date:   Fri, 21 Feb 2020 16:42:16 +0100
Message-Id: <20200221154216.206367-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch drops 'cur_mm' before calling cond_resched(), to prevent
the sq_thread from spinning even when the user process is finished.

Before this patch, if the user process ended without closing the
io_uring fd, the sq_thread continues to spin until the
'sq_thread_idle' timeout ends.

In the worst case where the 'sq_thread_idle' parameter is bigger than
INT_MAX, the sq_thread will spin forever.

Fixes: 6c271ce2f1d5 ("io_uring: add submission polling")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Hi Jens,
I'm also sending a test to liburing for this case.

Cheers,
Stefano
---
 fs/io_uring.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5a826017ebb8..f902f77964ef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5138,6 +5138,18 @@ static int io_sq_thread(void *data)
 		 * to enter the kernel to reap and flush events.
 		 */
 		if (!to_submit || ret == -EBUSY) {
+			/*
+			 * Drop cur_mm before scheduling, we can't hold it for
+			 * long periods (or over schedule()). Do this before
+			 * adding ourselves to the waitqueue, as the unuse/drop
+			 * may sleep.
+			 */
+			if (cur_mm) {
+				unuse_mm(cur_mm);
+				mmput(cur_mm);
+				cur_mm = NULL;
+			}
+
 			/*
 			 * We're polling. If we're within the defined idle
 			 * period, then let us spin without work before going
@@ -5152,18 +5164,6 @@ static int io_sq_thread(void *data)
 				continue;
 			}
 
-			/*
-			 * Drop cur_mm before scheduling, we can't hold it for
-			 * long periods (or over schedule()). Do this before
-			 * adding ourselves to the waitqueue, as the unuse/drop
-			 * may sleep.
-			 */
-			if (cur_mm) {
-				unuse_mm(cur_mm);
-				mmput(cur_mm);
-				cur_mm = NULL;
-			}
-
 			prepare_to_wait(&ctx->sqo_wait, &wait,
 						TASK_INTERRUPTIBLE);
 
-- 
2.24.1

