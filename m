Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7203A6C21E1
	for <lists+io-uring@lfdr.de>; Mon, 20 Mar 2023 20:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjCTTsS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 15:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjCTTr7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 15:47:59 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D003186BB
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 12:46:18 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id h7so7074710ila.5
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 12:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679341578; x=1681933578;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AUn52EW11J3zoV0tM8bRDEf4UDjiTecjwfVChm2ZUBE=;
        b=cSkYj+CH4+stOzM8QOGij7HCYee+O59ZiYYZab19LKp60jjFkhNayDgSE8cLgN0IEV
         cQtqWX/MQloEn28GV/kfY47+v8YV2ckX0YSyFpuEOtscny0MJTl6YoAxeVJ59QAMSqvg
         /VOb18wi8Xapvi4Q3gqXYJlFMnQi6r73kMZOtAgbQGjBQ7kZO8VTD1Q+5kWJYmWo0Lyc
         kycTMGDSALzoAShpSuLyyplx/DdSQuKAVhE/hhh4veNQK5RFbWvnlsk87kjkBsTsLT8r
         OlSsvY4jq1EMIj9Tcl9QgTmuLBr0ZBjjJPoi8iN+uGmQlfThX8kekuxXOvyPbHBey8dQ
         ujtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679341578; x=1681933578;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AUn52EW11J3zoV0tM8bRDEf4UDjiTecjwfVChm2ZUBE=;
        b=TWzyocImF24RFuboQcBnuavB2d5tDX7jVaoG+dU2/WYryYni4HW73SpZC64I0Igcko
         Zbn77pbgdM26Pa+t/G3TOSn8eCDeFzDUnFkFrzfigOSgYKsYITFHZH9orSsY90kgzXbf
         lBjU9cMSeDDN7ktqcLQwcl89eqbIYfPjLJjRssgKgXBNWaFXlIusoNEGymo4bYPSlRsA
         //veapC492Uh2zJxhwzB2VEBdHinu73SBQV+TCSLUwHS02n8T228KBqTVh2UQq5usMaM
         nC8Z8L3QVNqyhPP5de4qsjtHizrk+pasO3pHPH1w9jkozba1peMr99/Z9BsKczsyw2io
         k5QA==
X-Gm-Message-State: AO0yUKVaAMxkKXglwkxk60dBfimaFoxLdx2FWtwkoXQTzEQ3SNv6CXRX
        1MCERH5KjxZ7YADsPt4dxArI2MrC+aGUXr2A1NnZxQ==
X-Google-Smtp-Source: AK7set9XJzP/2nMhk+yTsaS4AWcuE8k707K4m7cHlmYDgnyOaRWWNpoyhr05kahQ6k0Nyb5BQulnMQ==
X-Received: by 2002:a05:6e02:12c8:b0:317:2f8d:528f with SMTP id i8-20020a056e0212c800b003172f8d528fmr491009ilm.2.1679341577805;
        Mon, 20 Mar 2023 12:46:17 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e28-20020a0566380cdc00b0040634c51861sm3375259jak.132.2023.03.20.12.46.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 12:46:17 -0700 (PDT)
Message-ID: <e1760236-2005-6970-75bc-948dd960ae53@kernel.dk>
Date:   Mon, 20 Mar 2023 13:46:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: avoid sending -ECONNABORTED on repeated
 connection requests
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since io_uring does nonblocking connect requests, if we do two repeated
ones without having a listener, the second will get -ECONNABORTED rather
than the expected -ECONNREFUSED. Treat -ECONNABORTED like a normal retry
condition if we're nonblocking, if we haven't already seen it.

Cc: stable@vger.kernel.org
Fixes: 3fb1bd688172 ("io_uring/net: handle -EINPROGRESS correct for IORING_OP_CONNECT")
Link: https://github.com/axboe/liburing/issues/828
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index b7f190ca528e..4040cf093318 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -47,6 +47,7 @@ struct io_connect {
 	struct sockaddr __user		*addr;
 	int				addr_len;
 	bool				in_progress;
+	bool				seen_econnaborted;
 };
 
 struct io_sr_msg {
@@ -1424,7 +1425,7 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	conn->addr_len =  READ_ONCE(sqe->addr2);
-	conn->in_progress = false;
+	conn->in_progress = conn->seen_econnaborted = false;
 	return 0;
 }
 
@@ -1461,18 +1462,24 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = __sys_connect_file(req->file, &io->address,
 					connect->addr_len, file_flags);
-	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
+	if ((ret == -EAGAIN || ret == -EINPROGRESS || ret == -ECONNABORTED)
+	    && force_nonblock) {
 		if (ret == -EINPROGRESS) {
 			connect->in_progress = true;
-		} else {
-			if (req_has_async_data(req))
-				return -EAGAIN;
-			if (io_alloc_async_data(req)) {
-				ret = -ENOMEM;
+			return -EAGAIN;
+		}
+		if (ret == -ECONNABORTED) {
+			if (connect->seen_econnaborted)
 				goto out;
-			}
-			memcpy(req->async_data, &__io, sizeof(__io));
+			connect->seen_econnaborted = true;
+		}
+		if (req_has_async_data(req))
+			return -EAGAIN;
+		if (io_alloc_async_data(req)) {
+			ret = -ENOMEM;
+			goto out;
 		}
+		memcpy(req->async_data, &__io, sizeof(__io));
 		return -EAGAIN;
 	}
 	if (ret == -ERESTARTSYS)

-- 
Jens Axboe

