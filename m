Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC75E52AAF9
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 20:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242960AbiEQSe7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 14:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347597AbiEQSe6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 14:34:58 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569523DA6C
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 11:34:57 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id q203so4411663iod.0
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 11:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=oYjqVxRZ3ltOeYUv1oo6iFDPZZtBNg7qC5+jacW8bpg=;
        b=RKQWbekm185Py7wSzoJq+iq9fYCzuA/DeI4AZj5BZU9eAkjG+v24tneRYia9NP5QwZ
         dvQSVxCFsSBRiSjqRPr2sP7SlAcTlbWHKiV3qi0TIfZYq/+8Dcg91DfnilfBUkhIjxnP
         tGCO+No7VltVqtkji0PIbK4H1H6PpzMYezYUofKwAQVdP9GdcvhpKyUIe3NzhtdsCcFT
         9t2xBbgT6MfyL+UqPuCi1Yiav/HM3WYU0N7Snnb32R9113ZTbnqKMVcjkZUt1JMmaAZX
         kATtE+inuKa3LG56tpAbaS33oYF+Ng4K3bOX84i+hjBkUlxBN16/vJoSFiUVPZurbMfh
         V0Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=oYjqVxRZ3ltOeYUv1oo6iFDPZZtBNg7qC5+jacW8bpg=;
        b=u52A+kGyJv4P6RBLt6vSdq8IGcQusQsLm7+wmuvr6Q7VC/mWdMhrjD6QqvJIo/FirF
         k/paABU0xh9YYsrves6JyQC+qsHWeq9LofyjWkN9lASYbOa+bQSsTIuY6xN12TfKqcY5
         KULEWuJ5xClCip94eqBcGj/Qo+swDbdlWnqvw17ar+fBDbAwrrZ12K3odXF5wzDoTz9m
         SMLlqMGHR+xejvESY2sTJxVt17i2L5LHpyHVAsinsiTdVrj+Og/1MCwkKKcVhSn+Tbbx
         x2Mf/GjnYrTOd/rQDHc7NANg4uwN1zzp9zN/dqn9X7XLYakhXxjsEOJheHvRPVW00a7T
         3KRQ==
X-Gm-Message-State: AOAM532iBuiPALczN67Kpjpu+PEhVP8ZquIFSJSUkBgIEJ6J5ktjNW6q
        IhcjpqA3flOx+0bnka/gpQm+c0AYLOoWmQ==
X-Google-Smtp-Source: ABdhPJx6h/tV97Kd5fzCdvkNOjpXUpmq/CcW4JBKwPurVeAjTZKsTX9FqXmrmUzrPeap7/um7l462Q==
X-Received: by 2002:a05:6638:4123:b0:32e:52ae:e8c9 with SMTP id ay35-20020a056638412300b0032e52aee8c9mr2948492jab.26.1652812496199;
        Tue, 17 May 2022 11:34:56 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t8-20020a056e02060800b002d10f043761sm6230ils.36.2022.05.17.11.34.54
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 11:34:55 -0700 (PDT)
Message-ID: <38094d23-9f0d-d257-1adc-79f50501b3cd@kernel.dk>
Date:   Tue, 17 May 2022 12:34:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't attempt to IOPOLL for MSG_RING requests
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

We gate whether to IOPOLL for a request on whether the opcode is allowed
on a ring setup for IOPOLL and if it's got a file assigned. MSG_RING
is the only one that allows a file yet isn't pollable, it's merely
supported to allow communication on an IOPOLL ring, not because we can
poll for completion of it.

Put the assigned file early and clear it, so we don't attempt to poll
for it.

Reported-by: syzbot+1a0a53300ce782f8b3ad@syzkaller.appspotmail.com
Fixes: 3f1d52abf098 ("io_uring: defer msg-ring file validity check until command issue")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91de361ea9ab..3cb0bc68d822 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5007,6 +5007,9 @@ static int io_fadvise(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, 0);
+	/* put file to avoid an attempt to IOPOLL the req */
+	io_put_file(req->file);
+	req->file = NULL;
 	return 0;
 }
 
-- 
Jens Axboe

