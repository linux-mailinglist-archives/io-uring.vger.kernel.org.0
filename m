Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84AF514A7F8
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 17:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbgA0QWn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 11:22:43 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21485 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729470AbgA0QWm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 11:22:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580142161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ss4U9Wn3tTKAPoAuitiVMbAeV2gmkSw/nR7X4tYbbRo=;
        b=aeC9JHNjn/DORqnQFDSRjiqJZkGFaAb38mS4g8/CGrODwZssBSmZhhD0j9iPoG3PuW5myE
        DKDhFFQQvTds7tm4tmQDJsKEVb8FIAbPxalQO4OlpO1SSgY0dNY4/szU88r86szJAGnJZY
        cURYQsy52r0iMzAR7nBmSGawIeUczrE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99--McmlvubMJuUbI4LSOqcZA-1; Mon, 27 Jan 2020 11:22:37 -0500
X-MC-Unique: -McmlvubMJuUbI4LSOqcZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EE70801FA5;
        Mon, 27 Jan 2020 16:22:36 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.43.2.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA0332AF99;
        Mon, 27 Jan 2020 16:22:35 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH liburing] .gitignore: add missing tests to ignore
Date:   Mon, 27 Jan 2020 17:22:34 +0100
Message-Id: <20200127162234.156353-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 .gitignore | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/.gitignore b/.gitignore
index fdb4b32..acbd30b 100644
--- a/.gitignore
+++ b/.gitignore
@@ -24,6 +24,7 @@
 /test/a4c0b3decb33-test
 /test/accept
 /test/accept-link
+/test/accept-reuse
 /test/accept-test
 /test/b19062a56726-test
 /test/b5837bd5311d-test
@@ -36,8 +37,11 @@
 /test/d77a67ed5f27-test
 /test/defer
 /test/eeed8b54e0df-test
+/test/fadvise
+/test/fallocate
 /test/fc2a85cb02ef-test
 /test/file-register
+/test/file-update
 /test/fixed-link
 /test/fsync
 /test/io_uring_enter
@@ -47,18 +51,26 @@
 /test/link
 /test/link-timeout
 /test/link_drain
+/test/madvise
 /test/nop
+/test/open-close
+/test/openat2
 /test/poll
 /test/poll-cancel
 /test/poll-cancel-ton
 /test/poll-link
 /test/poll-many
+/test/poll-v-poll
+/test/probe
 /test/read-write
 /test/ring-leak
 /test/send_recvmsg
+/test/shared-wq
+/test/short-read
 /test/socket-rw
 /test/sq-full
 /test/sq-space_left
+/test/statx
 /test/stdout
 /test/submit-reuse
 /test/teardowns
--=20
2.24.1

