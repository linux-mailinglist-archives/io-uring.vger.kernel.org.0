Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E607F6E9BB4
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 20:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbjDTSca (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 14:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbjDTScI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 14:32:08 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7D9619F
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 11:31:39 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-32ad7e5627bso501125ab.1
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 11:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682015498; x=1684607498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=CChzrJ2u9Hp20UfPmTPqpiWaDRYEoTme3376Yhjy93Y=;
        b=eP4xZmG1q/XZRzz7eI91wsBeRidcRBEINIeFAu7zV5bcB+C8rNI9IKLMZ2g3x16/KD
         lWYB1LBU7GkUXaD+1kdL/EfCmC9T6f6xFwrvXHv/W//yGYai+2KNmqgeehT1A6eI9Ws0
         UHTpHl3i3qCpybTs6GRyptAs6J8qg4uOK6dLSkZylqMvpQvngALVjX3ZKaXUMMFINjFy
         K+w3HCPFSzliPuUfe5DAJghUIj7QgkjxlC6dE9T1oFhXEn5zfqxlJQDCMB3IhlpLu59P
         7dHB1/5CDtJ3/+whybprBYL1uVQ15BasnfewOz4djVS1xNIOdo/GewNz1W8i0SoArtwp
         F9MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682015498; x=1684607498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CChzrJ2u9Hp20UfPmTPqpiWaDRYEoTme3376Yhjy93Y=;
        b=WhG7wfGVB5ug1jqBfT7JGWt2vzcMvYkgvJcqnxEClHCizpPECnV8C4UpubE3oxrZlv
         F227WPdMHfD2j2x8kPWY5qnZvaPZU7EQrdZ8KSdw1lrZ/ctowAHg6nANYHhz5Q7/vsh4
         98yrKRs4/tm85dd1jyWXy+nsaJKBVTNYgEfbY/T9IN3WVrbKDh5UUt7m0AHDamDhGRDZ
         pcURuzcwMY7rVHCdyixg9Y1v32ZY5e1//UpRYh/mhiEGMMF2QkGgqVWUkTyVldCNhSeB
         nCbqo8OkwHLuvqBvDckuzfcFq5I1h2uctwmvyubd2rTejm4gJqM6LUVxHO2MzLF4VgEa
         pZhQ==
X-Gm-Message-State: AAQBX9cI5sxLr48E0LXDRpODwul2jtpvvH5JyZ4f80+3bMzzMUiEUofs
        y+oHEgh5gTxNQnAZF0sRb9ErWm7xWCawkSrOK3w=
X-Google-Smtp-Source: AKy350aAliH3+agD9LRdzElSgJydpIlqVe6EcD6BODxGxrKzlRnhEhIQC50UWk1uCNsidiDcRE1kiQ==
X-Received: by 2002:a05:6e02:1609:b0:325:f635:26c5 with SMTP id t9-20020a056e02160900b00325f63526c5mr1699407ilu.3.1682015497788;
        Thu, 20 Apr 2023 11:31:37 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id dl36-20020a05663827a400b003c4e02148e5sm659132jab.53.2023.04.20.11.31.37
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 11:31:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/4] Enable NO_OFFLOAD support
Date:   Thu, 20 Apr 2023 12:31:31 -0600
Message-Id: <20230420183135.119618-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
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

This series enables support for forcing no-offload for requests that
otherwise would have been punted to io-wq. In essence, it bypasses
the normal non-blocking issue in favor of just letting the issue block.
This is only done for requests that would've otherwise hit io-wq in
the offload path, anything pollable will still be doing non-blocking
issue. See patch 3 for details.

Git tree: https://git.kernel.dk/cgit/linux/log/?h=io_uring-sync-issue

Since v1:
- Get rid of per-io_kiocb state, only apply this logic off the direct
  and initial submission path. Add IO_URING_F_NO_OFFLOAD for that.
- Due to the above, drop the two first prep patches as they are no
  longer needed.
- Make it mutually exclusive with IORING_SETUP_IOPOLL.

-- 
Jens Axboe


