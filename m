Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808CC165F75
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 15:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgBTOIk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 09:08:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54445 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728042AbgBTOIk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 09:08:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582207719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yXw1aooGm3SizxRsc5d1sX2J/L6gkHAaW3S5VvpIZy0=;
        b=B3FQHyFpyo/FqshK32+eV/XR8KC4BZN4V0i6kq+RE8UvvFxxDniFWVRsNugCDqUG98NyfL
        2j/0efe9sR5LRDthKkhU1dg1Y5uMqfGngS6RX4kQ0EOYDGkVmK7bXBZEqyMnjma90E/SOY
        y87y8xH5UpyvtwpSW4nYGyii8F8v11k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-nIS2u5SQOjOUiYUMSUXXFw-1; Thu, 20 Feb 2020 09:08:37 -0500
X-MC-Unique: nIS2u5SQOjOUiYUMSUXXFw-1
Received: by mail-wm1-f72.google.com with SMTP id n17so880230wmk.1
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 06:08:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yXw1aooGm3SizxRsc5d1sX2J/L6gkHAaW3S5VvpIZy0=;
        b=D2yjrlz4qnfPu/NMv0E+CdQT1bSeN+G7XYS2thrab4EgpvPO3GLF9RLYn20rSFt4Zy
         U0pUdKqR2I+xOk7ggvWyt8rb1FnjjUSvoczsV86ogVTdzlaYk4Cl7vt+UfPn2w2sbP9H
         BK7Mi7DLkohmd+hpyy6YX86hHiGSF0ydbESntE2KSy4ppyiLq8tn2O5d1HLsh+mUmSA4
         taZ6RY0UUh7J0R+XAOqQSt3zUycRqzGPXwRoTCa0r3x2VWr1pF/M5IfQWb+fXfpVcu0w
         XUECFYT95VjtPbxE3eHXTldfXBf78WLfY9wUGc4gZNny+DFd6dE97BKrxQzsobGGMYQ9
         LsoA==
X-Gm-Message-State: APjAAAXDiKMOfxqG+rRiPs2TNe1onBh6zmEZp6/IjjzJ4XrRB/X3yEu0
        G0nU4PhlJm52AnYAVOAkB+TOWoHc4gEhymF8AajEafowK9o9q8+FM+igBKS6ECE3ybGCRSeZdLL
        HsH4AJDLgSXYMB6UswYc=
X-Received: by 2002:a5d:5007:: with SMTP id e7mr42931440wrt.228.1582207715416;
        Thu, 20 Feb 2020 06:08:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqyw0NL4CfkVCvHhL8BV6jD0BLn6ZRb0x1FWrOTy5dsR72Hmp0fM/ZUPGXOTxrdPDBTx4bQySg==
X-Received: by 2002:a5d:5007:: with SMTP id e7mr42931423wrt.228.1582207715204;
        Thu, 20 Feb 2020 06:08:35 -0800 (PST)
Received: from steredhat.redhat.com (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id 133sm5010574wmd.5.2020.02.20.06.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 06:08:34 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH liburing] man/io_uring_setup.2: fix 'sq_thread_idle' description
Date:   Thu, 20 Feb 2020 15:08:33 +0100
Message-Id: <20200220140833.108791-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In the kernel we are using msecs_to_jiffies() to convert the
'sq_thread_idle' parameter, provided by the user, in jiffies.
So, the value is interpreted in milliseconds and not microseconds.

Fixes: 59bb09c553eb ("man: add io_uring_setup.2 man page")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 man/io_uring_setup.2 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index 4057e4b..20c67dc 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -82,7 +82,7 @@ doing a single system call.
 
 If the kernel thread is idle for more than
 .I sq_thread_idle
-microseconds, it will set the
+milliseconds, it will set the
 .B IORING_SQ_NEED_WAKEUP
 bit in the
 .I flags
-- 
2.24.1

