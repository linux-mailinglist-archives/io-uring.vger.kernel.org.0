Return-Path: <io-uring+bounces-9900-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59FE0BBCEE1
	for <lists+io-uring@lfdr.de>; Mon, 06 Oct 2025 03:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4A203B57EB
	for <lists+io-uring@lfdr.de>; Mon,  6 Oct 2025 01:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CADFC1E487;
	Mon,  6 Oct 2025 01:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="c/39OIvz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99A8D531
	for <io-uring@vger.kernel.org>; Mon,  6 Oct 2025 01:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759714593; cv=none; b=sGq1hbEDK54Thy0vS0nGjN39tohigC4mvdF4MH6D+kcXhyvPNx/VsK8Bn8RJobCW3A+G+j2WjAWtqIGWEHFs2RB0lRPxiMN0VzLHGspgu6E9Y36UGa55YxBric7P5wFjLKgkms48Ma/7zgJolcXFv3md/iAJRR7+O0vV52J8l7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759714593; c=relaxed/simple;
	bh=iZUc2pnL5DAOq3E/SDfVp/O2CRzdkvbeh5A6pP6DQSw=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To; b=MaTfkHlzQZ7B37lnjw5+LsFDXL/5JCCNL1nngJYNsAaLo8SehsA7k2nKgutYrOaxmUUgB4KEFy8pOLdomEqBFGACVeOpcNajdKGJVztX4URrTwqcIcxStc1zc7bRPN+UUigmG1RvRLzxbmyBX69GpoydA8UlMjg49DDEKT7ZVqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=c/39OIvz; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-42f5e9e4314so27644775ab.0
        for <io-uring@vger.kernel.org>; Sun, 05 Oct 2025 18:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759714590; x=1760319390; darn=vger.kernel.org;
        h=in-reply-to:content-language:references:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rPJUYpKqoQVdUrSr1ZWE4nklHgR1m4sExpfxlSn2QhU=;
        b=c/39OIvzc3Wm/ceoa/zm8zz/KlUtVsp8o9O+ZQ3wAOkL6fi8+ek0AVRBLO6AuqWvcd
         YJVxu/ODXATbK8GmwjC0psoZRGq216lgJi4fJyaTP/ZNNEqnpXnuJmE6+enrxtQfigtL
         lG7R1M/tmGpZ8Ocy/0kl83Y/ale8zI/zauRI8I+Nqngv4zSmVbN2Z6uQPVrlmuzOO7nr
         +dyiRIhOpbWm/OgmoAyytpsJlhkfMQKI0MybC5tlOOdv73E+tuvtRUF5Utmv6EhpXf0t
         t/74IoXQp+qWkVF75QctmdQKZlS9drNAayc/pmtkYerNHBiBrj//xTH73r2f7wX3uG7S
         1dYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759714590; x=1760319390;
        h=in-reply-to:content-language:references:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rPJUYpKqoQVdUrSr1ZWE4nklHgR1m4sExpfxlSn2QhU=;
        b=OT570URG1V2soKpuRr4Foy/YrnarAPU5jMjAkzLkZybYUHRjiL4DkrQJlTsS/sjAhW
         m8GU/TcjJ3K+jxwQocOOFOKJXaMUWG0RCxG2JlbmYztPaZta27tUNXonv8mhFEf7AnpN
         SgYtkh9NV5grZdBMV8OU5B7+QlVcEitrmGvydbLRWPG16l8Q5MZ9IBA3Q8F5dkuwQptO
         9zbc1LyYEE0w0M/zjSFGnYLqpxjdJBhR//75Cqr+Tu9UScG3qtL+x6NIDpbo7VmOKgHY
         f+bp5BPrI4obtydx+w3krwZQor+p4BQPD6CcodekRLAKrQTEHaFEFODiYv/dDmHHbzOw
         3jhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtWK5riTSc6W9XfwkmV8fWyiiyejAifYaL9Btlk40mESFoSp1oVQNAVTdU2WM70zZlbWoFDLncBw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4GcZbURtFPSMORgpc+waPNxYS/Smxzac6oLmoE9KGGKkzxUT6
	NOR3ilQ5uzaB/RG4dA0KriDfipzJVOyigAVvMAjqvXJ+rj3D1w90lpTH0vBUIcQZ7aE=
