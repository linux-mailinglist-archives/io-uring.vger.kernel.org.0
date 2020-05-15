Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5601D5660
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 18:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgEOQnk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 12:43:40 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35559 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726144AbgEOQnj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 12:43:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589561018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nL7HAnv8SzKDMqV5nM3SX2JgjjSbWVcWPVCx7qYeT8c=;
        b=JbXxCU1G066rKGEoMAo3MjwSYaWX5JmvDjQb57fQcb7HqVN0GhexDZfyn0oroEN0425ubw
        os0WIl2epii1yHXbdEphxQ68eDIRUGC471VKI2ZHnurWs54aDF+8/Sf/WL/ThlmpWYXypv
        hIkYorXBTz23kC6toJSFeL9edCeCAWo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-Y4Hgx5KXPZysWZmdRS_geA-1; Fri, 15 May 2020 12:43:36 -0400
X-MC-Unique: Y4Hgx5KXPZysWZmdRS_geA-1
Received: by mail-wr1-f70.google.com with SMTP id d16so1431312wrv.18
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 09:43:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nL7HAnv8SzKDMqV5nM3SX2JgjjSbWVcWPVCx7qYeT8c=;
        b=JfT5YYyC7ROfz6Baoadu/JAXkVkeaeylIP8Zh+eIQwYai16xjDThJ1jtYMC85fyzJ3
         hBYxFt/I34ptwKgVb9TcqHsre9l1/pvGB1r/rHA6Hvch0e0VmqZ8BuQzjch/GWxZFhae
         QS5cfkLjqKYbL63tqUjGIrrz1vqkfW5Bdnghc3YYuDVOlZELoIGDL8xUNqmqoyIChDLF
         YeKAEX7vTcxC4MWr725M6bxXI/a1G/Ff7jOHrfTy5oxTL1gaj9ZOQ7T0caLbtjDRGRZo
         35H76+hZAUg0fRBdnchgW4siMqRj2hNUADfWdAba9lzYP24oRQfPfDMeqLOYDMPq6NiL
         wJDA==
X-Gm-Message-State: AOAM530JcqpbZbg7mHdSfLQXL2cYM/L/XKMZ4HJRA1+PUca8nJHa6mqF
        FjSMpCLn5dbuAtl/u8gmY/Iv/KECfRMEjvJhJVnO22Bbae3wbWZ3vEFNC52/TADSMrZYlHx5wid
        SQRWtQ0dmpk39r8fHomU=
X-Received: by 2002:a1c:720d:: with SMTP id n13mr4887490wmc.130.1589561014860;
        Fri, 15 May 2020 09:43:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzq7+lyH0XgFbtwA1B2jVaUKrnp5Zj82slueWX2QOeTWzp4kgQ9sht9TJEQcAws4uCX+FMCPQ==
X-Received: by 2002:a1c:720d:: with SMTP id n13mr4887469wmc.130.1589561014595;
        Fri, 15 May 2020 09:43:34 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id v126sm4512322wmb.4.2020.05.15.09.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 09:43:33 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 1/5] Add CQ ring 'flags' field
Date:   Fri, 15 May 2020 18:43:27 +0200
Message-Id: <20200515164331.236868-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515164331.236868-1-sgarzare@redhat.com>
References: <20200515164331.236868-1-sgarzare@redhat.com>
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
index dd85f7b..ea596f6 100644
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
index e48d746..602bb0e 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -204,7 +204,9 @@ struct io_cqring_offsets {
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

