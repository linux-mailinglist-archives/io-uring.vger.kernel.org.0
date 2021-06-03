Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE86D399A05
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhFCFc2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:32:28 -0400
Received: from mail-ej1-f52.google.com ([209.85.218.52]:47003 "EHLO
        mail-ej1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFCFc2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:32:28 -0400
Received: by mail-ej1-f52.google.com with SMTP id b9so7272049ejc.13
        for <io-uring@vger.kernel.org>; Wed, 02 Jun 2021 22:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XwVy3Qz9VPC6MJGsOtNOJ4guTRMS3voj6OLvs1FhaxU=;
        b=esBNqGgwl6OELmRVh5cjRdy0i+fRMEGgpFOUGCGFQ8iam2Ng500uxcHJghQ6P86uTE
         guGRaqMsgDJfNaNSHkNXQaPK6vcdD2zwPUzrKW86IYiYr/aRZaJYPd/cswEyXLLzwOZG
         uDbpJa+DoFVJDM+oozlD2SgJvz4Cmpy+RJrg5aJGcOftxuFzvvm0oFrKnTbk4C7fjBrg
         DGILhD1/6HKyqdU7FdRLi6v7BJedpsMJDd6aLyGu0si9qPUio2WCKK+bFPzy4O+NLdDT
         xICgm25UQDc8MYl6qhyUjXnnpSiACkpWZa7agW12RRQPQxMITChMo6/7z/QGoF1NUAwe
         55kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XwVy3Qz9VPC6MJGsOtNOJ4guTRMS3voj6OLvs1FhaxU=;
        b=Em3B0gL+t+5St/Uddpewfntshj4sxC8Ff2ZDvQZe8i1I60GxIS5MVrMgdtNPVwgwes
         VKswnUP/e0BWQxh2ccZVGz75c6hvBCnQb3lSKDmyot8nxeoZ7IIzMvH2sV4GMURNmcP4
         U8O8/GHa8E6te8v5HcQhTuoXGY6iwJey7gGIbA2NIK6+dYVwj+E+GsoRwLNo6A00VbNp
         vdTpXyd6LaG7djiAMSzF04QBhI0eUtIvmQ/5wI4tEFSKKLfXmIU6A6sAaCQ7mSpCNfyc
         z13mH+/CcftR59FbnM2lMEn1thQ47C+L371y39qmxUQUeduASDKHIgdU1GfC/fShfOog
         mjYg==
X-Gm-Message-State: AOAM532NZ27ZuvhJDpzBE34xHF8TztwNpangos4PuDTi/eXw4TZ0wuEr
        YnmjfWBRzoBc37FqGu312Zo=
X-Google-Smtp-Source: ABdhPJwYoH6rTXxaiTsvNCKJTR7U3OdCpKviipiP6DDTxw83GcPv0nF4xA96AKPUExrLr4ioLJAIlQ==
X-Received: by 2002:a17:906:4e06:: with SMTP id z6mr28079969eju.34.1622698172318;
        Wed, 02 Jun 2021 22:29:32 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id hr23sm943291ejc.101.2021.06.02.22.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:29:32 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH liburing v2 09/11] io_uring.h: add mknodat opcode
Date:   Thu,  3 Jun 2021 12:29:04 +0700
Message-Id: <20210603052906.2616489-10-dkadashev@gmail.com>
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
 src/include/liburing/io_uring.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index a5e48e7..46cd2fc 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -49,6 +49,7 @@ struct io_uring_sqe {
 		__u32		rename_flags;
 		__u32		unlink_flags;
 		__u32		hardlink_flags;
+		__u32		mknod_dev;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -145,6 +146,7 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_MKNODAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.30.2

