Return-Path: <io-uring+bounces-13143-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLxgIvBL7mmusAAAu9opvQ
	(envelope-from <io-uring+bounces-13143-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 26 Apr 2026 19:31:28 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CECA946AAC3
	for <lists+io-uring@lfdr.de>; Sun, 26 Apr 2026 19:31:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D7163011849
	for <lists+io-uring@lfdr.de>; Sun, 26 Apr 2026 17:31:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC16023370F;
	Sun, 26 Apr 2026 17:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="QofQipdk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5540B2264A7
	for <io-uring@vger.kernel.org>; Sun, 26 Apr 2026 17:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777224684; cv=none; b=MQZCK5NmSZQB/L9L9fNvX6lR1TQPy/F6p/t0bjv5kHF5q/4gWMHeAUQry4Tls2KEKk2ICPLgPldxoIl/2FVTJ7J3z3c5KBf4nzUEmSFc/iefvnIP7dzG0Y2eJiWZNUVquZ9jM8/iYvSXzipFsRVmyCL4fV3ehWeXuqKQu3MqMG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777224684; c=relaxed/simple;
	bh=BpzEgM2/+wh+El5gqvjBzJq1Q2Ul3PcmCQt82Dkj+IQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pdTRiM6cfAchT8tVMVLUm+cRZjN9ZYalA3huO/GXd+t05YiNeNW8dyJtqXcCaWwjQYzMu85XMlJ7Gcvhf9raGQ00dB0E5REOGQYtIjdBHYTgSHu0RKi8tWB46WiLNc0WczaHiQAmNFTRjEBIxflebC6Z3q+F8pXH1JDaOJUzGWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=QofQipdk; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7de4a9cb8eeso3450766a34.0
        for <io-uring@vger.kernel.org>; Sun, 26 Apr 2026 10:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777224682; x=1777829482; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GZO64qVsC9xCB+2W6fybYLXw/QxsW4FITHO19+99+fQ=;
        b=QofQipdkZJnqWMXIZcl+5NfCUAw2TyWm41gts2Hu4404HIYgnlPubo9yviyCRIBk+B
         btRntqnmXCJmj6ESpACPvYREr7tQL9q92/22UwsHYn9I5S3QbTg4f57iICxIJzwlwDDs
         esSPxgFBx/wZzyWMPqoi9mFP+7We+FTH3DeTe8hkiEDrbj8ZNIVuvWbt5snbPUROKlSs
         J9Nw4IBgtsbaXD8s+IN+SqVG3zFOhOOwm7r2AU2ComK4h335sfVPIeHMciWlvoQePE5d
         VbXstSPS7fLUmygOcHvsHHUXy8EPhdeK7DRmSDGjx3wB2eSyEBriK+Kvwmgq2f4Pd3Zt
         9uTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777224682; x=1777829482;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GZO64qVsC9xCB+2W6fybYLXw/QxsW4FITHO19+99+fQ=;
        b=g5+IpWrJh959H4offCCIcoWfgmVevD1BRhuIaRiCpGYkN42GZEN/gYx/5nVuOgi1O0
         m4J6VDwFVzWjhKmOl1t5arnbG7UdobT/Bm4Dm0WQS7UjJDnjUOnKboS7FNSE4leagnGd
         6q12Df+TmOGcV8bxlybSF22vWgzSiPhEWP/FEixM5NDCLEwro2gh5zbXzIS2/l7jqGnS
         iwL8obClE7u5hFyiUCzPzBsZEud2xcYy3W8YeEp+Sb3OUo3+Q/Qw1XScraJ5b8ocRgC+
         ltbGYhZYqATC0inUrZTUHJ5pTJDFDExGZ0/aTM5ZqBzna/hNV2pDhcsyLF/aw2yHYiTi
         2brA==
X-Gm-Message-State: AOJu0YwD8x9kUlnL3OAiv0WAct22XaTBbK18sq5UbCqnw+eJlKVYvsuP
	iWWI0zoC0JPJlgEp606JWBp6QBvgzNytn+FywxkNlNg25QTDjgtoQiJ9uJSWyGNS7jeJm0GeW9g
	HM2R0DkU=
X-Gm-Gg: AeBDieuc93CdDCCEDExbrUI6F7V4G9ZrNKE6DoaPR1vt1Kk11j2ObH84Bq/2khnPxYw
	xfObUwwdpX3bEdC/ZOPuRppdwpaTQxNhKXNwejDS9YLdBX5860CLVVbNgg80F2dDv9z9ei+5Mr3
	ySTwILEggNzMgRDXW6faM9z6GTrM3eT8XmWU54EEmHplHjg2vZ0KuF9jBEEmodK6IfIaR/KsyqR
	TmIunDMxzNHuTE5km6r/bFIuPMOKYMy+JhkyQPb4qXuwJh6gkZlJgxB42hijlZIyHcyJ3HMylOH
	FNCBA1I5MDViUgGfMXcLrSwHw0AT1V/SZWI+9m3L1RE+bpVMyuBshlVFyCP53ksr2CC+mEsMHmv
	e2Ps9Zm2nPJo4a+EU25GNb/zJ3Lfxzf8NM/Lh5UBJHiv71IdKyOmgS/z8vquaFtdaxP7ZiG0zDt
	p4N58/FpGgUpu0NGnUppyDEm+YAXAJAIOch3gFMjoGsv/dKHfHHq7c8DB9vUoc+AGUB1OmpKqL9
	w/wBQruKyBtrYg=
X-Received: by 2002:a05:6820:4b8f:b0:684:2b28:f9a6 with SMTP id 006d021491bc7-69462f451a4mr21835313eaf.58.1777224681947;
        Sun, 26 Apr 2026 10:31:21 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-694994277a4sm10845980eaf.4.2026.04.26.10.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 10:31:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Haiyue Wang <haiyuewa@163.com>
In-Reply-To: <20260426112732.300165-1-haiyuewa@163.com>
References: <20260426112732.300165-1-haiyuewa@163.com>
Subject: Re: [PATCH liburing v1 1/2] tests: fix bpf ops build error
Message-Id: <177722468044.1676227.12840209959534437092.b4-ty@b4>
Date: Sun, 26 Apr 2026 11:31:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: CECA946AAC3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,163.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-13143-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]


