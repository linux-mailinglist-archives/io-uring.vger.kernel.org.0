Return-Path: <io-uring+bounces-12384-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SNsRFjlmnGmsFwQAu9opvQ
	(envelope-from <io-uring+bounces-12384-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:37:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C95FA178223
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:37:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B9C793020EDD
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B04288C3D;
	Mon, 23 Feb 2026 14:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f7hGF0sR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5477231842
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 14:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771857462; cv=none; b=rS6cn69WY4oi+PTscMZhKzSkY02bDuYYBVund2eZ/sGin/iVc8jPA68sFQPeWbDl5kBUhbDtf1Lyld1pI1PLDRjk7kiNTFv6ohv9Py6SwKOnacVhySD8o1UBT+61O44WR6wO8uJngGVWHRXrn1aA7Fd5LNqMpUvBI3EFVl3ejE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771857462; c=relaxed/simple;
	bh=RTkzzyKDatZddgiKvuWDwjXsDtIiYngshI5KMTs6CMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E6nfUk31d9Y+w0JrOkdTJtwvf0K7ADD3n34XNyf8xH5V7VMCzbJRivOlX/DYB8TlAsEHLtoKV0uUZePbobYJydMrl25l47KAGaTZb7gmNMyKbxQbWia6ltN7Uo75vNeXlS41H5QG1MiD/DtW/HzxnvJU8zW0HJtWrazL3GU02O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f7hGF0sR; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a962230847so43311035ad.3
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 06:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771857461; x=1772462261; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xs/cTzQu5c5itdBFJSEbXqGtwlQXJ9IuXssVyXeWfPw=;
        b=f7hGF0sRsMxSPe6VyExolSVMBmlDme6fB7oFe3uchmH6LHLSSSPXp06oU5txfMK7K4
         4CS7rEwFHo38Usb/fzkhfsLmsBSu4YJHd8aGl/UNhswZ1uO7Xba9GI9SV9jAUpAioYcG
         QAAXP42JsEg8zwrXQ6nGRTIN8hAzfzrVGFZ0TE71Cajh23mGW3/kpksqYV00Tlkf1cWn
         Hbtl0WuLkVrhjAPnekulR1eWFn+jqSbsq8IKW3S8AENuuR3TAHh6lmDQXqq9mn076SGs
         lB/sw64KfbAGs6n2B1N9fiGU/DiOiLQqY5H7heO+OkfWOh1mtDrrj73VedPYyp4+YXuD
         CepQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771857461; x=1772462261;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xs/cTzQu5c5itdBFJSEbXqGtwlQXJ9IuXssVyXeWfPw=;
        b=u+JXgigpEn9FbsSO2t0Zr22t8AD5dBz6/cclKkyk96fD8bJgPNRXaNPc6x2uxjMiDJ
         bIYW+xq8qxMKugjEPQLYPsvuSI2Xue0JJ8zvbvdtQ4Bom5+llxN+ONHSVH1bFohiuZpC
         rSStTln6GiV1qLseuXeFfpUyKEVW7OXMkwi4MdceyoecT/indFhEqPvymCqee7jbO6MO
         acu/LNWH10CnkiNLHqThxnHXHFV3Rb6rXN+CiGgnH8sXrX70pA/A6pXtB6SzFjGdgyK5
         cE3AFgwThXgODz3MDeh8As6V1i9tA8vMc6fuQoY4dfS9SD9/xJ+I4tp5d5S3n8scH1N7
         O1Aw==
X-Gm-Message-State: AOJu0Yzs2zQAlPryVN4wDE5WKVT6ZX7mbrpYcMrsEYcAjnXP8avBI6R2
	4pfSAMT/m16Yc7plhATKMu6/qPhueHl/j06fkUqqyqSkZxrngFt+orksgkXidw==
X-Gm-Gg: ATEYQzzw0UJTYTOIlRuq9za8/h4bkrpxp+xxubKt2F2Gi/PCGJMdinZcKn5vbHnvxZg
	ZyasDV+Zkf7J9BMeKTLBr8fMQXF54VltHMr6IwfPQD9Tur5LUd+onXb5GfdgbtCbQkJhvcv6E91
	aSka7AtmErdY8su42a2heyCUDqXkTe7XFC2Ke+IGmB3+13P3/WoVnr94qlLffxdxjOOooRb1HEI
	RUnU6rE3vw9HZAwDF5U8oBXKVyDM3y0jh0tJt75Y5oLPCXyvQDDuOLk/8s9+zpet+aQrb369WdO
	N/1U3AC0fF9mmLEJJ4pQkcLw1AzvGfcjzAE/bLsaGNQkHQ8tLn1jlcH3ozG11+x+J9jJ1ZH9H9T
	FuVMmhqFtfhre/J6pJKYbyOe/ZQXLTKvVaMLnr52Ketyi31oKwQeB3gh+KAykFeFl3KsxbxPhmW
	VLCTNzDKo+dBFyioqECYpXez5kBvaqtmRrEaS05YN/9Q+J8gYRDUnmen70FiecWmzpHcIK2Ea1B
	bGRwYoA4PgcbuqM5tf+o6AoGNFEe0WDstQfd3g=
X-Received: by 2002:a17:903:32c7:b0:2aa:d320:e969 with SMTP id d9443c01a7336-2ad743fb337mr85824485ad.8.1771857461024;
        Mon, 23 Feb 2026 06:37:41 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325::38a? ([2620:10d:c092:600::1:36ea])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad74e34e18sm78958695ad.10.2026.02.23.06.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 06:37:40 -0800 (PST)
Message-ID: <42f297b2-7742-4d96-8a7a-4d3d8325133d@gmail.com>
Date: Mon, 23 Feb 2026 14:37:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/5] selftests/io_uring: add a bpf io_uring selftest
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
 Jens Axboe <axboe@kernel.dk>