X-Gm-Gg: ASbGncv1ziAFTN6L7ZNzHbUeKGBkXVT6aNLor5p+iwXaaVNwMuK5poO23ZBxMyuPrpl
	3YmAjBBW9dQrUuE30r+WEGQpVwEKEQYgJgAOcptoIuOu1nDWDXUqVwFVApMf7P4bjUoJSMZ/tL0
	/P1YJRC0SbaPrsG3RBAOEyCQix/i/47IK3m71XHe6NfkJPN0cSjz9A3DRXToT+KXUvQeJryPsoD
	QK3Pmaus1ldqmqNmJuFQz8tH9OL/UqerVhKNfLNBf31eArpLeHHGsvFjLmye0LRVrsZOiiNLF1O
	UAep1DT8JRQFdn0/sbJPl0kdqhJxGuUxfdTgCH6UjlV9VyQTC86+mCIUv9rzLK/DNO5GRwKZOeB
	HcusY0zc4T5KbCIhSQp9qzqg4ScoXwlotOrLDmmGbZRMy/1oZ6hz+/to=
X-Google-Smtp-Source: AGHT+IGiupP0BWEXQ4qq+ItBsQvx7NdNFE5y1UeLTLCS+yhfLqKG1uiTOxccRkbSLV75tM8HdL5YNQ==
X-Received: by 2002:a05:6e02:b41:b0:42d:7dea:1e09 with SMTP id e9e14a558f8ab-42e7ad6ea2fmr133922875ab.21.1759714589828;
        Sun, 05 Oct 2025 18:36:29 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42d8b1f4e59sm46884565ab.1.2025.10.05.18.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Oct 2025 18:36:29 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------VjlvUxt0nUGmHHwY0pHLvsz9"
Message-ID: <4bb29dbd-cc25-4f5d-9156-c37c918d2b42@kernel.dk>
Date: Sun, 5 Oct 2025 19:36:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CQE repeats the first item?
From: Jens Axboe <axboe@kernel.dk>
To: Jacob Thompson <jacobT@beta.pyu.ca>, io-uring@vger.kernel.org
References: <20251005202115.78998140681@vultr155>
 <ef3a1c2c-f356-4b17-b0bd-2c81acde1462@kernel.dk>
 <20251005215437.GA973@vultr155>
 <57de87e9-eac2-4f91-a2b4-bd76e4de7ece@kernel.dk>
 <20251006012503.GA849@vultr155>
 <d5f48608-5a19-434b-bb48-e60c91e01599@kernel.dk>
Content-Language: en-US
In-Reply-To: <d5f48608-5a19-434b-bb48-e60c91e01599@kernel.dk>

