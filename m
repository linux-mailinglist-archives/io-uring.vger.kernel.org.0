Return-Path: <io-uring+bounces-4392-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 828079BAAE7
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 03:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36ECB280C35
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 02:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E03E27456;
	Mon,  4 Nov 2024 02:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GIp9u7UL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D1C2F5A
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 02:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730687917; cv=none; b=bLyVKqF5eJ3NSrzSO/wO9G7ePFnDsblrwPwrfXKs/7/UHZUFzec2Rk306ln8BaVko8htPC7IerN+Ou8bgVHddKL8JGbZfw4x2s4ocf81IypZWC6htH952TzO4r3uNE4sb2doBrx0mmw+Bce/O5vGERYKB9aaz3uXErTVdp+Afvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730687917; c=relaxed/simple;
	bh=XhCyYYk0mEstaNDV/2XhxEt14BcFP29muk01JM58Mg0=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:Cc:
	 References:In-Reply-To; b=jOZDNdhLdroxgaHDGtTJFkpFruhqcpvWxKf7WCIqBT+HWSxtHAHn3/yad3rFxpU0PW0vc1iNGAJ16gOgda6OAhlGhbzK5GNW40za7PxPIzmTaDIzQoOPhV4ZFGPOfYx3x3YHD9RxZIY2TDL75fNmAl+nBz66tLoTKrlP0c5qKg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GIp9u7UL; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20c9978a221so36965095ad.1
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 18:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730687913; x=1731292713; darn=vger.kernel.org;
        h=in-reply-to:content-language:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eC3eBFWwdOLE/lj3duyiFnbRAXC5pXb5r7bt7MjFNVc=;
        b=GIp9u7ULHgWBPkcjslrBVautXIdTTmj7HVxNi/WYUTXH0jDAPcySfBFb2uDz9xR6PB
         zoaMJiczxr9xFLQTiD/OWPoMI4dGFiYeWWDCUx13nhP/+0Ul4KWPDpdUcWuAj43OZE7e
         tnkPEmJrfh3b3VTN3tvuZRn12AqPtMVHpSehrSuMaCeKGUOZjw/MmHBhhfkfxie1ucyu
         xoDtHlLzaIbgNppYdAOS9iQDyXkwWZXSjQpAqEvC3H16Pa6bGvU28bm9OlyZLo7Yn41b
         B7+Eoq6WL39V7vzWwhe9mUpXhtT3T3hdd2sQWQU14B9WSrXsImfpPKQQPSRivrrpNCKy
         vtwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730687913; x=1731292713;
        h=in-reply-to:content-language:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eC3eBFWwdOLE/lj3duyiFnbRAXC5pXb5r7bt7MjFNVc=;
        b=pQ7UFpR8RLnhgngBfJLkkmaqW5ZYo2RvDYoV/0g7vW+aLIs4dNZmbz34CQ8Qk7vdrt
         j3TTLCqfCJQh+pMdhYel9zAhN9IBaRZvbbN2T2IYfPS6BqQuAoanvOYlF+K26PSkdbCW
         e5K9IcMfgPlFt0fsMNf8aw9giLGeLDT3GZTs3XR58+ZDxoQngMv4gaB9VXXDpRbYdtRY
         TsW2W7JxRLf6WYPVuyDYeHblZUA9/ZlZd7xFBwWn8DiY2MPmxqsCycC5Is9aZx0eEIvd
         0BgZVdVvkCRq3VTm/R/I0uYSg7pfrgQ0nVm4iCX57u9yZZkkmkuV7OBfKzft0rf/OWQQ
         JeYA==
X-Forwarded-Encrypted: i=1; AJvYcCW3uUp2aeTno7aGtB0h8oaCBElhc50Fq1n9vqLHnZ5MXmc4y1f3lr1LhI3cvZ9jqd03bTw3WXSKmg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFQD7OkFA1l9HFI7PtwF7yTSU2YLV1ouqFraVcFSx22XyHcxMM
	HDKgLh7XkJJmcKTfj7QtbII13BlMVK9BuODB7VPOHq6Sp0fPxMNiaeJz0LfK4TY=
X-Google-Smtp-Source: AGHT+IHirDQUIVeuwX+mE5dRWw3aGeXGQssoMqggzHIIOwB3ls3PYAgmLZwJ1Gf7RQMWv52Y0OAvbg==
X-Received: by 2002:a17:902:f693:b0:20b:9535:922d with SMTP id d9443c01a7336-210c6d27f7fmr350982525ad.60.1730687912581;
        Sun, 03 Nov 2024 18:38:32 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2110570865fsm51955925ad.107.2024.11.03.18.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 18:38:31 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------y0Q5tL4sI0ACrQE9b500uhkB"
