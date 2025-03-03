Return-Path: <io-uring+bounces-6909-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A738A4C5A8
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 16:50:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B29616943B
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 15:50:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 234392147FD;
	Mon,  3 Mar 2025 15:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fJ1rm8me"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57395214A78
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741017010; cv=none; b=grcKiHf4rtqpOIqxlqYRMEot7xKlK7NDty0gFaWXIdvXAb9o4+UwlnIym378P8Z6oD75jgwtC8zUrJItXR8qoINLOIxw2G5T/RWhb8F5BaTBdBmtwynfiCy4LKriLM7mMR5eJeZBud8iXckqh8cftUn/FHr7efpWzt8UovJm5CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741017010; c=relaxed/simple;
	bh=lHmXTgZLZPrFWQA2uBEMU/GbCtmIu6SrxYKZmNwzLF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnKnUeW21Ld9Ns+FSdMbb3BPLF1aVPhn5MfC6Ce/3BchMjESSxRN7mKmYKkmHA63jRHWdFhdXAnDX3yHh8JUfghi5KE2DCYv6YQ4TXSKxeuQcu37i8R/HQlHLZJ3U0/DUVjHMog2VBupzbu6FnHlgEfJUjFuaBnIRk3bEwlTHNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fJ1rm8me; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ab771575040so1011586066b.1
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 07:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741017006; x=1741621806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qOI8bdVbcoPe8sCdbKgJ/CnnnozyzBKVPBUSTN1RX5w=;
        b=fJ1rm8meZi1p09ide7nSdLZQJXtmPKpQiF95LKKTCVnHNmRsxwk4I7aSXC+JshgkrZ
         eS91AJC1Slfvxa6HOdxOSOMOGTpKZmvyEGJRnFHJ694Eig9S35rlj0sajFVyboSvbTup
         1VhowIjo+EBx8zikgaHj9EkG1dZheCF2QtyX2mwDzr/MrRb8OZvK9MnRQ1NejTnwZl3P
         +ogMc9jyTHyFR8mtrb6OGTnB01MNTtrarJ+YEO8J9eMaWky2oEDc4/HcaS2cL5hiM3Ch
         bD8z0Mkvbbjipp8X/WCEGmY2y0LkXjJbjOR4g5otfH3ggoAmnTeliCqr6fCieji1v3BD
         DZBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741017006; x=1741621806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qOI8bdVbcoPe8sCdbKgJ/CnnnozyzBKVPBUSTN1RX5w=;
        b=fiFF2zL4alqowONOq118IcRJsvBe9+ba6/Sfsx6+lTJtTvnqRtphTSSpT/4thLMjkW
         F6oieItbu+GJYIZK+uAYSJiegF450HfQT3HcabnIpU4j+OuvUA8DRc9Y0ZtvOEx4pECZ
         Ip7g/Ctu4mFgl04iI+pIOqSwJROcNlf67aeP5xevvayVvb7WJbWSEtjbZMExFh88QhHX
         tGh53ZeXgEPue2c9IJ3LFvRKok7w6Q+p6/EL+asKf1Au7xA00jkkIc7IMzL0t3Tqrb3a
         TOJoI4OQAOeuQmoBb1I5HnT/K9M07Nv4511Ba5b5RWtUTrtIpddrvaT8kNQe1NGp3Fro
         fahA==
X-Gm-Message-State: AOJu0Yze5U4l8LZsj1w/7mLWhPkIPhrgVikyP981hB/n12yjiAnZpSwL
	nSnaCdgZOY/JYTtndfRpJKJDa29VfF1LMvHIycj6qlkAtbYAO+7FTpvPxw==
X-Gm-Gg: ASbGncvRzBTJtIOmw1dVwq4D/86AtmygsyGZ/cxKRzuIO5P4Ctba6+qznqzPAhUZocz
	YR79HXb6d8/MRnHwfVoI8PgoFP15dAku2JzHazX7UR+Llbno6GI7AkpE3QetiO0ixsSyW8GUNDO
	fo1ABdsDAlFbxlGHVtnrsPrBQQHEeVKI59Yc3OBrTx8qoHvc9AYh4sIAGZAL2TRbd55Q0OKA5QP
	ppLxaHv5b0oC49lOWy4KAcjAOjjdWKqMgOsXprOvbh1TvnIrAjfISaP5WBQXjRW3bXC+Th+lOb/
	6xY8hpTqfKYnzx4tVL1nvtNY5cnX
