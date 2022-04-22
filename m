Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E4950C33D
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 01:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbiDVWnq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 18:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiDVWnh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 18:43:37 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7171D838C
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:42:19 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id z30so1232350pfw.6
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UAvikUaTK9E646FizQbGsRkjZl5jpa9WlQeNNDyqX2Y=;
        b=S8RIe6kkBi5gOVRk4cCYFPmhxLjE/mw2Qfz7mJEBfg1ip17KqWPi201MQheMN0PfQS
         r+aGdHcnSHDcOZJLxal9kM1hVvmw/Sq1r8SJThTMst7WGXiMlKi2ViGlpnVDt6zWDVCM
         hGWX8kEfKuKE8Ajog1sCaQN1yXAN2WSHiUtGU1L3LTyiJBJzWUmLBeDTrKbNjAYo8AVe
         cpQ6UScda3IS53cTL5WP3qf6+jDWMPjMTEOe+FrfVrNgOsxYzMZ5pYm5SLO8MvkevqJ+
         dklqLJGYQlCCJBQwD5L4wXXmuPoPteK+8OIN/JKyznxbK6vgaaeC3wbJdz9i+IzVqUTl
         zZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UAvikUaTK9E646FizQbGsRkjZl5jpa9WlQeNNDyqX2Y=;
        b=avWOqdye+qVobeZoVe0uQYBnT+3bIU/rg+9K1bqBgOR7t4iON/TlSkxFr1ngJzVUDa
         /OwwfV1UQ/CrWvrWXPZxc6lcB8Vu2WXJnVTn/Zf7JP+RZqRB38/5c2nf7WH1ieGWVmzS
         gasZ8wb6zY73c7j+iEBEDcYzsjldAipBZu+TPMGt6JbONuXw8Z0TI9i6ms6TqriWT7VC
         WBFUR5rYafr7ZsJ8f1ijGwwy3yQ1Ew3m60uCnIR2I9x8s27NchijJLku96lRcTHlCvF3
         kN+ssgX75Ok3kvZWU9PqYjjQs0V6RYrf1KgjgtrF/CoT9f0hOVMDGqamUMfI0J/5NG97
         QYSg==
X-Gm-Message-State: AOAM5334+W/wCem+SlxbYiHU/67RLA9/Kq/Ni9qkL0izTouz5i/u85Os
        3mlre2dy5kx+UFQqHzUvIC6z6OMus4rt/HAo
X-Google-Smtp-Source: ABdhPJwICyOtHO+1rCNVQDIjaBva6riUuXWW8xFiatnThmZKZirDc+DsYWzYemnxIfz7olC4qSKSoQ==
X-Received: by 2002:a63:4e62:0:b0:398:cb40:19b0 with SMTP id o34-20020a634e62000000b00398cb4019b0mr5579101pgl.445.1650663738449;
        Fri, 22 Apr 2022 14:42:18 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c5-20020a62f845000000b0050ceac49c1dsm3473098pfm.125.2022.04.22.14.42.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 14:42:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET next 0/5] Add support for non-IPI task_work
Date:   Fri, 22 Apr 2022 15:42:09 -0600
Message-Id: <20220422214214.260947-1-axboe@kernel.dk>
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

Unless we're using SQPOLL, any task_work queue will result in an IPI
to the target task unless it's running in the kernel already. This isn't
always needed, particularly not for the common case of not sharing the
ring. In certain workloads, this can provide a 5-10% improvement. Some
of this is due the cost of the IPI, and some from needlessly
interrupting the target task when the work could just get run when
completions are being waited for.

Patches 1..4 are prep patches, patch 5 is the actual change.

-- 
Jens Axboe


