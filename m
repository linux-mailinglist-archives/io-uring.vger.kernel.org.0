Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA20221501
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 21:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgGOTWs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 15:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgGOTWs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 15:22:48 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D847BC061755
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 12:22:47 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a21so3346331ejj.10
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 12:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dy7Ks+G/TEY13hlyA6NE2O4raUgka82zeTtioFQbzhI=;
        b=H2gwz2kR1IKY7h8K89QhetnaX7SOZJVsHMIR00dijjorTmGu/FPFU02Qj6kwQZeiuk
         gH+QA95s9Q5jWlKw0WAbQfxkLIiilI7KWajRgEqXBolI1E9IE4M0nClqjkauxZ3Q8DTC
         U7CVdfv+Sd4rKmwCx3jznVu47v1w3afteZJXwjlnkZQoo7oF90XSg27D+cFBLPeEDSBo
         3ph9y6bi+bWQs7tVtCXdgdxtAHLMhIYRDe1z+AnHfgiRkY6VD+kyarU4fISpOlkfL4go
         YcfxvdXxUmMF5Cg9OiGKgUoukqq0iLdjssUE0rhxY/eedXzsoPwWscJepV8kK721S2yI
         llBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dy7Ks+G/TEY13hlyA6NE2O4raUgka82zeTtioFQbzhI=;
        b=PUhHPCruN79b53CXf7L653C2b3Wqd5OnnoB54EYJ2TKE2Wv4c8AsCxQDsRvXnwi8hz
         qfSYCczskHp70X+4DkN9eVHRDpmBgH07fsHvRKiM4yd4G4bUaLJIZQ4fB8x8eXX0YK0E
         wn6kRze7ANW3ffp0XKDUY7Yva+rbnX+u8m5s1a8WmWE1mioWf909Oarbu+lhGGVojL1k
         mx8icz2aghldXCMR4LYjMNkVBHTfE7OuKxhoI0BFQvWVxAVjmfKvPdwvJWPWRRyhzpCx
         JRILYkuO3JzMkeN5JItyJLzwe73xxSUDCa+Pj+4zl400pwkhpTvo/9me3oJ/u75UjZh4
         ET5Q==
X-Gm-Message-State: AOAM532jK7U2E3AhYATB/agZjz8oKCGMdjL+Fcq05ra4F/zjO2IN9vOY
        NWpD4okm4SeClCeXqY3KMHC9jH6b
X-Google-Smtp-Source: ABdhPJw8qEgfdk2i8EquNTTtY9twwG7h7AekqjMNdQq4CeU7IRr3zMXdUBfw5xVHF9GAZEj2gVpSlg==
X-Received: by 2002:a17:906:94c4:: with SMTP id d4mr464171ejy.232.1594840966417;
        Wed, 15 Jul 2020 12:22:46 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id v9sm2894578ejd.102.2020.07.15.12.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 12:22:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.8] io_uring: fix recvmsg selected buf leak
Date:   Wed, 15 Jul 2020 22:20:45 +0300
Message-Id: <5b7c61cc77e0b85a4cfecf768be1c3982eb8ae05.1594840376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_recvmsg() doesn't free memory allocated for struct io_buffer.
Fix it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

1. This one is ugly, but automatically mergeable.
I have a half prepared set for-5.9.

2. to reproduce run
sudo sh -c 'for i in $(seq 1 100000000); do ./send_recvmsg; done'

and look for growing "kmalloc-32" slab
p.s. test(1, 0) in send_recvmsg.c is the one leaking

 fs/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9fd7e69696c3..74bc4a04befa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3845,10 +3845,16 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 
 		ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.msg,
 						kmsg->uaddr, flags);
-		if (force_nonblock && ret == -EAGAIN)
-			return io_setup_async_msg(req, kmsg);
+		if (force_nonblock && ret == -EAGAIN) {
+			ret = io_setup_async_msg(req, kmsg);
+			if (ret != -EAGAIN)
+				kfree(kbuf);
+			return ret;
+		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (kbuf)
+			kfree(kbuf);
 	}
 
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
-- 
2.24.0

