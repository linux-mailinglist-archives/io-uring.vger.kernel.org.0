Return-Path: <io-uring+bounces-8319-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B722DAD71D0
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 15:27:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A2A017B560
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 13:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D57C254848;
	Thu, 12 Jun 2025 13:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GWiypeyi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F82242927;
	Thu, 12 Jun 2025 13:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749734738; cv=none; b=tQXAElJtrYAUXYdnqGArPJt29xEiojLZvYxXX2Ux7PjjswI+0zr29CP9IgBXiWKjAvn3dJF+e/BkJeHBxQtnyMfaEk0TEL3Jeqdss+ghyPY/U+BCYLQi6iaflV9BcvWrR8CfOApTaEYtIZTpqWlgc9FvKzjxWow8bhlyMdcsvtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749734738; c=relaxed/simple;
	bh=x/LX/NF49fH82gw7hAYoUm3U1ut5qzEj5rfuDlwbzng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F3HBPu+RqUodywqVqXJ31wLIObwZ73h/TH9EYyffPOWlKLexSeFolMVHrmw5KszJqNTxbI7Q836m5NeqCMQtlASJOOEgDCtHkd8dcm9zRM3V4M2tKgADk6GLcz99M+DuCLyrezc6eBnPT65D8Ey56l1sUtPnMB342Z8zYaOw2jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GWiypeyi; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-60727e46168so1744340a12.0;
        Thu, 12 Jun 2025 06:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749734735; x=1750339535; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kWQJ78NSqKK670VP4Vaoznw10u+sraccs8botEaierk=;
        b=GWiypeyi2PbZmQS8haI3Uc2XJ34KqFG7WWEjQlxygn8mSiwlQtXYXF3QSl3aK7EZgY
         36EveIbXGHavbs9AsTUQZotkFH+D3TqHNrXjnDgcodivfEM6ZzxiASAE+h6G7TfPLWnU
         PqS1bMpijoAShhsGJwP8ws/YZpSVg9nJ5qVgUgCy/X6xPDVkpNegXSr2FPu46OheRfCE
         opI3LS5lPwTbyzuuNz2buLJwOybneAsERyL+Oo7gHg1Osz7XtmNaOhXMQdqR5N+h3W4o
         KSluUgpiU7LSaRm4JkfMvHWPCkdw4mIRXClQBdy7xblF9DOMuHr4Dg2xBFNLX6ZPu/Tf
         iC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749734735; x=1750339535;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kWQJ78NSqKK670VP4Vaoznw10u+sraccs8botEaierk=;
        b=WkYDv3udKeMRbiRXeoGa94Uo5IwwyUq003tNjopJraLvfgAp1YmVGGaJT2UuO7VtJ8
         ZfyKilDYBZEULs3L24Y2N1wWE19HSLLQUX2hwB5ddiP5EtL8uqwMu8cDCunB2rG+UT3F
         Ebj8iCTF/LGhypSLokWlv7+mxAiIMtsYBFL8lSnynJQiny18rJgozgUHnj/79UAtYEMJ
         5Lt94mk6fUYGxA61xsEMlu8xIrW7XMeg8SHgR/4UkXdSAQbXccv6EeQ2pn4cK5mrvH1O
         sVq1pMHwlIiFw8oqFoBcxLwIvC2oEv6K8Q7VSMVRYuXG/YTl3r6yCZWNcQ0vkaP5ayIU
         qETw==
X-Forwarded-Encrypted: i=1; AJvYcCUPoTttE/c8HgY4VKUH8NZx6s8zLOOYMHKlmzkJFKZiSMy2DtQ3ueF/JGVaKrSA0p9x4c1pPuRcUJM59aco@vger.kernel.org, AJvYcCVEf+0CGUMCczzRZOB5bZAbGP8Xb75o6rnQEgB2bwH7by9Ej467F+z53NTfRNK2XjF7m5Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOs8Omvuctw9lFV5ZOsVPH8FJvbUsXIp0OqZe9LvsMmfulJjkj
	gzaMdTbbKWa0apnZZeiZuoUYb64fVyJ3q401q8htO7QxHtp8D3O/faLz
X-Gm-Gg: ASbGncsunKhxv6aEgZ2xtcMKKqV0t3PQYFh4vXlkRlvNs4RWfWlmtkw4rGFlSmxDDUw
	bg2j+v9QAaZ15QNXOyYLP+Ui9B5//jIXnI7l2Vwrui1z7+K0Qlny2t4cwKbjSwSh9c7oCuV1KTX
	VDBqysPkchSNqkyr5gHSNH3SkJtl/mW6BUsC9w5g6zUTl2z3fG0vm0U+IQfYrg74Lkf18D9ft80
	ZRhVO0N+Zhw0FRkmFbKquGSHKy7FoL2qbT069UhllSbMUKQl7/QftBw4zAxiaaWrtt+KHumyNxm
	NlUTXI5jmsGCR8B6zfzSbXJ7l1bEDa3TO00rLQIr3EqjlAK/5hqM1gS2gS0lOsQq40JOc1kCwrH
	Tb8KvUAOuKScE2m/CYw==
