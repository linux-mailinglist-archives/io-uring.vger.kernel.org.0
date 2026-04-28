Return-Path: <io-uring+bounces-13162-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GNMGO7Hm8GmoagEAu9opvQ
	(envelope-from <io-uring+bounces-13162-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 18:56:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 924C1489707
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 18:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 56703309B3D7
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 15:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 224673BBA18;
	Tue, 28 Apr 2026 15:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="nUGBZLsa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F092C3C197C
	for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 15:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391200; cv=none; b=X7t8AsQxTPZiYUD2cbTiG6lquw6X77jBYGY/0CnbmZINKonmrm6bRQSVmgJfxYUXUvFeknDzn1JrtEBhJxib+GrjtWfMR8Qc61wuUGqSBtVdhRJVJxKcK4xXegUstc+zMyKKFv6gsMDDIiGjOYfv632/XX+xwMzhutclu5zIopA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391200; c=relaxed/simple;
	bh=ax1up2jNHblRYSRVv5kYKeYXkNcEPxQhD5YiWdUa6n4=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=DQsl8bmj0UXArLpG+duOqt8ObsREJlBHJVevWVYRshwi41yQO7NMAGJ0sqQZbuu/7xeyjItdGoNVQEzJujTYsaTH6Edb9XCOpDGiYTvPZ2+QrmxNM1COm2Q+mdt8aajyeuhyBu4o6lTbX7FYnlLHQQyhN0tOnAwggg7CGgG7g5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=nUGBZLsa; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6949192b843so3233782eaf.1
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 08:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777391196; x=1777995996; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wo7ihDu36qMHN1MWTJpk+nZzOmgMfNjhkF/rJkMCHQM=;
        b=nUGBZLsajgT9foGAxQDhYvnRdWRlOPpoPDTyQejcYcHHYQpuZ4U+3HdxGt6aYyUbEe
         WUIUaDgo198yM8jQBMPExFxHgfCuohHuLvg1Qx+dusedF3VVkFD+HgH/KJutdnCiJ26d
         gKpZ+Xzau0ioL3uS12NmNyIqk3x9kSSwM6WWZn4Y7aGryrBij5HUeg75eYd2wRZbgy0i
         Devf2nMJ20A/icGNkZyoi3IT3Z5rWnr6CZ6soxK0xvu2u0WUUBZ7tDLqTb7/zpB2NerV
         ueY4+tzP7wmVqdF4QKsXgUVSmSFFidnYSQwwU7QhE2tHe7wQGA2X4OzMa/jce9VRmcpD
         BkWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391196; x=1777995996;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wo7ihDu36qMHN1MWTJpk+nZzOmgMfNjhkF/rJkMCHQM=;
        b=L+u8BP9KbyAbAXHCq3AcSZNiiRZm/Qkct2JdsNeAN8nJzir2OGrzHqwU8pVLnY/BoM
         q+qhQW7FqXTgC6kldyREQqjVeeToVKOAvpqYz3d9kPIu5VWu5Q5uHZVtvk9B+XIOa0c+
         1SVZpM2svbDyczFQ2vEVFsg/voj4vDM4NAboDmOwH2GwjXN2HbU+BLUArVGkxx28fFoc
         3EQqI8tLwWcHpNkIqkjtsaLurmuScuvzYWc4iln2R1650iAyql+3S6MdymAGu+dp+Lx2
         wzC2wXBlIRLUKfYOFlp659od3h756jbZ4oacIWfjNMvHceTn3Gg3LcoKz65Gtm2/xiEO
         mVzA==
X-Gm-Message-State: AOJu0YwS5YQSq9dny5gfGsXNqN+acN9wpuigW45S0WcSwcxzFQ/bjyNK
	eH5Gmcvf29MCnRRTj+IIWcK6NI7ESY1lGvEGvhSTN1+QrtQz0h7MWs4yZZe3VzBBWSn580WW7x0
	9mVCuQ1c=
X-Gm-Gg: AeBDieuZztLpHOuqp3oG/qUpFjD7B1UHNDqK6T81n+L+OQ5w2HZ914KSoZHgeaEcJ6T
	uKK2Wpjf5iuHHbYdvQXZbtVsu34FQBG4ZKiW8V8X5AGe3JMfupNdQucDChBMwq21XsZrAC/XDJJ
	vXyglCWyVjsawbEMTKX9qfjFUDHe7hSSHOnNZLKQUTul/CaKswB7JHyeCZlk5xbNy9ZmnXNY2pt
	97RPfI7lWYbMjjmvGGJv2zNedo8zpkEL18typnx0c6zWvr2+9+Oa+wtj+1/1067ZSlgLDm4/qNN
	hfwcm9QrW34/auncEaSxaomTP4khXSNnVve5bpkmCLnfb0IhpIHKQWp+XiTraGp+hXDtzBL8YUu
	StyrKlZFpsrls2XUuuKku9vK+eh8zsjiiSPtnt8pK1cucZ92zAyQ0ZkXdnOGO2dH4r/aoKChDLa
	gVLJ5zrWtI/3A+3jSys3d08LUGYCFIbdCG8ds9KVOXT0UyLXpZD1AfUQNfEzS9uRozZj5lgtNx5
	3IlhR/I6YP0FZ86Hs8=
X-Received: by 2002:a05:6820:200b:b0:694:90ff:c769 with SMTP id 006d021491bc7-6965ca5288bmr2042398eaf.3.1777391196199;
        Tue, 28 Apr 2026 08:46:36 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6965ba73c73sm1681239eaf.15.2026.04.28.08.46.35
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 08:46:35 -0700 (PDT)
Message-ID: <ae34680f-4890-40a5-9d20-d99e719e9008@kernel.dk>
Date: Tue, 28 Apr 2026 09:46:35 -0600
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
Subject: [PATCH] io_uring/napi: cap busy_poll_to 10 msec
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 924C1489707
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13162-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

Currently there's no cap on the maximum amount of time that napi is
allowed to poll if no events are found, which can lead to kernel
complaints on a task being stuck as there's no conditional rescheduling
done within that loop.

Just cap it to 10 msec in total, that's already way above any kind of
sane value that will reap any benefits, yet low enough that it's
nowhere near being able to trigger preemption complaints.

Fixes: 8d0c12a80cde ("io-uring: add napi busy poll support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 4a10de03e426..8d68366a4b90 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -276,6 +276,8 @@ static int io_napi_register_napi(struct io_ring_ctx *ctx,
 	/* clean the napi list for new settings */
 	io_napi_free(ctx);
 	WRITE_ONCE(ctx->napi_track_mode, napi->op_param);
+	/* cap NAPI at 10 msec of spin time */
+	napi->busy_poll_to = min(10000, napi->busy_poll_to);
 	WRITE_ONCE(ctx->napi_busy_poll_dt, napi->busy_poll_to * NSEC_PER_USEC);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi->prefer_busy_poll);
 	return 0;

-- 
Jens Axboe


