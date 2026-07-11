Return-Path: <io-uring+bounces-13929-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id AoHyG+4IUmqxLQMAu9opvQ
	(envelope-from <io-uring+bounces-13929-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:12:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E8652740F91
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:12:13 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L3eGaEjp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13929-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13929-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4818230099BB
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5652F380FE6;
	Sat, 11 Jul 2026 09:12:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D334F37A84B
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:12:10 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761132; cv=none; b=R/BKm32ETmgnItpqYVW8612eXvkMXVyYApYCqS6ScBS7a5RHcME3CbM3i/PVPqkrbxcJAtuj1Am66Xgym9/PTfvbh7DFoW4l3YYuHY5KqLwuwz9cqtVa/oTWLwV456II9dM+o5g+Uje8pUQYbP3hPGMPjni9A10xu+TLlsQVBF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761132; c=relaxed/simple;
	bh=uPaiOGoNFr7zkBX2pJiSPMuPQwkXNFMgfzCf29UXcHc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sDbHMqIejhD+Bj1RijNe4lT0Qx3TcvohUIgUxhulJymT/L2cnU2yGxH4HvkmE0+fDUBTh8VspSn9/6V46mTjV9KT9OsDDPF5q1FZmtGnPhRXB3EtVyoxX6QJvJy3SIKh/wZ/gN+Vuw+gghlB983rTCD4Hg8uGuYbZ9PPzSK/azM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L3eGaEjp; arc=none smtp.client-ip=209.85.208.45
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-698562f10e7so2271917a12.0
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761129; x=1784365929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PSFjPIB523gHDvD4Fc7ge2yKmmEA/d172Uh20iN5gWg=;
        b=L3eGaEjptoxFEfk89oJhjPMsM75k7gHEIrDsQGsZdIagygiZWoqThfrDRd29GAPMeF
         1jAdgaUDxcTUETI68WH7Aqu2kjgzNusRXyb0K7NdZ+4u/AIEx1udO57i4aRfrc8zdfrM
         pN7cAwm9HCmnsYxgTvuR1RLYuP0jkyi53/eEwB1Y7EU2tvNi+B+8zJhqOIxA+bcEbUx3
         eEUkVGFbgebixee+H0xdBULw3B7867pfYUThux4FaK2vZj3OZjCZBPidqgbe2+0fyv+k
         e1/SpwDEVdYWZcLzVSyQ4F8aqBED6D3ioqnsRkcfx9tELs4eyQBDB8JdZpyKhjIWEIn5
         oiBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761129; x=1784365929;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PSFjPIB523gHDvD4Fc7ge2yKmmEA/d172Uh20iN5gWg=;
        b=ieriaQ/VxyM1vhkygBF6r51bm9oioA/GpMKxaxExEoN6IA6b119V7b1etpRZhNMI4Q
         x4ncNI9d+GFkbg16MHii0A0ZYXbchl7xZns1j5wjdiRE2XHbwI96JV5328ZL0BHSIOL7
         hwWfM/uwccVZnVya+L0thkvM/bz9EUzhCXX7ad0iU5nf5qBbGWtJSXKXz/EOUHZEBxgo
         uB6pWX3IIz/H8jrzX4b16LF869/dMQKamffMfGCisbxRqgAICfCOOdQxdA26TGISJA1m
         rVd4eWd+O6ssFjH7P9XFukVqy/vQlMxdmOmf6S9jOgRyfY6X+JDEeyA5kVhjdks54uVo
         0I1g==
X-Gm-Message-State: AOJu0YzuYhwvROXCc/uJB6ev+X54RI5GJX2XIc2Cktrl+ganNW2LkUKG
	elAiSzAMpusDK2X7x12L5QfG3m9WC3VwFbvLrnGDqFIJMsHijSfAg/i+ovysiw==
X-Gm-Gg: AfdE7cnA1s97KpKtPk494l2lTuX3VMQoGoovJZwsjggSbDhKc6YzgkExLhT7azo0GiT
	yIqI4LCw/umrh0oe1kxYtYGmGIVODzNoSGNmWpe4cZ9nRmKyM88vvcRCfqgT0Sh/5MArzjuYxHD
	B4BTwbYWYHLUTDmXxcjJmQkER/tEKh9vCqZkzD9JE4A1wtW8I3yusDW2F3xEPkDW6zMb/lpsU5j
	uk9OnJY5J+Y3fT5Usnhm2QhcfmEtOZEt06avC1aSCxmu1biz91lBYglisyvuirMq/sLLcLIwaWC
	96xbXZa02fkZAoMsYsV6qBWalrfDt0f/0Qpqg7mByoG4JII/XyPHkzenAqaG0+qXCPocTrjSas7
	6J7xykQWVZEfFR7b5SCqIK6iSif6VfyWxcT2djX1aeOYrZLEijifeGZBxiHzA6hRW0uAGq1YFJX
	RQNOPcpAl85Z2nCrBiq3Pg/3swKmlsskOW2Nk1jE/hNclj8kekorPpvnU84EadCDlZ7PdtYQ+TW
	Sk+RQlVwALg6YPAstl7dw7uiEzi449muvgNJXsf5CbgwN4=
X-Received: by 2002:a05:6402:380b:b0:69a:44e0:7455 with SMTP id 4fb4d7f45d1cf-69c5f11721fmr871751a12.30.1783761128956;
        Sat, 11 Jul 2026 02:12:08 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69c60d47188sm681191a12.27.2026.07.11.02.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:12:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 00/17] zcrx RQ improvements and dynamic memory provisioning 
Date: Sat, 11 Jul 2026 10:11:23 +0100
Message-ID: <cover.1783616211.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	SUBJECT_ENDS_SPACES(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:netdev@vger.kernel.org,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13929-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E8652740F91

Sending it out mainly to trigger review bots. The first half improves
the refill queue implementation and improves refilling limits, which
shows up when niovs are heavily fragmented like with large rx pages.
The 2nd half adds dynamic backing memory provisioning.

Pavel Begunkov (17):
  io_uring/zcrx: scale refilling with large pages
  io_uring/zcrx: move RQ head/tail to separate cache lines
  io_uring/zcrx: add RQ iterator
  io_uring/zcrx: cache RQ tail
  io_uring/zcrx: coalesce same-niov RQEs on refill
  io_uring/zcrx: constify area_reg on import
  io_uring/zcrx: add helper for deriving area token
  io_uring/zcrx: don't pass ifq_reg to area creation
  io_uring/zcrx: split dmabuf unmap and release
  io_uring/zcrx: unmap under netdev lock
  io_uring/zcrx: split append out of area creation
  io_uring/zcrx: move freelist lock to struct zcrx
  io_uring/zcrx: array of areas
  io_uring/zcrx: pass area_id to __zcrx_create_area()
  io_uring/zcrx: add dynamic area creation
  io_urint/zcrx: narrow var scope in io_zcrx_recv_skb()
  io_uring/zcrx: don't reload skb_shinfo

 include/uapi/linux/io_uring/zcrx.h |   7 +
 io_uring/query.c                   |   2 +-
 io_uring/zcrx.c                    | 445 +++++++++++++++++++++--------
 io_uring/zcrx.h                    |  15 +-
 4 files changed, 345 insertions(+), 124 deletions(-)

-- 
2.54.0