X-Google-Smtp-Source: AGHT+IFZxvwRQiBgTxSNHZLFGXnyUwZuR+Pl8ThdMj5kISrDwLpDREt72ApHyIV8rpIEcy5wIbNuRw==
X-Received: by 2002:a05:6402:5113:b0:607:323e:8071 with SMTP id 4fb4d7f45d1cf-6086389b344mr3524281a12.14.1749734734468;
        Thu, 12 Jun 2025 06:25:34 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:be2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6086b22ab35sm1183704a12.60.2025.06.12.06.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 06:25:33 -0700 (PDT)
Message-ID: <8aa7b962-40a6-4bbc-8646-86dd7ce3380e@gmail.com>
Date: Thu, 12 Jun 2025 14:26:58 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 5/5] io_uring/bpf: add basic kfunc helpers
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: io-uring@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,
 bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <cover.1749214572.git.asml.silence@gmail.com>
 <c4de7ed6e165f54e2166e84bc88632887d87cfdf.1749214572.git.asml.silence@gmail.com>
 <CAADnVQJgxnQEL+rtVkp7TB_qQ1JKHiXe=p48tB_-N6F+oaDLyQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAADnVQJgxnQEL+rtVkp7TB_qQ1JKHiXe=p48tB_-N6F+oaDLyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/25 03:47, Alexei Starovoitov wrote:
> On Fri, Jun 6, 2025 at 6:58 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...>> +__bpf_kfunc
>> +struct io_uring_cqe *bpf_io_uring_extract_next_cqe(struct io_ring_ctx *ctx)
>> +{
>> +       struct io_rings *rings = ctx->rings;
>> +       unsigned int mask = ctx->cq_entries - 1;
>> +       unsigned head = rings->cq.head;
>> +       struct io_uring_cqe *cqe;
>> +
>> +       /* TODO CQE32 */
>> +       if (head == rings->cq.tail)
>> +               return NULL;
>> +
>> +       cqe = &rings->cqes[head & mask];
>> +       rings->cq.head++;
>> +       return cqe;
>> +}
>> +
>> +__bpf_kfunc_end_defs();
>> +
>> +BTF_KFUNCS_START(io_uring_kfunc_set)
>> +BTF_ID_FLAGS(func, bpf_io_uring_submit_sqes, KF_SLEEPABLE);
>> +BTF_ID_FLAGS(func, bpf_io_uring_post_cqe, KF_SLEEPABLE);
>> +BTF_ID_FLAGS(func, bpf_io_uring_queue_sqe, KF_SLEEPABLE);
>> +BTF_ID_FLAGS(func, bpf_io_uring_get_cqe, 0);
>> +BTF_ID_FLAGS(func, bpf_io_uring_extract_next_cqe, KF_RET_NULL);
>> +BTF_KFUNCS_END(io_uring_kfunc_set)
> 
> This is not safe in general.
> The verifier doesn't enforce argument safety here.
> As a minimum you need to add KF_TRUSTED_ARGS flag to all kfunc.
> And once you do that you'll see that the verifier
> doesn't recognize the cqe returned from bpf_io_uring_get_cqe*()
> as trusted.

Thanks, will add it. If I read it right, without the flag the
program can, for example, create a struct io_ring_ctx on stack,
fill it with nonsense and pass to kfuncs. Is that right?

> Looking at your example:
> https://github.com/axboe/liburing/commit/706237127f03e15b4cc9c7c31c16d34dbff37cdc
> it doesn't care about contents of cqe and doesn't pass it further.
> So sort-of ok-ish right now,
> but if you need to pass cqe to another kfunc
> you would need to add an open coded iterator for cqe-s
> with appropriate KF_ITER* flags
> or maybe add acquire/release semantics for cqe.
> Like, get_cqe will be KF_ACQUIRE, and you'd need
> matching KF_RELEASE kfunc,
> so that 'cqe' is not lost.
> Then 'cqe' will be trusted and you can pass it as actual 'cqe'
> into another kfunc.
> Without KF_ACQUIRE the verifier sees that get_cqe*() kfuncs
> return 'struct io_uring_cqe *' and it's ok for tracing
> or passing into kfuncs like bpf_io_uring_queue_sqe()
> that don't care about a particular type,
> but not ok for full tracking of objects.

I don't need type safety for SQEs / CQEs, they're supposed to be simple
memory blobs containing userspace data only. SQ / CQ are shared with
userspace, and the kfuncs can leak the content of passed CQE / SQE to
userspace. But I'd like to find a way to reject programs stashing
kernel pointers / data into them.

BPF_PROG(name, struct io_ring_ctx *io_ring)
{
     struct io_uring_sqe *cqe = ...;
     cqe->user_data = io_ring;
     cqe->res = io_ring->private_field;
}

And I mentioned in the message, I rather want to get rid of half of the
kfuncs, and give BPF direct access to the SQ/CQ instead. Schematically
it should look like this:

