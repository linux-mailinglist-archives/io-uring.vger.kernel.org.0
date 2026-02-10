Return-Path: <io-uring+bounces-12114-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WLG7MHB8imkgLAAAu9opvQ
	(envelope-from <io-uring+bounces-12114-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:31:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2984F1159EB
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:31:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8DEE5301AA63
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 00:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE1E19CD19;
	Tue, 10 Feb 2026 00:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fPfyplyr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03EA186E58
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 00:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770683500; cv=none; b=XeZUY+AQvyKj68uePT3dDRc96Yq+v2+qaZwVWFkDRaNwECMmt+HEgMEAz30o9+Uy5rGtY/1ifYLpQglrHVtvIxFphGCOVAHXAqV3BlSyycO8GJQ2kkPEQk2BIwhtJj83dIztBxaif85kODTKOLnRfTTzUFUTgCQtjVogKIwNxjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770683500; c=relaxed/simple;
	bh=0rnW1e3mgUZ3/RiF61ly1xawFx9g0UsBaYdm29750JM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qi+tAGUV5YSERGBrcuHAjXrzWMW0Yp+J1Rau69aTl8ngsN91yYogRmc+VK57+xJB76MXDjWUMDkqRF1faKo+p1aKqwOk938EbzkDOkySvdPeVtv/YnBhT1KgcQPWYAx9oAo5RqIwF+vTiv8nd5ddU9/5sNOtLOyvgcLaNlKqV/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fPfyplyr; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2aad802a27aso12966175ad.1
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 16:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770683499; x=1771288299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ef6vu232B3wAWTpryVQF4g7jkfTjdk2p/VIFGFi0HDE=;
        b=fPfyplyr9R9jM1E/UdnHc8jT5lYKLF6AQCoytiZ7lRqbFObiYWYeQcRzi+0cYqSeYD
         W1wgKb0s4QR7PX7cnvGszhkbY6c3P28IsG6lhzp7yMgIkHaGGGv8jVvKtV0ddV2lldyq
         EJOYOWGnS8Gdkda09w5wc4ODC+IRY4UnCwAO6AhRi8Z6DuiPEX1b4LirjwQ7cNJRPwlq
         eTl4qzbn9xPCY20ViyOFQsPe/je+yUWTTMswIzfeoQcdCDBQjTHzgUe5f/Lt5glPkpHV
         NSfAsIDayYHC3wlUm3VKya8RK30yD6AonwhFKbSU5+3HCAnpH8tJo8NTiHHCzKNLwn5L
         TdGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770683499; x=1771288299;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ef6vu232B3wAWTpryVQF4g7jkfTjdk2p/VIFGFi0HDE=;
        b=vAxdwo/fEDcdNm2tVsLOIR+/0yyAK/lHjEbFylxXTZ6T95QuVcXkAPc6aN5Ico5zc0
         RziSPXa+oCUtetcnCPzTEpNakbdrM+zWTiacu4eA4hchV/rE0B5atzqyVryYyNPVRzuO
         ql61Al83D7twkcv9WBjhc+Byz2/Fb8J5DkxYAi8V1MeH5AU5Q1iDMyP/kmBgW+YeFCWp
         m1oxTZw91X+oEJjyNEX1l9qx1SkoJJ5RAsC0IAm4WqnF1GuQ4uXNpCKUViyuG4zMXQtd
         OE6oc8nwvNs8fFXQ4r+lwG25mDOVBtnhCqHuihwlZedXEp+jnWWbF99iwxq8v6qVvAvL
         PY2w==
X-Forwarded-Encrypted: i=1; AJvYcCViORwro0dF463XZUBI4XGyXvQWLc2rxHzDNjSYOYp63n0Ldi76FAMjlGhQ2G0j9PS362H68aJUow==@vger.kernel.org
X-Gm-Message-State: AOJu0YweKqYpJhQjEj3pFQDQah5I9nKr5lAHmURGZphGUwwh2NgUYhq1
	iL4aNt0Jr9Cdc5iEZKoQuv5XoyJn/Bxx9GMJO3pvk3xfTyCUz6JJMMsp
X-Gm-Gg: AZuq6aJ90+uEc7n6alQ/tCqYcQD3G1yDarRzoa8RBA3OgN4cNMAhgubzxfKY6GhyNeO
	ruDXyRkMZjPGcYVBwii2c752ickylpy4nxolwlFyeWtdBHNTfGqgKCOZvH/nqd81oJcV+lsy8ay
	IPm7gmQsCYxp7qSo3h6mJ9Ogrb0kvCzPMGXc+fbRzm14gR68gzulOeOxmRpIVTJms9oADLhYeGe
	48ldbGAjmjBnW668if3dyKfLzET5t4SbBmR6zsIx6Nx0y7F6yaOw74368SOpgUaTZuj2/Rz3pwp
	JouRvSYfGwAwbPOQWrlkkZUg8f+gU4vRAffZO20logkwY2zPvSuJuHcezvSygvevY92hGOAHXPT
	PxqRXqybKSkANSg9YT4WrEaVowZUMlyAnuXmM+1tNcFo2HocZcOu7zAKLxpIDAgRSeaAVlMRu3g
	SeWLIDnA==
X-Received: by 2002:a17:902:e5d2:b0:2aa:e568:164a with SMTP id d9443c01a7336-2aae5681896mr61730145ad.31.1770683499001;
        Mon, 09 Feb 2026 16:31:39 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1f::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a951c4d8dcsm122652175ad.9.2026.02.09.16.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 16:31:38 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	krisman@suse.de,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 00/11] io_uring: add kernel-managed buffer rings
