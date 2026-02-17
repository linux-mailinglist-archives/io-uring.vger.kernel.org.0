Return-Path: <io-uring+bounces-12282-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MMrXAIBLlGm/CAIAu9opvQ
	(envelope-from <io-uring+bounces-12282-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:05:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A287E14B266
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:05:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E32A9303742B
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 679AB330313;
	Tue, 17 Feb 2026 11:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d6m0Iqfh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEF932E6AC
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 11:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771326316; cv=none; b=jdR0hpJzOxiIOH8AqLfAMFEePuE80mHNT9FeYVKvRV2aOeHb/pcEWoTSzZTmfjUGxEkiN9W+iZPOX/YXqCNGrv4VmdB+9lPSn/fCFbuBSpUr6hLET0Teu8gsfWlC3GPVg3nJZRTuFkjQVaCI6pdOy/V5+QNILwKhaLfx36g9uC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771326316; c=relaxed/simple;
	bh=uDBiU2C7+3Rgh9Df39HuQ5kfSjmQotATp66mNAM7j+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AvjJoJHx9zcfnmKNoKsGu8Es0QC2FquevjtwR66oRT6fCR9eyJLyaXsW5bk+cZvj3x51LtEQspgrelMQdKUIpZK8TVS8TypiewKi1ww6/Vfc3IruOusu5gA3Ik+JN45qke/LYJSkUa1DFAzxHQGrI9KDWBKu0En5kPOCZWnTsxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d6m0Iqfh; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-482f454be5bso56789895e9.0
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 03:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771326313; x=1771931113; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DdieY3TeFCCP2lBrqX6SK0NNMt0g0Rj48YaZz/Wekss=;
        b=d6m0Iqfh7Q7FLdQvn7j4u9+mc8uypIKu7fdIjvm086jUWQ3X15wNwtJuvtEPjKEE46
         hJkYZFnfDVCR8ZZPdB3hVsHOOgNoVUXsAh3cYW+ZhHBcyyUMGY6XalocGtDS5BputbD6
         aIa5L81V6cN8A7fdzZ8dxP3ws9Z55zmTWrDtmqa5u2DRZNEh7dCj+0oFEajpibhhKwCc
         hYlpjZSi3xGr6tnCQT1VXEtTFcyZQhXGb0ijnQ7uwxntrym4+fxGhEmVfnbdtX2u8SUj
         SxcfUdHMiAmq4pBBGLy+9knivJE8CQgLlJTsnHYm6nXzCMeys2PScYJBM+BJIAYtH5lr
         dOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771326313; x=1771931113;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DdieY3TeFCCP2lBrqX6SK0NNMt0g0Rj48YaZz/Wekss=;
        b=TNY9vp2b8sS2DKsNlLg21kzn0yf0DW8EhBDiyvcBL1MaKtKPrb7B9xmxwN4rUSnN9v
         kC0ChnbGRoNwrOcTTxpS4soaTJQcefgz9Nl4WV7pO1ACGeOFFtAj2T7VulhMyVJQCRPI
         //rsQ5cmuxn9gSDP6eaQksC9kHP0GZN+cYjxz0VKKaU8deAIt+snQ9p8yF59LDwAs4N7
         PEmCYxR4RLwXPcyjeeQP1dKZaLuE9ImuHVL1mi88FovnUKWHMz74g/wcrv5/wyP89Gje
         FiAAS/cwl5g3ELB+AaXMOtCTyecJyaYOMB8INtyyySN3dJUhhaPFTO46DPIAO8qfpCrq
         rNlg==
X-Forwarded-Encrypted: i=1; AJvYcCVVulhn3RJMjoCQm2kN7Rvugmnq3z464otc07Nm/yToGu214xs3nzvjNHTx4diqXZEua1wyrIKj7g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzVL+HceapWJ05AGllsz5mbQJ4BUcUr4HuSRUQsoqu0cS5hJP5c
	ozOxzYY9R8juG6U2jwZbAuncS535jTHpFrcVuU8DZS54XLoCvqxu8OOc
X-Gm-Gg: AZuq6aK1iY1D29MJAUSCmmF9KHo1ZiTmzJyD4jgu9rQ9coj/7OXXbmiUigUztwcGMxB
	pgv/ga67tTkyolO8egSioahkszd59/1UX85LZ1JyANENTDjUu7D3lkSLWAgwMBqacM4s25js2g4
	cWu19aXvkdwwJXPSzgexJSlxNHCSelNMOCtlzmnyrYkWt0s/kFKuRrOdjjk77RlokBr7c1mD9Lg
	vncfNTLR2n2MS50sfmUsVjdt52N5KIoR5c1i6sVG/4G1j3I28oQWueljsXpFN9KjueSkURG8T/u
	HuPQNap+9jC50YugX8Emg9PyXT/KwDl/JASV04XW4lfTP57S0To9xTKLeHAeUaZ3/eGsksXej2s
	wKDBVdmMyL1T8tABfhVSb4xOXug2Ec+odPyRRWcqwCfDigRpGlICa/H4Z43IY/uIVGKAHaAviz0
	gfhtU3bcRyyj87+eWT33+gsrifw1664gd4w27JkhS6RzJgKJbLYvd0vXoD11cyrPcBca9RZF0DI
	AGeN6TGhiNtrnte/ZyS7fPGVjdo02OdjdyFx0kwwTPuQzFDdU0WFEGwczKy1aNIrWXYV7diMaPb
	3A==
X-Received: by 2002:a7b:c356:0:b0:47d:52ef:c572 with SMTP id 5b1f17b1804b1-48378d4f631mr137622535e9.1.1771326313228;
        Tue, 17 Feb 2026 03:05:13 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4837b68e5adsm310486565e9.9.2026.02.17.03.05.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 03:05:12 -0800 (PST)
Message-ID: <47684e50-d7c6-4f20-9206-366c9c343eb3@gmail.com>
Date: Tue, 17 Feb 2026 11:05:10 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/5] io_uring/bpf-ops: implement loop_step with BPF
 struct_ops
