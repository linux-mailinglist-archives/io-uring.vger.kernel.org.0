Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEDB1E444E
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2020 15:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388647AbgE0NsZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 May 2020 09:48:25 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:55735 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388082AbgE0NsZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 May 2020 09:48:25 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MkpOZ-1jA3RJ26yV-00mKQD; Wed, 27 May 2020 15:48:22 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: include linux/pagemap.h
Date:   Wed, 27 May 2020 15:48:08 +0200
Message-Id: <20200527134821.1001856-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:AnkI1/UfaEFGuuR8lsmWfA+cClYJaFovoQxZjwHBUBeNDV1ahjf
 qLXvGr/UxePgpPoq/+t2mGbqkfaheo9uVoLBmzedRhUYWCUK1zt2kE/lg/3YJ0tpIsd23QW
 IngVAeSYbhPn8DNs+ychvJ0KMGIhJQZ7p6aTYnjMTJ1fN49PDw+Y9l+P7dfXkDfM6PNtnWi
 oqyW4MPRJAhQKAng6kIUQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gK33T4nZbcg=:4i9fO+/F8DhO4VXyAzWfXw
 whkM41Bswq1rWhra27aXsOYJKq/S2fL7K5f4KgkEuKFvZ4oOeXKl3Z6Sw3P3U8b0pXOjp1pOK
 sKrTRndtpb9r+za1DsbTjwxcpkJwcTo758EZ8n0FRpKH5EnnQEjhw7kbRjOj+Iz60P66TtLZf
 aEDd74dNLeWQcoQTx+h0EJCNjXZrR06p38eexslvi2kTQ++dJ5atQRw3RF6r1iHFouVELw2mU
 OLsVeabPzX1hGsgMTGsVorENIA2qrSv8EpFzeKgcqSYL9taF92vr4Gf3t7IhAblvklQmD/Pax
 ShxnxopSUhtjhRBrPcDBoFeC4ROak+kXgbcfxkRq6CmdkKJG9qUTKw/+D2wtSRA4IcYReDkci
 tH9OAkC9OAgasXz3oFo0v+w3x/ltOAe9NQc2aWQz2UPWMqmxp3sWSresDYO6muIvnrdUhZhdT
 +6v10eE/YjGgZrbx9CY5X/SJRl/N7iifxdi3SE34Q0YrUed6cBGNxf2HFFWqWQRkacqDfGcP7
 39BliEHewgrmaaqf2eIp/8+JmPjaaDWR/OA1KhMY+hKfAxKgdXa6Z/jUW7i0ZplM4MC9nX1bq
 gxSa3ieQrGaapKVXlKQe7mDZsnGSV8rplzS+2tTtaMxfincOZMiEoDBSihmStkhy/+B71ewjp
 8/n2nmZUgWQSqZ7sNbSRjsfFZ0ifcqXZBybM6QnAQ5OvUUcb53ASfEn4ZEEvVNq+B4LzpB4QI
 J6AfS/k6dEvP8vHdRKeXE7r0JNdSWe/gKz84e659q9nr/GcA41OupnDTtUClHjSpAoZLuNcbt
 4lB5fjDlnOhEhillDubQa8+pfhkdduq9HiHKUuDenHuIwjTiY4=
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I observed a build regression in ARM randconfig builds:

fs/io_uring.c:500:26: error: field has incomplete type 'struct wait_page_queue'
        struct wait_page_queue          wpq;

Include the missing header file that defines the structure
to make it build again.

Fixes: ad9e8c18aaa2 ("io_uring: support true async buffered reads, if file provides it")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d292b992f945..5e2a0a8809a5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -55,6 +55,7 @@
 #include <linux/fdtable.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
+#include <linux/pagemap.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
-- 
2.26.2

