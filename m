Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6CF4D905B
	for <lists+io-uring@lfdr.de>; Tue, 15 Mar 2022 00:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241081AbiCNXaw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Mar 2022 19:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbiCNXav (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Mar 2022 19:30:51 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C1DFD10
        for <io-uring@vger.kernel.org>; Mon, 14 Mar 2022 16:29:39 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t22so3591961plo.0
        for <io-uring@vger.kernel.org>; Mon, 14 Mar 2022 16:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=WRDIjhVE3E+IHV0mKiiJAsgIanmG/KdJSoI78SBqIVQ=;
        b=IyCM9cmdavRhl//ycliYAChI3rTwGiR98JPlTW873yPxHdDlN+1+nIbwGAwEEZFvhI
         Gi7QQhuJriJL19nQAODIN6sWWUOhk0HMyPaJ+SSwBC1Fd0rrDgTp2UiSCAuCwrfqoRVm
         Tr71L0QagRM2zqn+WprIEXPgPqxtf5h5Zi43Jg9D6lAqtn1lf0rtyL7s/RJrnUDWOzNA
         mKVXrZaWx+gpFOKEYNfjjtcR3Ju5+A/4ST1YM7dCe724sz2VNPbUIzhhdtR8YMHSqDjn
         TWR1YBQMH+1fDPCa7NZNO4QyCvtGj7M39jmN0MSKfGMYnf8A2kCXfJvQS5AcOYIMmFZH
         5/Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=WRDIjhVE3E+IHV0mKiiJAsgIanmG/KdJSoI78SBqIVQ=;
        b=BFtSg2xHHawkwuSSqEnDh2R2XuGehR0NvqmtKyI5rsLo1NVQluPo1Yg5n59083s9Qk
         JsYZO7RN75vBEP5UcADwbAwgzXUA1uep/XbNl4ku3qD6535Nkw0nkb9+oB2cbedHk2eK
         B40EJJ+iYTWvRUN82LptaU8D0NWPTZXT2+QgoAdmq8fFN44ad0KCLdKHHu5sn17H4Rls
         0BMWIS0mPbYJunLnD+RcIMr7BmR/jsZraPx8pb8Qg7GIV3iAQnsjYlRLqTdpIxwLrF6q
         eva00+vWqBfeoFmdGK8WH0erKUyYzSU54lYFzQHoVPUqY1SVSZDkDrbLPFQHZtC44R0n
         2jvQ==
X-Gm-Message-State: AOAM531VUdZd+rYbLudHyvdjw/dyt68Z23lxtDsQKQtGN8fR04eI2I9O
        2Y10IynqhNd/WHeAJiVV4RRa9Vbqo6oIiLRV
X-Google-Smtp-Source: ABdhPJyZ1BUUyzOHIrr4LvyM1Nm7L9Mwr0WFoN+6dh31B4bgKdJq6F3sXGXb0a8ylOe0KkXKL8X61w==
X-Received: by 2002:a17:90b:1e01:b0:1bf:5f6e:cbef with SMTP id pg1-20020a17090b1e0100b001bf5f6ecbefmr1545306pjb.130.1647300579108;
        Mon, 14 Mar 2022 16:29:39 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id bh3-20020a056a02020300b00378b62df320sm17535077pgb.73.2022.03.14.16.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 16:29:38 -0700 (PDT)
Message-ID: <d4c9718f-24f3-82e6-f9dc-b90e8912c059@kernel.dk>
Date:   Mon, 14 Mar 2022 17:29:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't check unrelated req->open.how in accept
 request
Cc:     Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looks like a victim of too much copy/paste, we should not be looking
at req->open.how in accept. The point is to check CLOEXEC and error
out, which we don't invalid direct descriptors on exec. Hence any
attempt to get a direct descriptor with CLOEXEC is invalid.

No harm is done here, outside of potentially causing a spurious -EINVAL
for direct accept requests.

Fixes: aaa4db12ef7b ("io_uring: accept directly into fixed file table")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4715980e9015..fbbd8ae44f88 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5258,8 +5258,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->nofile = rlimit(RLIMIT_NOFILE);
 
 	accept->file_slot = READ_ONCE(sqe->file_index);
-	if (accept->file_slot && ((req->open.how.flags & O_CLOEXEC) ||
-				  (accept->flags & SOCK_CLOEXEC)))
+	if (accept->file_slot && (accept->flags & SOCK_CLOEXEC))
 		return -EINVAL;
 	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
 		return -EINVAL;

-- 
Jens Axboe

