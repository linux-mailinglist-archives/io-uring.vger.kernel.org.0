Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4041B334BC4
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhCJWoH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbhCJWoF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:05 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8605CC061574
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:05 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id e2so3971742pld.9
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0HQbEc1IwO4DM/THbvZFnU5w7qa1diYFeOyoPwUL8IM=;
        b=rpLR16ZExf0npMFpiQkD/pv8R4KtfI/bW2AKRyShXeCgdlDXZOCHPCt6KIAlt4UO9E
         uF9Jhiv2rUOmARk17Q5YlEnFZnc0xAb913LTldfD79VVqPIv6EIzwkASi/wnd9OIDXTC
         pcc9C9R/FPyGWmVjkPwNL/jgj8I39wFVYDTZj9I6+vlJ3BfqHr0NMYwXdkWTiCDwOODl
         7vfiTkW1/2xd4ERolVnyew6X+xDvMLhoUaapYlhU4Y7qfs2EMHcrX2n+/w/RubIYGRtS
         X48Q7EH7d0NUrocOLPAWY26ulH2BoQECNj/r2ByNrvs4CF+09uuqz+C+iJTAflBjSbf1
         SltQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0HQbEc1IwO4DM/THbvZFnU5w7qa1diYFeOyoPwUL8IM=;
        b=Adl++6x19Ec1ZZlww9d3GRzhdS68pdMbHDUxCi4KdxfM9k+5EK3w5LLnCGPXAckP5M
         OZmGaz9XhLau86NADtmP+LlvvBOAOW6jaA7uP1qC7Nr1FO3L+ztZbte3S6rSojiIoy/a
         /HVoTnP2MBCBtaQOEJmqA4G1Aws82sRPzPT3ME+Ot/2SRsfQxsBo9gA9A/ZU5pajdv4I
         Bjp9MreotO0qYclOJ6HLKLGjOv8wZO7d4CMEfkWHOPNY4Cs38iS10qWMRUwc7/M4ldyQ
         7vXE3MamlQppEwbxVrcS+d1XookcTGhqXxhQSs3i3/1yPm6kmQbeITU+UU0x9DgwZyb5
         Bs7g==
X-Gm-Message-State: AOAM533MrXFFXWzY8z/XEWz70d28s8qbCdjp0wC5I+aHef7uLK7TSbIp
        2ocJX6jOtXxVVa+kdhXXYzQfiqPUNM4nDA==
X-Google-Smtp-Source: ABdhPJxEvzfnC3uwiX6G2cOcCxm/kn2Fz+n0znB7TDUrTlvU1jZrw+K/ra7aOoT8lYNfeR7AAzdEhQ==
X-Received: by 2002:a17:902:369:b029:e4:b5f1:cfb4 with SMTP id 96-20020a1709020369b02900e4b5f1cfb4mr4895094pld.60.1615416244843;
        Wed, 10 Mar 2021 14:44:04 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.04
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:04 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET for 5.12] Patches queued up for 5.12
Date:   Wed, 10 Mar 2021 15:43:31 -0700
Message-Id: <20210310224358.1494503-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Some of these have been posted before, some have not. Here's the queue I
have pending for 5.12-rc3. As last week, this is a mix of fallout from
the -rc1 worker change, but also just fixes in general.

 fs/io-wq.c               |  25 +-
 fs/io-wq.h               |   2 +-
 fs/io_uring.c            | 608 ++++++++++++++++++++-------------------
 include/linux/io_uring.h |   2 +-
 kernel/fork.c            |   1 +
 5 files changed, 328 insertions(+), 310 deletions(-)

-- 
Jens Axboe



