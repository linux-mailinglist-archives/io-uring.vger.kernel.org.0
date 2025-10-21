Return-Path: <io-uring+bounces-10087-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCACABF8B70
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 22:29:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2978A40415B
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 20:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5123327F163;
	Tue, 21 Oct 2025 20:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="opeycQED"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9011C36B
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 20:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761078589; cv=none; b=nMCl57Zcqj+4cbYPZuyhnc8r4rcOzj93M1PKpmWO8lKsUwzgzXMut/QDGScghkbQz0HDPVWg4Gx+njaPMzkWiGqQCzkjXjWHa29mT7jUrsgDD1i0qb3bpwZEMf4qeMT3LNMtjbDhLkjVEJ/cofW/JAhRrVa9xqbZDUUj4pTCFxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761078589; c=relaxed/simple;
	bh=3RKfiQ7HQ+Ry+dDMPsxPz4pCXEPKDhuDMhaPEPx+pCk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z29oGQZv/wFGaMNzUvXFmSRLSUQFGucg3w43jky/3pwf47dwPO9893VwvTebrxDNh/a8+cHcL0raEslB8Icv26ateRUdpVJWZTCazMR6orf8H92YT2mSfkihv6xBdDHSBctKcH9fW17LJPp5ADVldf4lCbiiM8Yic0hHZ9GoaLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=opeycQED; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-64e84414cfbso2693274eaf.1
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 13:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761078587; x=1761683387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=poUGxYIjxDLWE9ICi3U7DjsMI96MoayyxctFhopL1GY=;
        b=opeycQEDqw8ebMrtxGHVvaXJgJbsa6ZNWnsbMCAdTB7E5MJliHrdPCWjYpQtu2+Tf+
         hV93QF4R8D7tg+q7TQuwbUmbXKyM3T9/+i0Vii2war48fKzTffVYTerY0KT3nsvJLmPB
         5+ZhQaROIzfJfEiM3klViyx2mjASIN9YT9DwgFHKObcFBDlgdmDiaTHXH+LE5/Y2C907
         IJVasz0N4JTqFIYw63GSV/Cy08peY14RboeSy4MPzqoGoylTDJn9nuZuhGf1H2z6MItT
         WllkA/6BWGkZrxCBuh4h1qt7WmJX4HXFdX1/jhgYjMdV49G7WZCLqLo+DAIrhSVt+Fso
         2ztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761078587; x=1761683387;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=poUGxYIjxDLWE9ICi3U7DjsMI96MoayyxctFhopL1GY=;
        b=fsvB2B6gZVf4idr/0PrP+FMAp6Uh6lA+9g1nsxjJ64g0rmEDWgM69DQYIKUokMH3FS
         oDzClMRIb5sqAp57S+WMJ0xftA5yCo9qjlPI1PSRKgQlXAB54pwhTrw2rrJP1WRf2VQx
         u1Ll/Gvt5dMvN7yis7DeFp7C0F8DmBaV9zVF/BpqA3kvFGluoQNQenORaiRiXZsm41jU
         /5VIRQPhJuIWuAdn5hopRW01d3FHqejxnWcLOfUTdn9gK6QTCsAbb6TJLKgld7Po7J37
         gAjnXtLPmWt1WB9kl8DBOD5H16FAAQoIHjG4fqugQg14u9ja9BS8V3dnVhbkKKO/d7os
         LmPw==
X-Gm-Message-State: AOJu0YyS5lvC7mlYDSYulVsAmJtrAx63HSytI2vTwtPhadiIuq59cg0b
	ttl2fbk7kMtcpDIiag95FiqB3FN17Oslb1Y9lgF9xiJBbr3JDJiHtx60PNKIoe21WKoNofpPmfU
	w4HRN
X-Gm-Gg: ASbGncsFUQlSf5I1Kn9U0gUA1cvVJP3Lt03SiEr+bpfx8k3c2hbZ1SxEavwHYeFhXbU
	mkkfVbFoN+hBK+9BcRvti1yKHrInOE5vSJzCECSScLBZPco+PPz9ElARAb2pv8VSG2a3g3U73+9
	RIBDfht5v/8ZUWFUrBXDNesq0lt39X6gX4c351jWmkfdPIdvTMVhHKYvi+j1vOtsP4/TfZY3XTJ
	N4XwcxF567lC3YIE2O5iprlgli8I2arbqjj9eyE6XaisdVn8adSHZqFRyyW0+DXHOk/ZB93LU6K
	5jU8KjCmYbpSZ5r8hT7OdpXvdHjD/xZ+pPXdfjtt7I6eOR2Pig/DvHdUEDOf85wExBi3h/iC5Sl
	zIPYShAlDByIWtC7rSMSvOz9W+mO9L76uovdZkTJ+NVPW721jkDFV1mca0vFUQUhX6/Xd+yvm
X-Google-Smtp-Source: AGHT+IGiU7S//2XSxp1uOjSndVStRByroVEosPr96HKaMXGb4yAHc3fkXcg5pK97vhsVlnohBOrRsA==
X-Received: by 2002:a05:6808:3a19:b0:43f:1c66:bbab with SMTP id 5614622812f47-443a3153ce3mr7489170b6e.47.1761078586740;
        Tue, 21 Oct 2025 13:29:46 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:1::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-651eb5e3256sm1408738eaf.14.2025.10.21.13.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 13:29:46 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH 1/1] io_uring zcrx: add MAINTAINERS entry
Date: Tue, 21 Oct 2025 13:29:44 -0700
Message-ID: <20251021202944.3877502-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Same as [1] but also with netdev@ as an additional mailing list.
io_uring zero copy receive is of particular interest to netdev
participants too, given its tight integration to netdev core.

With this updated entry, folks running get_maintainer.pl on patches that
touch io_uring/zcrx.* will know to send it to netdev@ as well.

Note that this doesn't mean all changes require explicit acks from
netdev; this is purely for wider visibility and for other contributors
to know where to send patches.

[1]: https://lore.kernel.org/io-uring/989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com/

Signed-off-by: David Wei <dw@davidwei.uk>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 545a4776795e..067eebbff09b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13111,6 +13111,15 @@ F:	include/uapi/linux/io_uring.h
 F:	include/uapi/linux/io_uring/
 F:	io_uring/
 
+IO_URING ZCRX
+M:	Pavel Begunkov <asml.silence@gmail.com>
+L:	io-uring@vger.kernel.org
+L:	netdev@vger.kernel.org
+T:	git https://github.com/isilence/linux.git zcrx/for-next
+T:	git git://git.kernel.dk/linux-block
+S:	Maintained
+F:	io_uring/zcrx.*
+
 IPMI SUBSYSTEM
 M:	Corey Minyard <corey@minyard.net>
 L:	openipmi-developer@lists.sourceforge.net (moderated for non-subscribers)
-- 
2.47.3


