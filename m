Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE36F5ABAF4
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 01:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiIBXA7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 19:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIBXA6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 19:00:58 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44236E8301
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 16:00:56 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x23so3227274pll.7
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 16:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=0G2AcQfAYBuIdwv/WO5Xpy6DI9yPS7nh9r3zVSGPqsw=;
        b=ZzvUmaQ4WRE2h14V8HX/UBWkKV04ImKgWAwoqB5xMsGGlcrTrmm+5c42fmzuw2lTGu
         dynYAXAVbFb1Pj+JEFygEb9Z3clQsfeADCyWdKzTvNBzv83iQsoAM+/tyBe5Vq0DzYdD
         t9H3lJ1jhaEy4kPPTfzmP0p/xV3zduL6OsJa/hab3Ucb1Svk3jDHU5SXyDUHLmHLRBK1
         6XGYaSDees7kGuCQAQqSJW7npMh8khTEY3Kq3vnl5dK2hfKCi0Ise+qm7laYCDg3R+Ei
         2YZNHhqD3uI/k9A/fqkX7S+xpU2RypxvSrqim5+W5Bz1yUNKRTGX3YIkft+i4pLmBaXo
         Pk4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=0G2AcQfAYBuIdwv/WO5Xpy6DI9yPS7nh9r3zVSGPqsw=;
        b=6p+JeucjMohsiXDNP8nXFKUMODsbkSY6kQa/HAqJUh5sC1kdFjjuOSfFetKHPcvTTP
         Mu89e+E9pPHkzGOQa9URWvYx8Cg3T4WXANKNU3DFPlH9Tvz5YoLncSIhwHqLLjXTdVGK
         s/N0JgyGx28QveOCyxmqiYhVELJzOOlbWWj1fUEPp8Dik5khGjlnWYY3gkcUZIYNHYBi
         dvQEiWCRnKxM9Z+8YIHlmNwkvQAkvPNmlMb8yYZOyAlqi+t79P7GjljZ8vbLrBeVNm5l
         NJz/grGxGCar7pbk91526v2HL/LvTE+ntc+o2V8jb5IpAHzXwomDdhnaypAi4oy2tvYM
         ItIw==
X-Gm-Message-State: ACgBeo0ZSeJ9lnzPTcyA7+mWmXuVBYWEXDtUNsuzYPHAMlN9/mbnVYA2
        P8ZZcnFsBYOTN3v7/nOVGFgj6wJnSiObGQ==
X-Google-Smtp-Source: AA6agR6BUT28n0mKHqZGk0H5kh/TBFVIk9bPpJ3LhzghmoGAJ6NsTB0G8Ix0N64DWQxA3JstiM9/jQ==
X-Received: by 2002:a17:902:f78d:b0:174:f7aa:921b with SMTP id q13-20020a170902f78d00b00174f7aa921bmr22212537pln.37.1662159655373;
        Fri, 02 Sep 2022 16:00:55 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c10c00b0016c5306917fsm2202104pli.53.2022.09.02.16.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 16:00:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com
Subject: [PATCHSET 0/3] Fixups/improvements for iopoll passthrough
Date:   Fri,  2 Sep 2022 17:00:49 -0600
Message-Id: <20220902230052.275835-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

A mix of cleanups and fixes for the passthrough iopoll support.

1) Cleanup the io_uring iopoll checking, making sure we never mix
   types.

2) Use a separate handler for the uring_cmd completion. This fixes
   a hang with iopoll passthrough and no poll queues.

3) Let's not add an ->uring_cmd_iopoll() handler with a type we know
   we have to change, once we support batching. And more importantly,
   pass in the poll flags.

-- 
Jens Axboe


