Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5B82F013F
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 17:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbhAIQHt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 11:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbhAIQH3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 11:07:29 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BF5C0617A2;
        Sat,  9 Jan 2021 08:06:48 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id g185so11020610wmf.3;
        Sat, 09 Jan 2021 08:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q8d8dG9UCf5e8vbipZsYPEj7r5MDYaj3bnreiQQXGps=;
        b=flzNBu2Q3t3/ImhTptnUpWZq2eOx/8D444lV2HOdKskJiBvPeDRYD15kOiU4YWJuig
         a2s3X5nS7c5Gu0oZ6799cSPGNNhYVL/DNuj6K8u45rZ2OSMGtpibL7htfny+gBGn1Ir7
         2ChwG/1/1TCbzPQMHL+TfEpG3iCnbxF6sZ8AsQ/02eXp20D6QL3CKQRqDDmBkSVfC0SV
         f6IuYJToioYrFrS8j23EyvK/Odm1iOgFzB2J7lVZzbO4RXL0oEFMFsAlNXU2n+23bBVy
         YEfcRNr25KYQJTnYxjfV0xLx+bWyP/gAF04dZSua4crVLyAEMveSQ92gBaEVPLnZzdfo
         HAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q8d8dG9UCf5e8vbipZsYPEj7r5MDYaj3bnreiQQXGps=;
        b=fDhjNFVvismg2ilzciurJ1os2toxyyXDUDRyQrj3lhiDS6Mgc4yyuvotJ+H4tD9X2C
         jg8TKJpfXXn/71+xqK5nY/ln//3Vws5Thbp7kxNw5cFt+VmBatb7iSNbbemAOWU86Hdm
         XK4PtK8l3aSZ/uDYN4dQLNOTjUGMEfArn8WztcdwGVFnKe/vjU8cdqMkSsza4g1Op3PK
         ojIfXcyFxs3yFwsVwT/yJEsIH0lDd4xXJcdbazOqn50Azzu7qKKD/i/HZodQ53I2DE0i
         fMdynDTe3vFWXQziO8s4hAEPuRMe9PsA1Ud2pHtWpQa7SkoAWyE/bLF4VJZftYLry7XQ
         CNvA==
X-Gm-Message-State: AOAM533KEY5/uj+7F2C7l29RxQWtx+UIvDMu/PIMUZ8PUcinUtd/f9y8
        GofKHMdX0rZGATXdSH8ntCCb1OjZHfgL47pS
X-Google-Smtp-Source: ABdhPJzXFJcFemHVSsCyCdF3SY1fQfhQCrpun0BXv+Pm10PNgRweNCoNTn+FNvIFpVE+sVQIwpzbuQ==
X-Received: by 2002:a05:600c:cc:: with SMTP id u12mr7982009wmm.42.1610208407039;
        Sat, 09 Jan 2021 08:06:47 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id j9sm17403866wrm.14.2021.01.09.08.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 08:06:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 2/7] bvec/iter: disallow zero-length segment bvecs
Date:   Sat,  9 Jan 2021 16:02:58 +0000
Message-Id: <4570836cc62137a9ee788d9c820f58ed8efe9b37.1610170479.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610170479.git.asml.silence@gmail.com>
References: <cover.1610170479.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

zero-length bvec segments are allowed in general, but not handled by bio
and down the block layer so filtered out. This inconsistency may be
confusing and prevent from optimisations. As zero-length segments are
useless and places that were generating them are patched, declare them
not allowed.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 Documentation/block/biovecs.rst       | 2 ++
 Documentation/filesystems/porting.rst | 7 +++++++
 lib/iov_iter.c                        | 2 --
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/block/biovecs.rst b/Documentation/block/biovecs.rst
index 36771a131b56..ddb867e0185b 100644
--- a/Documentation/block/biovecs.rst
+++ b/Documentation/block/biovecs.rst
@@ -40,6 +40,8 @@ normal code doesn't have to deal with bi_bvec_done.
    There is a lower level advance function - bvec_iter_advance() - which takes
    a pointer to a biovec, not a bio; this is used by the bio integrity code.
 
+As of 5.12 bvec segments with zero bv_len are not supported.
+
 What's all this get us?
 =======================
 
diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 867036aa90b8..c722d94f29ea 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -865,3 +865,10 @@ no matter what.  Everything is handled by the caller.
 
 clone_private_mount() returns a longterm mount now, so the proper destructor of
 its result is kern_unmount() or kern_unmount_array().
+
+---
+
+**mandatory**
+
+zero-length bvec segments are disallowed, they must be filtered out before
+passed on to an iterator.
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 1635111c5bd2..7de304269641 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -72,8 +72,6 @@
 	__start.bi_bvec_done = skip;			\
 	__start.bi_idx = 0;				\
 	for_each_bvec(__v, i->bvec, __bi, __start) {	\
-		if (!__v.bv_len)			\
-			continue;			\
 		(void)(STEP);				\
 	}						\
 }
-- 
2.24.0

