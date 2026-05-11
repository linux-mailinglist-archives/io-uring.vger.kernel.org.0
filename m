Return-Path: <io-uring+bounces-13266-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WAv7I0bfAWptlgEAu9opvQ
	(envelope-from <io-uring+bounces-13266-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 15:53:10 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D822350F5EF
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 15:53:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8636D3075C43
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 13:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573683EC2D0;
	Mon, 11 May 2026 13:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="urITWqWW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F273ECBC8
	for <io-uring@vger.kernel.org>; Mon, 11 May 2026 13:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778507085; cv=none; b=HqHZYUUYciEmUkUsUv15ugLV+GHpNjtULlKpf0GqXvpUPosERuv0SBChz9UqFvRvwpNePsa3RwhiDW1GQGE1lTNS8YRCYu77l9f3V8Dz3HlABAdcySXU3f483HYqn1WtVH+C+/o19MCKlohpz6uTBjjyZXAXdQbGS/jluxc+3gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778507085; c=relaxed/simple;
	bh=rnN0PqgXSM5FoJhM5oex7DTTFc9tCr65b7eTehiGT+4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hB8Bh7Ip4RH85iV1y75X54mAmtylhriUvsCOpXHRBlVHCZBGhhvhNQqs3FAOtpIZXJNImgtKL5zcH181btycqulQu7Co5vKoGsSX6ErAzttuBNbNocIGN9bq2tRPjLB1MnSPV+j3QyuLob8EXAR3Bj+YblAcWHIETQ5aWHLtcso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=urITWqWW; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-69489b43d66so1142522eaf.2
        for <io-uring@vger.kernel.org>; Mon, 11 May 2026 06:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778507082; x=1779111882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SarUqNBJNBkN6gQnKaXr30M60v93IRrFQf0+oOOL4A8=;
        b=urITWqWWdGMBNqWKywvOCK7LgDNd6RG4tFy9lmENCG5gYgMfg/7OsVP7aGoonTUhIM
         W1Yf4nOnVn23pzNLLsaTcOJnvvml2G47FL4aJYD0dAJqLckNQcGMgMnmQvOW+GZh93kn
         eHuXUr8wHWa3xIn/IdpfR8KxQcEaL+CHGz/Y5TbZTJSLW3tPupFuGoq3LVVOujdYphA/
         Mbwoohb6Ud5l2xmd7hidCglB8wj26wySd07X0ixMyNM0Kgm8HrJvfYmlUmd4ebk04ysm
         Oq3QEhFpvzeyhIVs0IEnBFjiHPImsya3SZ8TEth8tOBSgnSrwDT9lLxdZU75Z6PIWuL9
         Wl6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778507082; x=1779111882;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SarUqNBJNBkN6gQnKaXr30M60v93IRrFQf0+oOOL4A8=;
        b=SsICTnlcQfq/ie01/OMEKhN+DskU0qdMvfEHxOBNoXHjbQR1NaaQ+xWEFyIpmHGknN
         5kTlKz62LAeXBg/q0jILCfXB1F4kK5toQQoMvHTYK6OBiX9irP/j7T0VnCkVurz6MXg0
         zpMznqyJiZto1LbRMG38H8V4mGF/LI/eX+ixEJj7tDnhpbMqs3TzbZN0Pm6MRJQSpAVJ
         09KzHhpAiAB2UnVd1xgAW9RXlb+t7XEWEbeSiRAwJyZdcrY5sbb4YNLTJZaKH7OpcsXJ
         Q89kS80uUy0cABxg2sv8c3/uwuvB9Kq1FQ+Yj0MBZpt7EsMxKVPx0vaTbr0LUJLW8cGo
         UoPg==
X-Forwarded-Encrypted: i=1; AFNElJ/Lxon5Lo08y7EKF1s+MquyLmuHP7/Di3ZPMGK9tRXMOK2kic6Edm8p7mvs2uUry3UFKt790BREbQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/6pCaeOqFeyBUgkv8RzWYEjuXKD0GyRUdygJ3nnfqbQhjsEbr
	SLKgj9sOPGI5GJdkNxUV/AcNXTZJyxN/fl99ZEMmX2WJJdofcSosTT3xqx0wbTM8ji8=
X-Gm-Gg: Acq92OHD3K+c40aLB5EWmbzw9tGlLNuScuJyZ1/YBrd7zsnFpgR1Ba2Ny1m1aVLboW5
	p02BULVdMZSrOg9DdReROpNkFb25zS6gIhVl++a5fzeXfQ9i2RB2ts2bPWqEF21/ofans8Tnmq8
	/Bv58zFgu175fi8ovF6sdR6J2nszIwnmGQbWPv548BfkLOIPc5IO/98K0e06u8UNab2mHt/9tnX
	2BmkpIMrXsvZ5NNV1GLQoiDUxS2cCpY6c778mvTkd4nE1JW2rqtQg0w9wzWfv9e6oAh0domjiQO
	kvTf2finO/1G5UaTpkNoHUpLjq1SKkwo/FHrJzCrrxzBSQpwOxSFz+R906twPcUYoE28ZtZLg94
	IWgVT0CHEpX3jJeXvZqq/krxmhaKetLwcrRU98Y/zEqLDzWEOykwdXObPKwpDiaf8kqXbe346XZ
	LL2SEiusIoxba7CpRmKs+aJ72a6Gv6mm3FW4ATOTawGU727Vsae8EOymnRz9mttq4JzlWkxNdb8
	a+l
X-Received: by 2002:a4a:e845:0:b0:694:96ff:d50 with SMTP id 006d021491bc7-69998cd5d94mr12667505eaf.25.1778507081805;
        Mon, 11 May 2026 06:44:41 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-435571099a4sm9503962fac.7.2026.05.11.06.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 06:44:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 Maoyi Xie <maoyixie.tju@gmail.com>
Cc: linux-kernel@vger.kernel.org, Maoyi Xie <maoyi.xie@ntu.edu.sg>
In-Reply-To: <20260510084119.457578-1-maoyi.xie@ntu.edu.sg>
References: <20260510084119.457578-1-maoyi.xie@ntu.edu.sg>
Subject: Re: [PATCH] io_uring/fdinfo: translate SqThread PID through
 caller's pid_ns
Message-Id: <177850708099.123140.3578529526483452622.b4-ty@b4>
Date: Mon, 11 May 2026 07:44:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: D822350F5EF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13266-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action


On Sun, 10 May 2026 16:41:19 +0800, Maoyi Xie wrote:
> SQPOLL stores current->pid (init_pid_ns view) in sqd->task_pid
> at thread creation. fdinfo prints it raw via
> seq_printf("SqThread:\t%d\n", sq_pid). A reader inside a
> non-initial pid_ns sees the host PID, not the kthread's PID in
> the reader's own pid_ns.
> 
> The SQPOLL kthread is created with CLONE_THREAD and no
> CLONE_NEW*, so it lives in the submitter's pid_ns. An
> unprivileged user_ns + pid_ns submitter can read fdinfo and
> learn the host PID of a kthread whose in-namespace PID is
> different.
> 
> [...]

Applied, thanks!

[1/1] io_uring/fdinfo: translate SqThread PID through caller's pid_ns
      commit: 3799c2570982577551023ae035f5a786cf39a76e

Best regards,
-- 
Jens Axboe




