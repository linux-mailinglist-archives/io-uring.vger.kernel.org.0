Return-Path: <io-uring+bounces-7073-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A915A5F5CD
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 14:20:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF0201884E93
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 13:17:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF92D2676F9;
	Thu, 13 Mar 2025 13:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Op/PBEYH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F95D265612;
	Thu, 13 Mar 2025 13:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741871814; cv=none; b=pshVKgZYp2JAgeNUywQylEweGdbGSkVTJ0IlL5RyfEh1eSbgJW7Eu+EeuERANjCM0i7jQKLUbOe/NpshFtu9+kE9+doHyfe3D116U+puKNWMMVoIHcjWay0L/ktTwMRrheRrAcWoxS12va+p/kg4VC+pwfMOCk0KvEQvnovrSPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741871814; c=relaxed/simple;
	bh=4hEZKvPPqoNDq3/Hd2AigZ3kjsX2S7dtZBYLUGn6sLk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=TR3N7+EqAPTVqlkulZjaJOejY137KjurPYt8mWTadtmxMLqvtJ9M1LrvRsr6/7EqZnXVidNIlyQ9X2svBZ8NEvHcE+Mxg5vsvnqiegg8TE4ZjU+vjDJ4Y6b8n+jGmtmewuJvmG9lV9xdNMqCztm7yUUyQFq6JK/jWoI9TrlqjWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Op/PBEYH; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-abbd96bef64so166540466b.3;
        Thu, 13 Mar 2025 06:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741871811; x=1742476611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/EcYzxLBdXNeEonrdzVlaQub36QFygJnpK7VgyHCxlY=;
        b=Op/PBEYH3y+UllwMMO8rA2BlQlCnzxRGJre7P0bGlIeCRTx/bbaWrxaFpdaQkTjjKT
         BDTBp6UVRyhvzzGbzGRtORiCc0rkzTb+Z/dziAgz/MHBDaYejIor/9WEpP1jRTekMPKJ
         wPwKvYigZKag2lHTfNbWPL9fYWcnc0/DL9TOfxrniSw0UACAMaVZB5P1GJEp+hrUs5h2
         KzVdkn8ghwWXFLKakuBscvBY8/tYMBSdur3/5bxP0f+qSe7uEk9P0zUgi1sEAcFtbvnG
         2fwlkHpyNgS611gpxDqW/G/a3pMKti1kUnv4NdSZLcCqMPAecPLmdnmQFRkkufPVAzIF
         mQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741871811; x=1742476611;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/EcYzxLBdXNeEonrdzVlaQub36QFygJnpK7VgyHCxlY=;
        b=MXaA8tlfabwR7MeUgNcOB6u5qtc6tBxO/Zlc5Pky2y1vYQ0B0pd+xID0+pl/Z8yFR4
         /CW+rEByFeh1rD+igs/MLXt/yLIplIzRVGNmKIW0HOjy9Q3l7pkppTxGndGlbOuhTBXr
         3MWDe6diRLenj09hAsU9iIPRY+t/XD5YEZYPcoWHSgYewBKvV6zkPJeX6gI62bHxF23u
         h1xLwLoHkpAuNAebWX4/cf2ENjfHGxRqOdGj4r4C5fy3ua9JrxQQryUx83InaMVRmqr9
         ObhAHOHKTBG2xTV5rNorteyr2d09W8jsAcqCmCrZ/pdmpEFIneczzO7RSbpPDBF8cwRg
         oy6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVMr7ogLQzoQ2EQ2YqdgPrHWL6UVUkPEyfqQaKfr+iM2BtVWCTQSPATsUgHlsliBlsrLSNgCQgUJQy2l+e8@vger.kernel.org, AJvYcCVUKkRpxOt4D7ZY6mxnfNfoMunVCp45UoY6n8B8WgDZ5sgISGWXybtToZnVBGAfmdj2HAhQxcov3qQcTuM=@vger.kernel.org, AJvYcCWsI1CAdJiOo3PPVzmIJdbQFBI6ndB9VW6JqqpXCrEQy3Fl+592jKZSE+lZPIZI+/MwchS680ThLA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzuQMT3iuBHIsjPaYjYOzrmtlFbHto0OLE6qFcFU4pTLSc3ISHp
	w4cDjarzTpItw7HaYIxt/95iEmlqQTVMll7L9jYtyRME9nnRZPyR
