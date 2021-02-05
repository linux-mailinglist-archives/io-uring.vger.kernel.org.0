Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7D1310208
	for <lists+io-uring@lfdr.de>; Fri,  5 Feb 2021 02:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbhBEBDI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 20:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbhBEBCe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 20:02:34 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75417C061786
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 17:01:54 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id b3so5746350wrj.5
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 17:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rz/RzY0ITfhGhjik2N3xccJJtxO9hTdnPZUhXYchAJU=;
        b=U0HeZWYBGfLxIjBp4+CR9PHPcOIrqpFK7PzAOIRtjJCFrBgi4SX2IHITiR+93ubVnw
         PZpECYV4ejL1gbls0OIMjEH6yClgX6w9K1vStXVxJfUzokZ9R5HCkr0FGriZ0O2uYjrp
         ZEQjFpKfzpjnmEFatRZBlskpCm7KUjq+9ZnZxiy9LSPYQ00lT7hpomjTH957nq79cl5R
         3uPSCfJ8fcgp3BwIjxkVqTgKXXX/Z8k4q2uq+X+e8mCJ7UG8XYgB8S9SNHKrsYd6R566
         dY8TlOhokK3YZHl29fSZzIPOobgb3Hkcfmk2xB03Uf7oQcYYmN2UDdXgbfRzeDlYc6Q6
         5gzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rz/RzY0ITfhGhjik2N3xccJJtxO9hTdnPZUhXYchAJU=;
        b=IQwAx7EEL2wKoN3uGBmNGrXB2mW5lO7n9DPbHTdS4xpWh4O2igohymJCPQpL1K27QD
         OLhRwGL63ICJolR/DWXvOaE6H2GQiN3ybLNYzC8UdJQPufA97YviOHIVICJ6YCDXY/4z
         k8FpqnQ/2OitvjffCrS1RKLPAFxt24XDYtlWZA1bkanGs3gaFR7Lx2YCBURMFVekcmWY
         LLUHNVPWJkhDKDAxqKJ7TX8TYnCFyI/MjaZNgj6btwZmOyRR5PjksNC/eA0K/Ermf/Bz
         d6jmdU7jbCGNzTgbTVn3lwMzDzQujM6T/SvdLGGT7Wqdo5nUjIaO/K239s/bRyn2bzVp
         Ovkg==
X-Gm-Message-State: AOAM532oL2OcNKl+QprioQ4ema/ICUpJBtXs0NdsaV8/OLoXniqMQYi0
        K5PhJoA5cfOvGke48NiqpGc=
X-Google-Smtp-Source: ABdhPJzJ1cDUS/HiISFvWIlgjLyrJ/FgZRv1LimFWeOL1OG+RVIdbGWClgZ0auHcP3aL6KlBIZKAfA==
X-Received: by 2002:adf:9b8c:: with SMTP id d12mr2102568wrc.51.1612486912955;
        Thu, 04 Feb 2021 17:01:52 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id i18sm10853199wrn.29.2021.02.04.17.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 17:01:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: set msg_name on msg fixup
Date:   Fri,  5 Feb 2021 00:57:58 +0000
Message-Id: <211fa9b0e2ffefbdcffcf934911581149dadb8df.1612486458.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612486458.git.asml.silence@gmail.com>
References: <cover.1612486458.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_setup_async_msg() should fully prepare io_async_msghdr, let it also
handle assigning msg_name and don't hand code it in [send,recv]msg().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b740a39110d6..39bc1df9bb64 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4558,6 +4558,7 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	async_msg = req->async_data;
 	req->flags |= REQ_F_NEED_CLEANUP;
 	memcpy(async_msg, kmsg, sizeof(*kmsg));
+	async_msg->msg.msg_name = &async_msg->addr;
 	return -EAGAIN;
 }
 
@@ -4610,7 +4611,6 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 
 	if (req->async_data) {
 		kmsg = req->async_data;
-		kmsg->msg.msg_name = &kmsg->addr;
 		/* if iov is set, it's allocated already */
 		if (!kmsg->iov)
 			kmsg->iov = kmsg->fast_iov;
@@ -4839,7 +4839,6 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 
 	if (req->async_data) {
 		kmsg = req->async_data;
-		kmsg->msg.msg_name = &kmsg->addr;
 		/* if iov is set, it's allocated already */
 		if (!kmsg->iov)
 			kmsg->iov = kmsg->fast_iov;
-- 
2.24.0

