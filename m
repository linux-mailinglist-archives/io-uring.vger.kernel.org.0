Return-Path: <io-uring+bounces-12034-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SKd/E8QqgmnFPwMAu9opvQ
	(envelope-from <io-uring+bounces-12034-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 18:05:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A665DC798
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 18:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2CB4A30152E5
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 16:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4BA13D3483;
	Tue,  3 Feb 2026 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lkSbwWWM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A073D3326
	for <io-uring@vger.kernel.org>; Tue,  3 Feb 2026 16:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770137963; cv=none; b=S2iUdZ3SDrc6oLqFYD1ztn0PigHxxsDc9TRggtEavUaPh4rcFnoRsM3oRbJM1Cl+PzxknHBONM8o3si2StHIgbSJou1vnYR1PAhTZc2RcPfFydcR4MMieZxVE8tzOdVDMjFQl/jAzNSXNBp3tp0avv0Gs1eDCCyj+My/Gp8QotU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770137963; c=relaxed/simple;
	bh=AGaAxrlBpBZmrmdtu6I6cfE3CliMuvpvRGBpxzo0q9M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i7LyxuExFRbjnwX3WQyPU7PAo3NsWDhng4Qi2K0M9vstMZmAGkNpiBMaKw0FhjRov4FEx2Wco3qs2GAeHFR9ozIoulvAdrvsG+iqo7s/FJt8N0593MjqHU9V76pVKJs19TcxxOet/dOrupW+3EEyH6KIYnnwNKMHRWkkzK935+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lkSbwWWM; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-45efde72438so3767717b6e.3
        for <io-uring@vger.kernel.org>; Tue, 03 Feb 2026 08:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770137960; x=1770742760; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VWyZM67dFHK1T+WfKjMaoJ/w9zQ97181m9aF4PVU3Ac=;
        b=lkSbwWWMt1ihSwgjDd3A0KnZF2bN6r0fb1heh6SCu9aSrt2QTFm76/s+QxyDTk4z2U
         IKIIa25mwVoxihX5MVix0H9v9FsKm4D78Na8uOfhAXgjhU1kZhoUK35uSRSTkOQlNsdD
         f9aFw//i6B6W+8Al+6g9IGJNcj4bpxd06W0eECExH7UCzfFTvNkNLwVKm30UE6g+cNHI
         8+5t9zuEJW/bqi7wvJQRhAxPK+70puU3mCaKeK8vLiCbV+YdQg/y6qUG3FGbY12HeeG9
         LtiHXmWojXDFghttFsA24ONbdHWhmEHI0wnrHq+z/8pwy7btY2C1t48t47uk4jpHPafy
         8wsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770137960; x=1770742760;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VWyZM67dFHK1T+WfKjMaoJ/w9zQ97181m9aF4PVU3Ac=;
        b=ZHqpciUDGmSU0C1GqYTplEYCiuMoHf4bTvVdHI5z9r/kMq9m2IKd5Kp4n7bkIfEsZz
         FNrQbcE3IDFJrIywvm0q6zzzaNxD6xvHPYG6VlbeiUn22OzewKREytapZt3KlZGDgm7V
         9USzXaqUxjjPFNNkrpKD7gVIq9aj0mZ7+kCPGAWFdb5CsmbiIX9FucNLobzgwsJAzBou
         pX1Pkby91lSTpmwuHJtijZwdsZPIFgv8/BvdOvbLaj9MX2hLzdi6sNtYzdgJGZoNOWVH
         pgOI5LAVi/b/qWKOKInpwNsQkVNMHWItlPjXPCB36YSD9FjyZa0FDOcj5GgBzpFLU1d2
         hSCg==
X-Forwarded-Encrypted: i=1; AJvYcCXzSTW0c+tvf/cZeUaluuO0B9yKjPH0Xu0nYzMQaiP8F1/VAvCOkQBua6QnUD8Lyw/BYaWT8SM2+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzAM6EhePXXTlmSjZgYWDR7J+StxAcHoXUIWpZ91pGUFmaMozOv
	Xj0vjbNmWKbmnViBLfb0gv5K3+nTGsMntZPDH1HM5tdJVAdOkf6pjRydZcMvNPNZAaVwGEJm+GH
	ZC7f8nso=
X-Gm-Gg: AZuq6aKrI9fjz5w3FrEspFlokwCWtxhQFcTGFsByLLvDhzWbEu+sXZTjs8wfaeds/16
	M6N6mGgchSvLhSvXzyDWRcQOh9VLnxD+DYsboBsSU7AlbRWvLvXGQlE3l7/97Vfs+4ovRJORUp2
	fdGrNTzQcI0XvK2CB7CoSP02YpyjCUXPp+4sDMax7O/YzPZ8lfRKKBi4Ut4HlNTTw5i2y27Pk6T
	b6qBPayA5mEY476cKzT9QnSXvaIWDHVD/hM14KoRqb4bkFc/xLVjzIWINRWd0RSfU/swBEdtGBw
	qIt2+3IxAemithDS93vouFfK7FR49JEO/uzV+wIuO/6UMJbrVaJOzdaLbhiu2jXO5uYO/13zFet
	xeA7BnnVYw0EmXfn273mvbPqnO/tBP8WOnN58Iiko429idNdgs5PoR9emunGcRjgID+drGvUSX7
	4ZrdMflpx73JaO4RlW2NtYkkmV2PgPIxtcQsHlc/LsSrWmC+2/QG8Akqc8WSpsaz0uRkrH
X-Received: by 2002:a05:6808:1925:b0:45f:4610:fc72 with SMTP id 5614622812f47-462d5a26131mr16875b6e.39.1770137959892;
        Tue, 03 Feb 2026 08:59:19 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45f08f5ff30sm11534309b6e.16.2026.02.03.08.59.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 08:59:19 -0800 (PST)
Message-ID: <7fdc9f43-9ee6-4fcf-a44b-06ceb7a2db32@kernel.dk>
Date: Tue, 3 Feb 2026 09:59:18 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] soft lockup in seq_read while reading io_uring fdinfo
To: =?UTF-8?B?5piv5Y+C5beu?= <shicenci@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <PS1PPF7E1D7501FE5631002D242DD89403FAB9BA@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <PS1PPF7E1D7501FE5631002D242DD89403FAB9BA@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12034-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 6A665DC798
X-Rspamd-Action: no action

