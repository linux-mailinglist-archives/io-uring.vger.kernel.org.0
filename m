Return-Path: <io-uring+bounces-12396-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QDGREQe9nWklRgQAu9opvQ
	(envelope-from <io-uring+bounces-12396-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 16:00:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DCF7A188C52
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 16:00:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1F2C230379D0
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 15:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C27434A795;
	Tue, 24 Feb 2026 15:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RZhwFLI3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FBB20E03F
	for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 15:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771945220; cv=none; b=pejnsqx+1ktxBhvPQ0iAflZ1I0Sn6yptQkneN27CegOp/PjnwqBVpMo+Qq8Zou8nY9DrREPJkWA4SIYAYR9tuG8MooUu1I47pwjX9We/D6T1dqZvIlBJZIa00iXTv1uP4etVmyDQwlDOiQG9fFKJcw35KPwalkc0BmLsAAlACgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771945220; c=relaxed/simple;
	bh=tdLL5TjVZWKzbVLZ9FK/GPiosdcqu05aAwhqEu+1JHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X1GAMOqt+YwEcCTrtsHKY1GJ/qz6Ys9c7/5WUe+g8lVU9q1JhMSRsW0rZGhyz3CGlA5P2x+IhNvfuscuvyvWKsIQWbmKDxYsEfzQoV8EYvWD42tYt48Qm3a7haY5H3Nk4QnuzepKB+hdFSSzOP/aSqmqL8mWHDZkI/L/ZO310sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RZhwFLI3; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4836d4c26d3so49113115e9.2
        for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 07:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771945217; x=1772550017; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i8Q6tRjGB2I/ixKWwP0hFNJqTrneeTuIe1oiy/tFTZY=;
        b=RZhwFLI3QA9lz845DgUid5XtlmqLfN6o0Appwq9fhISEw9r2U6d9JMFbKxCt6t0LGi
         1kvJ/zAu+eGWP3oJ0M5hQyJtGPMgEpApiEXQb2O1391KgJO0eLSO6bcNcBfLQGPwNjkw
         Cv0rW8RDH575ICsfIDCSRzhKs6By5DDTdcT+1wnkKx3O6jLJSVb3Fd3Qd6nn94jd/2xA
         fSrVcyDl7jR4mapVLoctB+cvKrn+zd8Vj3KZuTj4xJxrZqMVSJaIUlWePFlePoj/mWAj
         YlMpUwyt39Y3T+m9zyAemH0iiJKjzKeTnL+sP059v8qr3pKRFAOWlyX7nz9aSP6pbDG8
         nbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771945217; x=1772550017;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i8Q6tRjGB2I/ixKWwP0hFNJqTrneeTuIe1oiy/tFTZY=;
        b=SLszQ4NQdFTwj4HCvUu6ADGgrcDOvKR+TgbWUA95DsWoRx3O8qgRBhEuvKwsSxNKE3
         7Tq77Z6dvjB87xDMIyNpAuyD3Gy+5ifyh7VhEok2JuSySv5dK26qPs2Ss4qcl+InMxxS
         AjFdRL4F4+Ea2mcwV2SNuSoANvgw93ffzjtTdXHD/VwrK7D91pwBPg+G/qa1EVed1Hy9
         ZSX2faX1B3k4sWe5M03LfKFzCqOY38I0DbJ9qhSJe3//S9yo/F3OzXo3DX4Ww21fuY+n
         mafSPgCMFqPUqY09FE0X832Aod0+s0puldqvsUVhftsrq54brylzkyW5nUp5kLhM01gm
         TytQ==
X-Gm-Message-State: AOJu0YwjKVGk2lwYqtcaPVlIwQe22KBfxc8dTaikWJwLSMT0YwPyohNN
	4DwCliSiyg4XfwfDzaggAw5aF+mRwoeGto9xqKzXd1DkhrJLjVCurQKPXOyJTg==
X-Gm-Gg: AZuq6aLwv/PuoD6F3cGSQnk4xnbac6/kEPSnPyIOX2WXCQCQznzss5agEX1wAWWifbC
	uIMWMwjI8ZJw/+iQlHZ87BbDiC4eQWB7Dj6EEr9Hke+ecWfHkYNg6aNx0RB9VOCkGZbo8cE9Fvw
	+LbbZrrIbgYoH6QyrULLbi/78biKynC4JRAjr9NYtoe98qAfvhFGcDE0W4pOCLdhy03HhpykHLg
	hmp/8hasnqvt8/j2Rl3NCwKC1og2tVhxPW0KjEMi7ZNvEH/egtja2Em/Ae8o4qyAnoc69B0oVo7
	EEuTTmX4wPdFDIobRD+pd5nH51TNKagsjhc6m0qrkJivOIwXlzuQq3iK6B4FjpcWyrD9OHUDdi7
	A8/Egak/ktboWN5y+V87L1seIujX8IbvOhr9pa4wxRpwXgjbpoJwz3tMzElOXkBcml8FPNtK851
	BYSh3jCUb8vUaEAnQWdJflvJhrsl6MZo0cna4+HMifomFvRaO3ale0mBqyJj7jpvM94R8W37yPM
	ve/Iu4fvlM3Pe3R1taygP9fSR/+64/l8oz4xGVWmO2uhOKOL5AKAXJE/OLEXxVJj0tYvtUa24TM
	gw==
X-Received: by 2002:a05:600c:8716:b0:471:1717:411 with SMTP id 5b1f17b1804b1-483a95e9a7fmr213821935e9.24.1771945216646;
        Tue, 24 Feb 2026 07:00:16 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd75df90sm4060215e9.14.2026.02.24.07.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Feb 2026 07:00:16 -0800 (PST)
Message-ID: <74d70b31-2320-42df-bf44-3286105961d3@gmail.com>
Date: Tue, 24 Feb 2026 15:00:12 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] tests: test io_uring bpf ops
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk
References: <a16c8d4e58335129c0548372daa6976f84662d6b.1771940194.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a16c8d4e58335129c0548372daa6976f84662d6b.1771940194.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12396-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DCF7A188C52
X-Rspamd-Action: no action