Date: Mon,  9 Feb 2026 16:28:41 -0800
Message-ID: <20260210002852.1394504-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,bsbernd.com,infradead.org,gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12114-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2984F1159EB
X-Rspamd-Action: no action

Currently, io_uring buffer rings require the application to allocate and
manage the backing buffers. This series introduces kernel-managed buffer
rings, where the kernel allocates and manages the buffers on behalf of
the application.

This is split out from the fuse over io_uring series in [1], which needs the
kernel to own and manage buffers shared between the fuse server and the
kernel.

This series is on top of the for-next branch in Jens' io-uring tree. The
corresponding liburing changes are in [2] and will be submitted after the
changes in this patchset are accepted.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260116233044.1532965-1-joannelkoong@gmail.com/
[2] https://github.com/joannekoong/liburing/tree/kmbuf

Changelog
---------
Changes since [1]:
* add "if (bl)" check for recycling API (Bernd)
* check mul overflow, use GFP_USER, use PTR as return type (Christoph)
* fix bl->ring leak (me)

Joanne Koong (11):
  io_uring/kbuf: refactor io_register_pbuf_ring() logic into generic
    helpers
  io_uring/kbuf: rename io_unregister_pbuf_ring() to
    io_unregister_buf_ring()
  io_uring/kbuf: add support for kernel-managed buffer rings
  io_uring/kbuf: add mmap support for kernel-managed buffer rings
  io_uring/kbuf: support kernel-managed buffer rings in buffer selection
  io_uring/kbuf: add buffer ring pinning/unpinning
  io_uring/kbuf: add recycling for kernel managed buffer rings
  io_uring/kbuf: add io_uring_is_kmbuf_ring()
  io_uring/kbuf: export io_ring_buffer_select()
  io_uring/kbuf: return buffer id in buffer selection
  io_uring/cmd: set selected buffer index in __io_uring_cmd_done()

 include/linux/io_uring/cmd.h   |  53 ++++-
 include/linux/io_uring_types.h |  10 +-
 include/uapi/linux/io_uring.h  |  17 +-
 io_uring/kbuf.c                | 365 +++++++++++++++++++++++++++------
 io_uring/kbuf.h                |  19 +-
 io_uring/memmap.c              | 116 ++++++++++-
 io_uring/memmap.h              |   4 +
 io_uring/register.c            |   9 +-
 io_uring/uring_cmd.c           |   6 +-
 9 files changed, 526 insertions(+), 73 deletions(-)

-- 
2.47.3


