Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E6241FDBF
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 20:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhJBSit (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Oct 2021 14:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbhJBSis (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Oct 2021 14:38:48 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51744C0613EC
        for <io-uring@vger.kernel.org>; Sat,  2 Oct 2021 11:37:02 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id dn26so47264456edb.13
        for <io-uring@vger.kernel.org>; Sat, 02 Oct 2021 11:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xVUMrUQlO+NfOnqKJgwWbIAW/9rVaUDMkLw/zBuDLhs=;
        b=qYoGl+cRn/R6BoURU2TSr+wvedV756fmB0dHYp3TwqAc6H+nV0yZhxSKwlze31sUTw
         7Vc12ebqWTEuwAyf0UoRdvK4P6+ikms1osT6+X1gNw2PVUVoY2ZGg0ilRG5WkoZ9WqT+
         rfRSvi+z5m/f6px3zfHB7gxldds3o2JH2t4zCaEkxiF2aQb+Ce0jXZ9eXT3rcoNDHcBf
         AanzH3sqTev5hopZuz3irS8CmLNng29V3CoGy5xC9Mrj7i2InH/Eq3vWUrOnMYSSb5de
         jLA475bXpG6H4NhWxKmpyBHko7z5pmfIlTmDGR6BT4RqDW++9PWAaa51agnEAk+Ja8Zp
         1DQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xVUMrUQlO+NfOnqKJgwWbIAW/9rVaUDMkLw/zBuDLhs=;
        b=k+BDeObWRTdNv5BJ8QHHQUn2uYxeX5Svy7JYEdCXtAyKevyxXwszeZOOiP+Hb7kPyy
         JRT7giIACMGyX4OfYIqaVIfead0efY7Ww2pi352BwQu4sAsYx9InyhCy4Em8RZtUpPHC
         feZWKpd1D+X/TrI9U4HSUpzWMqOvl0p294EvN2Q23xTdRj2jlh+UT2ZYDnxviY5LQSIK
         7NYKN6dQNX+joNMW6K3zFGyj8LlHVbflIZyZjYQRYP4HUlpbZ/uFzV4OF8eDO/qjKzkQ
         P4L/Cn1wlzUS5mh8XMhC6v3soGMqcpIyuudCruFkumpdwIBiddnFCwSCyaaouyMnGn2O
         AsKw==
X-Gm-Message-State: AOAM532fdFkmyU89A/X8vWnRl5wVHKgFZJgeg6xFHqK+pIF+BEVyRPXB
        cUMwLt+QA7gddgRybSEpqR0B73nqxuU=
X-Google-Smtp-Source: ABdhPJz0tyv9j6/Tz+2AapR/h3/VIvNAoNJGoLZike/ynyhbrAsBKXik6VKoQgYwkmkbZMjXdnitrQ==
X-Received: by 2002:a17:907:3d9f:: with SMTP id he31mr5997834ejc.255.1633199820740;
        Sat, 02 Oct 2021 11:37:00 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id ee13sm2759996edb.14.2021.10.02.11.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 11:37:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3] io_uring: add flag to not fail link after timeout
Date:   Sat,  2 Oct 2021 19:36:14 +0100
Message-Id: <17c7ec0fb7a6113cc6be8cdaedcada0ba836ac0e.1633199723.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For some reason non-off IORING_OP_TIMEOUT always fails links, it's
pretty inconvenient and unnecessary limits chaining after it to hard
linking, which is far from ideal, e.g. doesn't pair well with timeout
cancellation. Add a flag forcing it to not fail links on -ETIME.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: conditional behaviour with a new timeout flag
v3: renaming (Jens)

 fs/io_uring.c                 | 8 ++++++--
 include/uapi/linux/io_uring.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c1ad5817b114..a9eefd74b7e1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5860,7 +5860,10 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 
 static void io_req_task_timeout(struct io_kiocb *req, bool *locked)
 {
-	req_set_fail(req);
+	struct io_timeout_data *data = req->async_data;
+
+	if (!(data->flags & IORING_TIMEOUT_ETIME_SUCCESS))
+		req_set_fail(req);
 	io_req_complete_post(req, -ETIME, 0);
 }
 
@@ -6066,7 +6069,8 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (off && is_timeout_link)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->timeout_flags);
-	if (flags & ~(IORING_TIMEOUT_ABS | IORING_TIMEOUT_CLOCK_MASK))
+	if (flags & ~(IORING_TIMEOUT_ABS | IORING_TIMEOUT_CLOCK_MASK |
+		      IORING_TIMEOUT_ETIME_SUCCESS))
 		return -EINVAL;
 	/* more than one clock specified is invalid, obviously */
 	if (hweight32(flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b270a07b285e..c45b5e9a9387 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -158,6 +158,7 @@ enum {
 #define IORING_TIMEOUT_BOOTTIME		(1U << 2)
 #define IORING_TIMEOUT_REALTIME		(1U << 3)
 #define IORING_LINK_TIMEOUT_UPDATE	(1U << 4)
+#define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
 /*
-- 
2.33.0

