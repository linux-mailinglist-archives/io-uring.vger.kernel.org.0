Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A47A6AE992
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 18:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjCGRZm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 12:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbjCGRZU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 12:25:20 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F79EA2F1F
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 09:20:23 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id y2so13918073pjg.3
        for <io-uring@vger.kernel.org>; Tue, 07 Mar 2023 09:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678209622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yMHYMzVL0afntOwSVQWwB4+0IP333F5DvcjTZ4/a2XM=;
        b=yJVjYAryiTa8EK/3CH4axq335dSxgMP6o7ujp89+TxXpwBISoY5D7UB0+1VHXq0oZW
         A5ao3/rXy0O6AN35/4h9Bw8idgOibBP+QsS6JgC1YC0sEfnTujCYg+10CoP1cC2eLlGH
         gOHvYRedPE/veTwNS1q1iz5s71qiAtAjy+jQxj4Mu4y6nox7tYdpNFsohcsn/CGeg4/R
         GJLD7ML7q8L36yidkmRRfhpi2vTIHeoLwSLUqIUmTbafPxGArOpfUcYycwFMfr7efjQ4
         /ZHvVi6+WJhYnCwkdEV1hVclqhBGhHYpflEaBbR14OW+z47+KlORKstYvfJwilD4Gql6
         amDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678209622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yMHYMzVL0afntOwSVQWwB4+0IP333F5DvcjTZ4/a2XM=;
        b=GH+/WFy6Gh78aGZLI5cBJuBb3KMWvmjDI6pZ3RW3/7OyJ2B4CWct7yW/gXLK1A5yEK
         7EZHg9azgXqr/aA7ru5U+pMvdZCcChellsHwYAMoMCg4Opfx+2OdpiNai8iMl8Jwx9Qq
         ss7mBtNT5l1kg7H7rbMcA74R0rewhBA0OqnTnyzMh0CFK7n7Vzq5NfdDGXBKgYmBu3HK
         zuFOKjUsh4Y3t1oLFB9bDurmq0cm1+VLtnct8BoHYewtp2xWAp8ayPr37pbTPu2epSdj
         DMuEzXy+klFrdYVND31UeSZi0EYTh0R55qYKZWAJWXdn+PSnBUnAnYJLwmMaV0gEcw4b
         gsNA==
X-Gm-Message-State: AO0yUKUBCVPwZC/pqGZ5WsVRHSSIMoERYkS0ysaxsy8iA95jyOFy/BSw
        sOPuDeDnin9vFcwpo8P1hcNRa2TYCWw6HqIGAk4=
X-Google-Smtp-Source: AK7set8d3oHKR00RyvwWxKk6w6VSMkT+XovE08j4rCfKnN71CqMcdkO4uduXF6p3T/xU2mM2+T/iJA==
X-Received: by 2002:a17:902:e5d0:b0:196:3f5a:b4f9 with SMTP id u16-20020a170902e5d000b001963f5ab4f9mr17754824plf.1.1678209622397;
        Tue, 07 Mar 2023 09:20:22 -0800 (PST)
Received: from localhost.localdomain ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id c17-20020a170903235100b0019e76a99cdbsm8651390plh.243.2023.03.07.09.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 09:20:21 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
Date:   Tue,  7 Mar 2023 10:20:14 -0700
Message-Id: <20230307172015.54911-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307172015.54911-1-axboe@kernel.dk>
References: <20230307172015.54911-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some filesystems support multiple threads writing to the same file with
O_DIRECT without requiring exclusive access to it. io_uring can use this
hint to avoid serializing dio writes to this inode, instead allowing them
to run in parallel.

XFS and ext4 both fall into this category, so set the flag for both of
them.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/ext4/file.c     | 3 ++-
 fs/xfs/xfs_file.c  | 3 ++-
 include/linux/fs.h | 3 +++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 0b8b4499e5ca..d101b3b0c7da 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -899,7 +899,8 @@ static int ext4_file_open(struct inode *inode, struct file *filp)
 			return ret;
 	}
 
-	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
+	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC |
+			FMODE_DIO_PARALLEL_WRITE;
 	return dquot_file_open(inode, filp);
 }
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 705250f9f90a..863289aaa441 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1171,7 +1171,8 @@ xfs_file_open(
 {
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
-	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC;
+	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
+			FMODE_DIO_PARALLEL_WRITE;
 	return generic_file_open(inode, file);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c85916e9f7db..475d88640d3d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -168,6 +168,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 
 #define	FMODE_NOREUSE		((__force fmode_t)0x800000)
 
+/* File supports non-exclusive O_DIRECT writes from multiple threads */
+#define FMODE_DIO_PARALLEL_WRITE	((__force fmode_t)0x1000000)
+
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x4000000)
 
-- 
2.39.2