On 2/3/26 2:39 AM, ??? wrote:
> Hi,
> 
> I?m reporting a reproducible soft lockup observed in the seq_file read path when reading io_uring fdinfo via procfs.
> 
> The lockup is triggered by a syzkaller C reproducer that:
> 
> creates an io_uring instance with a large number of entries, and then
> 
> reads /proc/thread-self/fdinfo/<uring_fd>.
> 
> The watchdog reports a soft lockup with CPU stuck in __sanitizer_cov_trace_pc() while the task is executing seq_read() -> io_uring_show_fdinfo().

It's feeding invalid cq ring head/tail entries, so it'll loop for
potentially quite a long time, particularly with debugging measures
enabled. This should sort it out:


diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 4f12e98b22c3..74ea0d965d78 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -67,7 +67,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	unsigned int cq_head = READ_ONCE(r->cq.head);
 	unsigned int cq_tail = READ_ONCE(r->cq.tail);
 	unsigned int sq_shift = 0;
-	unsigned int sq_entries;
+	unsigned int cq_entries, sq_entries;
 	int sq_pid = -1, sq_cpu = -1;
 	u64 sq_total_time = 0, sq_work_time = 0;
 	unsigned int i;
@@ -146,13 +146,15 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 			}
 		}
 		seq_printf(m, "\n");
+		cond_resched();
 	}
 	seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
-	while (cq_head < cq_tail) {
+	cq_entries = min(cq_tail - cq_head, ctx->sq_entries);
+	for (i = 0; i < cq_entries; i++) {
 		struct io_uring_cqe *cqe;
 		bool cqe32 = false;
 
-		cqe = &r->cqes[(cq_head & cq_mask)];
+		cqe = &r->cqes[((cq_head + i) & cq_mask)];
 		if (cqe->flags & IORING_CQE_F_32 || ctx->flags & IORING_SETUP_CQE32)
 			cqe32 = true;
 		seq_printf(m, "%5u: user_data:%llu, res:%d, flags:%x",
@@ -165,6 +167,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		cq_head++;
 		if (cqe32)
 			cq_head++;
+		cond_resched();
 	}
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {

-- 
Jens Axboe

