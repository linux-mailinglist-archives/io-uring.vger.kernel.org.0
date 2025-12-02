Return-Path: <io-uring+bounces-10888-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 14810C9C9CB
	for <lists+io-uring@lfdr.de>; Tue, 02 Dec 2025 19:22:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7564634A0D5
	for <lists+io-uring@lfdr.de>; Tue,  2 Dec 2025 18:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31FEC2D29DB;
	Tue,  2 Dec 2025 18:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="C7DTXgoR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vs1-f100.google.com (mail-vs1-f100.google.com [209.85.217.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2698287503
	for <io-uring@vger.kernel.org>; Tue,  2 Dec 2025 18:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764699700; cv=none; b=JCGbWtRGi9O9g2CZHvDtf85wf6A6lxhkOxapcMz+/KBjLrPvplc1dy0Kmtb9t/+OK0Xe1kNrc+gxymqzQe2VDFn/ysnYYXkSVNgRAiVlvsmlW4iLdLoQQR3/7G9OvwuoWrKM4Kn5HHiG27yz6LA1CXn3yURSOWduvNjt1m161lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764699700; c=relaxed/simple;
	bh=Q6nsMG+HImyaJULK738xtVp5TUb5J3iQjwpkt/Zf/8A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=duSbiLwLyho3sPDukvNn0Z/BG/jqK7Cbz5mZqdrQ6dwlFmuPYoyq3kbYiVMSrhMP3ja81r70Ehorf7ahafg71gnhyqHqy1bqV9iQJ3WRx53khz75bJm/nUSnDSRhB4o3dZVzgWH6A5u/2FWehnF63Njo4Y7HXfNp0HTQqdyfl4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=C7DTXgoR; arc=none smtp.client-ip=209.85.217.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-vs1-f100.google.com with SMTP id ada2fe7eead31-5de89140141so279461137.3
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 10:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764699696; x=1765304496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iAKSM+YFIoffRWnIvZh2aZxrHWdwn+486YXWr5hu1CI=;
        b=C7DTXgoRVthKNAUolj16NYqvLduLiTWS1bxQV/5989HlCLOreZ4dM3sapElbWtem+z
         /2if+TAfMa/9TwJ5btrEeFgEOtKRMzWG7v2plXcd+YkzICcZC4F6b/+/Y5ezI6f4hbyS
         MlG0SAJJVusuJ2AdGqbfsY5BZrp65PW7PZR4R74KeCO3KAw8cBbbRH9o4jUmG1fiuf/Y
         yBIIsQHzHlLSoN8dlYW4SYUvWL3v5q35YZ+LrKGzF7EZmXUqj9aQzl/bh9p2npRMZbJs
         3Zw+H1ui1XL/As2FA4zKdxR0AjrKQUAE541ODqXl6iWcTWQaoXbIMei+RK6su/yomokS
         8YVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764699696; x=1765304496;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iAKSM+YFIoffRWnIvZh2aZxrHWdwn+486YXWr5hu1CI=;
        b=u2XHJugTysDbPKqyGwdfWW49BPqIDFyK4aPcXNTsOcCOAS4UmCBbT2fR108G6AKj5O
         7o5pL3kaIrbGYi+maMbC1MnYuhEXHHPfKcPZzevBlUkhHKvYNo3Vwb6u5ROErK6ZfEHZ
         DDmvGUROq9nCgk4NeEZHFfyNLyWexZ/HXt6TuXsNrXGoyFnHwsrokRoopMOT2+8iIz6S
         HE5NMFsstTB6owX5pPBZm3IFSvRyNdZrq8vxfoPHiNSaOKtohtpkEpWKxAtSBxM9I1aD
         +M0xXo6DI2c58m2NWJPgjxHcBVrkPXcSLekhvnkSytw3GX7aanVCysHhyxV+6YoMdKps
         YW/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUOGeOqJtTfR7+eyl5ywY0B3FlXzZoi7WKtFcH11a5y0SRKqOQlTmuFoMaFXi7Te+V2o7OoXK7TyA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxteQDohYxT6DNtrq8soY9gjQd5jajQaFuz+22/SYD6lksGP+CS
	RfLfBWG6A5ij2Uz5c80fNmNMihWs1BwL0b/j43NvjqZJf6mMLr+gmbbD3nMPsj61jqJBMJ12zz9
	QljFIr6syfkpa/OiODN8eTF9ZcunW4SfUBns5
