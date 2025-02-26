Return-Path: <io-uring+bounces-6782-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2005A45D60
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 12:40:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F5BD3AAF49
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 11:40:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65C72153D1;
	Wed, 26 Feb 2025 11:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LeUFI9Mq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7C621505D
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 11:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740570041; cv=none; b=g3B6l6qhTadEC4EklvnSL1sYxei5gT0d3kDcTZ3FjNu7gc1vBIpt9+lOFVq/YpsAvdps8eCLx+EncYGN3S3gcX7yKsuEKg/9cHKrnd+OQrU9l40f0IlSJqDKB18H9JbUo0S1QqQkmYzFXzh6qhoIPTe5WFRSstQ1yPo+gtus7LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740570041; c=relaxed/simple;
	bh=24FvXa9aG9vZ4yHSjilp07gbtCfvWhj/d8PPrNWFwKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NR0N892wG8SMktROGiusF8U6eC6PXEhIk3fIhFryK9OEpAlcjNFszHLckJYVmYZY1A89PMKXpHEfg6vZP2Ph/oNZNR1M5JSOWrF8MiljJc9p6FtxMC2h1BK0sxtS7KejGWVcu1QwvHzVFatfNB2Lo+eMoIgY6sgw2yKUaABx9KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LeUFI9Mq; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5e04064af07so10690002a12.0
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 03:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740570038; x=1741174838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jp+JgVKUVU7tG6AlWMu65MLLWLDtLTF+BDF9puXzNcs=;
        b=LeUFI9MqTg2s3S8lDME99rq8epgjC4Lg5wnhkrZ+oNU3C3NZbuOWE3zm7TfN7CUEs3
         CZPeJ5WsZt9rw0DI+S1JfWPz/dF54fiqzyoXs+hcfvilXcWAlWwQWFxeV5DPJIh9AItL
         3IGqitVu5GcbrVEnrN2S44uJ2iFV8K4SWNhi3bJcIOm36HutnGKbeeC0yPrT1vARifby
         ZrpovF6dRDIP+HP2pbuHalneOshxJ5NSrnbro935Md6AD72WyFo9L6hLDRkylm1PgH+5
         U1LutIM64gemcds2XCyfnrjun3Rhhb+kVKsv42k3HJ/aP92LqRd13gVY+X6GMMH4ifk4
         Mkyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740570038; x=1741174838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jp+JgVKUVU7tG6AlWMu65MLLWLDtLTF+BDF9puXzNcs=;
        b=MFJadfuIPdZXZeDVGYBzMh7ofyiREkoi4cI6H/Ww6tpH21SsFjPoid8bqYvBQTxp89
         dMC8ZVhe6JgN5mdBOzCcmPZ5ZwnHCTw/4rBK605WvZHQRNZTX90xou9il17Dx4WyYktE
         RsKHL4M5+ytOx9HymIdtnN/oAUmcbnNKLZv6VC3lea3DSLyWXgTB6kGnHCeLTrXzpVv1
         3RD19Clc/VrTtQyyaKEwfuPLyhJzVckw1jO1DSvyDRQiIaBebhFBuHBynWCW9isTNRYf
         Wzh9IwTPpkxBlntDLW4sy3dK+WsbwNiEkcRXLDIZW/DZFq4CV1KMH2M3aZX2aj+IOcRH
         W5/A==
X-Gm-Message-State: AOJu0YzbwKzqFzDWG/pr/sPwLyC9Ue6KW5I5odUzO56m7sPmzEV13GqQ
	Sw+3uBAZJnvkbCWm32MtOldvQ7oduPJdQeDrA6Q+6K/wqvosvFTejpfLjQ==
X-Gm-Gg: ASbGnctbJBJYzktSPWbMhIU1FTryARde+Bu68f0qo/0VWVeX+SyMmKeqPWpQq58fhHl
	BUxPfTcZu3S5xnWAZzvvUViAsndMW8j8qdz4/bSgeSPbfWeoeMA6fiYfAWlWlqJ8AVXROXp+ZOb
	SABPvxKAPYS800zsoKItHrkwjCqOtsjJVzfKSpbSvd6uL8Kvh3v5LM/LgXH6gFiJBcEPehXnyOF
	UzrjLHRlZ5CdSckoO1XdZomIqBwrqH81qC0yFVkI9vaVGgxBaktKTcXQV39vko6DP7X6Hv2r86J
	xg8bpnal1A==
