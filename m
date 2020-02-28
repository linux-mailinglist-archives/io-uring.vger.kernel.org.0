Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 399961731E2
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 08:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgB1Hho (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 02:37:44 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36414 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgB1Hhn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 02:37:43 -0500
Received: by mail-wm1-f65.google.com with SMTP id f19so2124610wmh.1
        for <io-uring@vger.kernel.org>; Thu, 27 Feb 2020 23:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=h3HK8blp4v1LjOiPEFB5dLOVJG89/ojTZyUi5ZYX994=;
        b=obmmLsW5qnmAnlQcvDL/j6GuKzTMaqWa1DaCb3UmVlMHvDtOVuLiAUbDZ3wZ4YS4RQ
         820MceBQk4Dkke2tpR6lYZVUOGN9TZyzoGyDUgZxAFZkNyfWPbZvE/OwfArjYY4GwV+B
         URiWVey7eb1yJ72UgAzCMMUFQfGXXu0spHMrMTnksUOAsf7A+rFMTGfQlYV5tc++4gIW
         IWQSLBZBecwEN1Qzw5jkEznB54vhfKQ/hqBlftvpypCD8AIJxuO/eUQ0z5VFwWmlQL50
         v25JvnTuf6DJXh2W1kORK8ZbvzDBpKw4VEzxOR68WnAkPoUZTHDpYzTqYjO+OnAnXniD
         27zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h3HK8blp4v1LjOiPEFB5dLOVJG89/ojTZyUi5ZYX994=;
        b=qlB8woZghg8H6iggHisurk2Ye7wPHsvJ41xYNm8hKtcJJ5WO46C79pWBnPuNW3UCwa
         JwOPSzMBOE/0e+nPIU4cDf12AXMt3lnE+n/IgGZMYyuVppnMucjWXwq1EZyI8T9rNBi4
         SMyuDHfLvQaIyn/JjLNomT+uZUnqYDakPG19eq+ejFS0tsxZmQoOgtUle78qLQVN8TDr
         tlqfG55CFr+RYK+K7/1R+O8e7b7fYHI/s6dR2PbeKVlbD95aErKjFjGHMi7dmSqlzCVu
         QILdki41VRCI/KWv83e5JPhdMPQyFMataLLcWMvIbkgOFjBmCPfJmjLLxwYyqvvswJvx
         mHUQ==
X-Gm-Message-State: APjAAAWnjoogcCfV5Ev0p0NzGhuRlcNw2OSKuW28KGwAcAnEwzUyNav+
        l2JAzXbzaBhR4vWZPhZqNwQ=
X-Google-Smtp-Source: APXvYqw/a58aguyyloXW2Sf/DOaJaIEwEhtubC6Ch7Vr2klctbVb2geD1uCeJ1OhZ+VhjEQozE017Q==
X-Received: by 2002:a05:600c:2c13:: with SMTP id q19mr3491484wmg.144.1582875461676;
        Thu, 27 Feb 2020 23:37:41 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id h2sm11369425wrt.45.2020.02.27.23.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 23:37:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/5] io-wq: use BIT for ulong hash
Date:   Fri, 28 Feb 2020 10:36:39 +0300
Message-Id: <332610e11bc94acb2390f737ecb0b08db120cb8c.1582874853.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582874853.git.asml.silence@gmail.com>
References: <cover.1582874853.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

@hash_map is unsigned long, but BIT_ULL() is used for manipulations.
BIT() is a better match as it returns exactly unsigned long value.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 1ceb12c58ae6..a05c32df2046 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -393,8 +393,8 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe, unsigned *hash)
 
 		/* hashed, can run if not already running */
 		*hash = work->flags >> IO_WQ_HASH_SHIFT;
-		if (!(wqe->hash_map & BIT_ULL(*hash))) {
-			wqe->hash_map |= BIT_ULL(*hash);
+		if (!(wqe->hash_map & BIT(*hash))) {
+			wqe->hash_map |= BIT(*hash);
 			wq_node_del(&wqe->work_list, node, prev);
 			return work;
 		}
@@ -512,7 +512,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		spin_lock_irq(&wqe->lock);
 
 		if (hash != -1U) {
-			wqe->hash_map &= ~BIT_ULL(hash);
+			wqe->hash_map &= ~BIT(hash);
 			wqe->flags &= ~IO_WQE_FLAG_STALLED;
 		}
 		if (work && work != old_work) {
-- 
2.24.0

