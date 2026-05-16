Return-Path: <io-uring+bounces-13372-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MMK+NSDACGrh3gMAu9opvQ
	(envelope-from <io-uring+bounces-13372-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2026 21:06:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CAE5C55D70A
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2026 21:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B7F993004DAC
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2026 19:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEA0535DA56;
	Sat, 16 May 2026 19:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="aeKKAanc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A7F33FE0F
	for <io-uring@vger.kernel.org>; Sat, 16 May 2026 19:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778958360; cv=none; b=bVXKuV9S4Dwl2p7qdK48w2fIoqE2fnJ4x8zVQ2GfMd1MsgVny2F4s1AS8V7qaDHZ9KWoI3F14ZY753u9zYyGNz7QR1bfLMj1d7HZHZ8rIbqnsKxkWHQL1RGaCEfdFHY3T8g+jIq825rQJr3MRr/Hi1QV1MRFq3GuTZw98rCXatQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778958360; c=relaxed/simple;
	bh=UyZOZuyRlMt3+ip0WlUfEQ2nBW08rltWdK8cjbw87Jo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Xw+KKFya0vuLulO5Tovkeg9VZLopqfuTLWs+wPT9dZb/zrF2bPk6TlQd0BLi3MBhTEoFOulQI+qEfCAa3kBU4Y68rlpOp4A2oRWUc/vPFo3ribnUWheXLE6soyFL/Hlw2DyHNlNuK60StH7rnQpyJOku9IbaKn0+FsAvqdGe5jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=aeKKAanc; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7de4be15125so964711a34.0
        for <io-uring@vger.kernel.org>; Sat, 16 May 2026 12:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778958358; x=1779563158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nZc4kj/8128oLJ3m8eOOQSX4eFeWKel+YW2aiCdJSZ4=;
        b=aeKKAanch01DJJc5tIz0fzxjvag9DEngY3FNU7E9eDpSn/sBspxJWfasn1KZF0D2VF
         37HihApVcpXyNRrtWWiVqHFHFzUo4oVu/R1FGbdgQQkYByDscC9K0mry3LZVH4leAIk+
         MALH1cq1akwqRTj2XnZenk462Ps4iDmE5A3EseRoF9GJSttOp9ucA70Z/jGm7H1DSbmv
         6Xk40sTPSaP1r9y7PBwNMgh4a3mL1Vz50DXh3U8txmwWkRnu2uM4qEGrc/M0KNT2IOlD
         8BrwxhKOkuk1kl/h7G3WY1pUToYlZtJdJ3BLI3YBCdXmUJtkQ4LtiOOJzWyuMjt1iZ89
         AuSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778958358; x=1779563158;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nZc4kj/8128oLJ3m8eOOQSX4eFeWKel+YW2aiCdJSZ4=;
        b=rp2FbEckgeSvqxgAibAt//uccuZJWR7lqEtATfT0Q6PZw84Qnr4qxovpllQwxabCrp
         mJh0XUe/hBeY62VP6PH0G2ZJZILrZs2uWrdULukljFbH0zklAPkhN2QbfsZZcVq4Hfg7
         HdtXAPvvegeYbsgFa6m24RxmIUIknWZoqLxGZpXkrzSPsqqrMrvmlTF/VOZPZsvnZqDc
         A/QCSDNxqo0yXah2u6er2d7629O53iO127yV6Cy6ZOfRDaSdXuqNOUEpv6A9CxolRoGP
         FyaFZbi94FWjSZqUMhQNeaDEG9nlDWgSDWv0lTw8sCe0ST2oi8Aq0KDdvdmXZTBmVITX
         7gwg==
X-Gm-Message-State: AOJu0YzUcrIGyXw7NjzvE4qfOadlx8z3DlBvBCL4/qxdQ/oDajhlmlrp
	AVGVJda3nYorIqrZkJrYoGrDFTPrC3SQn/0uH0SUtID8iV2Fn1TaFBtkHWCkiVSDkEI=
X-Gm-Gg: Acq92OFaPkzj1wF1eaYUdXdDWs3ekorHPecARJcd9m+jAPJqVXMPsOuCCOOkX3lIACD
	53NBOuLghHg0mhAS5vsH/JW7vNdifXumr44Gcd8iCp+vz17+4f4kdunPFdJC8nwJUyRCy1SvQjV
	KbFiNhhsqRlxHiAiNM1qC5zPhwzUWRXV63CLntTGX4AAf4ciEhFKVR2IomIEsuVK0P9RiX/zWNC
	CqgBPCfBC/D5xb6QoSdYn9uBx86H45Pn9DNBvy2tURg30TnI9GMXI+N5coA1+rZfSW65zLtqSvX
	Hxf3pVgD+TQ1DCWgpkgxygZOUBYFdcKImvFj8A9ivNh/fmILv2XnF32GGyTYo1mQ9tfzGRlC7EK
	swd96VYJoI0ikADvRgIc7f57Xai3vjuth5sc5l2lVdCumwPT9su0UbXS/B9OHyzgIF94JMsnR4n
	bSa7e0nZcyyAy2PAjf+0xDbwj4wlmx9329Hc5Gz4/WVZXfdZMAMrAz6EkmMzeeYxlMHTepwbioX
	von
X-Received: by 2002:a05:6830:4704:b0:7dc:e090:68a with SMTP id 46e09a7af769-7e4de651649mr6339319a34.0.1778958358300;
        Sat, 16 May 2026 12:05:58 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e55bbd08ccsm4023092a34.17.2026.05.16.12.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 12:05:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, 
 Michael Bommarito <michael.bommarito@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Li Zetao <lizetao1@huawei.com>, 
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260515145812.1241925-1-michael.bommarito@gmail.com>
References: <20260515145812.1241925-1-michael.bommarito@gmail.com>
Subject: Re: [PATCH] io_uring: propagate array_index_nospec opcode into
 req->opcode
Message-Id: <177895835722.925638.5480075990608035864.b4-ty@b4>
Date: Sat, 16 May 2026 13:05:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: CAE5C55D70A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13372-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,huawei.com,vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action


On Fri, 15 May 2026 10:58:11 -0400, Michael Bommarito wrote:
> Commit 1e988c3fe126 ("io_uring: prevent opcode speculation") added
> array_index_nospec() to the local opcode in io_init_req(), but the
> sanitised value is not written back to req->opcode.  The
> unconditional write at the top of io_init_req() stores the raw byte
> into the persistent field; the success path of the bounds check
> leaves it unchanged, and downstream consumers read the raw value.
> 
> [...]

Applied, thanks!

[1/1] io_uring: propagate array_index_nospec opcode into req->opcode
      (no commit info)

Best regards,
-- 
Jens Axboe




