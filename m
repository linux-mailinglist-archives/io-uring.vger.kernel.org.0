Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F315C14C7EB
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 10:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgA2JRb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 04:17:31 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22657 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbgA2JRa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 04:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580289447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RGglrM7s5lSXQM0eAmEz+FQFKQqXY1sMI+jK3RokXCY=;
        b=LLIsGJRzt4mkfFuB15GfSQr78MEA9JRZEPcEGSfR6HQaXzUjvZFsC4uSqM/sVThA8gfFAq
        g2SRoVSW13pG6qr3Wo9xaklGDncbX0ouRt9rdh0xzwampELkaUDlqr979VNcinLIGkwVcG
        Cj52b90MY6XYxK/KQ63A2VLwH0Gk3Wg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-fpyNTY4zPWqTpXqKvrIibg-1; Wed, 29 Jan 2020 04:17:26 -0500
X-MC-Unique: fpyNTY4zPWqTpXqKvrIibg-1
Received: by mail-wm1-f70.google.com with SMTP id y125so1252069wmg.1
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 01:17:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RGglrM7s5lSXQM0eAmEz+FQFKQqXY1sMI+jK3RokXCY=;
        b=Z4gCSOcahlVHJbOep8O0BOMs/wJXmlaOpay5/yMcIiQ8YIqQyp9z9mXDPPpjXiCBn0
         X3Tc7LbKxDwYJzAgiivwSmSYsyBbEHvd7p/XwF6xQ9kRaGIA7SVwhw50Ccce+X+7ISOg
         Ef2IT3QcPCSyJbEyKD9KHYfu/qMUyI7AyvNvknf/bPASz7nSuhV2BxAVLSl/sIbf5uI2
         SdIFaY9GWRAONH8m9EjQMiGFT6RvN2RAyyu1jTgJphv7H6FktAZyFW1hibnoA1R1gmdC
         GtyF+B3gIhiy2W0tmC/tqoXZtPulAlQM2FaB+nRsmbxVdZQEMEDN+wZ+Euj+lv5qlzFy
         CCew==
X-Gm-Message-State: APjAAAUpfpyXm/BP938/g0h4FOBexNuXVBhi4nDBLtuxBUh6V939Tf6q
        6vw4kQ/jATdj8qqoIeWeYMwXBlyHRnOUoRDFPO+U/4ol80LayFHTC64LjXdAPmBPH+loYxWRTGG
        7Vdvnco4mj582Lwf7DEg=
X-Received: by 2002:a5d:5706:: with SMTP id a6mr34179124wrv.108.1580289445162;
        Wed, 29 Jan 2020 01:17:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqwNEgRl6FoHBqOsuInbDXgnwmjNkSyuM8sX3+aZwGv9UkUvO1RB7XUCm8cQEi3IOEHAnJfT7g==
X-Received: by 2002:a5d:5706:: with SMTP id a6mr34179089wrv.108.1580289444845;
        Wed, 29 Jan 2020 01:17:24 -0800 (PST)
Received: from steredhat.redhat.com (host106-49-dynamic.31-79-r.retail.telecomitalia.it. [79.31.49.106])
        by smtp.gmail.com with ESMTPSA id a22sm1550885wmd.20.2020.01.29.01.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 01:17:24 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH liburing v2] .gitignore: add missing tests to ignore
Date:   Wed, 29 Jan 2020 10:17:23 +0100
Message-Id: <20200129091723.16746-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v1 -> v2:
    - rebased on master
    - forced 8-bit content transfer encoding (I hope it works)
---
 .gitignore | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/.gitignore b/.gitignore
index fdb4b32..acbd30b 100644
--- a/.gitignore
+++ b/.gitignore
@@ -24,6 +24,7 @@
 /test/a4c0b3decb33-test
 /test/accept
 /test/accept-link
+/test/accept-reuse
 /test/accept-test
 /test/b19062a56726-test
 /test/b5837bd5311d-test
@@ -36,8 +37,11 @@
 /test/d77a67ed5f27-test
 /test/defer
 /test/eeed8b54e0df-test
+/test/fadvise
+/test/fallocate
 /test/fc2a85cb02ef-test
 /test/file-register
+/test/file-update
 /test/fixed-link
 /test/fsync
 /test/io_uring_enter
@@ -47,18 +51,26 @@
 /test/link
 /test/link-timeout
 /test/link_drain
+/test/madvise
 /test/nop
+/test/open-close
+/test/openat2
 /test/poll
 /test/poll-cancel
 /test/poll-cancel-ton
 /test/poll-link
 /test/poll-many
+/test/poll-v-poll
+/test/probe
 /test/read-write
 /test/ring-leak
 /test/send_recvmsg
+/test/shared-wq
+/test/short-read
 /test/socket-rw
 /test/sq-full
 /test/sq-space_left
+/test/statx
 /test/stdout
 /test/submit-reuse
 /test/teardowns
-- 
2.24.1

