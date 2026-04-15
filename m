Return-Path: <io-uring+bounces-13052-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8OfzC1Xx32kCagAAu9opvQ
	(envelope-from <io-uring+bounces-13052-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 22:13:09 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A1327407939
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 22:13:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 97F253023045
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 20:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D383859DA;
	Wed, 15 Apr 2026 20:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="dp6Fvy8T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EF130596F
	for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 20:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776283986; cv=none; b=f39ygN0Whe3NHQSM/El4y/6l7OsVSiSRr9kiRVC+3kxUILXM0LrAuqDRDln066bN1PTV4gERqfhCabhyhK9Bhw+fVwXIQ5PRUTSexr4PyvBQbcnxvgC1l5/aa6NRnKa6Dx+dHbSbGQEdUZaQH87KJZm/CEdTeyaAI+rgXZsB6ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776283986; c=relaxed/simple;
	bh=m/50Vv9jb8nk9JN74CQTCu0XHs9QcTwiie/fH6KvtXA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ig8jQJTFPJz0VE5Zh7itWcLZr5de/j4ERBGWguS5sBm0ZVmdmN33EWmYD3hHaFAW1+Cb9aYhnBYcH+wJwKp0WwNVncGXHlbQTy3UC/6DicomvG1sLSGKc6ndyTvx2KplEMsFtL85zdzEnmX6MaQTY6SdPbe46L3lwwnNufroKZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=dp6Fvy8T; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7dbd801138eso3344207a34.1
        for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 13:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776283984; x=1776888784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BFAmglKt809k5HW/rLBePNy87fQJE/Bxf9qxGQKlB7I=;
        b=dp6Fvy8TrqoQXxveDKCqZYafbMmY4HfTRuzL9q3Qnq+7zpuJNE4Z/NIFUz8qi15DQ2
         BezFxorr2sESSxJq4NyBSUceDbR3e2pxGPdzVBJ7wuV81zpkOplG/Vr37F3BkU+ZVR1p
         sJiktMWVYp4BP7zTnf2whX4G3BUfEy9qjjBFYFo+iEfOA63i8QrOaEljp3VdDhDR6bbl
         M+idpNCBweRae1tZPO4Xu0UJ0Hr3HozLmp5ta/+R/aBDOyOOqeQAhuT/idukDEMnlH8c
         OXGn32Off21rTqUd7s/vGRNnivp/SChgnH99HpioiRdm9Io2wct6SgS2runNWXUd4AY8
         kmkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776283984; x=1776888784;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BFAmglKt809k5HW/rLBePNy87fQJE/Bxf9qxGQKlB7I=;
        b=K7RXl8scKin14ujgOCOAOy1rrljehVmOsGDO5gtF5EuvUv624TSzbnv/Izc2e7CqmK
         UUUk93R4SL0DKTF7GIWle7PJtW3fLyyEXaqnkNG2R48nkVLy1E1jeuvswf9OWnyCXANA
         avD9kW6YRMsJjrBWEOjYZZWJZzdAX6l5tByDszrqArKC3EyHJKuhrfL1rN9LRw1t+Zhl
         paZtw58YPxb3xIs1Jwj4IiYAdb/sDwzFmLNPmddi5IOiy2lpPzOWHbJBBLWnt1eQ1is9
         oXEp5vk6O7djH6Wo95w4TLaRezfEe5tnAAzSuvN0/RQAfScAO/oF6lR5JVnjt6xzIrph
         x6XA==
X-Gm-Message-State: AOJu0Yy08jJBAZTTmrzKxYWyfktJymOtnu97y0R2zvXNq3E0qo3AIpv2
	PQ8r5kxtSmrVbd0Tv1BmEwpPACRB+4RTOCd/Bem0HltdCUEivAUCYlzlRNw+H1xEl/f2DL0Wutm
	Oni2s
X-Gm-Gg: AeBDiesQJ0xl586AfTX+Z7q2COUZAIJVSGAo+Rw8+T/MqMTMBV97+tQeBiYm3+4OnV4
	/+6KILu8adHTWFWadFwKX0B05yt6ZR2VwxjxKo592ygBA1EpVgxUrEqqAfergffqxUn0qQj2lyP
	V4BsmoDPKByT1dVoQhOmgP3KfJtBAR5D5easJmH+3mGNnKRmc/q/Lv/roxwvR6W+BxZHS/uvJiy
	QZ86Cm/RV4aEeibXgd5NsvwgcoXOQyKlj9pbpMG6RdbqJiC1VmYovAif6MX6OxzyncM8nUADc7s
	/0qGKa2AyOigtucSW6kLXhY3T5DNn6qXg8c1Wq5hrQvuX2mHJRD82dun/OSqPNTxwG7lSi+LQKe
	lE2tA/fMsmLA6jyaGdj3Lgvx2ieycMeBiKaV+F6amzP2vKtvWcpXKCw1GsW+a12K9ZOk8bpy3TC
	i36Z4yF26k0taJDEXpEjBhodY1j4bl/NF6rEjfdP/aua5ngnXYNcnrGaqbu1BRRR8b66HbcN1Wf
	+yoh41ZG+MtDPzusha5kKoNtgBI+p9ErmbIu6emS59t784nHJE=
X-Received: by 2002:a05:6820:997:b0:693:4784:56eb with SMTP id 006d021491bc7-69422d3bef2mr573135eaf.18.1776283984184;
        Wed, 15 Apr 2026 13:13:04 -0700 (PDT)
Received: from [127.0.0.1] ([72.170.223.83])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6932ba69701sm1577878eaf.8.2026.04.15.13.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 13:13:03 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b689b7956262aa53d37c0608c80a007dfa4cd06e.1776002658.git.asml.silence@gmail.com>
References: <b689b7956262aa53d37c0608c80a007dfa4cd06e.1776002658.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] examples/zcrx: fix just allocated sock
 struct checks
Message-Id: <177628398081.681988.8500486110124066651.b4-ty@b4>
Date: Wed, 15 Apr 2026 14:13:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-13052-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A1327407939
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Sun, 12 Apr 2026 15:17:14 +0100, Pavel Begunkov wrote:
> The line in process_accept() checking sockfd is a leftover from times
> there was just one static socket. Now it's allocated, and we shouldn't
> be checking an uninitialised value, which fails the benchmark from time
> to time.

Applied, thanks!

[1/1] examples/zcrx: fix just allocated sock struct checks
      commit: 6dc578df309eb6958e7422ff7395e591c80ea7b9

Best regards,
-- 
Jens Axboe




