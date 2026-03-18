Return-Path: <io-uring+bounces-12745-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4MNJCALwumkBdQIAu9opvQ
	(envelope-from <io-uring+bounces-12745-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 19:33:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 799572C156F
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 19:33:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0615231141CE
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 18:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C291C3CE496;
	Wed, 18 Mar 2026 18:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2SC4lHg+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105823BFE33
	for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773858292; cv=none; b=QHhDvvadzQh1gC5+07CgEQ/CPlRBYysm3UGEihqH56ywRhkq056VMkAV+TN6vYt8dJSNFzxnSgf3jIC2i1q3v+3NATobZUG0bLuO15FDUyqk07ywHt/UegfD0AnmzYPGm6m1YMLWGJpro4oCuPHFv0wnMKTRhO97gRQW2sFPREU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773858292; c=relaxed/simple;
	bh=uX2+R6cftX7GRCorq5EGsoG0aBsDO95Zasz4mgK2q44=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hO3CuFE4a9b2XwYSeplqOip9Swi/E/8/R46Xhta+/SBjwU7oMZGeQ+lveHofovCYvuRmiO4UjbzFqoaWUkgPlgGltHUJ6HtLtYiflc0KPsYR1LD+HyUvVZ6pR1h/pXKCnTYyNx7GukHqCqb5shAKDFYzXiP+9QJtCp1FQoHqxa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2SC4lHg+; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-404254ffe8aso98770fac.0
        for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 11:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773858289; x=1774463089; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oHGE+uiqFRCDiVWk9jNydTGLejIjVemOigDXqv7ZqQI=;
        b=2SC4lHg+B03Y6nRh721fFXU2q564fEgiMHUPuffFDchgyw83n+0/WPao/G4wC0g9L8
         Maoe0M+q4eVG62mO/c195fIp8sCDWVkIRr+GOk4IAitN0nSsxPo9bwUCkHMroYmrJQv9
         Zbf8dK7vc9FauaQWLre8u7Ok6ZfAatT+9TrPJyQYXom5dQf/97Arne7B5SmA6pbwLJ52
         KC5MvXFcja48D37YOYWzeaPTpvlJM5vNHG/kOZ5RV/Dh562qqqv7H/VbSkBBFzsUFWpl
         pYBr8XUUCVWRWRRv6Kvuov5sbjaXADvy0yjmCnR32YpNU4PSsnKGQH1OrPI1UtvBl6up
         fkkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773858289; x=1774463089;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oHGE+uiqFRCDiVWk9jNydTGLejIjVemOigDXqv7ZqQI=;
        b=VJzno4b+9MQND7cNvvxTUzwEMvD23DWAMdoWrQlHzIF8ho/GO3P1MObuLLfiJCH1ct
         zxpHB0D/vFXwkzt0f3IXnAfmLu7tnEf/9U7yYujXwJE37UVUjPNaovPjKjFOBsHCtu0r
         KSN6mbvlbM+dVEwhf9x0JDGLUf64vxkZ1rI28SZFjhXgRk18LlttypGUAqLbCsDIh5vo
         zupBYBqD9xwFPYGJBotSLD9uE3ZtPS0IozjMMPx5L2vAhezNrL4wid3mIFkIMD2UzBsg
         MSsXsLfQh6gZp9Ze2VMH9EN/hFCoOETopdrVMexE/a1fvuA8OznCP7SIF7N6jixOJT47
         dVcw==
X-Forwarded-Encrypted: i=1; AJvYcCV9TREMSAPVrccOEtu4lSCbSJiRX96+exJ37BFA1pUAFHPNYmV29EJdiybf/XTYKFMG003yMs87bg==@vger.kernel.org
X-Gm-Message-State: AOJu0YysUh0XOAzn5ZVfR8zJUbF32BMiiY/mKEGOb3KvQqMiwNFNdJ8i
	iLo9PiGeYaX6ZeDsq44Gbt/o4bBjjf2BsEJM6mjQO1qLa8esq0APfZgwMn82u2d1xCif29LUlK5
	PgBAJ
X-Gm-Gg: ATEYQzyMBA5DXg4lixl9fPtN4gRyomyEMTOp4mk0OaU6C+q50j7t6GiC6JvUVaxkqQz
	9mv1SMhXEu0LQAapqtMG/lNRwhgcjHRudUUopweDLFChJgz1x/2/oWDezePoi9WIVF6pA7juXLg
	iAMVS2KOYbXNy2df6onXLdNtMfsZEXGPOAFvwMvuHfe+wsq4PAzK1OlOjgB8cQDPBDDL+5ba0Rm
	7ZkOWlJeishF5GVxjGYW7UnbOUPmdIVUrZgeruoq2T971J2DsI7HmsY0feKFrh9lP0GlZF9IDrX
	PSiX+CMEewiC0XzQCYdw2Jx7MhhNjTpvQ1EbxklCJbmFZIXjSy5rWGwROLXJhn4BznOxDrcpsqI
	RALtHZIlmPqXw2Io02hvyFUmwC15aD+anTerBLqX3vaTVdy9RgwtmwhIKXNOtGl7dEGtE+93vT9
	6/8wSgAlccrLxzqm8/YYOn/hQlWvg2SmukGYPjSlrwk0tPzsappmLEUye32U9yKoEh7Hwd2RTbq
	hZ5DPsD
X-Received: by 2002:a05:6871:2b04:b0:409:628c:ca6e with SMTP id 586e51a60fabf-41befc3aca0mr407016fac.2.1773858288746;
        Wed, 18 Mar 2026 11:24:48 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41bd2828aa7sm3660052fac.1.2026.03.18.11.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 11:24:46 -0700 (PDT)
Message-ID: <3c00370f-81b0-41d1-8deb-beb1781a75bd@kernel.dk>
Date: Wed, 18 Mar 2026 12:24:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v3 1/1] tests: test io_uring bpf ops
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <8c9cb9cf824e09271df9c6d6d4398e514d9c5733.1773855222.git.asml.silence@gmail.com>
 <6b9ef71d-118c-46c1-8f33-56145ddd8664@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6b9ef71d-118c-46c1-8f33-56145ddd8664@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12745-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 799572C156F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/18/26 11:43 AM, Pavel Begunkov wrote:
