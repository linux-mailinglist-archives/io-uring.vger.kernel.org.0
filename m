Return-Path: <io-uring+bounces-10818-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 303B7C8BF41
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 21:59:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F186A344E3F
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 20:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBCF24A046;
	Wed, 26 Nov 2025 20:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NQkTbokY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D485D315D30
	for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 20:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764190731; cv=none; b=f1xa8n8TZG4EBsn3ew7c4+P+MLXhX9sKR904h0qntPnfDUoxdkKEoI+nsVOyHqwXetHi2jDPVaotDxMfRfFeqxcFIE9lzDdjXRYhhuRhO6c79KgDwkzo3eY2XpEbqn+8eD+iMmP8alyufGK7BX3MN0jvEcEb7pBEJBIpxkcpqB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764190731; c=relaxed/simple;
	bh=zUFiniS1RCIRSb21naUxOGAeRsxcIhq03tzd5nhI9fM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QnG9LlLgIbhlRV/stANDv2zWK22zg1ooUfNAh3CwHyGmfiD2fQdZz32vpV6HqawtGZXC8hGRDqQprUSS5uM13aOXfSXq4olzsQY8X5Tg+92fTW+DTMakcahO3WieoK+/melQq4B7Oy3qtngMmBRiEsoSSLj2are8cjB1IlDChUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NQkTbokY; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-949033fb2a9so10291639f.2
        for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 12:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764190729; x=1764795529; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M/6o7fD/X1w38bcYZSSFkxeTG1cJnHmjfX1K9OAX0cs=;
        b=NQkTbokYdzev/OK7iqKCo5A1uPQoAliI1M+rZk5+8K18iBkb0VEqNhRZv6n48jz1vn
         +zP/W+563atM7mvkhE2mBcBAfEBuDggIgqhpobHHbxUNeaF52qzHWW0owyo49WstiXsr
         WHrxgVqoC/9zIlJaxzO2sy8U6J/a4RKtOCfvSmsbD7u6NJmbUmkTGdJhV9QOVnsUzTwi
         JYFwYJlWA5x+9r2PY/EwAXYmg7L2ru5YunagPrN1R/+3W32vs/7jhhHGuspC8OpbSxlG
         n/YoTDZ/MWaooXAu4mcTEJo8NkSfTvlNckYE8/tLjoTMOn3SgCenv5QurGdH3iB12qBL
         EqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764190729; x=1764795529;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M/6o7fD/X1w38bcYZSSFkxeTG1cJnHmjfX1K9OAX0cs=;
        b=CTtP7w6tyAKBJOvjFBMEbdN1Lw3VFjWHsk90XB6c2J2qUYnZ34oUSYKK3SHwqSQYi1
         M3mHcmWssTaQnpTSlH9NNpURHNjgG+mZThJPWLciXVvqV0RfTibNy3GHjBIcIW3+eTlv
         eAGJLTZVPjXklUBw493vxHwcalOMYYG9sf6hUDPrA89eZR9gblComBh9bUxCplJvo6Bk
         BzMDA2PWw3XFwwP0bd7xnEu0x1E4mfWIdBKv0soaYW2k/URbFOoMee2ImuMPtNeNgqqE
         WRZCpf5cDJFBFvTE54ul1puJGL6iIEC2ohrOblg2pbV2PB3omLTGwYYkeq7nHAg9S6x0
         W8YA==
X-Gm-Message-State: AOJu0YyPsCguf/mKhwta4NWOEcVeM8ZOL9qdPH7jmZ/eiMi3CDS/xWRj
	cR1rV9t18NLAN/zlNlZT7FO1XMhWA6csLnSxlvc6krZB6DaAiMu5WMSWYeeJ8ZRTSAQ=
