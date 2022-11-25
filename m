Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862C2638EA0
	for <lists+io-uring@lfdr.de>; Fri, 25 Nov 2022 17:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiKYQvx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Nov 2022 11:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiKYQvv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Nov 2022 11:51:51 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14492E07
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 08:51:50 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id b21so4451604plc.9
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 08:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vst8M8SBbRKVZBq0VGsiyUhXqg6jEIxiOhJW5JmMT0Y=;
        b=qFBfzmRnbnJKl2pW4fAknSXjEMPBjRLvh3QvP2E0eeAdNc2l5gXAE1tBIgA12LW6CQ
         EeE+fc3heRBI7qwPg+mIHIr7AMcA4F7kx1lcooHvzddonzdjMSGwcTfel5IojmtdEGdj
         lo+Ih4Q8bICvNR2WdKpdXa43+kWTlylJHwTrbTHMusPcuQrwK5YH/TLDzEtQslQB7Hpz
         4Ko6xYDC8SbNgzbKxKxa70AjpyITpI+REKGPJe5WRud2k3F6wT3oZAQJS156P3Vf7Ip4
         b+DVm+UkKMQuqQwuf+5/43A6S4JvTyvVRy2Zz8rLh9z7bDma5m19vz9UzqPTguw8Flmf
         QTtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Vst8M8SBbRKVZBq0VGsiyUhXqg6jEIxiOhJW5JmMT0Y=;
        b=blamSeKVB/vfUgkWmBDa7UrOxFcW6dYL37++8EMRdj6W4hQe8jCkT3K1fMiSJMX4qE
         GTJFFs8g/r5nqQn5VmXL5vWpvxFra2EyJZmOl7fVsmJmbZaZBbURnWePAjkuPUVHjDs2
         J8xGK1T5mT2LHoSKNMW9c7CLnHD/TULBkvM9xy0Yd1NGqki/ceZFZmg5z1dIeuI27Yta
         oNvysX9n9HpouF6NW9kY9J4F4ltB6kpazh+aEs5zaexlj+C7SaBzgHckFyM0K/pqJsrC
         1k3LPqoGzzQO5lDa8eI4OYTW8UaZ/Y8tgI40YMNSgjVW2ZjeshPWuU+QTUlhkxeTmWDd
         2qPA==
X-Gm-Message-State: ANoB5pmYEdGpLfz+/rj2zK/C6daVdc5Of0Sc73l1U6v8asB2aQDhlZVx
        aaetMvh+xkBXMmfookxsdO8SWOtnyMi4AzGr
X-Google-Smtp-Source: AA0mqf5P8KYIz8arDDVVGW40Xvn6gO2ln73OESQbtHIQdZAcj6gb/orJxAyikhojJthhQ5FWwdrW2A==
X-Received: by 2002:a17:902:cf4c:b0:189:68ed:96b0 with SMTP id e12-20020a170902cf4c00b0018968ed96b0mr3255540plg.92.1669395109297;
        Fri, 25 Nov 2022 08:51:49 -0800 (PST)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id q23-20020aa78437000000b00574679561b9sm3300179pfn.63.2022.11.25.08.51.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 08:51:48 -0800 (PST)
Message-ID: <93a72543-80b9-7412-61f9-9c28be9ec18e@kernel.dk>
Date:   Fri, 25 Nov 2022 09:51:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: clear TIF_NOTIFY_SIGNAL if set and task_work not
 available
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

If we have io-wq or SQPOLL setting the task_work notify signal but the
task itself doesn't have task_work to process, we don't clear the
flag and hence will enter a repeated check loop if we're waiting on
events or file/buf references to go away.

This was introduced in a recent patch which eliminated gating the
task_work run on just that flag, but that fix meant that we know don't
clear the flag if the task itsel doesn't have task_work to run.

Cc: stable@vger.kernel.org
Fixes: 46a525e199e4 ("io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

V2
	- Add comment
	- Keep the clear-if-set logic, just move it outside the tw check

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index cef5ff924e63..a70f8ec88bf3 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -238,9 +238,16 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 
 static inline int io_run_task_work(void)
 {
+	/*
+	 * Always check-and-clear the task_work notification signal. The
+	 * current task may have it set if io-wq or SQPOLL sets it, but not
+	 * have any task_work itself. This can prevent the current task from
+	 * waiting on events efficiently, as interruptible sleeps will turn
+	 * into busy loops.
+	 */
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+		clear_notify_signal();
 	if (task_work_pending(current)) {
-		if (test_thread_flag(TIF_NOTIFY_SIGNAL))
-			clear_notify_signal();
 		__set_current_state(TASK_RUNNING);
 		task_work_run();
 		return 1;

-- 
Jens Axboe
