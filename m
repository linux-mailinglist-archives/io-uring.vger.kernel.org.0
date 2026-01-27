Return-Path: <io-uring+bounces-11944-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gMKCOvIEeWk3ugEAu9opvQ
	(envelope-from <io-uring+bounces-11944-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:33:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC2A991D0
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:33:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4434530028FE
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 18:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2EED326959;
	Tue, 27 Jan 2026 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bKPHsSMR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230D52EA159
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 18:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769538797; cv=none; b=ZZpruGUZeVwBMXfOJbmNYy0YCzCj6PSClSveFSm+ILexNEEzGwFmDGvEiEIYmp5KGoOwkvI45LB15iMh6QozeYPIVi7PfRfOgSGMFe1Fc2cHkBJooZzDNe7AdUn9ggBa2qD5mZAia0LIN0Y8U38JH4MA4CxQDqH6qP0a4I8LmSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769538797; c=relaxed/simple;
	bh=2dA45QzRGE0cMTx0b7OjRC/IpaNlFaELF+VRWCZ7/ks=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cOz/aoFcfkmGYoqrAP555kAOhTF8N4UylysfFxCgev/ADDcstc5zGKWgbiC8VuAp1uRQCIZJ3AcB75bZpbfxx/0AhPF6dad7wQAVjxwnQxLaY/zMZhcHxe5ZGCXLSTYf4VPAMvmRd350D7TbfCIzh6ENJ14+OWQYyZxZr3ND9II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bKPHsSMR; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-124a677c9afso465296c88.1
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769538795; x=1770143595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JyoUniIGV9vUc0xYkkf4ZiawBa/sKTdD/UhBmOs/Uj0=;
        b=bKPHsSMRm3Rdza6+Uy6UFMgdEqBkTS/wzQPRci7NG3Ie17/eI6QerNo2Wfw8zSqx9q
         TxJDN3XsrBmK/u/N51eSFwJeZOTH2gmc2GbEo31ilZyhRnNUesyZ8ywszEraEc6a2FGv
         pCMgGmZ0uvSUYaun98BvIvMuYct6azRY2GGh/eJwT89laoIRXwjaWZ1hYhydn83D5bAa
         2SvvsuW08ZT93HDAX2Qtp7XsnYhA4gJ9r8MEa5RsJwsemhOiTlHqwyS05r3p32Y0QQDS
         6qOPkGVNJC6LgO6sYIet0njZmxMtWLyGN2Lji59aYgf+NMkbRkG8AD0G6X1fVvBThi5/
         66hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769538795; x=1770143595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JyoUniIGV9vUc0xYkkf4ZiawBa/sKTdD/UhBmOs/Uj0=;
        b=LLtFFrNHkiWuMJAN2QoQzfzXNOTOnIfnV20kiHn1TDRlcurpmWIfN9t1+R4pYbtT4A
         fFln/Gv8j9ElBQr76PZ5QLKtw1wi7Wle0qTp+zhQGx4vNekFfdMLUsFnDejuTMH5JKBY
         ca/Hg5fecMDcClPsa6YA7fC67fHIQAKviSrjM+KC1MF1mFTNtMiEYNzOLiRwLm5ZVWSp
         Xgz3LXiMHr3X5R5QA/f8tf3bTLsALahJ5ahrot/Lyteoj1/Ar0bjvAIXzck+L95/vACY
         HFeIoO4Daqtr8NsTom/Iamgph9SsYtBsrWFISDEFfrjViNw5vNYgul1CJtBdtjKJRBCk
         oBuw==
X-Gm-Message-State: AOJu0YzsWKcYMkN8FkR76qP6vft07gOskwXtEoat98/+iiFcpqz2N8xn
	+9fth8lN2e7gjNde0NTO+NXj30lSKtkefP/EEF1sFHmiOduo3QWkx8JDXbyitOCFk56o38rjgf+
	m8qEn
X-Gm-Gg: AZuq6aLfw70s1sQw+cpMrS+FZ0muEiFBlYAr0juR0ZqvCwpUo2i9mohF0R2nTsZq5WG
	5MW9yPQtg6PWB52mv9JrGxnBAHbLqj+m6Lj6hpbgEjPNBxiNPUoaBN1ZpM3RaSL5cCA+cJ6w9eF
	NFkkVoJg5q+7LJTlyVnZFLndGPhWggM4mr2Hx9kf4wM1mqjFUKbcM5fh2/HVa+wEOdCnvXMcvPG
	IC7gc1gnPDIE/jz3VS5DQiBovBBuvQRgtP/GftKYKBE6xjFSIU5lA1BWXPdevywp+rX5J5Kg1ji
	TvB/lgUfBxGUDA3cMnaf5GdsqSI5d/JD3e6ceQb9RvmVr/1tbVxXgh9Zi9ZDOCJt13gm+AnMoW9
	GnVg4vVYCim45cVtE1LrD9SWr5CfJ3rCightEsoPcMHlvZjh+xiVPe/wfrGv0B2S/Be3MqbIc4P
	Oo5Ggq8AHkZ/wpyWuLsSEOaR4wTgtK9u7uzVVHD94uavRIwbmQEKlXOa/GWHfXAA==
X-Received: by 2002:a05:7022:68b:b0:11e:528:4185 with SMTP id a92af1059eb24-124a0119a2cmr1658173c88.38.1769538794568;
        Tue, 27 Jan 2026 10:33:14 -0800 (PST)
Received: from m2max.corp.tfbnw.net ([2620:10d:c090:600::cedf])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a7bd05b1sm670139c88.3.2026.01.27.10.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 10:33:14 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	cyphar@cyphar.com,
	jannh@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCHSET v7] Inherited restrictions and BPF filtering for io_uring
