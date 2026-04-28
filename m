Return-Path: <io-uring+bounces-13159-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YMI8Bazm8GmoagEAu9opvQ
	(envelope-from <io-uring+bounces-13159-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 18:56:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 13D9E489700
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 18:56:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 376EC301E3EC
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 15:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F16603BED42;
	Tue, 28 Apr 2026 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="bNvnucjG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A975A3BED23
	for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 15:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391162; cv=none; b=uF50pM2LMyPNZmRu8y0AvNBZu7KYyb/4zCmQZdVKZ3R3Ewc7g7jbG+pzQll383aPFb1QwxggQax1wqlZrdm/QioRnfOvLDnn4t8rLOhuCfodTbDHuLRIwJ/lI4sJ7TPoVWCOMf5QnGfPuABEF6VXhRHkenjP/xFbooJ4CozwJC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391162; c=relaxed/simple;
	bh=bhZZN3BUYfL4OB6JiLdITFU1wKylylJAJ7GT/gLaVG8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VYJJXO8PTBlTsTTn6k2qOQr9CWXWDg7TR/YOAe9XfhKQ/vUfhi/IE3MJAhZCTTP5P72/k700Ul66pXTJ3VC+yxIxiBcOCOmp/f0awE6sjjNKucetkEheYYULrNpxUsUamegIHGD9Jy+JC9+HzeJ20SW0rhai1eTk0FTSXDfGdX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=bNvnucjG; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-4042905015cso6819701fac.0
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 08:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777391159; x=1777995959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=VmhUYAXPV6m/5vigUD7uQPXJyrepD3MRe/n1QgWegHU=;
        b=bNvnucjGxEwXptcfq9K1MKVyagllaR+4JOcsSS9YyhU/1iqMYd3fOEnywkqNBmo4zM
         vHglABMc+3gFzWkMgi+RL/yMaqKeaW/sZgRoCvdBDuc3pEzgCGaOjfaWf3niyBvLCtdM
         yxnIu54qsPR4OEWLqVGy3Ww8vNeWWaEfLbJszfKQE6xHDj5VfON9enxJRa1+3HwQPe3X
         DFF/L3Fzk0DvL4R3zRyOjbgvg77+q1/YYeIvQltqqWpNBRa3Bnr10OVDdeY/Lnez0ZCg
         uyug4qfxB+yZa6VS5KOpAr7CxL0Qf7KOyA0HUrPz72E+NKgKuYUg4hWHldXxCP9lgG4/
         fH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391159; x=1777995959;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VmhUYAXPV6m/5vigUD7uQPXJyrepD3MRe/n1QgWegHU=;
        b=k6rfZsJuVNnXBnXAL+SKVJUey5JDO+q0zsUYXhscyrybflyUmPV0u0wNp+GViThmjI
         5+2H9XqS78qgUb5EFG1GisCvD2bEPdyLwp0cxMQHTgfpmImBOMRpFZOs74REh/O8KyWx
         P1qJGkaqOhM0hl+slvppHa++jmZG0Gea0PTAgBUwJen+jbcY+Nh5ltTyVTAavm4AeuQg
         OvznCRvssDn4utvvxVlRoHmDNxC0T8JmppXSPlO0+R1ibt3kazB6TJiaFFYE3Qyz0cWM
         xfB0rRKmQUaCij5tDhx6nTM8S0JcCibl2B159qa3PXGL+xr30S1RGUvDQ4dBlUs79P2G
         qKYw==
X-Gm-Message-State: AOJu0YyGkW+AwFnfO6c4C/8GgmGppoun4E/5YdLnjw2cHwRFCgqJ1S5P
	iV7Tl2sxxAj7OUnPxOS5YnkgZUqiPK8ehnVe/a2PJLtAbgn+xUmj+2N4Q2nDHtSloQzmeu+fsuO
	EaaZ7ykg=
X-Gm-Gg: AeBDieuN3pzX6RGsGJqQ7KZVD9bv8hgf8fBXzQo+4xIuaUbTNWXW9ud3oty6QsWLYtt
	Nkuj8LIVReIDrYBeuFGdcz6fZkM02DXJTAtjR4+l/auIZAbHeDXGKk9jwpL/717HxwKmE3mPisT
	LXeT0d119UvY2E4kOL0hyFi3Fi/PdZH1eHhvhLrZ3ovZAPbdpxyYO+lMieSyddgQGDJ4Bxf1Smm
	aF2JX4LSVbU5hb+hxdLZdBnBbbJnP34BqwUjmEnKjFkmFhFcrao08mBblSifeMr8iJh7S8Sjqdd
	exUJL/J14dYzz9iQuf/aoriCVzkkTcMM+GDUVCGMc0GO8z1aXuZp5p91IPSy/OrpVpU/cOW5TDz
	uZpvvCGGKMRGt5VZUjTBOnsJ0n1xW967cuT8pskMNu2jxdTVjB6JkvrbrNKelR9RjA/GJgoGmxh
	03lH/gUN/sUITXAqI2+9KB31WshvtQk+GWDuHx8nAwGuJsv2OEJub9WA+w5It7sZlOZ0RBcX0C4
	6EFpZ2cUBFZknJX
X-Received: by 2002:a05:6870:3325:b0:42f:8c4:bd3 with SMTP id 586e51a60fabf-433f3a127cfmr2106495fac.23.1777391159222;
        Tue, 28 Apr 2026 08:45:59 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-433effdc79bsm2109567fac.18.2026.04.28.08.45.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:45:58 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] kbuf fixes
Date: Tue, 28 Apr 2026 09:44:48 -0600
Message-ID: <20260428154557.2150818-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 13D9E489700
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-13159-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]

Hi,

First patch just kills an unused member in struct io_buffer_list,
and then patch 2 fixes up an issue with incrementally consumed
buffers where the application cannot inform the kernel of how much
space should be left before moving on to the next buffer. This can
cause spurious -EFAULT with multishot recvmsg, when the current
buffer falls below the limit needed for the headers.

-- 
Jens Axboe