X-Gm-Gg: ASbGnct07h6mLVJ9yVoigxMD+a2YhlDd0D1ryGpNwrRKwwowrluNDGW7Vryjnqvrolb
	x6vOxcIo/t93Gy1+dGcsE7Ndb2aNavoDM5Kntm3T9i97b4NxjSTCvn6eHUwrS8Y64rdO26bk6Mk
	Rr/LE2EYTmMqNcGCzYAy4o4vUubFGI9w5lXfZI5PVLGw7sG24LMwSCG9/sHn7TgVzVRGpqkbJtj
	xdrqYB82jXDw7G5J+uE5Nyi0sb7yhRkd4bFUZp4uRbY9Gyfo4ktpT9wif/MMW3/QHIkZVTVEe6w
	EEdbx3SS2cBBqWHPiYSSo7Ew8F2CaM8RTyrI1KXYEkDaQViGZ4NXMJHufqNJ7+AJ2r8P8Ky0KBk
	XBH4JYxRuAft8u1OCCcpPcLjaV271+dRAP3QzcNjQBPWvr9y5XD6Q28rwsamQXFkOmnCgB/REF0
	ekX7/IYFJxWRK2gvnU
X-Google-Smtp-Source: AGHT+IFF8ceS8VSKQQ1KOf/d/myHIuyBjYxIwkR58sy+cagcI4u9ISGQT3YKrkigO1FXJjif1IHqlg==
X-Received: by 2002:a05:6638:c46:b0:5ab:77fa:f19a with SMTP id 8926c6da1cb9f-5b999632a14mr5614079173.8.1764190728883;
        Wed, 26 Nov 2025 12:58:48 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b954b48ed9sm8942941173.50.2025.11.26.12.58.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 12:58:48 -0800 (PST)
Message-ID: <62bbd237-532a-444a-9689-951c3d297d56@kernel.dk>
Date: Wed, 26 Nov 2025 13:58:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2 3/4] bind-listen.t: Add tests for getsockname
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, csander@purestorage.com
References: <20251125212715.2679630-1-krisman@suse.de>
 <20251125212715.2679630-4-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251125212715.2679630-4-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/25 2:27 PM, Gabriel Krisman Bertazi wrote:
> @@ -192,6 +192,30 @@ static int test_good_server(unsigned int ring_flags)
>  	}
>  	io_uring_cqe_seen(&ring, cqe);
>  
> +	/* Test that getsockname on the peer (getpeername) yields a
> +         * sane result.
> +	 */

Please use:

/*
 * xxx
 */

for multi-line comments.

> +	sqe = io_uring_get_sqe(&ring);
> +	saddr_len = sizeof(saddr);
> +	port = saddr.sin_port;
> +	io_uring_prep_cmd_getsockname(sqe, CLI_INDEX, (struct sockaddr*)&saddr,
> +				      &saddr_len, 1);
> +	sqe->flags |= IOSQE_FIXED_FILE;
> +	io_uring_submit(&ring);
> +	io_uring_wait_cqe(&ring, &cqe);
> +	if (cqe->res < 0) {
> +		fprintf(stderr, "getsockname client failed. %d\n", cqe->res);
> +		return T_EXIT_FAIL;

This will also fail on older kernels, where it should just return
T_EXIT_SKIP and the main "call these tests" part of main() should handle
that.

Any liburing test should run on any kernel. This is important as
regression tests are in there too, it's not just feature tests. I should
be able to run this on eg 5.10-stable and not get spurious errors and
then need to look at why that happened.

> @@ -417,5 +512,10 @@ int main(int argc, char *argv[])
>  		return T_EXIT_FAIL;
>  	}
>  
> +	ret = test_bad_sockname();
> +	if (ret) {
> +		fprintf(stderr, "bad sockname failed\n");
> +		return T_EXIT_FAIL;
> +	}
>  	return T_EXIT_PASS;
>  }

So here you'd just do:

	if (ret == T_EXIT_FAIL) {
		...
	}

	return T_EXIT_PASS;

so the test only fails if the test explicitly failed, which it should
not if getsockname isn't available on the running kernel.

-- 
Jens Axboe

