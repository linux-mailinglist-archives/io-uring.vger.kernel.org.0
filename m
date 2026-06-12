Return-Path: <io-uring+bounces-13684-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id vJO2KDh0K2qd9wMAu9opvQ
	(envelope-from <io-uring+bounces-13684-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:51:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F80A676545
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:51:36 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=q5ROqATl;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13684-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13684-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 94315302814B
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 02:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC61D2F12AD;
	Fri, 12 Jun 2026 02:51:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8566B374E57
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 02:51:30 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781232692; cv=none; b=CIwL4FYPMuBBCeB2LlCRygsQ7kacXxtpCV/HvkDPtllCxyM/4dH80AhfDBwr2vsAKrXtFWk1rd7GWFQZhCGKrWbqjOxqeOeQ6/agoSK4/2MC78osQoaEKLyd2rwrDrnoPSIDvhKiRr317tMB5Gz/yh/qo548enfk8okusZPuHik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781232692; c=relaxed/simple;
	bh=qeEq+jXLKSBeftNrL0mxrAEPEAZdpztu4D0rIVaClLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oe8b9KdZIVJw6QRZKdBEdv/Ry9K79KdD23TgyEBVYo35MgXOa+xuFyyOJRo3F9KR7n+rPvx5LYBc78ER6oa8FcvSbrc+V/sROK29CZYTP83TeaOn6yWvFeTMnIzt5bCl0PVxU+wRO2zlk8oaFuUPfqj4d/gYDGKgM+cKa3qdj68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=q5ROqATl; arc=none smtp.client-ip=209.85.210.43
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7e6fe199b81so224590a34.1
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 19:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781232689; x=1781837489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vg2z6CM9xvgBbX9e8SKGvNps2itWk5mL8lT+FpybT60=;
        b=q5ROqATlmYx82weYiL72jTRKt/hbZjz4r9IQubJoqYZzQQuBR53cOdEoInTkAjLuNq
         StSUg3jaJjC6smvBeoWy8t0nkxnkKOPskVnwy/9EuCyCfFlhnrRuRX+1PJ14LM1kvX7T
         nTc/AJe3Gx1qh0N/XGsXAKIsoqdyPjN9uVTbhCvo3M+2s4t1cSfs/S25/5C3eeUYt/dv
         DrP6ePIsvpvU6E61wotqHazG9ZScHOfRrCTdMAleeiCq0xL95r6AXvPb6PNPtZ8fK77Y
         3CRNRgXGcjERUTjDg6IBbLJjqWeR1qyoRXTXcle5ikAFdVw0Wa0/3EFq1zPd/b79fzuH
         rrIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781232689; x=1781837489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vg2z6CM9xvgBbX9e8SKGvNps2itWk5mL8lT+FpybT60=;
        b=WjZpQ+hE7sfLptI9MdDlRuCcYqg4zFF0Wl+Lej2ZbpcFhKzhz3TSZ6qOQunsAcUZJV
         3oSRnG/xv+z60TymePiUeT81EHBzt6VUsv8HtxKgW/Xa/9o2Z999kJr4+dj732bxjU2G
         kPwE6H0ClszR4o+cxlCQvDN5zWGzgxMNuL59NQDZ0yuQjv1SFX6WcCP1hlS+mU2B0OdM
         VUO9Ver7Hgj6g+J6IlWiu6q/FOWjXmpItN16/LpG4SBDdK4Y+k3694ZJRKXies8rf73P
         ZdD4RT+Ye8WVMHb+yo/klKDUnlVnsUph1dOG9odEXDiaA9VaanWnGtl/5WbbPCDv1Wg4
         fPGg==
X-Gm-Message-State: AOJu0YxQYYyBrFIfnnS2xi2+2tstXxtESvZ7hlaMxcAgMxmjs5DoNdWB
	AmRXR195mPc/ZHaAcA8ZJ4fcTfx1ni1bzNIpqrGvNuc0M20B5J7c9Re9AljkND7n1nqL3LOLFvl
	U60MACUc=
X-Gm-Gg: Acq92OHTZZu4MRRLs/4GrxveFCMw8+T/OwhAB7ZSUabT/7B8B0zgDnVecqLOYrWGUju
	mC5o1HU7ZtPJIZTnwDjzwlp7CUy+EKs1N49NYBIkBDr6Q89WlNlu2PQQiwLM3NZo2oczLMPSpvH
	+Svowc6sQc7FWqm/3YeDh6Ox1Pz6gkWbcciUXHec4cngATgcPJxxLItiAG5Vyqymwrt/u18j4v6
	BHQjgQHoZ1U7Wr9tw0n+lOGERjC9f/q8KaZ/8ynqqbJk6pRPGR114Z1EF4np/4RoxE+5/v4OwAT
	nr8VB6KXhVVYg62GtkxWNFISOJBk0i6+XlQDab2J+drFaiR5RrAzlW5mok0xsZ6xQBuU2fS/c9e
	opCY9AgC6ENQQVRaCpVxLLV2nOnWIRwukMeA/2MxcnMJIKHCJ/Sbdc3Ojl4f8foTnToTAAFPkOM
	bsPm41f1+kyuty/hUF/ov1h/2gwBIzocAZmAY3PA3DFy7zt2eTl0lALkdY3PlxMoahRr6Y
X-Received: by 2002:a05:6830:3912:b0:7e7:31c:c121 with SMTP id 46e09a7af769-7e784771f05mr555059a34.12.1781232689394;
        Thu, 11 Jun 2026 19:51:29 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e781734190sm862128a34.19.2026.06.11.19.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 19:51:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dvyukov@google.com,
	csander@purestorage.com,
	krisman@suse.de
Subject: [PATCHSET v2] Add lockless MPSC FIFO queue for task work
Date: Thu, 11 Jun 2026 20:48:26 -0600
Message-ID: <20260612025125.1690253-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13684-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:csander@purestorage.com,m:krisman@suse.de,s:lists@lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2F80A676545

Hi,

For v1, see here:

https://lore.kernel.org/io-uring/20260611160553.1486640-1-axboe@kernel.dk/

v2 moves the regular task_work over to mpscq as well, and adds a few
optimizations on top of v1. See the changes section for more details.

Can also be found in a git tree here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=io_uring-tw-mpscq

Changes since v1:
- Add patches moving !defer task_work to mpscq as well.
- Get rid of ->cq_wait_added and the associated atomics on that. Have
  waiter set ->cq_wait_nr and just count down from that. Removes another
  atomic in local work additions, and eliminates the need for the
  atomic_try_cmpxchg() for the faster lazy wakes.
- Get rid of RCU read lock for local work additions (Caleb)
- Cleanup up mpscq API a bit (Caleb)
- Correct mpscq comment (Caleb)

 include/linux/io_uring_types.h |  39 ++++-
 io_uring/cancel.c              |   2 -
 io_uring/io_uring.c            |   9 +-
 io_uring/mpscq.h               | 118 +++++++++++++
 io_uring/sqpoll.c              |  30 ++--
 io_uring/tctx.c                |   3 +-
 io_uring/tw.c                  | 307 +++++++++++++++------------------
 io_uring/tw.h                  |  11 +-
 io_uring/wait.c                |   2 +-
 io_uring/wait.h                |  10 +-
 10 files changed, 316 insertions(+), 215 deletions(-)

-- 
Jens Axboe


