Return-Path: <io-uring+bounces-13287-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0BtsJcFQA2qR4QEAu9opvQ
	(envelope-from <io-uring+bounces-13287-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 18:09:37 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E990252461F
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 18:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8D7D532917F2
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 15:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB3103C1F47;
	Tue, 12 May 2026 15:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="gzPQroTT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6C53C1F37
	for <io-uring@vger.kernel.org>; Tue, 12 May 2026 15:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778600083; cv=none; b=olSbsAqOTcD5w1rFKWejdBrsU32DlIf4+DHSoIS1vTT7/3GHlKy0Ke7vUZ+Z183iMJ11mmy7bxUwWji2JCNyFOOoLPauTeOXyfrQkmt8Q1TSNaDQf9w1LTK3T3+hKoJ5dJc6UxfR8/uLeS9lKNDWDjnYPTMVPWdY7+vCKvwpOBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778600083; c=relaxed/simple;
	bh=QIZ+VGeXVpAkpC4tmiWW4M33ME6DjwQIZMRpO36FIxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nFO663HFi9kMlSACxfGqmFvQocJBzapPRvJdCBQmRhrTsYBuYAozLeHZEZchp4iFpiUA0pVVw/BPBTM4CRNd9ya+Rj0Io6hqMOq64j/H3Q+VGSMrDmb0E5cxu7TnuLANRZwhybMbqf51YyuXLoQri8gkvZw1UddCUV+m9rr9L5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=gzPQroTT; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7dcc9b506d9so4627999a34.1
        for <io-uring@vger.kernel.org>; Tue, 12 May 2026 08:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778600081; x=1779204881; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6QXvd1Ks37rkL3H8X8RLMBYJecvq7AKSZyf6QRiWnUI=;
        b=gzPQroTTaRhn5RKzGkvAjFe535iCfAJrrXuWzBDjrPF/iXa6GqbvjGER7JOoftK0Wi
         NKzZgxOP5TshqZ0Jd6OhrFMBlo9fjvPudw+yFs2nogukJyIvnNO0hWtb1lvCAZlfnsTg
         LhIaXK6nzajYDs0a+t71Pcfni0tfQyRFL2/NgAR4016WNbMnd5jU4egggcCDpbc+P5Ty
         lLLNxkLacvQvSsGD736E/i+W9z+rcz9tcx4yXOWeEwwPHV8DAJes6Dh0gqwwjTpBsp+I
         PIRRxF5pco1/0BU8U/kjFxBPlMf7dVhHZFKcVstYf4H3swhRiaWH5OSu9cKGYM0U+4AM
         njcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778600081; x=1779204881;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6QXvd1Ks37rkL3H8X8RLMBYJecvq7AKSZyf6QRiWnUI=;
        b=Z7tP/FSgKMEwH+YT4cC/eDeG8PL9wCZRMByz6br6gKDpCuz5am124Q5H9cJdbycOB/
         oIiMEbXtqcHhOjVkTkuxPZhWwVxuw5GVwakb5ZrWJZRCd/QIwDrWE86cOCLIFsLspN/T
         ghxQ3DZCzamwIpDcwHExyC1CyHN2G2tjzEcu0H9/6a0MNhLbSPWCZ8dJXNKzlcaMONOP
         mk4n0rzzpYTkJngTf2JLil/XbEXtHD0Ku/LPiCoek/suoQ+lRia2RuaShYMy3CU6Tr2T
         FkBHXu7ZLWmbIOFoQ1tSHleT8kwr/VHUrTs79NRO2t2pC8T2GLlIMKyyxT9dAUgXXemR
         Q1nQ==
X-Forwarded-Encrypted: i=1; AFNElJ8vMXmpwttDKfvG1hQEKnT3HtYPggTEK6INd9aOB9jMXjnCpiwCNmoHn9snlp3f6S9aDqbbnYOcBw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx56Awuqb1qqdBKsn/7W8VT90NWJxv4+D7xGSJQawd7nHsUb/qY
	zCA1t+KczPViJSkjic/KOLyGzprgp0Nf2PQQQduvDB8oZp7F75kBcHcxJk9LiR7gyaN/QBrTUMi
	RICnb
X-Gm-Gg: Acq92OGpv4/steg5Jy6cw49pTmFQ3wbevTlLtuNCDbufFJb3i/o/QvQcRyawQdrt88m
	R8pwbUa9onVNeEZD99rRdwf6eYcJ8q2NzIRWLOVP4p90YmAWs9OQrMrVvezTBn+q1VyxCYTKEur
	mozVg3+v4+j0IG56B7+VNGQAKRfPaT6G4p/5imM1CJ/mml+Bk+NRhyn4hw/+IKBkUvVyeAV35xM
	att3LDUec9a4KbRxRbwwOtYgpzb0W91ERa5SIbuz7Og1Ovhf2G0ZTZawrbBKTJw7LaqbWqqfpkq
	kv/Gh2m2LHruY4LkkdJadNNLcqnXZibiV+csSsZnCm1NwraHcKbQPAnkV1QhhmbStFdm9KUgQCE
	LA95JnlLL3A5WIug9zbsLZ4lx+TiGHLJGgl567cX7KW5a+0xSq4RhAIYIjYF2Gj5+EQj+4g/RG8
	pc8RvGxOJF5aXeOf51d/r6+UBQkauJiE3ARiLbbdodwl9uL3kewUXErn8qnVU3Sqxu3nJ5re2yS
	8CxOOic
X-Received: by 2002:a05:6830:6734:b0:7d7:fb8c:3c29 with SMTP id 46e09a7af769-7e1df0f9574mr17794084a34.14.1778600081272;
        Tue, 12 May 2026 08:34:41 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e367be21f6sm9049277a34.2.2026.05.12.08.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 08:34:40 -0700 (PDT)
Message-ID: <add165a5-769f-4053-8ef4-27424cfb8a5c@kernel.dk>
Date: Tue, 12 May 2026 09:34:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: allow filtering on IORING_OP_CONNECT
To: Shouvik Kar <auxcorelabs@gmail.com>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Kees Cook <kees@kernel.org>,
 Christian Brauner <brauner@kernel.org>
References: <20260512110242.26219-1-auxcorelabs@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260512110242.26219-1-auxcorelabs@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E990252461F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13287-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org];
	TO_DN_SOME(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Action: no action

On 5/12/26 5:02 AM, Shouvik Kar wrote:
> This adds custom filtering for IORING_OP_CONNECT, where the target
> family is always exposed, and (for AF_INET / AF_INET6) port and
> address are exposed. port and v4_addr are in network byte order so
> filter authors can compare against on-wire constants.
> 
> Skip population unless addr_len covers the populated fields, to
> avoid leaking stale io_async_msghdr data on short connects.

Looks pretty straight forward to me. Do you have a liburing test
case for this too?

-- 
Jens Axboe

