Return-Path: <io-uring+bounces-12682-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YHVoJgLGtmk3IgEAu9opvQ
	(envelope-from <io-uring+bounces-12682-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 15:45:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E950B2910EE
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 15:45:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7693E3015D00
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 14:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03539337B8F;
	Sun, 15 Mar 2026 14:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yQrh/m08"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616D31E8823
	for <io-uring@vger.kernel.org>; Sun, 15 Mar 2026 14:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773585918; cv=none; b=FaBJsOWSA0nQDuJcf/60tizaFOnjhmLkUhmb/BzXeEmfc47Qr4Q9WNpglruny05mz7kPHGRweacO2oqzYEB29NFGbryAF2hD9NW2ny2KzlJ7HxDRlrnvjBauWKyL2THjLrrIXJXAivE0s48I3FF+FyvbmnuSIpKUdiro5stxLfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773585918; c=relaxed/simple;
	bh=mOZbb02TUL7t7mzJ06mm9K5csimZz2kxWAYTRHGM9MU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rIeshESIouyj+934mOQwgTaEBlXGmPYg26fxcmedCcVpZXqVGzQKj0pj4OortRHvIuSH4Os8RZX940w07Oi+JuqHBDZ83Q0Pv4w8U/fsbEsXFnrXPb9nyR2Glm6c9+7pmO8s6kMAAvqHoWVbc7voIQiCEw5udOG4T889vv7mAWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yQrh/m08; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-40ea611d1a4so1423734fac.2
        for <io-uring@vger.kernel.org>; Sun, 15 Mar 2026 07:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773585915; x=1774190715; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vrbb+YzitjTmh7xBh/LZ11QIR6eDIi9Bb9vxwcZ3IGk=;
        b=yQrh/m08/YGmAfCWNXADe0i+k65qtJ4W6PfoWPIGQUuBGgya98HOwP8jjxk5R3+PRt
         kIMuR/Y16scTgE0C4j+Jp+aPP+Vw/IndCk9iEtu7dvEG8NOIDRSV3OrE1ozR5x6ax6iR
         eKF2aTNsmawlY0qBNnKMar153UrcwVTPSMHtzHR4g2aDKMT2SPbV/1UJ9tLI9mNYeFMR
         HKeQS/wIMZo+kzAVCku4Id+Ez6mZ2jhzhcOIireWxUg5yUnoSTeEW/Ceok/knEL9yeF7
         P2ijcWo83ZlPVz+qwhMSqW69n8jL2vCPtR5D7wC4FA8KuPwXN/E4f0iZxf7kP2awB8bd
         1OaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773585915; x=1774190715;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vrbb+YzitjTmh7xBh/LZ11QIR6eDIi9Bb9vxwcZ3IGk=;
        b=Az4IWwRUH0/+qMZwOZ4d81JdsYH3jjeZxyyLRNlLVf5a3DOlA2lWoo8Rsg0nPW53Vi
         yWckB45CgcpeE086VC/5Mku+ewC5Vc30OSQKhhEdZ9F4XCEkkfGC3jnqvl1eHkldl86k
         Al1nnuNwGro02giatu3Ud6uys51riokis2fSfGYMGXagATJylTTnzUvJ4as1ewPBQ20u
         3jvQF74rF3JT+F3th7Gdd8BO7FVBMkW0vEA6ad46eZlNLju+IcX0Tgy5l+RXLn59lAA9
         +4FPfjH6tJImeTtbGPWEm8DVcrw4X9/TSpi25UypeZuXKOTJn03yfDF2Ft5ao7rowdJN
         pNpQ==
X-Gm-Message-State: AOJu0YyAb429GtOFBfBb2zyZVbA8bzIeDR1rEmT7AN5x+drop6EXWmdg
	E73DtTncDI9OiATr8i6jJCWyZJSmaiVF97jorlNL9JSSTMcGQePuG5zJ4CB2+WJQbGWScz8TPAB
	d8IQSTHs=
X-Gm-Gg: ATEYQzye/Ch1FMVi7HjK9raT/DwHM72dVPIM7oBHuKC2gJ5VRh0eG43tLRCf4yJMivf
	6qcPyGz/KfzVZntiQTuD/ORF3fmLXP90mecq1pps4e7OrPC32PQSkHRv5tcD2l/iA2A6DWkNR/T
	I8oNALrUyf4HQUjy+9f9A8pfpJLt+Ie4qyO+EYOgsZGHix/4GdwtK6X2LJ1MrYRUHaAYTf4nu8X
	4u/wDVjAVhZTa0TJFR0Y2jTbipjR9+YpoOAOwpTjeIatz8LkP7dCIPioYVcLov2J8XXdDWoDt8V
	pG25dOp742eb7AtwVFo4ZbJtuHb+oD39SUP+mBYzpSTpAXsy32FzD61nUPn6y4+J3T/Yjo1X8Y/
	vfmtaA1r7Hfbl6nOZsgfa6GAuEevt+KwUpZyjl6rhnnTqvN92ZfQLyReyuyK0wqj7hOX/BVmPFg
	BXytDS77T0yANyhs8wVrd8EAIqQdOtPk9sw5W6WKLLPsF7F6ejdqHppP0WbGHKNjH9lwbix+wXb
	swZJKhxFg==
X-Received: by 2002:a05:6870:c272:b0:417:3bef:8976 with SMTP id 586e51a60fabf-417b9446289mr6379273fac.47.1773585914871;
        Sun, 15 Mar 2026 07:45:14 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e268f37sm13010131fac.6.2026.03.15.07.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Mar 2026 07:45:13 -0700 (PDT)
Message-ID: <3ecf01a7-4057-423e-bafa-881454f6e014@kernel.dk>
Date: Sun, 15 Mar 2026 08:45:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] test/cbpf_filter: skip when openat2.h is not
 available
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: io-uring@vger.kernel.org
References: <20260314083538.791693-1-yangxiuwei@kylinos.cn>
 <20260314083538.791693-3-yangxiuwei@kylinos.cn>
 <10b4b9bf-2dc8-41f3-bed2-110170dff236@kernel.dk>
 <20260315050217.121292-1-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260315050217.121292-1-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12682-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: E950B2910EE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/14/26 11:02 PM, Yang Xiuwei wrote:
