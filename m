Return-Path: <io-uring+bounces-12842-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sBAoK4UNw2lKnwQAu9opvQ
	(envelope-from <io-uring+bounces-12842-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 23:17:41 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 29EC131D3E7
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 23:17:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BDA4530BE6B8
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 22:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1CEB241690;
	Tue, 24 Mar 2026 22:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F12yzx3J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E683093B5
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 22:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774390515; cv=none; b=u42ozKyojZtRVLrVA2HTIRLWQ1sYYTHZFZECPRTntFGt/yRcuLYdXJk4i2SkjxrleJGu7NgaBYaEz9BY4j2K+l2/LZEIfX1P5HqXwhJsX5lTuC28yZ/09khjEU4/ax/IaqeSgeQqoTm+l2T+07RG9oiVDAkl+tmAoPXo7uBXm3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774390515; c=relaxed/simple;
	bh=QFpNjeLcS4XnBLeNbFmVGB8mVshYhCDwcz3FGhurQ5c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GFlk000ARugOseIkVGn23R+AwuTuOYtkq0Vt0UcKC3iSlwK7os51IDDmAmsZ82qS2KdDzDuVG5hSyMyfxCcdnhU7OQJHunHVyose2HTRtpG7QCw9PxE+k/JS4HGkeLp4YtqWlGy+dOrg9/x8+Ige8DnDSzlvJXSZfUC6y0lgcUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F12yzx3J; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8296dabef74so4862900b3a.1
        for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 15:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774390514; x=1774995314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ELQgpagoOWCon+91ymu6LjhRaWTSSqV2Wr331mSiGKs=;
        b=F12yzx3JU16JhNG7aLlWhoEe1zheHjz/va23cZpqBLMcEvouVnMcOv8sFORbpLzRHD
         H/EnAoSiaCvzurpRfPrlkLe6+IQSqFA0AOUVN2B4+oL8ZtLQ3lz+4vK5ptgHZdPh5ox/
         44w0bepcfGPFuj0N61oWcCW6DqdKXQP1gpugl4Qx+xOmsZAdJAoOsnJygne5YriWCgK+
         m1ZeWp0nImZBQwiXev4yyHzBJ9q+ziwo7mOKNu6KZp8nKTtFlbH5ckKibDWHcVzdw2kw
         BwAVfF1cIyo8I7WruCk5BaSm+wC5O7RuX6bQU8lziJmjR4FRUuGISjcS9OCN3GT+GVxh
         eDCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774390514; x=1774995314;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELQgpagoOWCon+91ymu6LjhRaWTSSqV2Wr331mSiGKs=;
        b=Jt0lz5L6GUKLtS065tVO07NJ2GQoyDgLGT2w4Nn5AqfThd13q1st3M31xTHwKZXorf
         eg4IjtpA4yWG/GyMhAfGr3x2yxEdv1TpjzSKxLgLgLGQIZoaFvTLNO1v+z9LFe1udFrw
         qh9B5xqttpbewWURqP3FxhFcsMovYQa3rnfMDU5mtv/oZGNPQemxuNXNZPpa8He3mxTK
         LvIMnuHCjKfEhb5U85UGMA3w+TMz0fAn3q3G+SlYhZFUDbsRrO9IQk0rtDJlHmOoBXtx
         O1jMy2c5P9VeseoL2aDMSk190OpYcZQQRW+e2uX6zXXYCCZJpv919pKApnpINo+JwIM0
         FkDA==
X-Forwarded-Encrypted: i=1; AJvYcCUOm+eOZhJ7ft0Wf/m4/q2Z8mL3INrtqZ80cH5jmzcxm+lIyYBVqGyE9dvaMf/KeE6f1jfTmj9gTg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxriERX1w9A1QIi/KQr7dsGNPWyQscmUU8mza/fPNvczc/o7VVt
	eFIJ+awWMsP8vKTzBQeb4YjDds5t7lGVd0Nose2Orb2QTtmxdtw5ywZK
X-Gm-Gg: ATEYQzyE0BQsUVllEEqjtDcqq/FZi4iYTmcsog/dpAbhinUZ/uq0AQ3u9IH1EphGtwi
	EzylpkEC6auttW/D1DOj4g4Ihx2akp4oZyUnWV/bdAIhUnh/gTBOOtj5bG228ZZmOycmgvcm5Xf
	H29zrizQJ0Nu0A0iqdOCEQoKsHB9sWIcekUbcU8eh/GQTIKb2WnNXol6/DZ7ihXtk4kJAOlS4YF
	y9/7BJqe3U93lGdnRSDvJXiTho5gpI+QC+szXY9S8GFkGNktc8xExIrvMS8/UwCI3iChGjnnXAJ
	Td1VrWWb6bomY1+Uob9mK3wIajWSCJ3v44X8i1Gsl+4qGi87lgL9GlC03ItcfEMVUSlED2gvDDT
	614V0TgOP/k38rXuuS8ntO5f4rQu9vKP1GHZ9fhRDAUChd39jmN8DVlc57/2XihUFieYkS3a4qB
	UIbuem5tbOPUvvMvEChA==
X-Received: by 2002:a05:6a00:3a1e:b0:824:93e4:2de1 with SMTP id d2e1a72fcca58-82c6e0e5024mr1089014b3a.30.1774390510540;
        Tue, 24 Mar 2026 15:15:10 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:7c::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b0410a3c9sm16265108b3a.56.2026.03.24.15.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 15:15:10 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v3 0/5] io_uring: extend bvec registration and add mem region lookup
Date: Tue, 24 Mar 2026 15:14:21 -0700
Message-ID: <20260324221426.3436334-1-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12842-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 29EC131D3E7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This series refactors and extends the io_uring registered buffers
infrastructure to allow external subsystems to register pre-existing bvec
arrays directly and obtain a pointer to the registered memory region.

The motivation for the patches in this series is to make fuse zero-copy
possible.

These patches are split out from a previous larger fuse-over-io_uring series
[1]. The remaining fuse patches will be submitted separately and linked to.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260116233044.1532965-1-joannelkoong@gmail.com/

Changelog:
v2: https://lore.kernel.org/io-uring/20260324182157.990864-1-joannelkoong@gmail.com/
v2 -> v3:
* drop patch that makes buffer release callback optional
* add patch for renaming/exporting IO_IMU_DEST / IO_IMU_SOURCE

v1: https://lore.kernel.org/io-uring/20260324001007.1144471-1-joannelkoong@gmail.com/
v1 -> v2:
* update io_kernel_buffer_init() to take bitmasked dir directly so callers can
  set both dest and source

Joanne Koong (5):
  io_uring/rsrc: rename
    io_buffer_register_bvec()/io_buffer_unregister_bvec()
  io_uring/rsrc: split io_buffer_register_request() logic
  io_uring/rsrc: add io_buffer_register_bvec()
  io_uring/rsrc: rename and export IO_IMU_DEST / IO_IMU_SOURCE
  io_uring/rsrc: add io_uring_registered_mem_region_get()

 Documentation/block/ublk.rst   |  14 ++--
 drivers/block/ublk_drv.c       |  22 ++---
 include/linux/io_uring/cmd.h   |  48 +++++++++--
 include/linux/io_uring_types.h |   5 ++
 io_uring/io_uring.c            |   2 +-
 io_uring/rsrc.c                | 145 ++++++++++++++++++++++++---------
 io_uring/rsrc.h                |   5 --
 7 files changed, 174 insertions(+), 67 deletions(-)

-- 
2.52.0


