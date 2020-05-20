Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997351DBAB3
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 19:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgETRHX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 13:07:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57979 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726566AbgETRHW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 13:07:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589994440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=05KQX8lVPlCt8vmRWHdvXIWoBaoV9a3Uogcp9WxiQ8g=;
        b=dpf5fKUsxaKIDTiQMZYZpXZqpnsXuKEYMVeKYO4eyI5dPwxI0ve2ZPaOhor7oWAytRDk6b
        rWBwFO0z5c+1vtawytRylBrVjsqbaNoH85pGWU6MSWhC+dWlucolq2dpQOk1Q9tjjLWiSH
        TphmDVS61eU4m6SPbXgjt0Fw1VkCH4k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-h-LmWqDWPAinB8za52OApQ-1; Wed, 20 May 2020 13:07:18 -0400
X-MC-Unique: h-LmWqDWPAinB8za52OApQ-1
Received: by mail-wr1-f70.google.com with SMTP id p8so1666104wrj.5
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 10:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=05KQX8lVPlCt8vmRWHdvXIWoBaoV9a3Uogcp9WxiQ8g=;
        b=cbUBJJfMZ/uu9a8Yc0L8hFRnndC+nV+PGc8Zi+XVY2Z7qsk17FbQB/woCc9CkbaFql
         jPuZyUk7du3X548Mtbw4/8ekDLF04mvaYtN6M8x5q8/FXRdKeiOGhtYCj2c8+DIP0jwm
         isR50yAxkgOd38BRWOhtRcUSBThKAph5VbYWsr/NKbiwOXWeR17IxVgjgs9aagfOegoA
         AwoFeVJn+lZmzS3X31XXLXCbwep+9z1Y7RIspYndlTwnK+cfDS6rFxFkOXJIS1AipUIM
         lOCx68zUoc54ISdDRbl/vq5Z19B3dwefq3J82ZPh4Z6+hsXUXv/2u/mbqDaao4relvG3
         aLYQ==
X-Gm-Message-State: AOAM530XkS3fo4vb2XhYtXO7760/waAzbipk0UcL2zj6CSllUcD4olRO
        mdI4GZrw2QrNCeSkZj2OhYl5y1aTamkfsvXboI7TZZohy8rCPZ9EC5+c3ymtSsbqeYkdMI5eKnV
        MgRyk/6DqbhQz+JlLWvA=
X-Received: by 2002:adf:a15c:: with SMTP id r28mr256971wrr.337.1589994437575;
        Wed, 20 May 2020 10:07:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+adX5YucyY7E4vzhaND3YOzLEGdbHzr9/aBODa2oQodWTjohpKwnZCVuELuNx5MWcx6XbzQ==
X-Received: by 2002:adf:a15c:: with SMTP id r28mr256959wrr.337.1589994437393;
        Wed, 20 May 2020 10:07:17 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id u74sm3768614wmu.13.2020.05.20.10.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 10:07:16 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH liburing v2 1/5] Add CQ ring 'flags' field
Date:   Wed, 20 May 2020 19:07:10 +0200
Message-Id: <20200520170714.68156-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200520170714.68156-1-sgarzare@redhat.com>
References: <20200520170714.68156-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring provides the new CQ ring 'flags' field if 'cq_off.flags'
is not zero. In this case we set the 'cq->kflags' pointer, otherwise
it will be NULL.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 src/include/liburing.h          | 1 +
 src/include/liburing/io_uring.h | 4 +++-
 src/setup.c                     | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 4311325..adc8db9 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -41,6 +41,7 @@ struct io_uring_cq {
 	unsigned *ktail;
 	unsigned *kring_mask;
 	unsigned *kring_entries;
+	unsigned *kflags;
 	unsigned *koverflow;
 	struct io_uring_cqe *cqes;
 
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index a279151..9860a8a 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -205,7 +205,9 @@ struct io_cqring_offsets {
 	__u32 ring_entries;
 	__u32 overflow;
 	__u32 cqes;
-	__u64 resv[2];
+	__u32 flags;
+	__u32 resv1;
+	__u64 resv2;
 };
 
 /*
diff --git a/src/setup.c b/src/setup.c
index f783b6a..860c112 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -76,6 +76,8 @@ err:
 	cq->kring_entries = cq->ring_ptr + p->cq_off.ring_entries;
 	cq->koverflow = cq->ring_ptr + p->cq_off.overflow;
 	cq->cqes = cq->ring_ptr + p->cq_off.cqes;
+	if (p->cq_off.flags)
+		cq->kflags = cq->ring_ptr + p->cq_off.flags;
 	return 0;
 }
 
-- 
2.25.4

