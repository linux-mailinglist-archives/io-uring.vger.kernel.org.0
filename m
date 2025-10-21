Return-Path: <io-uring+bounces-10080-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 89635BF7FD2
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 19:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7E87F5063A9
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 17:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B7D2EC098;
	Tue, 21 Oct 2025 17:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CXbyK5A8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D17032B9A9
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 17:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761069273; cv=none; b=eCMDkJ17uo18IL9QyZWgCFY1ovHx6NY7s8jM7WrzRWm0A1FDWFaHzrCqmqT+jx5BbSBcD1XIDY4/YiAYYzfZgpKnUNrbw9uZ2/F5Wk/NLrJRPYDySzZesWtrN6IeBoizguQj+7eVaiTXnU/m6uNxrZcDO6LREbEMOKcxU1zxD1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761069273; c=relaxed/simple;
	bh=dGI1b4QuvMKOQIFf7VRch3Gg0awuk3OyroSrEWcapiM=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=QBH5J2YkiIGrQZRtPZVQUk5Ru1/ySjIdY3JZwEH9MTvDjfugw7B/45oYDkhOO/q3g1DGBIvf3S2HWeDbt2PAYjN139foXgA3SKhRcnd00A+ONn3aTic/s5N+ENrHD5hpEC0oaiJ1211FvPA26iZwebKKQn6DDAgdJh64bG6m9Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CXbyK5A8; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-430c97cbe0eso36761415ab.2
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 10:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761069266; x=1761674066; darn=vger.kernel.org;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2qmHr8k9+ikz36RKGjV2r4bD9PhFw3t6y4YPqyWU7bI=;
        b=CXbyK5A85V0piXFkJ83eM9rxy21T8P742K99rIyavHYsl++RSzxxU9KWOy7rPdAanB
         b/JAyIULyY3YAH25/zNefSeuMWwyHPMhDHH8HPJ59x3yHoIpXKc/mzQn7EB3op1OWfHN
         5/D49WW3xor/qiA0YoKEppc1e1otoZOR2HVlMbQyP9in7lb+8sSfXysm5vQlPCFIaxMn
         1Oomw3xcP5ukHkMNgGZWh1ZffFRi6VHWsgt+/g63G2xq4SSCbdMKsaM/g73P2YZqDXYE
         hY8luOS2ubdEcpd3lz22VWgjgUgV6ZcPHXn8eatjdzPor/rFFKVkOVt7Ul4EbU6nJlS9
         Kb/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761069266; x=1761674066;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2qmHr8k9+ikz36RKGjV2r4bD9PhFw3t6y4YPqyWU7bI=;
        b=M2AAZgeGF5oGnoFQXHjk8mLQ8vBFmil4A44gNnbTnSItaoEH19VRfcT7+tlAJmTnOP
         vJ9j74L0y/F6g9jbuS43/pPdP6VVrLpzikGf2kQzvz3ngrmG2AzNHcz1cI5ZtgwDXpJW
         wvo7/4WM3GsKTifXx4RipUp9Tx+VAnjxXOFCy+VPX9WWZpEBPa3uLOyOh1UXKl7ioqLR
         vIWuNtlzLSyAVSa4k9EbqiUtrxjy8Ykj4CjxQb5avQ0JBroUGMinvr1p4eboL8xrAVjL
         cmsh1GGtFsdV3hM08LTidWOj499aSps/XmzJLGw4RcfAdaPLoo8HWmTBciiausqXMRem
         Nu+g==
X-Forwarded-Encrypted: i=1; AJvYcCXcCwkA4zEoWNPs+zZHWL4GNmgJ+NYA6bS2xcIJXDY2kJM9ZwFSBNfa1wGIL5HzjDIoyVY9l+7p2g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3QaoHk3rIw++eKgtVwR/5+cKU8a8/d+jjyTxOue+vb2DDMlwZ
	PqqGr1wEVLvjFGk+If8byJJUM/37pbpPOrmGH3m7V6naR9i05zoWSZRq9e7iTX2mqmg=
X-Gm-Gg: ASbGncuIIjLi00X1XtHkUz5o7asamkRFm0vonQ6IucpdxHT0tw1Fu7958JqjBgxDpv1
	P3T+HfdwQASRm/0EGCHnnWdncrbZhI3RraF5SeNuw1YH0/EA4q01zH5lg1GJ4von46uf6rVcB/B
	RR+GDoIrHC0ZWAQvRED2MAxCnIUu155tJ+bpQ1ygtTisltUvluT1GCjepYT0iA0Kn3OmKLBwTJY
	WW4Wq7a7FeYcTZIUWZRzPhbbahCx1AtM7hTCLeLLVEPY5hrzp0RNBpWqHfJrr30IoKauLcoiyLY
	HRx7To2/3o000K33F/OF9E4cMtHIZuYMlmb87Bwhai1oJjN/goU7pEnA6F52upy65OwEzebqyAn
	rdaEc20bMIc6/zV5DY+sN4WfvdjY3ylp3rwFRJb8s6bodHqho5LDJMfpoZ8sJs8uTSmi57per
