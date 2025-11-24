Return-Path: <io-uring+bounces-10763-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 48115C80B0F
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 14:12:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E6DD534481C
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 13:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 669FE2F9DA7;
	Mon, 24 Nov 2025 13:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fao69M6k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E31226F467
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 13:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763989958; cv=none; b=Fq/roNV5OYmysFxlrKJwGM4d+YizgnjKZKq4bHkiOUD1C+b/33UEFOzwvZva5e6g+Hm9aSMf3XXDeertLHVsWOJQdu75QBW/K8eFM0XR0W16eNUEShdOI0yocTKWFM0FmgValvR90EIsKLsRLdKT+gWdpVqvJjXetAjs9qYvHLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763989958; c=relaxed/simple;
	bh=LVOeGfX/hrncYVszLSmkoVX2bh+Fnz3uRx8/nohuEvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hv0WLxfs2IdnCOMAIdW+H5sEma8UowPw7PQV0XwrKmics+u5U5MXlftea2NuemiEU9Gj9YN/CGRrdanSKe9ktzuZPRvU7V5kdCGz+11TqGqz3FrBb6uwg4dbH/7jSx5XyWUlKGIyEV0K26Ok2Wopmat1qSSA2d6uWASkaBJuvKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fao69M6k; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42b3b0d76fcso2652784f8f.3
        for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 05:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763989955; x=1764594755; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K/jAyvXkLX8H+nuUsYcPgHdNHZqUW0ZlRkXZiy2I490=;
        b=Fao69M6kOSKQRbPpkncvtBfJ76Bg/Yz2iNMbrijD5u/o8gE6CykzW/spmPBqf+3fIl
         WPKsCMUwWAPECxB9UyD08pLzZxvbEkVKvZqsFjvUkH1POYCYuaVwwpZxvsCQiQK6STj+
         gT78AMt981ObEoTw/SHxNnFRi3mtq1DYQ9FTzzHeiDk8ZQbCwVibhm1XRLf07XOfmwcV
         gbGlCOg5w/VM7JqwqqL4YX1b2hR7onzcLBQIC5QfDGulH/wSK1BqJ1OZjeObrDMVUyit
         7udmEf+wDEwsGowGGJm/ILk112294Amo64GEWdET5SfCPZcB5QKlLNCc8hmeMVIMQhAv
         i4Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763989955; x=1764594755;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K/jAyvXkLX8H+nuUsYcPgHdNHZqUW0ZlRkXZiy2I490=;
        b=v4CA4V4I+Nm+lEbShaNG/4b7x1V4KbDBa4D8mNFSsngY/uvi66M7jjYnwSCXP9AK26
         GzXB/WNgnVko7xsq0cKt0UP8uTBBqrub/lUVFvQ65qOo2a6TFbXHWcYhwGIiqhrYLotF
         T6xDRd6uBVloEBFzUpqPt9haaawLIPtiZOj1OajyjQUmdwSHc0s7aqEBtLpeJZg98MbK
         umXhd/A9ky6z+rQDvucerN2c5PEp/ZgqWAsjGzcXz4dz/enMDh5VnY0ISjCCKsyqmrou
         VT5Cp92P0Q7HJKXZxA+pHvNKJ2Eg1ati/Xo8Rupkj8hyWyKdUm6sO4cCyi1HGY8ouf35
         1Reg==
X-Gm-Message-State: AOJu0YxBccjrsZKTBtKepROYVImd3qAdHWSIYqyuRNX0MuHpNOfXgmaF
	An6PYtQaz6Z9r8Zb5S2pTTjhmgKqDz4kRdsquhT62FO/mF1bXytrL3CWD+D1UA==