> On 3/18/26 17:36, Pavel Begunkov wrote:
>> Add some BPF struct ops io_uring tests/examples, one is issuing nops in
>> a loop, the other copies a file.
> 
> I needed to conditionally compile based on whether vmlinux.h contains
> io_uring BPF definitions, so now configure probes it by generating a
> temp vmlinux.h. And since I want to be able to pass a path to the
> target vmlinux, it also became a configure parameter. Not sure if there
> is a better way to handle that.

Looks good to me. The configure changes are a bit broken though, you'd
need something like this on top to not have it fail:

diff --git a/configure b/configure
index 3a08e0f12448..7aea26fa7681 100755
--- a/configure
+++ b/configure
@@ -500,15 +500,15 @@ print_config "has_bpftool" "$has_bpftool"
 print_config "has_bpf_clang" "$has_bpf_clang"
 print_config "has_libbpf" "$has_libbpf"
 
-if test $vmlinux == ""; then
+if test -z "$vmlinux"; then
   vmlinux="/sys/kernel/btf/vmlinux"
 else
-  vmlinux=$(realpath $vmlinux)
+  vmlinux=$(realpath "$vmlinux")
 fi
 print_and_output_mak bpf_vmlinux_path $vmlinux
 
 has_bpf_loop_ops="no"
-if test "$has_bpftool" == "yes" && test "$has_bpf_clang" == yes && test "$has_libbpf" == yes; then
+if test "$has_bpftool" = "yes" && test "$has_bpf_clang" = "yes" && test "$has_libbpf" = "yes"; then
   if bpftool btf dump file $vmlinux format c 2>&1 | grep -qF bpf_io_uring_submit_sqes; then
       has_bpf_loop_ops="yes"
       output_sym "CONFIG_HAVE_BPF_LOOP_OPS"

With that, it does detect it fine here. However, it ends in misery with:

axboe@m2max ~/gi/liburing (master)> make                                        6.490s
make[1]: Entering directory '/home/axboe/git/liburing/src'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/axboe/git/liburing/src'
make[1]: Entering directory '/home/axboe/git/liburing/test'
mkdir -p output/bpf
     CC output/bpf/nops.bpf.o
In file included from bpf-progs/nops.bpf.c:3:
/usr/include/bpf/bpf_helpers.h:318:12: error: conflicting types
      for 'bpf_stream_vprintk'
  318 | extern int bpf_stream_vprintk(int stream_id, const char *fmt__str, const void *args,
      |            ^
output/bpf/vmlinux.h:170697:12: note: previous declaration is
      here
 170697 | extern int bpf_stream_vprintk(int stream_id, const char *fmt__str, const void ...
        |            ^
1 error generated.
make[1]: *** [Makefile:379: output/bpf/nops.bpf.o] Error 1
make[1]: Leaving directory '/home/axboe/git/liburing/test'
make: *** [Makefile:11: all] Error 2


-- 
Jens Axboe

