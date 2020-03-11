Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8789A1820D0
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2020 19:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbgCKSaU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Mar 2020 14:30:20 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37564 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730768AbgCKSaU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Mar 2020 14:30:20 -0400
Received: by mail-pg1-f193.google.com with SMTP id a32so797405pga.4
        for <io-uring@vger.kernel.org>; Wed, 11 Mar 2020 11:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BxZbaKbsS1IaGahDQhL0vut6MVcrp8tQKTp+ER/O00Y=;
        b=Cc9O753W9LvcReYVC9EDdHVhe62irX6doAmVS+ZSm7bSV1+YfR+jqX28ExSlsq8Txq
         srKEZ1PGRYtH4IdvYmR1D0bjMDnZonKwMei0SgwYKxEohbk+RpyAXNIMAvgnI8ZJ+3ua
         FXdU3KOsaxtFfOk2O4JzSfn29ix3V4h7rjrDzu/688JiT7keYeC8G7GVE4vyU61G41nS
         mh+PRJkInH3QL6kCsLuX8hTKEkodjmhsInrMHKafwoel7ueLb/L2awypsF6bCMLVUwAS
         0hk63HLePrcutMCMcQURYKestEH68hA6FfVIyNqicibHCOztENDQN+k3MValDnOvJra/
         vpGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=BxZbaKbsS1IaGahDQhL0vut6MVcrp8tQKTp+ER/O00Y=;
        b=tC73ky75QqzjsOdPeUtx2TVCzetTpaN6u1bHctREOYGC5kqdvTLVfbBFombMPNPUpx
         5lr8ByijX0Tc9Y5XQ7adkOjNJG9+ufzBqtsuMKneHAcQ0gbhnYaV5eH1MhcY+huqUG/U
         6s6pgsWbHPGVp8LcPGripCk0k6JMnCzm46hJKddxMJfM2hIRLMDMOv97VAA3z9FQa2wp
         7IGsT3vX6ubBJRN+ZBI7U77QisrfN+8Lkd1D10cURSv5aHjKMqfQ3ei+5N0O681+cgZm
         bCVYH/cgPN/oeHdQ5D/qOb44hel50Mo4AapZX2DQD77qEf+j92Pd2SrgFk6Q6HbMIjCb
         dhHg==
X-Gm-Message-State: ANhLgQ3X4YX9m1WmI/++7VxudFoFYvjxDzWlKySfq7BE4Vo80/fWOUfD
        gg3X45CP94NYQjrGiRqrGrkMCVDXCf7JBA==
X-Google-Smtp-Source: ADFU+vsyfFOMkJU7LWW7SU58gQ1bJ1ShmKUg9aYshiVhJYDUVpp20FL3MQQHOtUZ9jEkXqaiWnHEBg==
X-Received: by 2002:a63:5465:: with SMTP id e37mr3933352pgm.411.1583951419046;
        Wed, 11 Mar 2020 11:30:19 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c1::1835? ([2620:10d:c090:400::5:d375])
        by smtp.gmail.com with ESMTPSA id a143sm29062855pfd.108.2020.03.11.11.30.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 11:30:18 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix truncated async read/readv and write/writev
 retry
Message-ID: <62d7aa88-8765-d0a1-0db7-6b20cbf9a3a9@kernel.dk>
Date:   Wed, 11 Mar 2020 12:30:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ensure we keep the truncated value, if we did truncate it. If not, we
might read/write more than the registered buffer size.

Also for retry, ensure that we return the truncated mapped value for
the vectorized versions of the read/write commands.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9f1a462eb780..55afae6f0cf4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2360,6 +2360,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 				*iovec = NULL;
 				return PTR_ERR(buf);
 			}
+			req->rw.len = sqe_len;
 		}
 
 		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
@@ -2379,8 +2380,10 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		ret = io_iov_buffer_select(req, *iovec, needs_lock);
-		if (!ret)
-			iov_iter_init(iter, rw, *iovec, 1, (*iovec)->iov_len);
+		if (!ret) {
+			ret = (*iovec)->iov_len;
+			iov_iter_init(iter, rw, *iovec, 1, ret);
+		}
 		*iovec = NULL;
 		return ret;
 	}

-- 
Jens Axboe

