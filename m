Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7248650E2EB
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 16:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242327AbiDYOY1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 10:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiDYOY0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 10:24:26 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87891201B6
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:21:21 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e1so9435224ile.2
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pCyVvAC5a+7qFOn9sff5RSYth+CrL02R7qZ6kFwVXHk=;
        b=rmvVxqWo+Ukix+1yr5X173f7SmePsJ69ufr85BTcw3JaH7lAwbjADkwxoGaeq/piWC
         c+NGEWv1HQT4Hy+haTTkac6SDZlURxeK94r16DHyycNZxLQAL9ImBrXbAE0rJ0k9ppuj
         h9X1Y4lIY+NRnE5bR0xNfQvNllsdrkSryer3nPQlVWYo0skR1njpPDAndBD1gZPOCJvE
         /0XpHNyzGFsb/0MpiFbhwxr3xQoMvZI506ub8He/+tWpwMzr0K5wO2T9KzgMI5F7qcEI
         ocuIhFJ9+bKPfKc/Ogqgg0n32WLtzVJfV4uFb3DBjOJXEdIXMf6+ga+Nw1qWUGlMyoB+
         9ygA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pCyVvAC5a+7qFOn9sff5RSYth+CrL02R7qZ6kFwVXHk=;
        b=OMgWyxHwYoANNZhRDuIKjuRS76j75eh3ci9Uv3vO0w6wRyHjUQv5sb8aTYaQV6cNWZ
         Gxy8V0Qr+v9Ps1X+IB0QFwTOxgrvJQDY1fEMOix1mlU77lTh8Z4N/+hQkyXINM9+9MpD
         VjuCohimBsv8kVqrtY+y0rS1Zgp31wpoCDnBQmKcmu/xGC3+xs3qbBwQWLZfP7d39VqT
         l8UjQ6knpHhDdb+u0nFUC7VdXovPoNRwupuBbBXMOvVwgjtClnZa6K7/PD8oLDFEbMG/
         q3s/AXy0almZ73hpphdZ7NA72REaIw18SfrEIdjsi0jFevM16qPjBrdTKrZVLy//GdgI
         cMxA==
X-Gm-Message-State: AOAM533L5eNqVD+hWxvwDUlnbxGDBi7MrxkNQ9T3T0ZbgU8yDiYHPJOP
        /ZflvNVM+VAPdHu6YTWGSBNs/yNReRO2DQ==
X-Google-Smtp-Source: ABdhPJzuJmaSEPgJCuec11GkC5XXmmVJ0/gTQ1bYVBM0H1rBOVQ4SIxafAyCn+BwffwtScsUfghg1g==
X-Received: by 2002:a05:6e02:1d9b:b0:2cd:8857:33e2 with SMTP id h27-20020a056e021d9b00b002cd885733e2mr3856256ila.80.1650896480479;
        Mon, 25 Apr 2022 07:21:20 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p6-20020a0566022b0600b0064c59797e67sm8136737iov.46.2022.04.25.07.21.19
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 07:21:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v3 next 0/5] Add support for non-IPI task_work
Date:   Mon, 25 Apr 2022 08:21:12 -0600
Message-Id: <20220425142118.1448840-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Unless we're using SQPOLL, any task_work queue will result in an IPI
to the target task unless it's running in the kernel already. This isn't
always needed, particularly not for the common case of not sharing the
ring. In certain workloads, this can provide a 5-10% improvement. Some
of this is due the cost of the IPI, and some from needlessly
interrupting the target task when the work could just get run when
completions are being waited for.

Patches 1..4 are prep patches, patch 5 is the actual change, and patch 6
adds support for IORING_SQ_TASKRUN so that applications may use this
feature and still rely on io_uring_peek_cqe().

v3:
- Rename flags to hopefully be more descriptive
- Add flag for managing IORING_SQ_TASKRUN flag
- Rebase on current branch

-- 
Jens Axboe


