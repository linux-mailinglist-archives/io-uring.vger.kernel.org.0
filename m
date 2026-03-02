Return-Path: <io-uring+bounces-12503-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sD5cKFqMpWmoDgYAu9opvQ
	(envelope-from <io-uring+bounces-12503-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 14:10:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 534751D9849
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 14:10:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 78EFC3004DE0
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 13:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0EEC3E0C51;
	Mon,  2 Mar 2026 13:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jQZ0uZvs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CA23D7D9C
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 13:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457046; cv=none; b=A/23XHLM4T0NvbtS+chBwXT5x4b0s1BZ+W548DJ2DDIM/oWQT4XyWnJq/98y1nOb40kqZ6pJhWEgq/C4bcIdsF2pu/RfBYFew32YQgfzgrjmsRGL4IE058qt794M+G+Vvdu8nxm57UBLFN/F/ZIwLhTHeRtJBAubmKQMxxPuK9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457046; c=relaxed/simple;
	bh=HQeCA9ll7Hnms1y+lAIBT0BeSoJ4lDhcVb+V2a4QdC8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lCDAbZq1bxyhKvOnWVrJ+4o6N30hCH1GUoVQo16srUFHUdsDwRNqOQ4ZdY1KnDotHdHjNA9toIn7ob+8Sqv0sEAaCnoRN9bdb6jrmXVWP308r5RLsCLNRPrFaF12yysFcolyE1uavQ79goAm05GGrm3SvrguXuPt8i5sV0Sq+nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jQZ0uZvs; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48374014a77so53201475e9.3
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 05:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772457044; x=1773061844; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A/LYgq5ZDrMvoeC73igNAqocVGRnUbIFVLmv+elMVUI=;
        b=jQZ0uZvsCD9uzzLJsCSS+srIokriGApcKmg+hi9ehxcVMWZdKUQoz7+QV2SDqc9nn2
         U7qJ3rOkOskVvAZJhxftI+3qterZ5FO84Nsal0eFLykBrtGIc04427JNY/IJPy3Egyqj
         YQWScnmUguUl5MTHI1gw4+p5yZ1cXUGtH8eJb+zljCpLQ7rNSvr5LAWSoApc7kQFwlFA
         kffIrsSvwsBG38+HFmwJ5J+9OeMANnVL/Md0xQI9v9Ztkkt+4clCJv84HY1mjgSSPOzK
         z5uxtVa3p4uOXEhvCc5a9x5HLWUDeEzZOWYIaCCwk5ZbacLOGa0Q3qNq+CMzq7kYcffK
         xfBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772457044; x=1773061844;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/LYgq5ZDrMvoeC73igNAqocVGRnUbIFVLmv+elMVUI=;
        b=R0cj9dzF69l1WOj6g8/P19zURHaFmKp30d7FwRl5H390jt6M7Y5Ot6JuvL//bQHVpc
         qJ3qxZ9sjIti8gt+cb+gSG04UMWE2iLN9cOO1I1Dzzlb1q94GS8ilWvIrykjiSOlWs0c
         eRwVmcYZ5iu1ckP1drcAOdoRz4onGt4LULpChnAhX8FS/zr3Z03QzCA27tWHUuWz6ZgJ
         6C2jU48kzC6SObV/VcxQqwzp7aMavhgnAPKBcA47eCELTyvsBRTQvDDbxj3kjp3Bbo43
         dsQxAGTkAR2zQUq3qWBoXVKHs9UzfgBOufc3Sum1dxnyoITYqNpBUlrpqC3Gij0PK0dZ
         psJg==
X-Gm-Message-State: AOJu0YyOHCoQDVFE/lx/idjM52KOkQZH99MQlQuF00OgpkhuTYqzfAtF
	ltlCtONDUwEMZnWn973Mxk0JOgLMP/ucdrlk82/tB8OMeYfYg9DOUZng9SDOKg==
X-Gm-Gg: ATEYQzwV5Md1spfCgE2rgyAz/rjubM9ozlaL+yG7IxoMlEcidPUG+3Ju8GAsIIYFDlg
	27ntytieizZIjS9nANG23hwflhw18Cah8tW6QY0OaHAVY+9Z7iCO3H+ANFmykqByUQUpI15KvUc
	wKgBj0CQKy7IIO+u3ufg6YW7nUpNEuzRWQmsk6MmYqTrlPHVzHk+calacy6rSccALacYTgTb5pF
	9lsVOsUPD8MNwNNEdykjSVG+v7azO3BKNoG2enMmbD+4ZHrLo4oh81rYYabZtQf+EZV1FteyndW
	SjwnP2ZWEhrAp+5TBwxwwSA6ipV15EDKQMzgcSzgPr6NiY74Kk4gE2f9EXG5tkcFnKzBWicVvk4
	RE0eYNW1Z/IS001JP8v73q1bEpVQiI25WFdyEtrXqSeGxcBYtDIzPhgtalKThG+gGfwhNsIJMVQ
	UpvkAaoBmjUj3dwHh3c44nguLAsY2SkRXuN8rqUWMf1I7k2zdpPrxf2gqJFOPGfUV9jaX2JOfws
	F2qYxBtrA==
X-Received: by 2002:a05:600c:3b02:b0:483:6fe1:c057 with SMTP id 5b1f17b1804b1-483c9c02efcmr218728315e9.21.1772457043265;
        Mon, 02 Mar 2026 05:10:43 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:cad2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b346ccsm259935925e9.2.2026.03.02.05.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 05:10:42 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH v3 0/4] timeout immediate arg
Date: Mon,  2 Mar 2026 13:10:33 +0000
Message-ID: <cover.1772456786.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12503-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 534751D9849
X-Rspamd-Action: no action

Allow the user to pass the timeout value inside the SQE instead of
pointing to a timespec, people asked for it as it makes user space
simpler. More details description is in Patch 4.

v3: Enable the feature for the abs timeout mode
    Convert internal request handling to ktime
    Validate unused SQE fields for timeout reqs
v2: ditto for timeout updates

Pavel Begunkov (4):
  io_uring/timeout: check unused sqe fields
  io_uring/timeout: add helper for parsing user time
  io_uring/timeout: migrate reqs from ts64 to ktime
  io_uring/timeout: immediate timeout arg

 include/uapi/linux/io_uring.h |  5 +++
 io_uring/timeout.c            | 70 +++++++++++++++++++++++------------
 io_uring/timeout.h            |  2 +-
 3 files changed, 53 insertions(+), 24 deletions(-)

-- 
2.53.0