On 2/24/26 13:37, Pavel Begunkov wrote:
> Add a BPF struct ops io_uring example issuing nop requests in a loop. It
> needs clang, llvm, bpftool, libbpf, etc. to compile so it's gated on
> passing BPF_TESTS to make. The Makefile change looks sane but maybe
> there are better ways, starting with probing all the toolchain
> availability.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   test/Makefile                  | 44 ++++++++++++++-
>   test/bpf-nops.c                | 99 ++++++++++++++++++++++++++++++++++
>   test/bpf-progs/nops_loop.bpf.c | 99 ++++++++++++++++++++++++++++++++++
>   3 files changed, 240 insertions(+), 2 deletions(-)
>   create mode 100644 test/bpf-nops.c
>   create mode 100644 test/bpf-progs/nops_loop.bpf.c
> 
> diff --git a/test/Makefile b/test/Makefile
> index 1bbae1cc..0a4f275a 100644
> --- a/test/Makefile
> +++ b/test/Makefile
> @@ -1,6 +1,12 @@
>   prefix ?= /usr
>   datadir ?= $(prefix)/share
>   
> +CLANG ?= clang
> +BPFTOOL ?= bpftool
> +BPF_PROGS_DIR = bpf-progs
> +BPF_OUTPUT = output/bpf/
> +BPF_VMLINUX ?= /sys/kernel/btf/vmlinux
> +
>   INSTALL=install
>   
>   ifneq ($(MAKECMDGOALS),clean)
> @@ -298,6 +304,17 @@ ifdef CONFIG_HAVE_CXX
>   endif
>   all_targets += sq-full-cpp.t
>   
> +bpf_tests := bpf-nops.c
> +opt_deps :=
> +
> +ifdef BPF_TESTS
> +	override CFLAGS += -I$(BPF_OUTPUT)
> +	override LDFLAGS += -lbpf
> +	test_srcs += $(bpf_tests)
> +	opt_deps += bpf-progs
> +endif
> +
> +$(info flags $(CFLAGS))

Some garbage output slipped through, I'll resend

-- 
Pavel Begunkov


