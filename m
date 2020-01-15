Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC13013C97A
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2020 17:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgAOQfu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jan 2020 11:35:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59598 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728899AbgAOQfu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jan 2020 11:35:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579106149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=olwgOJsEeGbNBTUIn8I937CVc6Quj9K/XMlhmcyLdhM=;
        b=dHKN/fBFGIqkjz1Xj1KF4jmk8qJ+DQ2gRt49umOT5W0fi/95Fzr7lKUVUP2b1EW6QOn/ho
        2Zge1S4YtMDG8A3PGmO/roEIO1ebP2b76LP9be6jKrKXcwBoIVrsfRlX2qEyNrgSKHcPA4
        geDKJbrVNNbRpIe8FmiaHaaIRmhcvJQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-0sHrwlvyPHS8usrKZHIRnA-1; Wed, 15 Jan 2020 11:35:46 -0500
X-MC-Unique: 0sHrwlvyPHS8usrKZHIRnA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E12A800A02;
        Wed, 15 Jan 2020 16:35:44 +0000 (UTC)
Received: from asgard.redhat.com (ovpn-112-36.ams2.redhat.com [10.36.112.36])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2116D60CD3;
        Wed, 15 Jan 2020 16:35:40 +0000 (UTC)
Date:   Wed, 15 Jan 2020 17:35:38 +0100
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH] io_uring: fix compat for IORING_REGISTER_FILES_UPDATE
Message-ID: <20200115163538.GA13732@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

fds field of struct io_uring_files_update is problematic with regards
to compat user space, as pointer size is different in 32-bit, 32-on-64-bit,
and 64-bit user space.  In order to avoid custom handling of compat in
the syscall implementation, make fds __u64 and use u64_to_user_ptr in
order to retrieve it.  Also, align the field naturally and check that
no garbage is passed there.

Fixes: c3a31e605620c279 ("io_uring: add support for IORING_REGISTER_FILES_UPDATE")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 fs/io_uring.c                 | 4 +++-
 include/uapi/linux/io_uring.h | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 38b5405..677ef90 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4445,13 +4445,15 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (copy_from_user(&up, arg, sizeof(up)))
 		return -EFAULT;
+	if (up.resv)
+		return -EINVAL;
 	if (check_add_overflow(up.offset, nr_args, &done))
 		return -EOVERFLOW;
 	if (done > ctx->nr_user_files)
 		return -EINVAL;
 
 	done = 0;
-	fds = (__s32 __user *) up.fds;
+	fds = u64_to_user_ptr(up.fds);
 	while (nr_args) {
 		struct fixed_file_table *table;
 		unsigned index;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a3300e1..55cfcb7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -178,7 +178,8 @@ struct io_uring_params {
 
 struct io_uring_files_update {
 	__u32 offset;
-	__s32 *fds;
+	__u32 resv;
+	__aligned_u64 /* __s32 * */ fds;
 };
 
 #endif
-- 
2.1.4

