Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256E91D4BB3
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 12:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgEOKyd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 06:54:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32992 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726118AbgEOKyW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 06:54:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589540060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=v6+7HSHBKR8s0hEc33VZWCAeaUDT8hTqdZCAfgvJPF0=;
        b=auwsXi5ChYKGe9gfeUvtqL62zydkMAhZSHybWOWtL2afFS2HcwvMftLHTfwCzdx7LN8q+y
        Zb846USVkIbP2M/Wai8jWGoA3QpuH0+2V/yuK3ei0yqhgG1o00bkD5cZrEqPOElktCdtid
        skRVMi+wXmLFHBTRckfPCjSpudt/2Fo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-SvKXaD6oP8G8VQF6bLcPNQ-1; Fri, 15 May 2020 06:54:17 -0400
X-MC-Unique: SvKXaD6oP8G8VQF6bLcPNQ-1
Received: by mail-wm1-f71.google.com with SMTP id q5so995198wmc.9
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 03:54:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v6+7HSHBKR8s0hEc33VZWCAeaUDT8hTqdZCAfgvJPF0=;
        b=JVMwSF1oAlx5rtVvywZnXzE+vBDRc4f1GamSWQ/ZvOhboIluYtGiJ1qvQlAekCZAYl
         LdxoWFIPibJW8P4+cp1PVbX1CnnGNVr+rylpLAh6UKAj3K3gAzdrhuGclvKRiOgDQIuS
         zlZK5jCQSEI7MifcqLDpnO8KcarLvjFU9zbdCus8OsGwYm/qI788yf1MmaZ3BjiiElBd
         K4Zh9WA8704UyUlQxlj1pDbIFMxICRZ9ysRCi5WFJ+Bv4B+ST6x1DcW8R/f5IWYPJCDW
         yeK8dir1o/6RYjBf0AgkSU6rtXoAar+i1aswdGh+3M4kfawcK3bJZljPlCfkKNy9xNHK
         HXJQ==
X-Gm-Message-State: AOAM5327cb8rZiYpY751aX5eDymP/A2+D9ELNdARzIw+DZ08zhgLmsOz
        6JOEv8P37WUvaThJ7v915UV7rWisEfv74ENCcGWYQREWbRmViBhTSswetOrML/CGz+Heh0pLkjt
        HgPq4fW9lGLVod9L8yPQ=
X-Received: by 2002:a1c:e3d7:: with SMTP id a206mr611347wmh.141.1589540056769;
        Fri, 15 May 2020 03:54:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGKSyZ3EcGNQMbE2oXkZ+N+V0uB4B/vMGscbFwTRyBx5EdRM7q4us6BaR9smbe7DP+QNBN5g==
X-Received: by 2002:a1c:e3d7:: with SMTP id a206mr611327wmh.141.1589540056541;
        Fri, 15 May 2020 03:54:16 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id u74sm3081713wmu.13.2020.05.15.03.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 03:54:15 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 0/2] io_uring: add a CQ ring flag to enable/disable eventfd
 notification
Date:   Fri, 15 May 2020 12:54:12 +0200
Message-Id: <20200515105414.68683-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The first patch adds the new 'cq_flags' field for the CQ ring. It
should be written by the application and read by the kernel.

The second patch adds a new IORING_CQ_NEED_WAKEUP flag that can be
used by the application to enable/disable eventfd notifications.

I'm not sure the name is the best one, an alternative could be
IORING_CQ_NEED_EVENT.

This feature can be useful if the application are using eventfd to be
notified when requests are completed, but they don't want a notification
for every request.
Of course the application can already remove the eventfd from the event
loop, but as soon as it adds the eventfd again, it will be notified,
even if it has already handled all the completed requests.

The most important use case is when the registered eventfd is used to
notify a KVM guest through irqfd and we want a mechanism to
enable/disable interrupts.

I also extended liburing API and added a test case here:
https://github.com/stefano-garzarella/liburing/tree/eventfd-disable

Stefano Garzarella (2):
  io_uring: add 'cq_flags' field for the CQ ring
  io_uring: add IORING_CQ_NEED_WAKEUP to the CQ ring flags

 fs/io_uring.c                 | 17 ++++++++++++++++-
 include/uapi/linux/io_uring.h |  9 ++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

-- 
2.25.4

