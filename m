Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DCF1DBABC
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 19:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgETRHk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 13:07:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39194 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726845AbgETRHX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 13:07:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589994442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=R5gtdRsL9ifN7yCZuWFMi81hopoNqGWuqIuJGxvm7G8=;
        b=jPg8qEoAI7dNR1EN3jYX+8odSmxfTb2IUXUJ6+6AdSzt85f+QZJpFn5qMDAMKsCRcwCZvB
        u2gHjA2OFmAn/kQUZT4EdhUyKp0PLouxrCsPQtf99yt/OPUMut/OOidO41sWubQFmwR65l
        YmmqxJCmOmq8HiKjG+6cSUkS1BiwulM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-iVjWzuFlOSGa9V3Iyu1ozw-1; Wed, 20 May 2020 13:07:17 -0400
X-MC-Unique: iVjWzuFlOSGa9V3Iyu1ozw-1
Received: by mail-wr1-f69.google.com with SMTP id r14so1659912wrw.8
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 10:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R5gtdRsL9ifN7yCZuWFMi81hopoNqGWuqIuJGxvm7G8=;
        b=dgn+jzBm84RFCFrmzERzK/fBMA/lKcSV1CJIaQ/b0sYUvsgkapskUPYbf0XzI9alfS
         bFGueWo2VdWNX6J9LvYcoaNcmt754fF/tEjbV+yposgm8EDtW7dHd8AAf68h5KtdoRzy
         zU5jbPWuCiWi2vuZhD4q8GJG2g1hVnxpTKkYajYs8thSrHua6YQXZ+3hKdlP/dS/nOK5
         Tdpm9k67Dcxg1rCricdCAK+hBdek3f9hunbssWbAJgeJvBUbZ3u9ggpzL7BsQt1cDmyW
         6WuTp6yMMixTXqUrZ7gv0Pgt0qr/8AYek7Tt4PVnVP4YX41g76+UQ6MODEvwHVtzhRg2
         Bkkg==
X-Gm-Message-State: AOAM533jVA1jUV2on1a9mcu3NRWBrt6KSsbEWkYFlnVY+0lCX8OBK3qL
        TKb2HaMz/bRA2VsL991c55mE0LmaIVep1IY/Kgm0lDBJgkcZ1n75r6NYFD9lGF7TnlzBCSC8ruQ
        NTxrJv5GPQWKfNanBlm4=
X-Received: by 2002:a7b:cb96:: with SMTP id m22mr5197374wmi.164.1589994436451;
        Wed, 20 May 2020 10:07:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynFVFxeMMZ/CQT3A/ITIWWt66gwDGDa673jWSyagjowp7jh7Bk4zmW7lu95gMGrueShnLeLg==
X-Received: by 2002:a7b:cb96:: with SMTP id m22mr5197360wmi.164.1589994436149;
        Wed, 20 May 2020 10:07:16 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id u74sm3768614wmu.13.2020.05.20.10.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 10:07:15 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH liburing v2 0/5] liburing: add helpers to enable/disable
 eventfd notifications
Date:   Wed, 20 May 2020 19:07:09 +0200
Message-Id: <20200520170714.68156-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series is based on top of a new IORING_CQ_EVENTFD_DISABLED
flag available in the CQ ring flags.

I added io_uring_cq_eventfd_enabled() to get the status of eventfd
notifications, and io_uring_cq_eventfd_toggle() to disable/enabled
eventfd notifications.

I updated man pages and I added a eventfd-disable.c test case.

v1 -> v2:
  - renamed io_uring_cq_eventfd_toggle()
  - return EOPNOTSUPP only if we need to change the flag

Stefano Garzarella (5):
  Add CQ ring 'flags' field
  man/io_uring_setup.2: add 'flags' field in the struct
    io_cqring_offsets
  Add helpers to set and get eventfd notification status
  man/io_uring_register.2: add IORING_CQ_EVENTFD_DISABLED description
  Add test/eventfd-disable.c test case

 .gitignore                      |   1 +
 man/io_uring_register.2         |   8 ++
 man/io_uring_setup.2            |   3 +-
 src/include/liburing.h          |  34 ++++++++
 src/include/liburing/io_uring.h |  11 ++-
 src/setup.c                     |   2 +
 test/Makefile                   |   6 +-
 test/eventfd-disable.c          | 148 ++++++++++++++++++++++++++++++++
 8 files changed, 209 insertions(+), 4 deletions(-)
 create mode 100644 test/eventfd-disable.c

-- 
2.25.4

