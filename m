Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1468C3E4E5C
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 23:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhHIVYb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 17:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbhHIVYa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 17:24:30 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25105C061796
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 14:24:10 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a8so29999090pjk.4
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 14:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PP1ZfPKJqEpeBtzueEvBPGx+FIq9NBPbqy/H3X4n8yQ=;
        b=QntNk8vasegeRQEgvpTa/22T3k76x4N6NKutp80kBdgcUVkChC0EIARzOBzwW2+pTF
         RWHOkH2JqcD39EZC7on8rjGqpdPX4n7U96tyDrhHJNdbW/UtbwTKsiphXId+RsSCBq2M
         V9pjzdJfNYNUpHDrY/I8j2i+vgeukTmTtd2V0MELzz5NmkFOzktEP2fvX3drNNTsgcGM
         MEhMgreQtzoezgOnVZLzJSKqeSn8Q7krYOUC+nkMCosaLumz3slpkhUjvQpRP9Q5Xk5F
         n9L6n/M8KArazCvF28frDqVv6u5OAIAKNul8Xe7zT2MxrsTXBGjDdxQvJBJ4wNdi9IPm
         1Psg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PP1ZfPKJqEpeBtzueEvBPGx+FIq9NBPbqy/H3X4n8yQ=;
        b=D0XTV4cLFmuF9DHj8YmgAFPXCpAIb3NICoxF/VDpEURpcgtJcSTjwo74YNfhdX4D4P
         t4FGVMveClZu0DNInKZpwSH6s9X6RTW+rr3jge+6qAuq58odfVXKEkMyq8y9FhG17BuL
         kmjqAnpbygzvvDOJuGBmdffa7QbuGzrs4k6P78iXdweTqrJBH5mZ9BNVafAME8BB8FEu
         Z3unY34M+GoAswdnFG/evcKxv6pKJUjnQ0ECUdFbWZujMrQBY0GV68f+IqHHGPwaxS23
         XgzNqQmuvDMt2tnRvC8QsmAjVTdj3ZEx0SqBiKJv4IEJTBvrVSF1RdFTSb1tGInz30ek
         eL/Q==
X-Gm-Message-State: AOAM531+kMHchAwM+p4YS/HYHGQ89RE0SDuBE23M9GUNY/RtIuTB6xhb
        eH83YVaC+yncoodudxSy2P0C3cnIkAyvNNfu
X-Google-Smtp-Source: ABdhPJz2rpmsQOTo4zm6VYOkCVmmpOo82fVRnfQFtN14Gdp8qotDxvLXa/X8xd9Ldy6LwtBIipfg7A==
X-Received: by 2002:a17:90a:6a86:: with SMTP id u6mr1099946pjj.207.1628544249468;
        Mon, 09 Aug 2021 14:24:09 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id m16sm439885pjz.30.2021.08.09.14.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 14:24:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] fs: add bio alloc cache kiocb flag
Date:   Mon,  9 Aug 2021 15:23:59 -0600
Message-Id: <20210809212401.19807-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809212401.19807-1-axboe@kernel.dk>
References: <20210809212401.19807-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We'll be using this to implement a recycling cache for the bio units
used to do IO.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 640574294216..2ac1b01a4902 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -319,6 +319,8 @@ enum rw_hint {
 /* iocb->ki_waitq is valid */
 #define IOCB_WAITQ		(1 << 19)
 #define IOCB_NOIO		(1 << 20)
+/* bio cache can be used */
+#define IOCB_ALLOC_CACHE	(1 << 21)
 
 struct kiocb {
 	struct file		*ki_filp;
-- 
2.32.0

