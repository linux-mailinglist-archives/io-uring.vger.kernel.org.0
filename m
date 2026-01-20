Return-Path: <io-uring+bounces-11845-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +N83GE3fb2n8RwAAu9opvQ
	(envelope-from <io-uring+bounces-11845-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 21:02:21 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 156214AF3A
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 21:02:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id ADB9B66CA06
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 17:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9290421A00;
	Tue, 20 Jan 2026 17:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nr09jmJB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com [209.85.210.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAD43DA7FA
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 17:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768929896; cv=none; b=rsC4qNmFnJWghPvuU0KcTmybi/I2sbB4rJJ4nsKTPhad7qWGBNpQZAAcRz8lpOvc2nYQunheL6tYl0NaM7UZU8bmZg+RxiKfGE9wh6eIeqT7PDwSVngCJnBLF2HFI26m/aE1xgM3V7EcbOo63cXzRIa6aRFx5a1gTqk+DU41At0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768929896; c=relaxed/simple;
	bh=CujrEw+cKm2GKzRdfUbANKRittHXfLKMnJNavHCF4g0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=n7DDUT17ZtuBdm6/2X8YyFk8rcnQyuNzZPXU+6yYY2fKmQoc/KTgFBQkqjhLiJVSWRGZkrDjS0fqm6ZDQgvgmjRrOP2HHKpUe7K2GAZxKg+Tz4c+AEUFZKUZHPa/pwYgVmFHH730Tis92i4tsOnmyKIABVw1YHyQfex88ETOjKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nr09jmJB; arc=none smtp.client-ip=209.85.210.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f65.google.com with SMTP id 46e09a7af769-7d11e2ee188so1880663a34.1
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 09:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768929894; x=1769534694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sa8+4KO1m/ufVgLZFpuPOgrMf4fnNhj8yXe10/VofOY=;
        b=nr09jmJBWfgxEC6vLKKvxIjyC4/HGPlMDfjimJO3foJMauqNpDNzMUaMKLYRR3YSsD
         EGIy9OrXBSNiOxJXIoXqNhZ6UqPdpxmakPAIrJB1VF7Su+RkWaLjsirpfa5PsYLv1eFB
         sJ+0qTcKWnJYrbCe4WN3s5BKXke55IGrHJprjCEQIIU52VbCnvnMqardffvSFAA+vf4m
         X788vT+TuV2N/g17b1jz5jfU0IiEVcfGWklJg6EgofU4kwDnf78gaWNAkS/CpMA0s2fG
         n+EQne9L9k9yYyZVJW3U+oZjnSd38no6x8HdSMQCud2SIQGBRFmzGrSwPZXZpnhhLBQq
         LUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768929894; x=1769534694;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sa8+4KO1m/ufVgLZFpuPOgrMf4fnNhj8yXe10/VofOY=;
        b=rvsyxhlCKgGx1sU8x/4kxOTtA7uK6gfhpMJDrboAgV1UgV8GhWDjvvFVFRTU4V6OSg
         w83tY70uQh6fhRFZM7AepyU7fh/PSmO+B3c9GAEqMVyoDLxe3n6gJYu5NwcCp0KSqACu
         z8tnG8tpICdGf+EWnvXyIr1On7YHJPA/XSXlP1hgoQh9I/e3zrSU24+72tXFbb6yCecp
         jfHNzoR2NEAve7lY6Rf7ivuXraTYFkEsYmKAGtDm03/lvYhzQn3tAxDz/eGIK64EZG4e
         soJ0NATQst0FLsq+fmJLIYDirea0Oaa2oWUcpEzPVL0gHu1PC6ZZGaCTdzQQMxyngHBu
         qe+w==
X-Gm-Message-State: AOJu0YwlxcxZHQKv/pDW4uKL1dFH18O+SnRSd820vfTiUb12RxqVsMX+
	MgnEmeftI9DcxncVVXH1BZ8DiMHSlDDe+RIr8yhtd16641gB/rrOkjGwy2qihT2Hwh31iO+KEUe
	QQBA09pLBlw==
X-Gm-Gg: AY/fxX6ljAsDNu/JTjmjbHuJPTTJa1iBGFVlJ75A8Ug3g1cXcJXihxsO1XtqPkhbUDz
	st48kgjjbIrO5q36LuQAHgwvymKuF7YfMzXFpGUkU/Zb8wzPmzWJIsQNs4knljHLyIIjb6m/rVO
	9AZE2dBtAd4hKHs2RuxX/I8me++5kmb1JuzCnkgwh4+Pdx12JuWp7Bpsbb5p5gw4l6X2546XOsm
	xlw9+xUKf3p43RFbUpcvh33Y11i7zTCtbdbcv3boDLWq4SISQktnBegjwgrXTTvmo1YZslavKal
	w9HPuxq7uHzpttW/zcNXCAPBq5XjmDdCn5e4n+ouEaoJ4x2N5wTmj4oExsycVi5qn4Y8j94TW3e
	1MddQqfXpWF4sFSHvKnP8NjT4NKahIR+r4a47yVESfXjWno7BfgFD54oGX4hQYoTj9avqUxom1e
	fYn3lSfv7aK+I7sIQ2FPT/hwhf/MqvGcdPY1dxVAnAZOhTOVDS5lOcZim2Cg3doSY=
X-Received: by 2002:a05:6830:7006:b0:7cf:d822:37fb with SMTP id 46e09a7af769-7cfe029c704mr8422971a34.34.1768929893712;
        Tue, 20 Jan 2026 09:24:53 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0e9209sm8932389a34.8.2026.01.20.09.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 09:24:52 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Keith Busch <kbusch@kernel.org>, 
 Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
In-Reply-To: <20260116074641.665422-1-ming.lei@redhat.com>
References: <20260116074641.665422-1-ming.lei@redhat.com>
Subject: Re: [PATCH V2 0/2] nvme: optimize passthrough IOPOLL completion
 for local ring context
Message-Id: <176892989230.1994823.2473484633888931536.b4-ty@kernel.dk>
Date: Tue, 20 Jan 2026 10:24:52 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-11845-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCPT_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 156214AF3A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Fri, 16 Jan 2026 15:46:36 +0800, Ming Lei wrote:
> The 1st patch passes `struct io_comp_batch *` to rq_end_io_fn callback.
> 
> The 2nd patch completes IOPOLL uring_cmd inline in case of local ring
> context, and improves IOPS by ~10%.
> 
> 
> V2:
> 	- pass `struct io_comp_batch *` to ->end_io() directly via
> 	  blk_mq_end_request_batch().
> 
> [...]

Applied, thanks!

[1/2] block: pass io_comp_batch to rq_end_io_fn callback
      commit: 5e2fde1a9433efc484a5feec36f748aa3ea58c85
[2/2] nvme/io_uring: optimize IOPOLL completions for local ring context
      commit: f7bc22ca0d55bdcb59e3a4a028fb811d23e53959

Best regards,
-- 
Jens Axboe




