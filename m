Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A481519DD31
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2020 19:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgDCRwu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Apr 2020 13:52:50 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:32949 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgDCRwt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Apr 2020 13:52:49 -0400
Received: by mail-pl1-f171.google.com with SMTP id ay1so3004181plb.0
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2020 10:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6jXk7OKJMs75UMg6HGOC66c734UHXBzUrgbLZ2lU3fc=;
        b=rMtV62bPyITUXi+V8XkDbE0CrlLDTFdfuBCkXKvOjpUsIR9sUgD/nvD1iFjXP+GDRs
         g8Bu4HE9XT9Q14rqza8iw6Y0VgLGFqBb14L/NQhprDvNOad+EYyVhhNelCJWCgUty+HQ
         tFfDT5Ye8PJMKrTbsqtzfCoUtuZJ/3z05HdmNgHjz61oXiAbeuajWvYzSdtPeWHYhMPI
         YaI9guUrtTx3hEMMKMvEgLylwxNIFa5n3pMKKPwNFrPZ1nw7TLASzz42hJ/WQNXBhxa7
         duz+2Cx/YmXsa56Iv9es8kL6L6RmbDMVCCyHdKUr44Wodmc1I+Awvtt2A3fpGpUZszgX
         9rOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6jXk7OKJMs75UMg6HGOC66c734UHXBzUrgbLZ2lU3fc=;
        b=Sd4L9/jlbp6p7oeS/nt3VFFYAtBsuVE00/dqnudKojJxnCI2S7YUBuW92tSutvOdF/
         PKGCxF9ZjbyLUhdBdr2LAwaGwYaNXByu5JBeIrpBOwKgPikHgnfb6fMfORT+ARhnwwZ8
         vhU0fTp2guU8yG35ROI0tYUL4x96wPowrGQdus1uE9b2hesMHk4rWuRGNUgQa0X9D2DO
         ITokhnxsPOSo6EVv/upWYhy14BWQleYHhFfbvTajkXiDRKkLeTkEKd7GQ4arfqMZMtc8
         omiza5Xk9m2Byw3Q0ptWlTgC1nbfVEKa1ZHRviyDmyCoIfuE3Dp4Vp4nJYb2qunBdprx
         g9+g==
X-Gm-Message-State: AGi0Pua5W0GXzmPk2Zfyk9F8ltNGSmDcsfuxHQlY0GQ9SVg1JsrEY9Gj
        hxXRU3BEoojBCYU3jNCdyrBsJ5uB8+guIQ==
X-Google-Smtp-Source: APiQypLin3XXSzXs3T/mqviYjAc8oo0td8pWiTsU5C1mxXecg03NlRTRPPweDHV4qOO5V5FEnk38ww==
X-Received: by 2002:a17:90a:8085:: with SMTP id c5mr10155895pjn.186.1585936366655;
        Fri, 03 Apr 2020 10:52:46 -0700 (PDT)
Received: from x1.localdomain ([2620:10d:c090:400::5:8ed0])
        by smtp.gmail.com with ESMTPSA id f8sm6168449pfq.178.2020.04.03.10.52.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 10:52:46 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] io_uring fixes for 5.7
Date:   Fri,  3 Apr 2020 11:52:40 -0600
Message-Id: <20200403175243.14009-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A few fixes for the current branch, that came out of memcached testing
on roughly 320K sockets with the revised poll scheme.

-- 
Jens Axboe


