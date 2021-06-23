Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D8E3B1D7F
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 17:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhFWPUO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 11:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWPUO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 11:20:14 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13493C061574
        for <io-uring@vger.kernel.org>; Wed, 23 Jun 2021 08:17:56 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id r12so3894273ioa.7
        for <io-uring@vger.kernel.org>; Wed, 23 Jun 2021 08:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YkTnaRMxOPEyDKI248Frj4ONmmqeX+b0r9A5CiNV2OI=;
        b=yZQmATVQtEkqJ/O8Jwn3goSkRy/RvcFEtyRSOsg+bRRTLSZwy1iKPgBnvrZfk9bfEB
         o35Bdq3GcMmiFKHbRmbREBtEn7O1xFl4Nbm4w0r0m8Vv0sfm5oOr2aCW3d7VGFFsdcad
         eXcxcoOYH2bkqcFuTgUQFQJE5SBCVmg/jXMBlOZtDARV+5R1ZC2Ss2qt9uK+hchojwIf
         N1vHZr9bxJOJ/lWdhotdFNWaWN7SwMefiA5fGtJm5PlaUWuKQOJC/dlV832UHgvOYk+E
         5aHCseLhO2Z9exEfV7K66JopX5paWzCZxDHJS3rfXUQ8sBziBhaTcI25It/0WdTBR9RQ
         ogjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YkTnaRMxOPEyDKI248Frj4ONmmqeX+b0r9A5CiNV2OI=;
        b=n1Zqrxk7AO9faq/7p4SCXdnkrtpOnh99XFoWHijmuUA7o2gXn8vZwe/UihhJ9tZ8EW
         ub9hv64UkdfrOgX0yVjstkqq+/yDpoUb+vEqszJwrXO+C8ApV/tPuylhXDo4Y5jmJkcR
         d4iJuuLL47YYj6RudKkFciGnpWKr5PCwZCnG1OqWEyCr2TUKQjl3ojbFj/eA0b+MmHZQ
         7thuH3zltK3ErExfw/D4ZabpvAswVNP3a0weeBnn0lV0RkOwrz066v6mxtuR+5sv9n5a
         BSIrUS6vWq4fih/XCUGqNbYvPikXnmyBtdfnlNLSxMhnSBrgJa59iPp4JwFC73YBvB3w
         zXwQ==
X-Gm-Message-State: AOAM533yDi0eyeXIjMNJRWwh3IVIhgSRj5xNGCRkQIyp3PTAhn0J/E8k
        gheH56M6jlIdKfQDSLOMM0dRt9m1RlNq8w==
X-Google-Smtp-Source: ABdhPJxNxbDomd0oDRUhfQ/qqM0nqazdiqNeL0xt2lCH9A1+AX6i9sud09naUjc/hugHhwrnRMtwng==
X-Received: by 2002:a05:6638:191d:: with SMTP id p29mr91925jal.75.1624461475267;
        Wed, 23 Jun 2021 08:17:55 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id t6sm97967ils.72.2021.06.23.08.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 08:17:54 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     dkadashev@gmail.com
Subject: [PATCHSET 0/2] Add iopoll/sqe field checks to unlink/rename
Date:   Wed, 23 Jun 2021 09:17:51 -0600
Message-Id: <20210623151753.191481-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

For some reason these were missed when added, ensure we get them added
now. The IOPOLL is a correctness issue in that we cannot mix and match
polled and waitable IO on the same context, the field checking is more
of a sanity thing that allows us to more easily extend it in the future,
if need be.

-- 
Jens Axboe


