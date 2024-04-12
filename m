Return-Path: <io-uring+bounces-1533-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8038A35FF
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 20:49:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E214A1F24C25
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 18:49:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1B854F87;
	Fri, 12 Apr 2024 18:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0jbqmgPo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62025502A9
	for <io-uring@vger.kernel.org>; Fri, 12 Apr 2024 18:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712947792; cv=none; b=sczFaxgDpqFEuhq8yoqgIkOqjlGEaskgoqM1zkXftN7MfZN8dhHK4RukmE7lblGWWLZwJth84sypYzEWiTZlYPAX/e0gJ8iWx/ViW5qccIFhThg4B/K/1JOsjedJiicUkniNsQtux8swPOIq3qBE3EuAT6kbXClBSmgH7e++x8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712947792; c=relaxed/simple;
	bh=XE4/Fp74w1epzGMaYIi2zdq0OoGgMk5zkjDz0OAoFN4=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Ris0zw5mVOjKxfH6gkKQHClEWzc10rnu9DvzcJ6L0VCGPbbHAaF8r17FBpsgPBRCsdKJ+gHWxWgT5AGd4MKIrU5h8HEPLaciJ3/hVu9wGFpDULaScqK5oo2GaH4N7HrmajVEMG/2pU7INj5/bdi2ucP5lCzRUkpJzBkLj2NeR9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0jbqmgPo; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1e45f339708so2927825ad.0
        for <io-uring@vger.kernel.org>; Fri, 12 Apr 2024 11:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712947788; x=1713552588; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Lo/Zrqah9xi3DZOoi/6cvdjl6wQdRzy20qzHLShNyw=;
        b=0jbqmgPoVc6nD5hSsH4IlkXTtAQ/l4LyCwM50y/4zNjERMIK7NDgJjeLqYbKdPsDJa
         2xHeKkWAKawQd8e4isdeY4gpq9cX6glYO/VIppvHnyyBLhV7eCGHDuNSvHf5P6qO4QHc
         2lY4kJfFYDmTbcPxOPv959Q+SI9crNrWfQJu4E61DgT5X1PV+P+cLkzS2IGz2mXDPlXv
         Th6MHg4zQs6aEnjCTVZUeL2wTpU5CZMwH0xxl1OzU+u09K4O4OOztCtPBgKiHqPbJdre
         eFLTqWWhL2qvEpvLIAO9Vba69o/4APGlv5Mf0kYRwGpz1XPv9Gxv+xrbok1pBr12wmso
         nrpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712947788; x=1713552588;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1Lo/Zrqah9xi3DZOoi/6cvdjl6wQdRzy20qzHLShNyw=;
        b=BmTJ7oxlSJyoxbdaeV6PQB7kbiJZ4oNegQrHWEE83hlmlVqrkrJv1IBtz2NwJZxD5K
         BLXGI1/xFzcP+xFsuDa4RKGmiFf24IyDj2CJlyuOvqLVZoEKUosN1JR8KULA+VmfnB08
         /2rwg82ODdhwvzQoMXY6hzfhCOxLI9xh4RdDbCiigX9OpKjP9TvEulSlwMeW3fwdIBEL
         oVCaLu9ZzgJHGc7dpiu/szLhmnwoHRPhG9NJVhn2xmD1iv1r3xKfPptwgHJzVqDMKDBv
         9HB8KhL2eRKzYasgyM0FR1XAB3Q7SpXEJYo+GPgn9X7deUW5P6uOpE5CsTackVD3Rk2R
         /WXA==
X-Gm-Message-State: AOJu0YyIkPxW6WsJHtkQ2rmcLgiCP1O64nE0TW4+oXq2sHJkgVAnEswA
	+jfgImqv85KtuS8uSNP4zuX9sjHIUd6qEkWOMKRcGJUP3N4GR5bkMeyWWbvLfYI08XYLv2nQ2EM
	+
X-Google-Smtp-Source: AGHT+IGvmCD0xsR9eyQWAfMGJEcXj333IM2t16d+5kpCNe+oFUqVbOhyzfqprFnUD+U+XaRMZe0Jcg==
X-Received: by 2002:a17:902:f685:b0:1e4:3299:2acf with SMTP id l5-20020a170902f68500b001e432992acfmr3754136plg.3.1712947787852;
        Fri, 12 Apr 2024 11:49:47 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902684c00b001e3d2314f3csm3377308pln.141.2024.04.12.11.49.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Apr 2024 11:49:47 -0700 (PDT)
Message-ID: <23b5dc5f-ddd5-465f-bbb8-c2021a5f6b61@kernel.dk>
Date: Fri, 12 Apr 2024 12:49:46 -0600
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
Subject: [PATCH for-next] io_uring/net: always set kmsg->msg.msg_control_user
 before issue
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

We currently set this separately for async/sync entry, but let's just
move it to a generic pre-issue spot and eliminate the difference
between the two.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

This is for the 6.10 branch, was looking into dealing with the
msg_control_user fix for 6.9 SENDMSG_ZC, and I think this is a good
pre cleanup that just makes it easier to deal with while merging the
sync/async paths.

diff --git a/io_uring/net.c b/io_uring/net.c
index d095d3e48fcd..b08c0ae5951a 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -391,7 +391,6 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
-		kmsg->msg.msg_control_user = sr->msg_control;
 	} else {
 		kmsg = io_msg_alloc_async(req, issue_flags);
 		if (unlikely(!kmsg))
@@ -411,6 +410,8 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
+	kmsg->msg.msg_control_user = sr->msg_control;
+
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 
 	if (ret < min_ret) {
@@ -1271,7 +1272,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
-		kmsg->msg.msg_control_user = sr->msg_control;
 	} else {
 		kmsg = io_msg_alloc_async(req, issue_flags);
 		if (unlikely(!kmsg))
@@ -1291,6 +1291,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	if (flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
+	kmsg->msg.msg_control_user = sr->msg_control;
 	kmsg->msg.msg_ubuf = &io_notif_to_data(sr->notif)->uarg;
 	kmsg->msg.sg_from_iter = io_sg_from_iter_iovec;
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);

-- 
Jens Axboe


