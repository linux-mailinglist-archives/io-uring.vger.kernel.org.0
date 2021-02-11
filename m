Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84A2319665
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 00:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBKXMw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 18:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhBKXMw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 18:12:52 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAF7C061756
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:12:11 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id g10so5885940wrx.1
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ILLQkuy8A4XtZc+YrMTVGZk72QaKmNQD3MCcbsON12s=;
        b=YRd4afqAwDjSZmTR6xiF773gkEOkQOyqmNK0RkoRRoPhn6orBRa1RxK3HY9Xd/wImL
         5LpCYQhj4gTmRNvc+RtNZ+51/j7OeLptsNsqFLlMZhQxItH8P4xYoq0F/OUg4wlOoCpq
         ykGKp33Rekx/ccy0qk8Cloe9sykOU42yX7I/LX7d+8r8f2gSozvCVhythhB8wzBtX86e
         bG19egxyxKxmIVlTEMlCNWISY0sqgk0xqKEKWTo5K80buyNIdWTGrIcDQR2wIBCuQmSa
         5m2A3fYY0UJkeObS5aDSA9jH8Mb+3+W0uMMBZRjtssor44GKcn/Zyh0LnBF0PqQScGe+
         BAAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ILLQkuy8A4XtZc+YrMTVGZk72QaKmNQD3MCcbsON12s=;
        b=iXJIcUPkd9/00TIItwWVWCWdkrSal9RCrZlmHHGfnYMV7bWe9VwesbHOA/9QdVW+9K
         NbvEIqxn7x68dfhxR3EbqWQo4vjfwsMM5eFWPIt8aHDjH+h2r9kavHIvrTmmjFz+cIq5
         x0ak374I6pusy5edxVyhww9hMqX0U/JMr1XJLPbIUl1GE6aqgsAoEoIJ+Oou5bRueSnj
         UyMmVHO7EFsXAej6w9eF78a4YQXH78svU7DJo1QNd6WGsLh8eJNYLiA+awBQgnElNA+O
         Rf86zKIvE4KY9NQ5uRxmv38fLqmBxIKUDTPwNI46qFasKiJLM4AWxkDURND2IzNx+Bg0
         HWfQ==
X-Gm-Message-State: AOAM5329pM9SyvConQLmv/0j0A/UE6HpU5xbfxDN5S2BFgtN5JLEFJAp
        HyjyEL5BbAfWDXOw9P4HINc=
X-Google-Smtp-Source: ABdhPJy8furLxjkNQrgyW5tbPnuyO9enEY0H6673fRlv7HUSPzeEPCIqrOvkXsyx7nbLle28iG0ROg==
X-Received: by 2002:adf:facb:: with SMTP id a11mr120383wrs.161.1613085130076;
        Thu, 11 Feb 2021 15:12:10 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id d9sm7271184wrq.74.2021.02.11.15.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:12:09 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/5] src/queue: don't re-wait for CQEs
Date:   Thu, 11 Feb 2021 23:08:12 +0000
Message-Id: <6275b6b34126b13849fbf29263a59dd49c5c5031.1613084222.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613084222.git.asml.silence@gmail.com>
References: <cover.1613084222.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If ret==to_submit then io_uring_enter did go to waiting path and we
should not repeat it. And that was the intention of a post syscall
data->submit check, but reshuffling spoiled it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/queue.c b/src/queue.c
index 8c394dd..c2facfd 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -124,7 +124,7 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 		}
 
 		data->submit -= ret;
-		if (ret == (int)data->submit) {
+		if (!data->submit) {
 			/*
 			 * When SETUP_IOPOLL is set, __sys_io_uring enter()
 			 * must be called to reap new completions but the call
-- 
2.24.0