> Hi Jens,
> 
> On 2026-03-14 13:35 UTC, Jens Axboe wrote:
>> liburing defines open_how if it's not in the system headers. I feel
>> like all you need to do here is remove the openat2.h include, rather
>> than disable the test entirely?
> 
> Thanks for the suggestion. I had actually tried that first: removing only the
> #include <linux/openat2.h> and relying on liburing's compat for struct open_how.
> It turned out that this test also uses the RESOLVE_IN_ROOT macro (and the
> filter logic is built around it). Without the header, the build fails with
> 'RESOLVE_IN_ROOT' undeclared. RESOLVE_IN_ROOT and the other RESOLVE_* flags
> come from <linux/openat2.h>; compat.h only provides struct open_how when the
> header is missing, not those constants.
> 
> Defining RESOLVE_IN_ROOT (and friends) ourselves in compat or in the test
> would duplicate kernel UAPI and could get out of sync if the kernel ever
> changes them. So I went back to the more conservative approach: wrap the
> test in #ifdef CONFIG_HAVE_OPEN_HOW and provide a stub main that returns
> T_EXIT_SKIP when openat2.h is not available. The test then always compiles;
> on systems without the header it simply skips at runtime.
> 
> If you have a better approach in mind, I'd be glad to follow that instead.

I think just defining RESOLVE_IN_ROOT if it's not available should be
fine. And yes the test will always compile when you stub everything out,
but it also won't do anything at all. This will prevent running this
test case on a host with old headers, but with a current kernel. How
about the below, hopefully that should do it. That'll keep the test
functional, rather than wrap it all in a define that just disables it
entirely.

diff --git a/test/cbpf_filter.c b/test/cbpf_filter.c
index 41fd284e4434..b80b15033662 100644
--- a/test/cbpf_filter.c
+++ b/test/cbpf_filter.c
@@ -15,12 +15,15 @@
 #include <sys/wait.h>
 #include <sys/prctl.h>
 #include <linux/filter.h>
-#include <linux/openat2.h>
 
 #include "liburing.h"
 #include "liburing/io_uring/bpf_filter.h"
 #include "helpers.h"
 
+#ifndef RESOLVE_IN_ROOT
+#define RESOLVE_IN_ROOT	0x10
+#endif
+
 /*
  * cBPF filter context layout (struct io_uring_bpf_ctx):
  *   offset 0:  user_data (u64)

-- 
Jens Axboe

