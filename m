Return-Path: <io-uring+bounces-11971-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MJGiAKK/e2mnIAIAu9opvQ
	(envelope-from <io-uring+bounces-11971-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 21:14:26 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7428BB4301
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 21:14:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DFAA8301915C
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 20:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63DA1330B2B;
	Thu, 29 Jan 2026 20:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GrwO8s2G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279AE31280D
	for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 20:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769717657; cv=none; b=EsqA201U6+AldPKXOrmuIR7uvWlvy0e/B81YN1xOIe4kMlmGckEqIf4aGbhdv8Qst6ILIxSWrpQut+Sdv344EcIuwhVmg1Ac3MnNG349oMzCBI/2KXviQ16bQEXmCBn2v/MA/ugvn2DhJuUShD8JDku93NiIF9qGwQxuTqLhdW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769717657; c=relaxed/simple;
	bh=1OTyki0bSDDUtz4oTBM4KTnErZhSNZYphUWqwHVCIIA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ggDn8m0T5dN4m3aSU5yhqmBsvmMdBUoZd2IAVdDPLv6ydfPRwkRgoxEVVqrkF1eGZQLPGUnVVSYr55T5EGebImIGE+w7MC58vTFGhZJj8NMUlCgncJXo6azBn9xrssWYd22ZphAwWPK8FNQGClQ3GebhSd2bocbwFeqFStDeMKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GrwO8s2G; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2b4520f6b32so2856777eec.0
        for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 12:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769717655; x=1770322455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mEnXrEbok+5fN77Y7u0su+01Tkrn44tfAvU9KWQefTk=;
        b=GrwO8s2GTe8bP0mEKgDeqLsZu+mfHIL1S9vPVhKKcRdlWK0MA7WAw16rFWwkSSd6kq
         bXX2HhmM1EkdLvPhFux2ZBUvJDBVQ7qkXE7eV8LFVwpV72TCQzXnaMrfawB1rlfJ5FjR
         7Q4CELt1Sl9wWg99f09jW7qyvNS1whNicP4Ihk/nINeuwo0e4XxPNI9IG2WvvMF4Dlx7
         gb/hyaSewjxbV5kvVdTgEFHJX1xW0KX2otyEEu/Q4OYoVKH55XL1mRf6Gr3ukF7UlEcV
         ix41Olf7W/N6etgvso9VOM2x7+IjmjfA9K6VtTL3mA/vDolzuEi3fbC7Z0iYoaxLvi/M
         cUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769717655; x=1770322455;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mEnXrEbok+5fN77Y7u0su+01Tkrn44tfAvU9KWQefTk=;
        b=pf3MnSXsBBLUoqEV6kb5KPtXcFezXDT9+X0kS8TUf2Rv3vepLv1Q2cYUi1KDurC1HH
         UsRptn1EZU0Jbf8uN4ouAMhDvX/+w1wrY2ea0JGYeITyf3AV47CunWHYEAPFKwkSOtVC
         Ttf4SiNywB1ZWxy306oFbRAF9HNq+9KtZ9M/e3EL1AWyZzyWtULeL/Ew9mlTWbUkLO1e
         JpYU+5UjtliWBP4OqEw+yRqsNhqFmmxPBL0DHqR8RtHYzXk3R/MMCjlhJ2TtYbBG61Ab
         VzNTdtB+F1VyKw1aHN/7Vg3SzsO/dAMTH8WhAH+VGa8jRlnB/zZf7173KpmzhH5bNSfd
         jjsg==
X-Gm-Message-State: AOJu0Ywea2T9GUTx9X0mV5usKENyr2kNUW/+1A2ltBK7iFqvPbxVG3Mx
	JIceUtmlCM/a+FuTkQKzZflIHOfqNCgrbSurPgG2jFhigjf3QAkpMmaa9JXBYg==
X-Gm-Gg: AZuq6aICeuPg1+3BFod0s1/CqpCnw6PWfxw2yi7X+8cPFo/OgtvBVQjZK7JuyoXbh7x
	gefeuyOnumlljizHP/wcAncNkIJd3K8XPM+ppntee4NtemUF9ULapf0D/0aGZOq09kNarKLh77y
	RsqNpUukba49/fb1FNmbZG24Xv9iSY5S7i+MHAyp3J9JLHRYzcM8LK9w3tkGkF4WZgw7wzrc0mg
	TlkB1YH2qhqg2QTQIZeiemYoLPdfIVSj9+w8hNJA27SQTVN+NfV1ANNaS+pYTWXPuPOY5GcRa9h
	jRPmZGt/0dewGBystjvd8vOmr0owWhCD1JXbZrIAHKVROJrzOKUXCSdhcNO7O+EgGPs/KkQtV/+
	ea06YznABQLd4xd0yXWJBr/LnFFacapDUE8Dc5l98t14HGF1sXmmkjWQaKV4t9NtMvOvFHYUzhb
	7qkTIEuzkAMLlfink=
X-Received: by 2002:a05:7300:a146:b0:2ae:5d9c:9548 with SMTP id 5a478bee46e88-2b7c88faacbmr285482eec.32.1769717654812;
        Thu, 29 Jan 2026 12:14:14 -0800 (PST)
Received: from localhost ([2601:646:8100:f8:a787:ffd3:9020:3716])
        by smtp.gmail.com with UTF8SMTPSA id 5a478bee46e88-2b7a16cfaa8sm8025079eec.4.2026.01.29.12.14.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 12:14:14 -0800 (PST)
From: Govindarajulu Varadarajan <govind.varadar@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk
Cc: ming.lei@redhat.com,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	miklos@szeredi.hu,
	Govindarajulu Varadarajan <govind.varadar@gmail.com>
Subject: [PATCH 0/2] io_uring: Add macro to validate SQE cmd size
Date: Thu, 29 Jan 2026 12:13:45 -0800
Message-ID: <20260129201347.411015-1-govind.varadar@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,lst.de,grimberg.me,szeredi.hu,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11971-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[govindvaradar@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7428BB4301
X-Rspamd-Action: no action

This patch series introduces macros IO_URING_SQE_CMD() and
IO_URING_SQE128_CMD() for accessing cmd struct from io_uring SQEs,
providing compile-time type checking and size validation. The series
also updates ublk driver to check the SQE128 flag before accessing the
cmd structure.

Testing:
- Compile test only. (trivial changes)
- Validated IO_URING_SQE_CMD() and IO_URING_SQE128_CMD() with struct
  size < 16, = 16, > 16 for IO_URING_SQE_CMD() and < 80, = 80, > 80 for
  IO_URING_SQE128_CMD().

Govindarajulu Varadarajan (2):
  io_uring: Add size check for sqe->cmd
  block/ublk_drv: Validate SQE128 flag before accessing the cmd

 drivers/block/ublk_drv.c     | 20 +++++++++++---------
 drivers/nvme/host/ioctl.c    |  2 +-
 fs/fuse/dev_uring.c          |  6 ++++--
 include/linux/io_uring/cmd.h | 15 +++++++++++----
 4 files changed, 27 insertions(+), 16 deletions(-)

-- 
2.52.0


