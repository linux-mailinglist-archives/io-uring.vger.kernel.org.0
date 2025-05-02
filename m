Return-Path: <io-uring+bounces-7816-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90281AA7685
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 17:57:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3E7517898F
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 15:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F3CD20C488;
	Fri,  2 May 2025 15:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d1iTKs/d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8641725A2C1
	for <io-uring@vger.kernel.org>; Fri,  2 May 2025 15:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746201441; cv=none; b=aqM05NOSjmIlPJUOy9H1rLsysGfgzi2houP6tAmDEogVAMHRmO1kQvRvTI/1GAiBfqMvU49Y62+eSo6QPJmUj1WjrKoY88ORbyrizYu+T7WdOzDj5W/mfxO/WHde5kof8qfTNYBTkR+bPc3b34/uRxQimFI89eUyk0KXryliEfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746201441; c=relaxed/simple;
	bh=iGlWATS8kfHazUo3QOMql5NtNCV9fd8aGCUsWH9qToE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SSHzHBkhSF1hosiadFiKdv7+kaHYN1Wutt2WhfQhYhzEqGWixB50cb3qAwie5mi/U/tz7I/+DUSFwRAlu2bLnXQAMnEooUGEdXavG9q4DZdeOlQ314jxVSFH9D+L865jspUKXubNp3TFgSD2AOJQuDWwWsjfcpbIAg5tl5RAebk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d1iTKs/d; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43d2d952eb1so11325155e9.1
        for <io-uring@vger.kernel.org>; Fri, 02 May 2025 08:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746201438; x=1746806238; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rrlnYP/xM1+Bop0RzbLS4SI0tWXZNG+3I8DYutMbCKs=;
        b=d1iTKs/dlZ7kY+q3SLv0ScfzlWo7JuY1BmJmoGy2sc5fU/zH3Dvh9ADHeqZEpV5LUU
         5WWL8bAka0msIDcwlNFK8YuX1WjTTGrZSUoRTQisgS8rCwxt8AxB49flgi4gceXMvJAB
         10En9SgH7DVMgZjaDi9CZRtJL5OGOF33//VYxhXvakl6gAMGA+w2k5B/Dn6Pulf5HlV1
         /KhTG5OPYkIiGbc8veQH6BL5pMCcTmzAK0mxVamESwxb+OW7npp9SXOhA77LSckN9OHI
         1zfN9EZ4CFoEgegIRRtq1chOk+vQUU3e1e1VrkODD8xTXvY7A7GRlIdHeRD5kwQuYKLi
         0Ppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746201438; x=1746806238;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rrlnYP/xM1+Bop0RzbLS4SI0tWXZNG+3I8DYutMbCKs=;
        b=nj8spq7T1vpcRDmEHcVjs6a2Bq5T5HBiFpjuAm5E9hCraX0JH8Dw5VzazIy1UoVwM7
         mH4TTSQMcUqaPRmWB+ZXSPDN0rqIz93SlP8SXy15elczcR1xYeCIiawMICkoBV1Egv9b
         BP8agmC40xN9QmaQajin+izKWkXXqRhQiHO9ogMip0FhtVSI5jk5KSdORg3dp5Qf4j6S
         hbnypkjEExFyQOKVkN2CoeCTM7XzYXT4Z9lgj8RmM9f9eIkQwL+C7+uuNVbJ/agzUD4w
         2fi6hs0wPAhaaElmtaVi24q2TZLkrMkDtT1Ns/uOWg8MWdIVeGhVHLHLUUA2Q3uZgu7e
         IBaw==
X-Forwarded-Encrypted: i=1; AJvYcCUpl1RKRR7HjFWFvJAhU5jcymi3A2HxT6f9tNBsMf7DHL3QI5A0l8k14wV5xpS3WuxzAr8oI8Rikw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzESEjg5pXigIqZifyPEY4t06PnWE+idEveUz+VRYLWRonG8wG+
	xAvxX+n8VrvpTz3U+XX63a3705w6ymJyxKDcJHLtjQh3iSHs0e5Mzwi9oQ==
X-Gm-Gg: ASbGncsOhlmflzi5PwDBvlNP4zm3q+zaqAG4T1DLwuHMUUhuydZsOOKPodKpacADVXJ
	qVx+JsBAupmwmw/oh0Y5ZyiFwbQcMbhY6Z5qajMI8w/Wu6AK9GvffpymezITCWQcGwDFFI39erD
	HyFRMdUCHxs7PW3X7+quRAxtcTokOw6H9kB63Dwp5UReyYzjDYqewGYt4fF8WZ0j6e4x6ukfWmG
	9D2opuc8+RiSrE1WPdTlih1f8PMISv2d8g6+GfNov3sfIzi2Kepc5HUrs6vc+N0mJ6enL8YOmBV
	ajiQsFF8FrlbrnEawLW+b1SD7xYlp0nXmQTvT6CPibvoLcuMtMUX7gUcRWRqEw==
X-Google-Smtp-Source: AGHT+IGoE0JvQLm4VZi/W0xzjOu0mO0XMlQyj8rGskO2jRd60Jw7DMIfGIgw3L+e0WmvcPxcR3/LYw==
X-Received: by 2002:a05:600c:1e05:b0:43c:e2dd:98ea with SMTP id 5b1f17b1804b1-441bbf2bc25mr29166165e9.22.1746201437552;
        Fri, 02 May 2025 08:57:17 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.146.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b2b44474sm94820455e9.29.2025.05.02.08.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 May 2025 08:57:17 -0700 (PDT)
Message-ID: <47201246-1794-497d-9dc0-d3bff41ca7f0@gmail.com>
Date: Fri, 2 May 2025 16:58:23 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 3/4] examples/send-zc: optionally fill data with
 a pattern
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1746125619.git.asml.silence@gmail.com>
 <bafcd4da1148fdff2890c6ee186bfb516f434a65.1746125619.git.asml.silence@gmail.com>
 <8e5b61c4-e23e-4d19-bc5c-eb473612c6ff@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8e5b61c4-e23e-4d19-bc5c-eb473612c6ff@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/2/25 16:26, Jens Axboe wrote:
>> @@ -582,12 +588,19 @@ static void parse_opts(int argc, char **argv)
>>   		case 'R':
>>   			cfg_rx = 1;
>>   			break;
>> +		case 'v':
>> +			cfg_verify = true;
>> +			break;
>>   		case 'y':
>>   			cfg_rx_poll = 1;
>>   			break;
>>   		}
>>   	}
>>   
>> +	available_buffer_len = cfg_payload_len;
>> +	if (cfg_verify)
>> +		available_buffer_len += 26;
>> +
> 
> This variable is nowhere to be found

And it shouldn't be there in the first place, I'll resend

-- 
Pavel Begunkov


