Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A56B7377A7
	for <lists+io-uring@lfdr.de>; Wed, 21 Jun 2023 00:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjFTWzU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 18:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjFTWzN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 18:55:13 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4EE1727
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 15:55:07 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-54f73ef19e5so536788a12.0
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 15:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687301706; x=1689893706;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GHeaLUt3EIwgYeyxLihft+4Yu1FECCx6eG9he9+CmUg=;
        b=vUf/fDP8uV38DPE8XwPPyogt+TlrJwq3zkwP+6i8h42MLu1A2aM7B6KpdasbjeOI/Y
         fMkCSeuJZh776kUxPUlR4j188R5MY/gdognUdlQwbpAI/mejs5lpbR3gGHXlZbiQCvEV
         G1RRdyK40HmkSWfxiXedO5InaTwpn0cDWEl2tpz7wU7mEZYIQJ+RFeJ53la5n52VvMII
         mhoki9sqo1cj6yGYrHnIDmBFl1pEjMOA1Yh3umv9NJ83F5nLDgl3ypweYPV595o/sJ+A
         6LiDNSd2ts4vWXsRKEe/VkPLnKJNORoU5LBsdSIHREtSQUQucJEaP8OOotxk9sI0arJr
         g/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687301706; x=1689893706;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GHeaLUt3EIwgYeyxLihft+4Yu1FECCx6eG9he9+CmUg=;
        b=krjH/K0zO5iyb/Bt1nbFSC5bj7IE7z3+InR4FoTF+ihF55JPgDJpgo3owVd+6Iq/QM
         cJtW5WQmaVJLUFAeOYG+R0NwpoARfNB60T5dmkv/JthxsKh2sP5VULlLqRg7sdL8QTw+
         bEGE2EDNOpHoVq0WPwXoEh1mD8HWoT6vKyQKxg29VjFMTb5B9ygPHd7KSuwt0FGRqIii
         vLeeDw0hNoGMIhyp1YLTACQT7BH/nWMbyAMAsVjVovO47KEBy649jTDqfoGZ75XQ3uV8
         hD8nL/fCpolUiSu0dGvVJ3R+1WHKv/IIWXD0agDCOtL2SgQPq6pbJ3RUE64Qmqi+F7sF
         kzqw==
X-Gm-Message-State: AC+VfDwdaWv66W8zGE3/E7vOU9ZcuSNZdXIEopWExN1ENp70Jaai8u1E
        w/rRu7+vIoHnCYy0ybeLBkOptCfmwHc6/+oDXKY=
X-Google-Smtp-Source: ACHHUZ5kWX1f9fGBkrqDpU0iX21PnkwiLNrUYVpuWH7U98ki7wBFY9i39JZY4jBgJeun0zIvU5mN/w==
X-Received: by 2002:a17:90b:4b4c:b0:23b:4bce:97de with SMTP id mi12-20020a17090b4b4c00b0023b4bce97demr16542700pjb.4.1687301706529;
        Tue, 20 Jun 2023 15:55:06 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e30-20020a17090a6fa100b002567501040csm8250141pjk.42.2023.06.20.15.55.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 15:55:05 -0700 (PDT)
Message-ID: <222f3e9e-62a4-a57d-b14c-c8e9185ca1ae@kernel.dk>
Date:   Tue, 20 Jun 2023 16:55:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: silence sparse warnings on address space
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rather than assign the user pointer to msghdr->msg_control, assign it
to msghdr->msg_control_user to make sparse happy. They are in a union
so the end result is the same, but let's avoid new sparse warnings and
squash this one.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306210654.mDMcyMuB-lkp@intel.com/
Fixes: cac9e4418f4c ("io_uring/net: save msghdr->msg_control for retries")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 2bc2cb2f4d6c..c8a4b2ac00f7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -203,7 +203,7 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 	ret = sendmsg_copy_msghdr(&iomsg->msg, sr->umsg, sr->msg_flags,
 					&iomsg->free_iov);
 	/* save msg_control as sys_sendmsg() overwrites it */
-	sr->msg_control = iomsg->msg.msg_control;
+	sr->msg_control = iomsg->msg.msg_control_user;
 	return ret;
 }
 
@@ -302,7 +302,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
-		kmsg->msg.msg_control = sr->msg_control;
+		kmsg->msg.msg_control_user = sr->msg_control;
 	} else {
 		ret = io_sendmsg_copy_hdr(req, &iomsg);
 		if (ret)

-- 
Jens Axboe

