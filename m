Return-Path: <io-uring+bounces-12693-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8FcjCOwQuGmIYgEAu9opvQ
	(envelope-from <io-uring+bounces-12693-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 15:17:16 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E56C29B2AA
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 15:17:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8713C3006F3F
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 14:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28AE1A76BB;
	Mon, 16 Mar 2026 14:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gHXoOlx4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2D3AD2C
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 14:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773670631; cv=none; b=r0v9Y/dLxRXr9slKq81f5DMwoXZo5eRIVGyXp67amCdY8LnxqbIff5FAALgKIsQT6seRlabXL4KeaM9xpP7Uu2e+qCxb4ZOSX66ROe9KcPqZrXYOLYsBJL66zfPht6fpGM0tIEhUZYP2F70aGjR+NeAiVZKxKN7agJkSL6C4XpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773670631; c=relaxed/simple;
	bh=ApduOtXzHZKtX8AMlk83VBeLA6c4M+FKkdsHtpyppH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RVjzHbFFcDJk6BxrkqSddYjotMfE9j/SqLRbIOKGEzvfpmTISoqrOsUcsGLlXx5tVfOTLwQolFGbEFejF3W19150b1Wr2Bx6FRqU55H4NMcwAWiPYck7LuDuTzvmiEMPDip+eitncjyTOtt5bxArLruOhtSygBr8rhL9WHjevtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gHXoOlx4; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so53225335e9.3
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 07:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773670629; x=1774275429; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/IhOQ6OjC7cUuoSa7KKSrQwc6gNjNedjZAgWyqsIcXY=;
        b=gHXoOlx4cTUZ8Y6wmPnxnlBp17NgYxSi37w3l9KFfnBJ1f1rGYkyG2N92IdXepruzW
         raVpZDhHNPbYTaaljNHuHzIgyreTAJnNyefjvG6rpUFTabKge/aa7KrFe2X0nX5jdfN/
         yGRNQTEOlOUNVljCZqi8oxkvQ1E6mZrTUKf9C1HJl5jeTdxZXYE+QNBsOjPztpJi6hZ/
         yLMtfYt4FxuDfIRIA2Sk24qeTwM/wde+ryzGzau1fPYuW/bRC1gOenGuivgVaRSQYaEf
         uplKQDp+qOhZDJsGmZIplN6Nq53zp0t1uNQOd4hJVFiVxCeCI8UicLFQSdQBaY4scH6I
         /CgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773670629; x=1774275429;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/IhOQ6OjC7cUuoSa7KKSrQwc6gNjNedjZAgWyqsIcXY=;
        b=GBm+KLBKKrsnIzVbOvtb/30OzcLo0IdVhPNZajUE3qNIQUna3q9oP3jecCLWq/C6M/
         CVyfduhCiR0oE/Lby8Qlnd/8TRaAm7Aoj7JkGUHtfL+ERDdYg/sYZUZ7KGR3WylVw8pQ
         Ejhj44/6+azPACXEuiTJHB6BPgIFV5x9NOmXUcoynYDpqC43w9Kco2s3t8uITMT2RJZh
         nY0NISJh0/tXUe0iW5JMdQ9Stb3QhJdFbp9It/S9GW+quHb0NUoFW8FgtsOtVNhClWvd
         2fyMT6i4WkToxEDqMuvCa4jcUa9Embsv+5PNmbo3letMR7nOT6IV5aNq2/d+gNiCbqQF
         +iSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcHJha/nnGxtJpUcio2VPhJxSAr8qRclBAPThk1btVgWwaCbocATwDoBgLgwEQLI+AcMOtMvmjKA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOxBHvoBEbmdVB9WExL2QG3qzbAXb5svyUKiR4dGFS3WYlke3o
	JR+o8BT4m6+PPDBkU6jbMBEUFTqDcRCXo40Ms3Jd2CtXSfg7Aw8YpIM/
X-Gm-Gg: ATEYQzxgibOadDD8CIozb/wRR7CSUlUSxbe0hNgOQaSOkwmWbscKWayp3EYoc+S2u0s
	gM6x0uSUPTDq0taOOLIphsyveOVSUHBTn/6JEoVp1lruaxSz1RRy3lkqljAN4UcU3LrzQTnU9KY
	/scBcLLJ7NwQWvw6KcnLXCzZumy2fGwVREkUeJDWs/p3Et3oykkPsxu1nm+jMmlpfskrqezROkW
	wJatDBezFankAEftjShnxANfpd/yLq2wK7fwr7bAIFc50rKJxy1Q3MV5O/h9pn5svH/6J917im8
	A6VvCmfRLIpbMEYVdjD0u3Wv7wiVTJO8ZZIsvulkoTibaAVVHeHYTep7LMDHptiAsqaxSb4o+i5
	VKdD5JItal9mrLsmCbf7y/XeAjVyHRxj+KyLuQEybTV/TansLOLPJ8d2X9zFITfDcMOOVe7N+9P
	DgQ3SR397RqOGurawI0E4n3+hGed5LrF9jzv7aVRH5gfLmKTHp6omJjJatUvIaTZbwJs9Q1rBdw
	onBQHDlihgUHTQ1cDHwHF5ALYXaAxDuofFlcAbVLJW/iBWJfOJWO3xMww==
X-Received: by 2002:a05:600c:4f8f:b0:485:40c6:f507 with SMTP id 5b1f17b1804b1-48556711c6cmr245449365e9.30.1773670628608;
        Mon, 16 Mar 2026 07:17:08 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:a0ed])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541ab9f9esm517791155e9.4.2026.03.16.07.17.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 07:17:08 -0700 (PDT)
Message-ID: <2e2d6e81-bf95-47bf-9c70-1b2f8b63cfbc@gmail.com>
Date: Mon, 16 Mar 2026 14:17:02 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: fix multishot recv missing EOF on wakeup
 race
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc: francis <francis@brosseau.dev>
References: <8688cc4e-8619-4392-8d5c-93c554d70c34@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8688cc4e-8619-4392-8d5c-93c554d70c34@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12693-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8E56C29B2AA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/15/26 16:19, Jens Axboe wrote:
> When a socket send and shutdown() happen back-to-back, both fire
> wake-ups before the receiver's task_work has a chance to run. The first
> wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
> When io_poll_check_events() runs, it calls io_poll_issue() which does a
> recv that reads the data and returns IOU_RETRY. The loop then drains all
> accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
> the first event was consumed. Since the shutdown is a persistent state
> change, no further wakeups will happen, and the multishot recv can hang
> forever.
> 
> Fix this by only draining a single poll ref after io_poll_issue()
> returns IOU_RETRY for the APOLL_MULTISHOT path. If additional wakes
> raced in (poll_refs was > 1), the loop iterates again, vfs_poll()
> discovers the remaining state.

How often will iterate with no effect for normal execution (i.e.
no shutdown)? And how costly it'll be? Why not handle HUP instead?

-- 
Pavel Begunkov


