Return-Path: <io-uring+bounces-11838-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MG3QI724b2kOMQAAu9opvQ
	(envelope-from <io-uring+bounces-11838-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 18:17:49 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3591548696
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 18:17:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4F777769301
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 15:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2504A436362;
	Tue, 20 Jan 2026 15:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="m3HN4eP3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9135542DFE1
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 15:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768921456; cv=none; b=DTLKePHRNKq7aDLu6x+QKp4IJxHsA2cn1K6F6ilgeDTsK4ozvow9XRTmKlecfnygAvcikARhxen4PAV1bHLdQ2keYLQQfNoOx0T4xld9bN6zfd0V34j4jdOKiOcT6KtRFwETzHk9duLViR8XcojjoCXs+WgraLUeauAqGFudCi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768921456; c=relaxed/simple;
	bh=0kwFPNTS1wBhcrS2p64yAmyKrub/8csVHG8WUrdDfm0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WM1xrlu55yVoAGvWFjDgnfGwWyRCv65Aq4yzox9pXy04D2axgD7Gk4mnd8wt1EMlYyA141OxdJVrBehj9b2cmcvQl/8tUvmmIQDRle8wPlk8qT6IEIFHJhtxgykHUt7Dnc+7kxRHZqhr4jyaWflHIeV3CNKksYB6+H7/BkLcMe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=m3HN4eP3; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6610b05b37dso4548541eaf.2
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 07:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768921453; x=1769526253; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1PXHcWfbR1I64hahQZo+kOLn6fFlrmRf6akqxxtdaLQ=;
        b=m3HN4eP3zz0K9/9wh/8Av92xfUsGHfjkKET3HhW6Ti+mL+bEnnCBlYtUJ4zrnnp0ze
         A1K96Or7AGPyYa5DBpEABlvbuo6nn81t7yIfK8GBcB+G9D06/F/gpn4vt69DC2rH3/cA
         +Tddnn7eQUMgFmz9v8H/nTWBPOVdY052v3epdINuZWxnfmDT8UptFH6krEJFJ47A/CG5
         unI0Q7GcCgFatKhREB052ogkKe1e+pI4l2zxWv6tOIg9GdguI405gAc1v+TFDt5yDIOC
         0Ul5u4UYrJ56p/cJLS1ao384GZUc02KU7N+rcJd8iyLJLmUjK7mRiu6R+2T2QLS2DFl7
         qjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768921453; x=1769526253;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1PXHcWfbR1I64hahQZo+kOLn6fFlrmRf6akqxxtdaLQ=;
        b=bqCuQ9Jy1BSlbqoyhBEloBQ20Ad16ZTrjbbNTPVic9KONuBbYgHukKEhB0Xi5Woe7W
         f8i3HKWxeBGfLegqbrFJSXKZIRIpwt81GNEMPiugPOfSXd6QNNArnqm8yMKq6H52O0TV
         dtamwMseNtQARtiKub6Cmp9GWSKxqoJmJZWF/x2B3rbafLIH0DSGsgD13SbGCaNuLO+V
         IpZDh1SGltv/ZEr5hM+tTV2xOuWik9Oif76ErGT9D9b0KUVm45QkujeCwRr166WpY60i
         sdkAUvtdH2wTuspoJxqJlpI6EgP0pS/tL5fFD9VJrVNu8F9SGQZKOKF0T+iv/yZnngmi
         l3vw==
X-Forwarded-Encrypted: i=1; AJvYcCVa+gwddeVdywOVGHuZaBEO5UftQZsnEfaRTQ46zihZKhKFRt6gqReAQY7s+dBEr4gIyv59Id0Wyg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbMWznTF3ZuL24ChGBz4Zy9Czp5fjEb9RMXPFR9W6RxGoL9Uy8
	0ubeMV5YwpViSZK0bCMQw2LDiCWazlthfyU7rMpRZfBqhqEjFj0f4cNWnVtfG4MHsaM=
X-Gm-Gg: AY/fxX6eNV+um5IXzd1Nm1noytbXSJwodj+ATykhGqngonW7NWvbkOWoLk2qvC/mY3L
	URoIpzE2LqBIW5QQmJ54qfcGhRMjRa0ljRM81mGrNhEPUckZatqpaMR3a2P7yeR6xFg7sqGgeSW
	WRDg+AsUQKFxo8/ONcaxqni4uu4xB3aF2u5REm/SMyOidXNh9n0JgBzCeKu4VIBDXyXJBnWUPgQ
	LBVhsb9rk6mnEkKOEC25z2Z01Ci2Ym69mxf5XbR29I8/l44CH50BNYV4/d8CsD8D3GRvr7xbKy1
	zg7h20E+Vy9wOgIJiG9I0fzgpG6ZrEtKmUqp9SGFj4Vefzctns40AAM1A5cf7zxpyA95vzSboEQ
	Qb9gHXDRNVs7HLs3n4EVl9J6vfttDFI6ozUkISRP22KM7BFFVUu8eV9Z4frgXaJ3l+aYHvpzqAN
	wFLGDzaEjErnU7tKhG3pU2eCjNxYOhz0BdXQs/OQPfchGLmEF5vWQdTj1ba9e/+VTdPUlF
X-Received: by 2002:a05:6820:1993:b0:65f:67b7:95c2 with SMTP id 006d021491bc7-661179f382fmr6532331eaf.55.1768921453213;
        Tue, 20 Jan 2026 07:04:13 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-66118781fedsm6071471eaf.11.2026.01.20.07.04.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 07:04:12 -0800 (PST)
Message-ID: <7aa47c41-df51-4a9a-b021-866ea1bacb7b@kernel.dk>
Date: Tue, 20 Jan 2026 08:04:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (6)
To: syzbot <syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com>,
 anna-maria@linutronix.de, frederic@kernel.org, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 tglx@linutronix.de
References: <68a2decc.050a0220.e29e5.0099.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <68a2decc.050a0220.e29e5.0099.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [0.04 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-11838-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,4eb282331cab6d5b6588];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: 3591548696
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Just to wrap this one up - there's a fairly lengthy explanation posted
here:

https://lore.kernel.org/io-uring/937c3e38-368e-43eb-9d7e-2dcc0697799f@kernel.dk/

which details why this isn't really a bug, it's just slow exit due to
the odd huge reads (and number of them) syzbot queues up with io_uring
before exiting.

-- 
Jens Axboe

