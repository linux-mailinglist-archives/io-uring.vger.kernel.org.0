Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420012F011A
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 17:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbhAIQH2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 11:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbhAIQH1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 11:07:27 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13106C06179F;
        Sat,  9 Jan 2021 08:06:47 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id e25so11050762wme.0;
        Sat, 09 Jan 2021 08:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lGO3N0dJRSDXwKGKd9FDaeuDl4ejZglaZH9ZU4+s/tY=;
        b=PNS20XMr5oY5wsCd5IWCatRGYgKhqOGRWD42cUzqU3npgYmGMzrjMlQaKrMuRzUyc8
         7le18rv1rLvmFEUClV6PEHtvQK3aPEQ5Eavs+vj4yHGO7YyYQ6gOpjJRPPtMJXuCzzy7
         0SMvGb+teD4g2KnZITU9ti3EZ5Z0APu7/3lwhMTAld3hg2khQV8kramlUuW9yuI/bIyk
         rKQb1fd9HbjFeAz1LdRXFtgYiqhE3kSck9Y9NZIP08qyIULBtDjcvn9ateqYsZQmm8n5
         0O4OxKK1lyWfrvqjIu713MV1I9fpuCZEVnKGze8Rz95P5bj+PaD4IIN8RriANInJtb5U
         ifug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lGO3N0dJRSDXwKGKd9FDaeuDl4ejZglaZH9ZU4+s/tY=;
        b=BYYhz9CI58obEjQWt9TQLShaDMtO2DLRg1WGUD9Hg7fTo3yLksRCysBp151BEWVjK6
         K6vJ1B6t5Lz3L/sByRAJvmxBa3bYNaPJaRT4sIa5t0k9jcxo+eMAt22Aa73gS7S+Xws4
         sA0GVw8Wg0MKDik8yiGRf1G8wdWz6uKvsI1DUtPKEaNwd5myEzSnVBGn04OXkQvHcPqe
         t4eEhfAxPxK8AX5F1yvEhBCtPfPjUJZQCRDOBLbbNWme5yHLZ2MBeV/iXuWK0FXPLkH9
         gXSobW8qN9sqYknHG4bkc2014iAbwatWoNFYZfi9vfhFjUZNs9zvl+mSQW5AoI82Voi1
         GBMg==
X-Gm-Message-State: AOAM532YiM8OcP0W1YjUALKWfYLi3Y+ElhbQpp3c3/Pzx4jKIeXXA81s
        s68rb5l1Dt6XnUoBMAzKQpJWaW9J7s45xnvG
X-Google-Smtp-Source: ABdhPJyPJNi1iMc9SCE+oR3bxu64pyOQeD5A8QFIrcf1TR3/G6IczfLuhp47YWEuOLfIpgEf/eM15g==
X-Received: by 2002:a1c:790f:: with SMTP id l15mr7831379wme.188.1610208405336;
        Sat, 09 Jan 2021 08:06:45 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id j9sm17403866wrm.14.2021.01.09.08.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 08:06:44 -0800 (PST)
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
Subject: [PATCH v3 1/7] splice: don't generate zero-len segement bvecs
Date:   Sat,  9 Jan 2021 16:02:57 +0000
Message-Id: <bfaeb54c88f0c962461b75c6493103e11bb0b17b.1610170479.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610170479.git.asml.silence@gmail.com>
References: <cover.1610170479.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

iter_file_splice_write() may spawn bvec segments with zero-length. In
preparation for prohibiting them, filter out by hand at splice level.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/splice.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 866d5c2367b2..474fb8b5562a 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -662,12 +662,14 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 
 		/* build the vector */
 		left = sd.total_len;
-		for (n = 0; !pipe_empty(head, tail) && left && n < nbufs; tail++, n++) {
+		for (n = 0; !pipe_empty(head, tail) && left && n < nbufs; tail++) {
 			struct pipe_buffer *buf = &pipe->bufs[tail & mask];
 			size_t this_len = buf->len;
 
-			if (this_len > left)
-				this_len = left;
+			/* zero-length bvecs are not supported, skip them */
+			if (!this_len)
+				continue;
+			this_len = min(this_len, left);
 
 			ret = pipe_buf_confirm(pipe, buf);
 			if (unlikely(ret)) {
@@ -680,6 +682,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 			array[n].bv_len = this_len;
 			array[n].bv_offset = buf->offset;
 			left -= this_len;
+			n++;
 		}
 
 		iov_iter_bvec(&from, WRITE, array, n, sd.total_len - left);
-- 
2.24.0

