Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD530312868
	for <lists+io-uring@lfdr.de>; Mon,  8 Feb 2021 00:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhBGXgv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Feb 2021 18:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBGXgu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Feb 2021 18:36:50 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F32C061788
        for <io-uring@vger.kernel.org>; Sun,  7 Feb 2021 15:36:10 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id w4so11167414wmi.4
        for <io-uring@vger.kernel.org>; Sun, 07 Feb 2021 15:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=phRnIv2u7rghaycoPn92tkl1mf9MNGCRVwcMC5tYdt0=;
        b=EFDA1PTfF6vJQc8nVhNw1wnuo38OKfVLbNHof8oWEkvpkBq/RWJn6VMCIkzSHFurfL
         qtH/J+MqTkAKCBJJGSQBmCMCH0q3vXTmHl3SbE3XP8N5zUbnsc9KkOF2ChcLGZbSmDJZ
         dcMjPXeEfFRMVjxqYBJBHgWejlRNWHcSMd6rCqoC50vLdihqF7CZkKGAKsro4xpzduhz
         wnGDWzGR7MEfkubSJIruLt+ZuD2Xh7ZDfcuUQ2ONKnF6TwnBnXBl0Hjd7XkFqbjBrxdB
         DDNnqBjZ56SjHHAac2kmVb3IooGvrz5CE5OC/ucXMz+BAfzjk26ZpO2UvzZR1eUsrJdS
         jLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=phRnIv2u7rghaycoPn92tkl1mf9MNGCRVwcMC5tYdt0=;
        b=pitJ++H7dVSkfx8Wj9Eu2w2pcMHZc+yb1oFPI+jIVV1SW6IqMa8FD5iqX1C7JNEW0I
         I/Y3j03NFPR5rXa/rf7cvORGyw7XZ0AH/VVoytpWSh5EtyHgiWO6QQ0cy37A/SOzMPCZ
         Qdg006vFcMcL0O4TM9xVzyjRVdSFXZEoNHCLqorYegTh94MblBPoEx5xHfZ3xCrvJ+pF
         +WGfgH35EUjFA+ReRySJPCsMMhLAP+4XMn9JsCUik15t5OHmNvpqSY40zbjM7IskUBXf
         YakDQ+x+H+ANViyNa29HvCEbX48ZkC26nZb+zK6wiTIJkJUj1yII1h3Z/grrlW7hkpKB
         ICig==
X-Gm-Message-State: AOAM5312e7k6Mk7ZgyBf84mRUn2pvwU97nSfT2vKSyqmC4/2pKUvhBpi
        86VGyLBEsOIfCt1mREq5U9A=
X-Google-Smtp-Source: ABdhPJyauwPMMcNtDRAAYhcYKc2H1XbbAMnrCWCUeekfpeQCzeeL5tNHYDrTESC8iqHU3QXPqD4dHA==
X-Received: by 2002:a1c:2905:: with SMTP id p5mr12057228wmp.156.1612740969276;
        Sun, 07 Feb 2021 15:36:09 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id l10sm25453380wro.4.2021.02.07.15.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 15:36:08 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/3] src/queue: clean _io_uring_get_cqe() err handling
Date:   Sun,  7 Feb 2021 23:32:16 +0000
Message-Id: <3901e2c04937f30b95b1126929611338c2ac4885.1612740655.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612740655.git.asml.silence@gmail.com>
References: <cover.1612740655.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Doesn't change behaviour, just a little cleanup.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/queue.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index dd1df2a..be461c6 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -117,8 +117,11 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 					data->sz);
 		if (ret < 0) {
 			err = -errno;
-		} else if (ret == (int)data->submit) {
-			data->submit = 0;
+			break;
+		}
+
+		data->submit -= ret;
+		if (ret == (int)data->submit) {
 			/*
 			 * When SETUP_IOPOLL is set, __sys_io_uring enter()
 			 * must be called to reap new completions but the call
@@ -127,12 +130,10 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 			 */
 			if (!(ring->flags & IORING_SETUP_IOPOLL))
 				data->wait_nr = 0;
-		} else {
-			data->submit -= ret;
 		}
 		if (cqe)
 			break;
-	} while (!err);
+	} while (1);
 
 	*cqe_ptr = cqe;
 	return err;
-- 
2.24.0

