Return-Path: <io-uring+bounces-13213-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KDvWL7UM92lTbgIAu9opvQ
	(envelope-from <io-uring+bounces-13213-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 10:52:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 280644B4F97
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 10:52:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C83D23016C9E
	for <lists+io-uring@lfdr.de>; Sun,  3 May 2026 08:51:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62D973AE194;
	Sun,  3 May 2026 08:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="YC7v/NT4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF0A368971
	for <io-uring@vger.kernel.org>; Sun,  3 May 2026 08:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777798288; cv=none; b=PnM66in4MbI1NZODsHyZ3HASK/ciwy8yNc79Ba2f+WLFx5YXcPH3LYSOKEVhurwzsMpHBRi69b+VEMM+H3xsasOoYK1e1hyrN6+HlbKy7MBbAqYyj9rAdWpKWQL+d6vF5CY86Mryh/MiTt95/2DH1te7sQq8Jy8VenvYDAAGyRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777798288; c=relaxed/simple;
	bh=wtbl+ixVRxR+AU4WuUKWwBgg4ITg6WDjpgJQf0rWEhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/i8RfuBMttGch5JkEkmMzSTcm1PhWQfehVnhDJVPxbJN5LdV2KqeZaxxbvrq3LE5cmCzflz01d/n8Pqn/pu+Ejgm0JlHRyopaFtSjmwqhWYGrs5oojv6rmeptORxPel5khfyDM/nCJoWsv4aENXgcxPUwfQKBowc+qTui+lwnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=YC7v/NT4; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-678a16429c6so3575231a12.1
        for <io-uring@vger.kernel.org>; Sun, 03 May 2026 01:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777798285; x=1778403085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6FlnQddOFsW56J1QVBKnB0QJtZtOojgEvtskF1QOQA=;
        b=YC7v/NT4MhCgD9KiF3GpdqQSTEH3HRm5XgllpV1te5aqLCX4GEuc64/JvlYwgbGkEZ
         HuAmpiliWyejNzSjZEsIfA72rWNtAYcueRByPGgT/E46+LvbIswTdgRNP9g4FpioZ0Hg
         b8jS5B6RvD0JW21+kmLbL0fMwwlyHxjrUm2lZmkyoweD6zgt5a8Fr4tTkk4+pha4kLdD
         ZxLg0Y7Ylem3Ov+Yoq2AGB4eiH8Qkfy1q7NE5ZL3+YpOzWNGRZZAqMAr69mjrpJhPsKs
         ftkKlnvCtupUFLTddWGrFqaWPd/KnoIJG/J/J4HM12LfseJgbxIpYqEhRHY8bVV1gfsd
         96Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777798285; x=1778403085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/6FlnQddOFsW56J1QVBKnB0QJtZtOojgEvtskF1QOQA=;
        b=Bw1X4fzvYPF8Oypa+JmayIeGzlFpsgnY8IgAgjLFUfVXHHYBCw6HPw0w4KJYVd4fKg
         S98A/kEv5NoktjwkCJq3eouNyh2DKp2KD9bj6upn/UJs2GhVsATZ93qovfo15HEUUfF/
         0YyhUFBNAfhBOjKjjDdUR1sL+P1xLTSY6Fy8x3P5om7L3e3K5nzyD18JFbGsqUvjtvtS
         lnrlGxS3AeDzBIk/oK6uortE8i2BTCu2QcWG0aTxS5mzu7ahEMMPbR1DNU+A5Tn2Hudu
         DMGm+5CO0ip5n+oOnGQIKpMI/P6mpctnkfW4mfeIRgne6NF64f7dF4vnH0SYQhfKAIY/
         vBIw==
X-Gm-Message-State: AOJu0YwiPzIUV7VF+VwDhc+jUpNReIZCBBSUl38zGThwqB1jFH0iZ5HN
	7GnZRq8XTNNkB30Jshe4slGnObzOsdvk/n8Co8VRMSMMqsmOMKvm+OJwLU86HTK3Pczsg9uurD1
	oFwnsujiesA==
X-Gm-Gg: AeBDieu9FbQLiyxXABaeyJh67nwQ49Ch8QDAbrwhsUBDYPZsGhhBu4CeXD/j7pyDE6B
	QCF+oJvihR8G5MxAtwL4VailKW4rcsCpVAlUBrqoESci28exyvC/oTKzm+VogPfOin0irnBvFsr
	flCGWH2rhvFGqeBwFxz4pPxfQP+k7qp41lRA5wsxIIH88lZomre4XKrxLrDig/VNOpzDCUA963V
	WJkqi6aLr3A8PZBDLYdPQOnZ0ocplRV8bXt5+OsNU78o7jO4BJvgI9s+dTSbGBTLTUzT0c2t7Z4
	Np3U2IcRMUMZYsojMfsdMJVOc0/aalF9/lLUS4UlpGfEBS2Dy0ElCnIhmG6uXFdbhmxFYi3dtTc
	UtJqrj7CAVnkDfu+IRLGfi19CejtZhIJ8lKVzYoUXniQOi98wEMc8RBKdR1NfEqixQBg9LdmDoa
	Fpd3FQfHD9S+mM5g1hvp9DMlawFng3yH/yEXntvevaOsnm8Qtxt84P4i1oGZb3DsG4gzBLsea1v
	8Pro4Tm7g==
X-Received: by 2002:a05:6402:5043:b0:67b:7e67:7f5f with SMTP id 4fb4d7f45d1cf-67c1380e252mr1631880a12.9.1777798284672;
        Sun, 03 May 2026 01:51:24 -0700 (PDT)
Received: from m2max ([77.241.229.232])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67b85e292c2sm2368936a12.1.2026.05.03.01.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 01:51:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5/5] io_uring/epoll: disallow adding an epoll file to an epoll context
Date: Sun,  3 May 2026 02:49:16 -0600
Message-ID: <20260503085101.112698-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260503085101.112698-1-axboe@kernel.dk>
References: <20260503085101.112698-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 280644B4F97
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13213-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,kernel-dk.20251104.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux-foundation.org:email]

One of the nastier things about epoll is how it allows adding epoll
files to epoll contexts. This leads to all sorts of loop detection
code, and has been a source of issues in the past.

Arguably adding IORING_EPOLL_CTL is a historical mistake on the
io_uring side, but we're kind of stuck with it now as it does seem
to be in use according to code searches. But we can at least minimize
the damage a bit and just disallow this part of epoll, where nesting
issues can arise.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/epoll.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/epoll.c b/io_uring/epoll.c
index 59cd4f009648..42057aab9124 100644
--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -62,6 +62,9 @@ int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 	CLASS(fd, tf)(ie->fd);
 	if (fd_empty(tf))
 		return -EBADF;
+	/* disallow adding an epoll context to another epoll context */
+	if (ie->op == EPOLL_CTL_ADD && is_file_epoll(fd_file(tf)))
+		return -EINVAL;
 
 	efd.file = fd_file(tf);
 	efd.fd = ie->fd;
-- 
2.53.0


