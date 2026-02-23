Return-Path: <io-uring+bounces-12385-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iP9bDaNmnGmsFwQAu9opvQ
	(envelope-from <io-uring+bounces-12385-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:39:31 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DFE8178259
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:39:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1E9B73046694
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6069329AB07;
	Mon, 23 Feb 2026 14:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YruVImNw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CDB233722
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 14:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771857568; cv=none; b=XPPzj5ZSi0SWUUKTTGmtea29/KOXKun9Hpc5CQWMrwTFZ123TdchqkoAZgUP9Rtgmt7xO1fjtATkEj/dsb3UhmKIO7P6W+MF2Rvzd/QpkDthRID6UTmr9N5/zT0IVGwdbtftcVev91fFXlpoioLeLh4/BMBdUnhMglCv/AzWwVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771857568; c=relaxed/simple;
	bh=n1/9s6DtSYcJy/UIt9UlZ8z+Vd1Ss6EwqYKjwqJpEyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jtqhraKoggNXXRuq4JmPf7NeKPY6GiX4OQOG11h4kXJzHIYEQLmjoZMm76VAjOEzVncGW9eyu7N/8CAJtI6351b5FMh3S2rOYqf29emiBrKXge7tpytJQ2IshR9Na1ceRGXthwsqQmUA7BjMmSJDbx2E0xb9vX4Uk3S8GviItxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YruVImNw; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-673ee2a98b1so2476427eaf.0
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 06:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771857565; x=1772462365; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kPdrQ0UNYgw0k0lMo87j2lc39zDlBO0R2EUnBXNHeKI=;
        b=YruVImNw5d8NJzPZmdecH55fP2SiBgIfwd2X/9LTIme6AHro7Hna1ITDAm1c2XiD0Z
         F/PyY0CHsF1i5xjA5f4HOVUcEkhiYeHe0c/T/wpD9Fw447/+FEkeGJ5lJP6dZlDEPsq4
         Mf+V/vEgdb2ISr8Jmn433KLvuZqBcwd0lJbxEC49xzIu+3+IQNI4AgBtrsReWXOwlwCT
         03uuGaoZS02j24rGvPbHd+SG/vZJzheMsYtifbck2gZXZMwehCZ+ezWgPVEW9bm48iKS
         3w4dB7CtQdTIj6cwBIDa1wWqK9eiBVc/zPeGDWMyB2pFDLsXvKiTb6pCC6bnDIOwdtkR
         0IGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771857565; x=1772462365;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kPdrQ0UNYgw0k0lMo87j2lc39zDlBO0R2EUnBXNHeKI=;
        b=oIEV4YcaXOl012gUH1hthDJ4IlMV4skvszOnammZdzfnF/alHEqjz0EfFafzDhnXq6
         rvfu65sfZA1o5PCFHnkC/L9Zbs47FWfMk4//77vGxrrlf2EuuYzc1SWXMFy0W7I2uf84
         pZ2BkeqJca4+JU/ThGwIKJNMl6WCFbk+tLtPOU7lxkJbX5S8zIJef+l3v8BeDe235h/G
         Y0FvKYAQVMkC2343mPsTXjgp8qZyxnxhjXuLRlx7oQa44SEiftRoe78uBv/rm0KaOp15
         C/lAb/McoW0FyevwlLOtgSC/zfgqszFxALiMGGfZjxdfa0lSzEFnjof69Hrg7dfdcrx7
         WP6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUIepK1EqoDIDY/OnKI+fmNF47xsBGKFrXCXxPuvQEjSn4y6rMgCBWvbtWkuLugt4WKCnEDtRC8Ug==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+eL02UpK4glUPhNBu2FnK43myMA9KxWs6iteFM54H+4O5jrdS
	4P5qd0Q3sCOM+MT2v17KIvoIcPssPBij3AbKailSE2ZeRddv+Yp50yFERJGoFB1o9lc=
X-Gm-Gg: AZuq6aIGr9gKJ/BoLcd9uNneXG+sidjpegeeqGmvAnlBpjEZQFyqVZGsPsKJ+YE+QZV
	Txx/hQFgBl/1K5E3S9HIDt+hqF+xATUZKOSRE6BI4ZsPjIhLTemOzuIdBDLjJf+6Gx3IVC4oMQN
	6eik0I9oazp6rksBKDWXVeip8aHR96ja9RDq0ZPZw8gKBdhE75VxRJKuAMnlvWVG0xGKXcCNPVk
	i6g7yRddMRsuu8+SC/xncKxyzvQWmEea3tBTDaEW0AhHwBrs6N6Qc/mk23GO3Pk7uEYIF8SgEjw
	OzHi7rExFAJh+xjCkupX+addV8/qavXxRKSGy7t+//Bc/+T7xNX5lHUTlyEzeZqiIxwHPrWhdOW
	vL2QKY8Yg87U0DhjCF25fa5qi1Aq70iTmV+c8L4QGUSIury1M74aQmwOKyOVEUTYAutPvBKMvfc
	N9r0CQncypuVr8AKdIjcXNX99yqfwS3yOm9rmYglRH3MdaD1D0miaV1YyaJNXmFnXI+Oh1IEewK
	6I4AYUyyA==
X-Received: by 2002:a05:6820:2d0b:b0:679:a617:ed0b with SMTP id 006d021491bc7-679c446e96dmr5207128eaf.27.1771857564992;
        Mon, 23 Feb 2026 06:39:24 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679c5644224sm6188499eaf.6.2026.02.23.06.39.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 06:39:24 -0800 (PST)
Message-ID: <a7e1f667-04ba-4fe5-b21e-8c47e68213d3@kernel.dk>
Date: Mon, 23 Feb 2026 07:39:23 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] extra io_uring BPF examples
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1771850496.git.asml.silence@gmail.com>
 <9c8d6af7-8546-4409-91fe-85f92a08f503@kernel.dk>
 <d808f483-3c0f-4323-8faa-0b7d49c539e3@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d808f483-3c0f-4323-8faa-0b7d49c539e3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12385-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 9DFE8178259
