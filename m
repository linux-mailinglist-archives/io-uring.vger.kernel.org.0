Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75CE2DD405
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 16:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgLQPVs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Dec 2020 10:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgLQPVs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Dec 2020 10:21:48 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2BDC061794
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 07:21:08 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id x15so26187956ilq.1
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 07:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xVGQ0zGKmUbRRWQlod7hN5Mu/6gsu1HTxiEECYiMK/w=;
        b=1dMPHCncqhNGNnUpydZV6Q7/ZL/UP/Mq9en2OqprD/CNhIiarUSlxARI7hUwo3uC20
         pgj/ZKnEffk/o9uE4LT4rQazc9lDdBPcFUJ1t+nfnW2jlyu9qw39tEaXi7gfS8zH9Hob
         792a/8FV3CILeSSavWnGpTWswQUx2VS5J3S8y8NxLbxZUAwRov5cHFpKFBELV1q385al
         yxvjlecUNBR2Me1u5FNDDztVbOf8hWnXoI85d+b01nwr+69Zuuh5xR2J2/C6nWqM4BvE
         wPPs8AttTO3iQNkPxIeNpAOe/xSrfUBnmc8J/33/L/8ULmMFIgTRzjh90EJi2ftaDKxJ
         Nw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xVGQ0zGKmUbRRWQlod7hN5Mu/6gsu1HTxiEECYiMK/w=;
        b=Kh6Yu9qrSneX6sP8xmgycvSEoVARJLzIHR/8ZH5GQYs1AyYAEU2NHDNbt9J7/kbAQR
         jzg2MRWEdDiZWIkFjk3rhUoxpqdfNMGCgtDBf40qXmgPh0GI88uh4fzYgF3k6A7oD7Ir
         m6GhIuGqtrz+YrLTiZaf4sGIPp7nddP9sxzBuQvmAhhM4ATN4Av0rxh9ye5Qrk2kJbHe
         neuo3ZO4KvbWBD62fquVxLai/7R8uECwOC1ctXuJNUEve8hwg88RQdNmFYbo4xd9pvUp
         7WYGBXVz0N7dw2wS+6BL7FYu2H+D/2ocZ4wfukHKKz8BkbCAyP/aqEdn06qswZvoARxT
         6wzg==
X-Gm-Message-State: AOAM532IEpGNV8TwXyyY5RLPF+rU6hunaL/RA4jaFDwM0H+JStWmUAvh
        JDzwSU6TKDXlIS0rz5HQi4MAFU+S8U9uAw==
X-Google-Smtp-Source: ABdhPJy9slxAujgC+pxuY7x0z3ezCbSiMl3RldwNwkXryR/wW2cl5E7f3lzyYlqQYgiFcjAdqOoipg==
X-Received: by 2002:a92:da46:: with SMTP id p6mr37786750ilq.136.1608218467151;
        Thu, 17 Dec 2020 07:21:07 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l78sm3611793ild.30.2020.12.17.07.21.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 07:21:06 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCH 0/2] Two minor 5.11 io_uring fixes
Date:   Thu, 17 Dec 2020 08:21:03 -0700
Message-Id: <20201217152105.693264-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

1) Make sure we break links if a shutdown command fails
2) Play it safe and grab mmap_sem when modifying mm->locked_vm

-- 
Jens Axboe



