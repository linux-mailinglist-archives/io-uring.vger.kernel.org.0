Return-Path: <io-uring+bounces-12746-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4NbLGGPwumkfdQIAu9opvQ
	(envelope-from <io-uring+bounces-12746-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 19:35:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C88D12C161F
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 19:35:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F06F23056DA1
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 18:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792C33D5254;
	Wed, 18 Mar 2026 18:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QGAJNkUq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C9C2BDC2C
	for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 18:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773858513; cv=none; b=rVPtulBPuxTKM123ItkuoRyRIlY/Uywq1S7y/d893aMehQ7XJaaD2GZJQ+HWQLNFrY3jxgVsdY9leb6AhWnBrUuqQwFQy0HZEcMA2nBXf5iOMXKkx5IELyWtAGEDTzYW/mHcgSFO2eJryeI4N62qJlqGB6WaWgJ6KeyY9puhqcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773858513; c=relaxed/simple;
	bh=Y5x2K7es3byp6TgidtE+c7f64N0YuVZmn1koHCxyq7A=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=f0UWcZpvqmwVBYpYwAWwI3skxguxANTIHPZjAeC+e4w9k1Mrrl4opcsg7dOoGnUMRdn9pGSm0LzE+OE6rSupnxTWnG94Bq2qSJ3XH05gOIHEiGRc3BpKYFScIbd/jthHcQxcP3Cm4883JXEkLti88moseTdk5qeXDfjCrTHE5kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QGAJNkUq; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7d73d6976adso107483a34.2
        for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 11:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773858511; x=1774463311; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RyygO3QDx8pQC8eoas/WmtUGx5yNnCF1A2HI6flfRjE=;
        b=QGAJNkUq4rRqpaWTpNN9IxvG7hWnLtOc7KUt/VuRfUDQYA0SB7dc0mE+plAHGuymMM
         lTo5nrJVenKSHXamw2TtmO37O8GkCkdL16Teo/hStiGt2Ch2KWJ9o+e98nNi66LYraxk
         JcmUN44znoqVi9orXblkP9ycM32vy9lziMcu2K6QyY0yoOiMM4545Qq2/C764PGNmD55
         UD1KpWZEFy68XGFoXm2O4HpkW3N6FSTtLXZsuUxxx6zG4l6HpJcJRBo96VaE3youiII7
         U/FkyW5CaZOv+bK+yVcqF/ByWPgV0Hx9ImspJeJZCQDGg2Jca34HlqCKvk8n7PcoYqRm
         8MqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773858511; x=1774463311;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RyygO3QDx8pQC8eoas/WmtUGx5yNnCF1A2HI6flfRjE=;
        b=WpQegVu70n1r3u/XqsC9QsIVVFo3sGnHpgpLp62pVreKu1pffgCAtzSulZriQb8e5m
         Br4sbL3JjfsBxzC2luC82MC4TXsIVff1eUp2ahiPjOYbzWo5a4avlCKurAmPkVWgaDda
         nt43rMoAOWyaP80NkmB04UsDoiHiP81UtRQznlP8/BxqKjHSkfdVtXlFnCLhaNPZQTxM
         ftLVlWkYu5lt9rK/tek9MIZ/WYWaDRyggO0kRo1PZBBAfc4Kuzz9ratUXf46vqJLXgwM
         omgyTxuZTVKUb3UEPQ0Z9feWXMJs3oZ09XmUSesQT60wOjg7BQJxfNe4WjoxD22RGbbp
         D6vA==
X-Forwarded-Encrypted: i=1; AJvYcCUZl07KwoL2bigaUCw1UETI1dppC4i7B513bgAO0HeGRlKwynFFpnhCONPmSDRbPlMOWNHksEfyPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxincU6mfxwermRuIxbETb2Si3dYw4ejo94+kNRFGphiTz4Wd4y
	KVO7J/8/xH2EsGiJ62dEx7Di6rZL9A5Hz11N3RmNSLJ0cHTADCCLYJ6u/0wIvzXf0uI=
X-Gm-Gg: ATEYQzz1KlyMh0nDmccm5CIppC8J83mC6nVWkfXV9sOUHsmNVRBFByERMSYjmwX2rRV
	1hGEAdz3ODpOJGCLXQ/cqc0eHbj5UB7/cr36gNTtyYjxOCmSmdt9Im0zfLHg+YvtGRpYPNitU5P
	EYHQcNCb31Wh/JkkhH4/6IbT8HCTi91JT52s2IbLT/3EmRkQGAGfGCSXV9h8EOoRELcqjEZUuzR
	5U584hPQdzLIbDVzbbGOjhmA5/LktAi7GFVNXkspZIl0DHJ1vEety9swcGPlJo5Y/loo44159Og
	fgFcPOTPDqJxGXw+rRcEIDwqdtlOOy8okcK8lCFAl/tE+B1lrSPcXIPcfLuokdmsSo986H/k8P6
	+73zJgPCZ7J0sjV6Ny4DPMGbqWAlGXL1aDAdvX8Tj80hc/sqgKV8o4T7UAPvo+/vD++5E8wrtEY
	iHI8gUlV6JOBhsElBr9cfg5JlefYO8efLagYW6sG7DU1CvfXGkXkRLML7gdygINWyE7H9n7Aqd7
	a/9XqTcer2rW3wHF8Q=
X-Received: by 2002:a05:6820:a0c:b0:67b:f12b:7f09 with SMTP id 006d021491bc7-67c0db1af87mr2882864eaf.57.1773858510699;
        Wed, 18 Mar 2026 11:28:30 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67c0d7e5ca8sm2185363eaf.1.2026.03.18.11.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 11:28:29 -0700 (PDT)
Message-ID: <84859817-8af5-4468-8980-fe25417d6572@kernel.dk>
Date: Wed, 18 Mar 2026 12:28:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v3 1/1] tests: test io_uring bpf ops
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <8c9cb9cf824e09271df9c6d6d4398e514d9c5733.1773855222.git.asml.silence@gmail.com>
 <6b9ef71d-118c-46c1-8f33-56145ddd8664@gmail.com>
 <3c00370f-81b0-41d1-8deb-beb1781a75bd@kernel.dk>
Content-Language: en-US
In-Reply-To: <3c00370f-81b0-41d1-8deb-beb1781a75bd@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12746-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: C88D12C161F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/18/26 12:24 PM, Jens Axboe wrote:
> On 3/18/26 11:43 AM, Pavel Begunkov wrote:
>> On 3/18/26 17:36, Pavel Begunkov wrote:
>>> Add some BPF struct ops io_uring tests/examples, one is issuing nops in
>>> a loop, the other copies a file.
>>
>> I needed to conditionally compile based on whether vmlinux.h contains
>> io_uring BPF definitions, so now configure probes it by generating a
>> temp vmlinux.h. And since I want to be able to pass a path to the
>> target vmlinux, it also became a configure parameter. Not sure if there
>> is a better way to handle that.
> 
> Looks good to me. The configure changes are a bit broken though, you'd
> need something like this on top to not have it fail:

Oh, and additionally, at least my my debian test boxes, bpftool is in
/usr/sbin/bpftool and hence it won't get detected unless you run
configure as root...

-- 
Jens Axboe


