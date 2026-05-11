Return-Path: <io-uring+bounces-13267-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WBmHLwYgAmocoAEAu9opvQ
	(envelope-from <io-uring+bounces-13267-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 20:29:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 280CE51477E
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 20:29:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 96088304C07E
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 18:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1533347AF75;
	Mon, 11 May 2026 18:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="n89KEnzs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF609472784
	for <io-uring@vger.kernel.org>; Mon, 11 May 2026 18:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778523744; cv=none; b=OVb/fpU7B3cS9BpAkpakUwA0le2H2LcFNyCbL4GwTojqLRlw42sKqL3KZcKwo5fpUkI5P2DNGWsvU5moi4g0RAXsUHq//UlhkUFilZWFf4FFWVYoyIsvzx/NQARQQ9AsRGzJLZk48+voXoRwugE425uQ0Is4dUJrTSUBNVNJ6q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778523744; c=relaxed/simple;
	bh=/1mie9nVUoECq16WFXfhF4ZPLiJIB876MHOFi0zqUoU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hCCmIrx4rbjTlkKGiWsHKNQkn58+RlApTeeyiApCAMsX4WdySMOW519nsZv0446jFvBs9VJ4UjiNG+GIKc6zZHCx4Ne2KcHDfs0kJtfYzMhHz//nzfaZrPRsH9mWrtom9K7/UJ+9IqEbKtfmI1fjhNRuwcsk4lLsyEF3TZtYBqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=n89KEnzs; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-47c7b282d73so2714803b6e.3
        for <io-uring@vger.kernel.org>; Mon, 11 May 2026 11:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778523741; x=1779128541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=3LhD/Ik2jdmBxOHiKajwI1CIdjKIOKGb9//EjQmsz6k=;
        b=n89KEnzsU2KiMif8DaAmNluCEQzXg3ccVBZs0SLnTuND/rKJellxSfHG1DAaTWNbs2
         CjSNbZEzBB6R1hvPIQj7YtWRHCZxrKyaCQPtsq7/sX1+AkNIw9WX+EPr91qsJmjf+CK1
         S0ruvV3NP22HYtu7AMj3TP84v1JszZTMcfJCHRQ+ptKJ6gm9LRs/cZf1SnRRULqP8kIQ
         7DPIYceDGQb9k5iQZYbVuBCyDGC3miU5NB65IhaWSDzh0Lq8xvRabGYV+Qtia77tgFC6
         cIWwvd7+ufBsSYdZWOCwDYV/G1yljxpYjYLHAt6TCVOFSIk1XPtjXNKkIp6KwQzsRLB3
         cWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778523741; x=1779128541;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3LhD/Ik2jdmBxOHiKajwI1CIdjKIOKGb9//EjQmsz6k=;
        b=Ais/7ajCvKkQWDYYMy5SQ4373v6WHEsnP6awQwgAUK7G3Ul2557gaPwqjFKlyhuNoI
         GFVfU/xfp0Ov2sNXzzK/iQ5nHIC2Ta9rSMgMj6OCwwBHANSLsXf7w0F/AQkUBvZSP5sl
         A4k2hWNHzw0OZD/g3e8pPdbm/liXCyOedlPoWoW7ImXH9JQEVXxzXwhanZT0xM35hAI3
         PVjeq2e/ASoyhHCXl6VuFZQhm3F6wMDQdyQM/Y/FJjUZOwlPFBXggMUfbXmqoaOaxK6v
         sHW+Bj/tM53XmPqtTNB5EejBJf+ENXjA0RYGxZKzMJ0T3/bv0gxvNXKq6YUuAC8iDdvh
         F7Jw==
X-Gm-Message-State: AOJu0Yxw0uO9ETNkqXy99rxWzToUzWB3gEXQLLA8didc77Do1o8WaR0w
	+nElJbyz8rowRQ6nH8JHZwSeuXZpkgFzpV2PCcSHbqs+nMZ+/idg4wu1WfpkJFbusJk68UO3FTQ
	SVBGp
X-Gm-Gg: Acq92OFJKMc2svNhlTAIsgLmeZESvK3roPgxZFO5MQXcsJCTysaqh+xyaWkZRYSMhJs
	93bpvBkmYv9992tclG9acL3yHFZ7Ghw1WeTmb7jU7nqa6jolMsDt3gpAwJoA+tckB8x2hVYLn3L
	JRcp4894NSIOf3lF9dfCPXLhWwB6Zf7PzKliM5pKnMMNMKi2uBUoxLhZoYR/knJQxwFQewu4OZu
	KfLJx6dpnyuWCU0vJpe8R4Fb/0aTkfMzEnx1+kLPFU6tAnqoSHcwgNWmdN42QCdQApF8rYOx9yF
	GB8e9k3CGAkXqWdTuDwXhqTjNlBqZsfrP6+pqJW/nm7c3hxh+6MnykOp4V7ZEBDgfnqulDU5htF
	h5MUxD9XRk47KrtQSTalFO44mnuFtNl3cyPUzYTDiM2FpGRtGNLdkYp1h3iyUdTgfIdKLj7eAW0
	plBgL4az3FykPibccNvbAKS00/xbSSpgqUjyv4zeoWBd/6LICzIjH8WHtJcSc23NMtDqA=
X-Received: by 2002:a05:6808:f8c:b0:482:40b3:a669 with SMTP id 5614622812f47-4824a6c96e8mr5936453b6e.12.1778523741135;
        Mon, 11 May 2026 11:22:21 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c769c9b12sm20749141b6e.17.2026.05.11.11.22.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 11:22:20 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] Linked request fix
Date: Mon, 11 May 2026 12:21:01 -0600
Message-ID: <20260511182217.226763-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 280CE51477E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-13267-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Action: no action

Hi,

A small series closing some gaps on linked requests, where iterating
a chain must hold either ->uring_lock OR ->timeout_lock, and modifying
any existing change must hold both. Most cases already do, just a few
gaps that should be buttoned up.

-- 
Jens Axboe


