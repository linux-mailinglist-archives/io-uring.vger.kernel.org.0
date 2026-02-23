Return-Path: <io-uring+bounces-12364-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qN45NXBcnGmkEwQAu9opvQ
	(envelope-from <io-uring+bounces-12364-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:56:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B35081777C5
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:55:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6182230B2A43
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 13:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DE8D2512C8;
	Mon, 23 Feb 2026 13:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1MzizZp0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2A6246BC5
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 13:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771854441; cv=none; b=KCx8H6i6c0RJsqoNFD71mmF34e42kjqLHHmkwWXFXmPZxSQpMK4UBotM72dlVEBYbOVvtCgrteK5LM3D3PsqF3XjlE3Y56vgYNJh7sR98iLPRKrGqxG6xixiBakqQDyakJN/coDv0yWdTuYy8TeZ4nmgqUekeZ+aDLPImo7gjNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771854441; c=relaxed/simple;
	bh=3PLiiyro8yxnF1ucBPQWx1weRKwZZyFKHnND0CognP0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=R2M3tZ+zT6HBuSRGnepEchZu3iag8B7oH2Blmpwh2OEjrgcol89uZgtfT1ITMu2Z0/DQXlsTMIkyzV2juXka2nEOtfc4tquFWQgIsa5sRHg2oBtjGC7xsCRMPz29e1L/C9Fr/ITBrssCMqYs/g4hMAzahmrEJ/99JTqMk3ACxU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1MzizZp0; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7d195166b2cso3015726a34.3
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 05:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771854438; x=1772459238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oFfrLBaUt8mlHfmTCYXd4w2GJ2WXCmWCMom4vLxW0Zg=;
        b=1MzizZp0xySj5IL2/VVWFwRPxQyvem8fm4iiwNmqJ17iQ/SlDJakCGEq8w4WIQB3Rh
         Zvodc0jcT4toCHSVWsJZIGJPmM2XmtKy+1uBfllgR8fTyoXH3Ubsk0vC40+mYlGOA18b
         MbdySlU1QcaCEA5iqdGehW44PDEeVkeeTEGickVNKgQoWiWBAk8PPp4TmDhdUEirG3oy
         TxSEXCbiCNViA2Bvnj+KBQi3Jo7+Hmxwy7CcCgrfur71YFNjjUb2CGNJbfMSLZvFAqAU
         0mAdGuwsTfzk9LBtElUUPxgHErkOp9/vFa8bsFrwiMzyHKt1SdtsZloC8kXR2sOnFfc9
         s4Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771854438; x=1772459238;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oFfrLBaUt8mlHfmTCYXd4w2GJ2WXCmWCMom4vLxW0Zg=;
        b=K7Wd7w0Ntd/Qf/9mM6yKI9ANzb6367hWOlvpEOugQq0ynzLj/2M7PmqJUqKSxEP8kh
         BirPt2BGB3FPtcwNSQJDFJXBsxbJwsY7vfN2vJrfgtVxg2Mv4vuI8e3NdyIMCwASED0T
         ZA+k/TMeRvvDoJhTcndEAAR0cjcH4j02DcjO2WVp4VyQ7oGEbQLTPL9jJ4PEdwRnvIY1
         2RBM/iWAz8r5DrQA+K4Es+vD6THYX82yIozJTWYDjhlV2mjpSmPOi1e4hQuFv5E4xGC6
         LpYIMuIZRc/RUL3FKBlqEmKSogmVsogDW5XlzJXwUoLN6UTfqfL5Zn7XI6ySMMEoHVqR
         8crg==
X-Gm-Message-State: AOJu0YxpReaXybQT6iCy4iqUXcz4BfUGEHtaR4HaUGNAhkL2fCpqZIan
	p5N3v6rLqjYlSvASiTMXROqODxpn/qF3ph39CtBvrxrkAFJPwZEM4oLphk42bfsM+yT95fLlC46
	LT/SeSREG3A==
X-Gm-Gg: AZuq6aK2EHYWNKZWXoN1i9wc0mofyYEXj4d/vb/rXBA5WpVFzL2kFY2RUqNgkmMM/31
	WCmQRB5HpFj38xPVX4gMgJBXVYEY/WxY3vEO4rJCuRNljvxfAIJVY+OGCEH2o916mLBYDNwsJwE
	sWIiNKGA1H2RKRRze4N+MQzYKM0fw3+aLTRVvs63Rt2oMGDxVAoRbHwpVA1Dws0A9hnz8u0jh+a
	45htfyjRnRqYyJ+BxvHzyqUF4s1da0MoZ89SQddjhikFec4QSqawVwnsUegOi9R+YwWCAZRrQfT
	c2JQNRonlXos+Q+6r+3ppGVHHJf4FgkG4XAdvLPNbsFUTfOih3EQcB+cIMUx6SlJbZNfAKlB0YH
	aDW1vS79sEI0qF6qiHV0DBU3udLGS1cpt+TKNbnuEy0l7OGGSpAjamtHPVmcCxFphsVYocRIjCT
	EUETGjmWij9zfqkFc+izZt/M65PMuqu+UKL1Y8c9pBCcxf2q6MIdhpw3+DWWQ6QOhEwxAmXuUCU
	vQKJonI24UQsug=
X-Received: by 2002:a05:6830:6112:b0:7cf:db30:bb5f with SMTP id 46e09a7af769-7d52bf53132mr6691800a34.33.1771854438699;
        Mon, 23 Feb 2026 05:47:18 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d52d04dadesm7246370a34.23.2026.02.23.05.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 05:47:17 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Dylan Yudaken <dyudaken@gmail.com>
In-Reply-To: <cover.1771240334.git.asml.silence@gmail.com>
References: <cover.1771240334.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/3] deduplicate send and senmsg zc issue handlers
Message-Id: <177185443745.636584.13271111585602295059.b4-ty@kernel.dk>
Date: Mon, 23 Feb 2026 06:47:17 -0700
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
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12364-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	FREEMAIL_CC(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: B35081777C5
X-Rspamd-Action: no action


On Mon, 16 Feb 2026 11:45:52 +0000, Pavel Begunkov wrote:
> There is a bunch of code duplicated between send_zc and senmsg_zc,
> let's consolidate the functions.
> 
> Note: it's based on top of Dylan's patch removing buf/len accounting.
> 
> Pavel Begunkov (3):
>   io_uring/zctx: rename flags var for more clarity
>   io_uring/zctx: move vec regbuf import into io_send_zc_import
>   io_uring/zctx: unify zerocopy issue variants
> 
> [...]

Applied, thanks!

[1/3] io_uring/zctx: rename flags var for more clarity
      commit: 7e401209e5c2c88293798ba8275e117b994669ea
[2/3] io_uring/zctx: move vec regbuf import into io_send_zc_import
      commit: 694fd02b36056400ab4090a741c2b52c14d167c0
[3/3] io_uring/zctx: unify zerocopy issue variants
      commit: 80435d1743ac33199debcddd4df511ada79bbe8c

Best regards,
-- 
Jens Axboe




