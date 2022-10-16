Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48E0600425
	for <lists+io-uring@lfdr.de>; Mon, 17 Oct 2022 01:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJPX1F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Oct 2022 19:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJPX1D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Oct 2022 19:27:03 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BE336787
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 16:27:02 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id h24so6494506qta.7
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 16:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iFT7U8qgm4mPGYgCPN1h/awcyWV3zjeOYXdik70Po14=;
        b=CVQntaQ7ETbY+ugQjPYUwIU2s2cAHHCxyGOIuzgR7ZRSyl+x4gfkrq6wTtIW9w1S82
         QCY6WKw7XAq/RL7ZZ3wEsbodX8YwQClcEGnRXVmfuAz+95pkdKYLc+Mg1rB9exc7irDc
         UlWPCKRoR4yxD5uYkYW92x57BKMRvrCoiZlneZu4qWaCIbJAstsRv+tMdbS3tkWXfPb4
         M3V0gP2pEhUzEe0CWhcFX1qzILrysSbrMISUHqssodtfjTlBPFp7pzPx6ezTSogLPOsO
         qt81NTtOYkSH4rXDTm73Q8KOnqit63EGy0K9xtC2MOqzwvT3K3wBkceFwxNFLiIq1+xv
         VsQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iFT7U8qgm4mPGYgCPN1h/awcyWV3zjeOYXdik70Po14=;
        b=JG26TNCjPFpJEokFe8Ofk/C9aEzbYsVnWT8CsfbHvQxxm9enp812n9S36IjSQdXbzI
         A/IqiLrMZv3h4qe4yOqr8lCzj5wUgJ+T0cjDSz0z9u2HnzdyNwByoOU7nqLRLypo4U35
         q5c3DE6/wuJBt3ePVBaV5MToOnb0F6Ja35yZoiSLhlPav+VdD7xTHKqOkrWLRrqPIfE/
         vOMpZspwXHvEEADD8c35xDiM3+znj432f1gDyr8PRbVyOboSyPKa//BDfiCGQXG2tt/Y
         w/PGkq6zWMPFRhUEe1Mk8iOHuRSQjjHOPYsMp1hFGpeuGTsr8R0P0SdBbRpSXw+wmSu+
         VNrA==
X-Gm-Message-State: ACrzQf27Z/+mNoBG2KxbyKqaAs/Dr0a955IZ8+HC3nEpIulk6GFlF0rO
        CN8TYrnTk5Zabhm7Qxbgg4M7MCZKJA3twssy
X-Google-Smtp-Source: AMsMyM7/LW2rH3HTq+XyN9pbl7cd/dm1fBe+zm7Yy+Qr8evYi7DkzIukBKsbloDOc2fRbi+tlUgj2g==
X-Received: by 2002:a05:622a:389:b0:39c:e87e:903b with SMTP id j9-20020a05622a038900b0039ce87e903bmr3034386qtx.392.1665962821096;
        Sun, 16 Oct 2022 16:27:01 -0700 (PDT)
Received: from [172.19.131.144] ([8.46.73.120])
        by smtp.gmail.com with ESMTPSA id r9-20020a05620a298900b006b953a7929csm8603392qkp.73.2022.10.16.16.26.59
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Oct 2022 16:27:00 -0700 (PDT)
Message-ID: <8517e3ad-62d2-fdf7-e8a0-8dd5cfa8189c@kernel.dk>
Date:   Sun, 16 Oct 2022 17:26:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rw: remove leftover debug statement
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

This debug statement was never meant to go into the upstream release,
kill it off before it ends up in a release. It was just part of the
testing for the initial version of the patch.

Fixes: 2ec33a6c3cca ("io_uring/rw: ensure kiocb_end_write() is always called")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 100de2626e47..bb47cc4da713 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -242,8 +242,6 @@ static void io_req_io_end(struct io_kiocb *req)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
-	WARN_ON(!in_task());
-
 	if (rw->kiocb.ki_flags & IOCB_WRITE) {
 		kiocb_end_write(req);
 		fsnotify_modify(req->file);

-- 
Jens Axboe
