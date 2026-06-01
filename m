Return-Path: <io-uring+bounces-13577-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yE9bMu5dHWojZwkAu9opvQ
	(envelope-from <io-uring+bounces-13577-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 12:24:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E3B061D4B2
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 12:24:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C74AC31E6A5A
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2026 10:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8FD3ACEED;
	Mon,  1 Jun 2026 09:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wd9COx7X"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7723ABD80
	for <io-uring@vger.kernel.org>; Mon,  1 Jun 2026 09:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780307955; cv=none; b=eZX0wxNcgEj+Ur01S0MxY3X7x9mZxFrvMLs1Il25aFC8dsT7iggGuWOasuwDATnYUw46SnQdmtpqY//pdKW+I0stSOJuZCPRn0Dmll5ovD4HII1b3Q5Lk0aGcD6z4mvHuUetcqyQ7c3fk42Ccfu0BXZvEDD1IVDBtG9GrOY0n+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780307955; c=relaxed/simple;
	bh=JcrQQiKOF7xsDnpFVOQEazB5mvLJgHQ8Q1kJXvWC5es=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R6QKggUWT7dy1wSzt6JbJDKDmLLyeSURZNOaX42MiLMFUSCTaX3JG+347Qx0GI30VY3Zj4k+uoiRwKRUOhTLBLj4lXGd9GIsLj2iVV6uWlo8KxwpKledh2a6h3Gpibpw4SMWoEAsda5Ifu3osgiA0yA8XFm9WGSoc/kXdlByTaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wd9COx7X; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-91550fe1619so148379685a.3
        for <io-uring@vger.kernel.org>; Mon, 01 Jun 2026 02:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780307945; x=1780912745; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V7UsPLohXx473pPhLLbINPesE4RdWMgDU0nFm+q4ANY=;
        b=Wd9COx7XuI6k1AJ2lVGMOOLoq5R7KTXbLbTKnvHsw5Sjaa0+O3mZc+Ce0jgwNBEiwA
         q2jHOFQRm2ZheO3kI4jLSxINF2/f6c9mplOxF7zB0MqBFrJxGxsaHsQLlc/+HytTJ0i9
         Kmby+MUnScTT0UlIUENyysfCa4D0jS4OTPibSHpxLG4yWaUDQDYxvrK0HO1ZFt0n6fDV
         1pgsxC2tBjPATF8tySFUXYHbko/0o821/tEEQC8FTSMGWyytx4VjbjNz19h06wcvYPL/
         7QZwtMInjYmrPKXi/0vHPLMoqPFwqHrJCtfvPhtEkhkusdEiBWLGRmaqjPUZIAVwgkaO
         SflQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780307945; x=1780912745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V7UsPLohXx473pPhLLbINPesE4RdWMgDU0nFm+q4ANY=;
        b=MmBryJgQwnZ5qv+wpR3jnwgEoolWV+x6G61FToqFS2OEerQg61b/V41pXiXj914Uma
         muHATm4fbywY15bjq2b5O0rrACLTNFi3ER9I8eb4ucUegM0EcKIPZnyTHeMJX5d6NQ+G
         +utGlo6YeM03qRP8yK6b6u+zHacAJC5zbfmBahr9A2egMNFu/WcY4lZt5BlP4bigaNz4
         SltqSFj76GIrz8PxhqwawnTKuWH4ExuxoGr2boNvzn+7i07dmKI/SV18bvTGJrTb+9+O
         G8zHyDmuX9oT/BJ/ScN2II0OlhEZp14ldj5IBX4ZANH26koeNNUc0TCetL7roVOs8U+I
         G5fw==
X-Forwarded-Encrypted: i=1; AFNElJ+ws+Eiea7ZvVBsg/WRmKczcHUdWejqeqXV6P7WC9vqpPlYhT/zroRTU851OM1DbDELlh/OAS9Zbw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzTr0+VhWIDQq9M70YsFaLFFt+6wETw4Ed6d80vg7mGCXFaO9x6
	BlAUPmc1Qwg04Lidqbk8gyaQ0qZDvxt+AW8XdNFusvOKzKz/yno4ejUQ
X-Gm-Gg: Acq92OEs8eNMtGfajVNA3m51kxkLfmvHZKdfOtSuEzSDJD7FadzpaVUfR+3kWh3byRl
	YfUH3q/dTG7FMpQ2Zq/sAu649OIndyaeGrFsoK1SNERmfFb9vHZ0t4yEI0cDEHIDXAGmzEMrXhs
	FqqFP0sAtgp6BbBqZtRYsXpoBEkoiekxTUvfDm7Y2PHDygoLuxxfVOOxlXFZxoOTR9l7ZWusYTz
	vhw488KW2X9CX1Ff63Xkk3PGpsSLS5ZTw7ZpbDaoFbyBBZw7KWEEDYluVN6hoM8J0bYZ3Poqrof
	n8C8/tlKEqRUqJiEPlAH+vLC6FnNEXlcXGzy843pGyPF0E3wgGuNv//IfSSNFD3Uo1Uy30FxN72
	CCbqXqg21TUSMvElvuZ+wfTSR9eTMMnWXS3SCqE0yys9GjYTk2je9Lu0YjBMh84ocsM4bGTbojl
	k5qFq3DQcCKfS3Mo3PQuIUsOuFijC3mlKnSOtViG78iQslAdKSuxasJP0SQvWvn54cbDvLhC+T+
	4YIl5CaKm97EONkHv1ryYyRcWXIUUCNA+IxYsFJI8B2ljG1wyRrGA==
X-Received: by 2002:a05:620a:6881:b0:90f:fdb3:b752 with SMTP id af79cd13be357-9153d9f7676mr1646865785a.17.1780307945235;
        Mon, 01 Jun 2026 02:59:05 -0700 (PDT)
Received: from fedora.tail348456.ts.net ([172.245.82.59])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915721f7d75sm32658285a.18.2026.06.01.02.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 02:59:04 -0700 (PDT)
From: Ming Lei <tom.leiming@gmail.com>
X-Google-Original-From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 0/2] io_uring/net: support registered buffer for plain send and recv
Date: Mon,  1 Jun 2026 04:58:44 -0500
Message-ID: <20260601095853.3670199-1-ming.lei@redhat.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13577-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 2E3B061D4B2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Ming Lei <tom.leiming@gmail.com>

