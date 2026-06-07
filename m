Return-Path: <io-uring+bounces-13627-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 34JRL3PhJWpXNAIAu9opvQ
	(envelope-from <io-uring+bounces-13627-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 23:24:03 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CF5D6519F7
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 23:24:03 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gTrZ9dNw;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13627-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13627-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8CEE6300D86A
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2026 21:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A09D314A8D;
	Sun,  7 Jun 2026 21:23:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0CE2E7362
	for <io-uring@vger.kernel.org>; Sun,  7 Jun 2026 21:23:04 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780867385; cv=none; b=GXjFgSY+Z/tgSLJMOGVJHPHkgG1L7iDhLic4iaPJpUHJrUCb3lvzlxE5VVg2cKmtr9O8YD+o1vL8sR4nfcY0FAtx0INVvicIGONOWk29+fIC1+t+S510XuWyy0kRQlWh24yQXXag6Y9JHDwauGDlSyBjcTee66srTgTEpj8fVSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780867385; c=relaxed/simple;
	bh=EEq5qvhA49r12mr+gMOEoD/0WfBAlttJQu44IQmu5X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsxeK8k7skqQ/7a0JN7mVm2GeP7XMfh0qqpRhsr+y+PCWSrqNGmAwePvZYoeJnjPRuDSRzlYFYjF+9o9vIULx2OPbvwAlgV7eQNzYyV+svxtTrFKFqWjYmrfkOZULr7Zs3E+beM1xB3RzR3xzOrNPER4Rwg/+N+jd8z2yqi9wKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gTrZ9dNw; arc=none smtp.client-ip=209.85.221.43
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45fd461e4a5so2540443f8f.0
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 14:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780867383; x=1781472183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDTJqgjzotVu57/W16f4O0oCW/R4B2iNnJZk0eAPd8o=;
        b=gTrZ9dNwk//ZhNeEyj8uaIZDMk/dkN7yNzzEynzrKNRj2v38I4A+faBa1KeHpOQK9k
         KbnHgaRQPsAp1rTb3B30+AxAoPASxPk9Kvgy/YhZnDejRJDLG1kRJQ9sx7p8/7vrR0G0
         TeZF500x95jYczIoK64fNqIhRCKrYkYjrSkPrxJC2ZqZAKEBeLa+dx3lxZrBHb+yT9Ik
         OH1i5ZGtOf0fixtYs0uaoAjhL4OnJJ7RWynkte5KR4zBANhLhEfsJmDAOWGFikjZ6ev6
         JUKcV00JsKHxt2wftpJwASeZvl9+ut1HJZEwMN0nN1H2/56Z/QfajiwOzFFKy9rQPjs/
         u4JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780867383; x=1781472183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xDTJqgjzotVu57/W16f4O0oCW/R4B2iNnJZk0eAPd8o=;
        b=TO79CXmUy/gt/uqxD0P4PARDtI9qbevk707Fq7Zd4SYs1MG3heC4HM8sGlVQjvkb8h
         EwxJA1/v8bWBF/wvMWLxO1fbCyR5L7DFxlkS1ll6fHfjtRuIofDQM1IMd8vup7Vgy0Eo
         Y+2PUjQg9Pin7QkrLnB8rY6rMW7ugH9hXaviLRevIKzWwyKj7PKQ2fs1PMc4LJce6D+f
         kQzEHa3eOMRowGfOB+TSA6+obg8+rnDmSpE1zvDvfS16deSwUeTJsir4XREp/9h2uZj7
         /M68bULCrzyVwuTNuU87Wi4fhD4RyroD7PZM6X1w54X8TzmwT3xbz1q+NYSnas7jZQZy
         g5KA==
X-Forwarded-Encrypted: i=1; AFNElJ8N6cTRRswcSxxTJlU0oa3qkyISdIII+74iEZIYQSgN+0R2d7jmGgAHLsKVkfbCNt0lWVPv9po3oQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxodpPUxw7Oorr/iyPPOafrbB9qF7qGoHNIWqW8KPgK5J6mwo6b
	AQZZ5FpdL0oJPmN5xd+kfoYVquT7uzWmWgddFy0qUMun4Is9nUuqP7bK
X-Gm-Gg: Acq92OHyN3IxJVeWvTQqAhZbGHPTWucmZw+KnMqmAw7kD0r03NpJyGbz3d1j1m8b7ww
	6kO4rgKJkEopNgNNk6NJI/K2etJXDAEQL51XIlNBd1QKwP6YnvReis9i9ySmLn6xWm2AKYCpo9N
	wPZuMOW18kLg+nhIQNcOvYxqpG+ku+7iy7Uf3UYksxxVJrYDYz88twiUGoDfSz7Hp8IS2fKGDIy
	RdimBL1905P2WewFUooVRIYUU0YIbTxk/F8hX7GiFMcAhI9G6e+4dbWY5NG0/yWeNjPthVswbiA
	e37Z/sFgMonrm44tC+SKWntdxZIfmLG2tIqm0RmVnXP6ydLemWnj+5e8C1d1+OUPnwt0H99NG8U
	jol43Da7lOvyZUphxvABdXs/rmAyGbYon23vcsO3zPS51ChsOW7eICs8jief+ahISHYb670F459
	0bIjz8w3UiF9P3O61vpjuCn2XMyP7DMx0hU9+o7sw7
X-Received: by 2002:a5d:6190:0:b0:45e:ec18:f20a with SMTP id ffacd0b85a97d-46030759730mr13984648f8f.32.1780867382776;
        Sun, 07 Jun 2026 14:23:02 -0700 (PDT)
Received: from localhost ([217.199.144.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f35fb24sm48890167f8f.34.2026.06.07.14.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 14:23:02 -0700 (PDT)
From: Nyakundi Emmanuel <nyariboemmanuel8@gmail.com>
To: federico.brasili@gmail.com
Cc: axboe@kernel.dk,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nyakundi Emmanuel <nyariboemmanuel8@gmail.com>
Subject: Re: [BUG io_uring] Failed RECVSEND_BUNDLE can persistently shrink non-INC pbuf ring len and affect later READ operations
Date: Mon,  8 Jun 2026 00:22:18 +0300
Message-ID: <nyakundi-confirm-recvsend-bundle-20260607@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <CAAEr8jZDdiYB2vp9VJzSqq2J-GssH8GhrLYYn_2W2KAjYwDzSQ@mail.gmail.com>
References: <CAAEr8jZDdiYB2vp9VJzSqq2J-GssH8GhrLYYn_2W2KAjYwDzSQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13627-lists,io-uring=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:federico.brasili@gmail.com,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:nyariboemmanuel8@gmail.com,m:federicobrasili@gmail.com,s:lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORWARDED(0.00)[lists@lfdr.de];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com];
	FORGED_SENDER(0.00)[nyariboemmanuel8@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nyariboemmanuel8@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 4CF5D6519F7

On Sun, 7 Jun 2026, Federico Brasili wrote:
> I found a reproducible io_uring provided-buffer ring issue on Ubuntu
> kernel 7.0.0-22-generic.
>
> A failed IORING_RECVSEND_BUNDLE receive on a non-INC provided-buffer
> ring can persistently shrink the user-visible buffer descriptor length.

Confirmed reproducible on:

  Linux archlinux 7.0.11-arch1-1 #1 SMP PREEMPT_DYNAMIC
  Tue, 02 Jun 2026 18:26:58 +0000 x86_64
  Arch Linux (rolling)

Output from your reproducer, run unprivileged:

  [INIT] entry0 len=4096 bid=0 entry1 len=4096 bid=1 tail=2
  [STEP1] poison empty socket: BUNDLE len=1 expect -EAGAIN but entry0 len may truncate
  [CQE1] res=-11 flags=0x0 user=0x1111
  [AFTER1] entry0 len=1 entry1 len=4096 tail=2 changed_buf0=0 changed_buf1=0 guard_before=0 guard_after=0
  [STEP2] wrote pipe bytes=4096, now IORING_OP_READ len=4096 after recv-BUNDLE poisoning
  [CQE_READ] res=1 flags=0x1 user=0x6666
  [AFTER_READ] entry0 len=1 entry1 len=4096 tail=2 changed_buf0=1 changed_buf1=0 guard_before=0 guard_after=0
  [STEP3] wrote second pipe chunk bytes=4096, second IORING_OP_READ len=4096 without republish
  [CQE_READ2] res=4096 flags=0x10001 user=0x7777
  [AFTER_READ2] entry0 len=1 entry1 len=4096 tail=2 changed_buf0=1 changed_buf1=4096 guard_before=0 guard_after=0

entry0.len persistently corrupted 4096 -> 1 after -EAGAIN RECV_BUNDLE.
Subsequent IORING_OP_READ consumed the poisoned length as reported.

This confirms the issue is not Ubuntu-specific and reproduces on a
stock upstream-tracking kernel.

Nyakundi Emmanuel