X-Gm-Gg: ASbGncuWXtIPIN2geJPw/vCKyuGkGv66VfSaC208BOXbDMtRse/K6m7o1dO0TH+zJDM
	faUueg+AzkkUSOVf82Kx1QbgwDSs/enb0Hke6wS8vwDXQCZITVGTJ7CjBXfrGkBdsp/5H/eySIi
	2J1EqU/Me56zRUE5zYzejVwBbigRdtDN10IGiqL4pW44r8mgh9ox4O47pFshsfYwtL3JEUneimt
	0DuVBpm7Z3D7qK7be/kmx3uck5hsm2PERIYoA7an41hZG/gZ6EK/tfS6LVQgy9tZ1EJM3Bi3TLI
	E3jWJTwbi1TmawkWYG1FbLELStyacx8J+qc21Iqjsy9C0YfoMs4EEFtV7gGRE5pUCP9OToGw8Lm
	6SOx/JdAWNt0OvmKGaqIKmw78c5URfuZKGoXd9Dddyw==
X-Google-Smtp-Source: AGHT+IESuDUtU77Vl0nma1WiRhfiGkS93Xa+aCOm+aieYgupGxGL2OnR6elfzfyHjGVzalPvSGEdXG5HuxeL
X-Received: by 2002:a05:6102:374b:b0:5db:cc92:26f3 with SMTP id ada2fe7eead31-5e1e69fbcf2mr10232117137.3.1764699696634;
        Tue, 02 Dec 2025 10:21:36 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-5e24dce43basm996090137.4.2025.12.02.10.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 10:21:36 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 7C01F3400C8;
	Tue,  2 Dec 2025 11:21:35 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 76598E414BC; Tue,  2 Dec 2025 11:21:35 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH] io_uring/trace: rename io_uring_queue_async_work event "rw" field
Date: Tue,  2 Dec 2025 11:21:31 -0700
Message-ID: <20251202182132.3651026-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The io_uring_queue_async_work tracepoint event stores an int rw field
that represents whether the work item is hashed. Rename it to "hashed"
and change its type to bool to more accurately reflect its value.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/trace/events/io_uring.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 45d15460b495..34b31a855ea4 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -131,28 +131,28 @@ TRACE_EVENT(io_uring_file_get,
 
 /**
  * io_uring_queue_async_work - called before submitting a new async work
  *
  * @req:	pointer to a submitted request
- * @rw:		type of workqueue, hashed or normal
+ * @hashed:	whether async work is hashed
  *
  * Allows to trace asynchronous work submission.
  */
 TRACE_EVENT(io_uring_queue_async_work,
 
-	TP_PROTO(struct io_kiocb *req, int rw),
+	TP_PROTO(struct io_kiocb *req, bool hashed),
 
-	TP_ARGS(req, rw),
+	TP_ARGS(req, hashed),
 
 	TP_STRUCT__entry (
 		__field(  void *,			ctx		)
 		__field(  void *,			req		)
 		__field(  u64,				user_data	)
 		__field(  u8,				opcode		)
 		__field(  unsigned long long,		flags		)
 		__field(  struct io_wq_work *,		work		)
-		__field(  int,				rw		)
+		__field(  bool,				hashed		)
 
 		__string( op_str, io_uring_get_opcode(req->opcode)	)
 	),
 
 	TP_fast_assign(
@@ -160,19 +160,19 @@ TRACE_EVENT(io_uring_queue_async_work,
 		__entry->req		= req;
 		__entry->user_data	= req->cqe.user_data;
 		__entry->flags		= (__force unsigned long long) req->flags;
 		__entry->opcode		= req->opcode;
 		__entry->work		= &req->work;
-		__entry->rw		= rw;
+		__entry->hashed		= hashed;
 
 		__assign_str(op_str);
 	),
 
 	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, flags 0x%llx, %s queue, work %p",
 		__entry->ctx, __entry->req, __entry->user_data,
 		__get_str(op_str), __entry->flags,
-		__entry->rw ? "hashed" : "normal", __entry->work)
+		__entry->hashed ? "hashed" : "normal", __entry->work)
 );
 
 /**
  * io_uring_defer - called when an io_uring request is deferred
  *
-- 
2.45.2