X-Google-Smtp-Source: AGHT+IG8VnigtDDJepQuYFkEFzgfRIXO008KSy3xpbq04HuITU2qGMbMU16oNEehgKwwZWzUeS+7+g==
X-Received: by 2002:a17:907:7f92:b0:ac1:edc5:d73b with SMTP id a640c23a62f3a-ac1edc5d856mr28321566b.8.1741017005894;
        Mon, 03 Mar 2025 07:50:05 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:299a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf4e50c80esm492335266b.61.2025.03.03.07.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 07:50:05 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH 4/8] io_uring/rw: defer reg buf vec import
Date: Mon,  3 Mar 2025 15:50:59 +0000
Message-ID: <d0bd00d88da98bf236d92a9a45eeb69db2d3bbaf.1741014186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741014186.git.asml.silence@gmail.com>
References: <cover.1741014186.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Import registered buffers for vectored reads and writes later at issue
time as we now do for other fixed ops.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/rw.c                  | 36 +++++++++++++++++++++++++++++-----
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index b770a2b12da6..d36fccda754b 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -502,6 +502,7 @@ enum {
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_BUF_NODE_BIT,
 	REQ_F_HAS_METADATA_BIT,
+	REQ_F_IMPORT_BUFFER_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -584,6 +585,8 @@ enum {
 	REQ_F_BUF_NODE		= IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
 	/* request has read/write metadata assigned */
 	REQ_F_HAS_METADATA	= IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
+	/* resolve padded iovec to registered buffers */
+	REQ_F_IMPORT_BUFFER	= IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4c4229f41aaa..33a7ab2a8664 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -381,6 +381,24 @@ int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return __io_prep_rw(req, sqe, ITER_SOURCE);
 }
 
+static int io_rw_import_reg_vec(struct io_kiocb *req,
+				struct io_async_rw *io,
+				int ddir, unsigned int issue_flags)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	unsigned uvec_segs = rw->len;
+	unsigned iovec_off = io->vec.nr - uvec_segs;
+	int ret;
+
+	ret = io_import_reg_vec(ddir, &io->iter, req, &io->vec,
+				uvec_segs, iovec_off, issue_flags);
+	if (unlikely(ret))
+		return ret;
+	iov_iter_save_state(&io->iter, &io->iter_state);
+	req->flags &= ~REQ_F_IMPORT_BUFFER;
+	return 0;
+}
+
 static int io_rw_prep_reg_vec(struct io_kiocb *req, int ddir)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -406,10 +424,8 @@ static int io_rw_prep_reg_vec(struct io_kiocb *req, int ddir)
 	if (IS_ERR(res))
 		return PTR_ERR(res);
 
-	ret = io_import_reg_vec(ddir, &io->iter, req, &io->vec,
-				uvec_segs, iovec_off, 0);
-	iov_iter_save_state(&io->iter, &io->iter_state);
-	return ret;
+	req->flags |= REQ_F_IMPORT_BUFFER;
+	return 0;
 }
 
 int io_prep_readv_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -906,7 +922,11 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	ssize_t ret;
 	loff_t *ppos;
 
-	if (io_do_buffer_select(req)) {
+	if (req->flags & REQ_F_IMPORT_BUFFER) {
+		ret = io_rw_import_reg_vec(req, io, ITER_DEST, issue_flags);
+		if (unlikely(ret))
+			return ret;
+	} else if (io_do_buffer_select(req)) {
 		ret = io_import_rw_buffer(ITER_DEST, req, io, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
@@ -1117,6 +1137,12 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	ssize_t ret, ret2;
 	loff_t *ppos;
 
+	if (req->flags & REQ_F_IMPORT_BUFFER) {
+		ret = io_rw_import_reg_vec(req, io, ITER_SOURCE, issue_flags);
+		if (unlikely(ret))
+			return ret;
+	}
+
 	ret = io_rw_init_file(req, FMODE_WRITE, WRITE);
 	if (unlikely(ret))
 		return ret;
-- 
2.48.1