On Sun, 26 Apr 2026 19:27:30 +0800, Haiyue Wang wrote:
> If removed the previous install by 'rm -rf /usr/include/liburing', the
> test build will fail:
> 
> make[1]: Entering directory '/root/linux/liburing/test'
>      CC helpers.o
> mkdir -p output/bpf
>      CC output/bpf/nops.bpf.o
> mkdir -p output/bpf
>      CC output/bpf/cp.bpf.o
> In file included from /root/linux/liburing/test/bpf-progs/nops.bpf.c:2:
> /root/linux/liburing/test/bpf-progs/../bpf_defs.h:9:10: fatal error: 'liburing/io_uring.h' file not found
>     9 | #include "liburing/io_uring.h"
>       |          ^~~~~~~~~~~~~~~~~~~~~
> 1 error generated.
> make[1]: *** [Makefile:387: output/bpf/nops.bpf.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> In file included from /root/linux/liburing/test/bpf-progs/cp.bpf.c:2:
> /root/linux/liburing/test/bpf-progs/../bpf_defs.h:9:10: fatal error: 'liburing/io_uring.h' file not found
>     9 | #include "liburing/io_uring.h"
>       |          ^~~~~~~~~~~~~~~~~~~~~
> 1 error generated.
> make[1]: *** [Makefile:387: output/bpf/cp.bpf.o] Error 1
> make[1]: Leaving directory '/root/linux/liburing/test'
> make: *** [Makefile:14: all] Error 2
> 
> [...]

Applied, thanks!

[1/2] tests: fix bpf ops build error
      commit: 49f1a2ab7833a3563329fd9a86f58f84875d57e4
[2/2] .gitignore: add new test build output
      commit: 4330d09391470154ba4e453d01b1cf2f1f5ef32d

Best regards,
-- 
Jens Axboe




