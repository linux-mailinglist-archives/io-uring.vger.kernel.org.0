Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447B86A599A
	for <lists+io-uring@lfdr.de>; Tue, 28 Feb 2023 13:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjB1M7f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Feb 2023 07:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB1M7e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Feb 2023 07:59:34 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7637B1B300
        for <io-uring@vger.kernel.org>; Tue, 28 Feb 2023 04:59:33 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id m3-20020a17090ade0300b00229eec90a7fso1599498pjv.0
        for <io-uring@vger.kernel.org>; Tue, 28 Feb 2023 04:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677589172;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KXJtA17sEPdxzjGQRqo5/JFvtFde4VQEEjSMt1+MlDY=;
        b=mDyvWPGkbF3bJHaDb6URbCMeqSru6ugFNy/bIXh2NNi/ioO3zW+ma+AR2j2IwC3keR
         UoLtO2v1uvVynGfnjuYmbACZ4C4Uhv8Vmo/e7s4m8DazX56/y3yVJynMx8mD/W0mxqCK
         NzBY54eZADgur4Rkn0MoQR1vXrgH3RGUBiOoFknvp+uxjZaXYhxTYtZP8z8loYtrsZ1X
         YxTgT0KDf2+Qxo9j8WUArhqNLOhYUYSbLQZsIPgbaja4UfRavwt8/YAU8Qk66iWIoY5o
         zvyUZcHnZZdZdrPROyDNovpgFjNyZ/SQUXn8i15WFP4TafbtslEV7XyhcSCKR34oY1Ip
         YIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677589172;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KXJtA17sEPdxzjGQRqo5/JFvtFde4VQEEjSMt1+MlDY=;
        b=E9DyTS0hdDrOiE3wgFcY0j1Yi1HfwI14JgXcJHLXxyU0Or2DfT0KiaBNo7DrmCydhl
         IOGHau+soO70SCWQ8IwsQ6sTPAoMC6bNqijj+70DSM5XCUyoXZ13skve8uTXf/JO+Hzl
         PxLZWee4dstTzZus4NHfDCS1/eEDDutJ09VQIB52SOR8SDSrZ1S+hlLRyVfNB9aFebUX
         5rRRP2BZViI9l1k6aJNPJCHONs3hZk99Xu7wXpjpx2U+VqYDvrBd5Ik0sz73lIMlrM+5
         gudCUhX9zz5DMlkBFTYx92r4bxGI+MZpVaiaQK/CkL2/Q/hmLJ1jwdqs8TJ55Ub4AYjB
         nZ3A==
X-Gm-Message-State: AO0yUKUC6etefBzsw7k6HnoPiGBZqQxyUYwMFCtp4jymBed8fIYHvCis
        Naf6CAdST/dnthrupcM1gPdEGXg52MW8bwVa
X-Google-Smtp-Source: AK7set+Wesvq4ADKotBrhahVOK590hMee6o5LDqTctqAO+LO8D8tJEOkzucm4oPjIFohMcBEa+MLfQ==
X-Received: by 2002:a17:902:e543:b0:19a:9269:7d1 with SMTP id n3-20020a170902e54300b0019a926907d1mr2964175plf.4.1677589172564;
        Tue, 28 Feb 2023 04:59:32 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902d34600b0019cb8ffd209sm6506983plk.229.2023.02.28.04.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 04:59:32 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        Heming Zhao <heming.zhao@suse.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <20230228045459.13524-1-joseph.qi@linux.alibaba.com>
References: <20230228045459.13524-1-joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH] io_uring: fix fget leak when fs don't support nowait
 buffered read
Message-Id: <167758917178.12826.13481934362166793957.b4-ty@kernel.dk>
Date:   Tue, 28 Feb 2023 05:59:31 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-ebd05
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 28 Feb 2023 12:54:59 +0800, Joseph Qi wrote:
> Heming reported a BUG when using io_uring doing link-cp on ocfs2. [1]
> 
> Do the following steps can reproduce this BUG:
> mount -t ocfs2 /dev/vdc /mnt/ocfs2
> cp testfile /mnt/ocfs2/
> ./link-cp /mnt/ocfs2/testfile /mnt/ocfs2/testfile.1
> umount /mnt/ocfs2
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix fget leak when fs don't support nowait buffered read
      commit: 54aa7f2330b82884f4a1afce0220add6e8312f8b

Best regards,
-- 
Jens Axboe



