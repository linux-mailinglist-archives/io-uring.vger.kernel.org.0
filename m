Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE472222C6
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 14:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgGPMtB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 08:49:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48390 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728093AbgGPMtB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 08:49:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594903739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Odxlq9Ln5GrmGx+aMPEKeiGZ+J1+ZE/sVWWvuPsLyGs=;
        b=P2Tk3NYxzbjMVMQ6rgH3yWBV+MhzDAUpN275PjR8xSsf3tNtAwky33tXK5D+4jbeU7Uj46
        nLRAcmJUp4g5LVitFzenGrX4DpGO4fhSiQc3ug6ytPns/PSJJzLjdYjOEXJf1NQpdkEzsx
        aivW6UPDljkTrdF2OGmBDFh2GafB/L8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-opOtX4U3M22wtJYFkI7UFQ-1; Thu, 16 Jul 2020 08:48:55 -0400
X-MC-Unique: opOtX4U3M22wtJYFkI7UFQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B911C100AA21;
        Thu, 16 Jul 2020 12:48:53 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-107.ams2.redhat.com [10.36.114.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FC0B78A52;
        Thu, 16 Jul 2020 12:48:48 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kees Cook <keescook@chromium.org>,
        Aleksa Sarai <asarai@suse.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sargun Dhillon <sargun@sargun.me>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC v2 1/3] io_uring: use an enumeration for io_uring_register(2) opcodes
Date:   Thu, 16 Jul 2020 14:48:31 +0200
Message-Id: <20200716124833.93667-2-sgarzare@redhat.com>
In-Reply-To: <20200716124833.93667-1-sgarzare@redhat.com>
References: <20200716124833.93667-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The enumeration allows us to keep track of the last
io_uring_register(2) opcode available.

Behaviour and opcodes names don't change.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/uapi/linux/io_uring.h | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7843742b8b74..efc50bd0af34 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -253,17 +253,22 @@ struct io_uring_params {
 /*
  * io_uring_register(2) opcodes and arguments
  */
-#define IORING_REGISTER_BUFFERS		0
-#define IORING_UNREGISTER_BUFFERS	1
-#define IORING_REGISTER_FILES		2
-#define IORING_UNREGISTER_FILES		3
-#define IORING_REGISTER_EVENTFD		4
-#define IORING_UNREGISTER_EVENTFD	5
-#define IORING_REGISTER_FILES_UPDATE	6
-#define IORING_REGISTER_EVENTFD_ASYNC	7
-#define IORING_REGISTER_PROBE		8
-#define IORING_REGISTER_PERSONALITY	9
-#define IORING_UNREGISTER_PERSONALITY	10
+enum {
+	IORING_REGISTER_BUFFERS,
+	IORING_UNREGISTER_BUFFERS,
+	IORING_REGISTER_FILES,
+	IORING_UNREGISTER_FILES,
+	IORING_REGISTER_EVENTFD,
+	IORING_UNREGISTER_EVENTFD,
+	IORING_REGISTER_FILES_UPDATE,
+	IORING_REGISTER_EVENTFD_ASYNC,
+	IORING_REGISTER_PROBE,
+	IORING_REGISTER_PERSONALITY,
+	IORING_UNREGISTER_PERSONALITY,
+
+	/* this goes last */
+	IORING_REGISTER_LAST
+};
 
 struct io_uring_files_update {
 	__u32 offset;
-- 
2.26.2

