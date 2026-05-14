Return-Path: <io-uring+bounces-13330-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oCmcCOzYBWoncQIAu9opvQ
	(envelope-from <io-uring+bounces-13330-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:15:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE5B542EA0
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D77013056D56
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 14:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5413C40242C;
	Thu, 14 May 2026 14:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="YQ7jTSZX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4D83E51F7
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 14:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778767710; cv=none; b=RRjffXnqWBNBzeJX6T7yKn+NrPNmPBbhUGyoyd+VVJgLT6WbigmKbEoub/c25TmbCgy8MsT+ApynaGkgPUouhJTU90SUGLWYpVea4/v0mZd8PZqfVDZZjT3WdBtn53yKetatjx0G0zITXnFLfu8l8j5I+nCJjj6oo0ejSRDHBwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778767710; c=relaxed/simple;
	bh=XQJFVEGXb8GG1McHakPa6lexp/lhSqp5SHuspFmBCmM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bt7vRSyqdwLENZAgEMIGBg00sTSbtB6zNxNpYfWbQRtASbOxuR+OWkSkytawlOaMJl+zJk92CwOOfcmk9SKYHW/c2fwmrY5NOJkr6AybKfpNnb0lPhyB8ePMeVztoEnAHJobS+1OQG8V9Gzxmpp8sbkMlOx22e19PP56xYq+bdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=YQ7jTSZX; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-47cbd445021so4915803b6e.1
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 07:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778767703; x=1779372503; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BTKy+6a8jb6C2QuCQKPqyXABjIOGBqK3hbY009ZwCN0=;
        b=YQ7jTSZXMVUTpnHo+HDO+3N/2KadDZN3qqgLRk3cZD0UR6/gBHzMObv0Ucitaak+Av
         +ixjdBF36SLh2ItKzjHMiwz5M0pHPn3N2fx9yRZKukp6KSRihIA2/3kuvgpPAxwuYloh
         sILTUDxrDGO5zreyqQqh7DgqJR4G8KoxGnod77mLWTq1gUL7p8b9no8LhTPWqJmaHg/a
         +yPUYucfIuF342wN4HoZb5g3Rt45kx+UD+I27Fl3tS0V2R3aBndV293TsBqfUytE5a+2
         XrpOBOQLzpGc9rUUJmM6Oh+Gx8VOmw9AnfE+kpc5yU8EIZen0Kzc30vBa2h87264MYpZ
         1KTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778767703; x=1779372503;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BTKy+6a8jb6C2QuCQKPqyXABjIOGBqK3hbY009ZwCN0=;
        b=o4JPKohrFMGqHpkZMfVgJFCnNm3V5+8DBWIXmaiSZYkKDZwrImO9kT9RI/CVR+bR6o
         J8B+zhE6KQIPlnmuYIfaAPPaRZvwbZ93XsEkIbgeG0Wd3L+3NuCwMBEKxltluo6tEuOn
         XBhIPi9hdpn52UyXooXVGfSGDMZY19lIZKhNnMup2VD7d24pegRJeVNfdW9v0B2vj179
         Ezo0lmyocEoWPyHs5bT25rxPgsXR1WfjTCGjFRuf0C+yaq1YcuCm3sqgQG7b2+yBnpXr
         leK5fGRgb0tDn0Tt8FFwL2YgiE/WuTZTaluSbg/5WYh7b7kQvO5BhZjrkA5K8EpqcUxb
         Hn+Q==
X-Gm-Message-State: AOJu0YwAjy3ZNKaiHRKIkHSp884tdlXhkxTaG2xrcL8QTWemZgmL7Ndc
	D3KuGLC+3NPouLBERy+bd4dJis+4cFqBYahxZVvKPmPfrDLfo7npESz7amX3LYT0HZoEyslFadg
	PGQ7t
X-Gm-Gg: Acq92OH3xAozjx4atX9DV4CvLeJ10HeGi0MiYQhDdK4cJ+lJTQHW+dqMCqWvS8cjPb6
	WC4OixeUQNoHleYuQje933jAY97nHVPTXjm0v52Y4h+ZJZkruMr+CfklvcOGCC9d2Y2V4oHRP7H
	a8MyVRJoN7RYPCzzEsu0VFzzShWVfUtN44WhLeu/GZOJxZ7lLTEjqu6FCKkMBNNLNGZCCstVfx8
	vd8TKxBDY//USiH4NajNdNk5p4JNMJvWBdEv6tpOlspG5IA/+A3N+NrEmV7r0JM0wO8L7fiQILE
	VMkZKN5xm9BXVwSywr4FUH7leUT/O+nY2eh7v8s3TSUEsQOMtuauSlV9sxZMwrIPc3p6yYdyx+a
	7CtwfuPpnw5AfmEh4rOlJmKM/+GD583gdK6L+Z+uAEuseShqfReSBlnG9/0qIdzW6tuoIM7O6ig
	MyrW1vAzBTIaS9wX8k2y8I3YDHOupDyJgzpSL/PX0sirrgWmjoTSRMavsMUAY9maKHBBM=
X-Received: by 2002:a05:6808:4f08:b0:471:f036:7926 with SMTP id 5614622812f47-482b2c73cd1mr4937708b6e.28.1778767702773;
        Thu, 14 May 2026 07:08:22 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-482d379f062sm1394956b6e.6.2026.05.14.07.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 07:08:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org
Subject: [PATCHSET v2 0/6] io_uring related epoll cleanups
Date: Thu, 14 May 2026 08:07:16 -0600
Message-ID: <20260514140817.623026-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1DE5B542EA0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13330-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action

Hi,

One of the nastier things about epoll is how it allows nesting contexts
inside each other, leading to the necessity of loop detection and the
issues that have come with that.

I don't believe there's any reason to support nesting on the io_uring
side, in fact IORING_OP_EPOLL_CTL is a historical mistake, imho. But
let's at least try and contain the damage and disallow nested contexts
from our side.

Changes since v1:
- Add patch renaming struct epoll_filefd to struct epoll_key

 fs/eventpoll.c            | 91 ++++++++++++++++++---------------------
 include/linux/eventpoll.h |  8 ++++
 io_uring/epoll.c          | 18 +++++++-
 3 files changed, 67 insertions(+), 50 deletions(-)

-- 
Jens Axboe


