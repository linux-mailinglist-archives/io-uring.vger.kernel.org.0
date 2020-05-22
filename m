Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFA61DEFD3
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 21:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730840AbgEVTP3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 15:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbgEVTP3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 15:15:29 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3588C061A0E
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 12:15:28 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f15so4763842plr.3
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 12:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=2pxXjhh2wQZLJvi0e+K3hm5HMY1QP111OD7JAc4kQgY=;
        b=RlrLPJ2LYVkIEfBFh2jgsQoi7BXgq7KKdU3s3lhTdLJMZOtD0BADddoaILx7Ybobgt
         ygzpSqDfiJrAMci1udrQRbw2gBnBG6pffd3YqppcNotOHznlAEllqNp/PDV2nfhumPH9
         Pzx9natN0q0o0DMlgMeXucrCY+nMQSih41L0PeINW6AsXICJCWHja1WwbOUVr22fc+HL
         E0X2LP81OQ0YAlE2jz5xd1Mf4rdkI+DZvwYVJ0DOGwbvo2G4tGyFmE/bk+6gtTSYE0mC
         0SJWMVbqMUYBmciXjJEr/VyLdvsPgwSi7gNLzvZgP1MIp7EM3NFvpfXCQGU2I3cJSacZ
         /UWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=2pxXjhh2wQZLJvi0e+K3hm5HMY1QP111OD7JAc4kQgY=;
        b=rMO9yekGcPGNEJ1D+FHlcZbz4wlDm7Y7SrzQTjygqd52Gu3thE6d/7OlRkJfh/+ZsL
         RyP+EIx/7p28t0rDdaKIaHi+HGsiLxN6glG3TKIGYorbe74sn6+XDbG7ueyFUcgAZLoa
         q8+Ex8HiGosNAcfttQk4YZbNE7ueBfmDXLKOZrr9GgtULCxdvm6TwOlLNZ24IiNyrdik
         5FhqtiBbK3OgOCL6H8dZZuP27smKbubqmva49+86zWdqJitFJrIFwhWBu3V0mL3vrW9B
         v+2mmykSUaTgYyHu0xlIIQ9fJaPotvibHjVu1zE/4tP2ngEQjxJuFVFX9EN2xQSxDTfp
         MwUA==
X-Gm-Message-State: AOAM532tJtILoUye0QaVJFNVnHlTpMLHZ8fHUOS9Rs0ZPJkP7PMvRaHA
        fI0IYnw1cpwghZ4PgTuXInR0etIM8Qw=
X-Google-Smtp-Source: ABdhPJzyLewMIHVB+30rLeAvYQrBbxR3FNmtx239YKsPhNL+rUTWQBcMsawXByTppaHLmNSrv6p+JA==
X-Received: by 2002:a17:90b:30c5:: with SMTP id hi5mr6099276pjb.110.1590174928064;
        Fri, 22 May 2020 12:15:28 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:892a:d4e5:be12:19f? ([2605:e000:100e:8c61:892a:d4e5:be12:19f])
        by smtp.gmail.com with ESMTPSA id i12sm7291391pjk.37.2020.05.22.12.15.27
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 12:15:27 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: include file O_NONBLOCK state for, recvmsg/sendmsg
Message-ID: <69ed3063-f491-2a8e-7026-871a537d6317@kernel.dk>
Date:   Fri, 22 May 2020 13:15:26 -0600
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

Cc: stable@vger.kernel.org # v5.3+
Fixes: 0fa03c624d8f ("io_uring: add support for sendmsg()")
Fixes: aa1fa28fc73e ("io_uring: add support for recvmsg()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0b51f21e5432..792720b2c01e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3654,7 +3654,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 		}
 
 		flags = req->sr_msg.msg_flags;
-		if (flags & MSG_DONTWAIT)
+		if ((flags & MSG_DONTWAIT) || (req->file->f_flags & O_NONBLOCK))
 			req->flags |= REQ_F_NOWAIT;
 		else if (force_nonblock)
 			flags |= MSG_DONTWAIT;
@@ -3899,7 +3899,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 		}
 
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