This is a multi-part message in MIME format.
--------------VjlvUxt0nUGmHHwY0pHLvsz9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/5/25 7:31 PM, Jens Axboe wrote:
> On 10/5/25 7:25 PM, Jacob Thompson wrote:
>> On Sun, Oct 05, 2025 at 07:09:53PM -0600, Jens Axboe wrote:
>>> On 10/5/25 3:54 PM, Jacob Thompson wrote:
>>>> On Sun, Oct 05, 2025 at 02:56:05PM -0600, Jens Axboe wrote:
>>>>> On 10/5/25 2:21 PM, Jacob Thompson wrote:
>>>>>> I'm doing something wrong and I wanted to know if anyone knows what I
>>>>>> did wrong from the description I'm using syscalls to call
>>>>>> io_uring_setup and io_uring_enter. I managed to submit 1 item without
>>>>>> an issue but any more gets me the first item over and over again. In
>>>>>> my test I did a memset -1 on cqes and sqes, I memset 0 the first ten
>>>>>> sqes with different user_data (0x1234 + i), and I used the opcode
>>>>>> IORING_OP_NOP. I called "io_uring_enter(fd, 10, 0,
>>>>>> IORING_ENTER_SQ_WAKEUP, 0)" and looked at the cq. Item 11 has the
>>>>>> user_data as '18446744073709551615' which is correct, but the first 10
>>>>>> all has user_data be 0x1234 which is weird AF since only one item has
>>>>>> that user_data and I submited 10 I considered maybe the debugger was
>>>>>> giving me incorrect values so I tried printing the user data in a
>>>>>> loop, I have no idea why the first one repeats 10 times. I only called
>>>>>> enter once
>>>>>>
>>>>>> Id is 4660
>>>>>> Id is 4660
>>>>>> Id is 4660
>>>>>> Id is 4660
>>>>>> Id is 4660
>>>>>> Id is 4660
>>>>>> Id is 4660
>>>>>> Id is 4660
>>>>>> Id is 4660
>>>>>> Id is 4660
>>>>>> Id is 18446744073709551615
>>>>>
>>>>> You're presumably not updating your side of the CQ ring correctly, see
>>>>> what liburing does when you call io_uring_cqe_seen(). If that's not it,
>>>>> then you're probably mishandling something else and an example would be
>>>>> useful as otherwise I'd just be guessing. There's really not much to go
>>>>> from in this report.
>>>>>
>>>>> -- 
>>>>> Jens Axboe
>>>>
>>>> I tried reproducing it in a smaller file. Assume I did everything wrong but somehow I seem to get results and they're not correct.
>>>>
>>>> The codebase I'd like to use this in has very little activity (could go seconds without a single syscall), then execute a few hundreds-thousand (which I like to be async).
>>>> SQPOLL sounds like the one best for my usecase. You can see I updated the sq tail before enter and I used IORING_ENTER_SQ_WAKEUP + slept for a second.
>>>> The sq tail isn't zero which means I have results? and you can see its 10 of the same user_data
>>>>
>>>> cq head is 0 enter result was 10
>>>> 1234 0
>>>> 1234 0
>>>> 1234 0
>>>> 1234 0
>>>> 1234 0
>>>> 1234 0
>>>> 1234 0
>>>> 1234 0
>>>> 1234 0
>>>> 1234 0
>>>> FFFFFFFF -1
>>>
>>> I looked at your test code, and you're setting up 10 NOP requests with
>>> userdata == 0x1234, and hence you get 10 completions with that userdata.
>>> For some reason you iterate 11 CQEs, which means your last one is the one
>>> that you already filled with -1.
>>>
>>> In other words, it very much looks like it's working as it should. Any
>>> reason why you're using the raw interface rather than liburing? All of
>>> this seems to be not understanding how the ring works, and liburing
>>> helps isolate you from that. The SQ ring doesn't tell you anything about
>>> whether you have results (CQEs?), the difference between the SQ head and
>>> tail just tell you if there's something to submit. The CQ ring head and
>>> tail would tell you if there are CQEs to reap or not.
>>>
>>> -- 
>>> Jens Axboe
>>
>> You must be seeing something that I'm not. I had a +i in the line,
>> should the user_data not increment every item? The line was
>> 'sqes[i].user_data = 0x1234+i;'. The 11th iteration is intentional to
>> see the value of the memset earlier.
> 
> You're not using IORING_SETUP_NO_SQARRAY, hence it's submitting index 0
> every time. In other words, you're submitting the same SQE 10 times, not
> 10 different SQEs. That then yields 10 completions for an SQE with the
> same userdata, and hence your CQEs all look identical.

Ala the attached.

-- 
Jens Axboe
--------------VjlvUxt0nUGmHHwY0pHLvsz9
Content-Type: text/x-c++src; charset=UTF-8; name="test.cpp"
Content-Disposition: attachment; filename="test.cpp"
Content-Transfer-Encoding: base64

