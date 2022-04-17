Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363A75047ED
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 15:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbiDQNp5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 09:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiDQNp4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 09:45:56 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A6FA1A7
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 06:43:20 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id h5so14426280pgc.7
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 06:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=EwILbNqj1En2gCk70iVQXMrRBjEytHgJAy3rmAfZ5Hw=;
        b=qv+9U+4+4W4gqRY3OLtFoUUJqBDmuWXXd1GoCuuJXIyRdjnTr7CqEj8X63twWsfU3r
         2YvCGwwQ0w54vyEiR+Aruz4gHc1G5WbuMrfSaIraDYiKKBELMLnG/1gDikFDC5TeKKd9
         lwz2vg8x/T4RsmgcotuKDchLHIIfAonhc6slpO58zKw8Q+vJsOd+zOU6b50aMpiwaF8j
         IJK8mclVBNw1EbHXbhB07BRjaerANTv0dzNbUcmBF5hVBM2qo8LsJhUKEz1IlbJRh6qx
         +M53IZZIeofWZU7UZUuiISiLtl6KwZ8384nlLmLdJNkarIv6JrYqqWPgXidG3FCxAV/h
         q3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=EwILbNqj1En2gCk70iVQXMrRBjEytHgJAy3rmAfZ5Hw=;
        b=vyryU9S/3e10IYh3LKkt8znJm28gXcoO8MuLXeuGX3ROXoiXTkD4+t51eg0z3AYeBM
         Um/SQeZTyrz9j9KXzsjrpLgUIXrEzPUit31NrcSY8l/4DLDfQGoYx2KAk2s6XsFdmrJE
         AUGphwbnkPL/1ZOUv/uX84UGkKBfwNH4NeQlJi4gOgLJJ6bjVKO1UK0pvz90CysbY6+T
         af0qZT2On7I/CT1goXiaJ1iPiDMplF/YNcp+Fq3JSciPMcXgNAXNQSCA/edHbSMmx1qI
         lo9sqhieFlqrKWmIZbzbV3iL/ZUBUYWY3diHxzsTDi2xhO74+KIjQRKIIsdAQBNpb9Np
         6fJA==
X-Gm-Message-State: AOAM530dBUxtjD0XU2xmSE25iPdDdUn933oORIELszvPxK4WqbwtZ+pZ
        Gw61g7vPwXwpVe7K64ZjPUdjukIYLnmU/4hu
X-Google-Smtp-Source: ABdhPJx7spugmNioOc5cubLym2HNalA8GaO3Fc5iSHOCPqxc+kTCqiqg/meqEW0Rny9OjSt06B47nQ==
X-Received: by 2002:a05:6a00:801:b0:50a:6a46:598c with SMTP id m1-20020a056a00080100b0050a6a46598cmr2307758pfk.54.1650202999642;
        Sun, 17 Apr 2022 06:43:19 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g17-20020a625211000000b005056a6313a7sm8790923pfb.87.2022.04.17.06.43.18
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 06:43:19 -0700 (PDT)
Message-ID: <e2f326d2-3533-654e-e040-44a71cdcc896@kernel.dk>
Date:   Sun, 17 Apr 2022 07:43:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: free iovec if file assignment fails
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

We just return failure in this case, but we need to release the iovec
first. If we're doing IO with more than FAST_IOV segments, then the
iovec is allocated and must be freed.

Reported-by: syzbot+96b43810dfe9c3bb95ed@syzkaller.appspotmail.com
Fixes: 584b0180f0f4 ("io_uring: move read/write file prep state into actual opcode handler")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4479013854d2..24409dd07239 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3832,8 +3832,10 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		iovec = NULL;
 	}
 	ret = io_rw_init_file(req, FMODE_READ);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		kfree(iovec);
 		return ret;
+	}
 	req->result = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {
@@ -3958,8 +3960,10 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		iovec = NULL;
 	}
 	ret = io_rw_init_file(req, FMODE_WRITE);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		kfree(iovec);
 		return ret;
+	}
 	req->result = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {

-- 
Jens Axboe

