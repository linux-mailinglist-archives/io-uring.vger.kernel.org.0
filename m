Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55EE68C13F
	for <lists+io-uring@lfdr.de>; Mon,  6 Feb 2023 16:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjBFPZg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Feb 2023 10:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBFPZf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Feb 2023 10:25:35 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456B2298C0
        for <io-uring@vger.kernel.org>; Mon,  6 Feb 2023 07:25:07 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id j4so4561035iog.8
        for <io-uring@vger.kernel.org>; Mon, 06 Feb 2023 07:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6nyV1QLKTQOLRV/YssXHrxR2lRwzNmT4gJ4pkh6L0I0=;
        b=dHGvs5+ALaoX3wX/+V1JvCSRyxOsRN6u4mZHVNs14B90b+7lccMGP1g3kbpZABokzC
         rMydvA2DJbtaawvKVhwWFx2yt/BmXDSKLMsVhlrcxS+g4ZyvcwIhZNz54eeTk5nUQ9PZ
         ux1yEbl+p2Goyg+bNoJnyrycy+NFunVpXXbPi2xJZmOCmBOcHK+0ika26IOkuMkpPHaW
         lFvvp/YKdP7NdM+OjEIVwpfhJnF+cdfVy6jIs9EO/WEyHZs/8sJCFRAwkX7Iansliz/J
         t/+7bhDQ7gmUAdTZ6ODMY9Vr6w9n1ZAqdvG3C3zv25OsU1wvMBYtYc/Dcjc/wVuOIr2v
         QRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6nyV1QLKTQOLRV/YssXHrxR2lRwzNmT4gJ4pkh6L0I0=;
        b=VE5zYbtP5X1bwOnCyolM2aoWDe0qR8KRKr2Kyc2+lxf5FRj0C2URGJhzzL9S+sM3Sy
         nwOSbkag51hUV7oS8Kqst+qqxCtZGir6V/DxAPLEnjDDH6NcDp2crIudSTZPvWzyz3TN
         1idv2l4Pvn1DT69RaO+6YSB+bPCV1Q+DgW+tD9CQ2cKjBdF7yJ9C6UWz30I5gdCa91aw
         7bk9lgHB3d4xa6dG545mBPTmO45F6Bi455oVWnBonfBf915APiZLqWUsFFxb/un25hST
         7L/+l0cjRIbDSWvI+gNbg3ecz3XlQQE9C/c1xEZkDTkmF/jegO/0o9et+89F+BXW+NG/
         JxrQ==
X-Gm-Message-State: AO0yUKW8Ppo2+59ozX5MBFfoQvlI/t0RNsuI63pol9FgHWEIXx4Tro3z
        SWvws+06CgbH0nYt/W9hgoscJUjJCYVOieFB
X-Google-Smtp-Source: AK7set8fpDQbdEY7PA//wVY42KFLWwmzUh0x2DjrQ+SESNwqjgfJSMBCei9WkKueKwsCNCaJyMG3VQ==
X-Received: by 2002:a05:6602:2acd:b0:6cc:8b29:9a73 with SMTP id m13-20020a0566022acd00b006cc8b299a73mr13665185iov.1.1675697105932;
        Mon, 06 Feb 2023 07:25:05 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f7-20020a02a807000000b003a7dc5a032csm3600761jaj.145.2023.02.06.07.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 07:25:05 -0800 (PST)
Message-ID: <fdbc0707-ace4-d565-402a-4927fe0b9947@kernel.dk>
Date:   Mon, 6 Feb 2023 08:25:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring: mark task TASK_RUNNING before handling
 resume/task work
To:     io-uring <io-uring@vger.kernel.org>
Cc:     kernel test robot <oliver.sang@intel.com>
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

Just like for task_work, set the task mode to TASK_RUNNING before doing
any potential resume work. We're not holding any locks at this point,
but we may have already set the task state to TASK_INTERRUPTIBLE in
preparation for going to sleep waiting for events. Ensure that we set it
back to TASK_RUNNING if we have work to process, to avoid warnings on
calling blocking operations with !TASK_RUNNING.

Fixes: b5d3ae202fbf ("io_uring: handle TIF_NOTIFY_RESUME when checking for task_work")
Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/oe-lkp/202302062208.24d3e563-oliver.sang@intel.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index f90816aac896..2711865f1e19 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -281,8 +281,10 @@ static inline int io_run_task_work(void)
 	 * notify work that needs processing.
 	 */
 	if (current->flags & PF_IO_WORKER &&
-	    test_thread_flag(TIF_NOTIFY_RESUME))
+	    test_thread_flag(TIF_NOTIFY_RESUME)) {
+		__set_current_state(TASK_RUNNING);
 		resume_user_mode_work(NULL);
+	}
 	if (task_work_pending(current)) {
 		__set_current_state(TASK_RUNNING);
 		task_work_run();

-- 
Jens Axboe
