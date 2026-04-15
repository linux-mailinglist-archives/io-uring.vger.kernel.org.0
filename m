Return-Path: <io-uring+bounces-13053-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHzRHBD032mMawAAu9opvQ
	(envelope-from <io-uring+bounces-13053-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 22:24:48 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DC6E54079D6
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 22:24:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5DF94300C987
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 20:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BA2353EE5;
	Wed, 15 Apr 2026 20:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="vr8itQ+f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE4A31D372
	for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 20:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776284685; cv=none; b=qAXmnX2QH425/+sZCzzX0JrJZ/JGdRMt3MdXSKAmRVg1SBd/MIv+78DMJvpMysxeAABlIQEk8kcRe7Fj5AuEyB5OlavRu44krKUouBPdccrID9+mCZwMyKH7e15YzS8QwKRbc5TcJ4OvAvT9WWubfLR4J4a1eoqimxLUyLwpUUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776284685; c=relaxed/simple;
	bh=IMJ4SDbO/mgFaDGcnXO7+vxeBp7u37TMHoP15QS1anE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IBf4HzFogropARY7/goWI0Mx5GikfVzKPKXmWdd2eFJPI3d1EpmLq+yVh1rgphuQZKvDxzCMrmHOe4+Sl4GAAwB/ZfQtiBlU0Zb4tZ4laEfNecsbmlyI/yP+Wfu47bwI8/KRRhRNbAF5ArmGtKcEix698pDLvxk5/p5jUJwP+zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=vr8itQ+f; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-471bf5157d7so3183844b6e.3
        for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 13:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776284682; x=1776889482; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2b7DWU9d30wVeZCxRvO28kZHVSIZFqGuNTVN7hJZAeg=;
        b=vr8itQ+f0UyRtaFiHS7Qn3AIAI5u8nNJrDkmQp0alV5297uzq95/fDoUygwUr9glJk
         Hn/R6umqFs9WG1Sqxg+wfEekTT8tZ4WTbD0hQ/MNknZCm3St0k21FDta64kp7LQT8JaV
         T4U08TGXc+FoLis3uV0HeKuZ76pnMc9Z4w3D726NZ048oXmdM2/2DVeVuAre6EW1ejwz
         XdHXwpMjoNu2gfBUzmLN8X0j/x+yXzx+KV1xWzCjXHele20RBifULVdttG6XA4/JUCsh
         yCjmhWRNoiNc1XMqJN9MeBerpQ83dM9TUBv6Ln8qCHg93pf8NUiHLYyK8ghBto0wux3Z
         iVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776284682; x=1776889482;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2b7DWU9d30wVeZCxRvO28kZHVSIZFqGuNTVN7hJZAeg=;
        b=Ydar6pdBl5Nl3t91552P1xBA7rr0sw8TENE2o+jHtlrLwuevjpyftNXaOThh7KdPXZ
         Ng1TbQ7R9N9nHos9FIsSGvQq2h+9Gw2AHS+kmS5TuOg1FLvvrCXnifUpIkO7WZSzmL2H
         DWahf6nzY9TJqdenDGrBDQauTj20t99EWknfVRBSSkODQa/CfpQmsFeUKhopJMR0sAaG
         CowtQM+YpiNPZpRRypvOXDwC7ISrxN81sQTg/U9U4iU3zBPeOaZlpT6NPy9D5vPhsv9h
         lLgjEgkTe/cp/Y2Ajwl7AqWmp98pzv/S9x/YPY1q+AxtAqlJkIkTD7YkQAKzdkMHABw8
         Uozg==
X-Gm-Message-State: AOJu0Yy1jbfhAMifXpNr/q0lZSy1rRth6pKU9oIx6CmJa0JvUHOTlXc1
	kAP+Tn81KeaYLGR1gbNAltN4rdn8dwV1Z1i+hNHBqxok7UX/B8mN5UVI69h0+icd2Dg=
X-Gm-Gg: AeBDieu9O4yZoA7bYhYqwpg1m1H8I75s42SfP7xkYcldCBLvqcdh+OCbILLup9wi39p
	sCFbNmWkYbqsZRayP57pgtQ2lR47VqvInViLQB+JkUews4BeHu0nbfwu2aivIgnbtDt4iXDwziT
	tbv8ICZMqToQ91s2sktGV9hxxQ6LKzKQ9piFe6wLkYmh5tq55UZLOQOdL3DyObK/rKGDihAUTVf
	AtNy2edMI45Lv0CxbzqEOa3sdm7pkWvgYGuYy+wMRiLstUfXkUEkIziO8E5qJUlltCZgmbPEd4e
	AN6u6ocEZCNVha3h2qRfzBCoIbmnG9lSGFVHClbklY3li9I1Stvmve25Uh+Ioa0dzj+ar50BpLK
	AEcYsuIl8UkHSMH7dWKckAMWELtp0UDFQnf8gb3f6b3bdaTErzZDto5fKpgJOJmEzh0RlmZETuG
	tJWoSheL306DwtKKrt2ju2qt89ESlimXSTVXYjVNu0of8BVb9ZcjuyesvjidYeYvMwoUg8XJ05e
	+AiMHKKr/TdEYj9FzxePr8GaDR4Z9HHYx9iApZeEw==
X-Received: by 2002:a05:6808:c1b3:b0:466:fed2:54d4 with SMTP id 5614622812f47-4789c64b551mr12044925b6e.10.1776284682040;
        Wed, 15 Apr 2026 13:24:42 -0700 (PDT)
Received: from [10.0.0.169] ([72.170.223.83])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4797a36800bsm1514761b6e.5.2026.04.15.13.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2026 13:24:41 -0700 (PDT)
Message-ID: <499e9c02-3600-441c-bc8c-6ab41128d2bd@kernel.dk>
Date: Wed, 15 Apr 2026 14:24:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring/tctx: clean up __io_uring_add_tctx_node()
 error handling
To: Dan Carpenter <error27@gmail.com>
Cc: io-uring@vger.kernel.org
References: <ady1bB1t8l7LBjGG@stanley.mountain>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ady1bB1t8l7LBjGG@stanley.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13053-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: DC6E54079D6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/13/26 3:20 AM, Dan Carpenter wrote:
> Hello Jens Axboe,
> 
> Commit 7880174e1e5e ("io_uring/tctx: clean up
> __io_uring_add_tctx_node() error handling") from Apr 8, 2026
> (linux-next), leads to the following Smatch static checker warning:
> 
> 	io_uring/tctx.c:174 __io_uring_add_tctx_node()
> 	error: we previously assumed 'tctx->io_wq' could be null (see line 164)
> 
> io_uring/tctx.c
>     139 int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
>     140 {
>     141         struct io_uring_task *tctx = current->io_uring;
>     142         int ret;
>     143 
>     144         if (unlikely(!tctx)) {
>     145                 tctx = io_uring_alloc_task_context(current, ctx);
>     146                 if (IS_ERR(tctx))
>     147                         return PTR_ERR(tctx);
>     148 
>     149                 if (ctx->int_flags & IO_RING_F_IOWQ_LIMITS_SET) {
>     150                         unsigned int limits[2] = { ctx->iowq_limits[0],
>     151                                                    ctx->iowq_limits[1], };
>     152 
>     153                         ret = io_wq_max_workers(tctx->io_wq, limits);
>     154                         if (ret)
>     155                                 goto err_free;
>     156                 }
>     157         }
>     158 
>     159         /*
>     160          * Re-activate io-wq keepalive on any new io_uring usage. The wq may have
>     161          * been marked for idle-exit when the task temporarily had no active
>     162          * io_uring instances.
>     163          */
>     164         if (tctx->io_wq)
>                     ^^^^^^^^^^^
> This assumes ->io_wq can be NULL
> 
>     165                 io_wq_set_exit_on_idle(tctx->io_wq, false);
>     166 
>     167         ret = io_tctx_install_node(ctx, tctx);
>     168         if (!ret) {
>     169                 current->io_uring = tctx;
>     170                 return 0;
>     171         }
>     172         if (!current->io_uring) {
>     173 err_free:
> --> 174                 io_wq_put_and_exit(tctx->io_wq);
>                                            ^^^^^^^^^^^
> Dereferenced without checking
> 
>     175                 percpu_counter_destroy(&tctx->inflight);
>     176                 kfree(tctx);
>     177         }
>     178         return ret;
>     179 }
> 
> This email is a free service from the Smatch-CI project [smatch.sf.net].

Thanks, I'll make them consistent.

-- 
Jens Axboe