X-Google-Smtp-Source: AGHT+IEK2wHreVWILP+E075qj+8IByFvPmM7L3ympwisP//xsqtVD2+lDpzExALwvJ2nX9Op3aQbMg==
X-Received: by 2002:a05:6e02:1c22:b0:430:ab29:e75b with SMTP id e9e14a558f8ab-430c52bed72mr262322095ab.17.1761069266297;
        Tue, 21 Oct 2025 10:54:26 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a95fed84sm4263418173.5.2025.10.21.10.54.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 10:54:25 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------PvqwD6gU6M4H2ONsrWw8roT0"
Message-ID: <243ce0e2-0d42-4d00-b16f-5fd5033432bf@kernel.dk>
Date: Tue, 21 Oct 2025 11:54:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [PATCH v2] io_uring: add
 IORING_SETUP_SQTHREAD_STATS flag to enable sqthread stats collection
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: xiaobing.li@samsung.com, asml.silence@gmail.com,
 io-uring@vger.kernel.org, Diangang Li <lidiangang@bytedance.com>
References: <20251020113031.2135-1-changfengnan@bytedance.com>
 <8ac97b77-4423-41cf-a1f3-99d93ac65f9d@kernel.dk>
 <CAPFOzZswzJMSdtpZZTTWQ0b3SUgPg5g1cFLVQTQh+os_tVzSnw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAPFOzZswzJMSdtpZZTTWQ0b3SUgPg5g1cFLVQTQh+os_tVzSnw@mail.gmail.com>

This is a multi-part message in MIME format.
--------------PvqwD6gU6M4H2ONsrWw8roT0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/25 2:54 AM, Fengnan Chang wrote:
> Jens Axboe <axboe@kernel.dk> ?2025?10?20??? 23:12???
>>
>> On 10/20/25 5:30 AM, Fengnan Chang wrote:
>>> In previous versions, getrusage was always called in sqrthread
>>> to count work time, but this could incur some overhead.
>>> This patch turn off stats by default, and introduces a new flag
>>> IORING_SETUP_SQTHREAD_STATS that allows user to enable the
>>> collection of statistics in the sqthread.
>>>
>>> ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 ./testfile
>>> IOPS base: 570K, patch: 590K
>>>
>>> ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 /dev/nvme1n1
>>> IOPS base: 826K, patch: 889K
>>
>> That's a crazy amount of overhead indeed. I'm assuming this is
>> because the task has lots of threads? And/or going through the retry
>> a lot? Might make more sense to have a cheaper and more rough
>> getrusage() instead? All we really use is ru_stime.{tv_sec,tv_nsec}.
>> Should it be using RUSAGE_THREAD? Correct me if I'm wrong, but using
>> PTHREAD_SELF actually seems wrong as-is.
> 
> Only one sqpoll thread, no retry.  Only enable sq_thread_poll by default in
>  ./t/io_uring.c to test.
> Yeh, getrusage is not correct, I'll try to find a cheaper way.
> 
>>
>> In any case, I don't think a setup flag is the right choice here. That
>> space is fairly limited, and SQPOLL is also a bit of an esoteric
>> feature. Hence not sure a setup flag is the right approach. Would
>> probably make more sense to have a REGISTER opcode to get/set various
>> features like this, I'm sure it's not the last thing like this we'll run
>> into. But as mentioned, I do think just having a more light weight
>> getrusage would perhaps be prudent.
> Get your point,  I'll make it in REGISTER opcode.

My main point was actually "perhaps we're doing something stupid, maybe
let's try and do the accounting in a less stupid way". For example,
right now it's just blindly getting the time all of the time. That seems
very stupid. And rather than add a knob for this, perhaps we can just
fix it?

I took a quick stab at it, see the attached two patches. I'll send them
out as well. With those, accounting should still be fine, but all the
overhead is essentially gone. Hence no need for a knob...

-- 
Jens Axboe
--------------PvqwD6gU6M4H2ONsrWw8roT0
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-sqpoll-be-smarter-on-when-to-update-the-sti.patch"
Content-Disposition: attachment;
 filename*0="0002-io_uring-sqpoll-be-smarter-on-when-to-update-the-sti.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBhZDAwNWY3NDE2NDVmYzdkYTVkMTZhYzA3Njg0MTliYjMzOTNlMjJiIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFR1ZSwgMjEgT2N0IDIwMjUgMTE6NDQ6MzkgLTA2MDAKU3ViamVjdDogW1BBVENIIDIv
