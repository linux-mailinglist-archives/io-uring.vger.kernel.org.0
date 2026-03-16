Return-Path: <io-uring+bounces-12689-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KOWYBIPdt2mcWAEAu9opvQ
	(envelope-from <io-uring+bounces-12689-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 11:37:55 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B280298001
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 11:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E6A11300889D
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 10:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B69F33ADA2;
	Mon, 16 Mar 2026 10:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JFZj/hbe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AAA17D2
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 10:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773657451; cv=none; b=h7e1cK2V2yzMX80iAVcUfSY4M4NiNSAh+DQS1PlpNpCY1SMXiRbii8X8lAr3E8TUwB1I3R6xXGDeVGhw7rUmxJof4S/DHUxvHa6W9k5JFVwF1s382/zTTpLNqZkGPjVbytJ9zdH3aUaKKK2HiJ3QvZaes1kiDlUMWuPBfqgo9lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773657451; c=relaxed/simple;
	bh=4OAR59cTB/oFXacPdzJkYDSdLpesFmVIxfMOghPciVE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GdlO9zxkqeXp7CDU7pbi1D4gD4pEsxMYUvFqb3tEMrb9LKZMewiXr6R1r8l3mTpIjIB3I+egpaBXKfC4bMQ+W+riBWCn8QBHs1xY+AsrqUGYFrEXBp8HmHHbyeIOqGqlOG4QasXSNgc81CMJD2oVyqU6/zQcuL1PoYgPBGUi7ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JFZj/hbe; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-46703fb602fso1471313b6e.0
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 03:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773657447; x=1774262247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XxX4vcJLjj3QAXXDMSqZ/mMjfXjAEnypFJj+H4Z7iGo=;
        b=JFZj/hbeXyRmeibyCqdQObxdd0v7DCAYAMEv2ryNBcVkmDdlv9QEuDYRt6Vf7esel9
         07ScFDg9HjuitSHLR+V31BtXWy1XIDkr/6SNLUCuKtFry98NxDFUuj77c6Qz8rbOmjxU
         9F+ftSdr67k9EZ8DkNQDmqTgXuZO9fd6ncjRC6JpRfzPCcLgdDdRVcNVWkQX9o7Q7drd
         S4UHPinYkCuWExA3XlstA6wZwBNv0pK9Ld6wN0Tck/wzPndAIl+ZvkEO53K+ewrgH84d
         UbTwjkNLXqC51L4BLgx5ENXeydYUqjnqsdOqKD7U1pDqVA0lEtPDeO9pl9hAOxfUXMAY
         KJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773657447; x=1774262247;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XxX4vcJLjj3QAXXDMSqZ/mMjfXjAEnypFJj+H4Z7iGo=;
        b=hG2jRq8TwUDr3+nhzht2ZllxDIn0BzeJIFJSXIx1g3BOogfHaw1084ij4dZgnKNTzv
         XjwRo8KnrS819Pd3zpLYjis4iud/cfrls1lgIi51DNDR1pl6g9pJpO/4avaGwLXjo0xS
         fWf747bbmftJ1N4RREiS5Px/Zfbu7ztlq72uma6inSW4KB3ad1h52AyrGKeNEG8SqZoK
         6VdTCKL2WNLegtLllvhTBbTzmNEZzqxChn09bHc4U1hRbG2bqB+E0FhuBcmS62kRiZ4P
         imF36hxKO/u8+QWcyLDXkefHQFb3MJlhaYjbao9UlhLbaTFhWlIjw5Mf6rcu5PdKvHJh
         Xk1g==
X-Gm-Message-State: AOJu0Yzs5lCKx91VssoWpRul7yKwNZOFynnJ8pyBgbMU2pQnsnVvy5TW
	CWUym93hjylE4MI0MhP+75bfuvQhzXP99rV723hgvNtXgZQS4GI4qG+uS0Vv86J0dzQRmTpxijQ
	XPoB33Zo=
X-Gm-Gg: ATEYQzxFwAtCbHHhjHXAVqL8noUplvmgd2yQ2rp2J5cpySP41ZLdml+mZUWM9Gu0dLJ
	zo4Nv/8AzaZZfXFUzIUdvNZqfJRPr8wgdMn4dRuxg4gjP+X6R3Zn8bLsr7ovitc3Cvj7KNwmovW
	IbhXSnqeD84nxt5A8l7yY0CX0ET1LKbUxIBZQjk0Mdk8tgIWswDFUvqibb9zOk7zNDcOItayOTv
	3ryPkZr+jR7dBck7b3OmVfdUPBUIOMMGN6BqAhxh4+sQdu0zyBWHP7RENpdLf2Wu4wzk8xKeiqj
	ADyootPcd27kgeZkd+GN4P8gAcoCf1vZvmUX6T/6DxUTKQkKpXnTsfQBqWL+wbgNaLQwe8FJES0
	isKyLDAkNv707oiBLPuG6OxQ1etAL3nZ0bYCA557aNKyAxlya36pdTb+e5m+RDYuL6NV6E8V2Uz
	teOAd8DGVQtgDNycSyeruDPogwMFbA05LCT9YA1JgCtxnZaiWjnqRRb25UmuFI1JJ5+9i73Wu6F
	7Cj
X-Received: by 2002:a4a:dc8e:0:b0:67b:dd31:f11e with SMTP id 006d021491bc7-67bdd31f49fmr5725503eaf.62.1773657447099;
        Mon, 16 Mar 2026 03:37:27 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bc9118c87sm9870169eaf.5.2026.03.16.03.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 03:37:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20260316013621.115939-1-yangxiuwei@kylinos.cn>
References: <20260316013621.115939-1-yangxiuwei@kylinos.cn>
Subject: Re: [PATCH v2 0/2] build and compiler warning fixes
Message-Id: <177365744563.425847.7127717306019402589.b4-ty@kernel.dk>
Date: Mon, 16 Mar 2026 04:37:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12689-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 6B280298001
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Mon, 16 Mar 2026 09:36:19 +0800, Yang Xiuwei wrote:
> Fix two issues: (1) send-zerocopy -Wstringop-truncation on ifr.ifr_name;
> (2) cbpf_filter build failure when kernel headers lack openat2.h.
> 
> Changes since v1:
>   - Patch 2/2: Per Jens's suggestion, use RESOLVE_IN_ROOT fallback instead
>     of stubbing the test.
>   - Patch 1/2 unchanged.
> 
> [...]

Applied, thanks!

[1/2] examples/send-zerocopy: fix -Wstringop-truncation on ifr.ifr_name
      commit: b6a45c81fe1dd6d657f0ea96873cf38a69b0a410
[2/2] test/cbpf_filter: fix build when openat2.h is not available
      commit: a6e7bd5522be2ece8fe1accd2dbb4082742300a6

Best regards,
-- 
Jens Axboe




