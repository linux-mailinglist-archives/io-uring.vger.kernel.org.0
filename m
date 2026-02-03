Return-Path: <io-uring+bounces-12028-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oO5UErBdgWmdFwMAu9opvQ
	(envelope-from <io-uring+bounces-12028-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 03:30:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A205DD3C74
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 03:30:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8BB093015711
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 02:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C5CE2F3621;
	Tue,  3 Feb 2026 02:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uuTWD6nu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com [209.85.210.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90E686348
	for <io-uring@vger.kernel.org>; Tue,  3 Feb 2026 02:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770085795; cv=none; b=JUTw4Rx7D4kYYhOwNl2T+bl3k/TznaxoEUzRwhHOElGi02r8BpmdRplj+U6C7E2zr4zHwmhIBR/KooNLDLGExZwb9q0Y4u70xCVYer1Ep7sEe2uXia8WR6zmDX1+blcykuDos/nx+pdkGLYfPigKk0jxXYGbFgTULV4b/OzT0no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770085795; c=relaxed/simple;
	bh=d4oSZMDzJqoc07Qz9iqQUXV8kKfhHn5sAN8oZYWUcE4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rizWX0Ug0MyA++5WykPcip0nB99LuPwFsDAUkEOna1YcT8NacMYIvGmyKmCUVkJUxLQWkq1pmqkNfi/iNiL+vbmyMfvCN6uyQh9uIPa+dJ3dXocVkg63KpjHuREpSQ/AUQ+tQ03XgzpovlcOxK7RX7yg9SNSH9y3Lcowd2Y33Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uuTWD6nu; arc=none smtp.client-ip=209.85.210.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f68.google.com with SMTP id 46e09a7af769-7d18d02af68so3360679a34.2
        for <io-uring@vger.kernel.org>; Mon, 02 Feb 2026 18:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770085792; x=1770690592; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ndQ2M5AqgmK7BxzSKoO5epcV6Guo3VeMi9I02ZJ2y+Q=;
        b=uuTWD6nuSkksNyB7ksKKEFJ3HwN5z5H1f0nE8W8rOzthDjLWfmt6721AkELG3I7qrb
         fgyKXnGIPzJYfyqLRxvt64rTv2CL2jg58BxAy5VNHja0rJmWBPYBcBEgkfjbrQDSzTBK
         Z6ZoxRM7FQ4Fs40s5CtMCZTP+4E4QM6NLpkXknCeX1ivJGPz+/GvA4vOK8Xz9VUTNV4t
         MICqxfQUtZ06b2y556f1nIzZhpn0lKUxMGVuWw+Rmj88BhEcwDNJlyAutFv9w5f3GWrF
         hhhxnsGQX8+MCZ0lLzhgBKSU6gt9H5nJ9h+Ww6eE8r/MJIYfOQfjNR8RjplcZyrESSKv
         ES8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770085792; x=1770690592;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ndQ2M5AqgmK7BxzSKoO5epcV6Guo3VeMi9I02ZJ2y+Q=;
        b=VB3zUl10K7lcMLTuh4Yr8FXV3/ZS0tmQuCndOr1o10BZV19ajK4LyKVfOGe2/hm2o4
         H197nSvwyiaidndUNQF85PEXy47P2Zr1+UOZjPtNrUbJpfFtGKFsxANWKLKcm9FHiJWp
         o+yyFwMFqSBoU2Kjp5h7+CCYWbJECbj5j/p5OpxaiK8EH2CtRmGES4oVcDN6BuDkVe75
         lNJlkmJIMMby6WvWf2wcLhgrkYlvTO92ZHicU2JpfDosOpd5HQh0sWEAMc95UbBaxToq
         Q92/YzOai0s3xvoTM98vtlPVr4OI7AeOPDHH9YeCmfcZaZPn9/fF/C6FgfpchKJeAqmw
         So9g==
X-Forwarded-Encrypted: i=1; AJvYcCW+VFuxnNXlW4NLMdqoASRUK77nIcVi6qnjvWgHDUj9T0CWiN00wRn/si6MErNKnNGQYHXfK0yCrg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6q1XpwNw9ABm9zqeqepn4uFOkp8Vv/WeWb06u3V+Kcu5+O65V
	MsZnAXIprYUpUc80pE70hII8VTv2l8zZ2+bo/vmNc6Ae1isQsgeu8rkUxkfCLYtF/44=
X-Gm-Gg: AZuq6aK5/OMGzagn+6GSDB/LeD7g4U9BEBydLia2RdiNbo1AnZxw77VtZv3RsI6/XLi
	IwkaBo9NGUVhWSoYUcb/RnlVLovCMFpdedWQ94FAEcbZCDqgFfpDPHYSyHKRwtWUhgyuBBXM+0d
	UsLelo2IvzmdJZ9XrW/YkOVJ6PbNdB2qlbCxFPOrFs2Jaw9o9Mw9wGY4bFk0VYM4+Kd1LLb48IN
	YwePfDUlZEe+z3I1tFp2A4Bxmw6krtogl9mDSDVVZwXyqP60/RST+VpPkeHB3eTDzSIL7wRpslo
	IqQTB4wtWKFAgAUnzQ0jpWEp90k+bY8yEhubxy18M/bfRW5ffMu6X3bSEgD5qY16E16zrQ+QZ16
	HrLXEREIb3WQD6hMqFTId0zeMTinroWHwi1GdFHJG1ZmuQ22Gj3PeLLgI4EbxCCelA/4K6uZo8W
	U0rA+isLGf5BqQOwt+JvNh9hVV6eF6HHwxAADiKnXB2FbpGPIVN30Jcw/1JiHD4AZJI/wPaQ==
X-Received: by 2002:a05:6830:730c:b0:7d1:569d:ce7b with SMTP id 46e09a7af769-7d1a532974fmr6772965a34.29.1770085792435;
        Mon, 02 Feb 2026 18:29:52 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d18c69e632sm11676222a34.10.2026.02.02.18.29.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 18:29:51 -0800 (PST)
Message-ID: <147b6420-ad85-46b0-a8e6-3cb9265e4b15@kernel.dk>
Date: Mon, 2 Feb 2026 19:29:50 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] io_uring/io-wq: let workers exit when unused
To: Li Chen <me@linux.beauty>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>
References: <20260202143755.789114-1-me@linux.beauty>
 <17d76cc4-b186-4290-9eb4-412899c32880@kernel.dk>
 <19c20ef1e4d.70da0b662392423.5502964729064267874@linux.beauty>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <19c20ef1e4d.70da0b662392423.5502964729064267874@linux.beauty>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12028-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: A205DD3C74
X-Rspamd-Action: no action

On 2/2/26 5:37 PM, Li Chen wrote:
> Hi Jens,
> 
>  ---- On Mon, 02 Feb 2026 23:21:22 +0800  Jens Axboe <axboe@kernel.dk> wrote --- 
>  > On 2/2/26 7:37 AM, Li Chen wrote:
>  > > io_uring uses io-wq to offload regular file I/O. When that happens, the kernel
>  > > creates per-task iou-wrk-<tgid> workers (PF_IO_WORKER) via create_io_thread(),
>  > > so the worker is part of the process thread group and shows up under
>  > > /proc/<pid>/task/.
>  > > 
>  > > io-wq shrinks the pool on idle, but it intentionally keeps the last worker
>  > > around indefinitely as a keepalive to avoid churn. Combined with io_uring's
>  > > per-task context lifetime (tctx stays attached to the task until exit), a
>  > > process may permanently retain an idle iou-wrk thread even after it has closed
>  > > its last io_uring instance and has no active rings.
>  > > 
>  > > The keepalive behavior is a reasonable default(I guess): workloads may have
>  > > bursty I/O patterns, and always tearing down the last worker would add thread
>  > > churn and latency. Creating io-wq workers goes through create_io_thread()
>  > > (copy_process), which is not cheap to do repeatedly.
>  > > 
>  > > However, CRIU currently doesn't cope well with such workers being part of the
>  > > checkpointed thread group. The iou-wrk thread is a kernel-managed worker
>  > > (PF_IO_WORKER) running io_wq_worker() on a kernel stack, rather than a normal
>  > > userspace thread executing application code. In our setup, if the iou-wrk
>  > > thread remains present after quiescing and closing the last io_uring instance,
>  > > criu dump may hang while trying to stop and dump the thread group.
>  > > 
>  > > Besides the resource overhead and surprising userspace-visible threads, this is
>  > > a problem for checkpoint/restore. CRIU needs to freeze and dump all threads in
>  > > the thread group. With a lingering iou-wrk thread, we observed criu dump can
>  > > hang even after the ring has been quiesced and the io_uring fd closed, e.g.:
>  > > 
>  > >   criu dump -t $PID -D images -o dump.log -v4 --shell-job
>  > >   ps -T -p $PID -o pid,tid,comm | grep iou-wrk
>  > > 
>  > > This series is a kernel-side enabler for checkpoint/restore in the current
>  > > reality where userspace needs to quiesce and close io_uring rings before dump.
>  > > It is not trying to make io_uring rings checkpointable, nor does it change what
>  > > CRIU can or cannot restore (e.g. in-flight SQEs/CQEs, SQPOLL, SQE128/CQE32,
>  > > registered resources). Even with userspace gaining limited io_uring support,
>  > > this series only targets the specific "no active io_uring contexts left, but an
>  > > idle iou-wrk keepalive thread remains" case.
>  > > 
>  > > This series adds an explicit exit-on-idle mode to io-wq, and toggles it from
>  > > io_uring task context when the task has no active io_uring contexts
>  > > (xa_empty(&tctx->xa)). The mode is cleared on subsequent io_uring usage, so the
>  > > default behavior for active io_uring users is unchanged.
>  > > 
>  > > Tested on x86_64 with CRIU 4.2.
>  > > With this series applied, after closing the ring iou-wrk exited within ~200ms
>  > > and criu dump completed.
>  > 
>  > Applied with the mentioned commit message and IO_WQ_BIT_EXIT_ON_IDLE test
>  > placement.
> 
> Thanks a lot for your review!
> 
> If you still want a test, I'm happy to write it. Since you've already
> tweaked/applied the v1 series, I can send the test as a standalone
> follow-up patch (no v2).
> 
> If kselftest is preferred, I'll base it on the same CRIU-style workload:
> spawn iou-wrk-* via io_uring, quiesce/close the last ring, and check the
> worker exits within a short timeout.

That sounds like the right way to do the test. Preferably a liburing
test/ case would be better, we don't do a lot of in-kernel selftests so
far. But liburing has everything.

-- 
Jens Axboe