References: <cover.1771327059.git.asml.silence@gmail.com>
 <7cc147a959ac068c55dae4f540e38e9e4ab121e0.1771327059.git.asml.silence@gmail.com>
 <CAADnVQK0RaOA9ZYZdYyQxOzLde9MR8HpMM0SexcW59A9u7X2Jw@mail.gmail.com>
 <84e2f3ad-28f0-4e9a-804f-2647cba9b30f@gmail.com>
 <CAADnVQLSEoZ0V1m5j3ggX0o0gzVKyiDHL=J6F0wRXB8qk-MCGA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAADnVQLSEoZ0V1m5j3ggX0o0gzVKyiDHL=J6F0wRXB8qk-MCGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12384-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C95FA178223
X-Rspamd-Action: no action

On 2/20/26 17:45, Alexei Starovoitov wrote:
> On Fri, Feb 20, 2026 at 3:41 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> I had such examples, but selftests is not the best place for that.
>> It can use abstractions, and I want to make them reusable instead
>> of people copy-pasting from selftests.
> 
> Sure, but please still post them as extra patches so it's easier
> to see what's the end result.

As a follow up to this discussion I sent out more realistic
examples together with v9. It also has a very much toy program
working with registered buffers as you mentioned ublk wanting
to checksum them.

https://lore.kernel.org/io-uring/9c8d6af7-8546-4409-91fe-85f92a08f503@kernel.dk

> Also please reply to that thread:
> https://lore.kernel.org/bpf/CALTww28QMg=YXqKWpWLZrLO+xiqOe3LGyput8dx68-dnQsxg=g@mail.gmail.com/
> 
> It's not clear to me whether your io_uring+bpf setup will work
> for Xiao's use case.
> I don't think we need 2 ways of doing it.
> In networking bpf is hooked at xdp, tc, socket levels,
> but those are different abstractions.

-- 
Pavel Begunkov


