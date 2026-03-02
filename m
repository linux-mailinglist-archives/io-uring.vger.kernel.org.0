Return-Path: <io-uring+bounces-12518-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wPSoBvu/pWknFgAAu9opvQ
	(envelope-from <io-uring+bounces-12518-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 17:51:07 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7306D1DD3EE
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 17:51:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A1C7A314174E
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 16:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E1D142316F;
	Mon,  2 Mar 2026 16:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Vm0DKXqS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33804423160
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 16:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772469725; cv=none; b=NdA73tbd0MaQukzXMbxJN5zJX6bCvlUhguvU3AIxMZzRd2ZXcw11kd70EWenONB5xZc1VLUyljX4x/18yr7oUOF16SlHszkwVpGcqqYBQOAmj/eUdorATf5Xg2iB/BUliEfgnd3S9g5TwdWsB3fQi4YSwyfBwIG1I9k+NLu0baI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772469725; c=relaxed/simple;
	bh=fzyTAZoAms8ubILlSXFYO/feFsBjQ6umR6KKuhEg7Jg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pcEZu2dD8/gd5jEu7B4ahpaNEo4ELvDQ6m54S8+GQSd3Tdtvxp0GQjovxnTlAcmrv4i3Xg4dtPTw+YUprsx5GbCCOQVA5MqQsyYSZSNBmmMNxEDnLT1vsoAxZsV7rYt6qxyYMx6nqmXH5z+NZNCknxCcAPB7wQcotvKE9mFWJgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Vm0DKXqS; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8cb39f64348so460088885a.0
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 08:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772469722; x=1773074522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=drkLnu4yhkZYRl79HLl0Utb5lWMRNlqjOs/rvTbFa7w=;
        b=Vm0DKXqSM4vl/aDk+RgLzMgURKPKhs6whtcz7fbmfan2lemEQEF47TYbM9FpVSRaii
         76sG0yrCshjp8i2mDzsEwLALeG7GHH0iXqAZYXClhklUmABnYfKyTurwSQY5kyr3nQEK
         xRfuHZOrycNqec/ObAFiE8KvIs9t2DCjmsV2O8n4J1ZD/Bba0vrSrfEulXaW7n39BFT7
         S8//jEC6tZ+pGb8IcWz5bUbdKoiCmLew7zQW2XUdVfmk7YwR9MbDtxkEcAO6NkRwPB75
         wATp0BaoR887VwwfoTuk8go2HxW59KRicDwWD0CnVx20HOPv4PAHhBxjjRZJ+aGKlVNt
         cuqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772469722; x=1773074522;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=drkLnu4yhkZYRl79HLl0Utb5lWMRNlqjOs/rvTbFa7w=;
        b=Rn6tX+e4INl9ljKjB34+I5PkdvCZ916DTSZaIgF/JpNG6BqY1dfwF5mgS/2fO0gVZ+
         Im4457OuGyd2thkrn5B1c/zJ6gh7MSqXGgQ7BjXnMVfZdBLprWPf3v2bAD2S95z4Zhtt
         EB12fDqG3NYeb7FnphcFenQJykFa9Lj8fJNpQYx/xpQ7neMbkGL7xDurwDVuv6vl3SsF
         KYPPj4IuqFQvjaJlQzxfYWOQNMgfXQ4NnuDvM0qNilLMoOYfLUuU1XfpG1u1PQ7TyMAB
         LpQ7Mkwvzcoxf9+hffXpc2zc1l2Imo/954ggDuTVLIr1Mj03XtIHBCnTIgshanMNpooi
         9fAQ==
X-Gm-Message-State: AOJu0YyVfs/aVRO7OcAGIDwgAOvZhI+wCNn5jzHp8ukev6VYidWEFaj1
	lucSIfnJVx1N0Y4ca4fO7pkZnBaIs7FN8W53CXRdyGHp/ugehRyrPWMMjf3H1Abkh6rAgFJIjf5
	vM1Ts8s8=
X-Gm-Gg: ATEYQzyLOo7BFO7kEk3WYDJHjDjIJ1qyKdC3UZLgmfqLDZtpQ+kxsc9VUaMmXoCBZ6S
	fBYzG/T1kmBHP6NfW5MNb8JyUn7P1rejAoHMICzu6iNli+JjxWb38oxl2vBNQejijh6p85vw/Ua
	NwC7oEFj4e67zsOhECEOxyFCvmplr8G36UkGhUmcEiO8AZhCPnybzXpsmBO5rox+Sl6XOjVg4kM
	YAfEgyA6m1axyc9LuVAjoaatAFuuZHX0KnVffEK0IAXt94GDKHruAViIResYmQXKdWlY9yIgX2J
	phIMToVzZsjSB3lLXLCNYzthmzXW5f9VatXNxabABICIOXqgquViFAbwUOc56qcJ+whcNwLKFwu
	I5G0XIS63WL0s//+Nrsl+SksvkHpP5hn4VbIUt202QvyKGfGAe61O3wyxKPhw3QI+U/JYN8kzus
	eGVNSvxqJgqHA5cRSRncAJLueXS8OA0iHrl7ITWjKtqv7QZhyqT1BCHZdlBUEBDXlaWEANBm1EV
	bs=
X-Received: by 2002:a05:620a:29c9:b0:8cb:49e8:d460 with SMTP id af79cd13be357-8cbc8d70dcfmr1540436185a.5.1772469721717;
        Mon, 02 Mar 2026 08:42:01 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf659210sm1177020585a.8.2026.03.02.08.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 08:42:00 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <652575b9e2b08c08a32537f27b398504236e8be5.1772469585.git.asml.silence@gmail.com>
References: <652575b9e2b08c08a32537f27b398504236e8be5.1772469585.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests/timeout: add abs imm timeout test
Message-Id: <177246972050.116007.6551653266165193984.b4-ty@kernel.dk>
Date: Mon, 02 Mar 2026 09:42:00 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 7306D1DD3EE
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
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12518-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action


On Mon, 02 Mar 2026 16:40:00 +0000, Pavel Begunkov wrote:
> Add a simple test for absolute immediate argument timeout.
> 
> 

Applied, thanks!

[1/1] tests/timeout: add abs imm timeout test
      commit: 829c805c7285c31d099166708c92e459fa1bc397

Best regards,
-- 
Jens Axboe




