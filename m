Return-Path: <io-uring+bounces-12848-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oOJiEHjZw2lwuQQAu9opvQ
	(envelope-from <io-uring+bounces-12848-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 13:47:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7251C32520E
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 13:47:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 02CB2323A9A1
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 12:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 061343D1CAD;
	Wed, 25 Mar 2026 12:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oxCfiD5L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE6A3CF678
	for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 12:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774440499; cv=none; b=eowF2dYG55umQoYuiI2pjmu9nBcKH8yJFiauDDTUC4R1jwNkmbKla7stWblccgScaKgCFBXmkxmXu3dvrRdcJpu8+AWBlIQT0QfG4xOu5Yg8LZq0HvA8+FyHCpwygRKKR+TYehiEEy5NzdQz9Od3JmUV80mS/So2h6W1htgmpWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774440499; c=relaxed/simple;
	bh=+cMoiw6D/IN3IntDhoppbwqa4lsSaKo8wfRqQOkKgz4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t3MM1nxIOmSPHqRTg1Md1lEWgOVM05SFeRfclMc7sw3rJKFsawHnC8QsSCE21m9r4i8rYoT+SfbSPByZR3oUnne5wWMlExkI/1dgygFUqpJA59wm5mW03TfTznX2dgDYM6d5SMiobg4fP9L2O9OaN9YwjV/2U7QHdezrMQhSZFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oxCfiD5L; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-439bc14dcf4so642504f8f.1
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 05:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774440496; x=1775045296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zdYUqT0vzhqUOzwuw5MinoVNdtbVW6KIxEy0tW7Lyfs=;
        b=oxCfiD5Lpv7n+ZOtCaO5DUJR1M9E0ChfUX0Afr9QslGia9E7TFgFC3dMdEvveEKMK1
         FUipD/qgIIpMO1o9BRwSVznkT49iTxs4FRJiC+yBfAN4OXm6Q97zhbUPTMmYQ5eKe383
         SALugI9/fTD7PYiNHgXBAqdlr1DHY9SZCnUYlLI6vf/AJE5vrWl2oaRxmUyPU42siMVo
         gELgs1CFFKzHiU2A9n3CleurMb/kLuEdciWyzQPw2/j23kB2SIifAHKXIJl3sapl3vyZ
         iBWj8rrodcvj6skaUrKIXyK2n3Kz274Cs1TV8ihXz4qAof4WS1LyU7E4h4mdj+C8K6nt
         22Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774440496; x=1775045296;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zdYUqT0vzhqUOzwuw5MinoVNdtbVW6KIxEy0tW7Lyfs=;
        b=jInVILYCGTSrRyT3h4Zczc21emBu3LT8cy9seJiL8XGIztC+yjEkJpA3UyiQ7u2eNQ
         2XWQqovfD66O4uWzC+pIxgSbOHHz0GbGVbV8cnQbczU0IF+C76uIXMVBaEhzTeqnx/YD
         quTjS1/JUafshTXV3aRXxdzntpjzwZqI710AHihJxaIl+cB31voe8ssgzn2vsOFNcQbK
         +/H8dADwjGmybiPEEIEuw4C0oFMRYW8wloR/ZFrdjGvR9ItGBCsjCIGiIsYmNoJOfX35
         lbgBco13eGfdEwk+YB7G2QPHalnv9BcC4lq13yKVg++OMFBPY4HaccL9s+xcP1VQa9NT
         JW8g==
X-Gm-Message-State: AOJu0YznnY5rbTArpgT8e49IbWs3TQZQzyFafohlPZxsuJmHgLe/6iHX
	pUAlJSMxrM9G+O6wWTIklY3TsSbXOoGnGkyMx6H0uhNVblx/OOfyHC5lyPbY/g==
X-Gm-Gg: ATEYQzz8Li7TAlpGNFAW0CIaDhGZhaBV6RgBUYVFkmYkyn+RU1cEpfdnYEsTpLpwd26
	52SuQtQhBgHXfYTFwq+7wbs9f4R00DLwHezXHLZCjZU7BcwAofOIQ3kNDs2ajSKUfPcdXhhDa7p
	DzpWAfXqAjtv371cR9v3DLzKOLK5EgHhlp3nEBM4hF5xxqKSL38SkCaQ8YtAYBztPF11zPT6uio
	AfqcL4+eL4pvqUB6kTg7OuTd0JHGtc7DAWJuS5GlM77CJlDT3nzq7OuMF8D71uLgZMiXohIO8fy
	GZT5PIrCgAt3fTyzIRnRESoLuIovbEDUkCGBBG5X4aoMbvkHAX5Co9OwyjJHGoXbLSC5yFP/qCv
	oJsaHpuN9lTCtsshHerlvzglpNV/GH21VewqgDavpM0VgEsF8sdPGl9DXMHU1kPFMDbOrjP6j0p
	3KpttOzKjjpIRNCmAdRoesJqOWWs845AjrMLtMrcViBXC0lAJr3dYTGPD9hy4whxMDQ7jPN+PZB
	LubwNSSlQ==
X-Received: by 2002:a05:6000:98c:b0:43b:3c53:283d with SMTP id ffacd0b85a97d-43b805a1754mr10585982f8f.21.1774440496367;
        Wed, 25 Mar 2026 05:08:16 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644ae37dsm48618289f8f.2.2026.03.25.05.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 05:08:15 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 0/4] follow up zcrx fixes
Date: Wed, 25 Mar 2026 12:08:17 +0000
Message-ID: <cover.1774439286.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12848-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7251C32520E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Follow up fixes for the recent update flagged by review.

Pavel Begunkov (4):
  io_uring/zcrx: don't use mark0 for allocating xarray
  io_uring/zcrx: don't clear not allocated niovs
  io_uring/zcrx: use dma_len for chunk size calculation
  io_uring/zcrx: use correct mmap off constants

 io_uring/zcrx.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

-- 
2.53.0


