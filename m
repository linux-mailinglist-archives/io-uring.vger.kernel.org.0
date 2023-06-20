Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9E5736B09
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 13:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjFTLcp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 07:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjFTLco (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 07:32:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB50FE
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 04:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Sender:Reply-To:Content-ID:Content-Description;
        bh=U3ainyF2UXZak0+VVSWzlG5U4kg4C6crs3+ZoOul5Yc=; b=M270kmmTvd7BS1b0N7t00WyHB+
        OzG8lvOI5IEQwigpkn7Qhc5vQzIPIjXjumADM0ZpsUayJg4N89fDIlpgbe+7S+DHprWBLeeW86knJ
        rHFJIbLTp2V2hp+F4hh1jDnVWtTUQDgO8sVlrNhuj0fcKy2skfwcRC04zCdZfmiZIPihvc1/ErfF0
        NdJ2H/zMSc0Q8mhi3BWndb0Kp78fBJukIWk5Etg+o9Liyjjt58AbgVwVfxp8C090kiWWij6mnUuwP
        6j1eL3UYirIySohWLr1OyNB/JJjE9cT1VD+HArrcVTPl6AGTge5pl03LWQwWvEOMY62BqnO/VZjDb
        gPDpIxRg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qBZbG-00B8Wu-2Q;
        Tue, 20 Jun 2023 11:32:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: [PATCH 1/8] io_uring: remove __io_file_supports_nowait
Date:   Tue, 20 Jun 2023 13:32:28 +0200
Message-Id: <20230620113235.920399-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230620113235.920399-1-hch@lst.de>
References: <20230620113235.920399-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now that this only checks O_NONBLOCK and FMODE_NOWAIT, the helper is
complete overkilļ, and the comments are confusing bordering to wrong.
Just inline the check into the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io_uring/io_uring.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f181876e415b9a..7e735724940f7f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1766,19 +1766,6 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
-/*
- * If we tracked the file through the SCM inflight mechanism, we could support
- * any file. For now, just ensure that anything potentially problematic is done
- * inline.
- */
-static bool __io_file_supports_nowait(struct file *file, umode_t mode)
-{
-	/* any ->read/write should understand O_NONBLOCK */
-	if (file->f_flags & O_NONBLOCK)
-		return true;
-	return file->f_mode & FMODE_NOWAIT;
-}
-
 /*
  * If we tracked the file through the SCM inflight mechanism, we could support
  * any file. For now, just ensure that anything potentially problematic is done
@@ -1791,7 +1778,7 @@ unsigned int io_file_get_flags(struct file *file)
 
 	if (S_ISREG(mode))
 		res |= FFS_ISREG;
-	if (__io_file_supports_nowait(file, mode))
+	if ((file->f_flags & O_NONBLOCK) || (file->f_mode & FMODE_NOWAIT))
 		res |= FFS_NOWAIT;
 	return res;
 }
-- 
2.39.2

