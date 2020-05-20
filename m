Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFFE1DBAB5
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 19:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgETRHY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 13:07:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31334 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbgETRHW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 13:07:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589994441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=enl1W2uIu4fZuLT8iyT7NS/nMICLBarNGTfzsJ5XBJ0=;
        b=HKN5cKwh2Q8JRPbGvTBX6T8Ec1ueBvnd//Saf8QnSci31tzVqX5024kpF9nE17SqNypXWm
        YCEHMefFUy1LPf1V0cST1jC9dghDweDL/yjb5KvgspKqYkjd4u/H9vrzNg/iHhG0+ylZ7s
        7UKqC1WSN9KEABMqPjvrFGBiboCfwy0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-YpOvpHrnOCO07kVZFOiubA-1; Wed, 20 May 2020 13:07:20 -0400
X-MC-Unique: YpOvpHrnOCO07kVZFOiubA-1
Received: by mail-wm1-f72.google.com with SMTP id f9so1501369wml.9
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 10:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=enl1W2uIu4fZuLT8iyT7NS/nMICLBarNGTfzsJ5XBJ0=;
        b=uU7BdiCMnDU+eOWP69HJAMq67nXaSRBjVGsUUCBLpaBr93Nocm2H0Y4LJH7RQYQw4t
         bchYt071uZcoeo6+aHSUUgbWKuQHhWUP2jQweWkJVzcpYH/9ScDkGiRCEAcwDOgNvxeb
         AL2lBUbkwZp6UYEBg6N6VXBDcH06nF4H0a8ypo8AjNMico3y4QcdrT6JiMvSP/gOZNam
         HKL8SRhVzjgMijjVUGf5GPTGmuIjFG+Dai2NaM5DhCLtbjmIbtvwlXTxonSNWOdx3y1m
         FSEKwcBFJK/3PkDU0PKYTyT3HbQPOl2H6s0mfoBh53z27FXD2gEPmU+0za1cBzTnCKYh
         DJVg==
X-Gm-Message-State: AOAM533m/XIGGsKaiaKgOTPPIqf092iMPSgtawUM/aZH9TKD5NQyH2Qd
        y50GrrdDDxZyVrqB/cSDeddRqJiKtIGPxu40P5y3Ag3JgRCoNeyU2OKaRYWsycyvekTYKB5kSQQ
        OupuWi8uFhQYO+8oMZuA=
X-Received: by 2002:a05:6000:4:: with SMTP id h4mr4863658wrx.36.1589994438801;
        Wed, 20 May 2020 10:07:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/oL0fpnDNlWDRl/DQpqVURE2ukinpGD7z7G2S6eeKrBlnPSAq1QGG74sJXqhvE+E43M0SYg==
X-Received: by 2002:a05:6000:4:: with SMTP id h4mr4863645wrx.36.1589994438575;
        Wed, 20 May 2020 10:07:18 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id u74sm3768614wmu.13.2020.05.20.10.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 10:07:17 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH liburing v2 2/5] man/io_uring_setup.2: add 'flags' field in the struct io_cqring_offsets
Date:   Wed, 20 May 2020 19:07:11 +0200
Message-Id: <20200520170714.68156-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200520170714.68156-1-sgarzare@redhat.com>
References: <20200520170714.68156-1-sgarzare@redhat.com>
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

