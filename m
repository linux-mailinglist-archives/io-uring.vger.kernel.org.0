Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34033A173A
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 16:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhFIOaU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 10:30:20 -0400
Received: from mail-ej1-f51.google.com ([209.85.218.51]:37584 "EHLO
        mail-ej1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbhFIOaT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 10:30:19 -0400
Received: by mail-ej1-f51.google.com with SMTP id ce15so38778403ejb.4
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 07:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SmMICuNhQ4Mhd2qjrL79cgMbG0RxftKr3rFtutkQDaI=;
        b=XT68xaOYuKh9UocNI1kWtxywxJqcghi/FgpFBc8+6e5TrLBUDqnY/whkycgrulSCRF
         DONmiNX/U7vllBU/Eg5a0vTPoFdmHNTjieP97ovBOgeFCi6mbQEgOT6bDfHYXmxQyZGT
         M/qw/UJWLyBrs1fj5i2Fp6x2Kx0b8r6QtUndbjKhPUvOuXRokQkuFDGO6Tz/ubYqvJBL
         JrXoaUP39EumBpDlj6pJIAg8WM+tUKuQeXZmPt7BZGidk0dUP2P7DoozJ61jB7/AKQZd
         zJa56KKcfkyU24tNa6aXSKzjADGz9sv3D+89Y9mcbmJawjW3Ym/qsxyXzdpT1n1dvwFq
         bj+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SmMICuNhQ4Mhd2qjrL79cgMbG0RxftKr3rFtutkQDaI=;
        b=ESpEbhu227DKX+tTGsHrTUHw6D3nxxDnVFUcP1V4+zRJLIYhcLFw7LXhpcBApiUsas
         95p4ETWfuKESYgeXJyCvsz4WTzXr5IqB4XUGTWqGtl2t5bPq9ANqG310ehXCRJae1JQV
         R55LB5ytRoPJlvZbnID3XQgKsureqOd85XksMpV/nILa2QMW7G/g/CiNNm21r52/7jb4
         JLNC5qrxvRCZlu99k6eTyIEun3QM6QDUTkiipn65ujjUbUU0u+Z0JHO9Od3wLGUxncEk
         S5VPxx6JsASln5J1zSDyBT2UWdJcopr5GuqVa4pmSOcs3TpgiP0JMH8pmwHuu/73dO4b
         Gx0Q==
X-Gm-Message-State: AOAM530gJa85oOWKq83ulvpYn93hlHZCmk/51g6jErAPN+zzZsUgCBn2
        +7CjaK0fKHGvbUz0NsxIY3E=
X-Google-Smtp-Source: ABdhPJwMlZW1qPOX/ue0/AJekvvxh+HywEjXVMVlmllX1r0pWmWLA67WZfgJdHQryc38hJ4EiTN3GQ==
X-Received: by 2002:a17:906:4e95:: with SMTP id v21mr150339eju.434.1623248830862;
        Wed, 09 Jun 2021 07:27:10 -0700 (PDT)
Received: from agony.thefacebook.com ([2620:10d:c093:600::2:c2f])
        by smtp.gmail.com with ESMTPSA id me11sm1194554ejb.93.2021.06.09.07.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 07:27:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC] io_uring: enable shmem/memfd memory registration
Date:   Wed,  9 Jun 2021 15:26:54 +0100
Message-Id: <52247e3ec36eec9d6af17424937c8d20c497926e.1623248265.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Relax buffer registration restictions, which filters out file backed
memory, and allow shmem/memfd as they have normal anonymous pages
underneath.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 44d1859f0dfb..e980695707ec 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8300,6 +8300,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		for (i = 0; i < nr_pages; i++) {
 			struct vm_area_struct *vma = vmas[i];
 
+			if (vma_is_shmem(vma))
+				continue;
 			if (vma->vm_file &&
 			    !is_file_hugepages(vma->vm_file)) {
 				ret = -EOPNOTSUPP;
-- 
2.31.1

