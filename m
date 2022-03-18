Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D47E4DE036
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 18:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237687AbiCRRrC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 13:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237239AbiCRRrB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 13:47:01 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2634D23D462
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 10:45:43 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id r11so10071791ioh.10
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 10:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=1vZE58a3WTJJ3wyAYPRUtJ5sb/KdI4h8NkISB6NGmXM=;
        b=5EH7E+w/3/RVJ9aQe7idbt+ImaOS62lJDie6OIXkJ7ifO/1SJkUhA4+JbMDgJZaAZ8
         E2nrx+MCwwJDVH1MD7ILPGfzOUnuc/+r+O5hSuAkaiRbk9CaD8XhJhKurZIpkvHNmYYA
         y/Yp5+EYtW4Y6l1N8zX+joDxyfQ1KYQsEwQ1tFOEsWKBfguT9Bkz2TVpxaUy2SiYAjwG
         0KntVDk0jqwmMNfXtpcH4v4fcqzf39Vnt599BecM019aFbfDs1oc2wOSPEdTiYBe6Xdf
         doENoovw9oD0fXHdu1IGUPs2iY12rKtzacvbwoZPUYEuJd5JDdNRc4ps9eTcY0AOng1+
         NKeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=1vZE58a3WTJJ3wyAYPRUtJ5sb/KdI4h8NkISB6NGmXM=;
        b=NLYdMm679lc465bL3Vr73JMnr91L/4qMb7/VCtWT+7Wra+mOSVoVF9+bzC3Iq8dnxn
         nMRtDBzF7tM5fFK4aeX9s6x9+JaW30LfqtcLkPEsPbe8KnC3WdWEUjnQJH/pyCX4mMn4
         Joq+6bS0Kp/yX37NQ3k4nNEbxDn2am/qY4jKIvjrMu6/hEmJmh6g6VtGr+mCxTA+6j2z
         YGOWzuROq0IArs+hZXXDmcHBTYJaxSCWMPkTCwbNzulwz9oCXn9UnSg3/QzaftyirhIa
         ty1S7OTRPn6dWQVDOsYuLQJzgJGFxqiKvCy3PIZhtNsqYXcOYuxjiKJYRq+wdY6PAfcW
         6iKA==
X-Gm-Message-State: AOAM5322Zjr8eDTys6RVPoRCvYSpnPb8aJtLoXwBj+IEFrfUY4EnBm7n
        wAqDf6mIsPOpZvRQFQKUrYzYXvYuMFRL7VoM
X-Google-Smtp-Source: ABdhPJyjZhGPhB4ir+UXbFt3/3pScv+9hiBANcTaD68TO3LT6tRJXjuyAeVeb0k8uvjoLPr4tfX+Wg==
X-Received: by 2002:a05:6638:14c1:b0:319:dd1c:e179 with SMTP id l1-20020a05663814c100b00319dd1ce179mr5233914jak.64.1647625542311;
        Fri, 18 Mar 2022 10:45:42 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n7-20020a056e021ba700b002c63098855csm5227562ili.23.2022.03.18.10.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 10:45:42 -0700 (PDT)
Message-ID: <d70b7076-335a-3639-3807-d5bbf3d18857@kernel.dk>
Date:   Fri, 18 Mar 2022 11:45:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: terminate manual loop iterator loop correctly for
 non-vecs
Cc:     Joel Jaeschke <joel.jaeschke@gmail.com>
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

The fix for not advancing the iterator if we're using fixed buffers is
broken in that it can hit a condition where we don't terminate the loop.
This results in io-wq looping forever, asking to read (or write) 0 bytes
for every subsequent loop.

Reported-by: Joel Jaeschke <joel.jaeschke@gmail.com>
Link: https://github.com/axboe/liburing/issues/549
Fixes: 16c8d2df7ec0 ("io_uring: ensure symmetry in handling iter types in loop_rw_iter()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2d6ab732f940..5fa736344b67 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3612,13 +3612,15 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 				ret = nr;
 			break;
 		}
+		ret += nr;
 		if (!iov_iter_is_bvec(iter)) {
 			iov_iter_advance(iter, nr);
 		} else {
-			req->rw.len -= nr;
 			req->rw.addr += nr;
+			req->rw.len -= nr;
+			if (!req->rw.len)
+				break;
 		}
-		ret += nr;
 		if (nr != iovec.iov_len)
 			break;
 	}

-- 
Jens Axboe

