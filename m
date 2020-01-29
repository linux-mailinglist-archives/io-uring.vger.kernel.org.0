Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE48914C88A
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 11:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgA2KLK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 05:11:10 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50586 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgA2KLK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 05:11:10 -0500
Received: by mail-wm1-f66.google.com with SMTP id a5so5556260wmb.0;
        Wed, 29 Jan 2020 02:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/s2Pvc4rtIYnq/pOc+rMYu1hL0CKlGk2c1b/QVFIVn4=;
        b=GYTVgM1vQnXVg0+jEtvE7gtklxDswWkLuuwHNMr6z3BQV0ttepBWhjqNmwRquO5brZ
         wPtWlFREh5Vc0JH+3O1M3X2lHstBuW+77J1ZUWxlm+q8sLhYwS58BrlsHDx2eJITqjhg
         Cf+TN+vVVqFHtl9ln+OpWWuyyO8YshPjfzFI5ekBvNvVtbx/NjpcEqtJnJycINaT/0TT
         MtodmhdefRK6RPGA3csepwhJESJw+uiurIz2lPWIRqdwkm7BwNMQUQtRrLhVbhSk0yfp
         JeR/q1pgY0S1YMqfbnKa7JTON9S0MyeoeKbFArB+S4LQkcuXR30dYLTyjfl8/Kqn7INv
         U2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/s2Pvc4rtIYnq/pOc+rMYu1hL0CKlGk2c1b/QVFIVn4=;
        b=Ddvo/WBjPHeVKsfStrsan7kkKaWfY4tO8O+LRI0BVZlt7Nx9sBN/oyfdAZxrYWj8pm
         IPFbqq8Tn2QPXugEevT2V3l5d3oci2Zbiji3u/H6lJ/rCeg6qpd5JF91vEJ/rTuugLZI
         QsdhCgfgHrx9au8zP1PZ7nTvaUIUmm/cloLwDl0ZCSbRSTVvRv2oAiFk6ACVWEoOOhl4
         ta6gLAfwXZFQ4iF1IBGJYNRSReepb1s74SO27mGLTjjP00dEBNF7BXJ4CcQOACRADYfO
         /71z/0mJ+rGoxTNUU9thpkseu/4DuvSE2+RBXJIu4wCTwvECe/2dev+qWIZW8X9AS8AB
         JngA==
X-Gm-Message-State: APjAAAUnzIQcNc8/Gafy7kvxk/zssBjcN9RLcUybokqb9qGdssi8quyO
        YiqSktudkgT63gyQk7QP/LY=
X-Google-Smtp-Source: APXvYqzIno68ySw/HwWTZAocIeDIM+K/daqEQzdiw7u+TzLm3AvoUindlXWfE5FZ8QiUQkImcz0dCQ==
X-Received: by 2002:a05:600c:217:: with SMTP id 23mr3252001wmi.124.1580292667970;
        Wed, 29 Jan 2020 02:11:07 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id q14sm2182354wrj.81.2020.01.29.02.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 02:11:07 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io-wq: use put instead of revert creds
Date:   Wed, 29 Jan 2020 13:10:23 +0300
Message-Id: <c79bab7a6bd174f32121c9508390264bff9950ca.1580292613.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is no need to publish creds twice in io_wq_switch_creds() (in
revert_creds() and override_creds()). Just do override_creds() and
put_creds() if needed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 8fbbadf04cc3..f7eb577ccd2d 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -425,11 +425,13 @@ static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
 static void io_wq_switch_creds(struct io_worker *worker,
 			       struct io_wq_work *work)
 {
-	if (worker->saved_creds)
-		revert_creds(worker->saved_creds);
+	const struct cred *old_creds = override_creds(work->creds);
 
-	worker->saved_creds = override_creds(work->creds);
 	worker->cur_creds = work->creds;
+	if (worker->saved_creds)
+		put_cred(old_creds); /* creds set by previous switch */
+	else
+		worker->saved_creds = old_creds;
 }
 
 static void io_worker_handle_work(struct io_worker *worker)
-- 
2.24.0

