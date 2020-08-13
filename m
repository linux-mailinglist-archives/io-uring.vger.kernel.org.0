Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CC8243C8C
	for <lists+io-uring@lfdr.de>; Thu, 13 Aug 2020 17:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgHMPdc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 11:33:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55927 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726730AbgHMPdb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 11:33:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597332809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NyHfHbF6ww7AOILglJMvLxTHqil+Il52XX3iacaG1c=;
        b=fxl4Ra1hXmBUGc7r8CliS/D4Fk2+OHrwG/2NHkQJnSnguaM6bhYWwDlJm75rGrMKhE88rP
        ww20cAu2Le/Q5lPw1CyHKlppJJBRdlMhIt5ASNLJo91rDWKP+2TazF+fsBJvJNSyX/3XXS
        CymIYknGF2DhunkI+J+mKi3kihYBIZ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-P_6uw1VhOiiPCWSeelheKQ-1; Thu, 13 Aug 2020 11:33:25 -0400
X-MC-Unique: P_6uw1VhOiiPCWSeelheKQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A36F5807323;
        Thu, 13 Aug 2020 15:33:23 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-140.ams2.redhat.com [10.36.113.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E52260C04;
        Thu, 13 Aug 2020 15:33:18 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-fsdevel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Aleksa Sarai <asarai@suse.de>,
        io-uring@vger.kernel.org
Subject: [PATCH v4 1/3] io_uring: use an enumeration for io_uring_register(2) opcodes
Date:   Thu, 13 Aug 2020 17:32:52 +0200
Message-Id: <20200813153254.93731-2-sgarzare@redhat.com>
In-Reply-To: <20200813153254.93731-1-sgarzare@redhat.com>
References: <20200813153254.93731-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index d65fde732518..cdc98afbacc3 100644
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