To: kernel test robot <lkp@intel.com>, io-uring@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, bpf@vger.kernel.org, axboe@kernel.dk,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <ec7d21e6e16c49165fa1e8af2aa09d01c111ea97.1771260487.git.asml.silence@gmail.com>
 <202602171315.iJKYSSFe-lkp@intel.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <202602171315.iJKYSSFe-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12282-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2600:3c0a:e001:db::12fc:5321:from];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,kernel.dk,gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[209.85.128.52:received,100.90.174.1:received,2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c:received];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A287E14B266
X-Rspamd-Action: no action

On 2/17/26 05:24, kernel test robot wrote:
> io_uring/bpf-ops.c:45 bpf_io_btf_struct_access() warn: always true condition '(off >= $expr_0x7fb415932650(30)) => (s32min-s32max >= 0)'

Got me confused at first, but it's the first field => offsetof() == 0,
and after type promotions it compares an unsigned type with 0.

I think smatch is too strict, and it's better the current way,
i.e. handling all fileds in the same way, but I'll respin to
silence smatch.

> 
> vim +45 io_uring/bpf-ops.c
> 
>      37	
>      38	static int bpf_io_btf_struct_access(struct bpf_verifier_log *log,
>      39					    const struct bpf_reg_state *reg, int off,
>      40					    int size)
>      41	{
>      42		const struct btf_type *t = btf_type_by_id(reg->btf, reg->btf_id);
>      43	
>      44		if (t == loop_params_type) {
>    > 45			if (off >= offsetof(struct iou_loop_params, cq_wait_idx) &&
>      46			    off + size <= offsetofend(struct iou_loop_params, cq_wait_idx))
>      47				return SCALAR_VALUE;
>      48		}
>      49	
>      50		return -EACCES;
>      51	}
>      52	
> 

-- 
Pavel Begunkov


