Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480DC417CBE
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348503AbhIXVCr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348496AbhIXVCo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:44 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A06FC06161E
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:10 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g8so40860034edt.7
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=M4AMagFWXgKeMyOsWrx6Q5KkZDYOyTgXsRTRF7iF1ZQ=;
        b=C6vakzQK0TYRuqz+FtnMveL6EXaKrVCCt2Pw3BIuE3hplww/p4MwWSOcc8UV1jQYTp
         83IJ863It53A5z01nVkfYzKrfdmGmTrRA/yHfDcwKkJrNUnA4IhYmGV/+YeUNxKH9djD
         02gfn8mBjDJ1USxQ9PTg59kndt+SFsdDgc8KHPZDBwT9uuQx7ELZTNEB0a4oWliGwpgW
         UGJ4UjHiWc6K+8qpgR6L0lraqVffK8MXHlOJ2AC2oecvfPyPxj1C5S4gsCsbgf74HfpU
         oZpWr0Vx0RNgA9p+uXc6ARCn7KvqOkrf/bOki3U0znZoyE+JM8JvjJNHQpwPXNbd0Law
         uv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M4AMagFWXgKeMyOsWrx6Q5KkZDYOyTgXsRTRF7iF1ZQ=;
        b=nYJa5WN7ZUeqjYyM+M3kXaAdvh4DI0/qAjN2gitNX2+RG9dvNCfZwKDpVdNQ2Dbr/Q
         P14tDP5h5rtGrNjo2jS0TgMbKEDYqDlcmKs/Muas4KL9pC+6PMlj0/VT0lYd4urg0s5w
         cCbL95zjDUPLqnnszWLIkEqGPsc/w6QB5gby32yuKmcAQ/UZ0DCJNv6L2qsQLk7xsioW
         nO7FW5uKTMFwIcS363eT8BCRxJAmcn+8DiEnQCjuIoouH3+qwe2eJ+IqkD58mkIgn5lW
         odZzkMTmY9/TLQ7EzK/asI8a9QOdWo7CDmMcQfqPPEj+OqmmAtWI810OAiM1q3LwdUNQ
         ZuiQ==
X-Gm-Message-State: AOAM532kejZG/AibcyE5jwXGH1QavJpzYZ6To9p4E2csDaBPh4oV28Qg
        SBvwWCfjs3/JtuAzurj809k=
X-Google-Smtp-Source: ABdhPJw4i/ovOTxf7CdNbbW7hQbaNn2Rb+sYyGxZXSVaKgW9r2ixysN029TakC9LlVuJ4R3G9VSfCA==
X-Received: by 2002:a17:906:fa05:: with SMTP id lo5mr12946868ejb.204.1632517268988;
        Fri, 24 Sep 2021 14:01:08 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:01:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 23/24] io_uring: comment why inline complete calls io_clean_op()
Date:   Fri, 24 Sep 2021 22:00:03 +0100
Message-Id: <21806f862151e223fdf439e5e8ed7178a8d66979.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_complete_state() calls io_clean_op() and it may be not entirely
obvious, leave a comment.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 34c222a32b12..b6bdf8e72123 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1827,6 +1827,7 @@ static void io_req_complete_state(struct io_kiocb *req, long res,
 {
 	struct io_submit_state *state;
 
+	/* clean per-opcode space, because req->compl is aliased with it */
 	if (io_req_needs_clean(req))
 		io_clean_op(req);
 	req->result = res;
-- 
2.33.0

