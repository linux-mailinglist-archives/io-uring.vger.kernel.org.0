Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E25B25481A
	for <lists+io-uring@lfdr.de>; Thu, 27 Aug 2020 16:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgH0O65 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 10:58:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52555 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727008AbgH0O6s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 10:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598540326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E6x4893U1XZUaKie9nG5yKGJyij3esKFZmrFVgshH0M=;
        b=BvRGJ/taq4oGktbSmqqJbAemjnwdQDjfDOG7rS4WjMECZVXjfn+UWYc42ge1V8vNlvE+de
        Xs5mha85Cv/q3tj86spOYYUoJLdqaTGjgxt0B3ZUScKAGOPWPT1Tee5QIR4knQYRC7wZNq
        CS16cDxxWM8q6lcYVpNaUYRb3sWicBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-OzeCjMpkPR2bB2S_EItBpg-1; Thu, 27 Aug 2020 10:58:44 -0400
X-MC-Unique: OzeCjMpkPR2bB2S_EItBpg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D8F218BE161;
        Thu, 27 Aug 2020 14:58:43 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-96.ams2.redhat.com [10.36.113.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E260D5C1D0;
        Thu, 27 Aug 2020 14:58:39 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        Aleksa Sarai <asarai@suse.de>,
        Sargun Dhillon <sargun@sargun.me>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 1/3] io_uring: use an enumeration for io_uring_register(2) opcodes
Date:   Thu, 27 Aug 2020 16:58:29 +0200
Message-Id: <20200827145831.95189-2-sgarzare@redhat.com>
In-Reply-To: <20200827145831.95189-1-sgarzare@redhat.com>
References: <20200827145831.95189-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The enumeration allows us to keep track of the last
io_uring_register(2) opcode available.

Behaviour and opcodes names don't change.

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v5:
 - explicitly assign enum values since this is UAPI [Kees]
---
 include/uapi/linux/io_uring.h | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d65fde732518..5f12ae6a415c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -255,17 +255,22 @@ struct io_uring_params {
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
+	IORING_REGISTER_BUFFERS			= 0,
+	IORING_UNREGISTER_BUFFERS		= 1,
+	IORING_REGISTER_FILES			= 2,
+	IORING_UNREGISTER_FILES			= 3,
+	IORING_REGISTER_EVENTFD			= 4,
+	IORING_UNREGISTER_EVENTFD		= 5,
+	IORING_REGISTER_FILES_UPDATE		= 6,
+	IORING_REGISTER_EVENTFD_ASYNC		= 7,
+	IORING_REGISTER_PROBE			= 8,
+	IORING_REGISTER_PERSONALITY		= 9,
+	IORING_UNREGISTER_PERSONALITY		= 10,
+
+	/* this goes last */
+	IORING_REGISTER_LAST
+};
 
 struct io_uring_files_update {
 	__u32 offset;
-- 
2.26.2

