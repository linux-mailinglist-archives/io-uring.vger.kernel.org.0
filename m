Return-Path: <io-uring+bounces-12948-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kHVKD+v7z2nt2AYAu9opvQ
	(envelope-from <io-uring+bounces-12948-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 19:42:03 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BAA7739716A
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 19:42:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 21F343005AAD
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2026 17:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD8BC3D47C7;
	Fri,  3 Apr 2026 17:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EfVs4gQq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892673D413A
	for <io-uring@vger.kernel.org>; Fri,  3 Apr 2026 17:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775238121; cv=none; b=CNHZK/5NQ0yydxmcKDd2ujySf1GQZiGyDbI5M5cPkNWNLW5PVHG2kt/i3AkmaP5U8/g5HCHZFErc0fSOgKimyTHzg6dVTvsNbB9IwTEfMPZow/M4sUewksjzFFreuv3MyXeWLk+/uK6H6G7V+zOI1mCuZj4thSRw6zrh3WczqJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775238121; c=relaxed/simple;
	bh=C8B5hl7IizFDgtFrQvqTaXJGonFaqYa8vGoWwxMGBp0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l2/ReCFICqzIa8d5U3Sj4p3FonWtymm1drqra6+yD1uY71QkkueO9GsegnXx6LyFw2a2qcCwMVW3M1YOg3NoC2rFjM//5reYq2SKjaLYgOayl68aE+veL+K/JFwrrdaM17eB+zpFKJNO+gCmPj0XjJ5L3dUOrJQOcNLg0pTuzbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EfVs4gQq; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2addb31945aso15581395ad.1
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2026 10:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775238120; x=1775842920; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RiDPqgRogsjVY/vzsvzcAiyKnfiXL9JVJ/Tv8GgBJlA=;
        b=EfVs4gQqi5FJjs/Ioe2mFDSZqClLTjeJ5PhEH5Z9A+EmSVNLXoI82KX+Dmwha/e5FB
         dziudjWkaKdzZIPT56UYKZoFK2RWWkGZg4DH1Xqvq8GPRxBUXwzEorH4BkGzYXVYJ+Nw
         murJrN24FnugfGxJaNLVPzyDgNvDM62D7LGupnmJ7duBMTtlRsZeOh740iA6vZ4zkg4J
         6knxRONZH/jysdM4jyqCb9wNeU1mCWMEU4yzfY5m9WGmv2F6HpuojQlD+xbhs4lMh5/T
         FAb/Qib/+1bXs99XuChREpy5VKfKU30YOSxGGiPSKCaH+2ndD7nGAE7znaMMVY3jS48t
         AcoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775238120; x=1775842920;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RiDPqgRogsjVY/vzsvzcAiyKnfiXL9JVJ/Tv8GgBJlA=;
        b=OEr1oKXfJ1d5mRHm352oIyq3vIE3PyA/jUw6Ma9Kk4h6O+3KvgRmyCaAE0wNdZVcjt
         hvBg7CdewgFm1e90yFt9jDWiOZEt4GhC40DgLGsbczpgWdofbCDkoLgdPnbQVY0tHg4G
         nLOmXbt+aEqbuksCrrQw/ZSLahVNXmPUrWp1N4Gz9S7IY0idk3KODKZupX0fWfpBOVCn
         6E+vRMcj900yadfiiGOCsf1Kr86qLCjpmXfoYUzhFsSuB6ufsMdA0z6pSKO33bldzZNi
         8ywsfVN099TpGi3KQhCHUJlTgdMq3BFJVfKA9yk5eJwSbKyK15LiKQ5MlosZy7ViSgs4
         bx/w==
X-Forwarded-Encrypted: i=1; AJvYcCXTPO6U4nzCianNVIMgnTGd34IpveHpVYwhdNvlAtMCebEgNp9nAWVJ2ANVCfOdCVMfX9wwGCacGA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzhDtZS1QvgRIaS0bg3cz0VXDdZt3odzxoggMOXXRICOPJgLkpg
	/a3M/EYRvVEEHT3uJJICsWtt3om4ZUuA5BZFEEh++h2qmu5L1qMa20pmZNk+cQ==
X-Gm-Gg: AeBDievjasae6T5tG2QoF127cPJ7WWyXwvkJHO/J3h4AYSm31xjkxVcfcezJEPpcFdA
	32IK+gJ+tc3Wzj6zYy0LLmGD0Ote3BAieOgKjfkZkCvqy8yGkjWucvT9R2DzcBx2B/yON2YOe8P
	pDAncAOLPDsBhYFzMLI3EZpFmId1aJehmIIQTEaFINn1RPHjsjQZVgFGfvkPNnRu85apwPs8nyO
	bWm9NLVZD+MQIKVJ7Pv40SBmnW64DoKNMJm7c+rIYrAd8q7sSmUH3cG76gAOFkEw7dAFKZWMRrL
	3rpXH3DqlZGtJN0ioPzUvG8fnkAwYGbwV1lz0Quiqkg4QZoixFB1+7xsnNxF3pEX1Sa2kVe8jT2
	szY/WPsbMU4asnbw7jY0rVSmYftX7km+MgvO8HH1IOVGf+r4zroeE02QNcz0WUeIfWpm40tzNI4
	aFDqJbQSn2kyycPajVrg==
X-Received: by 2002:a17:903:4b28:b0:2b0:52b7:e82 with SMTP id d9443c01a7336-2b281867dc8mr37797865ad.16.1775238119812;
        Fri, 03 Apr 2026 10:41:59 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:17::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749cbd9fsm62154305ad.75.2026.04.03.10.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 10:41:59 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	io-uring@vger.kernel.org
Subject: [PATCH v6 0/4] io_uring: extend bvec registration
Date: Fri,  3 Apr 2026 10:41:35 -0700
Message-ID: <20260403174139.3634824-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12948-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BAA7739716A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This series refactors and extends the io_uring registered buffers
infrastructure to allow external subsystems to register pre-existing bvec
arrays directly.

The motivation for the patches in this series is to make fuse zero-copy
possible. These patches are split out from a previous larger
fuse-over-io_uring series [1]. The fuse zero-copy work that builds on top of
this is in [2].

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260116233044.1532965-1-joannelkoong@gmail.com/
[2] https://lore.kernel.org/linux-fsdevel/20260324224532.3733468-9-joannelkoong@gmail.com/

Changelog:
v5: https://lore.kernel.org/io-uring/20260402160929.2749744-1-joannelkoong@gmail.com/
v5 -> v6:
* rebase to origin/for-next

v4: https://lore.kernel.org/io-uring/20260327172631.3380702-1-joannelkoong@gmail.com/
v4 -> v5:
* rebase to origin/for-7.1/io_uring 
* drop the io_uring_registered_mem_region_get() patch

v3: https://lore.kernel.org/io-uring/20260324221426.3436334-1-joannelkoong@gmail.com/ 
v3 -> v4:
* Add comment about io_uring_registered_mem_region_get() locking (Jens)
* Return info in a new struct io_uring_mem_region_info (Jens)

v2: https://lore.kernel.org/io-uring/20260324182157.990864-1-joannelkoong@gmail.com/
v2 -> v3:
* drop patch that makes buffer release callback optional
* add patch for renaming/exporting IO_IMU_DEST / IO_IMU_SOURCE

v1: https://lore.kernel.org/io-uring/20260324001007.1144471-1-joannelkoong@gmail.com/
v1 -> v2:
* update io_kernel_buffer_init() to take bitmasked dir directly so callers can
  set both dest and source

Joanne Koong (4):
  io_uring/rsrc: rename
    io_buffer_register_bvec()/io_buffer_unregister_bvec()
  io_uring/rsrc: split io_buffer_register_request() logic
  io_uring/rsrc: add io_buffer_register_bvec()
  io_uring/rsrc: rename and export IO_IMU_DEST / IO_IMU_SOURCE

 Documentation/block/ublk.rst   |  14 ++--
 drivers/block/ublk_drv.c       |  22 +++---
 include/linux/io_uring/cmd.h   |  38 ++++++++--
 include/linux/io_uring_types.h |   5 ++
 io_uring/io_uring.c            |   2 +-
 io_uring/rsrc.c                | 127 +++++++++++++++++++++++----------
 io_uring/rsrc.h                |   5 --
 7 files changed, 146 insertions(+), 67 deletions(-)

-- 
2.52.0


