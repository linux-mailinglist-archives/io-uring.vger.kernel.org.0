Return-Path: <io-uring+bounces-13957-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id R9+JCKodUmqKMAMAu9opvQ
	(envelope-from <io-uring+bounces-13957-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:40:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C57707413F3
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:40:40 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kOyJmZEO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13957-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13957-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B88BB30091D0
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 871083BB13A;
	Sat, 11 Jul 2026 10:40:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B52A3B7B84
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:40:30 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766434; cv=none; b=ovifwShshJS8XC/EzhQZnF/lsa9wbUVCuMq7KrJni3NGAINn7tZz4nc+DswDXIkxdsZcFKuDFkfr3S5/j2OZjV3jZFz4+1XOr0rjoXEnEIxdGnMG5hVvuUbjqgVchkCPvdXalnK4IxkX7GlYd4w51airpkFCrDbbnGuiTtJOxgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766434; c=relaxed/simple;
	bh=uPaiOGoNFr7zkBX2pJiSPMuPQwkXNFMgfzCf29UXcHc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T0N5nB/PpZXyHXh5xK0vKzpE5ttoR8JfNnN3ZeItfsaUAG1zUU010nwKu3GqnRVYVusZuKLyZBIlFLgaz1wnO3edSaj1sgx9FH162XNWbdiH7YD/T2wwWcNc3KRQ183ytg1SqLtzTzd3O/XHttcC6LjZDfbrsRDdOjNyX8YsyZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kOyJmZEO; arc=none smtp.client-ip=209.85.218.44
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c15f020a223so245199366b.1
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766429; x=1784371229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PSFjPIB523gHDvD4Fc7ge2yKmmEA/d172Uh20iN5gWg=;
        b=kOyJmZEOSDagqzhp1AkhmZnbUjgQsqHGN3F83w6j5hNqvMVLDLUcZctQs3pNHzUlpg
         idp4fCnya8Uvuzh3jEUR37JUzsjyMQdMtTheyJ1QAO9p+HCyi3O4STF7XLVzlnGkTJqM
         DZE5tuTNRenaNZEE2rjnj5zlxl0CMFtY4TFthu3TmyM52UhbX6hzTaZXVjtx32+tBRvw
         CAxHfs9yWAlSzMKWbLc9NF6Kgk1VHbMQqGSY4HH8t8ObCTsOw3jWWv1FmOrYbgEjMs8s
         0uZ9fMcBCkI1foeBQGdkig/I+Mf4/7nFVBNu/Y7+tMcSCeNCQ1xSOhUvBEE0v6u+FDK9
         DwiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766429; x=1784371229;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PSFjPIB523gHDvD4Fc7ge2yKmmEA/d172Uh20iN5gWg=;
        b=ENKpIdv9x42Jg1SXBEzJLsuk9RPaxN5liGodv0niY8Nwu45mPoZHwwoCaHrckio0Ow
         AjyTmZW+z3IEVudS1rMfi2oD5HFIur4K40FLOXPDl9hOPL9A7a0zHFEBp63NXxkQOrHW
         Ilwi1baJvivgqjoQG5WSLaRCd9NLZ/0tGk3nsUXcohQWd2dxv65y2EY5oFtXfF/3f6Pp
         wQfnM2aVxG8s+5voDTVq3ktm/6o18Fex+E6eorckxi8PDwtBB2OLREJVRA7jHq5p8NMs
         SX1yXjNxBuGt24Fxq/QyUU5r+25BRIpkQMaJREO48mORuTj1IxXzeNpKkayS7R+WEKQ/
         HNzA==
X-Gm-Message-State: AOJu0YwZZXt9yC5LjttOzt0UG3v48LCY0nvccGjU/nZWFf8GT8BBqX01
	3FxHh1Y78fSmZLbifDs+QRssQaCf2iE2ceRl3aS3PGVDvjUQXL+nX3czdSVZwA==
X-Gm-Gg: AfdE7cnK7IA72R5b5zFGs6iwqjDuF2s2GuF3ioic4pv6oHxqAdVmY78omXS7CyMBg0x
	cR5qKbFjsQbaxb+tjuRSQ1xzWMT2W7Gc0KFe9m9w3WiPq3de7DkbScoGYE3HPp328fP8hmYFhb6
	MijtdspClZU7pCJj1bl6kzahe88c13cxd7hoHkuW2dobrsvKGe7aXkZDoFhyXQdfgjHI54WHkob
	ukufDA4INsIcWVUGtsNnN/7zlOyfuybomEoe/hbsxZjYnTPgsJULpJnfr1LL6iQcMvZR5XwJCof
	a48rlkX5Mhv7JPfjxjEXX6O/nVDAL9ejDcUPzglDmeXzpATCmrEy2cKyATJpsxTzT7YNLoAmwqU
	E2joxUXnquVHf8FuGoQE1KIM/orh5C58a9j+JGkE30Lc1VoY1Br/jxIhj6HU8OrDTt5F2zzTPFp
	pULbi7hGPkwEnh0i+jCzBRkJVMbZyGt6ogcaFqQRMoJxD50hQIYvOIooLY6ZsZtqOy+ZrXM8bpO
	dIvuAvmkhHlBXmvr2v0XW5iIGkKJHisFc+O7v8VWu3US9OOTw==
X-Received: by 2002:a17:907:3e12:b0:c15:ff7b:ad69 with SMTP id a640c23a62f3a-c161eaa959emr84236566b.34.1783766428403;
        Sat, 11 Jul 2026 03:40:28 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:40:27 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH RESEND review-only 00/17] zcrx RQ improvements and dynamic memory provisioning 
Date: Sat, 11 Jul 2026 11:39:53 +0100
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
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
	TAGGED_FROM(0.00)[bounces-13957-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C57707413F3

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


