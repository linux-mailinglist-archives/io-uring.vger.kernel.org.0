Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B4F3D7B72
	for <lists+io-uring@lfdr.de>; Tue, 27 Jul 2021 18:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhG0Q6Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jul 2021 12:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhG0Q6P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jul 2021 12:58:15 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADE6C061757
        for <io-uring@vger.kernel.org>; Tue, 27 Jul 2021 09:58:14 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id o17-20020a4a64110000b0290263e1ba7ff9so3217696ooc.2
        for <io-uring@vger.kernel.org>; Tue, 27 Jul 2021 09:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qyRHX3ec2PIE2cW+oOIbumw3Uuy3X4OTSdoN99Ky5Zs=;
        b=kvH8cMTwpGuc7JmsogsaId20DlKm78pAZEywVMH4oMHQ9ELwcBbOTv/VbRFUnqyq4w
         V7PbOrfHf8CQz1QVgcUxjRE6nKauRQxMbKZ1qBBpgAPM7E4kPehuOlljuTYKmGp6MRaE
         gQ9WSrOxTdlnaMVk+22eKVHUA4hpLX/xf9Zy78FW63/gsTX5vBCOcp2Bpnc9Ry/KtlfY
         xWms/+8/o3NZUdXlb9rd3ZPy7NC2JgKSM90a/oy8mT5cgN5vqmRtONkMnaqlzL8NJEaO
         GLkl/rCGPmj6sFiytCNbX0Uti+HogMVaGTqMlM9XmQP6D6yGRZL0cxk2fhpNLQX+zcWa
         Hccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qyRHX3ec2PIE2cW+oOIbumw3Uuy3X4OTSdoN99Ky5Zs=;
        b=BGzv11ucsd4B3cqBFWDiAO9a7fQufWhnQGPoviv2eBUfmJCI1VGzfJMUDbjC/UaI/W
         Dd0rwQkeyF+eM5oN74KZ0NrGtnPZwBJDBw4/+26HbFJJyMyxpd4IvpJ/c8cAeMXKCDzQ
         TBD++fbR37Qwtw8KQw14R/A9NPAwULWwz25juLTzjyQL9m9kGqnw4penneeknigM337q
         N2bwLr30wgmOtoBBbGclSGPWKHNPiIPlWj7BGauvCpPlj3yjrYO1ffqEKnDr+qh4Umjz
         pdZJ60UH8AFwEA5kmLB3KBbio4PmP5jL4wqsv4xDFoehPuLPbJDX5KqwVXbC/TM4BMs/
         h3PA==
X-Gm-Message-State: AOAM531a3AkpZZolOlccImmQrAxfuMtUOwREhPcK7MbQGnvJKMdjpKYD
        Z3pTFQJFQvFt78aCIiEF/1STUOyIW38nq8kL
X-Google-Smtp-Source: ABdhPJxiZ904hHLow3BJAptEINn/uZkNTW6XG2Ku4DPQe+QKdV+6eamXIc6CoO/K+lrL5m6P1/e4nQ==
X-Received: by 2002:a4a:e2d7:: with SMTP id l23mr14197402oot.71.1627405093853;
        Tue, 27 Jul 2021 09:58:13 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c21sm637922oiw.16.2021.07.27.09.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:58:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     f.ebner@proxmox.com
Subject: [PATCH 0/2] Further async re-queue tightening/fix
Date:   Tue, 27 Jul 2021 10:58:09 -0600
Message-Id: <20210727165811.284510-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Two small patches to ensure we always requeue off task_work, and a
sanity correction on when it is OK to do so.

-- 
Jens Axboe


