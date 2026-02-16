Return-Path: <io-uring+bounces-12252-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GCPAE4M8k2kg2wEAu9opvQ
	(envelope-from <io-uring+bounces-12252-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:49:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E8572145C51
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:49:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5C36A30089B9
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9CF329E55;
	Mon, 16 Feb 2026 15:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YMqmGNgc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F1D328634
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 15:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771256959; cv=none; b=gjGNn+/d0Vk7UHJzFYHPakbUyHncfWdDeCzbYsER9C4VKWLUXOLr2NnWk634U4cuiWczT3zan4AETlFFZmIpLjGuG7L/P7e6W7zcVlx6hvIzVe902QgPIwHGqOH7ou3Lz1yJZZkmt6U77VUxDQB7wp5weKRinRa3hMBD4S0GXxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771256959; c=relaxed/simple;
	bh=S7FCPDNRTuTokYbVmtUw1wt5LCxHACHp92odx4zAsRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JT99jt0NFRCbrsnc6k8r00UMlU6d+LiWdYMNaY5bwx0dUoOMk5a7unc4WKk+oFPfptxg/K4eM7ZW1+2oE9PT0JI4lRQMJExBjjjUlKbUcXtkZzZnkfjQVegqtpUh49b2ss5Wq9D+9KkmhhtsSxPpELyhyDgN2KXr4l3yByIsHzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YMqmGNgc; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-463a0e14abfso1659083b6e.2
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 07:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771256956; x=1771861756; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SYsmHXReoW9BrXI3fnboPaB0P/FfcginaDYlFc3JCAU=;
        b=YMqmGNgcw/q09739d6onWHvYU3GFDWr+k8OeoGJj1xp9j3W/DtBRQCs/O0qM4tqoQu
         lHpoLaIpujaGOoZ3Qrtuf35F305O1UoVvO+f3SS+iNXiAOY0l5SqsiMP9uVY2F+KPzqq
         bzX/nxhwZD2wGuQGyTaMArujccpCYLezrEwu0utbko4/tb8nORiF4f479zPQwlmTluH0
         3OoKRk4TLHWh96f0bQgkr/aaGVQItZxaJWIuLvpC55BbhNVfaSGq0cvl+s9p53Yn2QpY
         LZJ5L/2/gQPlU+QSUyngy5X4N0bI0jWYuHqUCsq3i20RHrfjpLJvyBjLZYTzebFIBq2A
         pUkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771256956; x=1771861756;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SYsmHXReoW9BrXI3fnboPaB0P/FfcginaDYlFc3JCAU=;
        b=BgPc2iTZtTIwyoHXcB/qUkhb8FEykYDHbXEfD7mf8wdcLv5Ep2ZKhT4XXwlrNnvJWL
         w++5b1nEmSIZO7qlFEVbHGSd6xyTKnqTHNgPKB78opdMbBUs2HB9m7RlBngzajrymVC7
         f0FL2a7efhPAIw2YQVLbLIgsj0MW9tIHtNYcjb0V0hZgUzPAbLvXhURg/KXZg99cPC13
         B3juGvhDPNPIWiM3ZsQkFepy4DKQhB5oleFzOLw9Y3zPkp81FKJtfZH9zNtEaZbXtNm0
         29Ye0X8n9YTrF42DcjVlTXTkTbjTw1Zzsn7BbDeSGYtQ7vur96mn25oACw2t2gKjadmP
         ZERg==
X-Forwarded-Encrypted: i=1; AJvYcCU22OLEtIiXPHOgl9hHSZv4FFIlLHy0To3j6dHKGWzP81LPyPc5F/KKst3jpDqlF8t7rCFolvQ+UA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwacLNU384zJxeiPmg1JzIFNjjc7IeGv22jmlfA98KGUkj4TH2w
	Rngi8EmflojJS6/Kn9ODt9GEauJ93VKYDsIht+Z26uB7GnE7iB4kbWRo4ypNEJ9J20o=
X-Gm-Gg: AZuq6aIlnzB96BqUpsGQs0jj0Y3NAZ+l6WlTtRSbM1Wg2OIY/LBmCV77PaQvuppO8Fo
	GFQLCOKAvLBG2PoeYcq2khDPJXEQLM81mwUbuUQmj3NBh65zzp6tpLBgyyeWSvMpDkgdagqCcBl
	Du9t6ShOO70tlZXoVsX4y++ilrsHxUsIjIxR9PCeqlt84V2jrRUU5ZOLDlEvZCAVOnLLGDPxUst
	d7NNQFgXUNoGuasET7WJ9LLURFMl7Lc1vXL7dLrLjAbj38P+Ve+uK+TYm3kqk0FsyoCvpCfMeCz
	IBhQIfmvvpKcbVR3o4pie5mgO25UlbXXubZ97sdyNDArT28+iLvvrmgdH2hqYNlhebnKHAOy+qx
	a/ufwnF7XVlyeRryEMah2lpwgg72MKKKTurt+BX7paiGfdpnkEaNEjJPl8tChkLpVFYMlCsleLV
	WislGB0M09tGvUqBheusTDZZE2HJZBdvDvP7KpW4pLtLcXP+BgROI0R0PtGuNQhhFMZG1LQC7oL
	AxCr2sjPQ==
X-Received: by 2002:a05:6820:1b08:b0:679:1eef:96f with SMTP id 006d021491bc7-6791eef0fefmr3551041eaf.29.1771256956100;
        Mon, 16 Feb 2026 07:49:16 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaeb42708sm15529092fac.0.2026.02.16.07.49.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 07:49:15 -0800 (PST)
Message-ID: <0b2d5fa2-77b8-4b0d-b90f-d073ea671fbe@kernel.dk>
Date: Mon, 16 Feb 2026 08:49:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] io_uring: introduce callback driven main loop
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1770836401.git.asml.silence@gmail.com>
 <efa65f15822f686bc2a8abda7ba799d3cf46f6c3.1770836401.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <efa65f15822f686bc2a8abda7ba799d3cf46f6c3.1770836401.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12252-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E8572145C51
X-Rspamd-Action: no action

On 2/11/26 12:04 PM, Pavel Begunkov wrote:
> +static int __io_run_loop(struct io_ring_ctx *ctx)
> +{
> +	struct iou_loop_state ls = {};
> +
> +	while (true) {
> +		unsigned nr_wait;
> +		int step_res;
> +
> +		if (unlikely(!ctx->loop_step))
> +			return -EFAULT;
> +
> +		step_res = ctx->loop_step(ctx, &ls.p);
> +		if (step_res == IOU_LOOP_STOP)
> +			break;
> +		if (step_res != IOU_LOOP_CONTINUE)
> +			return -EINVAL;
> +
> +		nr_wait = io_loop_nr_cqes(ctx, &ls);
> +		if (nr_wait > 0)
> +			io_loop_wait(ctx, &ls, nr_wait);
> +
> +		if (task_work_pending(current)) {
> +			mutex_unlock(&ctx->uring_lock);
> +			io_run_task_work();
> +			mutex_lock(&ctx->uring_lock);
> +		}
> +		if (unlikely(task_sigpending(current)))
> +			return -EINTR;
> +
> +		nr_wait = max(nr_wait, 0);
> +		io_run_local_work_locked(ctx, nr_wait);
> +
> +		if (READ_ONCE(ctx->check_cq) & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
> +			io_cqring_do_overflow_flush(ctx);

We need a __io_cqring_do_overflow_flush() or similar here that already
has ->uring_lock held. Or The same dropping/regetting of the lock as is
done for io_run_task_work().

-- 
Jens Axboe