Date: Tue, 27 Jan 2026 11:29:55 -0700
Message-ID: <20260127183311.86505-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-11944-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 1AC2A991D0
X-Rspamd-Action: no action

Hi,

Followup to v6 here:

https://lore.kernel.org/io-uring/20260119235456.1722452-1-axboe@kernel.dk/

Mostly just addressing a bit of feedback, feature wise this is all the
same as before. See the changelog section for more details.

Kernel branch can be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=io_uring-bpf-restrictions.4

and a liburing branch with support helpers, man page, and a fairly
substantial test case can be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/liburing.git/log/?h=bpf-restrictions

Feedback welcome!

Changes since v6
- Add pdu_size to struct io_uring_bpf_ctx. This will help future proof
  filters as they can check if they agree with the kernel on what is
  available, and it eliminates the need to pad the struct out for future
  expansion (Christian)
- Various code cleanups (Christian)
- Fix for FORTIFY on how the bctx filter struct is cleared.
- Rebase on current for-7.0/io_uring tree.

 include/linux/io_uring.h                 |  14 +-
 include/linux/io_uring_types.h           |  13 +
 include/linux/sched.h                    |   1 +
 include/uapi/linux/io_uring.h            |  10 +
 include/uapi/linux/io_uring/bpf_filter.h |  62 ++++
 io_uring/Kconfig                         |   5 +
 io_uring/Makefile                        |   1 +
 io_uring/bpf_filter.c                    | 430 +++++++++++++++++++++++
 io_uring/bpf_filter.h                    |  48 +++
 io_uring/io_uring.c                      |  48 +++
 io_uring/io_uring.h                      |   1 +
 io_uring/net.c                           |   9 +
 io_uring/net.h                           |   6 +
 io_uring/openclose.c                     |   9 +
 io_uring/openclose.h                     |   3 +
 io_uring/register.c                      |  91 +++++
 io_uring/tctx.c                          |  42 ++-
 kernel/fork.c                            |   5 +
 18 files changed, 788 insertions(+), 10 deletions(-)

--
Jens Axboe


