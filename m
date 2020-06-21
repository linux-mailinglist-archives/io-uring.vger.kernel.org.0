Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34076202B87
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 18:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbgFUQQf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 12:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730397AbgFUQQe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 12:16:34 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B6AC061796
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 09:16:34 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q19so15419461eja.7
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 09:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=WQS4oRcqBhC6PDVcN7G6Rki0rdZ9v12xyGxHefadJeU=;
        b=GfnO6pHFPyRf1AILM9IDQteSXLv/ONSvWPHkJGr5ajOiIUe9zLupatlrWHREI3xKi0
         pko3V7wNG97NGrX02O4NqPdTE1GLQ5BmkvS5FuIgHt+dCgy4pifgNjn85flXFV7jJDOu
         Y7fVPt+wwgsMhYnxW9zZF1xg0LHIxhLGEbnKsll1G56QZAySIXm+8D0oAaaVKKx3X12p
         Djht8+ECLmUbj32dJNa0WLhilS821fGcm7G4ugsL+y5r7DMU/IJLruwXeyPpbTf/63YD
         cfKLQgnijrDA096ETRWA8YYXKq9rD25Udxeyp47CW99afbbO40BTYgGn2Vtv/un8vI6D
         V/WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WQS4oRcqBhC6PDVcN7G6Rki0rdZ9v12xyGxHefadJeU=;
        b=i6CEaNNkHoXnuggDThKf8qT2QbnHbTs70nhf1JrXUFTDlsXwbvzuymjOcVMQnB/OYh
         GBe443skmPox5tAatWy2RtzaP2yMQTTnITn46fG8QBenR6OXQgwGhYZXrUN/UGURTgEp
         QH88Z+gPfwhNtJo7+/iS4D5UU4Q27ys7B/YlxP2YWz7O7d09THPTZ2kk7XHmO+zKgDOJ
         Mi9S2CjjHkkvhW8q6cI/qKXzry5n7pux+hxqWIwSGvag7iu2nsWQwhiNlgMaNerMEj03
         KrEDph6DZIEUHFaEamR3kVDL3gvdWocAwHHyuYUh5r1MdXR9vTiG8g+O7fzoEACiFaqJ
         LRrQ==
X-Gm-Message-State: AOAM531TrEOOI0u+aFAb1vdtskjm7iMDyhvtdB3W8DNIW/mQ+PEY9hA9
        A46J5JD/ejlTF6CVfurwqhw=
X-Google-Smtp-Source: ABdhPJwnRN3VVTGn4MM0GOPlWw6n1N8B9b9fYEtRTG0nrNBShCFCAMw9zY+nKrQCMBsbAC+Zu7mNBA==
X-Received: by 2002:a17:906:d973:: with SMTP id rp19mr11510243ejb.475.1592756192841;
        Sun, 21 Jun 2020 09:16:32 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id 64sm10160292eda.85.2020.06.21.09.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 09:16:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 2/2] Fix hang in io_uring_get_cqe() with iopoll
Date:   Sun, 21 Jun 2020 19:14:26 +0300
Message-Id: <ffc6ac4081c54b7c244ae46f76d6b46a9868871b.1592755912.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592755912.git.asml.silence@gmail.com>
References: <cover.1592755912.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Because of need_resched() check, io_uring_enter() -> io_iopoll_check()
can return 0 even if @min_complete wasn't satisfied. If that's the
case, __io_uring_get_cqe() sets submit=0 and wait_nr=0, disabling
setting IORING_ENTER_GETEVENTS as well. So, it goes crazy calling
io_uring_enter() in a loop, not actually submitting nor polling.

Set @wait_nr based on actual number of CQEs ready. It doesn't manifest
extra CQEs if any, thus implements __io_uring_cq_ready() with relaxed
semantics.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/queue.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/src/queue.c b/src/queue.c
index 14a0777..d824cfd 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -32,6 +32,19 @@ static inline bool sq_ring_needs_enter(struct io_uring *ring,
 	return false;
 }
 
+static inline unsigned int __io_uring_cq_ready(struct io_uring *ring)
+{
+	return io_uring_smp_load_relaxed(ring->cq.ktail) - *ring->cq.khead;
+}
+
+static inline unsigned int io_adjust_wait_nr(struct io_uring *ring,
+					     unsigned int to_wait)
+{
+	unsigned int ready = __io_uring_cq_ready(ring);
+
+	return (to_wait <= ready) ? 0 : (to_wait - ready);
+}
+
 int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 		       unsigned submit, unsigned wait_nr, sigset_t *sigmask)
 {
@@ -60,7 +73,8 @@ int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 			err = -errno;
 		} else if (ret == (int)submit) {
 			submit = 0;
-			wait_nr = 0;
+			if (to_wait)
+				wait_nr = io_adjust_wait_nr(ring, to_wait);
 		} else {
 			submit -= ret;
 		}
-- 
2.24.0

