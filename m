Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134611EE997
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2020 19:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbgFDRmx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 13:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729998AbgFDRmw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 13:42:52 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A659EC08C5C0
        for <io-uring@vger.kernel.org>; Thu,  4 Jun 2020 10:42:52 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o6so3826380pgh.2
        for <io-uring@vger.kernel.org>; Thu, 04 Jun 2020 10:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Upr8YSfJ2/W6KEk4TaSKqAGAx5DwCsYxd+SIMG+44wE=;
        b=gk4oEceO6MPFYHV0K08yVaSzM74PR2nrzr28aGPonpPJ1f1wa7k7HAI2jT8T1BH/TC
         Julgj5XhbSCBlnw8lFqrrZJGZNN22TRjOnkyVjhXLtOIAh+6EtWrzgxG2pk2IhSah/T1
         5+sfKNIvt0acls54ewoZsMr/uEQJ6Ev4Y8MOOGdphTsvm1O+AtcfbeKS3dXxQhjZekAO
         Gt758kuKrTVsozSeXJzzx+fSGF/s0fZRxHFkp5VGzXQnR6yQMIlkj3guYyJgzdl7V4HE
         KiJ+xaUtF2XuOKbBBuMXwsTyKwPSMhGFezocdlQNawWanjyf7tdLXpb2lmxeZoF9vWOk
         toXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Upr8YSfJ2/W6KEk4TaSKqAGAx5DwCsYxd+SIMG+44wE=;
        b=UN+qiAs5fgLpiiQ3LEC7xUltDQgq2UIiN/mebaml5dNfuYuKfDgQ3ndItoeE2plxtX
         rp3AA3ilnzKhL3Xi+5R990tIq8GXdujwz+Dh1gNlaOzOl4VmwY2bm7DBql3Ee9aN9XmV
         /Vm2acN+bsc6JtWzBbiHqCvC1OKB5xLLqh0iPqKNtJdMudjxCavc7KUWK5cyMoh+xYux
         hGg54+BmlifQk/MzbI0rd96VWHnq3y31ntbEep9NvLfF3mCKSXy7g0o4ePs8wKCi4Mod
         NVH7d7KnFBVEa5fJrT6ixbqwVuNdPBhtnzTm7ANFR9DCl4niSrxh4WA3cCG7W7sJFUGU
         sSmA==
X-Gm-Message-State: AOAM5310Ao5kFL3ltJY4Mtiecvtm8Kyf5jN4hP6XiIPejsg2LbRWmwkQ
        02es2zqcopWue0xrfLUw+3/sTJgHV187rA==
X-Google-Smtp-Source: ABdhPJwWj7tEL0hg+pwawfwohsqrlWdXVEsgN+Ic6/DmugAnsKMP/7oehBOfwzYsrU/bPIc7rdAXQg==
X-Received: by 2002:a62:1681:: with SMTP id 123mr5118336pfw.306.1591292571712;
        Thu, 04 Jun 2020 10:42:51 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l14sm6146464pjh.50.2020.06.04.10.42.50
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 10:42:51 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: re-set iov base/len for buffer select retry
Message-ID: <c884da5c-19e6-873d-9bce-371fa74add68@kernel.dk>
Date:   Thu, 4 Jun 2020 11:42:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We already have the buffer selected, but we should set the iter list
again.
    
Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d2bd82387a4c..70f0f2f940fb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2363,8 +2363,14 @@ static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 				    bool needs_lock)
 {
-	if (req->flags & REQ_F_BUFFER_SELECTED)
+	if (req->flags & REQ_F_BUFFER_SELECTED) {
+		struct io_buffer *kbuf;
+
+		kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
+		iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
+		iov[0].iov_len = kbuf->len;
 		return 0;
+	}
 	if (!req->rw.len)
 		return 0;
 	else if (req->rw.len > 1)

-- 
Jens Axboe

