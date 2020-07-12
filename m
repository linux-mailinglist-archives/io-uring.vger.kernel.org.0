Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BDC21C850
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 11:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgGLJnK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 05:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGLJnK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 05:43:10 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4E9C061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:09 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id p20so10855952ejd.13
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=H4kNRk/tXsLXRwlciUaZeaNj2qbRDmgAf56pnBJThRE=;
        b=WLnQCu95r4ZdO6pG4EfQU8STBQtS42bln9SMZcnZrILu0kS8G0BWRxSst9nCKDKUt/
         JQB5YgESKWGahj2ygK0RsmRWs1JGOxxQpurKTev6Q3GC+xH3fombgeiqloQ/51E5RiQg
         H6pIe8gEc7lUDuQLyGAk4sSMLSiVTqcfk0D9D3mpPhQdMT/FOJPslgeb3vfR54YGklR0
         Pxohy1mLjbwuLYx+fEtqE0Gte9ytWhL9985u25ksP6TlLVuCIvSssWpdD883o6GF25fW
         jHZm6YSJK76CzCKpSMLpEGLTpFY0YkvO+MMoDgsEESV3pQNJWb6VMelABz1FB3G1gg+l
         m9uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4kNRk/tXsLXRwlciUaZeaNj2qbRDmgAf56pnBJThRE=;
        b=Ue8gNcaKWxAbUq6YEoDGrfCMCxFTPvy3HdFf8ztaXI8vrR5qJbQ12lqWDMjSMnhFOo
         E0MRXg8zAwyLXR/5SnWW6V/Nbnb62SZ1RH05CVMU1sD8mF4b1x+U04WQdh57J4SFaOCZ
         znRJ5gP5JyY6+MnVh/2a1dj6IYcC3AsaTtqjLXZqPUV8RxG0gaSEcqK6+engqF+7eyTE
         GnOypYj0Sx24F64NeQnraNcv4wOj6mM/YlDr3gkA80ZFE8Ink5louBwlK2yw68yPZ0MY
         O1WGuPwde2vMD+DFvV1WMVAwkyufTz3P7eCpFiR789UWam8D84s+EconWDUQbtxOYxB7
         VBGg==
X-Gm-Message-State: AOAM531oP3fDkPDLoASj8sXqMhEoWQjXWF0jDmeKDZAUbZF61mGSpDFu
        aNHXSafbIt9kIY0fYgkxg2I=
X-Google-Smtp-Source: ABdhPJzOagZ4gVKP0Db2bP3lZywI48VPLJYdHYEG4eP8ZRHxRgdNQpVeDKHPAFS3QbPMWSVae6Ghvw==
X-Received: by 2002:a17:906:4a45:: with SMTP id a5mr67237934ejv.384.1594546988311;
        Sun, 12 Jul 2020 02:43:08 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a8sm7283718ejp.51.2020.07.12.02.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 02:43:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/9] io_uring: share completion list w/ per-op space
Date:   Sun, 12 Jul 2020 12:41:07 +0300
Message-Id: <012554b99f42cd199bfb0e377783fbc50dfc5a1a.1594546078.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594546078.git.asml.silence@gmail.com>
References: <cover.1594546078.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After io_req_complete() per-op data is not needed anymore, reuse it
to keep a list for struct io_comp_state there, cleaning up a request
before hand. Though, useless by itself, that's a preparation for
compacting io_kiocb.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8482b9aed952..2316e6b840b3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -487,6 +487,12 @@ struct io_statx {
 	struct statx __user		*buffer;
 };
 
+/* Safe to use only after *fill_event() and properly cleaning per-op data. */
+struct io_completion {
+	struct file			*file;
+	struct list_head		list;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -622,6 +628,7 @@ struct io_kiocb {
 		struct io_splice	splice;
 		struct io_provide_buf	pbuf;
 		struct io_statx		statx;
+		struct io_completion	compl;
 	};
 
 	struct io_async_ctx		*io;
@@ -1410,8 +1417,8 @@ static void io_submit_flush_completions(struct io_comp_state *cs)
 	while (!list_empty(&cs->list)) {
 		struct io_kiocb *req;
 
-		req = list_first_entry(&cs->list, struct io_kiocb, list);
-		list_del(&req->list);
+		req = list_first_entry(&cs->list, struct io_kiocb, compl.list);
+		list_del(&req->compl.list);
 		__io_cqring_fill_event(req, req->result, req->cflags);
 		if (!(req->flags & REQ_F_LINK_HEAD)) {
 			req->flags |= REQ_F_COMP_LOCKED;
@@ -1436,9 +1443,12 @@ static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags,
 		io_cqring_add_event(req, res, cflags);
 		io_put_req(req);
 	} else {
+		if (req->flags & REQ_F_NEED_CLEANUP)
+			io_cleanup_req(req);
+
 		req->result = res;
 		req->cflags = cflags;
-		list_add_tail(&req->list, &cs->list);
+		list_add_tail(&req->compl.list, &cs->list);
 		if (++cs->nr >= 32)
 			io_submit_flush_completions(cs);
 	}
-- 
2.24.0

