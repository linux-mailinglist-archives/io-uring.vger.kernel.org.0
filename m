Return-Path: <io-uring+bounces-7154-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53442A6AD1D
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 19:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3ADD4681F6
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 18:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3232C1953A1;
	Thu, 20 Mar 2025 18:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HJnO/CFJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E6C17A30E
	for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 18:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742495278; cv=none; b=k8QJS0UTeqs4gvIEXgUr3XjzCKy46HfD+JtTexVvknx0EXuytRsLayXuibKOYq04nOdrKtxBIoGLTOzswaa1mKsXF5rkRmI3Sr0oudtW0APdimeNPWTjquD5/7YNAOAqHjBYhFj3V1PRXGVZEFWGSFVLdGOApq6Yo5ugs3Yy7yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742495278; c=relaxed/simple;
	bh=/nWK6wsiU3rcdT/rf2J6WBDn3OCSlbzvc8aDgV2K6NA=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=C+SBkQpi2hnZlAHxvp0gDa6fa2rapTUMDdKcMUTBSRiadilDEmBkd+OF0wKKgkq+0ldfZXc2bpl1oIzqNC6aCpQryReG5CsR7d7yJ3dKdzej0WO5/O+JP0VQLeM9CMPAziNLL/AKOxjM/Nm0GXWSMCzmlryKJtWOo4QF8vyw+9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HJnO/CFJ; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d571ac3d2fso10221875ab.2
        for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 11:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742495273; x=1743100073; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QYK/zW3RMQjHiWbvSgO54WKIp3v9oYIucZxwk0zPOnA=;
        b=HJnO/CFJXD0f/kXBxLrn5cf9nkron3XJBNIo3nBrmb4E8et8Yg2wpk5N09QTPGrKAE
         LcdycgbniIqgSCH5xsyDJesR7k3NplrggCHG4Bin2oi+Srw/78C5jXXrtRvyncphbp4e
         hEGrxa6XR85UTnvrTzAJfrYF9J3Od6FfiyHH/zkzJ+W9u1osmx7P7ReOww7/bxqEuiIh
         i48UEwIzI72Q67xtfJ1K/keHdyzeboXMo5nhhtm8UL1Xt6ga/+XIkN6GhOsBN853RBxb
         z6zGomLQsnuVxOuGZk+hngE/G29zaiQ09Um338xMInN3d7THl8NpfDaZ7qH57RQ0Z2GJ
         N30g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742495273; x=1743100073;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QYK/zW3RMQjHiWbvSgO54WKIp3v9oYIucZxwk0zPOnA=;
        b=Z2FFuZZJNWs61rMbCRWxrLavTeVoZ2kLORTI9vyitShcepzOWRBDcT3bj8r8nOcAb1
         YH+y226vXAxgNJqzRmGwVKrJ5bDNj8o91BBHBMK+e46T793a+koDYIxH9MnJ/Qqq80C6
         CKTh4lOuAcytMwbMaqjwlXSwux+walBalBrlrq7Gs3oO81hHPCHhof5iJU2Hi8fPgSMB
         6aEoVybYSCzZmhefjx5a9FjnkxCnalvysKMXQZEXQFolIcJG1F0K+g9WFFvtWa2MIYWy
         TOjiad6axnoY8vc6yyR8eW4MegIyKyaMNQVLz2lgJ+O4lAaY/2wlSpILQutvmlLaJdJd
         VbiQ==
X-Gm-Message-State: AOJu0YyG6KHfEWkQqLuINtCMsKJMaqy/tnpD0FO3Sc4f7jRbsTqDzH/+
	6FkiurcKUoycj4LpJwNw4cMYiUlcf86S7NbYtxI6QPayu7J2tzTsCoWF5XeLW00Ixd1t+YU3fc5
	2
X-Gm-Gg: ASbGncuGOZPB9ebFHWeoO8GiMiYevo/DPCCKtu1gyDzUrDEtlq2Uw7IZWHfJTJHIz2Z
	+H0F+kNusDexud/+ikYazsXR7V5LX6JAzRetgHxIPycg7dH8aayiw9R5k0T8mx6QwRpDQnpd6zd
	5rTj/QB4mjZ7Pif68NWIKeT/aDSQ+MxehV5xNrwRgsuNoLue2NnSpr0O2io5QHooyRJFKGtNid5
	ZJwMdilKeHaTFDQ3pviRqi7VAYx9TT4jFRsmr66LL4ceGFQtNM2OJgc11X1GJaApkYttuqDbnV8
	Yi7IK227QYrTzWbChhKEFWqP+s7djgHsQ8RQcdiJCg==
X-Google-Smtp-Source: AGHT+IF9zLQQ/3Y4xF5Eq8GaRL0/SorSpMW5iBDNryFGwt2NxBtw2ZmXQapVBFv9AUCsB5TdPcDRWg==
X-Received: by 2002:a05:6e02:3e91:b0:3d3:d229:f166 with SMTP id e9e14a558f8ab-3d5961b12eamr5034195ab.17.1742495273178;
        Thu, 20 Mar 2025 11:27:53 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbeb0019sm39405173.104.2025.03.20.11.27.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 11:27:52 -0700 (PDT)
Message-ID: <3e865bb1-6b9d-4996-a228-ffa8477cb8fb@kernel.dk>
Date: Thu, 20 Mar 2025 12:27:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: don't clear REQ_F_NEED_CLEANUP unconditionally
Cc: David Wei <dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

io_req_msg_cleanup() relies on the fact that io_netmsg_recycle() will
always fully recycle, but that may not be the case if the msg cache
was already full. To ensure that normal cleanup always gets run,
let io_netmsg_recycle() deal with clearing the relevant cleanup flags,
as it knows exactly when that should be done.

Cc: stable@vger.kernel.org
Reported-by: David Wei <dw@davidwei.uk>
Fixes: 75191341785e ("io_uring/net: add iovec recycling")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 5d0b56ff50ee..a288c75bb92c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -148,7 +148,7 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	io_alloc_cache_kasan(&hdr->free_iov, &hdr->free_iov_nr);
 	if (io_alloc_cache_put(&req->ctx->netmsg_cache, hdr)) {
 		req->async_data = NULL;
-		req->flags &= ~REQ_F_ASYNC_DATA;
+		req->flags &= ~(REQ_F_ASYNC_DATA|REQ_F_NEED_CLEANUP);
 	}
 }
 
@@ -441,7 +441,6 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static void io_req_msg_cleanup(struct io_kiocb *req,
 			       unsigned int issue_flags)
 {
-	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_netmsg_recycle(req, issue_flags);
 }
 
-- 
Jens Axboe


