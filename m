Return-Path: <io-uring+bounces-12613-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id COg6BwonsGnYgQIAu9opvQ
	(envelope-from <io-uring+bounces-12613-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 15:13:30 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6766E251872
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 15:13:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 40EEB32D1FE9
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 13:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8A6355F5C;
	Tue, 10 Mar 2026 13:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1s7Ng7aH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45920399371
	for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 13:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147681; cv=none; b=ay6+2mmP9oRkbvTAtaeZDV0LYjtTRGbMpE0w/pM1xyVBvx1XMO5xGFDWblBZtPDazOgNwXv47aUK2nTHGDe8o2vVFu+HE/f/88n2ztH+QBBZy/ZU1e8x7xEHN2MovUdQmFa1lxYdQuzhq4qYyTXvJZRsp9kthrSLuFNYm2L63sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147681; c=relaxed/simple;
	bh=DRM3o/0MkVngiUT1StR06KkinWD6NhgWCnmFQoRum+c=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=gdQXsMLThP44VcEFSF9xfllF+DrSmQO+R3dw7H1XYEp6yya4KSiEKFjV72leNdTtPeJXwT/rHBrNnMzLNi1AEUtvFxpyMpJ8JxoQ56PTFUOo+DHiYKfv2hZOSwzQQJFoSMVEOqW2YzJf57nI6x4OpWhxF6yhrA1osy1L9dau0sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1s7Ng7aH; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4671cbce2feso396380b6e.3
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 06:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773147678; x=1773752478; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+FUL8dOnaJUDjdgi7N142b6T8rJdjLK1j6EWyHgFwQ0=;
        b=1s7Ng7aHTXcxnib1/QZSTber0K1mrJHHs0mlMMmMy+g+PIrauHISf45XlILJp9es3j
         pfhv5OpbaS3e8/J37CXj6vvjCPoCrq+24YMWKd4+tIECiNcj1TZVwJ43F7douLBVSTF/
         59OWCAXqgoTftUmJItOEfnso0QrWVjx/KJv8ivBrq8GdJRI8jVtJG4s4Zudubz7c90LF
         ZnobiHQgI8+QqOumqxfMZlR4UO7gyWOtjXEeiqqAhPw2atL0YuqeRtPRB2gBU1nkbgJk
         7DSPEV/wDFgPWNtxlnrmtoDUG+S/m6il2AMB2PMRwrn3IfqSF9Xe8/qtGeaMapjpLL5k
         ALHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773147678; x=1773752478;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+FUL8dOnaJUDjdgi7N142b6T8rJdjLK1j6EWyHgFwQ0=;
        b=j5qGQIDlEeb6qSavw+DhWB4++ZzFjvHYtb9MYOAR0du/SE8RK6+B4UH6u9aU1EuH1z
         TJxtJ3lXiyi8B+MjuQ5CXZfy3AJc0ldK3dudfpjK968I4aovgJp1NvirC9b2L/mndHyh
         cPrMy3xBGOOjV/MsMtGRu53THM54jmGHI+JBqB3T23LagirQmbFAXKLdqxnejTjtMh26
         qHUHdpnCXB7mHKIJ5Z1HWEN6kCkm8ac1s6xY1YacmmEWqeOnBChlIJgGoCWN+8oRWFR8
         nmdwZu0EhqC79f2bhv/SwC41l6XR4CCmMfL5I69gIls32ckm00WSGVBMSBZJExWj1CD1
         1zgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcIRXZz/Al0/IlLllUJsJB22mshw/XUmLRnVndb0k6kkoyRnZvCpOJk9S0xQrfxYjZIbnVfTReWw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlUCVF27LXQ0pdBucxui6rqYfNMDVrrjqDjf+5yOcW3ucRJ4aj
	evOIt2+wJNn0nCBtKHrO8xKX0XRIUEw7yB/6j0hBbcrghcC75pVuOGYWKRlBToWtZeI=
X-Gm-Gg: ATEYQzzzdQpq3+Q3dK7RQqXIjJn46y5ybpDy44Of9KMcdikYHNPcsqhriLCxdCwsGNP
	cv01zypGuG+27zy+4CD2HYBE2TbjCnS72RPsgrcHza3DaKk49dJ0e408YLPd4NBY32oXYM+6L/5
	H4pA8jvxgEMrXMHDsM2JAkbS7rViWbz1TY7Bo1geLVhcULTGzYJaSyJZMV0t7dtCwKzfEpu5Z+D
	YAub/f9ubJK31GpH9y6OH8RzGdvpQHBwdeTCjjSgTxSyU6ZX8gm5SxKjIZBSks7YVNpC9o3Jfi7
	BhIanbcjYLAwhWiBVgsztMt9NEDCmqBBCo2x4haTFSxvM2OCbAfRwveJ6JvAmmwNC4Luv7vHvko
	jyKTpEsp9MTZRSj2XSv7q+AmzFCjb+JIfaEztDGzv3ROGbqyDzQ/BJ5tWX40yYD7HZPUy5Tor5d
	izsnrQ3f1grtWrNw91GNpoAALmX/1pTpitY19KOFB28QNDFsd7UyQe8cn/7Q0GNHQj0MSFe5XME
	W6/y7RP3A==
X-Received: by 2002:a05:6808:1b0c:b0:467:1633:a1a6 with SMTP id 5614622812f47-4671634346fmr2599909b6e.13.1773147677860;
        Tue, 10 Mar 2026 06:01:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-466df93e85fsm7477923b6e.2.2026.03.10.06.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 06:01:16 -0700 (PDT)
Message-ID: <adc62a4e-6d68-4678-be0a-331d910405d5@kernel.dk>
Date: Tue, 10 Mar 2026 07:01:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH liburing] test/sqe-mixed-boundary: validate physical SQE
 index for 128-byte ops
