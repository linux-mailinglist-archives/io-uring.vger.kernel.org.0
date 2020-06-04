Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD2A1EE9BD
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2020 19:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbgFDRsi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 13:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730055AbgFDRsh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 13:48:37 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D26C08C5C0
        for <io-uring@vger.kernel.org>; Thu,  4 Jun 2020 10:48:36 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id j1so3431125pfe.4
        for <io-uring@vger.kernel.org>; Thu, 04 Jun 2020 10:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UQ23UMbLpnikMyJsJpi7tgybjenRgCAV4RiDM8tRNA0=;
        b=Zg7sIE66b6CJQoMMzgAdQSjCVFIDK0iYLSeyqJHrGnsRYsDLpSsHePwMwsOUcCUMGn
         tO1B+RtyiW/T6YUJ9IuionxmhwZ6QXVtvbJmZw3quDMZFx1miolZGbuB6KHvK+E9mDiI
         d4hOPVtVOhDb6P3mQd9nVBFNkYFk4Eoc0Z1I4c58GxOECpR/OLRGWu153CnlEewvspCY
         abTHjD6h+1+WXmqIGb0U5Rqeaoec5Q2IXPmtDkeZkqaGEjSUM9klxc22nrS4CWGSIK3H
         6zuh1r2BmB//DmM4MfCmvIYc8eFJH9omQrTgQ9va1jQHaJTKACdwdSkhxBHFAURwxyEv
         xenw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UQ23UMbLpnikMyJsJpi7tgybjenRgCAV4RiDM8tRNA0=;
        b=rlgq74YGyuOeENhC56x1ut4USrG1RiGNJVUT5EdkRsGlmJVkEhji6l++dG0T17jHGz
         2pHIfy1XgWAV1CV52469xe0frNZPNqKzMR3n4I9sltJezm0srDJjNSxrMvnuKfKFtcpV
         YWejxIO1jINzTXM8SRSfii+7gYx1VhXHBGKhSqBmZTgjaN+yo/n5NSSS2pWGyEB0hQMa
         6WOJCaXKzWi9nEZATvvV9u+pC1SYW/IFwdq8jw7ge9fmeL19g3d3jKJzTM/A/N5al66M
         rVuAOzwVk65UL39uh9yiHLuUTIjs9NGIAhFdctnZADsoQQwsujMwIddrFq4qo0xY/K3J
         6G0w==
X-Gm-Message-State: AOAM532gdFDlL11qJx//sQBWq140T2Rf0ktzq9aRJVJ2b2sFc75xlcDo
        fcHKcB7S5B/J9GXyarRZzdGayI7M5+FwuA==
X-Google-Smtp-Source: ABdhPJzSgTLra6f/JPMoooQhL9aoeQ21nA8f0jzPcISVEZTFy8Fg4pSiqfzTl7vqVB9bLYz9A/4T2w==
X-Received: by 2002:a62:2bc6:: with SMTP id r189mr4333039pfr.11.1591292915804;
        Thu, 04 Jun 2020 10:48:35 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n9sm6044494pjj.23.2020.06.04.10.48.34
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 10:48:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET] io_uring: never block for block based IO submit
Date:   Thu,  4 Jun 2020 11:48:28 -0600
Message-Id: <20200604174832.12905-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We still have a case where resource starvation can cause us to block.
I've been running with a debug patch to detect cases where an io_uring
task can go uninterruptibly to sleep, and this is the main one.

This patchset provides a way for io_uring to have a holding area for
requests that should get retried, and a way to signal to the block stack
that we should be attempting to alloate requests with REQ_NOWAIT. When
we finish the block plug, we re-issue any requests that failed to get
allocated.

-- 
Jens Axboe


