Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB6C4EB488
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 22:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiC2UQB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 16:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiC2UP7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 16:15:59 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EFDE5404
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 13:14:16 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id r2so22339414iod.9
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 13:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4jdnL0gXoi/owgf5xi8l1beIdJN4vMpZzAaag1MdyKU=;
        b=0rXxt5zY3INalhmkwUpskXJoH57gCLCnDtkhdwZpJUCmNxPGlCddvi7PfBd6ygWpP2
         8W4pU3gxHjlqiKejfQUgjVMvTMeUQB8SK0zwd4VoEzTljHusSqZwyE/35VTF/Cd/25HY
         Mf8nOywh9hsn+kQuPPfj50NlYInabJpvptghurrRUTGAdeFLm+RvzqmQqIxSn+Ujxwge
         aa/vSGX+p9d9EvgDqciHqUBYyeqOJuoGdJQMUzgUXFYXfOwKtaYtTG/1J2tD5tlI9mJz
         ZRCR6QwklCdvrwoPZ3WDyC0EF4h0uzwwTdCb3t+o5+J2FLzUKw9lvQiEQ9t9hfaCnE4e
         Pnzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4jdnL0gXoi/owgf5xi8l1beIdJN4vMpZzAaag1MdyKU=;
        b=tfcJqCSMN9tT1CeqPAi6VhORqAygIFSjO7CSZDmCnnLbfALyi6p8SZc8YAyRiGEmys
         kdzuymob56rrsbMeLSEHwjpTHJDkBecM+QbvroqQyxwTBxgnCBmUkMpiiLkGjnoDiX8n
         JJo5ud2iQL5X6VuI0ZArCDXBQqkP43X23j7sJQ5ydUG9ZudcIvWXixiKaXeV+cRGNZJG
         Re2oW4pgbHSTlHzF4Fk5cui7ly2+K+auw9SouGOuhEc1lfw5MOeBWKbrayJ6ZxrUXNl8
         fydtHzOwgLypV8ATiQ6N9gn4qfEWvgRwZ1WaAW3oV93ndi5pkO0xmBq0kDZwoIvibdYj
         9rHQ==
X-Gm-Message-State: AOAM533FftfXn+LMhmAi6KztxfvwXFO9jJlkTnMAyb2dQ8z8nFewWVxC
        YKBslHdhqUlo6F2UKfNV4cuBQLsQSKt6oq26
X-Google-Smtp-Source: ABdhPJxF1A7SmsqEKCiyPayznKY4X9KeioHhzhAr4YTMFk2LJua65vfVwOLwj88SPJ63Nsn2tkU9OA==
X-Received: by 2002:a05:6602:2c51:b0:649:e9a8:d1d3 with SMTP id x17-20020a0566022c5100b00649e9a8d1d3mr9937554iov.82.1648584855422;
        Tue, 29 Mar 2022 13:14:15 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v3-20020a5d9483000000b00640d3d4acabsm9606316ioj.44.2022.03.29.13.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 13:14:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCHSET v2 0/4] Fix early file assignment for links or drain
Date:   Tue, 29 Mar 2022 14:14:09 -0600
Message-Id: <20220329201413.73871-1-axboe@kernel.dk>
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

Most of this is prep patches, but the purpose is to make sure that we
treat file assignment for links appropriately. If not, then we cannot
use direct open/accept with links while avoiding separate submit+wait
cycles.

v2:
- Ensure we properly handle defer for async and drain
- Drop unrelated msg-ring fixup patch

-- 
Jens Axboe


