Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802A6382B5B
	for <lists+io-uring@lfdr.de>; Mon, 17 May 2021 13:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhEQLpG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 May 2021 07:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhEQLpG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 May 2021 07:45:06 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F540C061573
        for <io-uring@vger.kernel.org>; Mon, 17 May 2021 04:43:49 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x8so6031619wrq.9
        for <io-uring@vger.kernel.org>; Mon, 17 May 2021 04:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/zdlMrmXvXJzdER0hkM0QBZvrgzkYtkj4a/L8Yq1X0A=;
        b=TNFYQUkAYYazqJIit6Vy0fe7wKHEdWc6zES3uIHEPbeQMV7uPx54tqJTyB8SOZZa99
         FL6Rb07f9eyMkspkIeh0djPpYeWaQ4mRFKAJEsq7VGPKOuCKhz0SK5xaYpuFZYdzqtZv
         9/qgE3P62Vk0O6Q+ss5rLHdzI4MBmaV+VtPn8DqDvqv8ooXnSmflDixz8t9b3SeBOvdn
         S1Pq5wSJ3LWMkNA1cWHAvgVe7niaqsyaz/Cq2+SvlmV7u38xFGSd52yOQRWmkTpn89m8
         cswW2rrwAf5Sq/3lq+F5Bv9DB1yA1tZKuIHIhwzRKBNIpA8m20aUh6AO08eOTiGDrgD/
         OztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/zdlMrmXvXJzdER0hkM0QBZvrgzkYtkj4a/L8Yq1X0A=;
        b=QF2wb0TTDE8/N6meQ7gmEkQfV+ECfuPjE65LCWD9SmA4By+JeKSB9vNcIBWVh8PL8Z
         CBggfG3LXfxYC2yBtQ6Pj4n7/8hpDX5V+SBK5nWm2194t9YKnENeW3hgYpXox29vbkXW
         +IJBKbVO1feSrOTuxmqcalyKORNuvsrsqX0DD6pBbk+cUX3iVqhgqs10EwcPjd5kRR0M
         UPlkdIzbIV6qXK6+qsGSMO8zU4UT1AI/Bo9nE5jBA4OJZ860F+XEXFkWP5YtxD9rPLVm
         x5L8pxfQRKctOGF0WwE/ULL5eQ+fW87+BX/IvezOFBhgAOR3StRDg5+brNKH34BHDP4g
         ggMA==
X-Gm-Message-State: AOAM532YbOSLnxZkWCCICqsvwQaC95ejAz9AGEh/av6OvZwH5J5MQEAF
        H0dDgtW+YAR1Tkv7l5NQnlU=
X-Google-Smtp-Source: ABdhPJyPmTfMBQ8I0D7ViHQ9WwWomb6N2KJVmjY5ATepzrrDPkyTxmsvksXefs8vNL467EGRr01J+Q==
X-Received: by 2002:adf:fa52:: with SMTP id y18mr16643313wrr.355.1621251827932;
        Mon, 17 May 2021 04:43:47 -0700 (PDT)
Received: from agony.thefacebook.com ([2620:10d:c093:600::2:e1e0])
        by smtp.gmail.com with ESMTPSA id g206sm5055177wme.16.2021.05.17.04.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 04:43:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+a84b8783366ecb1c65d0@syzkaller.appspotmail.com
Subject: [PATCH 1/1] io_uring: don't modify req->poll for rw
Date:   Mon, 17 May 2021 12:43:34 +0100
Message-Id: <4a6a1de31142d8e0250fe2dfd4c8923d82a5bbfc.1621251795.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_queue_proc() is used by both poll and apoll, so we should not
access req->poll directly but selecting right struct io_poll_iocb
depending on use case.

Reported-and-tested-by: syzbot+a84b8783366ecb1c65d0@syzkaller.appspotmail.com
Fixes: ea6a693d862d ("io_uring: disable multishot poll for double poll add cases")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e387ce687f4d..63f6b11d271b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5016,10 +5016,10 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 		 * Can't handle multishot for double wait for now, turn it
 		 * into one-shot mode.
 		 */
-		if (!(req->poll.events & EPOLLONESHOT))
-			req->poll.events |= EPOLLONESHOT;
+		if (!(poll_one->events & EPOLLONESHOT))
+			poll_one->events |= EPOLLONESHOT;
 		/* double add on the same waitqueue head, ignore */
-		if (poll->head == head)
+		if (poll_one->head == head)
 			return;
 		poll = kmalloc(sizeof(*poll), GFP_ATOMIC);
 		if (!poll) {
-- 
2.31.1

