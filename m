Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF501B118D
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2020 18:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgDTQ14 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Apr 2020 12:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728998AbgDTQ1x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Apr 2020 12:27:53 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B445C061A0C
        for <io-uring@vger.kernel.org>; Mon, 20 Apr 2020 09:27:53 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id b11so12952148wrs.6
        for <io-uring@vger.kernel.org>; Mon, 20 Apr 2020 09:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=O+WplOik87VxRZXMQTnlXVOMgELplUpLySghY0PPwj8=;
        b=uO1l8267mVWK/rU0q3IgGyhEAkf/DNrU5RyxuhxOmSwpnzU3tWFFnsI0IDDoY76xZD
         J2PrxBFgfwuZoq4TJSQz+kHp+29rBkVZYK3ZmJXq/Etn1oALzyrN0E9ciObXUVJKLyD3
         qoJ+YPvADhb0S7bzmkqnOzIFnVLOyeraprnmQ1xfyvjkTJPhTpIeN/asWixfI3z53GHo
         DWoMOjc2yB+rD6fKYwSAAwEUTssMZr7IZgiITpI2HFFp0n0qgNtqH2J+M+xUJdEwAmdX
         MdRF+jJmbt4BpkJhQdAYateoTtlIIrzocgS6GgkqwTnS5ID3xhHt9wMtl5BvULpZOF8c
         HYSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=O+WplOik87VxRZXMQTnlXVOMgELplUpLySghY0PPwj8=;
        b=WOTnUMp71FRYueV0PiHM8cgNVKSOmxPo7xkGtW15oabP++1cubVS2yD0yAm7CDoGN3
         i5g5t9LoLNPdPpoGxlLrwlb9nJ5T0L3O8YKfoz5fQZTTjBNED4F6TKHpFflJQYOpGCyv
         05+W7t2PVHTxK5jnRv1ayrJGrNAEcKhXHYGNJ+R/LdL/njosFxSTePMAq0DpOra3aJjs
         5uISmCKVjQW6vr+y77IxUzsnA03LpFMuyiofKTw90fwUFwWP11gAqSxx4ajjOKU8oi/r
         oH9kSbW6aIrRXKJWsZJfCjHiFtXRX8jSWdvHPk8hC0g2AYdgGHbGPNx6EB1/F1WuRrwV
         nslA==
X-Gm-Message-State: AGi0Pubo5iDR7PgprpT7JEHOexhBtKYPcnbrqjgstXdNVLuxmfLvh8V1
        zIKKjP2KvsUxy7DcEklmgVJCHL4Wbs4=
X-Google-Smtp-Source: APiQypJ4ax65Tn1JK0VrpJ9Hbxl0xEyKxZHGEFdhlE+FRrbDRa3kXzMGhwmX/35fGQCc7QyWbgeDBw==
X-Received: by 2002:adf:8441:: with SMTP id 59mr20476989wrf.237.1587400070918;
        Mon, 20 Apr 2020 09:27:50 -0700 (PDT)
Received: from dontpanic ([2a01:e35:243a:cf10:6bd:73a4:bc42:c458])
        by smtp.gmail.com with ESMTPSA id s9sm19054wrg.27.2020.04.20.09.27.49
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 09:27:49 -0700 (PDT)
Date:   Mon, 20 Apr 2020 18:27:48 +0200
From:   William Dauchy <wdauchy@gmail.com>
To:     io-uring@vger.kernel.org
Subject: io_uring_peek_cqe and EAGAIN
Message-ID: <20200420162748.GA43918@dontpanic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

While doing some tests which are open/read/close files I saw that I
was getting -EAGAIN return value sometimesi on io_uring_peek_cqe,
and more often after dropping caches.
In parrallel, when reading examples provided by liburing, we can see
that getting this error is making the example fail (such as in
io_uring-cp). So I was wondering whether it was stupid to change the
example to something like:

diff --git a/examples/io_uring-cp.c b/examples/io_uring-cp.c
index cc7a227..2d6d190 100644
--- a/examples/io_uring-cp.c
+++ b/examples/io_uring-cp.c
@@ -170,11 +170,11 @@ static int copy_file(struct io_uring *ring, off_t insize)
     ret = io_uring_wait_cqe(ring, &cqe);
     got_comp = 1;
    } else {
-    ret = io_uring_peek_cqe(ring, &cqe);
-    if (ret == -EAGAIN) {
-     cqe = NULL;
-     ret = 0;
-    }
+    do {
+     ret = io_uring_peek_cqe(ring, &cqe)
+     if (ret != -EAGAIN)
+      break;
+    } while (1);
    }
    if (ret < 0) {
     fprintf(stderr, "io_uring_peek_cqe: %s\n",


Best,
-- 
William
