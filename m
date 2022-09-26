Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEA25EB5AE
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 01:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiIZXXz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 19:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiIZXXa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 19:23:30 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B40974CFD
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 16:21:41 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id l8so5498885wmi.2
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 16:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=2lSUpe592kbPQPhQMkeGWB6/Vun9yDD9GrzMvVsq/YE=;
        b=JFbAjsOf6gkvU2GaAnBFENd3hLGFO8h2NWD77dSXj1bf6R8YMQhAOAKRgS1GguZODi
         mMWUwIcBxp8oMowWSmqmooyQE8Ui8DGey2yyqCMn0PrnQSphOLdHYV9sqaCkWi3J8Z71
         ujS58zLsqNRstIljwi/BiKQSRGan2yCrK8ToOD/6tmLmiax2KRqKrHyL2VbtC+GWYlTI
         Wd+juE6H8Bzv9SvrgJc8ORLrGUT/rGNhFJHze6jMTRjxuJWd9JOru/P2NJO+5wzIejui
         SJsgic1C/OHKFpigsmAoQkC3IfHmwzIbTReZv5jq4WjZ65QuyxlSlgwVlycLigCNgSvq
         CPUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=2lSUpe592kbPQPhQMkeGWB6/Vun9yDD9GrzMvVsq/YE=;
        b=22JgSs5zwI8My6VvGi2trea14e0BJnp6fRWbj67Jz3dnRu0kdM7wztB0B3TEKSQ+fL
         PPLfTkVMNKSuSK+RsNwnr/+3XdPy5TvXGQnNrHpgA8G+gwfqIgF8q1DOpgCCPA/9JnXO
         joOu3loQxurFg/KP2cJDFtgy6PIujPf4Domt2i12fe69NP2qHeHueIdYGNiKE8qmqtUd
         G2aZECA4khvid8AsDN44UDN0hO/xH6nF6HlbbbVMSuebcPqQVBsDuHDTrLJvIUmryIRt
         ISpc2Mw9S/N8lfvsXDQdd59+l73sQvVkm0Vc0MNZy2pawbZnxOxQT26DgVH72XpdTU/U
         TEXg==
X-Gm-Message-State: ACrzQf1NWHMbRA1dgaUuzdp10stA6CEKwJf1KpMbZZn/b2Ugb3oRZR7Z
        gvbRbjq/WJf+5VmTIqTQnRfiXAZLspM=
X-Google-Smtp-Source: AMsMyM5BoDLsOTFAfDL386+fPjg+8rwxIFtbUFGximKW1UCOcJU5xowKivua312gQyRza1tybn0Ukw==
X-Received: by 2002:a7b:c450:0:b0:3b4:fb1a:325d with SMTP id l16-20020a7bc450000000b003b4fb1a325dmr654012wmi.138.1664234499131;
        Mon, 26 Sep 2022 16:21:39 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id p16-20020adfe610000000b00225239d9265sm90616wrm.74.2022.09.26.16.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 16:21:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Beld Zhang <beldzhang@gmail.com>
Subject: [PATCH for-next 1/2] io_uring/rw: fix unexpected link breakage
Date:   Tue, 27 Sep 2022 00:20:28 +0100
Message-Id: <e249fd61212bf9d1b15dbd4628a4ba615c5eef51.1664234240.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1664234240.git.asml.silence@gmail.com>
References: <cover.1664234240.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->cqe.res is set in io_read() to the amount of bytes left to be done,
which is used to figure out whether to fail a read or not. However,
io_read() may do another without returning, and we stash the previous
value into ->bytes_done but forget to update cqe.res. Then we ask a read
to do strictly less than cqe.res but expect the return to be exactly
cqe.res.

Fix the bug by updating cqe.res for retries.

Cc: stable@vger.kernel.org
Reported-by: Beld Zhang <beldzhang@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 76ebcfebc9a6..c562203d7a67 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -823,6 +823,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		}
 
+		req->cqe.res = iov_iter_count(&s->iter);
 		/*
 		 * Now retry read with the IOCB_WAITQ parts set in the iocb. If
 		 * we get -EIOCBQUEUED, then we'll get a notification when the
-- 
2.37.2

