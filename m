Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1F520FBF7
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 20:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgF3Sp2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 14:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgF3Sp1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 14:45:27 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E29C03E979
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 11:45:24 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l6so6758209pjq.1
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 11:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=36Pf7vLOoIjmkl5ILc1j+cAKoyh9jGyx3eicyZDkpLY=;
        b=haZm16FaN7L9wBGzn287iJdsYlLzqIRf1clHPgVmRu18KeNPfsyv3Mzx8qzBOvAWZ+
         ZEiMv7f0mBIn95G8IcVh8rewTPJUNMx5gqf7cNPBCuwsmwGfctuC2Gq/Hkb6XKVDAo+4
         6Q+6EhAhKdDq+8tAsPyclmZxtHDQeRaU94NiVLmuIEtzldU4qBjyUdFANxnJK1sw9zxG
         ZZPQpQojp6TyBuRyNGkR2jVdlEBFEwf7QRKSANrTSJMMcP5bo/Tceilwrcgm1vKO3wu6
         vvK2Z0z0SRFOH35GcASBAYR2wn6LNI1ZqTb6aRrJMJ0elkquw9/cDPrQRpjb1eug0OoA
         nEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=36Pf7vLOoIjmkl5ILc1j+cAKoyh9jGyx3eicyZDkpLY=;
        b=AZsLkftY8I4PQMQ0sP0+wg8JACxzxm39KTkjwhwx/lHClFjwajNW32M3uC5/l2qHTG
         9iNzOdgP0FDrRQ6vWOaQjE1qE3sisN4HFnAnVq4Ip0QI8um+r5Yl/NjsWNvfLlP7uct/
         bo1OatnirM/vOkYfXyX0bEB8FLPAks7MNXX/Ht5pqGXHcJhp+ACQo5RL62yvE8KIBkwh
         7lDFIcUb27kRT47NS0R9U8GkhdR8auzgHKJNJWRVwF7cVv8pmRbXmXdT5wN3a9tCNK7Z
         ZCy4Yiwp0Ge3nskKpqPld7CePsu+hBY3/8TdWdsSq41mwWBM7OGqIDXGXp0dAYljCjI0
         OUcg==
X-Gm-Message-State: AOAM530pt2TLDanIy3wmaaeEpICthB8hCV8tsHvxbsDdQWV7NCXDYj/A
        7U3skqgAOxOR783pxm9LNPJN7p8mRX33mA==
X-Google-Smtp-Source: ABdhPJwPaD/fLLXkzmsb4f+8hOMS05fApeg/LQl99uaMgVqHMvdpjIK/hEk3OxycS1sLEIU8isGIXg==
X-Received: by 2002:a17:90a:1acc:: with SMTP id p70mr13487771pjp.210.1593542724210;
        Tue, 30 Jun 2020 11:45:24 -0700 (PDT)
Received: from localhost.localdomain ([2605:e000:100e:8c61:4113:50ea:3eb3:a39b])
        by smtp.gmail.com with ESMTPSA id n7sm2898108pjq.22.2020.06.30.11.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 11:45:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     oleg@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHSET 0/2] Use signal based task_work running
Date:   Tue, 30 Jun 2020 12:45:16 -0600
Message-Id: <20200630184518.696101-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This fixes a regression in 5.7 with io_uring, introduced by the
addition of using task_work for certain async events. Details are
in patch 2/2.

-- 
Jens Axboe


