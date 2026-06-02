Return-Path: <io-uring+bounces-13587-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4NKuFhOzHmr7JAAAu9opvQ
	(envelope-from <io-uring+bounces-13587-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 12:40:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B365262CBFF
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 12:40:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 05911302353F
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2026 10:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81528369981;
	Tue,  2 Jun 2026 10:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AOf30IjD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311872ED860
	for <io-uring@vger.kernel.org>; Tue,  2 Jun 2026 10:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395737; cv=none; b=TXfe1EgSQdoMJU3K1EladfDURcguaK0U+33Jil5ltI7wmyxXqOedSSs1AbvmEBMK6ts8AzX0nNmyXr2zKdy8ySUPljT5nXJGYLxnELEfi2lM/n98eeiugqOBFUW2cCnV8CJiZaTJ2HszXEFdncTZOmaWh5wKWwo1t+Qivm+YvPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395737; c=relaxed/simple;
	bh=HkcSz52xFrrOWauefQzWAJVmuH3sqYf32u3CdB875C4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nLZ9+yBmMRC91Dki3icqlwjo5/WYNFKAiWOqgCQ7wmBk/MJKlHZ2K/eHD4U+wzgeslzDVN0J1Zq60Q79ONE+s7cribqtQW19RvXfTPZiojDn7p0CzG4kgiKLVt8/6W9ckerEA1IipxAZjefiE0dakvYnL9GKArQ5b41AposxpU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AOf30IjD; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4908b92904fso59009795e9.0
        for <io-uring@vger.kernel.org>; Tue, 02 Jun 2026 03:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780395735; x=1781000535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KOPBKAeEqkvF6QzMZmN8YyjoI4Qdf/wizxMTFj8xlE8=;
        b=AOf30IjD+C5WGXGgXyegaWfVJdaywIhxuiw+dFYHpNA65lnbc2jSiZLfPKUIglcl9y
         K0rdDendiAVF/Aqr4EaEiL9BbrslhlQcTba8ZRf02hPpPZ5V+G8fMPtlGyRwoLbjU6lk
         urivsm1TzqbBUYkIvf9wr1RR0neU0X+TSdAvu7MnIm9yNSg91IYHfkPHfPnYm+4KjqZE
         ms2w/atIGdx+4EKvYGvRI1fpAV5GDBAZS6Wb0X7TK4h3d2a+z1LRUqVWus2rAQg5TtpR
         c6I2FgbhlatZm4l/eAdCyn91qaGt+kTL/UnDs7jN67p2tGv4xTXfQxi9jKKBi9yFd3yx
         +SXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395735; x=1781000535;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KOPBKAeEqkvF6QzMZmN8YyjoI4Qdf/wizxMTFj8xlE8=;
        b=iPqycoP8fr6fcebPPJVN9pTwkNrEICrOo5lOjwe6MXlu9Eln1fSEzgesec99gKxGPt
         epcUjvyHM34xGMLePZS3spycWjW40yGMmZeovUjqb+jUafmW26lFM7ozAfdJbxC71w0+
         Ap8seqmdvAzc91K5CmScEHPrbFxGsWSLpJjDAfINY8Fo2GGCQMd8DlcXAIv2YDwb+BO1
         h0OVXadnh/IHv4pkmf3JmBzq4v+PzPdk2VEI3qtz3JnvBXy69JvjxJLhcCfLxQNW8vX2
         Fi2Ch8LyfZ/TL8rQxzP6a26ccDeqs+Anm1voDk0eO9/qBeiAF5RO2CVSX4G89/eKU7XW
         8p2Q==
X-Gm-Message-State: AOJu0YxSGYwPHfQAbfR7Su3K5XnPl/vlV/snR1bXS7laHOyEYLfv0FbX
	In0HAGJJ4fmX/gpEabP0vz3Wr54yh9+yEgOHRdSKRycrYI2C+cCHzQOGMFBY+w==
X-Gm-Gg: Acq92OErmhPPpKojXQDJ6arJfrCv5HtYSwZ821VMQRPhnp35+S3zK2cOKEQ1CHUtiSy
	Fk1r2jre6jy++xzCqpCfSvQqPbq6EZDnzCAk8zVYYJ1DpUt+SoYXgl6XfngNyoPPZzVOvsIGHSY
	uVuDYJcN+1gxrhvz3h6FVLF922IndZ5YjlUhiee5XSUVjfEfrpV5J+FMJGjEAw7xh8RLG26c2jW
	MWSDdbm5LZHKdQU3AgEjXUbd5oBpQjOeBNol2mQt7/wejaKwZ/P/r7J5idOuzX+9O2E1fq8dsPn
	ZwoJ/mQxxJrT4XOG844wxRP8o/545GVu7Ukur0iVOREuH1TSQD23xhrGNPvv/+CtGYdhImbzwsd
	L1fgnP2ouQqe24RIuzy/QFGfKCQzZDcripX5r05UUAVVQvpjZTz/0Bu4fDjSrWOUS/C3IH1zCI7
	rlg6+8bg3OV0X34H4/AQMpVbzTGW1u4gYEqI0vDnAd162ygndAGklbQn6pWk7tkfMGiZ6QKcvym
	j8ZutsKh5FVBUjwL3KvfdF1b7k18jrS0xCB0hZK
X-Received: by 2002:a05:600c:34cf:b0:490:6869:46d2 with SMTP id 5b1f17b1804b1-490a28d3b0fmr273487255e9.0.1780395734590;
        Tue, 02 Jun 2026 03:22:14 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b0e24069sm59123105e9.8.2026.06.02.03.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:22:14 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 0/2] add timeouts for io_uring bpf-loop
Date: Tue,  2 Jun 2026 11:22:04 +0100
Message-ID: <cover.1780395120.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B365262CBFF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13587-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

The BPF ops should be able to set timeout while waiting for CQEs,
this series implements one approach. I'm keeping it as an RFC as
I'm pondering at a slightly different and hopefully more performant
ways of achieving it.

Pavel Begunkov (2):
  io_uring/loop: add a structure for loop state
  io_uring/loop: introduce wait timeouts

 io_uring/bpf-ops.c |  6 ++++++
 io_uring/loop.c    | 37 +++++++++++++++++++++++++++++++------
 io_uring/loop.h    | 14 ++++++++++++++
 3 files changed, 51 insertions(+), 6 deletions(-)

-- 
2.54.0


