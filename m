Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC508399A04
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhFCFc0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:32:26 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:41491 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFCFc0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:32:26 -0400
Received: by mail-ed1-f54.google.com with SMTP id g18so3642781edq.8
        for <io-uring@vger.kernel.org>; Wed, 02 Jun 2021 22:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=je3ikxifPWcfjm8TZamA1GCv3bpaYO9d4fweVKg884Y=;
        b=HLjrMErYjXIspzXDErTAUwmIFK3C4jdSA1dg1HLsElfJwl+1ViL/SZiC0v10uyEZ8v
         iZY6mDiLCVh6DeIjehcON5PuGvwbb1WgXABLVIHW4fR2jKOcrdnXF9SqUvaXlxQM1n2K
         yB+DHQlitXh9AtDdWDLPHwen4Whiafa+wVG5DHfr1tunXcSP2ZY1V37wKAgiZLLmtD+P
         hXj4THqihy1uSfrr9w6Tu77Vug9L33BmeZYHcVQ+AieKiO+WLINs+CD5sYNgjEOx8zcO
         aYrWuYj3PADAg0pLvf2GSQrkPq1rVzGnj6vCUVNVOGrtslOJXknSCuQUp+K3mJ9wXyAb
         RjTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=je3ikxifPWcfjm8TZamA1GCv3bpaYO9d4fweVKg884Y=;
        b=mSLPmI9pusnGQU1wEs0luOak/eV1SYTXVJ57Olc8kc3gLEFv3CPTqNSKgWZuTtgtO9
         lPYfxrU/uYBYgZYAZet8JdwD6R4POPktOC+4VIjixTEpOdQjFfaBxZqVqazkPxVrM7mt
         wI7o3bfwH5eJOiFsefi5QOWQ2Qgz+IQjHkT9Yycjb3BRI95thXjl1woEFYLNG35uWycv
         0zKs9cLCE51bH8LMbN5A3DCqspVzzAY3qh2B9SIS65gLzAC87/qpSvIPp4IjtSJ0dKU6
         3nuuMuqL7MMNtm3xuIK3fn3SDgClMoJux5q2vI5TLdFL8jG1gxG9/CA0QLn/P7XrM+5/
         eobA==
X-Gm-Message-State: AOAM530iXaU+OOBjMVIZ936x0QAoK4tHDZWEcnrF1wKKC1dYmM5ZpIiw
        O6q6cNKuzWM9pcpVFQc2c4/fonzGR57egQ==
X-Google-Smtp-Source: ABdhPJzB6ttsgeiY2jo1BhWK5cLxXYljReMATqKnABzNvcOIb7EwoVfgFjIBTOCEap3hHayZJUOhzQ==
X-Received: by 2002:a05:6402:35cc:: with SMTP id z12mr41620393edc.154.1622698168412;
        Wed, 02 Jun 2021 22:29:28 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id hr23sm943291ejc.101.2021.06.02.22.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:29:28 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH liburing v2 06/11] io_uring.h: add linkat opcode
Date:   Thu,  3 Jun 2021 12:29:01 +0700
Message-Id: <20210603052906.2616489-7-dkadashev@gmail.com>
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
index 439a515..a5e48e7 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -48,6 +48,7 @@ struct io_uring_sqe {
 		__u32		splice_flags;
 		__u32		rename_flags;
 		__u32		unlink_flags;
+		__u32		hardlink_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -143,6 +144,7 @@ enum {
 	IORING_OP_UNLINKAT,
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
+	IORING_OP_LINKAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.30.2