BPF_PROG(name, struct io_ring_ctx *ring)
{
     struct io_uring_sqe *sqes = get_SQ(ring);

     sqes[ring->sq_tail]->opcode = OP_NOP;
     bpf_kfunc_submit_sqes(ring, 1);

     struct io_uring_cqe *cqes = get_CQ(ring);
     print_cqe(&cqes[ring->cq_head]);
}

I hacked up RET_PTR_TO_MEM for kfuncs, the diff is below, but it'd be
great to get rid of the constness of the size argument. I need to
digest arenas first as conceptually they look very close.

> For next revision please post all selftest, examples,
> and bpf progs on the list,
> so people don't need to search github.

Did the link in the cover letter not work for you? I'm confused
since it's all in a branch in my tree, but you linked to the same
patches but in Jens' tree, and I have zero clue what they're
doing there or how you found them.


diff --git a/io_uring/bpf.c b/io_uring/bpf.c
index 9494e4289605..400a06a74b5d 100644
--- a/io_uring/bpf.c
+++ b/io_uring/bpf.c
@@ -2,6 +2,7 @@
  #include <linux/bpf_verifier.h>
  
  #include "io_uring.h"
+#include "memmap.h"
  #include "bpf.h"
  #include "register.h"
  
@@ -72,6 +73,14 @@ struct io_uring_cqe *bpf_io_uring_extract_next_cqe(struct io_ring_ctx *ctx)
  	return cqe;
  }
  
+__bpf_kfunc
+void *bpf_io_uring_get_region(struct io_ring_ctx *ctx, u64 size__retsz)
+{
+	if (size__retsz > ((u64)ctx->ring_region.nr_pages << PAGE_SHIFT))
+		return NULL;
+	return io_region_get_ptr(&ctx->ring_region);
+}
+
  __bpf_kfunc_end_defs();
  
  BTF_KFUNCS_START(io_uring_kfunc_set)
@@ -80,6 +89,7 @@ BTF_ID_FLAGS(func, bpf_io_uring_post_cqe, KF_SLEEPABLE);
  BTF_ID_FLAGS(func, bpf_io_uring_queue_sqe, KF_SLEEPABLE);
  BTF_ID_FLAGS(func, bpf_io_uring_get_cqe, 0);
  BTF_ID_FLAGS(func, bpf_io_uring_extract_next_cqe, KF_RET_NULL);
+BTF_ID_FLAGS(func, bpf_io_uring_get_region, KF_RET_NULL);
  BTF_KFUNCS_END(io_uring_kfunc_set)
  
  static const struct btf_kfunc_id_set bpf_io_uring_kfunc_set = {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 54c6953a8b84..ac4803b5933c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -343,6 +343,7 @@ struct bpf_kfunc_call_arg_meta {
  		int uid;
  	} map;
  	u64 mem_size;
+	bool mem_size_found;
  };
  
  struct btf *btf_vmlinux;
@@ -11862,6 +11863,11 @@ static bool is_kfunc_arg_ignore(const struct btf *btf, const struct btf_param *a
  	return btf_param_match_suffix(btf, arg, "__ign");
  }
  
+static bool is_kfunc_arg_ret_size(const struct btf *btf, const struct btf_param *arg)
+{
+	return btf_param_match_suffix(btf, arg, "__retsz");
+}
+
  static bool is_kfunc_arg_map(const struct btf *btf, const struct btf_param *arg)
  {
  	return btf_param_match_suffix(btf, arg, "__map");
@@ -12912,7 +12918,21 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
  				return -EINVAL;
  			}
  
-			if (is_kfunc_arg_constant(meta->btf, &args[i])) {
+			if (is_kfunc_arg_ret_size(btf, &args[i])) {
+				if (!tnum_is_const(reg->var_off)) {
+					verbose(env, "R%d must be a known constant\n", regno);
+					return -EINVAL;
+				}
+				if (meta->mem_size_found) {
+					verbose(env, "Only one return size argument is permitted\n");
+					return -EINVAL;
+				}
+				meta->mem_size = reg->var_off.value;
+				meta->mem_size_found = true;
+				ret = mark_chain_precision(env, regno);
+				if (ret)
+					return ret;
+			} else if (is_kfunc_arg_constant(meta->btf, &args[i])) {
  				if (meta->arg_constant.found) {
  					verbose(env, "verifier internal error: only one constant argument permitted\n");
  					return -EFAULT;
@@ -13816,6 +13836,12 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
  		} else if (btf_type_is_void(ptr_type)) {
  			/* kfunc returning 'void *' is equivalent to returning scalar */
  			mark_reg_unknown(env, regs, BPF_REG_0);
+
+			if (meta.mem_size_found) {
+				mark_reg_known_zero(env, regs, BPF_REG_0);
+				regs[BPF_REG_0].type = PTR_TO_MEM;
+				regs[BPF_REG_0].mem_size = meta.mem_size;
+			}
  		} else if (!__btf_type_is_struct(ptr_type)) {
  			if (!meta.r0_size) {
  				__u32 sz;

-- 
Pavel Begunkov


