Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA827156C11
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2020 19:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbgBISdQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Feb 2020 13:33:16 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41759 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbgBISdP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Feb 2020 13:33:15 -0500
Received: by mail-pf1-f193.google.com with SMTP id j9so2517152pfa.8
        for <io-uring@vger.kernel.org>; Sun, 09 Feb 2020 10:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=HW2cqLHXfl8zs3dNREdFgCcFyLq0leEkQmkeXAPADBk=;
        b=XojAk9mPtljCT2S5Fa68Am2Lk1s+woF/Vp9X9gQaEb0mcVM8l2M2Gib8eEhaXiJL0F
         29VsaB9M8/nFHUp6x7IO7TlxrE7LqL5WJvviNB2d9crYM4bZ+FL5S53+mns7zMQwAjdk
         r35KsAIEJSy59xC9u9uIZmUL5S5aMkEYizpV85yika+r4RHbj5jYrlHa1JAKG5jJsWNe
         EJbwIt8DgPur2hmJu+qGzS6mMgSrK13MWKDVGz6PeJp+YfzhYkBADNFCYqCSabT6muel
         9Q5gdHoeA7B2+CmePys6g5xPNc2SsJoaIBg7jI9Hx+yv56M/tqwt86UEHmIGfiiaNheP
         Nukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=HW2cqLHXfl8zs3dNREdFgCcFyLq0leEkQmkeXAPADBk=;
        b=rXF3OAIu4Sr4y8jBXnwhj6BLb7jhCSwEF6mb/CRbY3RvOtCOHYMAJjEZZHvIsZxwVo
         4SRLFzBLO7gFRDRC+PneUeyJ7O/HWAsa7/9foIcnwECu53z4dU+o/rngi+q30YZ3uBb7
         qV6dHQ3rim8VsqWeGjhPne7y0WPSFcQ9dDis3MRlNaq0XY77t1mWyJHoDr9etOhLqAUR
         RyvGE7XdobZQ28dOHG/OiUjLM/34YYPdzIx9kljG7vXD2H6H2voiy+Iy69UfLg4xqQE3
         N797VaUK5VGJHuHW0cPt1OGrJyVHi4EUdYfzc69ofkWohiKpGniUXM7azdDeqcSc/b1I
         4pGg==
X-Gm-Message-State: APjAAAUHlBQb3xkvaapHJoNAI1QG4zco4uI+ooTSMvIU+x9T5NC74Bpb
        YRP6Cgh0V00LqbHaXyVy04s47k63pN0=
X-Google-Smtp-Source: APXvYqyFx6cCmbAMSPq/Ko4U8QbNB9LOMey44XPSx+9qmRtgyI9h/oK6efYlxKbV6C/9ESRmDTVXFg==
X-Received: by 2002:a65:4b83:: with SMTP id t3mr10105432pgq.195.1581273193518;
        Sun, 09 Feb 2020 10:33:13 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y9sm8900977pjj.17.2020.02.09.10.33.12
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Feb 2020 10:33:13 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: retain sockaddr_storage across send/recvmsg async
 punt
Message-ID: <fe4e99a9-2741-579c-7c5a-c010f5141bc2@kernel.dk>
Date:   Sun, 9 Feb 2020 11:33:12 -0700
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

Jonas reports that he sometimes sees -97/-22 error returns from
sendmsg, if it gets punted async. This is due to not retaining the
sockaddr_storage between calls. Include that in the state we copy when
going async.

Cc: stable@vger.kernel.org # 5.3+
Reported-by: Jonas Bonn <jonas@norrbonn.se>
Tested-by: Jonas Bonn <jonas@norrbonn.se>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bd5ac9a6677f..63beda9bafc5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -442,6 +442,7 @@ struct io_async_msghdr {
 	struct iovec			*iov;
 	struct sockaddr __user		*uaddr;
 	struct msghdr			msg;
+	struct sockaddr_storage		addr;
 };
 
 struct io_async_rw {
@@ -3031,12 +3032,11 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct io_async_ctx io;
-		struct sockaddr_storage addr;
 		unsigned flags;
 
 		if (req->io) {
 			kmsg = &req->io->msg;
-			kmsg->msg.msg_name = &addr;
+			kmsg->msg.msg_name = &req->io->msg.addr;
 			/* if iov is set, it's allocated already */
 			if (!kmsg->iov)
 				kmsg->iov = kmsg->fast_iov;
@@ -3045,7 +3045,7 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 			struct io_sr_msg *sr = &req->sr_msg;
 
 			kmsg = &io.msg;
-			kmsg->msg.msg_name = &addr;
+			kmsg->msg.msg_name = &io.msg.addr;
 
 			io.msg.iov = io.msg.fast_iov;
 			ret = sendmsg_copy_msghdr(&io.msg.msg, sr->msg,
@@ -3184,12 +3184,11 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct io_async_ctx io;
-		struct sockaddr_storage addr;
 		unsigned flags;
 
 		if (req->io) {
 			kmsg = &req->io->msg;
-			kmsg->msg.msg_name = &addr;
+			kmsg->msg.msg_name = &req->io->msg.addr;
 			/* if iov is set, it's allocated already */
 			if (!kmsg->iov)
 				kmsg->iov = kmsg->fast_iov;
@@ -3198,7 +3197,7 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 			struct io_sr_msg *sr = &req->sr_msg;
 
 			kmsg = &io.msg;
-			kmsg->msg.msg_name = &addr;
+			kmsg->msg.msg_name = &io.msg.addr;
 
 			io.msg.iov = io.msg.fast_iov;
 			ret = recvmsg_copy_msghdr(&io.msg.msg, sr->msg,
-- 
2.25.0

-- 
Jens Axboe

