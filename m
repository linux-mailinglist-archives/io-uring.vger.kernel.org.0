Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D67399A02
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhFCFcW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:32:22 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:38456 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFCFcW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:32:22 -0400
Received: by mail-ed1-f52.google.com with SMTP id o5so5654022edc.5
        for <io-uring@vger.kernel.org>; Wed, 02 Jun 2021 22:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Jr8ge50O3OfzWtwGpJaH1oYEn6Xwn5e/6+p4zm+Evw=;
        b=sQ5Gogc0A6uORzerWQpGxKMgZW57lR4h563Z5+532KpbfAS1of/76bqtjQCW25GsGx
         VxctwGp1o0slrhLNKS98Z7xzx/pwv7+wLceZnRi6JXV1skqKKhKXv44sQI6XLK2M3O2D
         xBGR9Rf5KFkVe0CCBob8BSYNeoNmwBKNZqZsOq60YXv00iT40Ud6LGKjG0dR76poY/Lz
         cQxlsVYlHhaAtF5I3UKxZzQUUNvDCH9KUwt+YOySqqh+vVBTZBHnvUwVqYQvJS4iUdk3
         ShysTdMloUT4xtJhV/kQ88DJMsVQvAikSydoztD9YlsIqYUmhIthmd13OxB5J/7QoJaW
         Zvpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Jr8ge50O3OfzWtwGpJaH1oYEn6Xwn5e/6+p4zm+Evw=;
        b=VzwbAIcte+YwvPxBiE6zn1J2L2oBpw4D+jHDWzSGRSnD3fJd7adGZxpNW8xXrpFIrm
         1Vmh4zX/tkgs6cwXY59e0Hc+hoMJvx1x7i+9pxYUuN5SYp+kxUQHt76OQFXJ2JlyJ9aw
         FbmZp+7StMrlPEGMyoJ6GUrWuYFkgiBN2xbBi9XgvRqzyU52v9wLa38/cXDZsaNNfdMs
         R4zvX4bFQEMS+gciLm13Hj1ztmFFMJcusG4coFFXV+ia1sEbq9vYZZWqi2lfgLINcpcu
         YzIhkbtKNa3SHTV0aD2kpzb6mmi3USxJ6lFc4C5v1PnrpkXI6jVzsj36ELuwmFYhYJSt
         rJ2w==
X-Gm-Message-State: AOAM533gljdVfiTQp04VtLAMFixXEpw2o3TWUAFZwDwvAR3YDO/D46UQ
        fDSz51D6wudFxBKexCfqyHo=
X-Google-Smtp-Source: ABdhPJyxG85wHCUIAjZqtyJz1GmpSf9xfOkyOVnUa/Wz9mCsk/E4YBroG2pYaRuKzNlaS8isEvOSEg==
X-Received: by 2002:a05:6402:3488:: with SMTP id v8mr6681969edc.124.1622698165912;
        Wed, 02 Jun 2021 22:29:25 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id hr23sm943291ejc.101.2021.06.02.22.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:29:25 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH liburing v2 04/11] liburing.h: add symlinkat prep helper
Date:   Thu,  3 Jun 2021 12:28:59 +0700
Message-Id: <20210603052906.2616489-5-dkadashev@gmail.com>
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
index b7f3bea..e033543 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -554,6 +554,13 @@ static inline void io_uring_prep_mkdirat(struct io_uring_sqe *sqe, int dfd,
 	io_uring_prep_rw(IORING_OP_MKDIRAT, sqe, dfd, path, mode, 0);
 }
 
+static inline void io_uring_prep_symlinkat(struct io_uring_sqe *sqe,
+					const char *target, int newdirfd, const char *linkpath)
+{
+	io_uring_prep_rw(IORING_OP_SYMLINKAT, sqe, newdirfd, target, 0,
+				(uint64_t) (uintptr_t) linkpath);
+}
+
 /*
  * Returns number of unconsumed (if SQPOLL) or unsubmitted entries exist in
  * the SQ ring
-- 
2.30.2

