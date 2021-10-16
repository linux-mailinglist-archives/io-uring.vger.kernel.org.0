Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA11343058B
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 01:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbhJPXKH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Oct 2021 19:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235614AbhJPXKH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Oct 2021 19:10:07 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4E7C061765
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:07:58 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w14so53605725edv.11
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SkGJXre3eSt8WixNFOpZnoQExEG/OHkac2IYm7ORg/c=;
        b=qK0Ei4EQJavksOmF7lVGWCAfchS5kWWLsC3A+n2o2/3UDZd+sacb4FIolAFUmN3KRs
         p/XMl1Hxy9/vJ+v336Ao/0B9qJtEhpxvOBmDYHnALCGXDDS1sUvRYxUYfr22H/lDLfM+
         frkLJrkRV3QRIPnBQTWzooWIoHU1GXN+L/O0kT3uLUPmqkyGjIffbmXZ1JTbROv0IOey
         rna9L/2mthRsddSgkBNgu6Y5FFQQUf1i7cJkp29Aa6IhA7UkOcg9V/sjlF2Sd9AK47Pm
         46dP8JCL2/3aZmoL+UtdbHweW5v5LSAsKQHUpnrBoxQjrWDXSaPYNnKp/4i8ZOiutLx7
         L6Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SkGJXre3eSt8WixNFOpZnoQExEG/OHkac2IYm7ORg/c=;
        b=KargpUsfm3uQ7XY9b1hLWt9TCSaAwx5VTuuB1qWlhEZZ/aIIMndd3Pk8jNKKOukw8r
         aMhUj6E9Z45T+Z86ZPabp1NiFC1DXuH41JMf3BJxQvuIt1YfKM2YUjxCsIxFTiyIffrq
         EEPVkI7OZM9O9H4j+wVjGVKzGRGunCnLZt5jNNCMPz93hxqzicT4nwVf+DH0LrFOSxx/
         T8W5voblLtw52PVvQ4+z/2erYMIMryon9ZJvvzq6ZWLH7T4rPzl68eRO/nKvOfDubIFx
         odgiSdMv5N+xFwUYfClPj6ljXUgnWyQyCr6P07IxzwbCFX7ffShXrZ5GupDovoH9CNco
         1H5w==
X-Gm-Message-State: AOAM533Bs3Wz/pHTC/XRO+yv8rrUOeb+npeieFXa/pqZavFJ/iNkvwmE
        TcsYwKVHhadVIX2xR4kiClC39ttwr37++w==
X-Google-Smtp-Source: ABdhPJyRXECY1nTtfHf4yz/RjYmvH7hxFLaEOPMA9/vRao87kvSHaBKrvIcE85ojTEG7FGNgmzj9Jw==
X-Received: by 2002:a05:6402:1d15:: with SMTP id dg21mr31050221edb.96.1634425676598;
        Sat, 16 Oct 2021 16:07:56 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.201])
        by smtp.gmail.com with ESMTPSA id q14sm6791217eji.63.2021.10.16.16.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Oct 2021 16:07:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/3] rw optimisation partial resend
Date:   Sun, 17 Oct 2021 00:07:07 +0100
Message-Id: <cover.1634425438.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Screwed commit messages with rebase, it returns back the intended
structure: splitting 1/3 as a separate patch, 2/3 gets an actual
explanation.

Also, merge a change reported by kernel test robot about
set but not used variable rw.

Pavel Begunkov (3):
  io_uring: arm poll for non-nowait files
  io_uring: combine REQ_F_NOWAIT_{READ,WRITE} flags
  io_uring: simplify io_file_supports_nowait()

 fs/io_uring.c | 88 +++++++++++++++++++++------------------------------
 1 file changed, 36 insertions(+), 52 deletions(-)

-- 
2.33.0

