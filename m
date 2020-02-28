Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF69F1731E0
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 08:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgB1Hhl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 02:37:41 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38885 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgB1Hhl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 02:37:41 -0500
Received: by mail-wm1-f65.google.com with SMTP id n64so791755wme.3
        for <io-uring@vger.kernel.org>; Thu, 27 Feb 2020 23:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Mad6mNsPQLfLmXeA1qGtfs7ABMvPWol+X1aneWYM0IA=;
        b=GugZRYtDXruprirhAFROUraQIcYcHiN2JsJ3ybnltCrVav17YK+8Yp+AUavbLvDT74
         VL1elpGDo75XFgNmhwieAanyyTfAbtRT1THKKAGlWRef2qBfX3Zqh1RZWs1M5EHpbBr+
         sC2ALGm4hnHIV5M2JnlqdJsZdw6690ORmZxdglxlTehGyACh7SGCkhQMzp3vjPeaMscs
         IYbn22ECduBmQzHZLdeHBPngmGVvOXwgaNeeaC/pky0ZAK+lCqBZirRqg2jfFtEeMf83
         3IzEQbCmMI/2LjggvU4y4z22k3sam2ocuxvOaziCm07Xk30KF9j42I3k0EMb+CPBdBqt
         qeog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mad6mNsPQLfLmXeA1qGtfs7ABMvPWol+X1aneWYM0IA=;
        b=cmBSsagWPD6WjoaDyo5oWwOtmJHwJDXSJ4onopo8lo61jBRwCrevSgVjq5EIxIL52q
         ePghXScRl0O/LRLm9sy8EiPXewh4mactPe8pKUXnZ3zoU0893AVdCx86dpDRr7vjfyyZ
         j4yA9nkpM38FMpU0ZTg3LqCS7EvYBNarRoA0WAXBkPVgF9dSY7MoxkI5Bu7WGMdROpDM
         ujVrL0W8TS1ohn8kU2QRAu3JZmNuVbi/CkbeyQXfuQgON/+Ir7oAR7BtZvq5VpB8zQDO
         yUx0FSjsI/qJPiP5kRqFmNZUrsIokhtzDuZxQg2FqAQ4/Juv9d7R9UHOB8oMRFwPsWJJ
         sk0w==
X-Gm-Message-State: APjAAAXsHnfqLn/15CGN5TLzPTh0poyOqPwjW5qf2C7Jj5DxLjP4IYUo
        hwVPhCIMqtIkzvVUqicwoaQ=
X-Google-Smtp-Source: APXvYqwdZVksPHYbRauDBu5BsIMwrs1AtPxu+RMTNWwZA0erefLp9kV1nUJT0cotUx2IvluoKVVY5w==
X-Received: by 2002:a1c:750e:: with SMTP id o14mr3331874wmc.156.1582875458839;
        Thu, 27 Feb 2020 23:37:38 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id h2sm11369425wrt.45.2020.02.27.23.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 23:37:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/5] io-wq: remove unused IO_WQ_WORK_HAS_MM
Date:   Fri, 28 Feb 2020 10:36:37 +0300
Message-Id: <571375960faf069a6bfc5e9d6d0325b932907f24.1582874853.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582874853.git.asml.silence@gmail.com>
References: <cover.1582874853.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IO_WQ_WORK_HAS_MM is set but never used, remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 2 --
 fs/io-wq.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index bf8ed1b0b90a..72c73c7b7f28 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -499,8 +499,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 */
 		if (test_bit(IO_WQ_BIT_CANCEL, &wq->state))
 			work->flags |= IO_WQ_WORK_CANCEL;
-		if (worker->mm)
-			work->flags |= IO_WQ_WORK_HAS_MM;
 
 		if (wq->get_work && !(work->flags & IO_WQ_WORK_INTERNAL)) {
 			put_work = work;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 33baba4370c5..72c860f477d2 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -5,7 +5,6 @@ struct io_wq;
 
 enum {
 	IO_WQ_WORK_CANCEL	= 1,
-	IO_WQ_WORK_HAS_MM	= 2,
 	IO_WQ_WORK_HASHED	= 4,
 	IO_WQ_WORK_UNBOUND	= 32,
 	IO_WQ_WORK_INTERNAL	= 64,
-- 
2.24.0

