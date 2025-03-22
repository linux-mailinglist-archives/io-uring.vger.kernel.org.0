Return-Path: <io-uring+bounces-7195-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45044A6C9F3
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 12:47:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF14918949CF
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 11:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F181FAC4A;
	Sat, 22 Mar 2025 11:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mPmzSyIi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F77C1D5165
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 11:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742644016; cv=none; b=P0vQjcAykCflSy5XqvD9gDfZqPJduM4NMjvNKeXCBl5b3pkQplX/YB0iiKsaiHlp7rFY411NLX1tKAvNgBu7+9s8+0OTI1wRdywriOTZMd1aEmT9uy5BNntu5u8i3P4nJU9Xl9ZSn5riAxx2MYCHfVp3mpFMdLl3tItr9JYwp6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742644016; c=relaxed/simple;
	bh=/cFv6kVrAxyWsF+WQvZhbTiCEMEwxb9IuuCq4hcBZ8c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ktAIhuHPLLbW068gkGqLPsfHXwN6uDSCvtUi4uq9IshFZL2Gbjx5kxk7EEjhMGCeobqlTGCwVgiMlrKkDsbeDaxUqfvGivhcQiVrLAJtEfw6vSbr0Jph7hkt4VG58hwnxqkGG14BbliuN68JS9ecv3rbCchBl9FCJI/VUArMOJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mPmzSyIi; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac2dfdf3c38so284719466b.3
        for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 04:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742644012; x=1743248812; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QQZSR8UyAVri9xDm6Qn2RVj/llcG7A718V9mWcMYiJg=;
        b=mPmzSyIiTgzQZECkr+gwq0X/WD/zm0OghTHw66QCgvRRjNUOJ1vzW7zNt7Cn3O+KEt
         dU4c+oUuwd1SbiuDX2oMUMfo6FXLzlOhY5mxWsggnrDx5iw9q0w2kK1QIXWByXTHmzZg
         24yczN6vg+WQW3zss4qcmvqCuYuKj3U81ClU8uby3MqRmtZKB8CpV5691ON4GdnY0Cwj
         kfmH2yp5ttW1AmRrlGe9ApzHP3GOjxL9aM1bryhU/IPbYIxN6YFE429JKlIJB0zCYmNS
         d3Y0nkyg5KkF3w5taTvYlTxzZvUvXdXSPgMnqV2NAw+0SQkjLc6RBNTjhRTHA8rFOVBf
         kVCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742644012; x=1743248812;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QQZSR8UyAVri9xDm6Qn2RVj/llcG7A718V9mWcMYiJg=;
        b=q2tGx5IPUMXgCxOZ18DtetyW8DyjsqqF1rNXaxMGuU846wdHY71RD+F7R1J8UuzWTN
         eR//WQkZP5aB1ZY18mCHFLUkRMdARv5boRbUCTWiu/NDh5GuMckbJhqSzRytRLyDFy09
         uPCurW3MVySN74bLJdKqTZDlXw4aVJoJ86jxBQ1C/7+03t3JJv074b/Tg29ukVXWwlPL
         lzIXLGsh5yCDuZoAsjQKLHZR+87JdnVDX2MosH+5EB+EUHQB9K13b++XkvPXQWfpjJ6d
         yiBYIIRjuAMX7WItihzF5cpJdE7nhLbYfGQm8zfTzS5MxzWtghCImFiDwk3JypVKl9p5
         Q7/g==
X-Gm-Message-State: AOJu0Yzz9z+30e5hg/+vrnvAeXprO970iraQPnbcR3ne0s+GDFu7W7Wv
	MDQO61cnTsAqDTcuMSEFvU1Xwo8lkXShYyOoIRQ7z5hx82iHilMn8e97Zw==
X-Gm-Gg: ASbGncsA7d+2tf1HppKhafGtJINCnlN8snDYwwCbG9hTjouzLdbaHq46isg7bCi2lfF
	H5ciuTF3EXd0upaGAoq3O4gNfpbdJ8hhTtMELfwLqQ7di18vW5IJO2OCx+/RYO1+WIuQcmO5euz
	Jl67ULPQfWkl3sbX2v6GkAOZgYzsVm2it0gp7ENkyOfT++ZaSu/5WpnJIkWATMag5orimxS2Cez
	/wbWWnkocHpURc4CaQ2G/QTpNyfHXQKUEhMbcMdGClvOusYW4EXnr3I4OCP0AUtZg0NX6Bqri1y
	nvyDzQ1pANeFaogZYF/X/kmU/lonlyQ+aB/ELKSt3WlMLKweUiXe5pnE
X-Google-Smtp-Source: AGHT+IHtf8K0CdaG2e2A35x1ljUHjVyQ9hgRU7opzW8aO3Z+TyF9CuaYvGsPd4VV9q8dprHEuoB3zw==
X-Received: by 2002:a17:906:f5a2:b0:ac1:e2e0:f8d6 with SMTP id a640c23a62f3a-ac3f2118855mr565864666b.17.1742644012173;
        Sat, 22 Mar 2025 04:46:52 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.37])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efbde644sm329706666b.145.2025.03.22.04.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Mar 2025 04:46:50 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH] io_uring/net: fix sendzc double notif flush
Date: Sat, 22 Mar 2025 11:47:27 +0000
Message-ID: <e1306007458b8891c88c4f20c966a17595f766b0.1742643795.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 5823 at lib/refcount.c:28 refcount_warn_saturate+0x15a/0x1d0 lib/refcount.c:28
RIP: 0010:refcount_warn_saturate+0x15a/0x1d0 lib/refcount.c:28
Call Trace:
 <TASK>
 io_notif_flush io_uring/notif.h:40 [inline]
 io_send_zc_cleanup+0x121/0x170 io_uring/net.c:1222
 io_clean_op+0x58c/0x9a0 io_uring/io_uring.c:406
 io_free_batch_list io_uring/io_uring.c:1429 [inline]
 __io_submit_flush_completions+0xc16/0xd20 io_uring/io_uring.c:1470
 io_submit_flush_completions io_uring/io_uring.h:159 [inline]

Before the blamed commit, sendzc relied on io_req_msg_cleanup() to clear
REQ_F_NEED_CLEANUP, so after the following snippet the request will
never hit the core io_uring cleanup path.

io_notif_flush();
io_req_msg_cleanup();

The easiest fix is to null the notification. io_send_zc_cleanup() can
still be called after, but it's tolerated.

Reported-by: syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com
Tested-by: syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com
Fixes: cc34d8330e036 ("io_uring/net: don't clear REQ_F_NEED_CLEANUP unconditionally")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index a288c75bb92c..50e8a3ccc9de 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1440,6 +1440,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_notif_flush(zc->notif);
+		zc->notif = NULL;
 		io_req_msg_cleanup(req, 0);
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
@@ -1500,6 +1501,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_notif_flush(sr->notif);
+		sr->notif = NULL;
 		io_req_msg_cleanup(req, 0);
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
-- 
2.48.1


