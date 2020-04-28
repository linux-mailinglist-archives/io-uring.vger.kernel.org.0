Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABF91BCC44
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2020 21:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgD1TUN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Apr 2020 15:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729135AbgD1TUK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Apr 2020 15:20:10 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5008EC03C1AD
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2020 12:20:09 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n16so10898415pgb.7
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2020 12:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=77ROVTPRQHoMC65ZKgpkg7gAM5Q+yL9Fp8FqGXiNYaM=;
        b=QU4Gn7Vovv/hHZph0WwH596uSHG4Elss8Ip0D3QCvS4hiU2gUccfCVuCIlBr+Ct/q/
         Imda3O0QKwXDRqxkJqZHsJmlH7lLhRBfSIdg51+efERoQpPaqamk8vXYyKNhBuDHA2NJ
         HuFIpBPSOx8iu2iSNZebj1pzLwLGkPTRQAj8zME/T4PwkJjVpvYcHrPM9Df2at2VxrdH
         Esl5060Vfw86fBhqq0TIJHdfERIhg2DQIpij1onfDXgkOIA3YOzJCFM1HE7IX20ehxyV
         2Zo6cEEvgRiAhGtl7R9EjESNxgY0f3eikqkFnxb6ryOuR64EIlVsqocfNbfVtjXOOx1L
         QL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=77ROVTPRQHoMC65ZKgpkg7gAM5Q+yL9Fp8FqGXiNYaM=;
        b=hofxKdBzVl2wgf5T9P5VxE61x6mbVWgsqvJKNvTUByhEI65YeeG+jKdhitgqxAS8Sq
         OL9t50wJcyqpzs1hlbwGA0ALzGrxoWe6HVwFOF1jaOFTvU090PisiWjIedFXPL/LvmY0
         oHk0qacsom0RvnnVxej+4jKnCJPl1dIYEcz1bgLP4r9hAjlTnBo8Y2RSAfSMSbIGdoCM
         OWNIUn0R/diB+KjXsNuizOzEJt0GTRNeRLrVDQ3RiNdfvktZ+JmhzR053cAYMWVndjL1
         9pgVTTSB8R+0qmSo4/Hi9w8vlFMOGjlKymAvzhIle2Dm80xR4fvzAROa0Gmwvc8JepTq
         9RmQ==
X-Gm-Message-State: AGi0PuZ7DH5nxZHx66M7PAa50sUQGAeiwCO8mgYRAF4rqtGc3RI28n4U
        sxKStBeRL4pF4G9uoTPMpLafqWbRE729cw==
X-Google-Smtp-Source: APiQypLOdBEUJver9Fq2JOpx6zv07kVnQ2/z4oPmUsf9qdGE9gCM6/LgwHpvWaWulxI/PEFmbkGERg==
X-Received: by 2002:a63:dc56:: with SMTP id f22mr4289020pgj.284.1588101608484;
        Tue, 28 Apr 2020 12:20:08 -0700 (PDT)
Received: from x1.thefacebook.com ([2620:10d:c090:400::5:7a1a])
        by smtp.gmail.com with ESMTPSA id u188sm15851946pfu.33.2020.04.28.12.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 12:20:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: only force async punt if poll based retry can't handle it
Date:   Tue, 28 Apr 2020 13:20:03 -0600
Message-Id: <20200428192003.12106-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428192003.12106-1-axboe@kernel.dk>
References: <20200428192003.12106-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We do blocking retry from our poll handler, if the file supports polled
notifications. Only mark the request as needing an async worker if we
can't poll for it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 53cadadc7f89..75ff4cc9818b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2601,7 +2601,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 			if (ret)
 				goto out_free;
 			/* any defer here is final, must blocking retry */
-			if (!(req->flags & REQ_F_NOWAIT))
+			if (!(req->flags & REQ_F_NOWAIT) &&
+			    !file_can_poll(req->file))
 				req->flags |= REQ_F_MUST_PUNT;
 			return -EAGAIN;
 		}
@@ -2723,7 +2724,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 			if (ret)
 				goto out_free;
 			/* any defer here is final, must blocking retry */
-			req->flags |= REQ_F_MUST_PUNT;
+			if (!file_can_poll(req->file))
+				req->flags |= REQ_F_MUST_PUNT;
 			return -EAGAIN;
 		}
 	}
-- 
2.26.2