I2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPGFzc2Vy
dC5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgojaW5jbHVk
ZSA8c3lzL3N5c2NhbGwuaD4KI2luY2x1ZGUgPGxpbnV4L2lvX3VyaW5nLmg+CgppbnQgaW9f
dXJpbmdfc2V0dXAodW5zaWduZWQgZW50cmllcywgaW9fdXJpbmdfcGFyYW1zKnBhcmFtcykg
eyByZXR1cm4gc3lzY2FsbChfX05SX2lvX3VyaW5nX3NldHVwLCBlbnRyaWVzLCBwYXJhbXMp
OyB9CmludCBpb191cmluZ19lbnRlcihpbnQgcmluZ19mZCwgdW5zaWduZWQgaW50IHRvX3N1
Ym1pdCwgdW5zaWduZWQgaW50IG1pbl9jb21wbGV0ZSwgdW5zaWduZWQgaW50IGZsYWdzLCB2
b2lkKnNpZykgeyByZXR1cm4gKGludCkgc3lzY2FsbChfX05SX2lvX3VyaW5nX2VudGVyLCBy
aW5nX2ZkLCB0b19zdWJtaXQsIG1pbl9jb21wbGV0ZSwgZmxhZ3MsIDApOyB9Cgp0eXBlZGVm
IGludCogSW50UHRyOwojZGVmaW5lIFgoTkFNRSkgTkFNRSA9IChpbnQqKShwK3BhcmFtcy5z
cV9vZmYuTkFNRSkKc3RydWN0IHNxaW5mbwp7CglJbnRQdHIgaGVhZCwgdGFpbCwgcmluZ19t
YXNrLCByaW5nX2VudHJpZXMsIGZsYWdzLCBkcm9wcGVkOwoJaW50KmFycmF5OwoJdm9pZCBz
ZXQoY2hhcipwLCBpb191cmluZ19wYXJhbXMmcGFyYW1zKSB7IFgoaGVhZCk7IFgodGFpbCk7
IFgocmluZ19tYXNrKTsgWChyaW5nX2VudHJpZXMpOyBYKGZsYWdzKTsgWChkcm9wcGVkKTsg
YXJyYXkgPSAoaW50KikocCtwYXJhbXMuc3Ffb2ZmLmFycmF5KTsgfQp9OwojdW5kZWYgWAoj
ZGVmaW5lIFgoTkFNRSkgTkFNRSA9IChpbnQqKShwK3BhcmFtcy5jcV9vZmYuTkFNRSkKc3Ry
dWN0IGNxaW5mbwp7CglJbnRQdHIgaGVhZCwgdGFpbCwgcmluZ19tYXNrLCByaW5nX2VudHJp
ZXMsIG92ZXJmbG93LCBmbGFnczsKCWlvX3VyaW5nX2NxZSpjcWVzOwoJdm9pZCBzZXQoY2hh
cipwLCBpb191cmluZ19wYXJhbXMmcGFyYW1zKSB7IFgoaGVhZCk7IFgodGFpbCk7IFgocmlu
Z19tYXNrKTsgWChyaW5nX2VudHJpZXMpOyBYKG92ZXJmbG93KTsgWChmbGFncyk7IGNxZXMg
PSAoaW9fdXJpbmdfY3FlKikocCtwYXJhbXMuY3Ffb2ZmLmNxZXMpOyB9Cn07CiN1bmRlZiBY
CgoKaW50IG1haW4oaW50IGFyZ2MsIGNoYXIqYXJndltdKQp7CglpbnQgcXVldWVfc2l6ZSA9
IDI1NjsKCWlvX3VyaW5nX3BhcmFtcyBwYXJhbXt9OyAvLyB6ZXJvIGluaXQKCXBhcmFtLmZs
YWdzID0gSU9SSU5HX1NFVFVQX05PX1NRQVJSQVk7CglpbnQgcmluZ0ZEID0gaW9fdXJpbmdf
c2V0dXAocXVldWVfc2l6ZSwgJnBhcmFtKTsKCWFzc2VydChyaW5nRkQ+MCk7Cglhc3NlcnQo
cGFyYW0uZmVhdHVyZXMgJiBJT1JJTkdfRkVBVF9TSU5HTEVfTU1BUCk7CglhdXRvIGJhc2Vf
bGVuZ3RoID0gcGFyYW0uc3Ffb2ZmLmFycmF5ICsgcGFyYW0uc3FfZW50cmllcyo0OwoJY2hh
ciAqYmFzZSA9IChjaGFyKikgbW1hcCgwLCBiYXNlX2xlbmd0aCwgUFJPVF9SRUFEIHwgUFJP
VF9XUklURSwgTUFQX1NIQVJFRCB8IE1BUF9QT1BVTEFURSwgcmluZ0ZELCBJT1JJTkdfT0ZG
X1NRX1JJTkcpOwoJYXNzZXJ0KGJhc2UgIT0gTUFQX0ZBSUxFRCk7CglhdXRvIHNxZXMgPSAo
aW9fdXJpbmdfc3FlKiltbWFwKDAsIHBhcmFtLnNxX2VudHJpZXMgKiBzaXplb2YoaW9fdXJp
bmdfc3FlKSwgUFJPVF9SRUFEIHwgUFJPVF9XUklURSwgTUFQX1NIQVJFRCB8IE1BUF9QT1BV
TEFURSwgcmluZ0ZELCBJT1JJTkdfT0ZGX1NRRVMpOwoJYXNzZXJ0KHNxZXMgIT0gTUFQX0ZB
SUxFRCk7Cgl1bnNpZ25lZCB0YWlsOwoKCWNxaW5mbyBjcTsKCXNxaW5mbyBzcTsKCgljcS5z
ZXQoYmFzZSwgcGFyYW0pOwoJc3Euc2V0KGJhc2UsIHBhcmFtKTsKCgkvLyBUYWtlIDEwIGl0
ZW1zCglhc3NlcnQoKnNxLnRhaWwgPT0gMCk7Cglmb3IoaW50IGk9MDsgaTwxMDsgaSsrKSB7
CgkJbWVtc2V0KCZzcWVzW2ldLCAwLCBzaXplb2Yoc3RydWN0IGlvX3VyaW5nX3NxZSkpOwoJ
CXNxZXNbaV0ub3Bjb2RlID0gSU9SSU5HX09QX05PUDsKCQlzcWVzW2ldLnVzZXJfZGF0YSA9
IDB4MTIzNCtpOwoJfQoKCV9fYXRvbWljX3N0b3JlX24oc3EudGFpbCwgMTAsIF9fQVRPTUlD
X1JFTEVBU0UpOwoKCS8vaW50IHJlcyA9IGlvX3VyaW5nX2VudGVyKHJpbmdGRCwgMTAsIDEw
LCBJT1JJTkdfRU5URVJfU1FfV0FJVCwgMCk7CglpbnQgcmVzID0gaW9fdXJpbmdfZW50ZXIo
cmluZ0ZELCAxMCwgMTAsIElPUklOR19FTlRFUl9TUV9XQUtFVVAsIDApOwoKCXNsZWVwKDEp
OwoJdGFpbCA9IF9fYXRvbWljX2xvYWRfbihjcS50YWlsLCBfX0FUT01JQ19BQ1FVSVJFKTsK
CXByaW50ZigiY3EgdGFpbCBpcyAlZCBlbnRlciByZXN1bHQgd2FzICVkXG4iLCB0YWlsLCBy
ZXMpOwoKCWZvcihpbnQgaT0wOyBpPHRhaWw7IGkrKykgewoJCXByaW50ZigiJVggJWRcbiIs
IGNxLmNxZXNbaV0udXNlcl9kYXRhLCBjcS5jcWVzW2ldLnJlcyk7Cgl9CglyZXR1cm4gMDsK
fQo=

--------------VjlvUxt0nUGmHHwY0pHLvsz9--

