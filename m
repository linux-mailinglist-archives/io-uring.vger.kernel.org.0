Return-Path: <io-uring+bounces-12333-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oGVmOcofl2nvuwIAu9opvQ
	(envelope-from <io-uring+bounces-12333-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 15:35:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AB3C15F930
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 15:35:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A1967305FD8A
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 14:32:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF24C33F8B4;
	Thu, 19 Feb 2026 14:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xkflXAuS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D792D86277
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 14:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771511538; cv=none; b=KJlVLRFf/EJBYwTEbemQmAfnR3ADp9w+b3NlwEJDBHRXnwHLfjKTiEQX23V226BU4PvfZweC5y5OwXWhH3pL4TMcK7o7EaqTEQ7dZJVboquhgsPAEu8ELQOiybC/TY9T4C7dk8jdImdAcnpf/VsiMIXys/idztXG5wUh8cSIi20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771511538; c=relaxed/simple;
	bh=1b/Ajg94WUPLq6D+VcvNqElFPYosPzHrfA8Z1vMrW7I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IT6jkbq9j7OwZh43YSbdMhBXJRyo5/DPDWpIy6vumllmRaAK4yo25YWyZsaWf7TMXhxKRSRpiE3uAOxKyiHF0pJGi3dzq59HOQA6w8XmLLCuqU6SqavZm/v8B3n0b5DXbSJaPkYYPyjTJka0HxG6NHJWS7RcQFnLQx3kZ7VMq7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xkflXAuS; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-463a0e14b4cso353432b6e.1
        for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 06:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771511535; x=1772116335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9F77IX8rpaUH7XVvy4BGA9ADXrMq2GyaWwAXYH8BoNY=;
        b=xkflXAuSAtLY7pW1dHPIRmve29fd3ori5R0R8yCm1Qvk+PzXQQIHLHDGzZJi2No8wn
         mN1rV7lTUuxDSoQ8Go0oQyx7+I/zN54LBrfXZ6DwpN386J+yyasrzZOfTTRKIxZp0M8m
         DsXR0upGtyYKhb5REac5P9KInQkAmSCKE+soUsuvfgP0JnBWKf9pcssoSxFfl3IHnCRF
         Vy14AcDizFJigikzMd4BlnxHsuibYjCFgYJ5VmKryHE48+1v+cekn65+2IqEshd4PUv3
         4seHbWxLQEm68gTuKGykGOQLj9Ng1IWuXdctxLHeblym1UxHZIzQR25F52d5rTEkENZM
         iMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771511535; x=1772116335;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9F77IX8rpaUH7XVvy4BGA9ADXrMq2GyaWwAXYH8BoNY=;
        b=vp13RyOLt2DxO4dBdDPbSsKEk49dG5nPdMv263lljoympOYBAC8Bexa+BY53VdzmO5
         ysGpcWuMRM6baKhg8d4VEPAFTAjH89LItgwYrtg3kTqfSSMwYSloyeTZYGQ8LBh8OY1+
         zaB5BqVj/qd9mvr5tQv2m8RqNoXz80I808sbh3uvPjYw3jP+TEyYdEGqAe/qJJS/+ZJS
         /mc29SUPV1gRhXnQYBzyeOQ1z8L11SGRvQ0MQhMxDpVUOvqZTbFS5VTk5Sz0ijFOdRjC
         AR+DK6YMEivRGQpd4YKs78cP9RpEymf/Qs81G2ZY58XnbmD0wU2XmfeuEw2TvJCQwoy1
         ZyDg==
X-Gm-Message-State: AOJu0Ywn5fEwBdInYaVuroe+htOGh9MwRTwAIukHa98tr7w6R0RhVuZa
	pOOZV6W7WlPfTfxJE8PdGxt666K5dfeIjsMbOgoQl/sW3aN0VCKkqrYlUrpaaD4ZRek=
X-Gm-Gg: AZuq6aLnf4y0WyMYtk2efAQfYbrKbeVWDHxPvFR+aklAEgkhUiqcyYnNykmTy5VwK2S
	dLmscEuonX9khQYKK/iFfGLoOKFkNY4rUvhgBoW9IjzX2TFvfR2KDsv1nEyZD47nccIdhCtAyd8
	nrx6F+ZiExIku4uqe+KlC88fCUP3YQY741LhF+FQKfyrAWKrXtBWKNslsXVmXmAKU0lajmgcjt8
	dcasGKWpLzM+oub7eqDrST3kE9tzFeUcx/nxcBCjODROOrLo7MZVRqaOdcLltkxlo5ru3XO9WEf
	4J+LTx3JNQTXtP5jTTuwyBxy7BUyvCoXpmdyqbTCYxBC0tZxQKpp9MivajHKzpAiMPMLcP+bBh2
	fliVmj1CZPZhyg81lingPd9cNJt4UeReg6WYI3sSaEY8p9GzqE4EyW1JnZIxBBOffhmCWzZ68Dc
	d0GV9jyrqith4H/yx5kb+oFPMgc7QF5kOnpzbHxG8w4WfqT+S3LvcyRdwqMZf7ziGViLKNYZje8
	fK39g==
X-Received: by 2002:a05:6820:981:b0:66e:e7e:6524 with SMTP id 006d021491bc7-679a745beb7mr2831341eaf.58.1771511535504;
        Thu, 19 Feb 2026 06:32:15 -0800 (PST)
Received: from [127.0.0.1] ([187.199.77.89])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-678b13aec01sm10280366eaf.8.2026.02.19.06.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 06:32:14 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Keith Busch <kbusch@kernel.org>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260219013534.4140776-1-csander@purestorage.com>
References: <20260219013534.4140776-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring: add IORING_OP_URING_CMD128 to opcode checks
Message-Id: <177151153434.554113.2492962091425318306.b4-ty@kernel.dk>
Date: Thu, 19 Feb 2026 07:32:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12333-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 5AB3C15F930
X-Rspamd-Action: no action


On Wed, 18 Feb 2026 18:35:34 -0700, Caleb Sander Mateos wrote:
> io_should_commit(), io_uring_classic_poll(), and io_do_iopoll() compare
> struct io_kiocb's opcode against IORING_OP_URING_CMD to implement
> special treatment for uring_cmds. The recently added opcode
> IORING_OP_URING_CMD128 is meant to be equivalent to IORING_OP_URING_CMD,
> so treat it the same way in these functions.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring: add IORING_OP_URING_CMD128 to opcode checks
      commit: 42a6bd57ee9f930a72c26f863c72f666d6ed9ea5

Best regards,
-- 
Jens Axboe




