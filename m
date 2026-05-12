Return-Path: <io-uring+bounces-13276-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KJ1aOpABA2rdzQEAu9opvQ
	(envelope-from <io-uring+bounces-13276-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 12:31:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3162A51E9BA
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 12:31:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7C6CD301C8A9
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 10:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D361349CD0;
	Tue, 12 May 2026 10:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oZyUw3mt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE15395AF5
	for <io-uring@vger.kernel.org>; Tue, 12 May 2026 10:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778581529; cv=none; b=LozqsNi7SjPvMC7Gyu1OL6lPPwBmI63jn6g1bCH8ZfWcGR6th1qmitGpSke3ZmmOJISZnWrtKQXLHQvt33zQ7V7qbizzYKl0Vg3khHDfvXLiW7aUlkPZq0shdp4goLRSTNwOM7GrqsotM2KGdT4F1+nmqEq3rq7Hi7imwq+0MhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778581529; c=relaxed/simple;
	bh=aX24LAztrHmynG61u3SAQQP3yV3M9517v3HJpsBkNrU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gkibtwkWkCtZ+1+mOwz6Tat3xdGzim3JEc7ytDzdpwKAXkSWD11JCJOGk4sggea1x6eT9wsT4f6BjWfJUEwjWF5Y/ur5dN/wymJuXMPX6qy35pnmuH4fKxLQjEhRWkvwyYRk0nt2zP9Zq8E62hGblBndWP+F5Bwiu4F31YLEqUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oZyUw3mt; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so59617635e9.2
        for <io-uring@vger.kernel.org>; Tue, 12 May 2026 03:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778581524; x=1779186324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q4vyxpBxCJTYcPxjgMNl98AO8CuI4Hu+7pj3X3JK0DU=;
        b=oZyUw3mtI5d2j06tBWbpYuYRIVlXptNuQV79hM1UfIFXVIdAt8rAPNOcEdiwbV2yNT
         te0R3eQKbgMI4Cu5TtU8wzwYoiwpO+p9mgmfIjRG3ZpF/CPd4dtwfz6Pd9lf5Snx7aVi
         oXrSnu7J9/TdES7mFI7JpfQcKdayz2O9QVGdcsCwJm190NCsEnxYd1u6fMgj2+GP/Kbf
         8ZeUXhoCtqq8HV176BW+M5LaHNCQTU+U+YifmAn0PMnA45qZ703M77dc4SxUe5DU8eBa
         ZSIWpEdCwsi27f8TCI6/TLW0KVxBt5ZPNQ7GV0QYZbLANrGeI9naDM7EHelkzsUv6bnl
         dFAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778581524; x=1779186324;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q4vyxpBxCJTYcPxjgMNl98AO8CuI4Hu+7pj3X3JK0DU=;
        b=aqS7je6CVo0P3s7N/w/typPE1pmAwHU16DknpiYLgofxae71FYBQMcy8fDmp2b5FdG
         tSFHoBlpR5631tQTbFGUWFGMiiZIltpdSPMePZSnmij9SjB7652xqkJg9bodGv+bjKqN
         nTRVpHbSpuO2Vk9LnbsOBU8I5rnnMkJPraEL3z89IhN1jJ9Hi5B8BRuC53GPlspoIZWa
         OQYyZOPKPCRmGAmN84vrXe8LxiCOdalN4oWn7UHQ6iGDsZ0yMRHlPNdTSIxA6lfPE+yB
         cLFLfjdxzDDDzTTJvUX9x6ungAO/REIDcpOOfUp/x78rJ+wWESP3mOWu6a7g+Z56/+Cl
         wXfw==
X-Gm-Message-State: AOJu0YwIi7ZCHLj6svOScxihNDcjOo3SbGepr1EnA8gj5eojTNx0toZT
	ea49YPP+6FmDubU2yAPrPa/QcevzzKC2Iao5U822r8MlIhQGpzVJicXZlXhHdQ==
X-Gm-Gg: Acq92OFc55Z+ePoswYwKhkEgOlZBEVP9+G4lP+e3sB5Hqp/zQyZH3dvQsYOSWfbZv16
	ARcqjTDRICkbY9P1C1NfdOkTpqwbj6zaUfbX2aXaFd4ILMXAJveBNTSpexAXIuMQ7wDGA/VWVkT
	vR48HI1+DNGLfkZGYtLuC60b6agNiPdREzepm1Y8kvxXIbGVbUrRdPDLR4glxj6myt83cgI3vgb
	/EyvS1chkIRGCKGjK0ChZo26DoYCjkubJfdFkhYMQOVe+XQ62PMQNLbgt/yfPrOnlVKSFApSdQO
	bKL3ER+cCxOg8fpsqWMTARIgdy/i1qNFLiMnu485QYuVNhv7Z4DQGiZnrYOs6P6mLS7K2WMB1Bu
	BLaAq0MmcgAPyKx3+bxCeTVtRwWs39sBVWNXXa4VVf367yoKuukQwHKiHFKe+7jLEIGvxdrtMSy
	9KMOm/kYsFBrvcLHwa5/TCrmW+Xi8H0bBStgku0I8NrzStuKP7MrH1UpKoIWN6gyIeUDkxBfr3r
	LtbkoNaRQ==
X-Received: by 2002:a05:600c:6299:b0:489:1c32:210d with SMTP id 5b1f17b1804b1-48e706f120fmr222953705e9.15.1778581524196;
        Tue, 12 May 2026 03:25:24 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:8c90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e9052c9fesm74352255e9.1.2026.05.12.03.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 03:25:23 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [RFC 0/6] dynamic area addition
Date: Tue, 12 May 2026 11:25:00 +0100
Message-ID: <cover.1778581283.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3162A51E9BA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-13276-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Currently, the user needs to give memory for the data upfront
when registering a zcrx instance, but it's not always easy to
predict for the user how much it will need. This series adds
a way to add more memory / areas at runtime.

Pavel Begunkov (6):
  io_uring/zcrx: remove extra ifq close
  io_uring/zcrx: move freelist lock to struct zcrx
  io_uring/zcrx: store area pointers in an array
  io_uring/zcrx: don't pass ifq_reg for for area creation
  io_uring/zcrx: split append from area creation
  io_uring/zcrx: add dynamic area creation

 include/uapi/linux/io_uring/zcrx.h |   7 +
 io_uring/zcrx.c                    | 203 ++++++++++++++++++++++-------
 io_uring/zcrx.h                    |   7 +-
 3 files changed, 168 insertions(+), 49 deletions(-)

-- 
2.53.0


