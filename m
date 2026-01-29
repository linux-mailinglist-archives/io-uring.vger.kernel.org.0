Return-Path: <io-uring+bounces-11970-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +CbKFvu+e2mnIAIAu9opvQ
	(envelope-from <io-uring+bounces-11970-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 21:11:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8C2B4297
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 21:11:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 08852300A386
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 20:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9581732ED37;
	Thu, 29 Jan 2026 20:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QjLFaxnm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E128327C06
	for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 20:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769717496; cv=none; b=N5itxPz6o1cHriCSr5KPc5xXquaBoAEKD1AKFRWAfbkRqjwR0R3BBywX1yyF4QCAKQcxt1AseTURqrIxjcaiUY7MVBMDDAtFiCEXLaqsC543dF7ZxkXrnoTDMq9f7qiTWzBKZYkarvvLN21D7HvLHSVRhblbpYodMBk004hm3nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769717496; c=relaxed/simple;
	bh=qdAFULlIb+mIDtEolLQXMkMN4GPxEQVTy/sTesqppt4=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bP/a7+MmSwZ74lSC7eBF0Dz2ZZTadSno2cxg7NyCuQGv3FcHZ//Sjk4V8DMdiiAQ1SkRMd9Q3JLC6NqU2Sl6nc/J4RVEPSyRWvNcqi7pbYTT+MHwp57LesFJ4A95/IYmp8x+lQJ3iur8Q01gR2GkYuUA98LGEuk714Hg71TK0C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QjLFaxnm; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-45c838069e5so895687b6e.0
        for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 12:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769717493; x=1770322293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yaqoYb5xukxZM7VRfFgscr9dk8PLfZvHZ+Mz0v+jBH8=;
        b=QjLFaxnmRgEuSiI9Liv8oPdySbGpr6uKxj5Y64hXDAkvIBJOgnmZdzn6/ppO754xCC
         l1LdXBursf8VNVGUz+f12q15Cyg/0zydmYOKjd4vJLjQhy2BwXJWOqCVjCdDB817OAMg
         da+qTOanERsp/xZV18e1CwKXUtQvsLhfC8yWpIaZlo7IeZ124wwWozkNkwBQmDpyxreM
         UzN+zvwceK1FAok4wGl9CaMp2Xw+pqupgJxg6q1ANPD809C2rZwBKSXyopUFGbczehxl
         VEm8BK6EqL4xQ/XFtTaOxkVh5G/QvbFSc3RqDjWjTSI/rD2Etjn464MZ0OwIwiwUYZQ0
         1LeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769717493; x=1770322293;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yaqoYb5xukxZM7VRfFgscr9dk8PLfZvHZ+Mz0v+jBH8=;
        b=lg75EHE8yAQfrpz/kFA8Gwh5B1A4R10ee5OX1CjTE5rTkb/eKAcVqvOfqY/yqrUKi9
         mm9yWzcULjgs7436vQnELRhY+ILaOSZ7Wl+gkp/d9XocSSfj7lBvRB0FpEe9z22DcshW
         dLGbr/MEaU4buVN92VP+r5HylQhqJyv6m9IsAzJMoxPy7rYbvxkiwL5mdw7kz+GuNrcH
         QRU4yJmQ1soV1gQZDuSsN9iYHczO9xn80HDAUInM5SzJYE2qZBU9YwuwzY9K4L94rvyN
         EqTviStxL6Nte/qS75dK+KJdeIJjfOtyn02FMArDwwF/JVbwodDftP3XpoWJ01WtLgU9
         WgZQ==
X-Gm-Message-State: AOJu0YzBaGkbWbr67KkpnBH2tpryJiV1JFpVgh/Bp7whCasG1fZnXtDj
	xGWwOOGueFPM2kG9tW7VWv1Ixo5rPCdnpVQjZAhrmlo26caMa2+OOapAt60Qh5FE5CyDrTOXRu5
	i7D/+hUk=
X-Gm-Gg: AZuq6aIZCaVsn1vIULTnFQLv2XPm27pihZobArJy8KvEPFp6aHr7bzZ8zCGT80kGosV
	F855NyDqLKeKR228z0PJfF1MCZAzn99qFdKkuF2ljnzYqh22jfJuCOJUb5NG9eEZkR4VvXFXMIX
	vAxIO2szHIfi4MFpHWsYhmvFmKLK/th3sW9wEAw65AeXYMSrS/sOx20h7qOBCak0WgyKumez+CZ
	Tlnot+KUBtikBnJnH3vlTBexcjXqk15HY0U4CCOay7JNAo+2ErOEX1C9n2SPTyNSs9D507AoYfC
	UHRNO6LX+0yoekI0raq+A3UU79qpxS1+ynF075vxu6jJClms+MC9GSdebLy8jb8eBq2TzuneVZn
	j9JBaZKnAkWPZlfDCv1nLFOCfQAFLdccC5N44dHh8zty124ybtcHMlGuHILXAjxpPPhbu/WCI1r
	QnJbf+f49oIcwArJHS3ejw/rO5fAEB0FI3BnSAptFZ6IoyzePUKy/Z5Msc8w9k2/8=
X-Received: by 2002:a05:6808:23d2:b0:45c:80b7:4e11 with SMTP id 5614622812f47-45f34cff8d1mr406867b6e.45.1769717492806;
        Thu, 29 Jan 2026 12:11:32 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4095716e7f9sm4620475fac.6.2026.01.29.12.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 12:11:32 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6fcdfda380cb636b3ddcb9d446907abdb63782c5.1769707053.git.asml.silence@gmail.com>
References: <6fcdfda380cb636b3ddcb9d446907abdb63782c5.1769707053.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] src/queue: simplify
 IORING_SETUP_SQ_REWIND handling
Message-Id: <176971749171.602028.1056539546614201886.b4-ty@kernel.dk>
Date: Thu, 29 Jan 2026 13:11:31 -0700
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-11970-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 5C8C2B4297
X-Rspamd-Action: no action


On Thu, 29 Jan 2026 17:19:31 +0000, Pavel Begunkov wrote:
> io_uring_load_sq_head() shouldn't need a IORING_SETUP_SQ_REWIND check
> as the SQ head should already be zero. Also, add a couple of words about
> the tail resetting logic.
> 
> 

Applied, thanks!

[1/1] src/queue: simplify IORING_SETUP_SQ_REWIND handling
      commit: e63decacd70a6fb00a5a8e85d7af9bf3f29876b5

Best regards,
-- 
Jens Axboe




