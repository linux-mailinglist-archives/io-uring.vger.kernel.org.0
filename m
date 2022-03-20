Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9270B4E1D8C
	for <lists+io-uring@lfdr.de>; Sun, 20 Mar 2022 20:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343585AbiCTTNw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Mar 2022 15:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343587AbiCTTNu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Mar 2022 15:13:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D4D197AFC
        for <io-uring@vger.kernel.org>; Sun, 20 Mar 2022 12:12:26 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so12664477pjl.4
        for <io-uring@vger.kernel.org>; Sun, 20 Mar 2022 12:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=OLg8ROzI9UsQBW7W+UtHMxjmHMFHW3BvwAHrOuDaWu0=;
        b=cD31NiFf59iqd5t8ZEEWgXt50xvtV1IhXswsK0ofGANX0wcSyWzU9Bd7aemja/Pue5
         w0EWsysV6y45FAH6n41m7ezvyKGbnxNEvTycs5mH2XXRZji0nCusVVU0yQGhvdoifhq/
         aJEznnW7n+bqr7DVWOVP6JwjBV9tGRrImf9zHelWMoUKNUeLvvzuIg/kAjlw0fudBqE7
         tl0ny4IKsJu7Y0cbllTKilMtVkTwU035yVxOoXXOBW7K4RgtmHCxSAl6KZ0j3q9K0ciC
         t0s2/hgh7sUYaRYxSbK8cZvtKpSyfz/HNwNCDqI5gk2hnduKDnDSpH2FF20epGHiWIq8
         IPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=OLg8ROzI9UsQBW7W+UtHMxjmHMFHW3BvwAHrOuDaWu0=;
        b=wE01IiV+lUKIMCyXsmYQIJSRbojR2fikwA8tTamEHdxA6frkR4bT3A7u3TMN2c5Llk
         51MZyEa5T0mot1sXV8DXgCfCxff/x5bMUQsfbewI45Fyjc0vG/fyNZMzvY6PMYPwrKfB
         ZMOArQnOSiKNDE+BVdyTuezobbn4D1JtAepotpBAyC/U2/fIODlce67d+Sh2296YQPGr
         ZN514+sxZCqAOG62+FSacC6IGsX58DZEQ/EgYVovG3V6uGVqq2rlk2RT8akwDmkZsQpE
         ksWlzBRdalmYGRMvhLl8Ce+s+ZUpGRCCPxR1Cj2TyXVGgMCwv9OmnFTcn4s9yszpA8E6
         bH5g==
X-Gm-Message-State: AOAM532m6TMRJN2aBnoNFLO0ilVsZkpAnTE/aa+pz9yBGEgpeSdNMvJS
        vjBd3TK5ZI3bPqWUDwCwSjCQHWtP6RFA77U5
X-Google-Smtp-Source: ABdhPJw4WV0SWRhz7QejygMMqFDaCk7BSAtLErqghIdXywFKKXvn4kh8w8ZfgMcvpPpo0nr/OsZ5Yw==
X-Received: by 2002:a17:902:bf07:b0:150:9b8a:a14f with SMTP id bi7-20020a170902bf0700b001509b8aa14fmr9529776plb.127.1647803545906;
        Sun, 20 Mar 2022 12:12:25 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i11-20020a056a00004b00b004f6907b2cd3sm16317679pfk.122.2022.03.20.12.12.24
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Mar 2022 12:12:25 -0700 (PDT)
Message-ID: <44037852-263b-0110-c5c8-a64cdbcf547e@kernel.dk>
Date:   Sun, 20 Mar 2022 13:12:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure that fsnotify is always called
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

Ensure that we call fsnotify_modify() if we write a file, and that we
do fsnotify_access() if we read it. This enables anyone using inotify
on the file to get notified.

Ditto for fallocate, ensure that fsnotify_modify() is called.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 98949348ee02..7492f842025a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2922,6 +2922,7 @@ static void kiocb_end_write(struct io_kiocb *req)
 		__sb_writers_acquired(sb, SB_FREEZE_WRITE);
 		sb_end_write(sb);
 	}
+	fsnotify_modify(req->file);
 }
 
 #ifdef CONFIG_BLOCK
@@ -2975,6 +2976,8 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
 	if (req->rw.kiocb.ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
+	else
+		fsnotify_access(req->file);
 	if (unlikely(res != req->result)) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
@@ -4538,6 +4541,7 @@ static int io_fallocate(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_complete(req, ret);
+	fsnotify_modify(req->file);
 	return 0;
 }
 
-- 
Jens Axboe

