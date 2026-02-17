Return-Path: <io-uring+bounces-12277-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uJjTDf9JlGn0BwIAu9opvQ
	(envelope-from <io-uring+bounces-12277-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:59:11 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC8814B12A
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 451913029A6A
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 10:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D54F832BF46;
	Tue, 17 Feb 2026 10:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jV0W5xo5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832D832B993
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 10:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771325943; cv=none; b=Qu442E3SthyLPfiVw/mlhQ63IDzg4gBGaPR+eY2hALOikkSRW64HNSVW+PgEcB+gMhWNtxqXKrYni0bVPjy4LjsR/U1gK4zfAMh29e5xoM99OV+XnA3Ue9kzCSIjCNNV0+MJzFPDS0MfpWwAgvXvLELKJm1GlX73TJxifyU6Xyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771325943; c=relaxed/simple;
	bh=dxkUEdW59WpbrdfCocb7yEpG8N+Jc3txoaD3rPLr/hA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a19OjO+lSo8e0Sesjpk5jHhYRax1oQFiq36mQmg0/dXFyetY8hiz+QNDAgYkTmvgI1gDOWDDYdL/UIyM8hARsNBZo/JvPwinUA4oVqAJb1sA2OcU73igFkWE0VQToWj2B+wgGP8A07CGGugLyUbConX7hmnRYziFvxnBuodJAZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jV0W5xo5; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48379a42f76so24928385e9.0
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 02:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771325940; x=1771930740; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pqd/qSNd5cJh+qVEsxJycYcGDG/6Gev0XJ7NgtBdi6w=;
        b=jV0W5xo5TUjK0Tpfg3f6zkPpqAVfKjj4DwXEaw0xWZGZbjLbkmZcI8RGl7PJPwAZh8
         6T/4JEOUoNUkaiVEFFW+78daVT20yJFwnBMdDOrbPGKPH/NBngHoVY+66phvQ4Yq7eFh
         lasXHJYVssAtCEzB3ujqGQkMMFwABrg7PuToSELxE1MlZg2qrGj+ASgUyXk99Gmq1ano
         p3QkB60yXAMvRiKn3itpjXYPs45Hzk4z6Bekfs+OR5qOlKvwjTt5d12XvJ+0xiEZvj5W
         MNWtjSBFelLl76gVB+VooDlPwfvUm3H5ig44QgUu3/9x+zTAHYfUjJ6hnPISpGZ2Icnv
         ZnGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771325940; x=1771930740;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqd/qSNd5cJh+qVEsxJycYcGDG/6Gev0XJ7NgtBdi6w=;
        b=gC3uqgh817eosKr1oPGnl44gU6AVvJ/zsT3Lg393+s8ypMxkROI3Gx4x15nuN/tiDJ
         SuUUPzXx2VFKrRRNv+43cgl4OzEuMdy94714zzifw5QFYi3O5hgtC+ApDyJiuaXjzPH8
         HnSkNDjLlhjnfHAhv1PkSISoOtxBcIHT2XSwXdw650r4kL/7mPznLwzujF4RRbz5uei7
         MLHxXMuWkh630CJRukNuCjtMZ4f1Sd9hA/71nYowsaRkKhyx+KjkHHh4s5zDy6/Vuwc9
         HXN+cuZw/5AjL07bPIMt8chclhNGv19Oj929gF0ItSClqbvgutmMlmmPS1mFUBB1aMWY
         4ZHQ==
X-Gm-Message-State: AOJu0YwyvwkNO91dD06CmRTxeJ0NiNKGWZKWFMllDKu14eGgySCwKhUN
	C5j2QUSLZ2WcmfkZE7a1Zv5UiA19abSsMcme0IYc/i7rH7oDNfjoFVUCUIh8gg==
X-Gm-Gg: AZuq6aKnCn8VPdEXE2ufTK0dUtVi/GApFZR9V9MThxoO28qb8OfZg7dPM8GruUfu5st
	DjXtHPoJxU8sxNaWpeMA74b4IDAGvoOyECS2eW6u3IwPbyYa9/0PZKq1uPcOdg7mSg02uNJGAiH
	1PwrLGUoDEfUKCHnheuhjhEfOR8gA+TBTziBUdEhR7lXM7LPMqQMWzItdW+ZpG3x4OylJof+5RV
	2tPOnCGISnRJzbLwYWzF+jUkr9WCIeJhDnc9OEfzOWK55KssxPz2RqIiW6CVAoGP7Y3gV22kqHE
	Q/5CFSKDvhB+BB1K8OcGEtWablZOncBLZlfPXSz0J5AUUMF2jnZ+13RciOfG/vya+onR5Kw864k
	X85X8vrXWXOGdijiO19E/WSFglh+9J1uOU4qtdp7trbpZOkzd1Y0ekX8LaUF00+ObyqcGHCpzPj
	/8DDU737nA2rG8wvBeYBkRIhFqs5a/ReXlU1ebGRQ8smE+Ap5Mdodc7c72im1anRgimsxSZ3I1L
	TO0DQnlF7QFfPs32ZqRBGzdJjf3oJ3FXKdoNtHd
X-Received: by 2002:a05:600c:609a:b0:483:7020:864 with SMTP id 5b1f17b1804b1-48379c178eamr193526775e9.25.1771325940268;
        Tue, 17 Feb 2026 02:59:00 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48370a78c89sm327759395e9.5.2026.02.17.02.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 02:58:59 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [RFC io_uring review-only 0/4] zcrx mapping cleanups and device-less instances
Date: Tue, 17 Feb 2026 10:58:51 +0000
Message-ID: <cover.1771325198.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12277-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: EAC8814B12A
X-Rspamd-Action: no action

First two patches move user memory DMA map creation to an earlier point,
which makes it more uniform among different memory types and easier to
manage. Patches 3 and 4 introduce device-less zcrx instances
for testing purposes, which always copy data via the fallback path.

note, based on two other recently sent patches splitting out a uapi
file and defining constants in zcrx.h

Pavel Begunkov (4):
  io_uring/zcrx: fully clean area on error in io_import_umem()
  io_uring/zcrx: always dma map in advance
  io_uring/zcrx: extract netdev+area init into a helper
  io_uring/zcrx: implement device-less mode for zcrx

 include/uapi/linux/io_uring/zcrx.h |   9 +-
 io_uring/zcrx.c                    | 145 ++++++++++++++++-------------
 io_uring/zcrx.h                    |   2 +-
 3 files changed, 90 insertions(+), 66 deletions(-)

-- 
2.52.0


