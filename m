Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82191DFA87
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 20:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbgEWS6C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 14:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbgEWS6B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 14:58:01 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B165C08C5C3
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:01 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b190so6756626pfg.6
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DT9kV8IQxC/D+uhFJsefv+iJT3TxYB4ReZ7s4ZFOil0=;
        b=a87Bs6xGjaGsCBlocxfqOxy2zUrVZ1peF9M9El8QQmFnxZ4ofnyrA5X/03ZjgM5oMk
         zf0D9gsPh6iz68c+lczEGQM3V/GADtGDtxRQ31jmSVBKL1jK04nvWfXWvIUImNfnH3kf
         iDDUDGAnkjQgjcXuQ6a4VuWuEC8bTOR7qieLkAE391AGwrp2msXuEG5eXaF9F0sTB4El
         xJRLA5INBmlDwvcdz5MRIV2c+bmSNsIetglQf8jjepx0Kkn5lCf+xSkGUABJGpgf9L5C
         7oa9Su9IFvIN+49vDAK5NqyrW+NLNVYtYBXw4n/n1hQuT6+hy/YomwcPhAuxTRqu1mZp
         QD6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DT9kV8IQxC/D+uhFJsefv+iJT3TxYB4ReZ7s4ZFOil0=;
        b=sljkkIKvgXEOeFy0UZ1x/XAxwHJSUBTYbk/oSUuEX68jyA8Ta6uTLxxs0cogqm35Wz
         lAOZoV2Ify52uMRh9fLLMWy4doUdsgw59CLxmFuGeNklGHCsba2niPGQBlC4e5LwU0zx
         oRP2rOwDg87BCPfhZ4Uavq1jMh6Y8SVZd+j0b7PDgn0GKKkJEvRBMSAqcdCHAkOPhDxl
         1QkHU5cmIF+tTWD/DKASVCED7eXSYcQZkDeRJtLsRPJ0C3vtswFAlXpCxaCHNz3a72eQ
         6CEP2SRpcbih1vIS/1dK3aFyYVWJyodNmvsL/e0BNsoCZlQ28RHfaEDPiRAAdWBp42k/
         UzcQ==
X-Gm-Message-State: AOAM531slwD1o1KEPLW/5WemezH6il39YVNfu/zgT+jvUyFghCOGZx1D
        W7z1RHEUxS8sLiOnzX0If4eR7nnu7RL+VQ==
X-Google-Smtp-Source: ABdhPJxn7lC8B7nFRg/yRVy5DZn0o0nXIqRSMuIOyfCbYvam4NLOj1/fhahVe0+8oMsT4fckX4/7FQ==
X-Received: by 2002:a63:145f:: with SMTP id 31mr19792396pgu.383.1590260280791;
        Sat, 23 May 2020 11:58:00 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c94:a67a:9209:cf5f])
        by smtp.gmail.com with ESMTPSA id 25sm9297319pjk.50.2020.05.23.11.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 11:58:00 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/12] block: read-ahead submission should imply no-wait as well
Date:   Sat, 23 May 2020 12:57:44 -0600
Message-Id: <20200523185755.8494-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523185755.8494-1-axboe@kernel.dk>
References: <20200523185755.8494-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As read-ahead is opportunistic, don't block for request allocation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/blk_types.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index ccb895f911b1..c296463c15eb 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -374,7 +374,8 @@ enum req_flag_bits {
 #define REQ_INTEGRITY		(1ULL << __REQ_INTEGRITY)
 #define REQ_FUA			(1ULL << __REQ_FUA)
 #define REQ_PREFLUSH		(1ULL << __REQ_PREFLUSH)
-#define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
+#define REQ_RAHEAD		\
+	((1ULL << __REQ_RAHEAD) | (1ULL << __REQ_NOWAIT))
 #define REQ_BACKGROUND		(1ULL << __REQ_BACKGROUND)
 #define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
 #define REQ_CGROUP_PUNT		(1ULL << __REQ_CGROUP_PUNT)
-- 
2.26.2

