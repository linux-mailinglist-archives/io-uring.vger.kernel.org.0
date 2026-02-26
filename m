Return-Path: <io-uring+bounces-12436-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kPXKBApCoGmrhAQAu9opvQ
	(envelope-from <io-uring+bounces-12436-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 13:52:26 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A6A8A1A5EC2
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 13:52:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DDC2A3015DB7
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 12:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43EA2D877C;
	Thu, 26 Feb 2026 12:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZuxO2bl8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FAA2D780A
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 12:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110343; cv=none; b=OahvGzE4J7hkAk5OE4gUQpCMBLgl/l8MRRl9xMf0S4oNk001V+pmveOURidgwIS0WoORlesirE9uMSvTfeSAh5r+Rq2CzAMwxZUWMF5CcWxHfab/d5pIDb5cbRC/svGKAFUJ+SJCgDU/3Q5WGgg4hIEMgcrmfbyHqqBRdhtx4AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110343; c=relaxed/simple;
	bh=VF6fV7I/BBDP0+MxJD3RG13GC0cphKYltY0psl7Zb+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nuUOVXm3J5oE8eLA5TZM5AUoTFv3O7Sjx3zgyVS0feY3WdHCaaGk2V7DbgzSsPPxyg+KPn3/oKAo16gYYSN+HNiREju0MQ1+PY3JaQWTb5kBc+WQiIxulBi/aY8El0cYsAf79cmbgcJ4pL+VGSwfzZMURqklOSUT6DJQQ5Ql8sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZuxO2bl8; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48069a48629so9038855e9.0
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 04:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772110341; x=1772715141; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LbGgExmn0uGsOqx6C19bqY2pEwWmo7ByORl9v0udAOg=;
        b=ZuxO2bl8JKSJ78Iqln1FNZFQFA9ntLvbsid2Tv6h5dTzaGLY8lHfRNZ4+kWDEfZxU9
         IkKe71XyBSwFy+cvlhuirVxfDygNnhTpdZAxb1vPhYkFVfe8ZDklR4BMkO+WGUvond1I
         NLWbMwBBbwcuHkBv+KJDRrA3F8XZ+7VjL8gN01dJe9aaU/S6zOritWrk4bXpBrtrjWYZ
         2Yb2h8MZiV5Av6l65aAAnTIbXGT4v+y2Z667MkpT32xQ/mYNGZIMqALETylUd8Hu2VML
         kZvevJTIJYzhntQiW0LXJL5GVGRuneBkq8sLJIiWcj9B8G6YhOfDcWzFvPf8ImSpw4oh
         d3jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772110341; x=1772715141;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LbGgExmn0uGsOqx6C19bqY2pEwWmo7ByORl9v0udAOg=;
        b=da0QORXwQZjEUenIofnTOEkTL+5s7Zwmzl+6rIvyiXsse9fdcrwc7fxWg1uvLfjxIS
         L5GDwi16f8kiumwmMrGbzZKrm0qiHjgqtvRAsrzeGuDi7NkxS5QrkyQI25Hq4/4jUsfj
         zdozjVCp8qoccl40qBgMwJcTSHFzxdbRcNIZ+503P8iA8JevBqWSEpHr6eMW5szeWWgp
         yW3nq9hWcergLkCaGD/zlgmxS2+BUkAwR7x0C4ib9+vDs3fxJWVPORpmsacgmZvSn7Re
         3Vdazq8Poo+05qvcAZzFejf3htXJv2l1a9De5CNpjexv9foTeKSdPBT5hhwpsq4VXqTC
         DU/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWR/gRVxiz7D5IXmd79JjvOBS4SGvfWfqWHwvdBCmRKzgsKwaBGFUaVxLtS+L8MgmIt6EvGk8i8Uw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwmgIHhB4/TyX+Cg8zzU2MIxG+tdm+OH77mLUnMDs1K7fG9bUSE
	a7A0QPKyobd2Bf5foyn9DCWspHd8HAVIpjZcRkwwwOw5cpb+4LQl3K/n
X-Gm-Gg: ATEYQzwq9fE7hQ7LV7ZntEOyBDkKos6pRe1JlRrmw8IJB5yv8IQdb/e1ZUQQ/s0f9PJ
	O4ZWdE5RwDod0xR2HW//Uc6wBC6aNeBptiLGFZ4QP7pCnksRwWNJOhpwC4rp91WbWKnmc6g8XnG
	YuGIyqpsHGS/vkF+k0YJ3gwiMJqq/CkdtiloOsZjUtLQ+6V61zY7ZHqWVqCtWtx6SeJmbRoynMU
	sUoiu57e7DWR6ZSL6Dh0WozO06UIoN9DaWGd+iTxv0BI/TqIKz63UE6TOU4eNZGpm2OED2htlxO
	3eoPweEVw3bHsknXlXpX39yOWamFlce3xciPW0hwW7kGNqFKooI8jSkaKtfpFD+LUKvH98WO6hJ
	rM26RtA0Up7yjKfovkVa62MOK9wpzuSWmJtPkF9r++QnzoeqQGgEKX1Ij7bFK5M+IzHyOFnPOTS
	bRTYqra21zGQSv5hVB7ASKA6/S8sp9DZ9c6MX9sifDg3ADsEbMbVwg6rTNNplhwO99i0SoAUHk+
	ifNbyL4D5f49BNI7AAxC8DftLu94KJD7hPW0A4zERLv46xHMluZaKkKGuk=
X-Received: by 2002:a05:600c:a42:b0:480:20f1:7abd with SMTP id 5b1f17b1804b1-483a95f89e5mr381968605e9.31.1772110340702;
        Thu, 26 Feb 2026 04:52:20 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:2ab0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfcbf789sm34826545e9.17.2026.02.26.04.52.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 04:52:20 -0800 (PST)
Message-ID: <d718db45-cd6c-4d89-ac9c-8f073d31eaa7@gmail.com>
Date: Thu, 26 Feb 2026 12:52:18 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2 1/1] tests: test timeout with immediate
 arguments
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <86e674b0742b1931ce197b022d228cc9217bc737.1772040411.git.asml.silence@gmail.com>
 <58b12176-0b58-45e4-840c-67fc2704da4b@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <58b12176-0b58-45e4-840c-67fc2704da4b@kernel.dk>
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
	TAGGED_FROM(0.00)[bounces-12436-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A6A8A1A5EC2
X-Rspamd-Action: no action

On 2/25/26 18:07, Jens Axboe wrote:
> On 2/25/26 10:28 AM, Pavel Begunkov wrote:
>> IORING_TIMEOUT_IMMEDIATE_ARG allows the user to store the timeout in the
>> SQE without indirection to a user timespec. Update io_uring.h and extend
>> tests to cover the feature.
> 
> Would be nice with a changelog...

Forgot about this one

> Applied, but there's no documentation update included. I'm just going to
> auto-generate one so we have it, we should not add new flags without
> documenting them in the appropriate man page(s). Same old story...

Looks like you've been generating AI slop for docs, so I assume
you're not against it? I'll try generating it next time.

-- 
Pavel Begunkov


