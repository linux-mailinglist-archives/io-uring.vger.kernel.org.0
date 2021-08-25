Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E3F3F7504
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 14:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240796AbhHYMY2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 08:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240593AbhHYMY2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 08:24:28 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963B1C061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 05:23:42 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id i6so12397885wrv.2
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 05:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aQBGe6ZWHQBok6ZPn01BvZZ+NbYvSJR6YPVFOl4OgIc=;
        b=dssxpB9WecqSQyrvobrEKnXkbldqcTPJaNs4QhivFMZ4MuNuvOBhjDgYj3Ni6rxU/Z
         GqV7xKhhlAS6sZQLkv2c6ybSQCWsIIH/GfLwdw6dBRza8gw/jcRjizaRQCvoGOxydou+
         PzaykZkqqYq52uIbG5Iaf5LrRgBMmgFeiCq3NgIMc0RA0p7U9rFFany0uQVNzyY0zugk
         bsJ9XsOmLxGEJZuChInFGy8KAg6CG6zgRALTT63X4TYA9IZkJ/dtoZETkc4gtEQ5HLfW
         ztVJ7fWn1PsP4mv2sI1JREd8RzUnBUauQZS5h1oTHw0OPZW4xvOUMPoGUdKIo1nqfxc3
         9UCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aQBGe6ZWHQBok6ZPn01BvZZ+NbYvSJR6YPVFOl4OgIc=;
        b=f09IVMejva/+dWdbrWKvRBiPQhdNaF8TLyijW++Oh7mYmTLl3qxwVEIbA1lO5cJsrq
         mDfRbgBhjIUjUukkh10v6RtoAJ40vQmUd/LG4hRwOTvJuzG21DERZh1TVxhzh8IWPGge
         XWr7LfKf3fe2IEKfVV147fzTmBatQ/bxV3/otAklW5cSgxQCdZcFzp5Bwig8oTMRqfhB
         f29MbLVI5E+C7VJgEZLwRCVXs9P7X0HLl2pR5CIDndALbUtAob+4tPybhD0ugGjIZG/D
         goeMhoN/eLL+CtdSJm4uvCr6j64JtGQVMxV0fEe57LaAsRl9Ra+BPt7K6IJind/t1Mjg
         nJ0Q==
X-Gm-Message-State: AOAM530VRjWZ2DT5IE30GeDliyJ0w6cP15t14AQT2KjquBNElf0dN4Xh
        UWM5DxczMW+I/J5US4+UI2fOSCszImA=
X-Google-Smtp-Source: ABdhPJxZhNV7WzJ4tXd1OSo+I8rdXnx0Rg+qUSFqTAPzl5t2M/9JNPqtZZZFI+aT3g7XWNwuznGQWA==
X-Received: by 2002:a5d:64e6:: with SMTP id g6mr13987243wri.288.1629894221285;
        Wed, 25 Aug 2021 05:23:41 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id l12sm5226199wms.24.2021.08.25.05.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 05:23:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/2] liburing.h: dedup poll mask conversion
Date:   Wed, 25 Aug 2021 13:23:02 +0100
Message-Id: <9035fff2bde1c54bcac87ca48dfcfc54e6a815ab.1629893954.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629893954.git.asml.silence@gmail.com>
References: <cover.1629893954.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Poll mask LE/BE translation is ugly enough to want to hide it in a
helper and not hand code many times.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index d20dd25..0ec07ee 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -313,14 +313,19 @@ static inline void io_uring_prep_sendmsg(struct io_uring_sqe *sqe, int fd,
 	sqe->msg_flags = flags;
 }
 
-static inline void io_uring_prep_poll_add(struct io_uring_sqe *sqe, int fd,
-					  unsigned poll_mask)
+static inline unsigned __io_uring_prep_poll_mask(unsigned poll_mask)
 {
-	io_uring_prep_rw(IORING_OP_POLL_ADD, sqe, fd, NULL, 0, 0);
 #if __BYTE_ORDER == __BIG_ENDIAN
 	poll_mask = __swahw32(poll_mask);
 #endif
-	sqe->poll32_events = poll_mask;
+	return poll_mask;
+}
+
+static inline void io_uring_prep_poll_add(struct io_uring_sqe *sqe, int fd,
+					  unsigned poll_mask)
+{
+	io_uring_prep_rw(IORING_OP_POLL_ADD, sqe, fd, NULL, 0, 0);
+	sqe->poll32_events = __io_uring_prep_poll_mask(poll_mask);
 }
 
 static inline void io_uring_prep_poll_multishot(struct io_uring_sqe *sqe,
@@ -343,10 +348,7 @@ static inline void io_uring_prep_poll_update(struct io_uring_sqe *sqe,
 {
 	io_uring_prep_rw(IORING_OP_POLL_REMOVE, sqe, -1, old_user_data, flags,
 			 (__u64)(uintptr_t)new_user_data);
-#if __BYTE_ORDER == __BIG_ENDIAN
-	poll_mask = __swahw32(poll_mask);
-#endif
-	sqe->poll32_events = poll_mask;
+	sqe->poll32_events = __io_uring_prep_poll_mask(poll_mask);
 }
 
 static inline void io_uring_prep_fsync(struct io_uring_sqe *sqe, int fd,
-- 
2.32.0

