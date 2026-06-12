Return-Path: <io-uring+bounces-13708-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 20XRCoFtLGobQwQAu9opvQ
	(envelope-from <io-uring+bounces-13708-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 22:35:13 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A11867C587
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 22:35:12 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=vcrUuQYf;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13708-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13708-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 145DE301483F
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 20:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE2C92BE051;
	Fri, 12 Jun 2026 20:35:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE31C2EBDE9
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 20:35:07 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781296509; cv=none; b=OEFqQ0uS1V4/u0UwZ/cZtTGldk+MFEG9uqKFrMLtWbMt+eZTKwHWogX9rCph7XL0ut9CG2Aryc9b8fAmQYplEez5HdSNT1Es4k+TuYdo3oM7Q1GJ0x2VJnWordbXMRyQKYr3py3/StowO7V/SscNE5vHCnGmhGGFF2quOnbh4Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781296509; c=relaxed/simple;
	bh=7y9hMoqzE7U13QYt5dX9JXww7Ho9zDQfHFWtvMU2lwM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=RHGmvvZDZ6TcHjREF6Peem22ZXYRaMk1dfZjhQYiYHwNDqe6x0JSctPsGZel0TbHsgYaZJM7UUykQUQYmDiCTR3iiIDvPH8ggc9J3YLJTbWyP4jY9gnv2YoXH9SV3vvMDf+ie/nJQvFdIuOVHO/FnAzFkPb8DVk0NafaaNGH1+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=vcrUuQYf; arc=none smtp.client-ip=209.85.161.46
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-69e8aa31e9fso673859eaf.2
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 13:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781296507; x=1781901307; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Wl3X8FpXaSAMpYsE8zMS+2CXQXkuBB03bdkDy/VYKo=;
        b=vcrUuQYfgAlQwOz6OlfguuDllxXf64yIt2QPBhzMcFKkZAEi6NeSV+obca1Yc6a9ul
         csu/MaIFzeo2cf4m2PSAYHXaVA3Dn2UZRxRQ858mCeeDKR4E+YIIILe+9DioO6Hhe79K
         Wm4Qa+Rd+GoR5oy1sjh30m5lJaEUzaWfOCUrU/HR8PAKaDpWOjxD2CPVKO5JhzPtMvAC
         wEGRNVzXKtJUyeYhDWCHEZRnv9w5xScvNp8OC/lx4mYng1dxfPeMCdtJa+UzCCK3ZK9f
         47dfArSYHld346udvdt3GnLToQEc2EicecgDgCu34hwDL8TI8BUI7EkJsOGY2yTDYgsH
         t2ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781296507; x=1781901307;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Wl3X8FpXaSAMpYsE8zMS+2CXQXkuBB03bdkDy/VYKo=;
        b=q9RYgNbPojSlWTePWxU8eAWz+cXRafm5G/Cthf4rCIMkiZ13u9A+Mit7uKuR7ZUq/Z
         8ouvFPMPIYThVXj3QGI7NdUo7ZWREi2MRCbQycy6i0BiQYG8D8CxKrT/ByTmshvkDYjT
         yiLAfrzZdIZOKTp2ZDKhu2r0eUOCFGXnyV27NFnV5lRkuaryFOW777ZyI12dgq/JlwMQ
         Mc0apZB8kaKIrweQOR0T2CzRVf7UnS758ozZYhp1ADHSuJTV19fSie3uxalCZ53L+qb+
         kO20FmJ6nghsf0GjpMCd5bA76WuRxFlLFvY3qokgQFxgkRkIos1P5Be8z9iG2aJpiJZQ
         9ZQQ==
X-Gm-Message-State: AOJu0Yz6l34uYAlHzQbQlRw/yMnw64qP108ktkixsS9HfaLIIkLGAPoD
	+OIwUIZ+mvW6yEXEq5OuxXHbC0NyaC5qmV61KL9WVkBiYp/37v1o6FPOh5vtmcyS2vHWUlOvsin
	B74Gx13k=
X-Gm-Gg: Acq92OFmHLhQrWxuxLFHuQ4uOH8uvWQnnX7R//3o0Qf3D2RQZVR7bTYr2F4LFe561yR
	TU5g/92Gy5MZ3LSTb2h/+k+7rEDBA45UMNCSU85BK2XL935OkfSncmoJxuSoW34A76syEFciwem
	r+zXdkTpnn3khq7mDn0e0fEyB6+xOCvp0CG6WCdxHZVhP7mOcnA5iPA+HRZHN96Yr7U4HX3HFlI
	vp6hzUQaomjlfRMZJ2P83E1n2V2a9tBW5B0xuINFCgEQMleu2s3Z4Jmcc5pONXhdRQfn58ynNTy
	MtiluSv91t9gQLgWnGd4va6xMU9mbIc0x7SHA03Bh+WNsGDhZ+utR6HPDK6v5d1g2sIhvqukqBu
	TO0O+afjnvlYaQIdrhaK5hWFtijcxDCmmNZVoQrpvQxEXKpNl8zFGlInK2GpU68Q8Pgj9ZXzo3b
	zIul8m7u/yrkJRrbdUD8OsCAlY4ZWBdXqU5bZGBVuU2wspcgsTrpxwFahtaIHKzcskOwmtOdMuA
	gLxb/yw8Q==
X-Received: by 2002:a05:6820:81d3:b0:69e:57a1:8923 with SMTP id 006d021491bc7-69edc620813mr2898119eaf.14.1781296506479;
        Fri, 12 Jun 2026 13:35:06 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4426abf2782sm2844961fac.8.2026.06.12.13.35.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 13:35:05 -0700 (PDT)
Message-ID: <a8ae874c-1fdf-49f6-abbc-a4dff3a7d679@kernel.dk>
Date: Fri, 12 Jun 2026 14:35:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring/net: make POLL_FIRST receive side checks
 consistent
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-13708-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,vger.kernel.org:from_smtp,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9A11867C587

io_recv() and io_recvzc() are the odd ones out, as they checks for
whether POLL_FIRST should be honored before checking if the file is a
socket. It doesn't really matter, but might as well make it consistent
across all receive and send types.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 5ae538b3c0f3..7deb62e3b4c0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1216,14 +1216,14 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	bool mshot_finished;
 
-	if (!(req->flags & REQ_F_POLLED) &&
-	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return -EAGAIN;
-
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
+		return -EAGAIN;
+
 	flags = sr->msg_flags;
 	if (force_nonblock)
 		flags |= MSG_DONTWAIT;
@@ -1328,14 +1328,14 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 	unsigned int len;
 	int ret;
 
-	if (!(req->flags & REQ_F_POLLED) &&
-	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
-		return -EAGAIN;
-
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
+		return -EAGAIN;
+
 	len = zc->len;
 	ret = io_zcrx_recv(req, zc->ifq, sock, 0, issue_flags, &zc->len);
 	if (len && zc->len == 0) {

-- 
Jens Axboe


