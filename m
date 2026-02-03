Return-Path: <io-uring+bounces-12035-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eGTCBrIqgmnFPwMAu9opvQ
	(envelope-from <io-uring+bounces-12035-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 18:04:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 93FBADC77A
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 18:04:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7E79A307805C
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 17:04:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 390333D4106;
	Tue,  3 Feb 2026 17:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VtFUZ5w2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D7D3D3D1C
	for <io-uring@vger.kernel.org>; Tue,  3 Feb 2026 17:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770138238; cv=none; b=b53/cQOQYFvvq3oIStC9DM1NdtiG6ytx8azeURhGMP72SQH+q1M5vIkF7kxiTPKeyZwW6mPp4A5WkLTBqQrx8hagEGBz0gdXcvqhmcaiyJH3PtzF5zbwOFkrJcZa227fWYI71GNEDwGgQBJOR34O+yA41t+wzVefnWdkDjplhvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770138238; c=relaxed/simple;
	bh=uXvvYexm1xW8OjmDkvr7W8B0Q0gMqkNgIeKSg66vkvE=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=L+8mzqpP58d2OxR5bjlDWTWp6mb4gn482EbDCSDzOGDaCg/1DQ8fMJC7YNlRx3NINn/29MOWmo9fEOec+KJtByvWIV8k34sdHfpFd/WHiA1gwAbmLoJNrqixwRT1zmswX5ofBdcHMZdLxt6IPjmy3MKs4mJL9YR1Ih13sIO/OmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VtFUZ5w2; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-45e934bb51dso2220933b6e.1
        for <io-uring@vger.kernel.org>; Tue, 03 Feb 2026 09:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770138231; x=1770743031; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xWdsq/mbKT33geIdcnB6cGNaBelR826woxVHrOBHOOg=;
        b=VtFUZ5w2wEHtgcH7u52N1hyeGibsBDR9HwJgda6WeUD6aQ6hJ7sAVnqk/zHt35UYN2
         K2zd5DsumVurQWAwdrcBZPi1LA6j/d3d4m/lkaDR4BWDb4JN8KMeDl3qooNXINHAsgdR
         qXwvdecIOY29e87qpKOPoYAfJOPIfhqWxtcffFAJnFcv7pHP5KAZzfPJ/JL1XUMgrhYv
         JK0uE26fLNnajPykNyanSdkkP2JnS/dE+7HE3zHj24rTqJCjWgzH5pWTKxuAL2cu6alU
         YPO/NC7tZ+vYxkX9J/QQ4x/VBlzfHNGkfmbhAE5sHUCiUU8ZI4InYqTO4wqpr6yMLiX8
         U+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770138231; x=1770743031;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xWdsq/mbKT33geIdcnB6cGNaBelR826woxVHrOBHOOg=;
        b=ozjb3pZrUFwKxQITRWxD4dcEROxFtLWhnoapVB5SukGCMPtY7wU05KdVSyl9lROr0b
         nAs2fqonAwRyVyFmdT/ORJzvfVWHus90+6HegFQDrDYYcltni0yfZ0Je/nRQUulwUSQP
         sdIiMyRc86hKCCvKb/Q2clUOe/+wzLhZqR6pf329lP1mb8ux61388wnlGK0rq80r0Zvh
         wySjAJsuSClhe01btlKRMt3CLmJTmWaBF5uGgW5A1qUFpwwtvvBTdS0tPHbzXuqbpcDT
         tf6lv2OCKrtlxjvYWHu4QMr2HKLDbDWl4gxusAqubNQswYyxumhVJSMTBz3j/TCcLlmm
         f4Tg==
X-Gm-Message-State: AOJu0YwCFh1rbufaPYXREFtPHIqiKu4mjuQRpx4PFshXGdaVUtzUEXyE
	j1104ipB+LjQZJFHntvJE0jfvtIs6rsFMsMJY8gYwsjaboblKkF/ogDRjDSq1KkEOBYd5y1mi5L
	jqeCD5bc=
X-Gm-Gg: AZuq6aLndPggMjE70qRhGZx7K+DUVLp+mTlGYWWrL2/qKwgME4T+DU7I9SJFjkDwyA4
	sCshLhcjXhcUz8t+fFryl8mST2h0dseL82YWumLm6mJxyEQlxA4QCKIjwlQ68YNiA7xxR/5jYOu
	lDtRwg0JbBDCUa79X8T3/N0I/PMWU1oWhq7xBoU5/+ygHiMSQsi57sd6ozwT/hrkIj5YlQbVjdF
	E0kx+6OXX0h/Sg+DKEqdpk1uiUgLXn8BWVcAnbvyRtLAK0jZHVhWSpv0lade2TQrfKUe59cg+oj
	tFowioxKmhr/QfiIduHiknd8bfQcDarSsTRKhyhbn/Qx/YvRgnnBekarb5cpcaEtqUfqYOLoYZ4
	wZ+H6uyzsqIvc0qBzDeZo7H0sTrKNGiHcWzqVrUo2PNY29LLl9w4MlmYnnrddU+uX42vV6utGZo
	jD9T+5unr8bFF77Kgsl2DugCUdov81yLfNJP1bidWflhZKHPPhfeMOns1hS19+EFBR/8ZI
X-Received: by 2002:a05:6808:10cf:b0:450:c9ad:491b with SMTP id 5614622812f47-462d5888dc8mr34943b6e.8.1770138231413;
        Tue, 03 Feb 2026 09:03:51 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45f08d894easm11304657b6e.1.2026.02.03.09.03.50
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 09:03:50 -0800 (PST)
Message-ID: <3aa0eb71-0663-4090-b715-308d3b5e2650@kernel.dk>
Date: Tue, 3 Feb 2026 10:03:50 -0700
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
Subject: [PATCH] io_uring/fdinfo: kill unnecessary newline feed in CQE32
 printing
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12035-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 93FBADC77A
X-Rspamd-Action: no action

There's an unconditional newline feed anyway after dumping both normal
and big CQE contents, remove the \n from the CQE32 extra1/extra2
printing.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index a87d4e26eee8..4f12e98b22c3 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -159,7 +159,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 			   cq_head & cq_mask, cqe->user_data, cqe->res,
 			   cqe->flags);
 		if (cqe32)
-			seq_printf(m, ", extra1:%llu, extra2:%llu\n",
+			seq_printf(m, ", extra1:%llu, extra2:%llu",
 					cqe->big_cqe[0], cqe->big_cqe[1]);
 		seq_printf(m, "\n");
 		cq_head++;
-- 
Jens Axboe


