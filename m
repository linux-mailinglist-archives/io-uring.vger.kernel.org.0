Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D2A510E6D
	for <lists+io-uring@lfdr.de>; Wed, 27 Apr 2022 04:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356992AbiD0B5n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 21:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356998AbiD0B5m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 21:57:42 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C14F1759E3
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 18:54:32 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id i24so359351pfa.7
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 18:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fOM7HQQjEBs78pDV8t8hUmJzke7jQ1ddVj+W8qa45kI=;
        b=gSYTvVuDjLSB6gked5o6M9viFoTWbDD7UPTSDLE0chucwzu510k4Ti4Gwy7lC+G8bw
         VMGpbngPfyx2BLHl/lLvAYKSWr2/UlOtUzv3QT+ui8JkcLtc0MAu89OryyJR2+S3LuAc
         VjopH+l++ETIPUncv+XDjeEfwqFcXt23lVzJntGv0rKMAdMA4axDUl3mEXsuk6jHkNeZ
         03dqY1YomUnst91ovT9IP8j1LOy3j+OlfnD+zZtl0p47KJYxHDBoHJlyFjL4eoFnRdvd
         4B+W6blFkn9EbOUzEZclowx8UbYXsGC1/qAU3JX/u5HetVYeSjyNMSb3bKj1rKtEjJHx
         oSgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fOM7HQQjEBs78pDV8t8hUmJzke7jQ1ddVj+W8qa45kI=;
        b=SNH/A0JKL57/cjj2a6fyaVF+tItDwlaLuF/2JbSNDX9tPV+lW8RmKH/3TWSi3MN4/K
         /yZWNoV5MSVaTMhum14Kd2tdoL6+fxStMt8DPa1uzn8ymbGjt1ewVcprluWcmUpLV31Z
         B0aJIlRq2oJUrkyA0pi0Iifwf+99YmHgGYo5ijFfdTGk3Fc2F05A3Usx37xbA+cia+Cr
         fBWuUmajBMA8QbdmjAHEQoSeLH/8v8rqwRZ2+tfnJqbkcoGYx2ieUFX1QRqjU4fcOD/f
         oC3G8x7PK7n9oqtiQdhV9VZt+sNNCOuEexv/6AzQimY7m9/eoS12xoafaTG8tlE80S+g
         EtDA==
X-Gm-Message-State: AOAM531ea7qxqP8KeAkiikTC3m74jQwdPZhbgnFvyT5kgJizLSysh3gU
        8bSRkqGzk3m4Zh5ChlF0p5E5XnBoyMdYZUr1
X-Google-Smtp-Source: ABdhPJwnoz+CRW7LE4DvfNeYGYkUj7Mxe1DuWmkgK/xCL3wOY8ww++W1pBxcEozBcdp6CJAqkhI28Q==
X-Received: by 2002:a65:418b:0:b0:382:250b:4dda with SMTP id a11-20020a65418b000000b00382250b4ddamr22407137pgq.428.1651024471548;
        Tue, 26 Apr 2022 18:54:31 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p185-20020a62d0c2000000b0050d1f7c515esm13194998pfg.219.2022.04.26.18.54.30
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 18:54:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Add support for IORING_RECVSEND_POLL_FIRST
Date:   Tue, 26 Apr 2022 19:54:26 -0600
Message-Id: <20220427015428.322496-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I had a re-think on the flags2 addition [1] that was posted earlier
today, and I don't really like the fact that flags2 then can't work
with ioprio for read/write etc. We might also want to extend the
ioprio field for other types of IO in the future.

So rather than do that, do a simpler approach and just add an io_uring
specific flag set for send/recv and friends. This then allow setting
IORING_RECVSEND_POLL_FIRST in sqe->addr2 for those, and if set, io_uring
will arm poll first rather than attempt a send/recv operation.

[1] https://lore.kernel.org/io-uring/20220426183343.150273-1-axboe@kernel.dk/

-- 
Jens Axboe


