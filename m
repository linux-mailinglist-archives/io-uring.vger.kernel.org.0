Return-Path: <io-uring+bounces-13208-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mF0lJoQM92ktbgIAu9opvQ
	(envelope-from <io-uring+bounces-13208-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 10:51:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC494B4F3F
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 10:51:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 479B3300823B
	for <lists+io-uring@lfdr.de>; Sun,  3 May 2026 08:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1201F2F6904;
	Sun,  3 May 2026 08:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="vAb5So3Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCA22264A9
	for <io-uring@vger.kernel.org>; Sun,  3 May 2026 08:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777798273; cv=none; b=b1+qH6jZ+EQ1YqFdpeQbhzVOqkKtC7KF74D0GpRZP8Ndd3JUGj4rj9eIKI5cXseD5GLU0WmL3QjeKg3a4huTdhiMdjXVo6ALNNzQXH9oo7e8FwZEU9s9smx6+NZTvOgr6kPPHr+i73Hmv9Yg4emD+dL7NkCEzdMc0kswbX/toAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777798273; c=relaxed/simple;
	bh=fPHKQYNdZo00tTrxT+9rg/5OaWyWo2NnrgtAoUea1IA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tC5zcW433MiqfNEZytrxw9HbCsg7yn7Q53TE8WC0DMG696cCJzdkmw+e74NUOzzfJ5Q9BFc3R7eR2bQjZk6YqtpmDDxp2z/JiKf7hY72TOnj9rTIG670ASx7tFeU/+XzmYaQ8b/c1Av1R+xdUFCJ9Kgwe64F7Z9Wm/8Iof03I1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=vAb5So3Q; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65c4152313fso4344981a12.1
        for <io-uring@vger.kernel.org>; Sun, 03 May 2026 01:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777798268; x=1778403068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N+S1K9D2mcBINOkojfaHJOsrVSLjVbIvJht7zvxYQyY=;
        b=vAb5So3QJfv/c9Xx8YkT9vGb1C0ExPR7T9y7B7T5yxiIlTIIDmpeW9QieMhnENlHUx
         +XFMgcLa9rAPVthiDPg+k7H1KrmMJOixvA1xE19mlMCyIrwB+Z3/5tYxn88Ti0Hq1ePC
         ZX+KhqRpmMQS2BKBUQvP/IXjg1g739l3uj03QJbVDkoV3mjzaOn+qTa/w0HRA9K4r2h0
         t2K+VFAyP6WTaUL5trXilRhCiorqg18hUg6SC45ukNCg6oDxOYFj7LNJcadGNexvT0CZ
         pYM+7tBqVKj8NM/bQ4Y//GUB6Xrk1oukhUuLhxUbK2WGlS3w9hUtvkC/Za/7qSFbSu5v
         f35g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777798268; x=1778403068;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N+S1K9D2mcBINOkojfaHJOsrVSLjVbIvJht7zvxYQyY=;
        b=LzZqc3RSxe6XvDbIdCFcyvFKkvg2kmhRMFWve+9CBxXfZ0ZGqy+3OgwQMlaUFKpwdc
         UCW9ZujwpWgUiGWaai+L5bP9koUCnxwQPZGJtvgykTCDHWKftrGs4MNdIt1tULus40RR
         ccS/bCz0A33Hp/pTA2Eo/OOsxF9oIhBUWXkG5l2ASgKQXo2cFG6wyjLEDE2HLC25+HHx
         sYTDQ4TwH7x1PY89udiqAcgU8PA20G7lPoOqFNdIl5D81lOUjAtWMxELxJxYTZeYv/qA
         btFn67rl1Tw04iepeQzqlOWc63zrccCvWU60w8ihLC7GCSJDVosM0ZfBZ18n2qYNB3nN
         Abdw==
X-Gm-Message-State: AOJu0YyLJkrCXw5ATNu39gv3o0U8GghswtB6uNzvnfaEEOchLs5svDqI
	t63CobS6IG5LNiSeJUczYugeiDGgzWWVPz6ulOBMaSETiUBmjhAQYQmSqi51oX/cf5Pt4vS9aE5
	efYOazUZrIA==
X-Gm-Gg: AeBDievH6mmoIYZenyJ7cIehqE0L/eWTOeRaa5QdXDnsI9ZFOuGQ3gOS+VNMV8yLj7S
	NDMuv3qrUT8TwxAlZLTW5cAxCFNepzTu8DwpQRDildY9ZAu/mclRGEO/7T14do9ziiteWuLoubg
	NOUUnhCCCV/+2YJCnz0Yxxzbc5k90aJziVSzIl9fUz0FBQ3BA6+R1GHbQTBLGVuwPbaFkuXIwUP
	vy+tB1QgJOCvEcFi1kf/yYTURMi7FNPq/5ufjeMuOMh00gv16tZAubb+xZuprAP8vE0dywqrA8a
	kuz0Plg88ftXp0r0isjsSnnFJIiiXNosPfR85Q/V3WqW0F2CRj56UjGA2jfcJF+3WpYSITspUrl
	MYNE+TXb57M5ZkwfICw/yyCr/cEM9gxtraB0UQtzucDHObpwla446D19DsZrBQDSjzhUF01CO4l
	Qx7e/S6VUJbyJ77nQce/9qp6CNaxkJB/TvBp+zhEqbhoeLVUk+j9vUpMIVKLmCYGUrbujLCAvlG
	CoKdaI6Ng==
X-Received: by 2002:aa7:c60e:0:b0:679:1f4f:9d1a with SMTP id 4fb4d7f45d1cf-67c17e267afmr1798999a12.3.1777798268034;
        Sun, 03 May 2026 01:51:08 -0700 (PDT)
Received: from m2max ([77.241.229.232])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67b85e292c2sm2368936a12.1.2026.05.03.01.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 01:51:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org
Subject: [PATCHSET 0/5] io_uring related epoll cleanups
Date: Sun,  3 May 2026 02:49:11 -0600
Message-ID: <20260503085101.112698-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EAC494B4F3F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13208-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]

Hi,

One of the nastier things about epoll is how it allows nesting contexts
inside each other, leading to the necessity of loop detection and the
issues that have come with that.

I don't believe there's any reason to support nesting on the io_uring
side, in fact IORING_OP_EPOLL_CTL is a historical mistake, imho. But
let's at least try and contain the damage and disallow nested contexts
from our side.

 fs/eventpoll.c            | 86 +++++++++++++++++++--------------------
 include/linux/eventpoll.h |  8 ++++
 io_uring/epoll.c          | 18 +++++++-
 3 files changed, 65 insertions(+), 47 deletions(-)

-- 
Jens Axboe