Ml0gaW9fdXJpbmcvc3Fwb2xsOiBiZSBzbWFydGVyIG9uIHdoZW4gdG8gdXBkYXRlIHRoZSBz
dGltZQogdXNhZ2UKClRoZSBjdXJyZW50IGFwcHJvYWNoIGlzIGEgYml0IG5haXZlLCBhbmQg
aGVuY2UgY2FsbHMgdGhlIHRpbWUgcXVlcnlpbmcKd2F5IHRvbyBvZnRlbi4gT25seSBzdGFy
dCB0aGUgImRvaW5nIHdvcmsiIHRpbWVyIHdoZW4gdGhlcmUncyBhY3R1YWwKd29yayB0byBk
bywgYW5kIHRoZW4gdXNlIHRoYXQgaW5mb3JtYXRpb24gdG8gdGVybWluYXRlIChhbmQgYWNj
b3VudCkgdGhlCndvcmsgdGltZSBvbmNlIGRvbmUuIFRoaXMgZ3JlYXRseSByZWR1Y2VzIHRo
ZSBmcmVxdWVuY3kgb2YgdGhlc2UgY2FsbHMsCndoZW4gdGhleSBjYW5ub3QgaGF2ZSBjaGFu
Z2VkIGFueXdheS4KClJ1bm5pbmcgYSBiYXNpYyByYW5kb20gcmVhZGVyIHRoYXQgaXMgc2V0
dXAgdG8gdXNlIFNRUE9MTCwgYSBwcm9maWxlCmJlZm9yZSB0aGlzIGNoYW5nZSBzaG93cyB0
aGVzZSBhcyB0aGUgdG9wIGN5Y2xlIGNvbnN1bWVyczoKCisgICAzMi42MCUgIGlvdS1zcXAt
MTA3NCAgW2tlcm5lbC5rYWxsc3ltc10gIFtrXSB0aHJlYWRfZ3JvdXBfY3B1dGltZV9hZGp1
c3RlZAorICAgMTkuOTclICBpb3Utc3FwLTEwNzQgIFtrZXJuZWwua2FsbHN5bXNdICBba10g
dGhyZWFkX2dyb3VwX2NwdXRpbWUKKyAgIDEyLjIwJSAgaW9fdXJpbmcgICAgICBpb191cmlu
ZyAgICAgICAgICAgWy5dIHN1Ym1pdHRlcl91cmluZ19mbgorICAgIDQuMTMlICBpb3Utc3Fw
LTEwNzQgIFtrZXJuZWwua2FsbHN5bXNdICBba10gZ2V0cnVzYWdlCisgICAgMi40NSUgIGlv
dS1zcXAtMTA3NCAgW2tlcm5lbC5rYWxsc3ltc10gIFtrXSBpb19zdWJtaXRfc3FlcworICAg
IDIuMTglICBpb3Utc3FwLTEwNzQgIFtrZXJuZWwua2FsbHN5bXNdICBba10gX19waV9tZW1z
ZXRfZ2VuZXJpYworICAgIDIuMDklICBpb3Utc3FwLTEwNzQgIFtrZXJuZWwua2FsbHN5bXNd
ICBba10gY3B1dGltZV9hZGp1c3QKCmFuZCBhZnRlciB0aGlzIGNoYW5nZSwgdG9wIG9mIHBy
b2ZpbGUgbG9va3MgYXMgZm9sbG93czoKCisgICAzNi4yMyUgIGlvX3VyaW5nICAgICBpb191
cmluZyAgICAgICAgICAgWy5dIHN1Ym1pdHRlcl91cmluZ19mbgorICAgMjMuMjYlICBpb3Ut
c3FwLTgxOSAgW2tlcm5lbC5rYWxsc3ltc10gIFtrXSBpb19zcV90aHJlYWQKKyAgIDEwLjE0
JSAgaW91LXNxcC04MTkgIFtrZXJuZWwua2FsbHN5bXNdICBba10gaW9fc3FfdHcKKyAgICA2
LjUyJSAgaW91LXNxcC04MTkgIFtrZXJuZWwua2FsbHN5bXNdICBba10gdGN0eF90YXNrX3dv
cmtfcnVuCisgICAgNC44MiUgIGlvdS1zcXAtODE5ICBba2VybmVsLmthbGxzeW1zXSAgW2td
IG52bWVfc3VibWl0X2NtZHMucGFydC4wCisgICAgMi45MSUgIGlvdS1zcXAtODE5ICBba2Vy
bmVsLmthbGxzeW1zXSAgW2tdIGlvX3N1Ym1pdF9zcWVzClsuLi5dCiAgICAgMC4wMiUgIGlv
dS1zcXAtODE5ICBba2VybmVsLmthbGxzeW1zXSAgW2tdIGNwdXRpbWVfYWRqdXN0ICAgICAg
ICAgICAgICAgICAgICAgIOKWkgoKd2hlcmUgaXQncyBzcGVuZGluZyB0aGUgY3ljbGVzIG9u
IHRoaW5ncyB0aGF0IGFjdHVhbGx5IG1hdHRlci4KClJlcG9ydGVkLWJ5OiBGZW5nbmFuIENo
YW5nIDxjaGFuZ2ZlbmduYW5AYnl0ZWRhbmNlLmNvbT4KQ2M6IHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmcKRml4ZXM6IDNmY2I5ZDE3MjA2ZSAoImlvX3VyaW5nL3NxcG9sbDogc3RhdGlzdGlj
cyBvZiB0aGUgdHJ1ZSB1dGlsaXphdGlvbiBvZiBzcSB0aHJlYWRzIikKU2lnbmVkLW9mZi1i
eTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgotLS0KIGlvX3VyaW5nL3NxcG9sbC5j
IHwgNDMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLQogMSBm
aWxlIGNoYW5nZWQsIDMyIGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2lvX3VyaW5nL3NxcG9sbC5jIGIvaW9fdXJpbmcvc3Fwb2xsLmMKaW5kZXggODcw
NWIwYWE4MmUwLi5mNjkxNmY0NmMwNDcgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL3NxcG9sbC5j
CisrKyBiL2lvX3VyaW5nL3NxcG9sbC5jCkBAIC0xNzAsNiArMTcwLDExIEBAIHN0YXRpYyBp
bmxpbmUgYm9vbCBpb19zcWRfZXZlbnRzX3BlbmRpbmcoc3RydWN0IGlvX3NxX2RhdGEgKnNx
ZCkKIAlyZXR1cm4gUkVBRF9PTkNFKHNxZC0+c3RhdGUpOwogfQogCitzdHJ1Y3QgaW9fc3Ff
dGltZSB7CisJYm9vbCBzdGFydGVkOworCXN0cnVjdCB0aW1lc3BlYzY0IHRzOworfTsKKwog
c3RydWN0IHRpbWVzcGVjNjQgaW9fc3FfY3B1X3RpbWUoc3RydWN0IHRhc2tfc3RydWN0ICp0
c2spCiB7CiAJdTY0IHV0aW1lLCBzdGltZTsKQEAgLTE3OCwxNSArMTgzLDI3IEBAIHN0cnVj
dCB0aW1lc3BlYzY0IGlvX3NxX2NwdV90aW1lKHN0cnVjdCB0YXNrX3N0cnVjdCAqdHNrKQog
CXJldHVybiBuc190b190aW1lc3BlYzY0KHN0aW1lKTsKIH0KIAotc3RhdGljIHZvaWQgaW9f
c3FfdXBkYXRlX3dvcmt0aW1lKHN0cnVjdCBpb19zcV9kYXRhICpzcWQsIHN0cnVjdCB0aW1l
c3BlYzY0IHN0YXJ0KQorc3RhdGljIHZvaWQgaW9fc3FfdXBkYXRlX3dvcmt0aW1lKHN0cnVj
dCBpb19zcV9kYXRhICpzcWQsIHN0cnVjdCBpb19zcV90aW1lICppc3QpCiB7CiAJc3RydWN0
IHRpbWVzcGVjNjQgdHM7CiAKLQl0cyA9IHRpbWVzcGVjNjRfc3ViKGlvX3NxX2NwdV90aW1l
KGN1cnJlbnQpLCBzdGFydCk7CisJaWYgKCFpc3QtPnN0YXJ0ZWQpCisJCXJldHVybjsKKwlp
c3QtPnN0YXJ0ZWQgPSBmYWxzZTsKKwl0cyA9IHRpbWVzcGVjNjRfc3ViKGlvX3NxX2NwdV90
aW1lKGN1cnJlbnQpLCBpc3QtPnRzKTsKIAlzcWQtPndvcmtfdGltZSArPSB0cy50dl9zZWMg
KiAxMDAwMDAwICsgdHMudHZfbnNlYyAvIDEwMDA7CiB9CiAKLXN0YXRpYyBpbnQgX19pb19z
cV90aHJlYWQoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsIGJvb2wgY2FwX2VudHJpZXMpCitz
dGF0aWMgdm9pZCBpb19zcV9zdGFydF93b3JrdGltZShzdHJ1Y3QgaW9fc3FfdGltZSAqaXN0
KQoreworCWlmIChpc3QtPnN0YXJ0ZWQpCisJCXJldHVybjsKKwlpc3QtPnN0YXJ0ZWQgPSB0
cnVlOworCWlzdC0+dHMgPSBpb19zcV9jcHVfdGltZShjdXJyZW50KTsKK30KKworc3RhdGlj
IGludCBfX2lvX3NxX3RocmVhZChzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwgc3RydWN0IGlv
X3NxX2RhdGEgKnNxZCwKKwkJCSAgYm9vbCBjYXBfZW50cmllcywgc3RydWN0IGlvX3NxX3Rp
bWUgKmlzdCkKIHsKIAl1bnNpZ25lZCBpbnQgdG9fc3VibWl0OwogCWludCByZXQgPSAwOwpA
QCAtMTk5LDYgKzIxNiw4IEBAIHN0YXRpYyBpbnQgX19pb19zcV90aHJlYWQoc3RydWN0IGlv
X3JpbmdfY3R4ICpjdHgsIGJvb2wgY2FwX2VudHJpZXMpCiAJaWYgKHRvX3N1Ym1pdCB8fCAh
d3FfbGlzdF9lbXB0eSgmY3R4LT5pb3BvbGxfbGlzdCkpIHsKIAkJY29uc3Qgc3RydWN0IGNy
ZWQgKmNyZWRzID0gTlVMTDsKIAorCQlpb19zcV9zdGFydF93b3JrdGltZShpc3QpOworCiAJ
CWlmIChjdHgtPnNxX2NyZWRzICE9IGN1cnJlbnRfY3JlZCgpKQogCQkJY3JlZHMgPSBvdmVy
cmlkZV9jcmVkcyhjdHgtPnNxX2NyZWRzKTsKIApAQCAtMjc3LDcgKzI5Niw2IEBAIHN0YXRp
YyBpbnQgaW9fc3FfdGhyZWFkKHZvaWQgKmRhdGEpCiAJc3RydWN0IGxsaXN0X25vZGUgKnJl
dHJ5X2xpc3QgPSBOVUxMOwogCXN0cnVjdCBpb19zcV9kYXRhICpzcWQgPSBkYXRhOwogCXN0
cnVjdCBpb19yaW5nX2N0eCAqY3R4OwotCXN0cnVjdCB0aW1lc3BlYzY0IHN0YXJ0OwogCXVu
c2lnbmVkIGxvbmcgdGltZW91dCA9IDA7CiAJY2hhciBidWZbVEFTS19DT01NX0xFTl0gPSB7
fTsKIAlERUZJTkVfV0FJVCh3YWl0KTsKQEAgLTMxNSw2ICszMzMsNyBAQCBzdGF0aWMgaW50
IGlvX3NxX3RocmVhZCh2b2lkICpkYXRhKQogCW11dGV4X2xvY2soJnNxZC0+bG9jayk7CiAJ
d2hpbGUgKDEpIHsKIAkJYm9vbCBjYXBfZW50cmllcywgc3F0X3NwaW4gPSBmYWxzZTsKKwkJ
c3RydWN0IGlvX3NxX3RpbWUgaXN0ID0geyB9OwogCiAJCWlmIChpb19zcWRfZXZlbnRzX3Bl
bmRpbmcoc3FkKSB8fCBzaWduYWxfcGVuZGluZyhjdXJyZW50KSkgewogCQkJaWYgKGlvX3Nx
ZF9oYW5kbGVfZXZlbnQoc3FkKSkKQEAgLTMyMyw5ICszNDIsOCBAQCBzdGF0aWMgaW50IGlv
X3NxX3RocmVhZCh2b2lkICpkYXRhKQogCQl9CiAKIAkJY2FwX2VudHJpZXMgPSAhbGlzdF9p
c19zaW5ndWxhcigmc3FkLT5jdHhfbGlzdCk7Ci0JCXN0YXJ0ID0gaW9fc3FfY3B1X3RpbWUo
Y3VycmVudCk7CiAJCWxpc3RfZm9yX2VhY2hfZW50cnkoY3R4LCAmc3FkLT5jdHhfbGlzdCwg
c3FkX2xpc3QpIHsKLQkJCWludCByZXQgPSBfX2lvX3NxX3RocmVhZChjdHgsIGNhcF9lbnRy
aWVzKTsKKwkJCWludCByZXQgPSBfX2lvX3NxX3RocmVhZChjdHgsIHNxZCwgY2FwX2VudHJp
ZXMsICZpc3QpOwogCiAJCQlpZiAoIXNxdF9zcGluICYmIChyZXQgPiAwIHx8ICF3cV9saXN0
X2VtcHR5KCZjdHgtPmlvcG9sbF9saXN0KSkpCiAJCQkJc3F0X3NwaW4gPSB0cnVlOwpAQCAt
MzMzLDE1ICszNTEsMTggQEAgc3RhdGljIGludCBpb19zcV90aHJlYWQodm9pZCAqZGF0YSkK
IAkJaWYgKGlvX3NxX3R3KCZyZXRyeV9saXN0LCBJT1JJTkdfVFdfQ0FQX0VOVFJJRVNfVkFM
VUUpKQogCQkJc3F0X3NwaW4gPSB0cnVlOwogCi0JCWxpc3RfZm9yX2VhY2hfZW50cnkoY3R4
LCAmc3FkLT5jdHhfbGlzdCwgc3FkX2xpc3QpCi0JCQlpZiAoaW9fbmFwaShjdHgpKQorCQls
aXN0X2Zvcl9lYWNoX2VudHJ5KGN0eCwgJnNxZC0+Y3R4X2xpc3QsIHNxZF9saXN0KSB7CisJ
CQlpZiAoaW9fbmFwaShjdHgpKSB7CisJCQkJaW9fc3Ffc3RhcnRfd29ya3RpbWUoJmlzdCk7
CiAJCQkJaW9fbmFwaV9zcXBvbGxfYnVzeV9wb2xsKGN0eCk7CisJCQl9CisJCX0KKworCQlp
b19zcV91cGRhdGVfd29ya3RpbWUoc3FkLCAmaXN0KTsKIAogCQlpZiAoc3F0X3NwaW4gfHwg
IXRpbWVfYWZ0ZXIoamlmZmllcywgdGltZW91dCkpIHsKLQkJCWlmIChzcXRfc3Bpbikgewot
CQkJCWlvX3NxX3VwZGF0ZV93b3JrdGltZShzcWQsIHN0YXJ0KTsKKwkJCWlmIChzcXRfc3Bp
bikKIAkJCQl0aW1lb3V0ID0gamlmZmllcyArIHNxZC0+c3FfdGhyZWFkX2lkbGU7Ci0JCQl9
CiAJCQlpZiAodW5saWtlbHkobmVlZF9yZXNjaGVkKCkpKSB7CiAJCQkJbXV0ZXhfdW5sb2Nr
KCZzcWQtPmxvY2spOwogCQkJCWNvbmRfcmVzY2hlZCgpOwotLSAKMi41MS4wCgo=
--------------PvqwD6gU6M4H2ONsrWw8roT0
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-sqpoll-switch-away-from-getrusage-for-CPU-a.patch"
Content-Disposition: attachment;
 filename*0="0001-io_uring-sqpoll-switch-away-from-getrusage-for-CPU-a.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA0MDUyZTIwZDNkNjNkYWM1ZTA1MTM1ODU0ZTMwYzZiNWYzN2ZkZDRhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFR1ZSwgMjEgT2N0IDIwMjUgMDc6MTY6MDggLTA2MDAKU3ViamVjdDogW1BBVENIIDEv