X-Gm-Gg: ASbGncug6PrefqQ4Ep8i3wAWMhOLoc1hExAbF0eMAdIT3sNnIKsZF47W40deK1E8yqc
	l0kcKHIAY+DC7M6ZCX3um8++UkTycDv7k4/XJCzWOHMpYJ+tQ2HdnJcTIdicvHDMPIb4YF1/g7/
	h8V+p1+MNXnD+wwyFo+bYQ0gOn1EuY3dcrhtLYtbN12M+CwTtkHF8cWAzme3QONEdxjjXtWHipf
	KupYTMCdG6D34nfBQpJbFMOhT2M2sTk2PvcFrcb/k9RA3BRAh8IvOoZD8kvXLHtfDRVhOH5IknF
	0A4cuH89HPBP+WS8P2ftHF+8qME3j0UOeY0YaIAdTk4t8/9lmC7gz67A7BpkYQYpxWvXiX6Hvkj
	7Chp0dPPQ7K5p6WHRcSZLtpX1oqbs504UgvJoBaD++EHZc5E+cMsqOC0XPNaJvhUGMUSPo+ErcX
	YYVYU/eHzDsXb3/a86d10Wn4ZtcU03mTEjSOAdAIszrumi8No/Cd829UCrklkHbQe4+jJlkdrD
X-Google-Smtp-Source: AGHT+IFqiPToSF4N3e+veioRZSYuFb1cST6j6mPnAPjs/4jifICbawVLxJn6G5AnECO7vxqysuoJ7g==
X-Received: by 2002:a05:6000:290f:b0:429:8bfe:d842 with SMTP id ffacd0b85a97d-42cc1cd8f9fmr13219439f8f.4.1763989954744;
        Mon, 24 Nov 2025 05:12:34 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f49a7bsm27934717f8f.19.2025.11.24.05.12.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 05:12:34 -0800 (PST)
Message-ID: <015ee1ee-e0a4-491f-833f-9cef8c5349cc@gmail.com>
Date: Mon, 24 Nov 2025 13:12:29 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] io_uring/bpf: implement struct_ops registration
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk,
 Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>
References: <cover.1763031077.git.asml.silence@gmail.com>
 <cce6ee02362fe62aefab81de6ec0d26f43c6c22d.1763031077.git.asml.silence@gmail.com>
 <aSPUtMqilzaPui4f@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aSPUtMqilzaPui4f@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/24/25 03:44, Ming Lei wrote:
> On Thu, Nov 13, 2025 at 11:59:44AM +0000, Pavel Begunkov wrote:
>> Add ring_fd to the struct_ops and implement [un]registration.
...
>> +static int io_install_bpf(struct io_ring_ctx *ctx, struct io_uring_ops *ops)
>> +{
>> +	if (ctx->bpf_ops)
>> +		return -EBUSY;
>> +	ops->priv = ctx;
>> +	ctx->bpf_ops = ops;
>> +	ctx->bpf_installed = 1;
>>   	return 0;
>>   }
>>   
>>   static int bpf_io_reg(void *kdata, struct bpf_link *link)
>>   {
>> -	return -EOPNOTSUPP;
>> +	struct io_uring_ops *ops = kdata;
>> +	struct io_ring_ctx *ctx;
>> +	struct file *file;
>> +	int ret = -EBUSY;
>> +
>> +	file = io_uring_register_get_file(ops->ring_fd, false);
>> +	if (IS_ERR(file))
>> +		return PTR_ERR(file);
>> +	ctx = file->private_data;
>> +
>> +	scoped_guard(mutex, &io_bpf_ctrl_mutex) {
>> +		guard(mutex)(&ctx->uring_lock);
>> +		ret = io_install_bpf(ctx, ops);
>> +	}
> 
> I feel per-io-uring struct_ops is less useful, because it means the io_uring
> application has to be capable of loading/registering struct_ops prog, which
> often needs privilege.

I gave it a thought before, there would need to be a way to pass a
program from one (e.g. privileged) task to another, e.g. by putting
it into a list on attachment from where it can be imported. That
can be extended, and I needed to start somewhere.

Furthermore, it might even be nice to have a library of common
programs, but it's early for that.

> For example of IO link use case you mentioned, why does the application need
> to get privilege for running IO link?

Links are there to compare with existing features. It's more interesting
to allow arbitrary relations / result propagation between requests. Maybe
some common patterns can be generalised, but otherwise nothing can be
done with this without custom tailored bpf programs.

-- 
Pavel Begunkov