Hi,

This series wires IORING_RECVSEND_FIXED_BUF into the plain IORING_OP_SEND
and IORING_OP_RECV paths. So far the flag has only been honoured on the
SEND_ZC path, even though the import wiring is already present for plain
send and completely absent for recv.

Motivation: targets such as ublk's NBD backend want to push/pull I/O data
directly to/from an io_uring registered buffer over a plain send/recv on a
TCP socket, without the SEND_ZC notification machinery.

The flag is accepted at prep time for the non-vectorized IORING_OP_SEND /
IORING_OP_RECV opcodes only, and is mutually exclusive with buffer select,
bundles and (for recv) multishot. The registered buffer is imported lazily
at issue time via io_import_reg_buf() (mirroring the existing send path),
and the resulting bvec iter persists in async_data so MSG_WAITALL partial
send/recv retries resume at the right offset.

Patch 1 is the kernel change.
Patch 2 adds a liburing test and is meant for the liburing tree. It covers
send-fixed/recv-fixed/both-fixed roundtrips (with non-zero offsets into
distinct registered buffers), a large MSG_WAITALL transfer that exercises
the persisted bvec iter across partial retries, and the negative
validation cases (sendmsg/bundle/recv-multishot rejected with -EINVAL, bad
buf_index returning -EFAULT).

Ming Lei (2):
  io_uring/net: support registered buffer for plain send and recv
  test: add fixed-buf-send-recv for registered buffer send/recv

 io_uring/net.c             |  46 ++++++-
 test/Makefile              |   1 +
 test/fixed-buf-send-recv.c | 300 +++++++++++++++++++++++++++++++++++++
 3 files changed, 345 insertions(+), 2 deletions(-)

--
2.54.0

