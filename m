Return-Path: <io-uring+bounces-10493-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E21CC468FE
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 13:19:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BF2F64EADC5
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 12:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012DA19DF4F;
	Mon, 10 Nov 2025 12:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PUbpZ4MI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C0332C8B
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 12:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762777167; cv=none; b=oaH3o2poH/caT/34eOTvvwBRpYl912/BuMc7uDJV4BNrQFqmoWFtEKry1YTBVmA7L2vMPJstRIIMi6Ep9Tk5Dojn6bwVF/0CQTBoDx+k9cXKr1wTS+KL3U+8/4cSmxqxKsnqmefuk2lqSuIPt2fZFYxFTGMgG+FcouTcp4/PAzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762777167; c=relaxed/simple;
	bh=NMW//3ReMf/Z22UX9iX3icHMtXRInyi7ShEjqCzTACA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c3t4Kg8yb70amJREmgxWpnKsCb9aYbvYvurjRRpQv/vtKH2Vsm4s0qOZf6htEgVMT1nDH2kNTnNLftKI+JnqG48M3MoFXkgK1FLmcR6a4WYrvFM/MQfny6zYaqq+2TVFnJDRvrSwFIwNbjdECEd/IORsJIYjzOSZdw8Xh0Sa7ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PUbpZ4MI; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47118259fd8so20516915e9.3
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 04:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762777164; x=1763381964; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=72acmuda/38rUriRcDLxMyvI+iV4ATxSBVvktppnni0=;
        b=PUbpZ4MIYeWumfipqgeP7AeiNsRt90+CAeLrCIl7h7AQJzTDDJ3rrmMh9gdMj9toq2
         TgPkiznDAj+pt0fGEgva4waoCwUVcYZeSexrWfPwNQvSxqdtRbBG1SAdq2XXWkj5I75W
         VqH9fuX1P5pZV7fUhAx+l411vR8HG7Cn1h3lSgwepwnyNuRr765PAZhJd49SpfGwbNDZ
         NqUd0Pn65wJTsr/DCtnuwExIyefrR+si2olAVOuAoPT4bs74Q/jIQt6reWqkm+pAGz3e
         VBxMDteIz2/GzluuU1EXax/WOS+kxhohBW6RRaBRZxsmuSnGRqp1ju9PABKltRh0uj6T
         Ug2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762777164; x=1763381964;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=72acmuda/38rUriRcDLxMyvI+iV4ATxSBVvktppnni0=;
        b=A2Sa5VTRON5fst+V+IXSDgOF+wzfIlXmf4JO32uvXlBCdsah9AsrR5VnmAU5P27cpv
         Ek+yzcPcJiMgB8xzrc0X8N7iLnMT41BtpD2M60k0kax4wjOpilpa4WIlT+nMkEcSs8r2
         FChD24ib1M511wXeLNUnjhekjzW+0fB2ZQqgHrGaTH+WZUr9wnJuR5pjKXcL8Gi0Bwt5
         rMIlKqrsCdNiXiWZVPxESSNLTdUf/3k9uuwC94+DDXCe31gd+ovc1RAt1m4Iu5BApjel
         TzJhd4HTziKFybEACiEE5eN/in3RA4Fi9HmiGbIuuBMOuiCQDrtmtFeKJydRAHGLuwJT
         ySsA==
X-Gm-Message-State: AOJu0YxvhR29cXiA3PdB1rwa0NaicLQ7cC9HMYi8FOcD41MWJhb7PpkD
	eJPjtpwWxn8BxRn1QpKz8BOd9PDqbuPSOscyJ5UEKo/+XetqaQEmszAf
X-Gm-Gg: ASbGncv9x0RpFwLiw3HBdycUTuNgZiIHKPpHM8opoYxlhGrZ7sv93xtq5rp518xGzdN
	F55FloZCkYBzCmbXUYqL4t59g4suNxYuRN1yshMmWAnPS/Z53nH5HhHEJaJDRPNAiZ7rSMjnVS5
	kT4s5D7ruyd18pv1oxVxe7IspBRDQ5jHvJTmbp1E3a8+4WIs5bSRwhWuIjGcNCvlPX65793np/P
	hAhMSKh5/ckIKYqyDb28RoY3IPcDZQMhbuhBvHP8tX+4AhxHZRayp5gencZ88K9c68mJWthn/Qb
	pqRBSMPG2IzzXZx9avmjB+F9xMOz5QTyuIjznZ0LM6/9A/TJE01g8XOl8fVis+qnEKQxRnWpG/5
	qo8f/cm1BEaUUzRthi2FaY5G/KsAHEHG55s6aj8rgH2D7ICfGu5dwlI/jWBUIc9BoEgcho1XhAv
	+6teo5/JB1CAxbD+DIBiLisNzTRVjrLxO09gLtyQO98SRTq8MToFBs2mSqbhMTzw==
X-Google-Smtp-Source: AGHT+IHyiZ5blnWFfVHo0aVoSw/GX7cKvEqPyuUs3wxc82408Yp85ygar7f/4UMrbHgBB46yeFyyTQ==
X-Received: by 2002:a05:600c:2195:b0:477:73e9:dc17 with SMTP id 5b1f17b1804b1-47773e9e27bmr42974895e9.35.1762777164352;
        Mon, 10 Nov 2025 04:19:24 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4776c2aff72sm206500975e9.4.2025.11.10.04.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 04:19:23 -0800 (PST)
Message-ID: <1c2c9bac-cb24-414d-a6ee-1456534d3e2d@gmail.com>
Date: Mon, 10 Nov 2025 12:19:22 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: regbuf vector size truncation
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk,
 Google Big Sleep <big-sleep-vuln-reports+bigsleep-458654612@google.com>
References: <11fbc25aecfd5dcb722a757dfe5d3f676391c955.1762540764.git.asml.silence@gmail.com>
 <aQ5hTIBM0euPZGnD@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aQ5hTIBM0euPZGnD@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/7/25 21:14, Günther Noack wrote:
...>> @@ -1512,7 +1515,11 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
>>   		if (unlikely(ret))
>>   			return ret;
>>   	} else {
>> -		nr_segs = io_estimate_bvec_size(iov, nr_iovs, imu);
>> +		int ret = io_estimate_bvec_size(iov, nr_iovs, imu);
>> +
>> +		if (ret < 0)
>> +			return ret;
>> +		nr_segs = ret;
>>   	}
>>   
>>   	if (sizeof(struct bio_vec) > sizeof(struct iovec)) {
>> -- 
>> 2.49.0
>>
> 
> I reviewed the logic and the check looks correct,
> and I tested that it works as expected.
> 
> (Minor remark: You might want to annotate the conditions as unlikely()?)

FWIW, it doesn't really matter here, the check can be optimised
out by moving more of the sanitisation logic earlier, but that's
for later.

> Reviewed-by: Günther Noack <gnoack@google.com>
> Tested-by: Günther Noack <gnoack@google.com>

Great, thanks

-- 
Pavel Begunkov


