Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0718C5272DE
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 18:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiENQXf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 12:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbiENQXe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 12:23:34 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F892CE2F
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 09:23:32 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id p26so19254037lfh.10
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 09:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=W5F0uGwuAL8pTZ+Hf+pCcDwDg2tH8pzMKHWva8EgvhE=;
        b=zCqSFU3L2yPqDpA9e6zkSdFzMlewSbDHui1YgNVZgkEOYdLOoLz3x7AsC+W2olBLwt
         IThcy1Re3FAhxcn/Tl75bzDyYHshYQx05ySzBpWntoqEYwEJYqiFUvEcTIeAijtIz0MM
         8Q4gOzHipiFNoWRdcrvQWkpNy1W4/xFgddUVDg8/gb5nwpP4g95HpB5VKSiOJtl/Xyed
         CQbtMh9HQUQlCqqrGfPPW4b12dfTsuPubqMnXjg7TdmTo/gR2WfAKyFTFZaqdVnsx0Nv
         zsv4pUR8DUIOTWwXceE5IVzux5Yo7gLwP7z8I6Ee0TsAP5DFjFudWpvTkJ64F8ZIjNLY
         VaCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=W5F0uGwuAL8pTZ+Hf+pCcDwDg2tH8pzMKHWva8EgvhE=;
        b=B9HHpnIvGe4wxTRenNtAcCKIK1MLDSAusoUl6hADpsckyTUplpLGKmqC1G1/poRvu5
         TmdL/jjvHR6YyB8FNHW6Zrcy2cSVnFQ+h9Edmsdz4ffg7jT7X0lkmp8w2bZCZSBet0Oj
         YBeKW8FU7XFC1j/B1FtCvQHSN+o0FVQikeIz3KzlkzKJ3l89b9dFGClfNZjeeVfcwgfU
         3Y9mPvCWk98vDfcz9xN4ttgxUqUJ24PdjLoqv2e2UsZU939Dk/iVF8q5sWd1cssKlGpU
         GmQo8T5Muk6RbrCnBsdx/CMW3YN9kx47gwqBbRDJQwfGo74yQ73VuR42JEOWMX7fYYC8
         ersA==
X-Gm-Message-State: AOAM530x1fNcz3FTYiAqTM8Lgc78uqrwZw7wTTCGL29XC230r3aaiiIE
        I0yyXiXxLakssS7YxwMIEGEVvw==
X-Google-Smtp-Source: ABdhPJyzA3gBu6tJoV7aXuYH4hYAVPI7IiUCE5GtiiWU2bTMC48HhY0m5tzuX2uMo3QxpvekwlBCqQ==
X-Received: by 2002:ac2:5237:0:b0:471:fe52:9a82 with SMTP id i23-20020ac25237000000b00471fe529a82mr7133701lfl.624.1652545411030;
        Sat, 14 May 2022 09:23:31 -0700 (PDT)
Received: from [192.168.1.65] ([46.188.121.177])
        by smtp.gmail.com with ESMTPSA id p23-20020a2e8057000000b0024f3d1dae7csm891077ljg.4.2022.05.14.09.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 May 2022 09:23:30 -0700 (PDT)
Message-ID: <45e8576e-5fcc-bc52-8805-0b5cc3fc1a84@openvz.org>
Date:   Sat, 14 May 2022 19:23:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Vasily Averin <vvs@openvz.org>
Subject: [PATCH] sparse: use force attribute for __kernel_rwf_t casts
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     kernel@openvz.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org
Content-Language: en-US
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

Fixes sparse warnings:
fs/io_uring.c: note: in included file (through include/trace/perf.h,
include/trace/define_trace.h, include/trace/events/io_uring.h):
./include/trace/events/io_uring.h:488:1: sparse:
 warning: incorrect type in assignment (different base types)
    expected unsigned int [usertype] op_flags
    got restricted __kernel_rwf_t const [usertype] rw_flags
fs/io_uring.c:3164:23: sparse:
 warning: incorrect type in assignment (different base types)
    expected unsigned int [usertype] flags
    got restricted __kernel_rwf_t
fs/io_uring.c:3769:48: sparse:
 warning: incorrect type in argument 2 (different base types)
    expected restricted __kernel_rwf_t [usertype] flags
    got unsigned int [usertype] flags

__kernel_rwf_t type is bitwise and requires __force attribute for casts

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 fs/io_uring.c                   | 4 ++--
 include/trace/events/io_uring.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91de361ea9ab..5ca4a6e91884 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3161,7 +3161,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	req->imu = NULL;
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
-	req->rw.flags = READ_ONCE(sqe->rw_flags);
+	req->rw.flags = (__force u32)READ_ONCE(sqe->rw_flags);
 	req->buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
 }
@@ -3766,7 +3766,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
 
 	kiocb->ki_flags = iocb_flags(file);
-	ret = kiocb_set_rw_flags(kiocb, req->rw.flags);
+	ret = kiocb_set_rw_flags(kiocb, (__force rwf_t)req->rw.flags);
 	if (unlikely(ret))
 		return ret;
 
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index cddf5b6fbeb4..df4b89a79764 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -520,7 +520,7 @@ TRACE_EVENT(io_uring_req_failed,
 		__entry->off		= sqe->off;
 		__entry->addr		= sqe->addr;
 		__entry->len		= sqe->len;
-		__entry->op_flags	= sqe->rw_flags;
+		__entry->op_flags	= (__force u32)sqe->rw_flags;
 		__entry->buf_index	= sqe->buf_index;
 		__entry->personality	= sqe->personality;
 		__entry->file_index	= sqe->file_index;
-- 
2.31.1

