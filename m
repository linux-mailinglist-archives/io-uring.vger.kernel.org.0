Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B4D399A07
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhFCFcb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:32:31 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:41497 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhFCFcb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:32:31 -0400
Received: by mail-ed1-f52.google.com with SMTP id g18so3642956edq.8
        for <io-uring@vger.kernel.org>; Wed, 02 Jun 2021 22:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8zpHJmKsAzKzcTUEmLn8QUg49fDq/X/mkXl2iRO9pl8=;
        b=s7bF4fn54mWR/VgS0hGIjf82DpNqK5dZnsRFlsf0IM7wlD1924Vp/IPzT/ID/XGREu
         CdheOERKAuXxkaBft8bqHkdD1+ts4nr0EGqFqioYsx/89uJ6UYsZiWHGrLgyQfEnD0cv
         MXSg1fMblK4hFoPrLaAfzqp0O99d21Pi4Mn5sUHYZsdjuggYFQTHyLXMUOO1urWT0FIM
         HX0qYdH9wxWSOayJts5vQExzxKyBPswewYIEM8F0uE5cx6IQGMoHXxO5rELr2QL1R+RT
         AMY0pJE2v/Cu3x/rE07Vk+7O5ImL15UMpuKCfQz/rsN1nBnnXs+Nzix7s9M8WfdFkpAA
         JQuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8zpHJmKsAzKzcTUEmLn8QUg49fDq/X/mkXl2iRO9pl8=;
        b=VsqVGtBhM8xqlTU5a8Nikr2hTUookzgdm8nMG3TtNdvq548ZLFfiZW9Di05rzfna8V
         9Yt9bHsOCOLvq3dx9L2QMi2FEVRmstJkRnKDBkoQ/wxmU+cHd54RBTv/oLtK2d/K3EA9
         bKsnLcWZJa2RVUzLj4UwaiiynrGGwrcrPb/pivdt/kRj4oz5dUVWz6ltGzIxDn2nAov6
         3KY0B3krkTIcwHwRSDfMC2HZ0EFhn3vSjAsouHYM0IOvDXLPafQbVWU8GxYwkblA5viF
         FpJRzo80FJZgPaSJOc9EIJTZiLjJ+vpRidhRtj+WtfsH9fAEirjcgdBta+PmEWbE3idC
         z/rA==
X-Gm-Message-State: AOAM5333yvWveIxoXZKhirmkgdPE44zUWk7fWnxXOGKGyIuOYa+kLbQy
        c1Ju9ug1MDN35BV1xf0nRmE=
X-Google-Smtp-Source: ABdhPJzaasonZ5thcv3fBQcRjyuzpJ64ZNtSO3VxNnN7YwEj5Elga+NgMv/eie+ycuPWJz4GUyhkpA==
X-Received: by 2002:a05:6402:2791:: with SMTP id b17mr360751ede.44.1622698173537;
        Wed, 02 Jun 2021 22:29:33 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id hr23sm943291ejc.101.2021.06.02.22.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:29:33 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH liburing v2 10/11] liburing.h: add mknodat prep helper
Date:   Thu,  3 Jun 2021 12:29:05 +0700
Message-Id: <20210603052906.2616489-11-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603052906.2616489-1-dkadashev@gmail.com>
References: <20210603052906.2616489-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 src/include/liburing.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 51dc602..c6ef0e8 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -570,6 +570,13 @@ static inline void io_uring_prep_linkat(struct io_uring_sqe *sqe, int olddfd,
 	sqe->hardlink_flags = flags;
 }
 
+static inline void io_uring_prep_mknodat(struct io_uring_sqe *sqe, int dfd,
+					const char *pathname, mode_t mode, dev_t dev)
+{
+	io_uring_prep_rw(IORING_OP_MKNODAT, sqe, dfd, pathname, mode, 0);
+	sqe->mknod_dev = dev;
+}
+
 /*
  * Returns number of unconsumed (if SQPOLL) or unsubmitted entries exist in
  * the SQ ring
-- 
2.30.2

