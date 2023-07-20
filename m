Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8285D75B7CB
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 21:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjGTTS6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 15:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjGTTS4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 15:18:56 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687F32118
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 12:18:53 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-7748ca56133so11727139f.0
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 12:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689880732; x=1690485532;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1FMs55iNJ7wOg/bgwUPgSC+zAeUUdwA3ycGTcF3hfuU=;
        b=BN8IST1dJbj0nnYWwz2212vYIPN60OEz3XqPsVMScK1p6aSxnmmtSJaOAKWFTTK3em
         kwT5weNPKgpZlspQ+/gxj/CtfigyaFsyLKQImg58kH3JBrmXVDnnboJOoYhcdyTgu5J+
         W9kha2MmrkS0P7Ii/Dm7MIzKrVzKz/IbdlXqqUV8DDpAIDykv2i2g+0nhiSd46X4hDtR
         ckh74ojhUE5mYQ0djSvvyC6HMSlKCwyzWwsI66TlBlnEoUYZnd7kbcDlSfmgDe1/3A4F
         0sU0+Ks6hfZrWBJOStpLY4lc5y9vYyXAX5xqQ87UKSPBTO3hhBZvN8JUNl+BzYoAaYHK
         j/UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689880732; x=1690485532;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1FMs55iNJ7wOg/bgwUPgSC+zAeUUdwA3ycGTcF3hfuU=;
        b=OqAtN26ttkckdH9UpfokFSG4eX32KDw0ZkmAufO3F4pTq+OvKVN3kGsn9g1z4zKHjZ
         qahY38SVn9z4GiRTA3IX29M773ckYoLBgr2q8F0/eZ0Zo/Mk886BGl8V+kOXm7t/aFFb
         9mG5xxC3N7LpNv0LRUjTOUrsZHSeG8GtD64ryGciL5wv0z0IoTV8vqG3FJcmOWoWaXoR
         AR2HQIhXzmfFfLxFYx4I7Tl0pZ6Trjps40Dwb5hnQ/usgrdXpzeN8WWt8MuY05rux2l5
         /Zg3TtfKXRFizV/icNJteOhhiFoGS8FuHNEv3SvFMtPxlljUmNQOETphEQ7zjvuzGCFH
         pCkA==
X-Gm-Message-State: ABy/qLaUVszj5rl4unY/r+kqgwRtoc6PTLv7OCGoSBvBYnayPiaioPiF
        qBYajqc6Fs0ZTeJFBogB13Je4GqMFyxm2u+zA0k=
X-Google-Smtp-Source: APBJJlHo8xQKh3WDzUCkdftKVgSeT32b1O1rPbjxF6Xk/CGfXG4tdWdlCcT9PU38cM21oy3fQFb56A==
X-Received: by 2002:a05:6602:3808:b0:787:16ec:2699 with SMTP id bb8-20020a056602380800b0078716ec2699mr4284900iob.2.1689880732151;
        Thu, 20 Jul 2023 12:18:52 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q13-20020a5ea60d000000b007836c7e8dccsm513604ioi.17.2023.07.20.12.18.51
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 12:18:51 -0700 (PDT)
Message-ID: <363d8e40-6acc-57bd-feb1-4dbd50e15c31@kernel.dk>
Date:   Thu, 20 Jul 2023 13:18:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: treat -EAGAIN for REQ_F_NOWAIT as final for io-wq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq assumes that an issue is blocking, but it may not be if the
request type has asked for a non-blocking attempt. If we get
-EAGAIN for that case, then we need to treat it as a final result
and not retry or arm poll for it.

Cc: stable@vger.kernel.org # 5.10+
Link: https://github.com/axboe/liburing/issues/897
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a9923676d16d..5e97235a82d6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1948,6 +1948,14 @@ void io_wq_submit_work(struct io_wq_work *work)
 		ret = io_issue_sqe(req, issue_flags);
 		if (ret != -EAGAIN)
 			break;
+
+		/*
+		 * If REQ_F_NOWAIT is set, then don't wait or retry with
+		 * poll. -EAGAIN is final for that case.
+		 */
+		if (req->flags & REQ_F_NOWAIT)
+			break;
+
 		/*
 		 * We can get EAGAIN for iopolled IO even though we're
 		 * forcing a sync submission from here, since we can't

-- 
Jens Axboe

