Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F04417CBB
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348487AbhIXVCq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348489AbhIXVCl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:41 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39C4C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:07 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g8so40859558edt.7
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jauM2dJoIlzR8Gs3XB7k8CYnrIkI5wrB/Ca39NoTmPY=;
        b=CXN4DogGRaCXeT2+nzZvNP/pXUP0BsyuNvvl95R5Tfv1z8bOL5kIExAoxVAoPIxhPZ
         zP7CrPIUXM8I/0PfV8wLYR3uXqi5cfGonXg9Tk/1k98D/yK/Mptu7rGiAEV20IJYmFvE
         HESmVUaM/a2EXr/ZrACNfUL2Rsl0r9sGdvre603Ol9mTpewRSG8YbUW3rIoKbql1mSA8
         bXo2HOurM+TPftw1Hlu7oo3C0IRrs5rHR180gEv5VXrhEIDJVBot/mgj9Pe50BMLuG6Z
         MobPXK8ip81Dvu2ekUUhMvKpLYX5kN9/5/ToHPDmnuFYl7H8pVFGbCjPRlfWs7g0u6M+
         889A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jauM2dJoIlzR8Gs3XB7k8CYnrIkI5wrB/Ca39NoTmPY=;
        b=M3RvPYRfeHrWPV1KCDtJKvsYXEG8XHnqeuu6UrdFc/OOCxJyZnWrECuNXdfqXUdYcG
         wr1CM50nwgOIkfXuXTTMsRh2CwqOv7VCpsfN+VOKeyIJcppEOHIpofLLPnmhTInHH5Ev
         r9M/nbOYjhas4s5zQdfdti3u0hpi7Z0FhAN9VrhMshDGmLYcyw2PSe62lEt7G6EQ0nY9
         dkZsnVDq59e4sHVK75sgNkPO7mSF18MStIwxu3sm0ao0/8IbmitBjOM8E7wsA3ehenbf
         o+jJQFCIt9gnoO3VcONbyX5+GeYSKNSMoiQP8UgGO16QDpl3JX1TlPnrqmdI/rX5/cd2
         puEw==
X-Gm-Message-State: AOAM530unWHK7lk8PxU6zcZbjq641SOUPscsvQEd9mkOoQlyRVJEBc8e
        vrihDBffih68CP+n1WivH6E=
X-Google-Smtp-Source: ABdhPJz6kG6Rj6/1k4tOAqLpBGrdKusgbewTTa4sX0JuRcENlaSln9TZN/OE8I8EJg0MHBJI/oeipw==
X-Received: by 2002:a17:906:1615:: with SMTP id m21mr13906674ejd.279.1632517266271;
        Fri, 24 Sep 2021 14:01:06 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:01:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 20/24] io_uring: reshuffle queue_sqe completion handling
Date:   Fri, 24 Sep 2021 22:00:00 +0100
Message-Id: <ebd4e397a9c26d96c99b24447acc309741041a83.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a request completed inline the result should only be zero, it's a
grave error otherwise. So, when we see REQ_F_COMPLETE_INLINE it's not
even necessary to check the return code, and the flag check can be moved
earlier.

It's one "if" less for inline completions, and same two checks for it
normally completing (ret == 0). Those are two cases we care about the
most.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0470e1cae582..695c751434c3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6933,14 +6933,13 @@ static inline void __io_queue_sqe(struct io_kiocb *req)
 
 	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
 
+	if (req->flags & REQ_F_COMPLETE_INLINE)
+		return;
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
 	 */
 	if (likely(!ret)) {
-		if (req->flags & REQ_F_COMPLETE_INLINE)
-			return;
-
 		linked_timeout = io_prep_linked_timeout(req);
 		if (linked_timeout)
 			io_queue_linked_timeout(linked_timeout);
-- 
2.33.0

