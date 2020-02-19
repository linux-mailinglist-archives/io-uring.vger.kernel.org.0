Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D52164661
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2020 15:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgBSOIx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Feb 2020 09:08:53 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:37952 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbgBSOIx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Feb 2020 09:08:53 -0500
Received: by mail-il1-f195.google.com with SMTP id f5so20684670ilq.5
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2020 06:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4iOSY81duV/UvWbh1sNcjABYOc+p+AYnaeRpyzduwgQ=;
        b=1TUCm8l7sKwZZ644EQSO+ShplDSXCzCUKHMJkhV2WrVII4UGIrSRUg/1C0RrQqtm6v
         DMxwzCo178rQIOUz2mt6LeGpealD9JRnp4Wu3WHMCW7IVDC9f7vyEivd/nd4heGEVI5Q
         5e+DudCw3Y7UJURSwvjK8ZzYRaCvlxRUZhxPETW4tp0yUJeuMJuUjKruyd+3EXGHxOUN
         dyHDnXJCtu6kxYqb1qfeeI+mSm8kImG70MfD0ZnDPD52lXxjhO8fwIKmfnvajOKntrbe
         qHSOA5AEXuRQXgL3fCbFVds6ocNj/bpcHUvnc73wk2X+Toh90ytDPP+yWuJzJGqbyxgP
         8Myw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4iOSY81duV/UvWbh1sNcjABYOc+p+AYnaeRpyzduwgQ=;
        b=FbQwfv8upz95Rn/UduAWflWgsA7u6TKaFL2+01bPek03c/bapvI32Gfz3BvFTvRr5d
         Pw5PdZclGfuhnx3dmFTXaGzN54RYiFZfqNy0pCxbf8KjetFipnTlzsHTT7P+sGx1Vj3H
         2yDUMaqlMjUdKWiBRxcS+jOU8U3sSG+/kElyJjaD+BuuqJgbuxKtR0E+4CPhcWEMHCla
         /k3lcJ/hnJe+WAJtKRyCjKWtf+sePijRw3ooFf9kIeWH1mhSREzHiyQ/vCSb84pxyOvW
         wsE3YSmwO1SG1X0U/L42oufV9D5OTVYI6UR7iS/P7fsbpdfib2nNNFEA+P8Wl2/SU1cS
         wnPw==
X-Gm-Message-State: APjAAAV7ZgBezSGDeWLfqsnI5BaHW1PwXVfLIzy+awUR6m1zgfiRHN5O
        b0tyG/NPOQTMcZTlrgAcpalQ8rgNGBaYBQ==
X-Google-Smtp-Source: APXvYqxqcXrCLOC+f8zhAK9jGotSKmpSBUEFMNhUEovLAQtccE/dc3WFwjs6PpOHv0o9ZihY+A1pug==
X-Received: by 2002:a92:350d:: with SMTP id c13mr25074654ila.205.1582121331838;
        Wed, 19 Feb 2020 06:08:51 -0800 (PST)
Received: from trueserverstrongandfree.hitronhub.home ([2607:fea8:8420:a85c::6])
        by smtp.googlemail.com with ESMTPSA id a18sm784151ilf.43.2020.02.19.06.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 06:08:50 -0800 (PST)
From:   Glauber Costa <glauber@scylladb.com>
To:     io-uring@vger.kernel.org
Cc:     Glauber Costa <glauber@scylladb.com>
Subject: [PATCH liburing] sync io_uring.h with newer kernels
Date:   Wed, 19 Feb 2020 09:08:47 -0500
Message-Id: <20200219140847.2847-1-glauber@scylladb.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Essentially adds the IORING_FEAT_FAST_POLL flag

Signed-off-by: Glauber Costa <glauber@scylladb.com>
---
 src/include/liburing/io_uring.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 424fb4b..d6e7f3d 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -204,6 +204,7 @@ struct io_uring_params {
 #define IORING_FEAT_SUBMIT_STABLE	(1U << 2)
 #define IORING_FEAT_RW_CUR_POS		(1U << 3)
 #define IORING_FEAT_CUR_PERSONALITY	(1U << 4)
+#define IORING_FEAT_FAST_POLL          (1U << 5)
 
 /*
  * io_uring_register(2) opcodes and arguments
-- 
2.20.1

