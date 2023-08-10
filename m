Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAC7777E45
	for <lists+io-uring@lfdr.de>; Thu, 10 Aug 2023 18:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbjHJQ3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Aug 2023 12:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbjHJQ3x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Aug 2023 12:29:53 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C333C5
        for <io-uring@vger.kernel.org>; Thu, 10 Aug 2023 09:29:53 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-348d1c94fdaso1360615ab.1
        for <io-uring@vger.kernel.org>; Thu, 10 Aug 2023 09:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691684992; x=1692289792;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lVC6cdnksTa2WxKrHDm0l6Pd/A1ZWvvqdzTZT5Opwd4=;
        b=iHxLQGtBeHF55qq0RUHSHwSfrl55tPVOJrBJWOrpPHH4z2wpVXiN79GdZbCNNmOQpr
         klfYPJYqTkkOdjqEvOalQVcPBclUitW58gmPsD42JPYvcbXa3sYXO82bmBPqXGeKC6rJ
         sjbaNyLp2XLHYjjkKWJKyiilIa4Ggp1J2boijYTNa9pl/kJ/XGtT6un31RWJjwFpXrQn
         xlLdIpkY7jfGebfVG9/gdypaQptBnLbPZw09WTajws1aOZhg43zBT2Cx0Kw4bBttXr3a
         P/xIBnqO5kGcAcmobYaodjjohFpdUHXZ4z13waQPwlGVZ7MaoZzeXE0DIgCK/IDWsSmg
         O1Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691684992; x=1692289792;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lVC6cdnksTa2WxKrHDm0l6Pd/A1ZWvvqdzTZT5Opwd4=;
        b=h9y+ZfSX4L5q3Q+mmlAchpoP3vQEvlDW011pYQfg6fstPUWWYJIGRJ3epu7pkmfqjX
         ekgFQqWkmdv0diI4a/1ZgkqJ991JSR0eeFPZQeXjfrlPMp7joMuctQGC7Leg4HWtmQZl
         HNzbOKs8TvGY1ZVX8+ujX54LtiePuwGK44g22eWb4JcYaadwwSlySB9b4+wCyjO86gqw
         JU82U0DSC+fiZag+zOftRTS7Mqi4iVe6y2Fhoktz/L8lRoikQiOPwhhZM+DYKleHeUMx
         pFIg6c5lyzUvJLToM1VaL/nch8JI6y8IlqdvLtaGmtiU76Kom5nwc+2XUjlm3PEY08rA
         K9cw==
X-Gm-Message-State: AOJu0YzdjTYAOCJt7RZ92oRkFgsB8xv9EJE71gAtgCGn1BquBB7BAOTp
        6GfEuss8st3pzGG1p1ouEga9pu07fEv+DrnfIx0=
X-Google-Smtp-Source: AGHT+IF+g5HKmdk6qnwK0VP+P2v05fDNL8Dy5wvlK39kcuWEp5s7aF0SwX/pqVSC32ra0zOQLcxlAw==
X-Received: by 2002:a92:dc04:0:b0:349:1d60:7250 with SMTP id t4-20020a92dc04000000b003491d607250mr4052404iln.0.1691684992538;
        Thu, 10 Aug 2023 09:29:52 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t16-20020a92dc10000000b0034938167b1asm523800iln.73.2023.08.10.09.29.51
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 09:29:51 -0700 (PDT)
Message-ID: <11b283b3-cfc5-40d4-933c-c1a0750dc1e2@kernel.dk>
Date:   Thu, 10 Aug 2023 10:29:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: have io_file_put() take an io_kiocb rather
 than the file
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
References: <20230810162346.54872-1-axboe@kernel.dk>
 <20230810162346.54872-4-axboe@kernel.dk>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230810162346.54872-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/23 10:23 AM, Jens Axboe wrote:
> No functional changes in this patch, just a prep patch for needing the
> request in io_file_put().

Gah, that was an older version. Newer version checks the
REQ_F_FIXED_FILE flag in the helper instead:

commit 17bc28374cd06b7d2d3f1e88470ef89f9cd3a497
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Jul 7 11:14:40 2023 -0600

    io_uring: have io_file_put() take an io_kiocb rather than the file
    
    No functional changes in this patch, just a prep patch for needing the
    request in io_file_put().
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index dadd745d389e..15697d88930d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -998,8 +998,7 @@ static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 		io_put_kbuf_comp(req);
 		if (unlikely(req->flags & IO_REQ_CLEAN_FLAGS))
 			io_clean_op(req);
-		if (!(req->flags & REQ_F_FIXED_FILE))
-			io_put_file(req->file);
+		io_put_file(req);
 
 		rsrc_node = req->rsrc_node;
 		/*
@@ -1533,8 +1532,7 @@ void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node)
 			if (unlikely(req->flags & IO_REQ_CLEAN_FLAGS))
 				io_clean_op(req);
 		}
-		if (!(req->flags & REQ_F_FIXED_FILE))
-			io_put_file(req->file);
+		io_put_file(req);
 
 		io_req_put_rsrc_locked(req, ctx);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 12769bad5cee..ff153af28236 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -196,10 +196,10 @@ static inline bool req_has_async_data(struct io_kiocb *req)
 	return req->flags & REQ_F_ASYNC_DATA;
 }
 
-static inline void io_put_file(struct file *file)
+static inline void io_put_file(struct io_kiocb *req)
 {
-	if (file)
-		fput(file);
+	if (!(req->flags & REQ_F_FIXED_FILE) && req->file)
+		fput(req->file);
 }
 
 static inline void io_ring_submit_unlock(struct io_ring_ctx *ctx,

-- 
Jens Axboe

