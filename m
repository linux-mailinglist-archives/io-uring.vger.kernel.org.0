Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7265EE121
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 18:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbiI1QAB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 12:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbiI1P71 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 11:59:27 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD20BDF071
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 08:59:26 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so2078756pjh.3
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 08:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=DCckozSD+DRbPbiG0B8/d+bbMjSxope0/gjSlkpTyB8=;
        b=eqFuUjb/ijbDH8kYe7RCXg9Da3w3KRwfCjOffLT3NpA0a/ujgWw4lTXfGy7t8B0xXz
         Rsp2vwcsQBOkksiMcWnkM3WurnJuOQ4VoJW65mY1GQNL55w5y3lzj6HmlsISpspEwafO
         p37BqfZOJGJ0bzDzoKinVgN+ymRaAId1IZIaGSrkKXurjUaBMAsn2z5Bn5ZE6BkT7dYu
         R/5hc9fmUC/Fi/KldFUu7uuW11Ln3EmizAGn7ApSEYpHoRVtsO5/zmWyIcWIp9t5TJ1x
         Q9vT++wgDd3XHsbd+sUSUCNsR4tO4A2y0TOP+0lTjWjdqvVGJ7N8qqgAiN/Qa+CiBBy4
         LL+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=DCckozSD+DRbPbiG0B8/d+bbMjSxope0/gjSlkpTyB8=;
        b=q84XNTt3RpRmndYJHWNsgR2eJO8diZwe3Bl5hedEmFzIW50hX4qGf1QjeYWWpKA3DY
         b0F8+oWfQ9TElkEFBW9ZgrbW8G5xM0l8IKbFCWsT9uQHSu2T69pLTtOJD8zpYC6abi2h
         YZOkzvBq8oa/pd7iLBGVxnanOHwSaZ0k4T8q6ZX9fSGIvUq9O+D7FdbrDWxuDhdTo5Md
         NYmRm3NBg7WZPFywsxYAdjyLynJH2RptU53sqku37XFeE6ErbfLkrwhNWpNHqLuxPNFw
         mt9t/75MJ/tBFE1fyLpSz5JO1TX+EwNJ6bMa7SlOwEU+ojfDEzzVjkQJqGrC4Rqxaf6n
         sG9w==
X-Gm-Message-State: ACrzQf0N0rfoSsl84W16x8C7mlwiAlEVg3ri8S21Sss8OggTB1fww0Ec
        pgq2AkXFT/2/AihfvbhjRdWezBuit8DhuQ==
X-Google-Smtp-Source: AMsMyM5LMpwFuTr/XjnTzH1K/WLz0760AzPIAertMhg53w/gOPl2OIVXOVRgos2T9iM4rvsUn3p2uA==
X-Received: by 2002:a17:90b:1b4f:b0:202:b066:322 with SMTP id nv15-20020a17090b1b4f00b00202b0660322mr10838764pjb.226.1664380765704;
        Wed, 28 Sep 2022 08:59:25 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a9-20020a656049000000b0043bed49f31fsm3709306pgp.8.2022.09.28.08.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 08:59:25 -0700 (PDT)
Message-ID: <68178467-39c2-adb9-0358-4587ef01cf4a@kernel.dk>
Date:   Wed, 28 Sep 2022 09:59:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Stefan Metzmacher <metze@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/poll: disable level triggered poll
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

Stefan reports that there are issues with the level triggered
notification. Since we're late in the cycle, and it was introduced for
the 6.0 release, just disable it at prep time and we can bring this
back when Samba is happy with it.

Reported-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/poll.c b/io_uring/poll.c
index d5bad0bea6e4..0d9f49c575e0 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -857,7 +857,7 @@ int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (sqe->buf_index || sqe->off || sqe->addr)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->len);
-	if (flags & ~(IORING_POLL_ADD_MULTI|IORING_POLL_ADD_LEVEL))
+	if (flags & ~IORING_POLL_ADD_MULTI)
 		return -EINVAL;
 	if ((flags & IORING_POLL_ADD_MULTI) && (req->flags & REQ_F_CQE_SKIP))
 		return -EINVAL;

-- 
Jens Axboe
