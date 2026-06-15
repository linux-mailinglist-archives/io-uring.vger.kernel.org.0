Return-Path: <io-uring+bounces-13732-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id kNoHBV0mMGraOwUAu9opvQ
	(envelope-from <io-uring+bounces-13732-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 18:20:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E0583688470
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 18:20:44 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b="GNo3F/Lw";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13732-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13732-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5F3D9307E8B5
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 16:14:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 262AB425CC3;
	Mon, 15 Jun 2026 16:11:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8837E423173
	for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 16:11:21 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539883; cv=none; b=VCkR5fp0c75THrtEJsxmCWujT2SAv+FF0k3NNb3jdB/+LWojUzKWBmUoinGpmNW/legm/zex951skBRh7TAAJRV3NAbfiLHUJd+L+DEilcdlKw+IY9lM4Vmua4ddm0+0CDJVQhRtHlxB3pGMZRZZJ10SvtD51a1O0zYZZX6b6z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539883; c=relaxed/simple;
	bh=v+O+yppkseenWDZs1JbF/AaLknmY2AN0YpoReeQBaRo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rpOsqaj3ORE7C71xXxinYZzcdrDbW0kYzrtzHze04NfxVBP9G5/z9TKaunaLFwF3QSAuW0Ga0DBtn8h4mWoZyTd5uXaX8sqZMNvxQQCXqR/la/c0iv8RAYTfa425kPnEJQDQgOLcPXL8Eow4/lcD0IPFQh/n8bfyyM1jZHhdNxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=GNo3F/Lw; arc=none smtp.client-ip=209.85.210.44
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7e6dcad6018so3057045a34.3
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 09:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781539880; x=1782144680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qj7icUEMs4GIx/u6FWTf4aEg63YvIWSyt4xXxioMfP0=;
        b=GNo3F/Lwc8eWmcjX/yyBDPRLHwjBOnNzqbt0sItdN9OGWbppMkV8YclwQU9W5KAn9v
         HA6+fWB+gUBaTLZPfVWxZ/9h4GkmY5FVSUP7oUb/FS1MlJi6N1Hff9TmU1L8lP6y0WpS
         gsPnNarH8cegM0/A3u4OphUHpZ1FZi5XN4tVYkPvOPgo1FSxzmDG1g9/XiEXKLi6jVXd
         2yW5zsA005RglNBPoSz5lIGCJxYQ2l24imDJrrGWFYPrPfhYWBD7fTl8q2tHwGgryk76
         PuCPBb8XT43UqQ0eCRkqIByTbnuwuQ3ux9NpAml8VEWEigNc3DVxH8I31jc9H3AEA0kj
         7AYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781539880; x=1782144680;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qj7icUEMs4GIx/u6FWTf4aEg63YvIWSyt4xXxioMfP0=;
        b=PcNLZiUrFIShns7/stMLLL+5WjQnuEW8ZzEDARkrVOP6WafExO4nqIhi3PXv3zjIdf
         cDO29xtr/ks6uPK+W9/r4bMB2sPLILI/Zxoq/7rB9aK9Kb++dafWYF5UQ7GxK8rDOCMB
         oV3BSKOZxhsUPx5RnCXBbq+i1FF4kkeqFq+On5KVkmbWaeSfGdcECj+8QMAsLhkpN4xK
         LyORkD/30DjMFwtElox5md1l42iuXxPCoMzbMczOA6EpDRRvDGIriqk2/UNpD1LrQpST
         hL5eZhupVNDnqK3JCQg+984c5gKgU4WMdUR2mtB68jhKq6Np/1ljYe6lS+NtHL+mjwRY
         gptw==
X-Forwarded-Encrypted: i=1; AFNElJ8y7Il9uigWR3kjsBGTPhfjP7XCQ7/id5tZ/65dzN0lc/RqEpuTQHlrFuGB6gNOmgWEB8cVkmhujQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7kUcqXG8ykU0iQVutqXfqLZRPPabZVpDvoiUPYWHeiIW56fUk
	YiBToFNeyBfunoMbZlk4wwcwl4eWhLw9YkpiQEV0TxJIsSIBd4HMF6kmZAaFE2zFnXk7Zap4cIv
	WHk512+I=
X-Gm-Gg: Acq92OGCUaQGcYJkJlTReQgJU2Bq5EY+Mrnl8XlRT54dj6G8lzZSM2ouIs+W58zn27o
	Bu7xky9Ri+fZsGzMaEOJ+cdUGhwvtMkrsa7nHkChIhjEt/zP8MZhQrztNxJ4IoNEpbAsCav/BVW
	NLGSWeTawcMsYnyMkUxVZlI8FVYEGsmd9dgA95eISZ7YGCcWR0R2BABV6N9C+zAPw/i/yto0xyi
	8KZQOxhc1kbeO82uKNOlbbeBZH+ZMBr4aEQGNRRHZf4mPS+NINBROO3ctPYyOyOSxWzfZgUJ2r2
	Ylf2D0cV1DyGioZpSCC78x4u9Mr7tmqsyQoQvs1PVmtN8yTGDWwap9RIo/2Jz691PF7K6pLxPfr
	o9b1DVYMF/OOtgRpEiymxT2RdZzBEa+fbEc5gul51X67BlxbFZMijMBd+xUncYae99tFTbE/E8Q
	TVFd8ZZFcYdVHwRD9rUEIyDB5X7vWR8t2h5MNNGirLTcl+ZZHkPb7pghiZyL2qGVJCt37B3kJDE
	NZQTGdQO2QMMA==
X-Received: by 2002:a05:6830:f90:b0:7e6:f7fb:967f with SMTP id 46e09a7af769-7e78e628c3fmr8131058a34.2.1781539880593;
        Mon, 15 Jun 2026 09:11:20 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e79f6fb5edsm4581811a34.26.2026.06.15.09.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 09:11:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Michael Wigham <michael@wigham.net>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20260613225240.34032-1-michael@wigham.net>
References: <20260613225240.34032-1-michael@wigham.net>
Subject: Re: [PATCH] io_uring/rw: preserve partial result for iopoll
Message-Id: <178153987932.2073745.6612566060392161190.b4-ty@b4>
Date: Mon, 15 Jun 2026 10:11:19 -0600
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:michael@wigham.net,m:asml.silence@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:stable@vger.kernel.org,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13732-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,vger.kernel.org:from_smtp,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E0583688470


On Sat, 13 Jun 2026 23:52:16 +0100, Michael Wigham wrote:
> A partial read will store the completed byte count in io->bytes_done.
> The regular completion path applies io_fixup_rw_res() so that, when the
> following operation reaches EOF, the number of bytes already read is
> returned.
> 
> The iopoll completion path does not apply this fixup to the return value
> and can return zero instead.
> 
> [...]

Applied, thanks!

[1/1] io_uring/rw: preserve partial result for iopoll
      commit: 15a90c358c33871eec14588d4c72b548b4f679b2

Best regards,
-- 
Jens Axboe