Ml0gaW9fdXJpbmcvc3Fwb2xsOiBzd2l0Y2ggYXdheSBmcm9tIGdldHJ1c2FnZSgpIGZvciBD
UFUKIGFjY291bnRpbmcKCmdldHJ1c2FnZSgpIGRvZXMgYSBsb3QgbW9yZSB0aGFuIHdoYXQg
dGhlIFNRUE9MTCBhY2NvdW50aW5nIG5lZWRzLCB0aGUKbGF0dGVyIG9ubHkgY2FyZXMgYWJv
dXQgKGFuZCB1c2VzKSB0aGUgc3RpbWUuIFJhdGhlciB0aGFuIGRvIGEgZnVsbApSVVNBR0Vf
U0VMRiBzdW1tYXRpb24sIGp1c3QgcXVlcnkgdGhlIHVzZWQgc3RpbWUgaW5zdGVhZC4KCkNj
OiBzdGFibGVAdmdlci5rZXJuZWwub3JnCkZpeGVzOiAzZmNiOWQxNzIwNmUgKCJpb191cmlu
Zy9zcXBvbGw6IHN0YXRpc3RpY3Mgb2YgdGhlIHRydWUgdXRpbGl6YXRpb24gb2Ygc3EgdGhy
ZWFkcyIpClNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0t
CiBpb191cmluZy9mZGluZm8uYyB8ICA5ICsrKysrLS0tLQogaW9fdXJpbmcvc3Fwb2xsLmMg
fCAzNCArKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tCiBpb191cmluZy9zcXBv
bGwuaCB8ICAxICsKIDMgZmlsZXMgY2hhbmdlZCwgMjYgaW5zZXJ0aW9ucygrKSwgMTggZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvZmRpbmZvLmMgYi9pb191cmluZy9m
ZGluZm8uYwppbmRleCBmZjMzNjQ1MzFjNzcuLjk2NmUwNmIwNzhmNiAxMDA2NDQKLS0tIGEv
aW9fdXJpbmcvZmRpbmZvLmMKKysrIGIvaW9fdXJpbmcvZmRpbmZvLmMKQEAgLTU5LDcgKzU5
LDYgQEAgc3RhdGljIHZvaWQgX19pb191cmluZ19zaG93X2ZkaW5mbyhzdHJ1Y3QgaW9fcmlu
Z19jdHggKmN0eCwgc3RydWN0IHNlcV9maWxlICptKQogewogCXN0cnVjdCBpb19vdmVyZmxv
d19jcWUgKm9jcWU7CiAJc3RydWN0IGlvX3JpbmdzICpyID0gY3R4LT5yaW5nczsKLQlzdHJ1
Y3QgcnVzYWdlIHNxX3VzYWdlOwogCXVuc2lnbmVkIGludCBzcV9tYXNrID0gY3R4LT5zcV9l
bnRyaWVzIC0gMSwgY3FfbWFzayA9IGN0eC0+Y3FfZW50cmllcyAtIDE7CiAJdW5zaWduZWQg
aW50IHNxX2hlYWQgPSBSRUFEX09OQ0Uoci0+c3EuaGVhZCk7CiAJdW5zaWduZWQgaW50IHNx
X3RhaWwgPSBSRUFEX09OQ0Uoci0+c3EudGFpbCk7CkBAIC0xNTIsMTQgKzE1MSwxNiBAQCBz
dGF0aWMgdm9pZCBfX2lvX3VyaW5nX3Nob3dfZmRpbmZvKHN0cnVjdCBpb19yaW5nX2N0eCAq
Y3R4LCBzdHJ1Y3Qgc2VxX2ZpbGUgKm0pCiAJCSAqIHRocmVhZCB0ZXJtaW5hdGlvbi4KIAkJ
ICovCiAJCWlmICh0c2spIHsKKwkJCXN0cnVjdCB0aW1lc3BlYzY0IHRzOworCiAJCQlnZXRf
dGFza19zdHJ1Y3QodHNrKTsKIAkJCXJjdV9yZWFkX3VubG9jaygpOwotCQkJZ2V0cnVzYWdl
KHRzaywgUlVTQUdFX1NFTEYsICZzcV91c2FnZSk7CisJCQl0cyA9IGlvX3NxX2NwdV90aW1l
KHRzayk7CiAJCQlwdXRfdGFza19zdHJ1Y3QodHNrKTsKIAkJCXNxX3BpZCA9IHNxLT50YXNr
X3BpZDsKIAkJCXNxX2NwdSA9IHNxLT5zcV9jcHU7Ci0JCQlzcV90b3RhbF90aW1lID0gKHNx
X3VzYWdlLnJ1X3N0aW1lLnR2X3NlYyAqIDEwMDAwMDAKLQkJCQkJICsgc3FfdXNhZ2UucnVf
c3RpbWUudHZfdXNlYyk7CisJCQlzcV90b3RhbF90aW1lID0gKHRzLnR2X3NlYyAqIDEwMDAw
MDAKKwkJCQkJICsgdHMudHZfbnNlYyAvIDEwMDApOwogCQkJc3Ffd29ya190aW1lID0gc3Et
PndvcmtfdGltZTsKIAkJfSBlbHNlIHsKIAkJCXJjdV9yZWFkX3VubG9jaygpOwpkaWZmIC0t
Z2l0IGEvaW9fdXJpbmcvc3Fwb2xsLmMgYi9pb191cmluZy9zcXBvbGwuYwppbmRleCBhM2Yx
MTM0OWNlMDYuLjg3MDViMGFhODJlMCAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvc3Fwb2xsLmMK
KysrIGIvaW9fdXJpbmcvc3Fwb2xsLmMKQEAgLTExLDYgKzExLDcgQEAKICNpbmNsdWRlIDxs
aW51eC9hdWRpdC5oPgogI2luY2x1ZGUgPGxpbnV4L3NlY3VyaXR5Lmg+CiAjaW5jbHVkZSA8
bGludXgvY3B1c2V0Lmg+CisjaW5jbHVkZSA8bGludXgvc2NoZWQvY3B1dGltZS5oPgogI2lu
Y2x1ZGUgPGxpbnV4L2lvX3VyaW5nLmg+CiAKICNpbmNsdWRlIDx1YXBpL2xpbnV4L2lvX3Vy
aW5nLmg+CkBAIC0xNjksNiArMTcwLDIyIEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBpb19zcWRf
ZXZlbnRzX3BlbmRpbmcoc3RydWN0IGlvX3NxX2RhdGEgKnNxZCkKIAlyZXR1cm4gUkVBRF9P
TkNFKHNxZC0+c3RhdGUpOwogfQogCitzdHJ1Y3QgdGltZXNwZWM2NCBpb19zcV9jcHVfdGlt
ZShzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzaykKK3sKKwl1NjQgdXRpbWUsIHN0aW1lOworCisJ
dGFza19jcHV0aW1lX2FkanVzdGVkKHRzaywgJnV0aW1lLCAmc3RpbWUpOworCXJldHVybiBu
c190b190aW1lc3BlYzY0KHN0aW1lKTsKK30KKworc3RhdGljIHZvaWQgaW9fc3FfdXBkYXRl
X3dvcmt0aW1lKHN0cnVjdCBpb19zcV9kYXRhICpzcWQsIHN0cnVjdCB0aW1lc3BlYzY0IHN0
YXJ0KQoreworCXN0cnVjdCB0aW1lc3BlYzY0IHRzOworCisJdHMgPSB0aW1lc3BlYzY0X3N1
Yihpb19zcV9jcHVfdGltZShjdXJyZW50KSwgc3RhcnQpOworCXNxZC0+d29ya190aW1lICs9
IHRzLnR2X3NlYyAqIDEwMDAwMDAgKyB0cy50dl9uc2VjIC8gMTAwMDsKK30KKwogc3RhdGlj
IGludCBfX2lvX3NxX3RocmVhZChzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwgYm9vbCBjYXBf
ZW50cmllcykKIHsKIAl1bnNpZ25lZCBpbnQgdG9fc3VibWl0OwpAQCAtMjU1LDIzICsyNzIs
MTIgQEAgc3RhdGljIGJvb2wgaW9fc3FfdHdfcGVuZGluZyhzdHJ1Y3QgbGxpc3Rfbm9kZSAq
cmV0cnlfbGlzdCkKIAlyZXR1cm4gcmV0cnlfbGlzdCB8fCAhbGxpc3RfZW1wdHkoJnRjdHgt
PnRhc2tfbGlzdCk7CiB9CiAKLXN0YXRpYyB2b2lkIGlvX3NxX3VwZGF0ZV93b3JrdGltZShz
dHJ1Y3QgaW9fc3FfZGF0YSAqc3FkLCBzdHJ1Y3QgcnVzYWdlICpzdGFydCkKLXsKLQlzdHJ1
Y3QgcnVzYWdlIGVuZDsKLQotCWdldHJ1c2FnZShjdXJyZW50LCBSVVNBR0VfU0VMRiwgJmVu
ZCk7Ci0JZW5kLnJ1X3N0aW1lLnR2X3NlYyAtPSBzdGFydC0+cnVfc3RpbWUudHZfc2VjOwot
CWVuZC5ydV9zdGltZS50dl91c2VjIC09IHN0YXJ0LT5ydV9zdGltZS50dl91c2VjOwotCi0J
c3FkLT53b3JrX3RpbWUgKz0gZW5kLnJ1X3N0aW1lLnR2X3VzZWMgKyBlbmQucnVfc3RpbWUu
dHZfc2VjICogMTAwMDAwMDsKLX0KLQogc3RhdGljIGludCBpb19zcV90aHJlYWQodm9pZCAq
ZGF0YSkKIHsKIAlzdHJ1Y3QgbGxpc3Rfbm9kZSAqcmV0cnlfbGlzdCA9IE5VTEw7CiAJc3Ry
dWN0IGlvX3NxX2RhdGEgKnNxZCA9IGRhdGE7CiAJc3RydWN0IGlvX3JpbmdfY3R4ICpjdHg7
Ci0Jc3RydWN0IHJ1c2FnZSBzdGFydDsKKwlzdHJ1Y3QgdGltZXNwZWM2NCBzdGFydDsKIAl1
bnNpZ25lZCBsb25nIHRpbWVvdXQgPSAwOwogCWNoYXIgYnVmW1RBU0tfQ09NTV9MRU5dID0g
e307CiAJREVGSU5FX1dBSVQod2FpdCk7CkBAIC0zMTcsNyArMzIzLDcgQEAgc3RhdGljIGlu
dCBpb19zcV90aHJlYWQodm9pZCAqZGF0YSkKIAkJfQogCiAJCWNhcF9lbnRyaWVzID0gIWxp
c3RfaXNfc2luZ3VsYXIoJnNxZC0+Y3R4X2xpc3QpOwotCQlnZXRydXNhZ2UoY3VycmVudCwg
UlVTQUdFX1NFTEYsICZzdGFydCk7CisJCXN0YXJ0ID0gaW9fc3FfY3B1X3RpbWUoY3VycmVu
dCk7CiAJCWxpc3RfZm9yX2VhY2hfZW50cnkoY3R4LCAmc3FkLT5jdHhfbGlzdCwgc3FkX2xp
c3QpIHsKIAkJCWludCByZXQgPSBfX2lvX3NxX3RocmVhZChjdHgsIGNhcF9lbnRyaWVzKTsK
IApAQCAtMzMzLDcgKzMzOSw3IEBAIHN0YXRpYyBpbnQgaW9fc3FfdGhyZWFkKHZvaWQgKmRh
dGEpCiAKIAkJaWYgKHNxdF9zcGluIHx8ICF0aW1lX2FmdGVyKGppZmZpZXMsIHRpbWVvdXQp
KSB7CiAJCQlpZiAoc3F0X3NwaW4pIHsKLQkJCQlpb19zcV91cGRhdGVfd29ya3RpbWUoc3Fk
LCAmc3RhcnQpOworCQkJCWlvX3NxX3VwZGF0ZV93b3JrdGltZShzcWQsIHN0YXJ0KTsKIAkJ
CQl0aW1lb3V0ID0gamlmZmllcyArIHNxZC0+c3FfdGhyZWFkX2lkbGU7CiAJCQl9CiAJCQlp
ZiAodW5saWtlbHkobmVlZF9yZXNjaGVkKCkpKSB7CmRpZmYgLS1naXQgYS9pb191cmluZy9z
cXBvbGwuaCBiL2lvX3VyaW5nL3NxcG9sbC5oCmluZGV4IGI4M2RjZGVjOTc2NS4uODRlZDJi
MzEyZTg4IDEwMDY0NAotLS0gYS9pb191cmluZy9zcXBvbGwuaAorKysgYi9pb191cmluZy9z
cXBvbGwuaApAQCAtMjksNiArMjksNyBAQCB2b2lkIGlvX3NxX3RocmVhZF91bnBhcmsoc3Ry
dWN0IGlvX3NxX2RhdGEgKnNxZCk7CiB2b2lkIGlvX3B1dF9zcV9kYXRhKHN0cnVjdCBpb19z
cV9kYXRhICpzcWQpOwogdm9pZCBpb19zcXBvbGxfd2FpdF9zcShzdHJ1Y3QgaW9fcmluZ19j
dHggKmN0eCk7CiBpbnQgaW9fc3Fwb2xsX3dxX2NwdV9hZmZpbml0eShzdHJ1Y3QgaW9fcmlu
Z19jdHggKmN0eCwgY3B1bWFza192YXJfdCBtYXNrKTsKK3N0cnVjdCB0aW1lc3BlYzY0IGlv
X3NxX2NwdV90aW1lKHN0cnVjdCB0YXNrX3N0cnVjdCAqdHNrKTsKIAogc3RhdGljIGlubGlu
ZSBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnNxcG9sbF90YXNrX2xvY2tlZChzdHJ1Y3QgaW9fc3Ff
ZGF0YSAqc3FkKQogewotLSAKMi41MS4wCgo=

--------------PvqwD6gU6M4H2ONsrWw8roT0--

