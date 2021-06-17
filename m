Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16813AB9BC
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 18:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhFQQcI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 12:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbhFQQb4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 12:31:56 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D82C061574
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 09:29:47 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id i12so5853105ila.13
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 09:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kbuRQxrtHS6GQ1BP/HG4wNbGvyIaKVlpxlEeJ0jbSTc=;
        b=jj+3oARFhLligUnuhr/O+nZSWTYfW4Z3Wy/Y8KVKaX0rIioVJjsruAVhadPw2uhvet
         utKVwviNBpFJi1oXw+Sg+y9enzYfPuR/ius8xBt4h6DXfFmQgyhxWUxD/yGC0Nue3/8U
         B24gvxBKDYJ3Q15cfZD2PaJyzPH/rRhJrsdmh7CpvCL785IgHMvx7kjPqtluLI+0QqJL
         WlcJLVzfntEnlI6wTw0rUjjsTXjastuq6zaJS0JMrbsziL4S5P6FwQn8iB/sPfMdezba
         7zV92fw1l4XWYLGt3VA1ieUdQk6zsuLLDInSqUqP3OdrXWjzX/6HzNRlbVRuIXY6DjsV
         hIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kbuRQxrtHS6GQ1BP/HG4wNbGvyIaKVlpxlEeJ0jbSTc=;
        b=IisAEP6SwLsXxdAgJHnkRDOQCJnDI/rYR1rUB1VNHmy4qnxlQWfHWgaXu0/B2ksTjM
         fxFe1ipaEbhHoMFBKmfx6j3WdUWJv1kCPeRq9TrTPaqxoEh33qfgXerheOcfGXGqU+Pj
         hsdfcignmSLuEXX8fHBZHsu8MexpMfCtCInFv11fZz0Y3W/8F0wOeT+4OR/4GX2Zk1PF
         +g2ZtIb79IUmKmDy+u8Zn94J1e/zaW4DnXGCGK3gmkdSu6rs9f7G0jzj6YyvWy4bwPOB
         ZrVQVH6mRlvY2yXUqb8+2oyiabCQQUNHbtV0npYK476VRmwp0Qfosy3JjT4XNr31fmUE
         e/Mw==
X-Gm-Message-State: AOAM533xsQGVfvr4hIci10gu1fQ8izX6M3xfDRFzBbzjHl94JXb25UVa
        iBFLJw65YMpS5+pHVSUBuzpTI2Jk0DmuXn93
X-Google-Smtp-Source: ABdhPJwzMhMypIgKR2BeSY2pIX8uziTrOPAtRfo3VJAqnX7Iig5IV/h1G5R6R4tEwHqh09ECixrfsg==
X-Received: by 2002:a92:c5d2:: with SMTP id s18mr4238728ilt.127.1623947386641;
        Thu, 17 Jun 2021 09:29:46 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b9sm2856359ilj.33.2021.06.17.09.29.46
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 09:29:46 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Allow io-wq user configurable CPU masks
Date:   Thu, 17 Jun 2021 10:29:42 -0600
Message-Id: <20210617162944.524917-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This adds IORING_REGISTER_IOWQ_AFF that allows an application to
specificy CPU affinities for any IO threads that may get created to
service requests. Explanation in patch 2, patch 1 is just a prep patch
that makes this easier to accomplish.

-- 
Jens Axboe


