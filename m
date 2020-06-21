Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC44202CC2
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 22:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbgFUUg6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 16:36:58 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39078 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730643AbgFUUg6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 16:36:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id d66so7375988pfd.6
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 13:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ubgr7GDHwp8O+mkRkZwZzFXWvwfOrgn1g5p28KfkUTQ=;
        b=DxKLWdVGt+P7kH43X+46NQLG39gqacqfd4LKcTlG9kMrnjxsIbvTJd3rJWZwvcovN4
         b0WgcfjanJ6jkZGzOEnuWgfDn7F3QbO5UelOpVDuN/LQ0r4rxD7ggTM20uViniaQaqd/
         R2N8QH0ddiMGJpUS9hGeuDbBeEnnvyYUzzKdeVHQqjwFp0ifiEgbGYJWWEr2zfNy7utW
         QECAtzC//d2J7L5Jmqm17xpbTv/trEE4wgrUWqfNPFUICH8YKGfJzIJ7EoZiUrqtQItO
         tdMY8i0x5f3sFEHAUP3xU9Ry4DlDX7Irz8xt6Ah7770rrpIFFXSHKiyZz1hknQEhVhQR
         t6fQ==
X-Gm-Message-State: AOAM532zvXWV+p5dy4AVWCpp8CTk0QWO4waqcS61wWu5octLBWeQBjGq
        7rl646A5dyA3cH7xCTdKVMEUAFC3
X-Google-Smtp-Source: ABdhPJyUxh3Ba8AOPxGhqSzSEhCYtqaFDhVb0IMEKf64QwvzskRIWmVUXSeyuNZ8CjK+PBFJqKyMpQ==
X-Received: by 2002:a62:31c6:: with SMTP id x189mr18519165pfx.79.1592771817847;
        Sun, 21 Jun 2020 13:36:57 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d5sm10861387pjo.20.2020.06.21.13.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 13:36:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH liburing 3/3] Convert __io_uring_get_sqe() from a macro into an inline function
Date:   Sun, 21 Jun 2020 13:36:46 -0700
Message-Id: <20200621203646.14416-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200621203646.14416-1-bvanassche@acm.org>
References: <20200621203646.14416-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch makes gcc 10 insert one additional assembly instruction in
io_uring_get_sqe(), namely xor %r8d,%r8d. That shouldn't cause any slowdown
since that instruction does not access memory:

   0x0000000000000360 <+0>:     mov    (%rdi),%rax
   0x0000000000000363 <+3>:     xor    %r8d,%r8d
   0x0000000000000366 <+6>:     mov    (%rax),%ecx
   0x0000000000000368 <+8>:     mov    0x44(%rdi),%eax
   0x000000000000036b <+11>:    lea    0x1(%rax),%edx
   0x000000000000036e <+14>:    mov    %edx,%esi
   0x0000000000000370 <+16>:    sub    %ecx,%esi
   0x0000000000000372 <+18>:    mov    0x18(%rdi),%rcx
   0x0000000000000376 <+22>:    cmp    (%rcx),%esi
   0x0000000000000378 <+24>:    ja     0x38e <io_uring_get_sqe+46>
   0x000000000000037a <+26>:    mov    0x10(%rdi),%rcx
   0x000000000000037e <+30>:    and    (%rcx),%eax
   0x0000000000000380 <+32>:    mov    %edx,0x44(%rdi)
   0x0000000000000383 <+35>:    shl    $0x6,%rax
   0x0000000000000387 <+39>:    add    0x38(%rdi),%rax
   0x000000000000038b <+43>:    mov    %rax,%r8
   0x000000000000038e <+46>:    mov    %r8,%rax
   0x0000000000000391 <+49>:    retq

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 src/queue.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index 3db52bd17b86..88e0294c19fb 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -273,16 +273,18 @@ int io_uring_submit_and_wait(struct io_uring *ring, unsigned wait_nr)
 	return __io_uring_submit_and_wait(ring, wait_nr);
 }
 
-#define __io_uring_get_sqe(sq, __head) ({				\
-	unsigned __next = (sq)->sqe_tail + 1;				\
-	struct io_uring_sqe *__sqe = NULL;				\
-									\
-	if (__next - __head <= *(sq)->kring_entries) {			\
-		__sqe = &(sq)->sqes[(sq)->sqe_tail & *(sq)->kring_mask];\
-		(sq)->sqe_tail = __next;				\
-	}								\
-	__sqe;								\
-})
+static inline struct io_uring_sqe *
+__io_uring_get_sqe(struct io_uring_sq *sq, unsigned int __head)
+{
+	unsigned int __next = (sq)->sqe_tail + 1;
+	struct io_uring_sqe *__sqe = NULL;
+
+	if (__next - __head <= *(sq)->kring_entries) {
+		__sqe = &(sq)->sqes[(sq)->sqe_tail & *(sq)->kring_mask];
+		(sq)->sqe_tail = __next;
+	}
+	return __sqe;
+}
 
 /*
  * Return an sqe to fill. Application must later call io_uring_submit()
