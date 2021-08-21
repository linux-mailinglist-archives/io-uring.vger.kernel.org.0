Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546E43F3B1C
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 17:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhHUPIt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 11:08:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230259AbhHUPIt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Aug 2021 11:08:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629558488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=eaFIdkBVLb/Y085I8a/rndyDjBOtoqkC6jmue5Wa1yI=;
        b=WcB3pYFAzODTHXIg9tVadC9WrMc8bmwJ28Cuh1TaZ71uI/6V1ZYhXw5HGn3l68DZtYYFjT
        Ad1LXWM1/OoMN3Nl9ACbbgtiacdzHPxtWNpQAMnuNxR/VtsqXOEOAlMYIFfS06sBK1+IhE
        U8AHbSHX21Y49V0Bhq2g8KDVVEX2/18=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-gYpi6mW_OMSf9M2z3MGETw-1; Sat, 21 Aug 2021 11:08:04 -0400
X-MC-Unique: gYpi6mW_OMSf9M2z3MGETw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86C50107ACF5;
        Sat, 21 Aug 2021 15:08:03 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E27625D6B1;
        Sat, 21 Aug 2021 15:07:58 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH] io_uring: retry in case of short read on block device
Date:   Sat, 21 Aug 2021 23:07:51 +0800
Message-Id: <20210821150751.1290434-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In case of buffered reading from block device, when short read happens,
we should retry to read more, otherwise the IO will be completed
partially, for example, the following fio expects to read 2MB, but it
can only read 1M or less bytes:

    fio --name=onessd --filename=/dev/nvme0n1 --filesize=2M \
	--rw=randread --bs=2M --direct=0 --overwrite=0 --numjobs=1 \
	--iodepth=1 --time_based=0 --runtime=2 --ioengine=io_uring \
	--registerfiles --fixedbufs --gtod_reduce=1 --group_reporting

Fix the issue by allowing short read retry for block device, which sets
FMODE_BUF_RASYNC really.

Fixes: 9a173346bd9e ("io_uring: fix short read retries for non-reg files")
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf548af0426c..bbcd1a9e75e5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3268,6 +3268,12 @@ static inline int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
 		return -EINVAL;
 }
 
+static bool need_read_all(struct io_kiocb *req)
+{
+	return req->flags & REQ_F_ISREG ||
+		S_ISBLK(file_inode(req->file)->i_mode);
+}
+
 static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
@@ -3322,7 +3328,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	} else if (ret == -EIOCBQUEUED) {
 		goto out_free;
 	} else if (ret <= 0 || ret == io_size || !force_nonblock ||
-		   (req->flags & REQ_F_NOWAIT) || !(req->flags & REQ_F_ISREG)) {
+		   (req->flags & REQ_F_NOWAIT) || !need_read_all(req)) {
 		/* read all, failed, already did sync or don't want to retry */
 		goto done;
 	}
-- 
2.31.1

