Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E6C2793B3
	for <lists+io-uring@lfdr.de>; Fri, 25 Sep 2020 23:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgIYVmU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Sep 2020 17:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgIYVmU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Sep 2020 17:42:20 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3DFC0613CE
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 14:42:20 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id k133so3683896pgc.7
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 14:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=IUVuiTT6QpX6Tvtz21Sp0V+8zcQCszxgr5GTENPTF0o=;
        b=CWC49QgevxSb0+Vg5PLYD0gPIa39gbFLrmdi4TxICcqiHBYf93yaG4PmpmyBYQB8sz
         Blc5379DoihHQzLM8BlPDBGVt1RAq4OukcchR1uKdx/LAiZQj0u8Di9R6mjTLMZ1P36Z
         6XFpSSzcuiYF+MFfCQwJUBrbn5IDkYHV3aSlBmIvOAeZVDadKoCuCa5sDdEfUW5gERl4
         s7IQRXdtIW9baMmpnw4+klcmb81BhiryCA2J/GAwwQV71/aiNXThBKXRIZzyIMKFX2gs
         aqRhxaWtVzl7sR2pbDOaUmfmUYWzeBrg0/V8W5vS9RqdD1Y1lsbRLf9EUiv/FELKzeY+
         gEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=IUVuiTT6QpX6Tvtz21Sp0V+8zcQCszxgr5GTENPTF0o=;
        b=k5iw6DGOPnzrL3Hetli+UbtlLAuRJpc2Z7X1kKv1lAUJGhvqwcDOGWRQNTgiaH798r
         djQe47VlAVF8yu/ErN2GI6uiFZtXd8AWwrpKkYMUEUSmRp9QHRGsk1uyHcgJ5sG/DBWV
         DbIZxWfv4rBw4EtSE5jXzt7HZfwBjEu5eZi7s3acfPvaKLONYJsgG8xVIKGUmPy3rWJg
         p4zNacQJf6wQJ9+3KL7HI4bcS0jR8wAgHrdmpOmUU7pGj8FaNN4mTDzcSONwANVwRIbF
         WZW9/UjfMoPqeo6BUv9gKtdSgPHM1duC7+RVYvLT6loy4RgMWE7SABDfAXMmJHhREQN6
         k0QA==
X-Gm-Message-State: AOAM531wmmVB+UupI2W13F/KfLJF3nyoefjvn+z4EuPBmQImwNsiaBpK
        DsCXHofVP4NUFs6gBhx/X5E86PQVG1j72Q==
X-Google-Smtp-Source: ABdhPJz8UCF1H43cXCiFBzLW1jw4+sdUH6iECs8YZa5Po1x9aSxX5Z9avheCw/gzjziWuBwDOQtI2g==
X-Received: by 2002:aa7:8583:0:b029:13f:7096:5eb with SMTP id w3-20020aa785830000b029013f709605ebmr1175678pfn.0.1601070139311;
        Fri, 25 Sep 2020 14:42:19 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21d6::1a1c? ([2620:10d:c090:400::5:1c5b])
        by smtp.gmail.com with ESMTPSA id d15sm3742237pfo.85.2020.09.25.14.42.18
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 14:42:18 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure async buffered read-retry is setup properly
Message-ID: <70b160c1-43b2-21cd-cb1d-faa30f9bb7f4@kernel.dk>
Date:   Fri, 25 Sep 2020 15:42:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A previous commit for fixing up short reads botched the async retry
path, so we ended up going to worker threads more often than we should.
Fix this up, so retries work the way they originally were intended to.

Fixes: 227c0c9673d8 ("io_uring: internally retry short reads")
Reported-by: Hao_Xu <haoxu@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ad828fa19af4..11b8e428300d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3172,10 +3172,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 			goto done;
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
-		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
-		if (ret)
-			goto out_free;
-		return -EAGAIN;
+		ret = 0;
+		goto copy_iov;
 	} else if (ret < 0) {
 		/* make sure -ERESTARTSYS -> -EINTR is done */
 		goto done;

-- 
Jens Axboe

