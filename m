Return-Path: <io-uring+bounces-12325-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gOjXDw9rlmkqfAIAu9opvQ
	(envelope-from <io-uring+bounces-12325-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 02:44:47 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AA5D615B6B1
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 02:44:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2DBDB3058B91
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 01:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE85A274650;
	Thu, 19 Feb 2026 01:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="K1QMBc0t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f98.google.com (mail-oo1-f98.google.com [209.85.161.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE54D2236EB
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 01:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771465428; cv=none; b=F6/L50v3ABrndvTCYSOnKb5WQqlp3A67Dq0b+Pw+u3A0MT+6iqJtST2ierdrg9xj0fu+Fa03Ki07JStVbo+9PndNDoCJ8fMciL8ZSoBA8IN7fl1I4VJwrafHJ8pvOQJvLnI0Sv5zq9xtRm2oBPZRRv7dLqs1ALsaveE5DtLk05Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771465428; c=relaxed/simple;
	bh=tV41JT4N82HtLiVT4LDve0d5RQZWyngFmDTN+LM2KSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3qN7aBs6AE6Uaxy34ePhl1WdU6aXLmrnXYncie4zhb1qPaHCy8cnApxiXPBL/GaRZCGK4VNc9ioq62jeVp21T1pLdPVjGOKLJvW4gKlZmiQceSzp1aNj5J8J0p91aeESXyZO3/zjeiv9ar8jK38R5P6cIEFvscnEdkoltJ4qOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=K1QMBc0t; arc=none smtp.client-ip=209.85.161.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oo1-f98.google.com with SMTP id 006d021491bc7-66b0418ebe7so30182eaf.1
        for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 17:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771465425; x=1772070225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cD5qcELz1szuWzdXkgd0fgG80WegTttIPZeozvdhos4=;
        b=K1QMBc0tijEvOQMuBRX61IYuaNingv8UqIP75jzJdtB+oFOFSFJX9A22Wgt198UeVl
         Gg/EqhboLZj4eUEifY/Lg2fqZGgsaxon60yMafnoAE074OSryzJXmtXCm3YTTvItucTm
         Rnuz40FD2Q4SY7Ah6Y0EdadYgqjO7mzbFHyjc5baGrHRnin7kyE0/wE1zBazLNMq6VFi
         60TzMK+4+q1OQt1dwNB53J1G8XKl3XaA/M5N4nYwsn0otrran7CuSSV7Sh2umOF8O1u5
         Z4Dkj0h3ZXYRzQognhp7Y0kWtet0yqwjQ6WQegTL+QxD1Rtv1ESF0I39+GyTfB7RRQ8h
         0O+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771465425; x=1772070225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cD5qcELz1szuWzdXkgd0fgG80WegTttIPZeozvdhos4=;
        b=LaorUhi2xLmwEIPlLSqI83Z/NtNb1bv6Xwpx9ZLuatLQCNoUbVtDZkraLUO1l9ob5R
         Gv2X/zqMddrQDHF/JdO8All+6C8b/jprt3EWk2H7WP/nGTso/bpTwQmp5tZ5yvQwnkbg
         TSPb8cFLZMmS1ZUBW3/fA0YlRSx8ZsBBO/AC0GypxJ7XxTqkiEqQeTB3/g+FPFW4PAWf
         RoxTaQ2LtynS2IWdIPbcNdxwLSLg9rsBMref2lQPlDuS9f3SNZFi+DTQUNX3p9t1I1cY
         ShrrVKPl+tPe5XaenaKgDo9i1wrNGIqLaQjTUoeOqbIU6RZZPVj3gNt7qAdx+c9JpI6N
         XtQA==
X-Gm-Message-State: AOJu0YxX3c9aTH2wCBaUFWsH2G8rh+x4DYY8ya3xXg+hIeopjqv6vR/+
	KEjG4ZOHfr8qZ2S6/pTs3bF9TIWyW1G7AvSlPebF12VJztE5sYZ9cuZGPqITWnXsA0LE5pqe8pJ
	jSFYCfbTQ5rW65OrmyNTO5baQy7nsfgecFgyd
X-Gm-Gg: AZuq6aJEBZ6v7AD+qIkKKx6vB6UWhdvqwOvtsac7dnkxZrzq04ZRqPh3e4YA5CyV55N
	Dx3sB7B2gpeXspqEPXutCRePXUZycv5RXl4hvG6MEf+x86Etk//hFJLugSPQWJB1W/vef6Ug/40
	wkq/uRYQrGPLYad3jv+umgL5Hb4/zDaWrZiQIcjLWlL3bm3+6iQ0bvbCeiNwc3HQeVX8zN5pOwV
	7NrW1oTAQjDWiVYfYMzLzhQgJDgxWHmQGlJTug9kOfmBahIC0xmEmhc8BqcYHmv2Iksncq2CcEM
	kwG4tyPzmyd4NalIAFXsokoC07p1AV5ja5y1F+MIFZhSIONQRTkOefgtcwswLuwJQpPSuMEEGhM
	0w9fb3OzuXJDfLRyFKKZA2MoQo8w5b3hnXppaARhLP9Gv7kQRt9+wUg==
X-Received: by 2002:a05:6820:498f:b0:679:ae61:ed85 with SMTP id 006d021491bc7-679ae61f23dmr566445eaf.1.1771465424693;
        Wed, 18 Feb 2026 17:43:44 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-67997aeee34sm737226eaf.5.2026.02.18.17.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 17:43:44 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id D8A4A3422C7;
	Wed, 18 Feb 2026 18:43:43 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id D4182E41D2F; Wed, 18 Feb 2026 18:43:43 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v2 3/4] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
Date: Wed, 18 Feb 2026 18:43:34 -0700
Message-ID: <20260219014335.9061-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260219014335.9061-1-csander@purestorage.com>
References: <20260219014335.9061-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12325-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:mid,purestorage.com:dkim,purestorage.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-0.999];
	DKIM_TRACE(0.00)[purestorage.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: AA5D615B6B1
X-Rspamd-Action: no action

Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
requests issued to it to support iopoll. This prevents, for example,
using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
zero-copy buffer registrations are performed using a uring_cmd. There's
no technical reason why these non-iopoll uring_cmds can't be supported.
They will either complete synchronously or via an external mechanism
that calls io_uring_cmd_done(), so they don't need to be polled.

Allow uring_cmd requests to be issued to IORING_SETUP_IOPOLL io_urings
even if their files don't implement ->uring_cmd_iopoll(). For these
uring_cmd requests, skip initializing struct io_kiocb's iopoll fields,
don't set REQ_F_IOPOLL, and don't set IO_URING_F_IOPOLL in issue_flags.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/uring_cmd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index b651c63f6e20..7b25dcd9d05f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -255,13 +255,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		issue_flags |= IO_URING_F_SQE128;
 	if (ctx->flags & (IORING_SETUP_CQE32 | IORING_SETUP_CQE_MIXED))
 		issue_flags |= IO_URING_F_CQE32;
 	if (io_is_compat(ctx))
 		issue_flags |= IO_URING_F_COMPAT;
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		if (!file->f_op->uring_cmd_iopoll)
-			return -EOPNOTSUPP;
+	if (ctx->flags & IORING_SETUP_IOPOLL && file->f_op->uring_cmd_iopoll) {
 		req->flags |= REQ_F_IOPOLL;
 		issue_flags |= IO_URING_F_IOPOLL;
 		req->iopoll_completed = 0;
 		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
 			/* make sure every req only blocks once */
-- 
2.45.2