Message-ID: <c34e6c38-ca47-439a-baf1-3489c05a65a8@kernel.dk>
Date: Sun, 3 Nov 2024 19:38:30 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Stable backport (was "Re: PROBLEM: io_uring hang causing
 uninterruptible sleep state on 6.6.59")
From: Jens Axboe <axboe@kernel.dk>
To: Keith Busch <kbusch@kernel.org>
Cc: Andrew Marshall <andrew@johnandrewmarshall.com>,
 io-uring@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 stable <stable@vger.kernel.org>
References: <3d913aef-8c44-4f50-9bdf-7d9051b08941@app.fastmail.com>
 <cc8b92ba-2daa-49e3-abe6-39e7d79f213d@kernel.dk>
 <ZygO7O1Pm5lYbNkP@kbusch-mbp>
 <25c4c665-1a33-456c-93c7-8b7b56c0e6db@kernel.dk>
Content-Language: en-US
In-Reply-To: <25c4c665-1a33-456c-93c7-8b7b56c0e6db@kernel.dk>

This is a multi-part message in MIME format.
--------------y0Q5tL4sI0ACrQE9b500uhkB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/24 5:06 PM, Jens Axboe wrote:
> On 11/3/24 5:01 PM, Keith Busch wrote:
>> On Sun, Nov 03, 2024 at 04:53:27PM -0700, Jens Axboe wrote:
>>> On 11/3/24 4:47 PM, Andrew Marshall wrote:
>>>> I identified f4ce3b5d26ce149e77e6b8e8f2058aa80e5b034e as the likely
>>>> problematic commit simply by browsing git log. As indicated above;
>>>> reverting that atop 6.6.59 results in success. Since it is passing on
>>>> 6.11.6, I suspect there is some missing backport to 6.6.x, or some
>>>> other semantic merge conflict. Unfortunately I do not have a compact,
>>>> minimal reproducer, but can provide my large one (it is testing a
>>>> larger build process in a VM) if needed?there are some additional
>>>> details in the above-linked downstream bug report, though. I hope that
>>>> having identified the problematic commit is enough for someone with
>>>> more context to go off of. Happy to provide more information if
>>>> needed.
>>>
>>> Don't worry about not having a reproducer, having the backport commit
>>> pin pointed will do just fine. I'll take a look at this.
>>
>> I think stable is missing:
>>
>>   6b231248e97fc3 ("io_uring: consolidate overflow flushing")
> 
> I think you need to go back further than that, this one already
> unconditionally holds ->uring_lock around overflow flushing...

Took a look, it's this one:

commit 8d09a88ef9d3cb7d21d45c39b7b7c31298d23998
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Wed Apr 10 02:26:54 2024 +0100

    io_uring: always lock __io_cqring_overflow_flush

Greg/stable, can you pick this one for 6.6-stable? It picks
cleanly.

For 6.1, which is the other stable of that age that has the backport,
the attached patch will do the trick.

With that, I believe it should be sorted. Hopefully that can make
6.6.60 and 6.1.116.

-- 
Jens Axboe
--------------y0Q5tL4sI0ACrQE9b500uhkB
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-always-lock-__io_cqring_overflow_flush.patch"
Content-Disposition: attachment;
 filename*0="0001-io_uring-always-lock-__io_cqring_overflow_flush.patch"
Content-Transfer-Encoding: base64

RnJvbSAzZjFjMzNmMDMzODZjNDgxY2FmMjA0NGE4MzZmM2NhNjExMDk0MDk4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdt
YWlsLmNvbT4KRGF0ZTogV2VkLCAxMCBBcHIgMjAyNCAwMjoyNjo1NCArMDEwMApTdWJqZWN0
OiBbUEFUQ0hdIGlvX3VyaW5nOiBhbHdheXMgbG9jayBfX2lvX2NxcmluZ19vdmVyZmxvd19m
bHVzaAoKQ29tbWl0IDhkMDlhODhlZjlkM2NiN2QyMWQ0NWMzOWI3YjdjMzEyOThkMjM5OTgg
dXBzdHJlYW0uCgpDb25kaXRpb25hbCBsb2NraW5nIGlzIG5ldmVyIGdyZWF0LCBpbiBjYXNl
IG9mCl9faW9fY3FyaW5nX292ZXJmbG93X2ZsdXNoKCksIHdoaWNoIGlzIGEgc2xvdyBwYXRo
LCBpdCdzIG5vdCBqdXN0aWZpZWQuCkRvbid0IGhhbmRsZSBJT1BPTEwgc2VwYXJhdGVseSwg
YWx3YXlzIGdyYWIgdXJpbmdfbG9jayBmb3Igb3ZlcmZsb3cKZmx1c2hpbmcuCgpTaWduZWQt
b2ZmLWJ5OiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdtYWlsLmNvbT4KTGluazog
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8xNjI5NDdkZjI5OWFhMTI2OTNhYzRiMzA1ZGFj
ZWRhYjMyZWM3OTc2LjE3MTI3MDgyNjEuZ2l0LmFzbWwuc2lsZW5jZUBnbWFpbC5jb20KU2ln
bmVkLW9mZi1ieTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgotLS0KIGlvX3VyaW5n
L2lvX3VyaW5nLmMgfCAxMSArKysrKystLS0tLQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0
aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pb191cmluZy9pb191cmlu
Zy5jIGIvaW9fdXJpbmcvaW9fdXJpbmcuYwppbmRleCBmOTAyYjE2MWYwMmMuLjkyYzFhYThm
MzUwMSAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvaW9fdXJpbmcuYworKysgYi9pb191cmluZy9p
b191cmluZy5jCkBAIC01OTMsNiArNTkzLDggQEAgc3RhdGljIGJvb2wgX19pb19jcXJpbmdf
b3ZlcmZsb3dfZmx1c2goc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsIGJvb2wgZm9yY2UpCiAJ
Ym9vbCBhbGxfZmx1c2hlZDsKIAlzaXplX3QgY3FlX3NpemUgPSBzaXplb2Yoc3RydWN0IGlv
X3VyaW5nX2NxZSk7CiAKKwlsb2NrZGVwX2Fzc2VydF9oZWxkKCZjdHgtPnVyaW5nX2xvY2sp
OworCiAJaWYgKCFmb3JjZSAmJiBfX2lvX2NxcmluZ19ldmVudHMoY3R4KSA9PSBjdHgtPmNx
X2VudHJpZXMpCiAJCXJldHVybiBmYWxzZTsKIApAQCAtNjQ3LDEyICs2NDksOSBAQCBzdGF0
aWMgYm9vbCBpb19jcXJpbmdfb3ZlcmZsb3dfZmx1c2goc3RydWN0IGlvX3JpbmdfY3R4ICpj
dHgpCiAJYm9vbCByZXQgPSB0cnVlOwogCiAJaWYgKHRlc3RfYml0KElPX0NIRUNLX0NRX09W
RVJGTE9XX0JJVCwgJmN0eC0+Y2hlY2tfY3EpKSB7Ci0JCS8qIGlvcG9sbCBzeW5jcyBhZ2Fp
bnN0IHVyaW5nX2xvY2ssIG5vdCBjb21wbGV0aW9uX2xvY2sgKi8KLQkJaWYgKGN0eC0+Zmxh
Z3MgJiBJT1JJTkdfU0VUVVBfSU9QT0xMKQotCQkJbXV0ZXhfbG9jaygmY3R4LT51cmluZ19s
b2NrKTsKKwkJbXV0ZXhfbG9jaygmY3R4LT51cmluZ19sb2NrKTsKIAkJcmV0ID0gX19pb19j
cXJpbmdfb3ZlcmZsb3dfZmx1c2goY3R4LCBmYWxzZSk7Ci0JCWlmIChjdHgtPmZsYWdzICYg
SU9SSU5HX1NFVFVQX0lPUE9MTCkKLQkJCW11dGV4X3VubG9jaygmY3R4LT51cmluZ19sb2Nr
KTsKKwkJbXV0ZXhfdW5sb2NrKCZjdHgtPnVyaW5nX2xvY2spOwogCX0KIAogCXJldHVybiBy
ZXQ7CkBAIC0xNDA1LDYgKzE0MDQsOCBAQCBzdGF0aWMgaW50IGlvX2lvcG9sbF9jaGVjayhz
dHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwgbG9uZyBtaW4pCiAJaW50IHJldCA9IDA7CiAJdW5z
aWduZWQgbG9uZyBjaGVja19jcTsKIAorCWxvY2tkZXBfYXNzZXJ0X2hlbGQoJmN0eC0+dXJp
bmdfbG9jayk7CisKIAlpZiAoIWlvX2FsbG93ZWRfcnVuX3R3KGN0eCkpCiAJCXJldHVybiAt
RUVYSVNUOwogCi0tIAoyLjQ1LjIKCg==

--------------y0Q5tL4sI0ACrQE9b500uhkB--

