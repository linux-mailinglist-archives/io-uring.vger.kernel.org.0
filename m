Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD3F124EEB
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfLRRSr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:18:47 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:38753 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRRSq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:18:46 -0500
Received: by mail-il1-f193.google.com with SMTP id f5so2349425ilq.5
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 09:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YUyDVNzQApn7TZGymEi5w5t6vqIBtznv0px7rEQuLzQ=;
        b=g1Es3spPbvpREJ4zgZ9oM9Cyk82VnddJHOgAWyiVIGJxg/S5mB+TBuQY06EVGM0dsG
         /3H1P887ov+hZHKvkWK2CMYo6OcK4A/6YmLiodAeR5l1kNIC732uH/8Yvh4gWKrFtXhB
         9sMmgT/2HPINpwZHZC7G3Ni/C40vk6JFGX54xNlb2KVHlObFk/BK65NFWJdpWajJ8ITL
         gbvtnbIOvJU7vUfgaof0t4zP9PgQqBvXgjA7G4oA+s+J8sG6rFUKfloshJ5wchbvqAs2
         cBt1mUdpxD3evppzp9mh9IUesdF4JdEvYikasr3fVKeg6jdpX5avTIjT3u8Fnxx0pI6a
         TcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YUyDVNzQApn7TZGymEi5w5t6vqIBtznv0px7rEQuLzQ=;
        b=pImTqAT45H0RAuLvRJrd3hspnR+IKo/YHQa3OMNhiFpKy4B04YVPncvv5ZMCcMuOCG
         0+Ii4oAzH8A+BJogflI7QnXCoWouXbbjUe0uuPVYwgGA/wtYttg48+NEh4eC9jpJhzgJ
         LAxSSrkQUxG8HYU0LZfnLdQOiEYEexU646ak8+2jOK4SXTJajKDf5hsYQC0UKozi3iis
         RDRyEbPtbrTljrGHjq7I5o2g+00TRmJzB+dbzSxBoJ7K+JdCwcrgBKh16NRu48JX1z99
         Ko5G18jXG2wiGnI61GZw05t4o9NI0MS/aZ1afHE8sx1yCw/WjysmU3TPBW9GyBPYdwgj
         ApyA==
X-Gm-Message-State: APjAAAWJKaHFK1WoDW4sEJx8rcRLSGGPIhmU9GnLM1p+jK+csla1NRJ6
        tnNCU70LAkozzVK7dZ9Y6isAa/IGj+0LUA==
X-Google-Smtp-Source: APXvYqz4nGZWTqtB2T0cvWCIT+FUhV2zAr2OcwOPGggB5IMNDMWriArWN+DzL45gy/bnO9xrm/Q/3w==
X-Received: by 2002:a92:4992:: with SMTP id k18mr2832317ilg.10.1576689525727;
        Wed, 18 Dec 2019 09:18:45 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm577488ioh.42.2019.12.18.09.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:18:45 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/13] io-wq: re-add io_wq_current_is_worker()
Date:   Wed, 18 Dec 2019 10:18:25 -0700
Message-Id: <20191218171835.13315-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218171835.13315-1-axboe@kernel.dk>
References: <20191218171835.13315-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit 8cdda87a4414, we now have several use csaes for this
helper. Reinstate it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index fb993b2bd0ef..3f5e356de980 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -120,6 +120,10 @@ static inline void io_wq_worker_sleeping(struct task_struct *tsk)
 static inline void io_wq_worker_running(struct task_struct *tsk)
 {
 }
-#endif /* CONFIG_IO_WQ */
+#endif
 
-#endif /* INTERNAL_IO_WQ_H */
+static inline bool io_wq_current_is_worker(void)
+{
+	return in_task() && (current->flags & PF_IO_WORKER);
+}
+#endif
-- 
2.24.1

