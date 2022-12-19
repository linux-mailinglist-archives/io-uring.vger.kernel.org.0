Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31A2650D70
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 15:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbiLSOgf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 09:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbiLSOgL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 09:36:11 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91558638A
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 06:36:06 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id a9so9185437pld.7
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 06:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c9MNKv6cA2M1dbecWKum7EhJMeeMPDbM2TD9KnukXtY=;
        b=J+1lGc+zbIuuzKY2z5QLdA6oc9KeKYni/WbOo+8xdaaPyU+tWp79Uc7wBl0gDBJQOd
         fCEVYzQTAek+kaGzEkjd2z4hXkw5n8L9/mgO+qm8Am47ppy/Z6/eWDVTuDDJe1A3Jv5L
         IOaVQHiNLb3tDVVo246LsGT3wz1qtf+WqkBg+UV74mBFHf27omHar/sybcLhKeYhqlPQ
         7fc/+rumuZwJRtfyIJyxz4USGfuJYth53pSzjIUcxMeWqXgQWf3wjkRKyyV2VEcbN0H1
         +WSSoxjt9Sgd2qvHA0Q/LVj55R157l+kMYiVmU0C7QBOI9fddUALJRgGM/vScZ+7MvzJ
         bucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=c9MNKv6cA2M1dbecWKum7EhJMeeMPDbM2TD9KnukXtY=;
        b=Bl1P0s6XBTFM6ynikafxJUFviRzvkrOozhIK2p43IRr+nCjg2SMv7e0notuG98pW8u
         bIsUdbHVAYh+sOpKnOf46N+/WfrfbD661czTE26n6McpHCb18+bzxiHFbAyHCA0po5ot
         33tZLwyTVUdQkbtx35GFDJo/iO4Ru2p0iaYKxSZQF07Igsgp+Lod+OpOCHcrQGGQNRkq
         9UxY5hxbiH+MuKAlamrw/sQLlk9SxLDJAryXA2Qs6O1XI8EJyx4omHSR9j6MWyIyBFg6
         z14r7MWRc672cspYroPLqddhSMFyzJq99NlRkhABa7VqZyvBo/NT+miO3iaxUWR3yG1a
         4l4Q==
X-Gm-Message-State: ANoB5pmS8Mfjj72b9uIEtCRufV2a/eW84d+BlLH1HkTv41d2LPqZ9Pow
        CBb/df5g5IEBQ2W2s8y2cFBc0LEmRqbu+PpvVv4=
X-Google-Smtp-Source: AA0mqf4yy59uMM1TOsB+0o3T3fkL4zaK7sGLtm1cd6+kJNXwiWtzOpwgO9NH9cmM/4SGEdp2GHXm9A==
X-Received: by 2002:a05:6a21:328a:b0:aa:4783:efc1 with SMTP id yt10-20020a056a21328a00b000aa4783efc1mr16731957pzb.2.1671460565270;
        Mon, 19 Dec 2022 06:36:05 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e35-20020a631e23000000b004784cdc196dsm6360572pge.24.2022.12.19.06.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 06:36:04 -0800 (PST)
Message-ID: <1fcaa6f3-6dc7-0685-1cb3-3b1179409609@kernel.dk>
Date:   Mon, 19 Dec 2022 07:36:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/net: ensure compat import handlers clear free_iov
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jiri Slaby <jirislaby@gmail.com>
Content-Language: en-US
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

v2: let's play it a bit safer and just always clear at the top rather
    in the individual cases.

diff --git a/io_uring/net.c b/io_uring/net.c
index 5229976cb582..f76b688f476e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -494,6 +494,7 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		compat_ssize_t clen;
 
+		iomsg->free_iov = NULL;
 		if (msg.msg_iovlen == 0) {
 			sr->len = 0;
 		} else if (msg.msg_iovlen > 1) {

-- 
Jens Axboe

