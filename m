Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76A44ECA5A
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 19:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245707AbiC3RQG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 13:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244733AbiC3RQG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 13:16:06 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2AE13F8C
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 10:14:20 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id d3so14972179ilr.10
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 10:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2UkUupH5oLEEbu8160bqmsw4/SLY7Dm6ghy/kSBDtFg=;
        b=q4s8cGUtw0cyEpMhPoHoSsN0KLg3x90viOofpccCRwuLtfr6pNwJki31fRQXraQPRz
         EqYQlsZvdnAkdPrUodtQHuk5FvfxZBEhAdnSAm+w22nNTfzMZ6PQbEylgCcrv7IT8qyI
         gZd2Z9EwDIDO+pJwVYdF1XKHnNtUfK7NB4I7tWekiWmrh/Qhe9F3gQuJTr6UQ9uK3tn+
         aE3jZ7kf/66NBFkhV+rn6kHq+NLd38sPLHZyxwogKwskqbC1aVj7e69klB7W6PVtFZxa
         y2hEbmbSAOMcaBRo2AI3BJL0E6Pi/TViZo6bTsmSD9kRac8feT9ievyPBCxkfCeV3lpO
         FsSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2UkUupH5oLEEbu8160bqmsw4/SLY7Dm6ghy/kSBDtFg=;
        b=w7Vqg62GM0jPcponuKMkrHN92ANkO5JMfDJE0tqMqH5LzrXiTPxufU+x+ciU1PkcXi
         Sr1r/LdbiNcVvS4QDatk+rtJjCWY0gbSaeE/VMQ4irbQrpmd0abVDnZ8nz37JC3QqmWT
         FtfXPq0lMEmYqOdnn5s2lPNT43FxKy5s5FvXxOzqUmc35ydW5It6pv0fokDvEAAAb/e1
         ObOsbOHo7YFiwmvvXSS7lIXKwYcVkvu/y+GEY1btkjmFJhh3LnujxuUi+Z2w1Mcso1Fy
         cwQ9TgmQLBujSY5RIVkSy5li/JPKX7hfn+bf0WohzVAaRzY7zeWd53nXJS3nvu/N8nBJ
         2DsQ==
X-Gm-Message-State: AOAM530QfQe0xOcjA2CZQ4W7GcR+QQy6m+A+SX3VMslQ00X0yRHtzLoK
        s8vm9gyWTRsDiD4kPWpfZ6lyDxLDcuPIEBhO
X-Google-Smtp-Source: ABdhPJzxd/6heQBZvSbOF1X333VfSU07ipKrpy7BFyPAJH9JCzwvJVP6vMl6hMnUk8EVkg2rfa7Gig==
X-Received: by 2002:a05:6e02:1d16:b0:2c9:d7e1:e949 with SMTP id i22-20020a056e021d1600b002c9d7e1e949mr3864819ila.125.1648660459605;
        Wed, 30 Mar 2022 10:14:19 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b24-20020a5d8d98000000b006409ad493fbsm11588920ioj.21.2022.03.30.10.14.18
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 10:14:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v3 0/5] Fix early file assignment for links or drain
Date:   Wed, 30 Mar 2022 11:14:11 -0600
Message-Id: <20220330171416.152538-1-axboe@kernel.dk>
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

v3:
- Fix bad req->file check in io_fsync_prep()
- Be consistent and always assign file at the same time, regardless
  of whether this is a link/drain/etc.


