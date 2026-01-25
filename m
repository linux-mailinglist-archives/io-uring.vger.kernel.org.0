Return-Path: <io-uring+bounces-11919-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sDx1FgUmdmn0MQEAu9opvQ
	(envelope-from <io-uring+bounces-11919-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 25 Jan 2026 15:17:41 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AFD7F80F3A
	for <lists+io-uring@lfdr.de>; Sun, 25 Jan 2026 15:17:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D19AB300462D
	for <lists+io-uring@lfdr.de>; Sun, 25 Jan 2026 14:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD2D731A7E1;
	Sun, 25 Jan 2026 14:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="npsBxcgl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D38318EDA
	for <io-uring@vger.kernel.org>; Sun, 25 Jan 2026 14:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769350608; cv=none; b=kmt/POPN+qLPb2YQ1Sbyuq+GSIIu/CuOcaY04McBJYngkom3h1aRJSAXvwe2Pj7Cx1vy70ILI9hnfgsMlJS2ubhKHwvqqZnOgkfauixJHjcII+f1oLZ8jMu1FE6eZr6EX9k8m6D11+Yn2D+fxhEJYIgrgWPJXEKOvLDOfPsUUiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769350608; c=relaxed/simple;
	bh=5jwbZukbJ3haIhe/4S7dFzNov0IdTCPoFe/yvHsnr5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nq6Qv3GXTke/Yn+m4Qw9OhBxLrFSAIPkJmlyJxPa0XE9tmJ6dVb0NPLbwjC1LOyTmq19nImqukds+yFc83BGSnKdPYbR5AfsTyTsDwTTRRApfHIsenzT/t8KOXgSkj5KihUi3vVGdyIZnQVgCzfUXvbrCdqDWO8kMuDwniehNpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=npsBxcgl; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-45c93e60525so1114671b6e.0
        for <io-uring@vger.kernel.org>; Sun, 25 Jan 2026 06:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769350605; x=1769955405; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y1RxQAAHw9tRpFPuhCeNDywtO5xFD3YInBr/d8D8Jxs=;
        b=npsBxcgl5jm4Zzrz+n0TA2BQpLzrQGgQhdgbAjydhpMk7SJFSftA6nDPc9l3JkEVMJ
         /1wbw8WP/yBsB8zSGaoWgf0YJM1ZJaYkPIhN3LY+Thf0C8PKIDSnkIlgJrLtJwVpvmo0
         FjWBHhN8z7polaaLVSJ/i3D051gkUTlAtJDi7kwtHQDXcqjMDJ/odB582qpzeVjgKPtS
         excKb3sQ7xeoVSQpusp+V7zDQgrxMH4qPliLAcze8slg5nlU//+gtg8T/d32I5mBOyrs
         gWuy6WJ64DPV3e0Zsxrm4+La3KSXxyAS0/XBB/mSBLw86qE3o0RCMU4RKxhAWNe7URvl
         dLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769350605; x=1769955405;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y1RxQAAHw9tRpFPuhCeNDywtO5xFD3YInBr/d8D8Jxs=;
        b=JxpM8UQsPoywl0VyDwUDXRgFoObTVnvZYo1qojVZ0Llr098dbSGGP7Cv5G4gvyiy8r
         gTnjZLvEbjgu5PyJHxpjnCO3LYsIXtbJJkTRwAxp+ziLX3BSTM+cemyBCp32GAx0k13Y
         qp0E3wWvvdKdW61WPKVmZnyq7SHwNvcALhyCtx03c4dCjwD6VSARi/nHAVo9E8Kuf295
         Y4l4aM1NoZZKzueLxKqi0PKN8I6EiQIMNz/44rBwETrmlRXjV3CncAOk7WrtgYaSiyLo
         tWdnKj1mNJeexJjy3RfQ2w8sBTKaPYPP+ylaJ4vxhw3oFQhZtSrdViqziJbZTjBNWEUj
         ZFNw==
X-Gm-Message-State: AOJu0YwIo5Eh+OkUksJzpTlq5yD0/5jOpxMy7j8DnncffDaRn66wh0BA
	t8t9oK2qChvN0v+NMVbl47Us4N/VZS2UOGen0raM1TybOTxRf6Rje8THcugjVzYlDuo=
X-Gm-Gg: AZuq6aKgNOCH2b3X5XHA36DPogdPeu4F3REnqqf7+LRhHh3b6IX1KVJYaL5lVkrPb2r
	3E+VFDyyaW2I+FprZgIWWARglYrVIE0f3iZ3QSao8szocYmBXw9ooBub4jfy9vCIvKlnRzW4T3s
	vHSZFhfO9+STy34yFEb+J3ux8wvnDpwvT8ZQDvvpuUIy6VoOrIeFhRHgg+wAFVAjjH8XZa0mah4
	ZKqJXFzlua/wkrS6Q4hyoDVqNcDhjb1V5HlJY59H3u2OoXoId9HmSJniRtB2MdO+bab2vzEJ1dh
	EEaZR3KmBCOWZ0wv/f3SY02MYrZHv1eWNjcDzWJifMcWdZQm+0141U8Jg64a8ApCj7RacrHrCV1
	4Wdw4fP4rxda0DEWNOZPcgu82CzzM7CeR3OxdYf5FDxkBeY0DNGpYt2aeHQtjnhAWcXvW3Eg7ML
	HSTprSNb7Dqco5YeZMQd/zvZpQsO03GUqiXHNpFtYT804yfd3Hnat2cDEn0JcpK01tbw11rg==
X-Received: by 2002:a05:6808:191c:b0:43f:7e97:3983 with SMTP id 5614622812f47-45ed9a0af8emr653061b6e.41.1769350605114;
        Sun, 25 Jan 2026 06:16:45 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45eb411ffeasm4401728b6e.8.2026.01.25.06.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jan 2026 06:16:44 -0800 (PST)
Message-ID: <cea5285e-061b-4e5e-8c06-82461e8eeb62@kernel.dk>
Date: Sun, 25 Jan 2026 07:16:43 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: gate personality per opcode to fix TOCTOU check
 in io_msg_ring_prep
To: clingfei <clf700383@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260125075302.621785-1-1599101385@qq.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260125075302.621785-1-1599101385@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11919-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: AFD7F80F3A
X-Rspamd-Action: no action

On 1/25/26 12:53 AM, clingfei wrote:
> From: Cheng Lingfei <clf700383@gmail.com>
> 
> Add allow_personality io_issue_def and reject personality use in
> io_init_req for opcodes that do not permit it. This fixes a TOCTOU
> window in the prior implementation: userspace could race-update
> sqe->personality and bypass the __io_msg_ring_prep personality check.

Please do detail what the bug is here, this looks like some kind of
AI hallucination. The check in msg_ring prep exists just to reject
commands with it set, for future expansion. The only thing that
matters is the ordering and use in io_init_req(), which is fine.

-- 
Jens Axboe


