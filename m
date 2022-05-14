Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D6B527210
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 16:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbiENOf2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 10:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbiENOf1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 10:35:27 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3652020199
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:35:25 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d17so10564323plg.0
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kqTCYzXPj2qvNDeP69xecjDJXh7/toCrwC41GgwtH4k=;
        b=fHLaUuUKJu0aPXHPeZnjZGTh4T/kzGSQyqAEcOyj3O6lLAE6ERApZMwPg9kXf6QEU3
         4NK39YEyqntxMsk2wmSfV80rHMibiXrukijfrwln/mBQBhdjJseh0sXL5f1mgeAPQret
         R8amBzcHKK6Xq3NJUsAOmDN5JnBmP89KYHF1jplGxhPXIk16V5nzx6LwFEN2lI8cu5+J
         6SXOdgsJS8IqFZdiVcJKy3iwcTjOmOP2SNEosaMO/Namu0ppN+WrQsC+mR5JU+Xwbyl4
         w23JMA0v6WQJMFvm+IIBFoejTJuBtExmq/w95bZItdrrCHymg3sQz8w4HPi93Qmd6aWD
         ZvQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kqTCYzXPj2qvNDeP69xecjDJXh7/toCrwC41GgwtH4k=;
        b=NVzPsFoaLAVQKktvpZte93GMaeWBqPGNUaA2MSaPnAAi1Ni2dJLFm9TRZOx9mZoYos
         lkkglpSdUWQ8n/CwbliXyF9/REqd9BDTQCSSCP+FwcZBfyNif388w81Op2VLQWiD628B
         AFftbEYL+GIkxqJAhw8a47d5wTRUlpx3KVNXukznBbV0jrHaDz+7El4zjRBrT+r1LUYA
         Xrc9YZpPLx7vT+Qq9yvbervhvjF2TLk5mOhK80ec/6IWt1ndI1kbmRSDDia/C3NkPfI1
         byi8T/GJ6VTsPcuwr6+y/GmWZK+fc1VG7ahU7mnK01n2cjt5eASFB2LghlwHLXeXgG6w
         ayTQ==
X-Gm-Message-State: AOAM533PYqlwfvuLY0MzRsUtSuRgfHpIFDBBbigjeIn/107KT185rXMs
        0p7kPFR8/yJW2/jYzXzAYzOPVFUsBdaRxFjQ
X-Google-Smtp-Source: ABdhPJxjYZKtAo01RpOhCmcxPWN1zTVe+bU9fRwjR9IqC4GUG3FyDj+3uELo4JoXp8LAoNQw+CHqbQ==
X-Received: by 2002:a17:90b:3a86:b0:1dc:2343:2429 with SMTP id om6-20020a17090b3a8600b001dc23432429mr10147810pjb.206.1652538924684;
        Sat, 14 May 2022 07:35:24 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902c3cd00b0015ea95948ebsm3762179plj.134.2022.05.14.07.35.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 May 2022 07:35:24 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5/6] test/accept.c: test for multishot direct accept with wrong arg
Date:   Sat, 14 May 2022 22:35:33 +0800
Message-Id: <20220514143534.59162-6-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220514143534.59162-1-haoxu.linux@gmail.com>
References: <20220514143534.59162-1-haoxu.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a test for multishot direct accept, where don't set the file index
to IORING_FILE_INDEX_ALLOC.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 test/accept.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/test/accept.c b/test/accept.c
index 897278a2a3c3..921c79b862db 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -541,6 +541,43 @@ static int test_multishot_accept(int count, bool before)
 	return ret;
 }
 
+static int test_accept_multishot_wrong_arg()
+{
+	struct io_uring m_io_uring;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int fd, ret;
+
+	ret = io_uring_queue_init(4, &m_io_uring, 0);
+	assert(ret >= 0);
+
+	fd = start_accept_listen(NULL, 0, 0);
+
+	sqe = io_uring_get_sqe(&m_io_uring);
+	io_uring_prep_multishot_accept_direct(sqe, fd, NULL, NULL, 0);
+	sqe->file_index = 1;
+	ret = io_uring_submit(&m_io_uring);
+	assert(ret == 1);
+
+	ret = io_uring_wait_cqe(&m_io_uring, &cqe);
+	assert(!ret);
+	if (cqe->res != -EINVAL) {
+		fprintf(stderr, "file index should be IORING_FILE_INDEX_ALLOC \
+				if its accept in multishot direct mode\n");
+		goto err;
+	}
+	io_uring_cqe_seen(&m_io_uring, cqe);
+
+	io_uring_queue_exit(&m_io_uring);
+	close(fd);
+	return 0;
+err:
+	io_uring_queue_exit(&m_io_uring);
+	close(fd);
+	return 1;
+}
+
+
 static int test_accept_nonblock(bool queue_before_connect, int count)
 {
 	struct io_uring m_io_uring;
@@ -673,6 +710,12 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_accept_multishot_wrong_arg();
+	if (ret) {
+		fprintf(stderr, "test_accept_multishot_wrong_arg failed\n");
+		return ret;
+	}
+
 	ret = test_accept_sqpoll();
 	if (ret) {
 		fprintf(stderr, "test_accept_sqpoll failed\n");
-- 
2.36.0