X-Gm-Gg: ASbGncvex3MM8BJr9qAJVqAe4i+0mZKqBUzJ/OuqTgnCHNlDap463XvE9po4uHya77V
	iAusn+fZlFxMOurBSAfCX/55r+0PGlI1KVsoybvooQV73vTBb9On4TR8dt1mgK8CAmcJniVGzuV
	fcMnwafRKaCT98nUhuFUXHow2lwfN4MoWV+R/VpAst9wnZVapczQvTaoZyswMkmnw8HbdsHWn1R
	qnyuwhfUXy3mIv/hvLfkrUOAw8PurL8bbQBuyojaKZq/6itr2b6qK54bEX83JaZFHKr8sbqcZET
	UQEfJv6Sf19v+4morcojvs4jK+bsnf47X1Ha+5//xcuxmvVFMbZYqymf6Q==
X-Google-Smtp-Source: AGHT+IF67h+sFS0bZ31AEL4ckZWHT+tb3ZA94vVbtwUGxG6+KTy2C9n6ETvxxKoNWw6ge8wjenfi8Q==
X-Received: by 2002:a17:907:c994:b0:abf:7940:dba2 with SMTP id a640c23a62f3a-ac2526d9b1dmr2472108366b.30.1741871810966;
        Thu, 13 Mar 2025 06:16:50 -0700 (PDT)
Received: from [192.168.116.141] ([148.252.146.254])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3149cf0b5sm80090566b.103.2025.03.13.06.16.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 06:16:50 -0700 (PDT)
Message-ID: <fd3264c8-02be-4634-bab2-2ad00a40a1b7@gmail.com>
Date: Thu, 13 Mar 2025 13:17:44 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/2] introduce io_uring_cmd_import_fixed_vec
From: Pavel Begunkov <asml.silence@gmail.com>
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20250312142326.11660-1-sidong.yang@furiosa.ai>
 <7a4217ce-1251-452c-8570-fb36e811b234@gmail.com>
 <Z9K2-mU3lrlRiV6s@sidongui-MacBookPro.local>
 <95529e8f-ac4d-4530-94fa-488372489100@gmail.com>
Content-Language: en-US
In-Reply-To: <95529e8f-ac4d-4530-94fa-488372489100@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/25 13:15, Pavel Begunkov wrote:
> On 3/13/25 10:44, Sidong Yang wrote:
>> On Thu, Mar 13, 2025 at 08:57:45AM +0000, Pavel Begunkov wrote:
>>> On 3/12/25 14:23, Sidong Yang wrote:
>>>> This patche series introduce io_uring_cmd_import_vec. With this function,
>>>> Multiple fixed buffer could be used in uring cmd. It's vectored version
>>>> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
>>>> for new api for encoded read in btrfs by using uring cmd.
>>>
>>> Pretty much same thing, we're still left with 2 allocations in the
>>> hot path. What I think we can do here is to add caching on the
>>> io_uring side as we do with rw / net, but that would be invisible
>>> for cmd drivers. And that cache can be reused for normal iovec imports.
>>>
>>> https://github.com/isilence/linux.git regvec-import-cmd
>>> (link for convenience)
>>> https://github.com/isilence/linux/tree/regvec-import-cmd
>>>
>>> Not really target tested, no btrfs, not any other user, just an idea.
>>> There are 4 patches, but the top 3 are of interest.
>>
>> Thanks, I justed checked the commits now. I think cache is good to resolve
>> this without allocation if cache hit. Let me reimpl this idea and test it
>> for btrfs.
> 
> Sure, you can just base on top of that branch, hashes might be
> different but it's identical to the base it should be on. Your
> v2 didn't have some more recent merged patches.

Jens' for-6.15/io_uring-reg-vec specifically, but for-next likely
has it merged.

-- 
Pavel Begunkov