X-Rspamd-Action: no action

On 2/23/26 7:32 AM, Pavel Begunkov wrote:
> On 2/23/26 14:14, Jens Axboe wrote:
>> On 2/23/26 7:11 AM, Pavel Begunkov wrote:
>>> NOT FOR INCLUSION
>>>
>>> Alexei asked for extra more realistic examples. This this series is
>>> based on top of v9 of the io_uring BPF series and implemented as
>>> selftests. There could be more, but I stopped with 3 that should
>>> give an idea how it'll be used:
>>>
>>> 1. A QD=1 file copy program that show cases state machine handling.
>>>
>>> 2. A BPF program rate-limiting the number of inflight io_uring request.
>>>     That's a good example of what users asked for before but seemed to
>>>     be too niche to be plumbed into the main io_uring path.
>>>
>>> 3. A toy example of how BPF can interact with registered buffers.
>>
>> Let's please keep examples in the liburing side, where they can be
>> with the documentation too.
> 
> I got you a liburing example
> 
> https://github.com/isilence/liburing/tree/bpf-ops-example

Right, but that's just the nop thing, which isn't really interesting
outside of doing basic verification of yes indeed the kernel side works.

> but need to sync with the selftest. I think I'll rather keep the rest
> into a separate repository instead of adding all helpers to liburing,
> which will inevitably do similar things but deviating in API and
> internal details. And it's simpler on dependency management instead
> of requiring libbpf / etc. for liburing. I wanted a space for
> misc io_uring bits that doesn't make sense to keep as core liburing
> anyway.

liburing should have support and documentation. It's not that hard to
check for libbpf in configure and either build the support or not. Once
various feature support ends up being fragmented in the ecosystem THAT
is a mess for users, I'd much rather have it consolidated and deal with
it on the liburing side.

-- 
Jens Axboe

