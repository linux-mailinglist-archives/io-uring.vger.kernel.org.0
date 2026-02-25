Return-Path: <io-uring+bounces-12423-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0CEeHYw6n2m5ZQQAu9opvQ
	(envelope-from <io-uring+bounces-12423-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 19:08:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F6E19C077
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 19:08:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E3E2C3044371
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 18:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77F762E3397;
	Wed, 25 Feb 2026 18:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZsJgbxOG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F0C2EBB8C
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 18:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772042876; cv=none; b=UYS+J6po1yli2P7gfE6F+Pil6kypS+QVSQpCvqxYJAhe2zIuBm3antQS+ly5m2n3PuTfcRdUJp0SyEzHpXqnPD4fl/QYHkkzN1r74sb2z6/9+znDFm5ZbpWwvqoi9QnwRfqx298UCJ1pQyhqjU0psPiGxv+yeSC4m5U9DQ4oNM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772042876; c=relaxed/simple;
	bh=7u6h3P4VFl3N7W1LWMNKjlz8sAh/LFksKFwqvSTH8uQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JfoZNuiZ1WQAeRQ7H45FG7xv7kBzZITw+mRdJWWjoap40ZvN4Jm8XNPK/RgSigytfZipfsX6duoG/PGH5MIWfzcBQRHcgdKz6/6BhZoePrrSQigdCmLBKT48rv5OGpsLnxQKqUcil+gun28CdHqFFJokg8JkO9qdJHfd/jM0LYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZsJgbxOG; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-899a2f4cdddso28616336d6.2
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 10:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772042873; x=1772647673; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CNohweu8NghPPzffsYi6pRH5D4Q21gEXlPfTQd68qk8=;
        b=ZsJgbxOGAD2vTfg+VLC1dJ48IscIQIMhF1tsB4gTw2clNEYm9TVl3zq7/0FnTJ2oo7
         ZJDxhJgveose62NLeSA6T3R01f6oVuHFCvFYgKHrvoXoippKViPFlDBE9rEVzuC3j2Di
         ZaiCt96o7OsG2etHuSKL2sTA2JLBkS7Rr/juffINfd64SPcy+4JHUHof7o4bNnvPAZig
         DyFyugYovP71rnwT/UZzYcPAIjakBM3JQVz+BlqMR1An77bS19oB255MdSyc9ilBzhga
         rC4ZYV6TkdvjydjiRE6mc///mJZqcwpIwte64hFR0XDu1qYDzytM848gYguuUL1aT78d
         L9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772042873; x=1772647673;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CNohweu8NghPPzffsYi6pRH5D4Q21gEXlPfTQd68qk8=;
        b=eFjdXfTZJjeJXUOdSifKEXrxHr00bE+c7fnbwaLtFztev9dl8msCfQGvVzhLmFCCX/
         ujQGRK34Ah5A8JNIhvT3LjMWEDXDK29xni2s4m84bHm5yAiaii48EoUT+85nkfWr4Q50
         RPWL+YE5deOxRYG9O9eSbQ+0tGyrIS57BiAFMnFkXIffnG0oGQnogUP4PwfgxIuujvnm
         OsKC7RHv6Nvvv9aI4FHaZvsVWU9vsP0TvSBACPJCdyrWWXLWAFm41fXltZi6mglC7DUo
         ECBH/+lDoH4aAFwLKSQft5lsb8qjIdnWnirC4cAk115OU1TQgh3PrJfq3yVCoGtgkeNQ
         9cRA==
X-Forwarded-Encrypted: i=1; AJvYcCVsvyAyqg7rV+DCVpT1+SLDUisEPiKfykVQKiqOc8zRI2nKcsjgl/eAKbfsESFhL3UVU0zj7RBuQg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfF9rXURnEaMvTNcHjMUIsDCI6fePgStMVl3ydI/uEsTDWazf+
	qH2lOkPLLgJ22JZv+OGZawLrzz+/YPG3WOqGM5pxJLjSzCgwkNlWk7ILNFCmjk0wk8g=
X-Gm-Gg: ATEYQzwr8qK3KgCPExWYREenPLafBJnVKRVHUbq0wmC0oapqEwTTTcbmBzEFdqXGK1Y
	fuXOnW10YtgbN0O1+F56FKM2LEmhWhWq6p9riKRayVUrpZM3yFVCdMDgYKGfcYrKK+jQNgD85Cn
	Vs8fe1ZZWYWtZoAmBY8knCI0p2pjbnthYmdN/ER07/IMXxTwwyWxf0C8GiONMzcs95ydhN7BB8n
	lkItl7sH/puEZ1JgscRAC6xszLLiqfIME/m9/U/otUaNJv55c/Fly1BXiRJtN+S5LISO6Rb8s9R
	PZiM2EOQ47Lys/22VRFld6Pj85cUdog/lnlIB363Dgvu3ffqf1+1CZkLFYXsVjfD7Z7rIHwjJmz
	W8RLrcZVORiiXzLTFWbTOi6tkoh7O+5MumK1WulUalJzyc3eJTH19qb7RMxzYnXhNSddRG94Wjh
	65nkfujW9WeYv5wDYvxKmmdyIPw86R5Ff70RDkDx05v4rRrCaBcsIcSgZfMhR05bjYxohpSG7Cg
	VUdfW/6
X-Received: by 2002:a05:6214:2aa7:b0:896:f47e:fd43 with SMTP id 6a1803df08f44-899c150f0d9mr21549046d6.23.1772042872785;
        Wed, 25 Feb 2026 10:07:52 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d6c69dbsm127411721cf.24.2026.02.25.10.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 10:07:52 -0800 (PST)
Message-ID: <58b12176-0b58-45e4-840c-67fc2704da4b@kernel.dk>
Date: Wed, 25 Feb 2026 11:07:48 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2 1/1] tests: test timeout with immediate
 arguments
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <86e674b0742b1931ce197b022d228cc9217bc737.1772040411.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <86e674b0742b1931ce197b022d228cc9217bc737.1772040411.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12423-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: D9F6E19C077
X-Rspamd-Action: no action

On 2/25/26 10:28 AM, Pavel Begunkov wrote:
> IORING_TIMEOUT_IMMEDIATE_ARG allows the user to store the timeout in the
> SQE without indirection to a user timespec. Update io_uring.h and extend
> tests to cover the feature.

Would be nice with a changelog...

Applied, but there's no documentation update included. I'm just going to
auto-generate one so we have it, we should not add new flags without
documenting them in the appropriate man page(s). Same old story...

-- 
Jens Axboe