X-Google-Smtp-Source: AGHT+IG3uk2c8fvUhhmNHDfR5Z3PwlP2xPAFP3fTe7U1tpyPBps6HLjezA5hLKUKoJCSrM1YGQ0oLg==
X-Received: by 2002:a05:6402:4604:b0:5e0:8c55:531 with SMTP id 4fb4d7f45d1cf-5e445994128mr6374449a12.14.1740570037693;
        Wed, 26 Feb 2025 03:40:37 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7b07])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e45b80b935sm2692418a12.41.2025.02.26.03.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 03:40:37 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/7] io_uring/net: isolate msghdr copying code
Date: Wed, 26 Feb 2025 11:41:17 +0000
Message-ID: <d3eb1f81c8cfbea9f1aa57dab90c472d2aa6e371.1740569495.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740569495.git.asml.silence@gmail.com>
References: <cover.1740569495.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The user access section in io_msg_copy_hdr() is overextended by covering
selected buffers. It's hard to work with and prone to errors. Limit the
section to msghdr import only, selected buffers will do a separate
copy_from_user() call, and then move it into its own function. This
should be fine, selected buffer single shots are not important, for
multishots the overhead should be non-existent, and it's not that
expensive overall.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 0013a7169d10..67d768e6ecdd 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -243,6 +243,24 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 }
 #endif
 
+static int io_copy_msghdr_from_user(struct user_msghdr *msg,
+				    struct user_msghdr __user *umsg)
+{
+	if (!user_access_begin(umsg, sizeof(*umsg)))
+		return -EFAULT;
+	unsafe_get_user(msg->msg_name, &umsg->msg_name, ua_end);
+	unsafe_get_user(msg->msg_namelen, &umsg->msg_namelen, ua_end);
+	unsafe_get_user(msg->msg_iov, &umsg->msg_iov, ua_end);
+	unsafe_get_user(msg->msg_iovlen, &umsg->msg_iovlen, ua_end);
+	unsafe_get_user(msg->msg_control, &umsg->msg_control, ua_end);
+	unsafe_get_user(msg->msg_controllen, &umsg->msg_controllen, ua_end);
+	user_access_end();
+	return 0;
+ua_end:
+	user_access_end();
+	return -EFAULT;
+}
+
 static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 			   struct user_msghdr *msg, int ddir)
 {
@@ -259,16 +277,10 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 		nr_segs = 1;
 	}
 
-	if (!user_access_begin(umsg, sizeof(*umsg)))
-		return -EFAULT;
+	ret = io_copy_msghdr_from_user(msg, umsg);
+	if (unlikely(ret))
+		return ret;
 
-	ret = -EFAULT;
-	unsafe_get_user(msg->msg_name, &umsg->msg_name, ua_end);
-	unsafe_get_user(msg->msg_namelen, &umsg->msg_namelen, ua_end);
-	unsafe_get_user(msg->msg_iov, &umsg->msg_iov, ua_end);
-	unsafe_get_user(msg->msg_iovlen, &umsg->msg_iovlen, ua_end);
-	unsafe_get_user(msg->msg_control, &umsg->msg_control, ua_end);
-	unsafe_get_user(msg->msg_controllen, &umsg->msg_controllen, ua_end);
 	msg->msg_flags = 0;
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
@@ -276,24 +288,17 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 			sr->len = iov->iov_len = 0;
 			iov->iov_base = NULL;
 		} else if (msg->msg_iovlen > 1) {
-			ret = -EINVAL;
-			goto ua_end;
+			return -EINVAL;
 		} else {
 			struct iovec __user *uiov = msg->msg_iov;
 
-			/* we only need the length for provided buffers */
-			if (!access_ok(&uiov->iov_len, sizeof(uiov->iov_len)))
-				goto ua_end;
-			unsafe_get_user(iov->iov_len, &uiov->iov_len, ua_end);
+			if (copy_from_user(iov, uiov, sizeof(*iov)))
+				return -EFAULT;
 			sr->len = iov->iov_len;
 		}
-		ret = 0;
-ua_end:
-		user_access_end();
-		return ret;
+		return 0;
 	}
 
-	user_access_end();
 	ret = __import_iovec(ddir, msg->msg_iov, msg->msg_iovlen, nr_segs,
 				&iov, &iomsg->msg.msg_iter, false);
 	if (unlikely(ret < 0))
-- 
2.48.1


