Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DB41DEFD4
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 21:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730871AbgEVTQB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 15:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbgEVTQA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 15:16:00 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF795C061A0E
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 12:15:59 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id w19so4743890ply.11
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 12:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=AmRIh3/Hn9Jm/0oPJsKouqFQl6TaG/kanQqDf2eErdM=;
        b=a2dDnSFWDxAPxHfJzIIqmcP+t7zgTLHnD+1Fz/dU4kppP1SCFZvxDvn9bnhZJJhwFv
         IylA1mUv0/9D3K/sUYWXEPilYCBNXs+0v11QsJ7+YoZMoF/7XBS7U12Yj3TAhBrSvm4y
         KHgIRdLfNMIg40XQkZK1vzkkueDXvBCXXp7qxZ+sxg+7vjHVwbjv1BPuZcDWQOPeZb9q
         o8tsEQjiR1/h+MCNhEDwBGekI8jZDu9lfOICBA7KKowdDQYD+N3kWpHIoemPmobwrDKn
         mxCH13C4Il6pKpYZSm6rqRvGV1IWV/Ogv+Ikh7Fx+payWCTmTqo7cJeWG6J6hALml/pj
         OoQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=AmRIh3/Hn9Jm/0oPJsKouqFQl6TaG/kanQqDf2eErdM=;
        b=UlI+LGSoSbiNkVBZC0mR/2pdF/14NNrDchUU3juKOc49WGZf2mL5goNxnvhBN+cmo/
         tUeeTW+utt8c81H77HYeVmGM4t2ADON4u3Sw2PSFY6SvXBpmi/JMuSckBL/JJ4m/QOUY
         VRVxI0WCI+VRaH7VNll54/6s+J13YPTtPf6cq0tBr5qOJrBXqxyomXNbokDgFpAwVyjT
         FrxB+/4N9MbSb1M5CYYi6JNs/TRyFS96wBnAt8Enxi1ipJKTS795WFkIZrMYeHSgYCbS
         kJQxHVSMNVpy+IcTSRASaX2YXglE5CGRwvJ0TAULv3fVV2Xq/oWg2uGrzQ94KHMkpeU2
         ZlLA==
X-Gm-Message-State: AOAM5329JXm5nLWKvT/VwBU3LhdXwcAn2Uh7iJJtW7O2qUhM4RJYpfgh
        96Px/gFFrg0fq9jgMqnbHefydZC4WDQ=
X-Google-Smtp-Source: ABdhPJxL82fIqfdYADWrgmEDejSY9wMjGn89IH8ey9beCLHqXz+Ls97BHyyyuq5RlAlyF3ZToP8iVA==
X-Received: by 2002:a17:90a:ba18:: with SMTP id s24mr6572985pjr.192.1590174959232;
        Fri, 22 May 2020 12:15:59 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:892a:d4e5:be12:19f? ([2605:e000:100e:8c61:892a:d4e5:be12:19f])
        by smtp.gmail.com with ESMTPSA id hb3sm3937778pjb.57.2020.05.22.12.15.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 12:15:58 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: include file O_NONBLOCK state for recv/send
Message-ID: <d88692a9-2143-421b-9d50-f85d7ab52432@kernel.dk>
Date:   Fri, 22 May 2020 13:15:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We only check for MSG_DONTWAIT in terms of whether or not we should
be completing with -EAGAIN or retrying, ensure that we check the
file O_NONBLOCK flag as well.

Cc: stable@vger.kernel.org # v5.6+
Fixes: fddafacee287 ("io_uring: add support for send(2) and recv(2)")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 792720b2c01e..bf75ac753b9d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3702,7 +3702,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock)
 		msg.msg_namelen = 0;
 
 		flags = req->sr_msg.msg_flags;
-		if (flags & MSG_DONTWAIT)
+		if ((flags & MSG_DONTWAIT) || (req->file->f_flags & O_NONBLOCK))
 			req->flags |= REQ_F_NOWAIT;
 		else if (force_nonblock)
 			flags |= MSG_DONTWAIT;
@@ -3961,7 +3961,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock)
 		msg.msg_flags = 0;
 
 		flags = req->sr_msg.msg_flags;
-		if (flags & MSG_DONTWAIT)
+		if ((flags & MSG_DONTWAIT) || (req->file->f_flags & O_NONBLOCK))
 			req->flags |= REQ_F_NOWAIT;
 		else if (force_nonblock)
 			flags |= MSG_DONTWAIT;
-- 
2.26.2

-- 
Jens Axboe

