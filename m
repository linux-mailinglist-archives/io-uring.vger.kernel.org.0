Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7657CFA37
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 15:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345779AbjJSNC0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Oct 2023 09:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbjJSNCR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Oct 2023 09:02:17 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286516EA0
        for <io-uring@vger.kernel.org>; Thu, 19 Oct 2023 06:01:29 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-79fab2caf70so69983239f.1
        for <io-uring@vger.kernel.org>; Thu, 19 Oct 2023 06:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697720487; x=1698325287; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pG3rynEGwYqH3CMUWHGTYB5p02H0+uBp6/zRGHa85uY=;
        b=npfcnMakid1ce+/YaF09VqrHQCB/zue7Xim+/0Ir/wFOSJu35MUTRsGKs7AWE6ubSx
         tTsKAqZSqqNbHcxkwjOwINkbj7ABTgIW1jewgMOHBFFgB7wO8kPNpY7/+rNEcbh5lcnO
         lD2o+fzYe1wi13xdZFerWQ00+WBrQn6+LNG7VfZ22/Om0nq+6VcsIja+usDA1LYSjQhT
         iJPnyCWlDnpbNtKHhZw6cUcEr8Ix/R2Zu0e+XwmhMHBb2+Nh+Ayl1EjfXg7cq8NfHHL9
         5QaThsZhk+TUV4as2QUher4z6eWs1glpHX2AfVQy+RKKdBmNEsBefTfp4d/EwS2eUzKc
         QHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697720487; x=1698325287;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pG3rynEGwYqH3CMUWHGTYB5p02H0+uBp6/zRGHa85uY=;
        b=d9KIrCqIZi1tPPc1fqKCbNOXjS+uBydHvcmRb787SkfuSmL3eg2XdV7rjySAjSbwUp
         6UPeWiU6IOjw99gppTEZ+h+YATSEAARO7IiynQDycD5VS/NPm127efSKKgkulLLzJ2v2
         65myR8mL6AnXO/BiTUwHSGcQWZprRyMbzWPBssnnLlUuw5pBNiSIgoX7UFpF/FF7XTAq
         tO7rGMDjHuqJgP9exgjgO038wXmOtdDXM2lz+qmCfi9rF8IpDB3xEdtEo72rDclkVHHQ
         IdcdVBdYyHfigSTLEWCIRgtB+JO7LXADqtLOx+7MnRLL2HwofkQEmhzyhDHrKWnlbez/
         XmpQ==
X-Gm-Message-State: AOJu0Yxy+oCcjYR/UrQNIzyWlBLTlHljH77b4qqyRRx6iHjiHinNfJcP
        1TiLNSsZobNyXQ6iHg6dgf+9+PsEo4xQQHUn5ZTsjw==
X-Google-Smtp-Source: AGHT+IHbDoUwOM4L+vUfE7wjfVwFryAH3von/T6K+kAdC0US6DRJlSyIPLPVKTztL8n/qisCXxDbwA==
X-Received: by 2002:a92:d2ca:0:b0:34f:a4f0:4fc4 with SMTP id w10-20020a92d2ca000000b0034fa4f04fc4mr2326108ilg.2.1697720487517;
        Thu, 19 Oct 2023 06:01:27 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id k9-20020aa790c9000000b006be047268d5sm5223820pfk.174.2023.10.19.06.01.26
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Oct 2023 06:01:26 -0700 (PDT)
Message-ID: <e6bcdcb4-8a3d-48a1-8301-623cd30430e6@kernel.dk>
Date:   Thu, 19 Oct 2023 07:01:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/poll: use IOU_F_TWQ_LAZY_WAKE for wakeups
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

With poll triggered retries, each event trigger will cause a task_work
item to be added for processing. If the ring is setup with
IORING_SETUP_DEFER_TASKRUN and a task is waiting on multiple events to
complete, any task_work addition will wake the task for processing these
items. This can cause more context switches than we would like, if the
application is deliberately waiting on multiple items to increase
efficiency.

For example, if an application has receive multishot armed for sockets
and wants to wait for N to complete within M usec of time, we should not
be waking up and processing these items until we have all the events we
asked for. By switching the poll trigger to lazy wake, we'll process
them when they are all ready, in one swoop, rather than wake multiple
times only to process one and then go back to sleep.

At some point we probably want to look at just making the lazy wake
the default, but for now, let's just selectively enable it where it
makes sense.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 4c360ba8793a..d38d05edb4fa 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -370,7 +370,7 @@ static void __io_poll_execute(struct io_kiocb *req, int mask)
 	req->io_task_work.func = io_poll_task_func;
 
 	trace_io_uring_task_add(req, mask);
-	io_req_task_work_add(req);
+	__io_req_task_work_add(req, IOU_F_TWQ_LAZY_WAKE);
 }
 
 static inline void io_poll_execute(struct io_kiocb *req, int res)

-- 
Jens Axboe

