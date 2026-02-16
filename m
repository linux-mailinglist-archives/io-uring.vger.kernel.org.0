Return-Path: <io-uring+bounces-12248-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AF+NE1k4k2mV2gEAu9opvQ
	(envelope-from <io-uring+bounces-12248-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:31:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A8AA21459B6
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:31:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 72D56301A927
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3191312832;
	Mon, 16 Feb 2026 15:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DQZCDuta"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355D82C0268
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 15:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771255799; cv=none; b=WD4KKQN7yxyLIFQNMlRHZWF7mv8y63BlZ1HK+VxKDWIE0RIfc2Pw7kOh8bh0jhLaZ+LIKxaxIKIOoXGD47iG3T6k+pQkv+9jIZb40NSAQhwhbOMw6tdDho7heJbnpT/7TjX8SqTfg4P1Xx19lsp/TnoLFc4eSuH6dhQeof9NGas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771255799; c=relaxed/simple;
	bh=MWM6DbuJEwYXQIuHcyvn6XjWfxOTdzD44c8RDE7eyQk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LpGNoYAqpy5Llm7HRxGfLcMiUAf4t8ijFe5dQonMQw3MLKKNr5jtYd42aApDkFLxc8HiIqcFRIcMezObSADpVtecl1AIiIrRB5K6imjvv4Q2hd4NJ48wfBdCtAjQ2Xi41gmZPzRL3bqupeIihuikiRVAhvDEdrlybkyxcK2SAgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DQZCDuta; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6786b13984fso1378336eaf.2
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 07:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771255797; x=1771860597; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8N8W9m+TqdQtO25+aXT/RZHv/2DZcyL0+Fk8m1ITjs=;
        b=DQZCDutaut71YX4cg/078z7ORgvaJB66kXJnDh80aZZAGczByjNvAKaOt6ZxugrJTR
         Y7TWnm/768XEIUKC++k/aZ+2yDqU9wlWSEO+CmvBi64Pl1D2DGORpgIgynbfnk9eUMqm
         V+9KsGP+029PDPmpuv6Qln/8MNCi9n6kETe48rIBzh3kW/EuRwJ/HaKPvdRz9CH1UEnI
         sPku9XB/aOWiteoPKVZUXTMrTBx/ddC4TnIG/+Dztrmy5jL+S9uvPaeQllw9yjdbnsfg
         A/eZDF2i1CYIX12IlADQXrF3CmPB+4BBOn7eLtgncizDMeQahAU8EcEhHsez/D+UfpU0
         rx9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771255797; x=1771860597;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w8N8W9m+TqdQtO25+aXT/RZHv/2DZcyL0+Fk8m1ITjs=;
        b=e6CUuWl0W1Ia1YQGMw0rXCm7IOC4lPMkTsSqkdQnszhhxT8ZasUn5w1CG7kM3ZSA/O
         3jxZlOucI2jyJLy2jIUxu1aONHz3yVt7jZ9nYebulbEnahiLhCOXzc2c2732+04U1KZV
         vSct+RIyHooqg/TDfduXgQqrA7d6MIMMUrug1/LxNLcha6jGT//a5jlSjKkqKd6UAjaW
         UwI3PwLUJuLAL8VLjnhX2ItOs/hOGsgO+9inUxkz9Q/cjJUsWjoQuyprFmCanG7BYZVd
         PmgKT/bqTr7a4SmXGare8AwTidpYLN0hMwybUTFMKWJ/fYdEpPiZWgUusl5rGrOk88Pr
         7fEw==
X-Forwarded-Encrypted: i=1; AJvYcCUu3UeIxJm934MtKlmwPo9BcB5OhNhf7Gx6J76EUogiBQXGRg3Tn7lZCcd9DZ/1WvXj/JjsR8gcVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbG38YqPYGDEHAiqhpVruA//lrJZp49+MvY57IIGk/M7eTmoTw
	ZjpomYCkZVWSs4bELtw8HStVuIjh6MQf12/llmEqrgYNJiV3UodiCfwpTDr61Qg5zwrO/8rHW3v
	mw8ulFiU=
X-Gm-Gg: AZuq6aJMJN/Xt9UV43k8kClgy2BaMOuu4kH58AlCIHx90GM4kCCf2gAMVP/hcin3ae6
	7XZJEoxPovYpC7jiGNR2vY2g0o8HnAsYlUOrgfodIBg1kW7L44HZyeri5pY0b6dv2CprcxPchbZ
	beFvwsF+pG5no3DVsiwqp1VmgegkSnSMjboNXozKjqu3FCsmGkTKqhgaXZOorcDU2BFZbH+0eDl
	ChDrZ51I7Y2z+9im+u8Qm2hjTyQSuAVXxDdz398fmkvPzYXYNAkNGPkohzPveV7VPtD4J7raK+m
	V0gPd6BqbYluh5HnZbd0Rwb9sslkdIVYMXY2J80aZFkA23cscsRRZQf1Xgm1F2Hk8T09iWxJoU+
	ZxQRqpobR0nBQh7S72m1zHMYKpBRy92hVH9NfiSEpRG48n3R1d/250J9OD+2C20nskNMdiWt+oQ
	UXn04YkJP1P8CHFu7K5+xhRHHurpnJaUqAkzxpLzZRdqtn9N5sZCZB4G8QFOGrX9lAjuaRrwP6C
	Tmw
X-Received: by 2002:a4a:bc94:0:b0:677:520a:b91a with SMTP id 006d021491bc7-6775219ff33mr4448186eaf.51.1771255797089;
        Mon, 16 Feb 2026 07:29:57 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6777c128a11sm6223317eaf.0.2026.02.16.07.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 07:29:56 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: =?utf-8?q?Asbj=C3=B8rn_Sloth_T=C3=B8nnesen?= <ast@fiberby.net>
Cc: Breno Leitao <leitao@debian.org>, 
 Gabriel Krisman Bertazi <krisman@suse.de>, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20260216-io-uring-fix@fiberby.net>
References: <20260216-io-uring-fix@fiberby.net>
Subject: Re: [PATCH] io_uring/cmd_net: fix too strict requirement on ioctl
Message-Id: <177125579594.125569.3885850915035279276.b4-ty@kernel.dk>
Date: Mon, 16 Feb 2026 08:29:55 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12248-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: A8AA21459B6
X-Rspamd-Action: no action


On Mon, 16 Feb 2026 10:27:18 +0000, Asbjørn Sloth Tønnesen wrote:
> Attempting SOCKET_URING_OP_SETSOCKOPT on an AF_NETLINK socket resulted
> in an -EOPNOTSUPP, as AF_NETLINK doesn't have an ioctl in its struct
> proto, but only in struct proto_ops.
> 
> Prior to the blamed commit, io_uring_cmd_sock() only had two cmd_op
> operations, both requiring ioctl, thus the check was warranted.
> 
> [...]

Applied, thanks!

[1/1] io_uring/cmd_net: fix too strict requirement on ioctl
      commit: 600b665b903733bd60334e86031b157cc823ee55

Best regards,
-- 
Jens Axboe




