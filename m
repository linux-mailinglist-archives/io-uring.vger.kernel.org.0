Return-Path: <io-uring+bounces-13060-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uLtGJ05B4WmaqgAAu9opvQ
	(envelope-from <io-uring+bounces-13060-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 22:06:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A856141474C
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 22:06:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B71A130300EF
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 20:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5232239F19C;
	Thu, 16 Apr 2026 20:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="E1Oy0Xa9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A77A36C9EE
	for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 20:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776369992; cv=none; b=eV7sb6clpVPMDxI6BtpOySwAN1f0NefbALQxemmo7t4lgVO7MESXP/ApJot4L52zVd2LA/nqD0Vq/JnaUH+Un2c17IJbow3fPfzcCQ0GYoo8H1o6M2OH63mP50rVrgXuLXGykXFaZFqWkqpNbZ597W3NZiBuuJ1KMbCnDQF0nTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776369992; c=relaxed/simple;
	bh=iyYm5h+6dLApz3uTctrHk3M2WP1bTOzZLtX+hjH3RwY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=uxJiB91vglnSy994ezR9xrDDy9pt5/Bk6D+ZyzN8JBSKzwVEVOAlwdSHRl5JTLjDDi7lPfvPHo2NZNQ/rS15mbrYitBWjgVjkOSmx4/sVkdmcWWcis74RGyVRT0czyDK7Qr7eKn8gUMPL3DR+PExVD32t8tCyIEGnkc3K6k/L1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=E1Oy0Xa9; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-46fb6d65c28so2980848b6e.0
        for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 13:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776369984; x=1776974784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=1g1sPkXfKEAxTMUEweiuJtLkzeA82pGz3IzihXCLv4U=;
        b=E1Oy0Xa9Vn8gEjUnlz3OxP/hf/vriJGGgzAetHz0I6VA1/SYKrk2Hsm6KZsw0kxoEp
         cmQKVX7xZfWOkYlLicMR0hPraTA7M6/y/IujQPJnEovq5rCi+mRB+iS51rw2JW+fMv5V
         OJBbYqWiBkTldsMv3kAPXZDWtIX2xyv3RrPPVoJObkbS8SciQdUVjpab4QTE7cPwMJYT
         Jpv9H41anGqLDrsZ1tGxoLsnx5Es8BMIq0UwRlBszel+2ZSNTUkbcl+QQMc77EalZXQe
         tceGHpvVkZCubJ+jtha3Z3FJTTo2yUV2T0wCc4Viq7PS0Jy50pTHTuE+wLzft7MdcBTF
         8V8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776369984; x=1776974784;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1g1sPkXfKEAxTMUEweiuJtLkzeA82pGz3IzihXCLv4U=;
        b=d60jGrVZb1KiBClOqClwfu95ZJoLxonmqX1Yg44yCKghMakzLf2LSTS+calohxJCY1
         imkdzTA3kDUmNsBZ+0jnq5NES6O/stOZvzBh9ltW6EThODpwsP5qPVhcEFXGdur1H7Mo
         IOo+twHRpoifPIF0vxlpGaf1+1PVNhBfNXQgB3FyqfgnN7zK4XZwHQ5pwQcFo0dahN1N
         BgzwD+gTUyku3RksQsGdQh0AgmK8KKFxWkpEp2xzvm1KwZ89X9RBCgUqsXBk0kgg1Lw+
         eSmR4wTFmxxxUzcIyDFDV+qrTFnZJEq+bU1Ttqi5hTKNnlgxX6DSMwFE9Wb4KLlvCmz+
         EGmQ==
X-Gm-Message-State: AOJu0Yx5nSda3o4Am9m76yCgozN1mj3UTN2dmg0LDuvpIrL7YV4TSvCP
	kR0qvT4mntGgO232IlT/f9SJnuJ4WIGi3AKQ4KgtgUngP+ZU8hFtrdDF/L1aSL4wYsN+BTl34C5
	hztWY
X-Gm-Gg: AeBDiesKjBS4bQYsDcIB2qR6yCfNU2hPlXVB2a+Pv6JX2f2188DoYQEkzl8yaalCICN
	Zsw5F9FBdoh85N27QMYe+FxjPflOzHnXmxXuQve3sKHxM1d7z2NN3r/mWL0NapaGIjcLGl6NvuB
	wS/iZDMTtodNnH+grWX3GUd1teTYZUTA/s3y79ebW/pmV1xq6DErS7HiX7zyama0ur7MlvtdLC4
	bniGqWN34dI5nV3k2aHmVcpODc/XWclMoR02SqlSmBLdy543N1DVATWXBfJTsD99S40RRan+Kpp
	P9Or4ABjgzPwdU7wZvj4KGYjzdEbNO67Eqbn/9pQrhoXgEFtyC4W80Ohnhh1xb/WWpbg70QJMMe
	jrHZYTIAgQ5QcP5BrYZz39wlif6CrGotIx4LlcoN4XJH2E0cV5xgMh031i5o1GqtylC0/k+D/rq
	UAKeU+aQDmDUmY2sFA2X3vVzQErFoJm5bJ6fmpejcWiIUKjI0dOb0x9dDredmkluZXItLa6wRHE
	y32yw==
X-Received: by 2002:a54:438a:0:b0:466:f25d:3281 with SMTP id 5614622812f47-4799a2b05abmr190152b6e.29.1776369984494;
        Thu, 16 Apr 2026 13:06:24 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47997f9abd8sm576352b6e.15.2026.04.16.13.06.23
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 13:06:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCH 0/2] Misc minor tctx fixes
Date: Thu, 16 Apr 2026 14:05:51 -0600
Message-ID: <20260416200622.831635-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-13060-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A856141474C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi,

Just two small fixes for issues introduced in this merge window.

-- 
Jens Axboe


