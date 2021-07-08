Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6293BFA59
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 14:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhGHMkO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 08:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhGHMkO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 08:40:14 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1502C061574
        for <io-uring@vger.kernel.org>; Thu,  8 Jul 2021 05:37:32 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id a13so7323556wrf.10
        for <io-uring@vger.kernel.org>; Thu, 08 Jul 2021 05:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ekdDJEUKNVHxvifSvNZBZXJSwUwzbgfn4Dhgt8QTVYc=;
        b=BYAd5m+d3AchsmkNJu10mdmTTbHe3IFITb7t2FQVqRpRrLGiZ5T6M4/lVg6jwRCOFr
         TSKPIUhHL/Uo+AghxYR4RK7UWI0cjNo49hImLrwRki8SV7uTvdPhZB3bgxxOWxTMkRJk
         wmBoPp2ACEvPV2Ooi87CrSOC8hDKgyF2ESJn0zjNEupOMIxnBn/xc/Af9F+TUvo5KeTm
         tyjeBSLKMNsdCaCT21HaKn0haEZ5eRysqFJVzNPLoHB0ChfwYcN3mlXhEyqxXd3A9be5
         sSqZQOgcfCSHJQPFvRFN8Z9O+u9QdBVz5s0/ckl0yWk2pn4i0LJZVcES0rZ190jX3Rcs
         mlCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ekdDJEUKNVHxvifSvNZBZXJSwUwzbgfn4Dhgt8QTVYc=;
        b=YF98oOubyUw7HgJBzVEvJYkzhZSOX2GrzZNpCp10gO5Upj3eTgHF+izbAfD531KUK0
         ixed95wDVPp/BJg8J9mhnqsFyfcbGZDUSRXsqE2NupLNP7TbSLoSA7Y16r1UH462JyXb
         gqMplqz3hW2dxviDFhfMEf2MKuZVamMRQgeYfYH5fg4ezRynXRQBeUnteAUfX9+C9FLk
         /VtIElin6txDVEVnhwRFzCfNkmpIeF8EOxjd2iIbVIO24SIChIcB+jpToRikp9dhTsht
         HmkCSMnmjKUcjPGMwMiqaJztBMH8gTSvMejv4favkXqaKbndf5fNx+N+EwXeOlq8HaW+
         2RHg==
X-Gm-Message-State: AOAM532zF2O+Ye6AhZX0Bo6LuOEFZIw1wdQpt7qVe9cAuCm5xi9Khysx
        lJPoMCiAcL6fItXCvScgKSBYMrINav21Cg==
X-Google-Smtp-Source: ABdhPJyejbgZQ0Jo8gCeRwLAUEXLG1JwA146eGUMd76O6yUSwr4uWoNs1k/PQPf7eF+nnANu9PMTUQ==
X-Received: by 2002:adf:f8c5:: with SMTP id f5mr34013114wrq.420.1625747851471;
        Thu, 08 Jul 2021 05:37:31 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.213])
        by smtp.gmail.com with ESMTPSA id n8sm2078949wrt.95.2021.07.08.05.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 05:37:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: mitigate unlikely iopoll lag
Date:   Thu,  8 Jul 2021 13:37:06 +0100
Message-Id: <66ef932cc66a34e3771bbae04b2953a8058e9d05.1625747741.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have requests like IORING_OP_FILES_UPDATE that don't go through
->iopoll_list but get completed in place under ->uring_lock, and so
after dropping the lock io_iopoll_check() should expect that some CQEs
might have get completed in a meanwhile.

Currently such events won't be accounted in @nr_events, and the loop
will continue to poll even if there is enough of CQEs. It shouldn't be a
problem as it's not likely to happen and so, but not nice either. Just
return earlier in this case, it should be enough.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8f2a66903f5a..7167c61c6d1b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2356,11 +2356,15 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		 * very same mutex.
 		 */
 		if (list_empty(&ctx->iopoll_list)) {
+			u32 tail = ctx->cached_cq_tail;
+
 			mutex_unlock(&ctx->uring_lock);
 			io_run_task_work();
 			mutex_lock(&ctx->uring_lock);
 
-			if (list_empty(&ctx->iopoll_list))
+			/* some requests don't go through iopoll_list */
+			if (tail != ctx->cached_cq_tail ||
+			    list_empty(&ctx->iopoll_list))
 				break;
 		}
 		ret = io_do_iopoll(ctx, &nr_events, min);
-- 
2.32.0

