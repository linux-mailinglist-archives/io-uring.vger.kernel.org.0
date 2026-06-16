Return-Path: <io-uring+bounces-13753-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id U8JUHg14MWp5kAUAu9opvQ
	(envelope-from <io-uring+bounces-13753-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 18:21:33 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB2DF691F9C
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 18:21:32 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=uEOmTZ+C;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13753-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13753-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C7BA832855A9
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 16:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFF84657D0;
	Tue, 16 Jun 2026 16:08:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5925945BD6F
	for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 16:08:38 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626120; cv=none; b=Fhy3qd/vJQOMQc573PHa7X0LB9RpAtB5iqSumII6dOsv2R58sTPhVIT/RpmjZqpgGyIWPwdk41ALDfrHPkUL6/CidNxizputjdbncXiuxw9ASoBMAT9lKD07jhL+TTjuVBBeb56qT7pHjzSJhMcgCI8B78wpZ+qlx5//TPnLzos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626120; c=relaxed/simple;
	bh=114CpVtkB6p1CIb6o0+A+XoYmOp70hQhk51t9u+29HY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=eXCKZO/AvSkthb9CKNgRhw9jNG3/ZMjdNcU4j1GIpGDluuHuFWdYDOI1obf8iLn7jsDPTQLwDBSIvQQi/VEfgKl1AfoNop6Xz6EkYsVfqiv0KfXsTjuelptiVrtfhiE79QX75S2bnUT+cfKB9uKgcqty395sSnU04VdC44IwF2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=uEOmTZ+C; arc=none smtp.client-ip=209.85.160.49
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-43d16405b54so1793304fac.3
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 09:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781626117; x=1782230917; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KK8pQaJRHjqFuo46fkJ7FtOQfX1elMDIW9ynP3FkvE8=;
        b=uEOmTZ+Ci1BiBYd51xdXdgaZNmRg1eHe4hF+FRW6+O3ghp1UntZ5mz3+iou/QnQAXt
         U2x80DDYFniIsznKMNZphOueMb+jcTu2tr9FOAohwZylyxWrm77G/fKtYt1LLBzb8hbJ
         t3SCG7uF3bhPEDY9/sfcIkKMLVC09H24bXCZZDwLtJrMaocu3amSjcWiYvJaJwcmpszy
         8A0aTQIQtbdEnuYSLTbEr5eOHYf37Kf1fYiFUTHQqyVRMMwY35evQGcA3t0Gr7Pq4y9C
         qB++THCBbUtegg8ku4zim3DSmEREiCJRhYg+SkbzHJd2QD+x/NwJcc+ShMknbWZ6jz3T
         5W/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781626117; x=1782230917;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KK8pQaJRHjqFuo46fkJ7FtOQfX1elMDIW9ynP3FkvE8=;
        b=Ht9H2D1qzikjM32bfw2wLuyONv7UEULNCGni9ZhrSJsybWXSqSK3SictF/j6h6sA8K
         /P9UUybRWghYMqfEZKqfJ+J/mwlIFJeHcH5+JY8a3zp5aY8hqCkHrmPKti7rzEglUaI7
         owKkGSMwVU+LLQ6FZFioyT+B/Ju9i7CyjpkOrfUsOT5ugAzNZ9Z/NKyqpGkENjHhJDO/
         boa59XlOPiH2CLbXBZHkBGJycnwLjZOOjPAxsffLziAfkgK2XBTNKGPoofy+65HxFM+S
         2om3n2DqX2RTS8MrXiXRICnNSpWczQ3y6zcKTbGiPmQe67B8WLZOqwF74XQYPCBe4cpw
         4RGQ==
X-Gm-Message-State: AOJu0YzlHL7emyGChgAw2pC/Zz9SHjdlu6/Ue0deQ1yGm3UIbZhBwwIx
	5IiZBf9VQKN20y4dBZhdHNnQ9yFIIPpdoTpygZp9ucCuOpJSl2DVX0fn/zzS61efFol4fC+y+z/
	SVqtq2LU=
X-Gm-Gg: Acq92OFK5F6fsxtaoi/WuBdWaWZOVPEzbOk8sF8NzS6/d6IRVhcdpz3+wTYTw8Q7P+b
	X8H+eT85KjDaUCSpWLwpDyKoo6JTY9cWlz+UCBMYwSuFjWGZbuN8rl/vfDpHGkJMP80cP6/jDQH
	zaWKPauSut5anYhwZdxfTFp7wogKb1NhpVZP87qYRtuWZu4CSfIseMCKlRHAkkeSqB3GfcW0/qg
	XnCJ4Zk2Cpo5NudQLknldVwPS35FZfleL1znv5u2DsAtdNaUdU2AIWbjAvtdNNoJ6VaB95iXTRk
	0m7gSo4AU2I7FMFMVYLZguGK47aw+095VfNeIBjyW81DgsjGPQxYSdR8Tk1JO9lXdFX+D1Q6538
	v4/TcxG7NvRSBJapUJeOIrMZUf/kqC5u0AXZOhOL1JTuX0wqjn2GUJ/rQ7G4j8qweaQdAlEf9A8
	r459T7CYNGIUisS6aLZZmz4c4RMP1QtjzNdwf/mzqYbLs6DQnvFBIvFTF6sgBprtlC12lDz/Mnj
	Qzs
X-Received: by 2002:a05:6808:2210:b0:487:500f:ef56 with SMTP id 5614622812f47-489429e5b80mr230690b6e.34.1781626117278;
        Tue, 16 Jun 2026 09:08:37 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4875ddd9fd3sm4631101b6e.7.2026.06.16.09.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 09:08:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: guzebing <guzebing1612@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260608133316.3656440-1-guzebing1612@gmail.com>
References: <20260608133316.3656440-1-guzebing1612@gmail.com>
Subject: Re: [PATCH] io_uring/register: preserve SQ array entries on resize
Message-Id: <178162611649.2191657.14070998514588053092.b4-ty@b4>
Date: Tue, 16 Jun 2026 10:08:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:guzebing1612@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13753-lists,io-uring=lfdr.de];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: CB2DF691F9C


On Mon, 08 Jun 2026 21:33:16 +0800, guzebing wrote:
> Ring resizing copies pending SQEs from the old SQE array into the new
> one so submissions queued before the resize can still be consumed
> afterwards.
> 
> That copy currently walks the SQ head/tail range directly. This is only
> correct when there is no SQ array indirection. With a regular SQ array,
> each pending SQ entry contains an index into the SQE array. After resize,
> ctx->sq_array is repointed at the newly allocated array, so pending
> entries lose their old logical-to-physical mapping and may submit the
> wrong SQE.
> 
> [...]

Applied, thanks!

[1/1] io_uring/register: preserve SQ array entries on resize
      commit: 1fe703cc708f19209ae8e6261247483db723c221

Best regards,
-- 
Jens Axboe




