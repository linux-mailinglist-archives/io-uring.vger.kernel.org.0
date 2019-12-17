Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56D9123402
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 18:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLQR5v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 12:57:51 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44050 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfLQR5v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 12:57:51 -0500
Received: by mail-wr1-f68.google.com with SMTP id q10so12288719wrm.11;
        Tue, 17 Dec 2019 09:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/veVuxGSNZ6vYt8Kjkt9fU6DsI7r6dl8u0XAVHaGrcg=;
        b=f3WvUd6ikw3G1bFlEBfT7KHmgufnclAxHFqMsSQiLDChE00tf1+cFKvrGlZcGdvq6r
         uVwRBPyq7Gq7uvNs2fi2trO95U7rSFJsQkJ5sJMnEzNe1bUS9f51mAYuS7d+omlZhCZ1
         ldjK6qyUmwiYCxffMSDw57MI71y6h+v6S7wo9ZTHPl8Gl77QqemXXZLz33dCqorlwv58
         QPdWzqBoH0JSK1bjE9ZkVYK8opFCbY4oZa4XJAxxHRWc9ssj5oLfXLESlaaCkFYa7DdA
         Wgix5epNPW4vrMP++zl32v6jKJzyIRW4aarlPFctI0sCTFl4K5JYpUplJLCZzt3snFD8
         XjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/veVuxGSNZ6vYt8Kjkt9fU6DsI7r6dl8u0XAVHaGrcg=;
        b=AJOeH56U8wyNAozLdYaLxHQiobdutGUo+vbtkRgTmVUxWUusneRqG2VYfSGRkOiCDf
         L+9Ha3o5NUEjYj32j2qmEarv48GW98k8Z2KMSJEDQk6d2DRVO9YLI6KZbgpiLh/U6EeV
         gwlmzH2XXtRauU1pfA5LT6fx6xHGIrd32yQ4YzXxpasstzyIfjPEQH8OhFvxLekR2XpP
         NM5eGI7EOCBmp2pvfSYgeG1m7Z3WwzutMNeQylLIMwVkZN9oiMwgaztbKyj35ybzrrwB
         FRqveCVssE52ClhEPX8v/zihiXPhY2mEEUvt4EBBQdwU7pnfJZvyzUsq8xWtNukVRSG6
         b/sg==
X-Gm-Message-State: APjAAAWeI2U6PtTJqqMR2ifULdxLWEd/CeyGhxQroTllqWWsCyiaYH0O
        YJOQolLGTqKdt4BR2yUdBZQ=
X-Google-Smtp-Source: APXvYqyLTN3dFvqiJkcm/MgGQwIOBoYmUuQjRL8j3JY3p4ln+YyFqtnPDDsZoWtGgYD1LMgqZ3yhiQ==
X-Received: by 2002:adf:81e3:: with SMTP id 90mr37921736wra.23.1576605468725;
        Tue, 17 Dec 2019 09:57:48 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id z8sm26466192wrq.22.2019.12.17.09.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 09:57:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH for-5.5] io_uring: make HARDLINK imply LINK
Date:   Tue, 17 Dec 2019 20:57:05 +0300
Message-Id: <4d08ae851e48c030b726e00def4451466475b7e9.1576605351.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576605351.git.asml.silence@gmail.com>
References: <cover.1576605351.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The rules are as follows, if IOSQE_IO_HARDLINK is specified, then it's a
link and there is no need in IOSQE_IO_LINK, though it could be there.
Add proper check.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 339b57aac5ca..eb6d897ea087 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3577,7 +3577,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		 * If previous wasn't linked and we have a linked command,
 		 * that's the end of the chain. Submit the previous link.
 		 */
-		if (!(sqe_flags & IOSQE_IO_LINK) && link) {
+		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) && link) {
 			io_queue_link_head(link);
 			link = NULL;
 		}
-- 
2.24.0

