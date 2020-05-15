Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98751D5662
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 18:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgEOQnm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 12:43:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38899 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726246AbgEOQnm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 12:43:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589561021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=enl1W2uIu4fZuLT8iyT7NS/nMICLBarNGTfzsJ5XBJ0=;
        b=dTAKL6clOQZ6Q+D+nhoOK/TH2/Lh1hXs0WMny2GQ64Li8IX+c6Euj+0+cPUXpbe2qOBMIO
        6xvoNLzljIs5dvMVybvdwSizRNmdbg3K3sX0rkIo5gj19fvkscLhR7SEUC0eCDEyAp9Vhu
        6r65QJ39EQ5TJsnffPtamY6uTnmC3/U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-I0Loyw3cNC-WrQjYANIuAg-1; Fri, 15 May 2020 12:43:37 -0400
X-MC-Unique: I0Loyw3cNC-WrQjYANIuAg-1
Received: by mail-wm1-f71.google.com with SMTP id u11so1236250wmc.7
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 09:43:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=enl1W2uIu4fZuLT8iyT7NS/nMICLBarNGTfzsJ5XBJ0=;
        b=CngyJQh3UfY/IYj0eAgIgi++90wIMl39DlhcQpcxaCgA2Ehr9z9dxvlrdwTsjfJP7X
         5AdnUHbm+76cVX5DdNsTazaUOpJKgDqVC/eA/MBeropBGiO14MmCl3ys6zvyteS5foV+
         4TYVmrt0v9dQUTCsmOhhF/2X+FxjS+W8QhJ6rs3LAl45q/aIk+8BPyZQqRti4C+0kBRV
         eWbRjnzSA3ySYSjUPOiFxWixxxbHK6qUoIHgVAQvnbMVdUcA6vvtkujQOHr4FrF1yXVg
         UE8aE3nNn2DMd8jbzdiZY1pt/r7jvh7T0Kg1Uusy4txbAY2O4K0vwXmqbmT8vTQX567O
         Q9Wg==
X-Gm-Message-State: AOAM531rbyQKHWsCoAABskVXYxazaYBjVXVVcvRTXaUyY4dizboIkQdt
        ZplkJQVFnkIPhrFJkGDwGyoc3Zi801Tmr4MBPe5FXvnBSuaE+OZdmo/NpMJEj9M0hJ0Yumedrsw
        RgJTQE1Ym4PMiNDVU5M4=
X-Received: by 2002:a1c:ed04:: with SMTP id l4mr4987110wmh.93.1589561015724;
        Fri, 15 May 2020 09:43:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkOAks95htd1wI4Q7WDHz0wED8tXZucCBKkqycTNQVsSclhprEd7iOXb2jbnbwGGaJOjtB7A==
X-Received: by 2002:a1c:ed04:: with SMTP id l4mr4987083wmh.93.1589561015481;
        Fri, 15 May 2020 09:43:35 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id v126sm4512322wmb.4.2020.05.15.09.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 09:43:35 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 2/5] man/io_uring_setup.2: add 'flags' field in the struct io_cqring_offsets
Date:   Fri, 15 May 2020 18:43:28 +0200
Message-Id: <20200515164331.236868-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515164331.236868-1-sgarzare@redhat.com>
References: <20200515164331.236868-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 man/io_uring_setup.2 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index d48bb32..c929cb7 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -325,7 +325,8 @@ struct io_cqring_offsets {
     __u32 ring_entries;
     __u32 overflow;
     __u32 cqes;
-    __u32 resv[4];
+    __u32 flags;
+    __u32 resv[3];
 };
 .EE
 .in
-- 
2.25.4