To: Tom Ryan <ryan36005@gmail.com>, io-uring@vger.kernel.org
Cc: gregkh@linuxfoundation.org, kbusch@kernel.org, csander@purestorage.com
References: <aa9Bjbplx3b_Uvmj@kbusch-mbp>
 <20260310052003.72871-1-ryan36005@gmail.com>
 <20260310052003.72871-2-ryan36005@gmail.com>
Content-Language: en-US
In-Reply-To: <20260310052003.72871-2-ryan36005@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6766E251872
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12613-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel.dk:mid]
X-Rspamd-Action: no action

On 3/9/26 11:20 PM, Tom Ryan wrote:
> +/*
> + * Negative test: NOP128 at the last physical SQE slot via sq_array remap
> + * must be rejected. Without the kernel fix, this triggers a 64-byte OOB
> + * read in io_uring_cmd_sqe_copy().
> + */
> +static int test_oob_boundary(void)
> +{
> +	struct io_uring ring;
> +	struct io_uring_cqe *cqe;
> +	struct io_uring_sqe *sqe;
> +	unsigned mask;
> +	int ret, i, found;
> +
> +	ret = io_uring_queue_init(NENTRIES, &ring, IORING_SETUP_SQE_MIXED);
> +	if (ret) {
> +		if (ret == -EINVAL)
> +			return T_EXIT_SKIP;
> +		fprintf(stderr, "ring init: %d\n", ret);
> +		return T_EXIT_FAIL;
> +	}

I don't think this will work, because this function requires the sqe
redirection array and liburing will wrap the above in SETUP_NO_SQARRAY.
Is this some llm written test case, or conversion of a raw use case? Did
you actually try and run the test case?

You can certainly make it work, you'd have to use
__io_uring_queue_init_params() to accomplish the setting up of the ring
without IORING_SETUP_NO_SQARRAY.

> +	found = 0;
> +	for (i = 0; i < 3; i++) {
> +		ret = io_uring_wait_cqe(&ring, &cqe);
> +		if (ret)
> +			break;
> +		if (cqe->user_data == 2) {
> +			if (cqe->res != -EINVAL) {
> +				fprintf(stderr,
> +					"NOP128 at last slot: expected -EINVAL, got %d\n",
> +					cqe->res);
> +				io_uring_cqe_seen(&ring, cqe);
> +				goto fail;
> +			}
> +			found = 1;
> +		}
> +		io_uring_cqe_seen(&ring, cqe);
> +	}

This one puzzles me too - you submit 2 SQEs, yet you wait for 3. This
will just sit forever until killed by the test suite timeout.

-- 
Jens Axboe

