Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4464650D51
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 15:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbiLSOcz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 09:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbiLSOcS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 09:32:18 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FC11A4
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 06:31:37 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id s7so9186918plk.5
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 06:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HuqIP5LGl7DjXndmCVG8SH85v1dpGijNePy1Y/NSabQ=;
        b=qMZk5abf2Vnrqyx8Jc3ff46UZQw5G3bN6pgkub2OnrI4prUu8kP9SOxCPtzmn6kg+y
         g/J9qgPL8iEYZmR2Vht/MCBn+mmN66imxsnMH6+AI7JKao4XCS/NIQNY5inTvMXAvZ8R
         0iXpPGGnJIZabCQ2Pwuhi9HzfZ05Qhgt2PKxFn21/EuP0D5DnbKgx/NiR6hwTES8dqvr
         0mUuHJDeNt0tCZPHRHFmSFf4fiyen7qwUtnqKgrIbyQ8kUzgvueO0GskVs5dybH4865F
         4Cpuf/a6/IDv9xvUGktnTYM53lk7AXfNyBQfx971x1+xVy/JLFdMz0wh1XP8wD4avycU
         5oew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HuqIP5LGl7DjXndmCVG8SH85v1dpGijNePy1Y/NSabQ=;
        b=mhr58+MDWkpKmBIFxqZDlnddUw3tcHRZspKY4W/vqUBxtC4GFZ4vATyhKUPH6r7RgU
         8hZq2M00zJI8AnmDOvDVOmhGhGOUN6ScNEALcgt6U3aN9fgamG5KmOMF5x9fI9P1Zm5C
         H8SkQaG5IoPDtr+sIzSiVSZ8CaWOmvbo2sh5mFnxiB6uiFnPBvUY09b5A8sD8mRAA5Jj
         Cpe4/GF1kjoE2qEV33z+wK3PWm/QfPL/qbHnZ7IL8LxVoGzHf61zbsYLgd2xytMk3I90
         g0xdRWSkd9ULZJwJHAndy9obJuh0DguSTbIGNg8aPDc0Hy/eCPne+3p+8Ezi+NHekE+2
         JrFg==
X-Gm-Message-State: ANoB5pnCMAy99sVOMhSzgqZSSLlOyF0P/Ji17vnlBICO1xBS0MfDqwHS
        5J/d6mdJgUAW3xh9z7Ms+xjDQ16ncBk+QKbVfyQ=
X-Google-Smtp-Source: AA0mqf4uo3uxFocnTb9XlE7CW0CHmOIgMiz/nB185umDJv77R/+lB9iZGp7T8ILvJ7iRL5rTYntyBw==
X-Received: by 2002:a17:902:d58d:b0:189:f277:3834 with SMTP id k13-20020a170902d58d00b00189f2773834mr12253007plh.6.1671460295998;
        Mon, 19 Dec 2022 06:31:35 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h14-20020a170902f7ce00b00189c93ce5easm7182819plw.166.2022.12.19.06.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 06:31:35 -0800 (PST)
Message-ID: <a8ab87bc-760d-a17f-9110-ae99cb59311f@kernel.dk>
Date:   Mon, 19 Dec 2022 07:31:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: ensure compat import handlers clear free_iov
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we're not allocating the vectors because the count is below
UIO_FASTIOV, we still do need to properly clear ->free_iov to prevent
an erronous free of on-stack data.

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Fixes: 4c17a496a7a0 ("io_uring/net: fix cleanup double free free_iov init")
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 5229976cb582..5aebdfd05de7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -496,6 +496,7 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 
 		if (msg.msg_iovlen == 0) {
 			sr->len = 0;
+			iomsg->free_iov = NULL;
 		} else if (msg.msg_iovlen > 1) {
 			return -EINVAL;
 		} else {
@@ -506,6 +507,7 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 			if (clen < 0)
 				return -EINVAL;
 			sr->len = clen;
+			iomsg->free_iov = NULL;
 		}
 
 		if (req->flags & REQ_F_APOLL_MULTISHOT) {
-- 
Jens Axboe

