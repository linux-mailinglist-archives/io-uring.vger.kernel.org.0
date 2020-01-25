Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9781493C3
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 07:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbgAYGOz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 01:14:55 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:55052 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgAYGOz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jan 2020 01:14:55 -0500
Received: by mail-pj1-f67.google.com with SMTP id dw13so297135pjb.4
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2020 22:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=FAKFlcYVYdI0VmjebDNmDqSAN9JunbJMIDMS51223G4=;
        b=LXJ1SWh/WVUEQxvI/5RTa6yFJdQM6Ej9vyo6EKAGOTCxu2iB2hMoaZheR5RDtsSKhr
         HeslNnPl8CkELkcnRXLXkqMQY6BGqsACDdBKMVwoNEzz8I7cTKgF4C1c/kmcmD1d1wkl
         B/8PTVfjkX1SCQiVCJeQRq7i166FUnSj7VB73hpkaWCqonvSfKvFy8YXk8GLs0MmXAbN
         4M5cpEqXv8zSZEs2z6AMrMmAGQ4Rjw5Nn6RNF9cDxI5xLLCW4rKw51SONIqdDW/M+/bj
         /do7OkkqohLyxOwbEs4HzptixLOHZqqLj5aPpLBbCI6CoSVvPSoEWFzip2QiE9y07tJp
         qo1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=FAKFlcYVYdI0VmjebDNmDqSAN9JunbJMIDMS51223G4=;
        b=rJwHrMx+ujNepWaysHgfZsGlA/tk6fxDo3BT2qBU3XN8oB9JIgmon2lvZMaVIeyiMB
         qJrr/S/5q6k8kKfnbdn/L1jhZR/ppvFMWhEIBDwrTHxbXNkuj+NyRGrID4ue2E+UqMba
         WtQtv3yAaa24flrD3PubPF/Y/Dfmlrbn2tilc45ds12ajUYQQUkRLfhr504EIQ+955nh
         k8udvqPRUY4b9bM5RRft0jINri6SUwUemaApHGruNAUS1Duo0/sjG399aH9I+QrMGPaL
         dNtu7F1oFkvxfdBVXMyfbepTIKnJ9egZksV9XCn0+3YJRcmM9PuSexQ7VF9vqkIt0paO
         3vXg==
X-Gm-Message-State: APjAAAUFgTBB5bEF15CvImaITft3iZMs0AF4tao3mxfEMVJbaRjjJOaL
        NiR+9lKvjS8vbIHB4gZxYckAgYY9pps=
X-Google-Smtp-Source: APXvYqzze0xJPkYnDnCsOH/l2BpIH3tesvjURwKn7hjFBJn8+0xG9k4sJ0Z2mKsEKwqiwk6VMZOuZA==
X-Received: by 2002:a17:902:8a8d:: with SMTP id p13mr7285386plo.159.1579932892995;
        Fri, 24 Jan 2020 22:14:52 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u3sm8659949pga.72.2020.01.24.22.14.52
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 22:14:52 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't attempt to copy iovec for READ/WRITE
Message-ID: <3e074be7-e282-9e1d-72e2-5002fadd53ec@kernel.dk>
Date:   Fri, 24 Jan 2020 23:14:51 -0700
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

For the non-vectored variant of READV/WRITEV, we don't need to setup an
async io context, and we flag that appropriately in the io_op_defs
array. However, in fixing this for the 5.5 kernel in commit 74566df3a71c
we didn't have these opcodes, so the check there was added just for the
READ_FIXED and WRITE_FIXED opcodes. Replace that check with just a
single check for needing async context, that covers all four of these
read/write variants that don't use an iovec.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3dad12906db3..c1d1de2a2968 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2112,8 +2112,7 @@ static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
 			     struct iovec *iovec, struct iovec *fast_iov,
 			     struct iov_iter *iter)
 {
-	if (req->opcode == IORING_OP_READ_FIXED ||
-	    req->opcode == IORING_OP_WRITE_FIXED)
+	if (!io_op_defs[req->opcode].async_ctx)
 		return 0;
 	if (!req->io && io_alloc_async_ctx(req))
 		return -ENOMEM;

-- 
Jens Axboe

