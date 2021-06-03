Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9985B399A06
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhFCFcb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:32:31 -0400
Received: from mail-ej1-f52.google.com ([209.85.218.52]:46997 "EHLO
        mail-ej1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFCFca (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:32:30 -0400
Received: by mail-ej1-f52.google.com with SMTP id b9so7271937ejc.13
        for <io-uring@vger.kernel.org>; Wed, 02 Jun 2021 22:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=922+0SHma63mC5pf16SoGCDWunW5qXVhVZbitU/yv/0=;
        b=dX+7Ssy6koYQcmrlQJ7Bx0MuyzLNspfAmkiuN/CCTmu6F9iLFsKoXDQKbS1/Jf2xUp
         HQewS246TdEoEK2pLaIj5G0BNFxmcMlJpOXq935NS1IGfm+17nkynHJ51M21E4UH9Orp
         PlwLVIfVK3eFda4+A0vHUboN1aM8dAospcVBNP3QPewr2xSb4A/hXTXYAR7xmvIQFaKx
         yqe2vUtQnGtTHVguRCzi4B6CDfkCQlwb6r7ILGOx/L8dHP8CPNKXqH4VMQ5K5Iy5VgY4
         1sUGzJiCZWVivEwekHDQQjJenVJptLQcj8m0v3Lv+IEpCmsaKWvIvnnwsP/EdL/1da+u
         F/gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=922+0SHma63mC5pf16SoGCDWunW5qXVhVZbitU/yv/0=;
        b=eoMhtyYKEpYnsnvjF97eGTtcdovzvD9WMpuz4QQVky7ceiTHTNnJZ1W80cbQjKYooU
         +7RQL4V3mp0blwMdTUVFoYik+NbKsiXhsFgUTQV2UZOLRygctrqPp/dVc+U08ISxHqY8
         XetxFVKxhqiy6pGWp7JFwGQQrR6ljFtm/erouNOhbM31wVUjjZnpl26y8dQme6ey0wBG
         Az4OEDDu37nXBKHXSlPxZ6bshSlwsTLZUjyom7clNY9Fpf+N8PDhvarkGKDf/v5pTO9W
         +NPcvwqq38CSunrVbVTL+zmncwS/p6xnB/gxEuvXQrPAHmj7PwVf7EACgcEktuSKmUy8
         SqyA==
X-Gm-Message-State: AOAM531gSigiLJT7YpV+6aMwRRAvXfXqUefSt6VczPE4RllM9cmHbwWi
        0lLbAOZWxNU+Y5JEkhTMaEQ=
X-Google-Smtp-Source: ABdhPJy1X/SoIWpcxS6acpnaX1wC02xLwO/ZtXq82x2LuYaqXforLfylZgngaaszSPLTBiNFYSm+4Q==
X-Received: by 2002:a17:906:5f99:: with SMTP id a25mr17139115eju.45.1622698169663;
        Wed, 02 Jun 2021 22:29:29 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id hr23sm943291ejc.101.2021.06.02.22.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:29:29 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH liburing v2 07/11] liburing.h: add linkat prep helper
Date:   Thu,  3 Jun 2021 12:29:02 +0700
Message-Id: <20210603052906.2616489-8-dkadashev@gmail.com>
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
 src/include/liburing.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index e033543..51dc602 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -561,6 +561,15 @@ static inline void io_uring_prep_symlinkat(struct io_uring_sqe *sqe,
 				(uint64_t) (uintptr_t) linkpath);
 }
 
+static inline void io_uring_prep_linkat(struct io_uring_sqe *sqe, int olddfd,
+					const char *oldpath, int newdfd,
+					const char *newpath, int flags)
+{
+	io_uring_prep_rw(IORING_OP_LINKAT, sqe, olddfd, oldpath, newdfd,
+				(uint64_t) (uintptr_t) newpath);
+	sqe->hardlink_flags = flags;
+}
+
 /*
  * Returns number of unconsumed (if SQPOLL) or unsubmitted entries exist in
  * the SQ ring
-- 
2.30.2

