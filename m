Return-Path: <io-uring+bounces-12615-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOHFKD1BsGkehgIAu9opvQ
	(envelope-from <io-uring+bounces-12615-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 17:05:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5470B2543FE
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 17:05:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 597E7308072F
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 14:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29CC72DB785;
	Tue, 10 Mar 2026 14:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DFAl3SCu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1352E5B09
	for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 14:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773153889; cv=none; b=hwpMuiP/5Rhf8sQUx8Fh5TuvrQBGRgKfmnXGLVCeLnao3RATA4hFYF/vNW9ru4mMy27L/OsyKpYrj/N7hrBOXKfjbrEu+gKlRvF7H10PWfYauLHg0r00cEXO1d2Kj5BzWSRLygL5a9UwrTogYE2Mjb6IGkLS8klj7SEHxyAmSKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773153889; c=relaxed/simple;
	bh=lvkaekZTNOHzSLewf8IN6K3Oi5oLTD7hA7iigLzcQeU=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=FDPuUp0zz4t/Qanr+Hk6d0ciY6qXuorMNDcIJcM16l2OOWJJAF3aClx0/7foUL66WRECObv1MRt4+1p8rv6fYwBVN80bVd4kY7q9I8ksbOoUybYaTzAz5pHcoLjnGjj8vMPppT/YpkqGNQ1/NwIVdXtrdzkcHMp5gITDsBE+90E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DFAl3SCu; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d73d6976adso2155372a34.2
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 07:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773153886; x=1773758686; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+pSoO8zMvomK0QownWiTVdRi1a6yto/HOZW2IYfoCK4=;
        b=DFAl3SCurKFN0QOLYF8/zQUHyw89tk3WJVdYTQqHZi2ivTRlqMedZ8pIIt92HUdaeK
         5+0JKD6hlxxFW8ZQTeqCd6WTLShlC6/hK8xK4Pn3FVtouU8OQPCT87W2Hg/eMAlIQzJE
         Hn5CKc2RDzKh6GVDqz8488OTkDRTxTf/mvWHh0jhb+2do640QjN0QVBzxKykbxL0SIDi
         g8SW4F2iCjgFE/Jc674qtAFTmolVw7WU4rvdwOkyfY57l4h9GjB/uCnieUyO8VZMzakX
         r2TeD4+vUuwN4uQwNa240mwbJsIPqSUFf+qKzEU7Na6bfZAARw0Y64X1qVJWD8mFjzDc
         PpXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773153886; x=1773758686;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+pSoO8zMvomK0QownWiTVdRi1a6yto/HOZW2IYfoCK4=;
        b=jJUIYLjbiPxQxzi1lEs48zkgLFUwTaFvve+fzZ7ftP6Ix3eh8UhDqGt5Y6eOB4/Fxh
         Ljs7jDi21pAzKoR3JYQOln5fQGCHOShT8OV71koKFpgFWekJoybrMIf3qFWWtYLYdWTj
         wgKxKKR/GGLpq7p07P34cf7Uuna79l+YN6QkTq4egnsM3qbOrS+vmmyTVoudOlr8xp+d
         Lq2g0Ujyrxm7SXNr3IwLRkVdi54o7IkTjffdbj7FUUtHtJ5/M4zqDXbCsEgBR9Ye204R
         nQ45GbAe5LIocXz8FAugbm75Bst9yUxLUvs4DuhfzO+tPBiHKTsAtBcidjRNHflhh490
         BbfA==
X-Gm-Message-State: AOJu0Ywv2wh6oRNGWIxOHCLIfLObgrymGmjRC7iBJ7W1nfzlnNpDJpvl
	QiEBAU4EQi/gmhqXHgORUKXHoPDuiqW78fHy+RZXznQgjNY4cBR8jsBKMTCLkuLLMHA3H4KF73I
	DlPPjZZQ=
X-Gm-Gg: ATEYQzwUpuG0Mo2h4At14d1qxfjJXZcxqKPUK1zbszBoYopm2CYTbfKxxE83R+51gNU
	AZwCh+p3y8jJB0X0wkvdp7QSdiYGbyhpgkg21xBiK8fRAdw2T6G3S4ESE394/vn1vWSP2PVav0Q
	30Qx6tq1TygHdoM48H6gzlDyfAIXkZvksZzbA2eDnkGxqI7ReCF+HHMLkxwSfH/2LfszuTLzYqE
	OzORPynkdcmswjfbZmTbD34+FeD62PKNE9NpJFcgiC9Jj6BfR8XCZV9d3f2eLtPEHam1bFpE/5S
	d2vSMfUIE/gZKu+UvLcydljU3AkcEeZQFJeNF8fv3z84wuVjqZbcm8B5bvcCHaRoAj0bBfAspG4
	xB6StnxzOdphvwalTGTf8oV3JPmEpcAJAZ5Q9BwlYP171GC6VFnEg5l2ns0wvu92r1BSbS8SrzN
	GIE8GMSCgXujXADt8tsQiL0mIh6oqaeuS6JqInjXC9nB+TLaV0ZpQI0Jo0HTZOaZFLCifqvBfe+
	kBkNGuEJw==
X-Received: by 2002:a05:6830:82f8:b0:7d7:49f4:8fce with SMTP id 46e09a7af769-7d749f4b0c8mr5669284a34.19.1773153886061;
        Tue, 10 Mar 2026 07:44:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d728d2d48esm8642109a34.19.2026.03.10.07.44.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 07:44:45 -0700 (PDT)
Message-ID: <7fccfa01-cb96-4d9f-b71a-56460d49f47d@kernel.dk>
Date: Tue, 10 Mar 2026 08:44:44 -0600
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
Subject: [PATCH] io_uring/bpf_filter: use bpf_prog_run_pin_on_cpu() to prevent
 migration
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5470B2543FE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12615-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,kernel.dk:mid,kernel.dk:email,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

Since the caller, __io_uring_run_bpf_filters(), doesn't prevent
migration, it should use the migration disabling variant for running
the BPF program.

Fixes: d42eb05e60fe ("io_uring: add support for BPF filtering for opcode restrictions")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
index 28a23e92ee81..9cc44764e0ac 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -85,7 +85,7 @@ int __io_uring_run_bpf_filters(struct io_bpf_filter __rcu **filters,
 	do {
 		if (filter == &dummy_filter)
 			return -EACCES;
-		ret = bpf_prog_run(filter->prog, &bpf_ctx);
+		ret = bpf_prog_run_pin_on_cpu(filter->prog, &bpf_ctx);
 		if (!ret)
 			return -EACCES;
 		filter = filter->next;
-- 
Jens Axboe


