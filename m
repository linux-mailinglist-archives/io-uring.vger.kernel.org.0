Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8ED61D5661
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 18:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgEOQnk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 12:43:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28279 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726246AbgEOQnj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 12:43:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589561018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6zoWiTj7IBOy6jTdEVVP3ldTuVxq4EjrFI7WKis4eRY=;
        b=Bhdfl+xPEcYmPu8rTSmi+pKqD0NNChOJGRSHyuiXG3Rx74xkhhEyPu3DfbXX5xh9420joj
        OQgc6mhLv60xzSiUXnmo28iJTxJfPXJhVSezQ2L2o+61cSAZE+uN3AABEwen0/Zu/W4ilg
        y34GyHwI1g0jQZPf+Ri1EVB0yNN1saE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-nDdGHyqgMICGBOZ8gJOpjw-1; Fri, 15 May 2020 12:43:34 -0400
X-MC-Unique: nDdGHyqgMICGBOZ8gJOpjw-1
Received: by mail-wr1-f72.google.com with SMTP id x8so1437831wrl.16
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 09:43:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6zoWiTj7IBOy6jTdEVVP3ldTuVxq4EjrFI7WKis4eRY=;
        b=iZr+hAh8IwaKCobuhTslxCKwV3dnmDPmb90dPNqhN9vz0cP/dbBpedpLLjwW2KeuLV
         kndAcajKQkowEbGTILA8kYejgeVp9talcAzLHZ2yw0l40Pad7OKW36GZz7WQ5P7Ru6Rs
         pW1PqJ+jUsJzo/Fqs/wg9/sZCxreQmUgJz585fDbAaMNjQJV/l25t1/t7sj5GA4vEd4j
         59c2Ad5FstZpko4pqrEOh88sFK2QKnsxfYpSFE0UZSxKHpNZSg9vhbJnrILFiZOZhnjl
         eG48vBpKfd8ICfWODQLowHr1U1tz1DCqJkU93cZUD8a2zaH3IfeDFn2rT8HH1my7Z8a/
         Hu9Q==
X-Gm-Message-State: AOAM530sdPUas+RPirLGlX8Em5ZZTDINL52IPExgB1KqAEsJTnjWDTtt
        8f4iZCNzI/+AqmVUkdCy00j6FFRZQKaGMHG4SNJn7WKYuIzTkzacinaVODASRB1HFSn/keWmDsC
        0B5+hBYcRDxgxwQWI3G8=
X-Received: by 2002:a1c:23d2:: with SMTP id j201mr5042758wmj.48.1589561013628;
        Fri, 15 May 2020 09:43:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwA09iK0Nho3crwi4jdnst3INeMg6bl3yW6BpGnu+r0s6/TLAGqfsj/K2pzfbyXM8yUAg0aoQ==
X-Received: by 2002:a1c:23d2:: with SMTP id j201mr5042745wmj.48.1589561013415;
        Fri, 15 May 2020 09:43:33 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id v126sm4512322wmb.4.2020.05.15.09.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 09:43:32 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 0/5] liburing: add helpers to enable/disable eventfd
 notifications
Date:   Fri, 15 May 2020 18:43:26 +0200
Message-Id: <20200515164331.236868-1-sgarzare@redhat.com>
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
notifications, and io_uring_cq_eventfd_enable() to disable/enabled
eventfd notifications.

I updated man pages and I added a eventfd-disable.c test case.

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
 src/include/liburing.h          |  31 +++++++
 src/include/liburing/io_uring.h |  11 ++-
 src/setup.c                     |   2 +
 test/Makefile                   |   4 +-
 test/eventfd-disable.c          | 148 ++++++++++++++++++++++++++++++++
 8 files changed, 204 insertions(+), 4 deletions(-)
 create mode 100644 test/eventfd-disable.c

-- 
2.25.4

