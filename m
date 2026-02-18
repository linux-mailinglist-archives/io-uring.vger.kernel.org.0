Return-Path: <io-uring+bounces-12300-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OC31E2oqlWm2MQIAu9opvQ
	(envelope-from <io-uring+bounces-12300-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:42 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A7612152BFF
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B1703037F09
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 02:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 737DB2874E0;
	Wed, 18 Feb 2026 02:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HvNAmb6F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493A6C2EA
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 02:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771383397; cv=none; b=dnCENTISYVmPnsNg5AbX0fYz/oyfe/jfRbltPWbOEf1iUnUePkR2A7uXPeobgOvAYD9JYnS+7muW+EeLU2k3dpEK1iZbk06oE5m9XMYzzzBg/xaSUlU4W7IriwfrJDW52ifymj/4vKZI2HzH429o8ZrG7GaRPNOmUQQa6rYot8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771383397; c=relaxed/simple;
	bh=BGNRg966IsE8DlmABr3gmooRLOYbOWuX39W0STBpw2U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kmBrt0bFnRnqaUXiLnecUVAFvYRbrQtUIMYaXzJDAWFovS1QqD1wc8LDU4qKTFLbUh+t+zHtWdefiB2Ro9ZVrR6BdJHCIG6h4a0ppYjLqbWIFYWWuaM+OzcPQly17IsrfWSw4k0pseF7UUT4gnxwFjGrHbJPHy1muADhiCANE34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HvNAmb6F; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-824c9da9928so2238331b3a.3
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 18:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771383396; x=1771988196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ghxwbUaIMu0rBLzAeqbmtMS1/HSpsZF5T2MvWzuBq9Y=;
        b=HvNAmb6FYTsjlzXgegrSxGHOjW801wQAC0L3h7cKGjxd212cyMHxen2aXJrWlV5pla
         asgN/3d0yAtL+B138KS8LLDHaburQK3oSh55J7EYGJPeaLgcSaU6PzLY9W1ZgcvtW+1i
         IZwtiucKHNoZY5CYQD/8tAdu8rodSke+0aqXQ7Qpd8W/rYDC+UQp/4UCmBrd8YUCgEVz
         y3szjghCrJ8S8XWZEJCxVgFDFo9L+XHQwXTogciYLU9TeDwUlDsGhHSQ5ZbtPsNN9AO/
         4qOCxHLEx/5PNdUSsSIAVemlsqPW44yrg60Ph3tOKtVie6t34ZHoAOl2QQAjJ8N4C58P
         KsmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771383396; x=1771988196;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ghxwbUaIMu0rBLzAeqbmtMS1/HSpsZF5T2MvWzuBq9Y=;
        b=Lgm89BKEzN/kSkYjAegIJzHepgAcV9njSemc/qYbgD//0+wE2NCLv9AhfifZvDKynQ
         h3qB2hyxH6kouuJDxqIAXcVRTdzTfSpfSTLVNEC2UDIlPWD8ZnnM+7hq8LAI3D/1pPJZ
         a6NWTc6+gMb4TpRGVbcuKnJU11esAV/5IsMvvQSuXqeQokiYXD/fPlz3cFcGwVrFjIkK
         AB1U8WTJj9HJn7o2CKxEr2FeWwSIiB/SZZex3Ut1eswG2OsGsdq5XLUYPzJ326QvqK/y
         OvS4DEhQCdyBR7t9jl3NnO2OSEOwKpDfKlSxXiXY5yd8ULytVatpgUCOCHnt/HYZvSGo
         N9PA==
X-Forwarded-Encrypted: i=1; AJvYcCX6jTwYa2K42xBQlkncOHtv2Ue88ygBzzq1fa4HurIr+SJmc7ZFokHZ7tr3Zp4YjHN4EKk/n2dWPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxxCSe9TFwZX27bGKx7sg4RYCGKKFlrdnAAwN9EU39lDjNpBaNb
	JdbM5rBt2q47wlAYogrFkHO/07/9A9/tsj2heT1qdApNX2doRkyUQu1q
X-Gm-Gg: AZuq6aIfFnmY+GOvwU0YbuRuARBB4LfktIcWfMVO9mJgIO9QsC/7VcoUprHRzGBpSQP
	a7mUog4YDoWsrpqPJg8I5OT7opLzshzT10jRVSdG7WTfu3ZCutrMjzZtKLeivFKrGtwbgmaDAOo
	iRxYJmqSe6Hd2L9JUO3SAYRgtnCI16NWWZUIb5yQkWRMFfrrwQUJbTLm9ZSGoqa5yLtgrjbKBgz
	qIwpgm86FuKTy3roNcHt/W40MgdFbgR5m+xV2SMaHCPyZzQRQHkVqNhxU8yrSHqyWxZiJcSY3Lo
	b/i2mRwFoyPrl0I8pfLLFI2coTzBxSmEmE+JIovOvA+eovjvTHVp5pRlYaS3M+eUy2MHKMmZKnW
	tTWOy1na8nM36bznXEGroa7P1MndNN8DHOMgJZ3iZLluZ+hUuRuTBwuqOGRs2/KhLh0Mz+tzZ9X
	pnpxrfq3WCE7uVNG6tSQ==
X-Received: by 2002:a05:6a00:813:b0:821:78ae:9dcd with SMTP id d2e1a72fcca58-8252746075dmr655672b3a.13.1771383395548;
        Tue, 17 Feb 2026 18:56:35 -0800 (PST)
Received: from localhost ([2a03:2880:ff:41::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a546edsm15314851b3a.25.2026.02.17.18.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 18:56:35 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com
Subject: [PATCH v2 0/9] io_uring: add kernel-managed buffer rings
Date: Tue, 17 Feb 2026 18:51:58 -0800
Message-ID: <20260218025207.1425553-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[purestorage.com,bsbernd.com,infradead.org,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12300-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A7612152BFF
X-Rspamd-Action: no action

Currently, io_uring buffer rings require the application to allocate and
manage the backing buffers. This series introduces buffer rings, where
the kernel allocates and manages the buffers on behalf of the application.

This is split out from the fuse over io_uring series in [1], which needs the
kernel to own and manage buffers shared between the fuse server and the
kernel.

This series is on top of commit 73cf88d775b1f55 in the for-next branch in
Jens' io-uring tree. The corresponding liburing changes are in [2] and will
be submitted after the changes in this patchset are accepted.

There was a discussion on v1 about having kernel-managed buffer rings go
through a user-provided registered memory region. This changes proposed in
this patchset add a simple straightforward interface where the kernel
allocates the buffers and the buffers are tied to the lifecycle of the ring,
which suffices for the majority of use cases. If/when in the future it is
useful for the buffers to be backed by a prior user registered mem region
(eg for PMD optimization gains), the changes in this patchset do not preclude
support for that from being added.

The link to the fuse commits that use the changes in this series is in [3].

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260116233044.1532965-1-joannelkoong@gmail.com/
[2] https://github.com/joannekoong/liburing/commits/pbuf_kernel_managed/
[3] https://github.com/joannekoong/linux/commits/fuse_zero_copy/

Changelog
---------
v1: https://lore.kernel.org/linux-fsdevel/20260210002852.1394504-1-joannelkoong@gmail.com/T/#t
* Incorporate Jens' feedback, including fixing wraparound int promotion bug
* memmap: drop allocation per buf + have everything go through io_create_region (Pavel),
  add 2MB chunking workaround for large allocations
* uapi: merge kmbuf into pbuf interface/apis as IOU_PBUF_RING_KERNEL_MANAGED flag (Pavel)

Changes since [1]:
* add "if (bl)" check for recycling API (Bernd)
* check mul overflow, use GFP_USER, use PTR as return type (Christoph)
* fix bl->ring leak (me)

Joanne Koong (9):
  io_uring/memmap: chunk allocations in io_region_allocate_pages()
  io_uring/kbuf: add support for kernel-managed buffer rings
  io_uring/kbuf: support kernel-managed buffer rings in buffer selection
  io_uring/kbuf: add buffer ring pinning/unpinning
  io_uring/kbuf: return buffer id in buffer selection
  io_uring/kbuf: add recycling for kernel managed buffer rings
  io_uring/kbuf: add io_uring_is_kmbuf_ring()
  io_uring/kbuf: export io_ring_buffer_select()
  io_uring/cmd: set selected buffer index in __io_uring_cmd_done()

 include/linux/io_uring/cmd.h   |  53 ++++++-
 include/linux/io_uring_types.h |  10 +-
 include/uapi/linux/io_uring.h  |  14 +-
 io_uring/kbuf.c                | 248 +++++++++++++++++++++++++++++----
 io_uring/kbuf.h                |  11 +-
 io_uring/memmap.c              |  87 +++++++++---
 io_uring/uring_cmd.c           |   6 +-
 7 files changed, 373 insertions(+), 56 deletions(-)

-- 
2.47.3


