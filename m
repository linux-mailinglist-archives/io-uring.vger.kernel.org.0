Return-Path: <io-uring+bounces-12812-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gLP1CG7WwWkaXQQAu9opvQ
	(envelope-from <io-uring+bounces-12812-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 01:10:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A4702FF5B5
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 01:10:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C2676300F2B0
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 00:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50BFEEC0;
	Tue, 24 Mar 2026 00:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Un0uSQQp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D13273F9
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 00:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774311015; cv=none; b=SkFmRzwuwWqgbz/fxfdu3E9HBqdVXhzHOtdLdHjTPYnpyIWUD1fVC27GOCgQ3ft5mC/jigB4l+92djz4cl/sqKmczvZla1/8kFgtL8FmqGIXEVJnSiJ/tiEhcZdbsX4tVmnHAk/2Xvd5EILMIeXxyCd1dyMViFOy3rRuHGHqpm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774311015; c=relaxed/simple;
	bh=IbAw3ZLW1hZPVagabh74ljI4jFpdYVS7ZuikBJ37iHU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O3lpbTJjwS116VaTKS4pCtC5aA3umQlKX+7q7eySZioDizrgm5ZQh3lkck5aBDHJBmwAOlOi4p7HI8SILM/4kG/D6Vkk0KVUWIKefSRsmG5beKemY/SFo5oRu3YiNQnvTAVrdTD/QVWVDcfgtffYXcL8071/DycmavMyobzJgM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Un0uSQQp; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-827270d50d4so710585b3a.3
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 17:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774311014; x=1774915814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qiGg9e0CMeWQCnXZFqT+SmHuI/gmt7YL2vhCkuolLXc=;
        b=Un0uSQQpTwmjM9J82LajaTkX6Rj1hAw/Io5GqQL8lpztaEH6fFAbrnELiok1GRmfC/
         wtwoy90cYgMM/QA3ici6rrmpbLw0E3x2SdKyrWJba3i6cm2wRbzB6C9N8x6tpPJofhWM
         3gXWIBaMzYDVTM40ZksaLxhggvrfMOeVEqvTq8x8E4cNUI925W54yShUVlT/C9mTWOSC
         ATurtbhQ5a14zihAN+PQaWYToHNV7l4tRvR/N3EJMJNamdQBijsBwYgwMz4CVGDBqypo
         CaX1g8CIjVIBWhLrT8bn3fajwtY/iX2bum45Bmk38qel2H4n8nrA5DnSqpKhkM/pY1W6
         GlMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774311014; x=1774915814;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qiGg9e0CMeWQCnXZFqT+SmHuI/gmt7YL2vhCkuolLXc=;
        b=gyE+if4G1o85wfYjZYAlOQquW0Xu8dAdmll9D0bwTTcQ8O4Dx8Pr6sUJIFzWZGuFLf
         kTESkouHNKqHUYbLUiQB/3GtkZ3hN2M69Df1uq0GF7x+o/6Eb8ke/wUOgAK78CpXyBX+
         aishzQ6it4KzSrDG/kanHHO7p1jhoLy2x+yP2s/Hrt+wFltwfbaz+7/yUdPPuXHtWBSC
         nEnz+LqHWOj7NMziuZZNdY3b9fA3bGPm6UskYxeXfdv/XSs06Mp980p08sc+hP8L0yio
         1X9IdwiBDbpF6HCDAzYDG4IA9INEmCaclBQm1shYTZaEsmAndpw39q+6doQQCR5ubssN
         nf8A==
X-Forwarded-Encrypted: i=1; AJvYcCXFuLp7qZosHclm/TQKvuN2SDyXHnT6uCMZGyZbhjZzmFFcKywPL1v7NDyRhdbEuS6FqOidhmvfrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxxjWmzippyJvNKtpql2ae1sJXYdV8rvPx0c7nCLbwJyrUTlb+I
	3wUnGCL2csYjIG0ADvSX6vE1ax2Oxyc5vJlZfgpY5xMpUB5uAVjKd62zaB12pw==
X-Gm-Gg: ATEYQzyBSBdMb2HmVqBPQZcaeSsHTQw9B2FixbjILkquwDu5KVhtlO2z4Y0vHDg9jQH
	U86TN7z8N2Fg3nE41YgWZs/26jZUoc4xUZuy3aRbMq9CDGRbGfxczXyx0uBbAumaHGmO3I8jf2M
	+2bfzQPlA1+DtZPwGpj6dLRaNyv0t/7cpeBRQLTRyghWTjOmSwGR3slJjy2stjEFcWzNOOeY/Qw
	iF+5Mjtr+lBasY29bT/3rO3Coj26VGcPh7diSHIOwTDcrEAuxm+ku3BpVvwO4hPVcmYkqRGmAth
	a1YSUlT4RPSuOF7G1PmwXpOpMzpIPe7Ykh6cMBLlJJQKJkpw0DDlurAs6YUaWTJ1afS+4SAzw8q
	JZUeBApl6vyAHBN6eFjwwhpsJ4EPa9qx+8MqhzVP2SufFC25DToz9GjqEcaOcYMw9zX6mejoyxU
	UqKLUTpvpgn1LJA8wRAA==
X-Received: by 2002:a05:6a00:3e07:b0:81d:dd3a:b8fa with SMTP id d2e1a72fcca58-82a8c334e6amr12310586b3a.50.1774311013760;
        Mon, 23 Mar 2026 17:10:13 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:44::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03be31f7sm11980613b3a.26.2026.03.23.17.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 17:10:13 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v1 0/5] io_uring: extend bvec registration and add mem region lookup
Date: Mon, 23 Mar 2026 17:10:02 -0700
Message-ID: <20260324001007.1144471-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12812-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2A4702FF5B5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This series refactors and extends the io_uring registered buffers
infrastructure to allow external subsystems to register pre-existing bvec
arrays directly and obtain references to registered memory regions. 

The motivation for the patches in this series is to make fuse zero-copy
possible.

These patches are split out from a previous larger fuse-over-io_uring series
[1]. The remaining fuse patches will be submitted separately and linked to.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260116233044.1532965-1-joannelkoong@gmail.com/

Joanne Koong (5):
  io_uring/rsrc: rename
    io_buffer_register_bvec()/io_buffer_unregister_bvec()
  io_uring/rsrc: split io_buffer_register_request() logic
  io_uring/rsrc: allow buffer release callback to be optional
  io_uring/rsrc: add io_buffer_register_bvec()
  io_uring/rsrc: add io_uring_registered_mem_region_get()

 Documentation/block/ublk.rst |  14 ++--
 drivers/block/ublk_drv.c     |  22 +++---
 include/linux/io_uring/cmd.h |  47 ++++++++++--
 io_uring/rsrc.c              | 143 ++++++++++++++++++++++++++---------
 4 files changed, 165 insertions(+), 61 deletions(-)

-- 
2.52.0


