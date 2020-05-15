Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D841D5640
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 18:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgEOQiU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 12:38:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27432 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726313AbgEOQiP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 12:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589560693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7Bg7RWFLPly3TX4Y/V49rHB9a190dlTFcmjCSkHrUK0=;
        b=JL8e68hqz97QOk+dlnTT76BNXp/fDRypnFg5LOVrrNZr8oZtipjkVkmc5t3/PcCfhPxCSo
        Svr/4mDBQ0EkJhSLm3fIAyHiM77zKU3AbSiHktr+dvI2TjCFtmBcet8zrsNqtu6XZjgSrt
        +YxjxUcRMXq4jolfTFTb8Kzb2soVq4Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-G5I_1StFN6-l4nBGmHPpcw-1; Fri, 15 May 2020 12:38:09 -0400
X-MC-Unique: G5I_1StFN6-l4nBGmHPpcw-1
Received: by mail-wr1-f72.google.com with SMTP id 30so1432538wrq.15
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 09:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Bg7RWFLPly3TX4Y/V49rHB9a190dlTFcmjCSkHrUK0=;
        b=WDXAbhx4wMCnri5EawtWLsEnw1ImUbe59mM0Z7CtvSUWZeK4w4EEX7PYpeMeszh4Gl
         QxaVa6GgiIwxyCqEYHRogDqcZXXl8VGT4nrzeWUBvMQMD/7tSXm0Zn9KiSqNK3HxdjqO
         1aJ+R/SrwzIRq++WAr7t6UzXSKELBwega21GxvqSD6Lf2yviML665NTk7FDdjMjBTMLd
         EQsuKufS6jI2EEBPFmA9TRxr6GlwyBfN+Qt7CFg/lhstAiyGNIyXSHjokfOq4aRisRMp
         8Yc8ndRyO9/qsh/KTF8GImnWYmDD2bYEVjQ4zITUFm9hIXzFiUiE4ToLnztsCi6BrupK
         0b8Q==
X-Gm-Message-State: AOAM531e4x4VMDin8oM6Pnj5L1gzkY8cDUxhiyZlpumRSSALgiRNKGMK
        +6zQtWvtxC46hsCcTqcNUwOH7Or/GVQwnEGUC9VNKZHxyCp/wJ1GkFxKHxd7uXy3ws63DmBrB1g
        9VJzSRCbWxrhPvmGsSmw=
X-Received: by 2002:a5d:5449:: with SMTP id w9mr5180359wrv.361.1589560687882;
        Fri, 15 May 2020 09:38:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQ0wJAxWl28YCjenrP8G+kE5OMcm3BmJsWA9vMViZXynBcWONdSadJSiu/D24iHJbsAlDgVQ==
X-Received: by 2002:a5d:5449:: with SMTP id w9mr5180340wrv.361.1589560687584;
        Fri, 15 May 2020 09:38:07 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id b145sm4680274wme.41.2020.05.15.09.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 09:38:06 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 0/2] io_uring: add a CQ ring flag to enable/disable eventfd
 notification
Date:   Fri, 15 May 2020 18:38:03 +0200
Message-Id: <20200515163805.235098-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v1 -> v2:
 - changed the flag name and behaviour from IORING_CQ_NEED_EVENT to
   IORING_CQ_EVENTFD_DISABLED [Jens]

The first patch adds the new 'cq_flags' field for the CQ ring. It
should be written by the application and read by the kernel.

The second patch adds a new IORING_CQ_EVENTFD_DISABLED flag that can be
used by the application to disable/enable eventfd notifications.

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
  io_uring: add IORING_CQ_EVENTFD_DISABLED to the CQ ring flags

 fs/io_uring.c                 | 12 +++++++++++-
 include/uapi/linux/io_uring.h | 11 ++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

-- 
2.25.4

