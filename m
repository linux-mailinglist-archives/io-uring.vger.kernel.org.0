Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68351ED736
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 22:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgFCUKA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 16:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCUJ7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 16:09:59 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDC9C08C5C0
        for <io-uring@vger.kernel.org>; Wed,  3 Jun 2020 13:09:59 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id h185so2295945pfg.2
        for <io-uring@vger.kernel.org>; Wed, 03 Jun 2020 13:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=+58F9ba22pLc32lImYVxk53p4gNTEwmc0yiM59nc2Sc=;
        b=2IrDmbSSWRyRqYN1dkWzY/mKHLA8SssUwfB+HRYcSQ/tyOeTeMp1poTWQOo6U/3pmY
         jIaJxnnso9ljMRY6rG5uRM33UecuB6cDMd5kjj/iCzEvpqHGtSuyK9jwA5nZ2CG4f9C2
         rvH4RRykEKnUIqlnrqAqYtQsY4xvhcTFX0AN01n9/IeKtuIG1zgkPjiZPhUmo33c3ceP
         6lhUvZ9Fn28NtYDPyLBAk3xjYEjBBc34FDPFEzPR7gTpbHRfqWsIh7vQZXcWOSv1mfGX
         mCyQZLO7xL9ZrZTeg56tgMyt2JJ/XOtfSX5eWIx7IX5IdkNb8Xo4Qh7biRooZEbNaJAD
         pHPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=+58F9ba22pLc32lImYVxk53p4gNTEwmc0yiM59nc2Sc=;
        b=YpCgLEETKFVNcqRn3jiJRBjuhXIeBOzFvXbx+kZu48XEDyHt1N/Q8iNK6YGPaL6lWt
         9HALFrbNQ4FJIZrQjsigwEfkX3MD1MhjSvWpvKcVce8dXLpkmovyJL1na7l7UW9fCImF
         6VKUNNB8G+wkBLJpFYDp8D0UOZCRTszQvH1quhjmqg6gS/3f1JReKqkz1owyO6Ty8m8j
         bMiyE1mpFFEzfbkyUJN0SrjXtR97LcWk1cE6VVTmz/xhdBdmjI2wLWnHpsvQuDdXbV0r
         Nmnu+arLDu1cpfG6TtPbK15bFrt779o+9SE1vA4cjrqM2xs0Wy2KaJpZOFmhUdznNRgt
         qFhg==
X-Gm-Message-State: AOAM531pmPz5dwocWYzeGsvNc80l7KpoChkUG3/tVt1qK637hQoMTOuC
        uTMafm4CVinUjusnvhBHmrYn8VHd61SQXg==
X-Google-Smtp-Source: ABdhPJwujVsoIDXUY9hnCAE2Gq3CPq42God12lmmeShdL3nwpqDEVsvBAAM47SBdocEb4Sd4GpcB+Q==
X-Received: by 2002:a63:cc0f:: with SMTP id x15mr1019792pgf.84.1591214998673;
        Wed, 03 Jun 2020 13:09:58 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b11sm3479296pjz.54.2020.06.03.13.09.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 13:09:56 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: disallow close of ring itself
Message-ID: <b86f5db5-5daa-8c79-5cfb-4030c6b32e96@kernel.dk>
Date:   Wed, 3 Jun 2020 14:09:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A previous commit enabled this functionality, which also enabled O_PATH
to work correctly with io_uring. But we can't safely close the ring
itself, as the file handle isn't reference counted inside
io_uring_enter(). Instead of jumping through hoops to enable ring
closure, add a "soft" ->needs_file option, ->needs_file_no_error. This
enables O_PATH file descriptors to work, but still catches the case of
trying to close the ring itself.

Reported-by: Jann Horn <jannh@google.com>
Fixes: 904fbcb115c8 ("io_uring: remove 'fd is io_uring' from close path")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9d4bd0d3a080..417b7105c6dc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -698,6 +698,8 @@ struct io_op_def {
 	unsigned		needs_mm : 1;
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
+	/* don't fail if file grab fails */
+	unsigned		needs_file_no_error : 1;
 	/* hash wq insertion if file is a regular file */
 	unsigned		hash_reg_file : 1;
 	/* unbound wq insertion if file is a non-regular file */
@@ -804,6 +806,8 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_fs		= 1,
 	},
 	[IORING_OP_CLOSE] = {
+		.needs_file		= 1,
+		.needs_file_no_error	= 1,
 		.file_table		= 1,
 	},
 	[IORING_OP_FILES_UPDATE] = {
@@ -3421,6 +3425,10 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
+	if ((req->file && req->file->f_op == &io_uring_fops) ||
+	    req->close.fd == req->ctx->ring_fd)
+		return -EBADF;
+
 	return 0;
 }
 
@@ -5438,19 +5446,20 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 			return -EBADF;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
 		file = io_file_from_index(ctx, fd);
-		if (!file)
-			return -EBADF;
-		req->fixed_file_refs = ctx->file_data->cur_refs;
-		percpu_ref_get(req->fixed_file_refs);
+		if (file) {
+			req->fixed_file_refs = ctx->file_data->cur_refs;
+			percpu_ref_get(req->fixed_file_refs);
+		}
 	} else {
 		trace_io_uring_file_get(ctx, fd);
 		file = __io_file_get(state, fd);
-		if (unlikely(!file))
-			return -EBADF;
 	}
 
-	*out_file = file;
-	return 0;
+	if (file || io_op_defs[req->opcode].needs_file_no_error) {
+		*out_file = file;
+		return 0;
+	}
+	return -EBADF;
 }
 
 static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,

-- 
Jens Axboe

