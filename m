Return-Path: <io-uring+bounces-7148-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D220A6A6DB
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 14:07:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66BC4167660
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 13:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC5B6221729;
	Thu, 20 Mar 2025 13:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VAd8gD7M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802B4221574
	for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 13:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742475752; cv=none; b=Rj+ieb17t6/mMl5S9BwJseziZb2qnyZ3bvkJ2NpUNMW5eSDq8j0YrGX+T4ozBd9nZAmrvSsIMDBlVd13tnx+nP8vehaOaMKRVJKsUxLVMVEVy//o454g/PyG2VZcCcae2ELzznAyfvo6MRXWcWLexX0OUsBPiJc81Xx4kUypVos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742475752; c=relaxed/simple;
	bh=JMhhhNGTe9Zato6Ia7XiyqJ9D/Dl48xikq4fGOPQrBg=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:Cc:
	 References:In-Reply-To; b=XuINIBZNvw9X8+XQuULl87PT7/zF9fCbZjGfMTjfBpA92CyVSOv8gQCpIL/dsB17TmcY1FlnCYh1AOYT0NKeyQTsNrDSl2KyTzwjELs/v2AsAfaNl32RNd6f04muVHCjL3IWbXlm9DdNvitt6l12q0nKKQtlvfuXFoIbbVPyKls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VAd8gD7M; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d46693a5e9so6328165ab.3
        for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 06:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742475748; x=1743080548; darn=vger.kernel.org;
        h=in-reply-to:content-language:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XfLDGlTTtRmP8WjpQYTQhZX5dML16RV+akL10ntBsM0=;
        b=VAd8gD7MUTe63gritVljp8aOpLYQsiozkKcPQvK9RaI+oG+TcHUNvnLobZEpo+r/Jo
         vyJ8IM/fCtdBxr07p2JBMg9yi8sezkz0tBCvRbumFBg5tObhkh6UIU5Lkjh1TuBlqEq+
         WERUZd0fxhooGFUzF11Lcm6pTybSDSxmksF56KOUjTlHRJe0BCIsGBuejksYMUDzYYtH
         FB3YIpKcQPVywXWeEbwnTSGXvCJ2BoXVwBq8FesbE14iTUcHaO5TN+qjFiqb9YUCtada
         C6ICCzqMxnGSO/UDZfvaFS/eJQ9w8B8G2mDHCVTP0AeqtQzLIzRMzfF8MVcvL4juC0uX
         r/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742475748; x=1743080548;
        h=in-reply-to:content-language:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XfLDGlTTtRmP8WjpQYTQhZX5dML16RV+akL10ntBsM0=;
        b=N69nR/2MWBDimMgwU9wVBMrgzyQywGkXxZYqHy1zVCi9ukFoQ7fR9kKVQnZG6RHSMC
         +GfFWDqlLLZnjEmPjn8LMH/du2T9yUh5AcETjeOP/09N4O5Nyd65FCleueBhalLiaMY3
         G3jvXFe84w21v1evQtRbKbvl+JdCSG5kbiPKfdnOBZImxTDGdTc+o/aLdfM5YRrfrV4h
         aTfNeEkYadQ8JlFUR1dbRNx/h8zgCSFQjQ+HuWsdPnGnWbhU/NEUVl7XUH4C/SHaq4K9
         HsJ9oQ0PjNNnzZJJzrHFAUXchBA34y2J189PvSsHBQLdkII0vMTQ9Ef35h1Q0L3n6Eoo
         4oWg==
X-Forwarded-Encrypted: i=1; AJvYcCXUJWvDNgclyVT2ymRftl49wbhpZPx6Q+lxOc5ftgbZRnn2x3d1DWDOBMSEcIEpd6s3rjIKayW8lg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yywi9aj2SLTAyoHIjPARacyAQTFu7dn95ioMPeBqWaNEOrwWPuy
	gCEbb/DvtuC5pzn+GhL87hLK6KLPZ23vNyGqJ36ruZC6UD+0jjpz3v0+J66Z4BY=
X-Gm-Gg: ASbGncsMvzTAqPOuSGLYcbLJYfRQ9PXfscanMeSLrChX+1J0fcNwEffCOYSeOrvx6fu
	QwI/DIzvj+RTg7wSKMfN/9jtfC5qn3dAVLz42lAKzHUhrHIXFWXleHhvZRZ+zl3SuovwcmIZNB3
	N4mItPXMQqOe/bYwgrht7ZS37dYYpmXzts3FjpIX3b8HLfE8+7ust3Sz+XsQoKqOa+DTeMJVMS3
	NLemv/HekuL9EUMD/BywD2Wd+6eZ46U2w97pKcVCIfcGJMPkTyvMqqosqAL6BDi14qk+lgdpKxe
	YtW2mstgn92p1D4FU9G+c8dowvlA9YuhpwuM4r8jlw==
X-Google-Smtp-Source: AGHT+IHaQhZqZWqxRYs2gF01Nfg5iK6keAfIGc4rNwmkB87OAZ1hIEGYFvkzr5bAAzURFeJZfth/hQ==
X-Received: by 2002:a05:6e02:1a69:b0:3d4:6ef6:7c70 with SMTP id e9e14a558f8ab-3d586bb7b01mr68132835ab.21.1742475745462;
        Thu, 20 Mar 2025 06:02:25 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2638137fcsm3634784173.106.2025.03.20.06.02.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 06:02:24 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------XeJ5l7j8vrm0Oo9FqamueXIO"
Message-ID: <412b08d9-17fc-4a62-afd3-7371cf479f2d@kernel.dk>
Date: Thu, 20 Mar 2025 07:02:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc1 review
From: Jens Axboe <axboe@kernel.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>,
 Anders Roxell <anders.roxell@linaro.org>,
 Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
 io-uring@vger.kernel.org
References: <20250319143019.983527953@linuxfoundation.org>
 <CA+G9fYvM_riojtryOUb3UrYbtw6yUZTTnbP+_X96nJLCcWYwBA@mail.gmail.com>
 <2deb9e86-7ca8-4baf-8576-83dad1ea065f@kernel.dk>
 <2025031910-poking-crusher-b38f@gregkh>
 <3dc5b070-0837-4737-be78-ba846016c02e@kernel.dk>
Content-Language: en-US
In-Reply-To: <3dc5b070-0837-4737-be78-ba846016c02e@kernel.dk>

This is a multi-part message in MIME format.
--------------XeJ5l7j8vrm0Oo9FqamueXIO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/20/25 6:55 AM, Jens Axboe wrote:
> On 3/19/25 5:51 PM, Greg Kroah-Hartman wrote:
>> On Wed, Mar 19, 2025 at 10:37:20AM -0600, Jens Axboe wrote:
>>> On 3/19/25 10:33 AM, Naresh Kamboju wrote:
>>>> On Wed, 19 Mar 2025 at 20:09, Greg Kroah-Hartman
>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>
>>>>> This is the start of the stable review cycle for the 6.6.84 release.
>>>>> There are 166 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.84-rc1.gz
>>>>> or in the git tree and branch at:
>>>>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>
>>>> Regressions on mips the rt305x_defconfig builds failed with gcc-12
>>>> the stable-rc v6.6.83-167-gd16a828e7b09
>>>>
>>>> First seen on the v6.6.83-167-gd16a828e7b09
>>>>  Good: v6.6.83
>>>>  Bad: v6.6.83-167-gd16a828e7b09
>>>>
>>>> * mips, build
>>>>   - gcc-12-rt305x_defconfig
>>>>
>>>> Regression Analysis:
>>>>  - New regression? Yes
>>>>  - Reproducibility? Yes
>>>>
>>>> Build regression: mips implicit declaration of function 'vunmap'
>>>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>>>
>>> Ah that's my fault, forgot to include the backport of:
>>>
>>> commit 62346c6cb28b043f2a6e95337d9081ec0b37b5f5
>>> Author: Jens Axboe <axboe@kernel.dk>
>>> Date:   Sat Mar 16 07:21:43 2024 -0600
>>>
>>>     mm: add nommu variant of vm_insert_pages()
>>>
>>> for 6.1-stable and 6.6-stable. Greg, can you just cherry pick that one?
>>> It'll pick cleanly into both, should go before the io_uring mmap series
>>> obviously.
>>>
>>> Sorry about that! I did have it in my local trees, but for some reason
>>> forgot to include it in the sent in series.
>>
>> Wait, this is already in the 6.6.y and 6.1.y queues, so this can't be
>> the fix.  Was there a fixup for that commit somewhere else that I'm
>> missing?
> 
> Huh indeed, guess I didn't mess up in the first place. What is going on
> here indeed... Is that mips config NOMMU yet doesn't link in mm/nommu.o?
> 
> Checking, and no, it definitely has MMU=y in the config. Guess I
> should've read the initial report more closely, it's simply missing the
> vunmap definition. Adding linux/vmalloc.h to io_uring/io_uring.c should
> fix it.
> 
> How do we want to deal with this?

Either fold in the hunk from the previous email, or replace patch 2 in
the series I sent with this one instead, which adds the vmalloc.h
include. That should sort out the issue without needing add-on patches
that don't exist upstream.

-- 
Jens Axboe
--------------XeJ5l7j8vrm0Oo9FqamueXIO
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-get-rid-of-remap_pfn_range-for-mapping-ring.patch"
Content-Disposition: attachment;
 filename*0="0002-io_uring-get-rid-of-remap_pfn_range-for-mapping-ring.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAwNjNjZGE4ODA2Y2YyNzdjNTZlNGJmYzcxNjNlNWZhYTM1NWUxNzdkIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFdlZCwgMTMgTWFyIDIwMjQgMDk6NTY6MTQgLTA2MDAKU3ViamVjdDogW1BBVENIIDAy
LzEwXSBpb191cmluZzogZ2V0IHJpZCBvZiByZW1hcF9wZm5fcmFuZ2UoKSBmb3IgbWFwcGlu
ZwogcmluZ3Mvc3FlcwoKQ29tbWl0IDNhYjFkYjNjNjAzOWUwMmE5ZGViOWQ1MDkxZDI4ZDU1
OTkxN2E2NDUgdXBzdHJlYW0uCgpSYXRoZXIgdGhhbiB1c2UgcmVtYXBfcGZuX3JhbmdlKCkg
Zm9yIHRoaXMgYW5kIG1hbnVhbGx5IGZyZWUgbGF0ZXIsCnN3aXRjaCB0byB1c2luZyB2bV9p
bnNlcnRfcGFnZXMoKSBhbmQgaGF2ZSBpdCBKdXN0IFdvcmsuCgpJZiBwb3NzaWJsZSwgYWxs
b2NhdGUgYSBzaW5nbGUgY29tcG91bmQgcGFnZSB0aGF0IGNvdmVycyB0aGUgcmFuZ2UgdGhh
dAppcyBuZWVkZWQuIElmIHRoYXQgd29ya3MsIHRoZW4gd2UgY2FuIGp1c3QgdXNlIHBhZ2Vf
YWRkcmVzcygpIG9uIHRoYXQKcGFnZS4gSWYgd2UgZmFpbCB0byBnZXQgYSBjb21wb3VuZCBw
YWdlLCBhbGxvY2F0ZSBzaW5nbGUgcGFnZXMgYW5kIHVzZQp2bWFwKCkgdG8gbWFwIHRoZW0g
aW50byB0aGUga2VybmVsIHZpcnR1YWwgYWRkcmVzcyBzcGFjZS4KClRoaXMganVzdCBjb3Zl
cnMgdGhlIHJpbmdzL3NxZXMsIHRoZSBvdGhlciByZW1haW5pbmcgdXNlciBvZiB0aGUgbW1h
cApyZW1hcF9wZm5fcmFuZ2UoKSB1c2VyIHdpbGwgYmUgY29udmVydGVkIHNlcGFyYXRlbHku
IE9uY2UgdGhhdCBpcyBkb25lLAp3ZSBjYW4ga2lsbCB0aGUgb2xkIGFsbG9jL2ZyZWUgY29k
ZS4KClNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0tCiBp
b191cmluZy9pb191cmluZy5jIHwgMTQwICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrLS0tCiBpb191cmluZy9pb191cmluZy5oIHwgICAyICsKIDIgZmlsZXMg
Y2hhbmdlZCwgMTM0IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvaW9fdXJpbmcvaW9fdXJpbmcuYyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMKaW5kZXggNTc3
NjQ0MGY1ODRjLi5iNTA2MDY0Y2EyOWQgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL2lvX3VyaW5n
LmMKKysrIGIvaW9fdXJpbmcvaW9fdXJpbmcuYwpAQCAtNzEsNiArNzEsNyBAQAogI2luY2x1
ZGUgPGxpbnV4L2lvX3VyaW5nLmg+CiAjaW5jbHVkZSA8bGludXgvYXVkaXQuaD4KICNpbmNs
dWRlIDxsaW51eC9zZWN1cml0eS5oPgorI2luY2x1ZGUgPGxpbnV4L3ZtYWxsb2MuaD4KICNp
bmNsdWRlIDxhc20vc2htcGFyYW0uaD4KIAogI2RlZmluZSBDUkVBVEVfVFJBQ0VfUE9JTlRT
CkBAIC0yNjgzLDYgKzI2ODQsMzYgQEAgc3RhdGljIGludCBpb19jcXJpbmdfd2FpdChzdHJ1
Y3QgaW9fcmluZ19jdHggKmN0eCwgaW50IG1pbl9ldmVudHMsCiAJcmV0dXJuIFJFQURfT05D
RShyaW5ncy0+Y3EuaGVhZCkgPT0gUkVBRF9PTkNFKHJpbmdzLT5jcS50YWlsKSA/IHJldCA6
IDA7CiB9CiAKK3N0YXRpYyB2b2lkIGlvX3BhZ2VzX3VubWFwKHZvaWQgKnB0ciwgc3RydWN0
IHBhZ2UgKioqcGFnZXMsCisJCQkgICB1bnNpZ25lZCBzaG9ydCAqbnBhZ2VzKQoreworCWJv
b2wgZG9fdnVubWFwID0gZmFsc2U7CisKKwlpZiAoIXB0cikKKwkJcmV0dXJuOworCisJaWYg
KCpucGFnZXMpIHsKKwkJc3RydWN0IHBhZ2UgKip0b19mcmVlID0gKnBhZ2VzOworCQlpbnQg
aTsKKworCQkvKgorCQkgKiBPbmx5IGRpZCB2bWFwIGZvciB0aGUgbm9uLWNvbXBvdW5kIG11
bHRpcGxlIHBhZ2UgY2FzZS4KKwkJICogRm9yIHRoZSBjb21wb3VuZCBwYWdlLCB3ZSBqdXN0
IG5lZWQgdG8gcHV0IHRoZSBoZWFkLgorCQkgKi8KKwkJaWYgKFBhZ2VDb21wb3VuZCh0b19m
cmVlWzBdKSkKKwkJCSpucGFnZXMgPSAxOworCQllbHNlIGlmICgqbnBhZ2VzID4gMSkKKwkJ
CWRvX3Z1bm1hcCA9IHRydWU7CisJCWZvciAoaSA9IDA7IGkgPCAqbnBhZ2VzOyBpKyspCisJ
CQlwdXRfcGFnZSh0b19mcmVlW2ldKTsKKwl9CisJaWYgKGRvX3Z1bm1hcCkKKwkJdnVubWFw
KHB0cik7CisJa3ZmcmVlKCpwYWdlcyk7CisJKnBhZ2VzID0gTlVMTDsKKwkqbnBhZ2VzID0g
MDsKK30KKwogdm9pZCBpb19tZW1fZnJlZSh2b2lkICpwdHIpCiB7CiAJaWYgKCFwdHIpCkBA
IC0yNzg3LDggKzI4MTgsOCBAQCBzdGF0aWMgdm9pZCAqaW9fc3Flc19tYXAoc3RydWN0IGlv
X3JpbmdfY3R4ICpjdHgsIHVuc2lnbmVkIGxvbmcgdWFkZHIsCiBzdGF0aWMgdm9pZCBpb19y
aW5nc19mcmVlKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4KQogewogCWlmICghKGN0eC0+Zmxh
Z3MgJiBJT1JJTkdfU0VUVVBfTk9fTU1BUCkpIHsKLQkJaW9fbWVtX2ZyZWUoY3R4LT5yaW5n
cyk7Ci0JCWlvX21lbV9mcmVlKGN0eC0+c3Ffc3Flcyk7CisJCWlvX3BhZ2VzX3VubWFwKGN0
eC0+cmluZ3MsICZjdHgtPnJpbmdfcGFnZXMsICZjdHgtPm5fcmluZ19wYWdlcyk7CisJCWlv
X3BhZ2VzX3VubWFwKGN0eC0+c3Ffc3FlcywgJmN0eC0+c3FlX3BhZ2VzLCAmY3R4LT5uX3Nx
ZV9wYWdlcyk7CiAJfSBlbHNlIHsKIAkJaW9fcGFnZXNfZnJlZSgmY3R4LT5yaW5nX3BhZ2Vz
LCBjdHgtPm5fcmluZ19wYWdlcyk7CiAJCWN0eC0+bl9yaW5nX3BhZ2VzID0gMDsKQEAgLTI4
MDAsNiArMjgzMSw4MCBAQCBzdGF0aWMgdm9pZCBpb19yaW5nc19mcmVlKHN0cnVjdCBpb19y
aW5nX2N0eCAqY3R4KQogCWN0eC0+c3Ffc3FlcyA9IE5VTEw7CiB9CiAKK3N0YXRpYyB2b2lk
ICppb19tZW1fYWxsb2NfY29tcG91bmQoc3RydWN0IHBhZ2UgKipwYWdlcywgaW50IG5yX3Bh
Z2VzLAorCQkJCSAgIHNpemVfdCBzaXplLCBnZnBfdCBnZnApCit7CisJc3RydWN0IHBhZ2Ug
KnBhZ2U7CisJaW50IGksIG9yZGVyOworCisJb3JkZXIgPSBnZXRfb3JkZXIoc2l6ZSk7CisJ
aWYgKG9yZGVyID4gMTApCisJCXJldHVybiBFUlJfUFRSKC1FTk9NRU0pOworCWVsc2UgaWYg
KG9yZGVyKQorCQlnZnAgfD0gX19HRlBfQ09NUDsKKworCXBhZ2UgPSBhbGxvY19wYWdlcyhn
ZnAsIG9yZGVyKTsKKwlpZiAoIXBhZ2UpCisJCXJldHVybiBFUlJfUFRSKC1FTk9NRU0pOwor
CisJZm9yIChpID0gMDsgaSA8IG5yX3BhZ2VzOyBpKyspCisJCXBhZ2VzW2ldID0gcGFnZSAr
IGk7CisKKwlyZXR1cm4gcGFnZV9hZGRyZXNzKHBhZ2UpOworfQorCitzdGF0aWMgdm9pZCAq
aW9fbWVtX2FsbG9jX3NpbmdsZShzdHJ1Y3QgcGFnZSAqKnBhZ2VzLCBpbnQgbnJfcGFnZXMs
IHNpemVfdCBzaXplLAorCQkJCSBnZnBfdCBnZnApCit7CisJdm9pZCAqcmV0OworCWludCBp
OworCisJZm9yIChpID0gMDsgaSA8IG5yX3BhZ2VzOyBpKyspIHsKKwkJcGFnZXNbaV0gPSBh
bGxvY19wYWdlKGdmcCk7CisJCWlmICghcGFnZXNbaV0pCisJCQlnb3RvIGVycjsKKwl9CisK
KwlyZXQgPSB2bWFwKHBhZ2VzLCBucl9wYWdlcywgVk1fTUFQLCBQQUdFX0tFUk5FTCk7CisJ
aWYgKHJldCkKKwkJcmV0dXJuIHJldDsKK2VycjoKKwl3aGlsZSAoaS0tKQorCQlwdXRfcGFn
ZShwYWdlc1tpXSk7CisJcmV0dXJuIEVSUl9QVFIoLUVOT01FTSk7Cit9CisKK3N0YXRpYyB2
b2lkICppb19wYWdlc19tYXAoc3RydWN0IHBhZ2UgKioqb3V0X3BhZ2VzLCB1bnNpZ25lZCBz
aG9ydCAqbnBhZ2VzLAorCQkJICBzaXplX3Qgc2l6ZSkKK3sKKwlnZnBfdCBnZnAgPSBHRlBf
S0VSTkVMX0FDQ09VTlQgfCBfX0dGUF9aRVJPIHwgX19HRlBfTk9XQVJOOworCXN0cnVjdCBw
YWdlICoqcGFnZXM7CisJaW50IG5yX3BhZ2VzOworCXZvaWQgKnJldDsKKworCW5yX3BhZ2Vz
ID0gKHNpemUgKyBQQUdFX1NJWkUgLSAxKSA+PiBQQUdFX1NISUZUOworCXBhZ2VzID0ga3Zt
YWxsb2NfYXJyYXkobnJfcGFnZXMsIHNpemVvZihzdHJ1Y3QgcGFnZSAqKSwgZ2ZwKTsKKwlp
ZiAoIXBhZ2VzKQorCQlyZXR1cm4gRVJSX1BUUigtRU5PTUVNKTsKKworCXJldCA9IGlvX21l
bV9hbGxvY19jb21wb3VuZChwYWdlcywgbnJfcGFnZXMsIHNpemUsIGdmcCk7CisJaWYgKCFJ
U19FUlIocmV0KSkKKwkJZ290byBkb25lOworCisJcmV0ID0gaW9fbWVtX2FsbG9jX3Npbmds
ZShwYWdlcywgbnJfcGFnZXMsIHNpemUsIGdmcCk7CisJaWYgKCFJU19FUlIocmV0KSkgewor
ZG9uZToKKwkJKm91dF9wYWdlcyA9IHBhZ2VzOworCQkqbnBhZ2VzID0gbnJfcGFnZXM7CisJ
CXJldHVybiByZXQ7CisJfQorCisJa3ZmcmVlKHBhZ2VzKTsKKwkqb3V0X3BhZ2VzID0gTlVM
TDsKKwkqbnBhZ2VzID0gMDsKKwlyZXR1cm4gcmV0OworfQorCiB2b2lkICppb19tZW1fYWxs
b2Moc2l6ZV90IHNpemUpCiB7CiAJZ2ZwX3QgZ2ZwID0gR0ZQX0tFUk5FTF9BQ0NPVU5UIHwg
X19HRlBfWkVSTyB8IF9fR0ZQX05PV0FSTiB8IF9fR0ZQX0NPTVA7CkBAIC0zNDYzLDE0ICsz
NTY4LDEyIEBAIHN0YXRpYyB2b2lkICppb191cmluZ192YWxpZGF0ZV9tbWFwX3JlcXVlc3Qo
c3RydWN0IGZpbGUgKmZpbGUsCiAJCS8qIERvbid0IGFsbG93IG1tYXAgaWYgdGhlIHJpbmcg
d2FzIHNldHVwIHdpdGhvdXQgaXQgKi8KIAkJaWYgKGN0eC0+ZmxhZ3MgJiBJT1JJTkdfU0VU
VVBfTk9fTU1BUCkKIAkJCXJldHVybiBFUlJfUFRSKC1FSU5WQUwpOwotCQlwdHIgPSBjdHgt
PnJpbmdzOwotCQlicmVhazsKKwkJcmV0dXJuIGN0eC0+cmluZ3M7CiAJY2FzZSBJT1JJTkdf
T0ZGX1NRRVM6CiAJCS8qIERvbid0IGFsbG93IG1tYXAgaWYgdGhlIHJpbmcgd2FzIHNldHVw
IHdpdGhvdXQgaXQgKi8KIAkJaWYgKGN0eC0+ZmxhZ3MgJiBJT1JJTkdfU0VUVVBfTk9fTU1B
UCkKIAkJCXJldHVybiBFUlJfUFRSKC1FSU5WQUwpOwotCQlwdHIgPSBjdHgtPnNxX3NxZXM7
Ci0JCWJyZWFrOworCQlyZXR1cm4gY3R4LT5zcV9zcWVzOwogCWNhc2UgSU9SSU5HX09GRl9Q
QlVGX1JJTkc6IHsKIAkJc3RydWN0IGlvX2J1ZmZlcl9saXN0ICpibDsKIAkJdW5zaWduZWQg
aW50IGJnaWQ7CkBAIC0zNDk0LDExICszNTk3LDIyIEBAIHN0YXRpYyB2b2lkICppb191cmlu
Z192YWxpZGF0ZV9tbWFwX3JlcXVlc3Qoc3RydWN0IGZpbGUgKmZpbGUsCiAJcmV0dXJuIHB0
cjsKIH0KIAoraW50IGlvX3VyaW5nX21tYXBfcGFnZXMoc3RydWN0IGlvX3JpbmdfY3R4ICpj
dHgsIHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hLAorCQkJc3RydWN0IHBhZ2UgKipwYWdl
cywgaW50IG5wYWdlcykKK3sKKwl1bnNpZ25lZCBsb25nIG5yX3BhZ2VzID0gbnBhZ2VzOwor
CisJdm1fZmxhZ3Nfc2V0KHZtYSwgVk1fRE9OVEVYUEFORCk7CisJcmV0dXJuIHZtX2luc2Vy
dF9wYWdlcyh2bWEsIHZtYS0+dm1fc3RhcnQsIHBhZ2VzLCAmbnJfcGFnZXMpOworfQorCiAj
aWZkZWYgQ09ORklHX01NVQogCiBzdGF0aWMgX19jb2xkIGludCBpb191cmluZ19tbWFwKHN0
cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSkKIHsKKwlzdHJ1
Y3QgaW9fcmluZ19jdHggKmN0eCA9IGZpbGUtPnByaXZhdGVfZGF0YTsKIAlzaXplX3Qgc3og
PSB2bWEtPnZtX2VuZCAtIHZtYS0+dm1fc3RhcnQ7CisJbG9uZyBvZmZzZXQgPSB2bWEtPnZt
X3Bnb2ZmIDw8IFBBR0VfU0hJRlQ7CiAJdW5zaWduZWQgbG9uZyBwZm47CiAJdm9pZCAqcHRy
OwogCkBAIC0zNTA2LDYgKzM2MjAsMTYgQEAgc3RhdGljIF9fY29sZCBpbnQgaW9fdXJpbmdf
bW1hcChzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpCiAJ
aWYgKElTX0VSUihwdHIpKQogCQlyZXR1cm4gUFRSX0VSUihwdHIpOwogCisJc3dpdGNoIChv
ZmZzZXQgJiBJT1JJTkdfT0ZGX01NQVBfTUFTSykgeworCWNhc2UgSU9SSU5HX09GRl9TUV9S
SU5HOgorCWNhc2UgSU9SSU5HX09GRl9DUV9SSU5HOgorCQlyZXR1cm4gaW9fdXJpbmdfbW1h
cF9wYWdlcyhjdHgsIHZtYSwgY3R4LT5yaW5nX3BhZ2VzLAorCQkJCQkJY3R4LT5uX3Jpbmdf
cGFnZXMpOworCWNhc2UgSU9SSU5HX09GRl9TUUVTOgorCQlyZXR1cm4gaW9fdXJpbmdfbW1h
cF9wYWdlcyhjdHgsIHZtYSwgY3R4LT5zcWVfcGFnZXMsCisJCQkJCQljdHgtPm5fc3FlX3Bh
Z2VzKTsKKwl9CisKIAlwZm4gPSB2aXJ0X3RvX3BoeXMocHRyKSA+PiBQQUdFX1NISUZUOwog
CXJldHVybiByZW1hcF9wZm5fcmFuZ2Uodm1hLCB2bWEtPnZtX3N0YXJ0LCBwZm4sIHN6LCB2
bWEtPnZtX3BhZ2VfcHJvdCk7CiB9CkBAIC0zNzk1LDcgKzM5MTksNyBAQCBzdGF0aWMgX19j
b2xkIGludCBpb19hbGxvY2F0ZV9zY3FfdXJpbmdzKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4
LAogCQlyZXR1cm4gLUVPVkVSRkxPVzsKIAogCWlmICghKGN0eC0+ZmxhZ3MgJiBJT1JJTkdf
U0VUVVBfTk9fTU1BUCkpCi0JCXJpbmdzID0gaW9fbWVtX2FsbG9jKHNpemUpOworCQlyaW5n
cyA9IGlvX3BhZ2VzX21hcCgmY3R4LT5yaW5nX3BhZ2VzLCAmY3R4LT5uX3JpbmdfcGFnZXMs
IHNpemUpOwogCWVsc2UKIAkJcmluZ3MgPSBpb19yaW5nc19tYXAoY3R4LCBwLT5jcV9vZmYu
dXNlcl9hZGRyLCBzaXplKTsKIApAQCAtMzgyMCw3ICszOTQ0LDcgQEAgc3RhdGljIF9fY29s
ZCBpbnQgaW9fYWxsb2NhdGVfc2NxX3VyaW5ncyhzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwK
IAl9CiAKIAlpZiAoIShjdHgtPmZsYWdzICYgSU9SSU5HX1NFVFVQX05PX01NQVApKQotCQlw
dHIgPSBpb19tZW1fYWxsb2Moc2l6ZSk7CisJCXB0ciA9IGlvX3BhZ2VzX21hcCgmY3R4LT5z
cWVfcGFnZXMsICZjdHgtPm5fc3FlX3BhZ2VzLCBzaXplKTsKIAllbHNlCiAJCXB0ciA9IGlv
X3NxZXNfbWFwKGN0eCwgcC0+c3Ffb2ZmLnVzZXJfYWRkciwgc2l6ZSk7CiAKZGlmZiAtLWdp
dCBhL2lvX3VyaW5nL2lvX3VyaW5nLmggYi9pb191cmluZy9pb191cmluZy5oCmluZGV4IDU3
NjU4ZDI0YTczZS4uZWEwYjhhY2FiYzcxIDEwMDY0NAotLS0gYS9pb191cmluZy9pb191cmlu
Zy5oCisrKyBiL2lvX3VyaW5nL2lvX3VyaW5nLmgKQEAgLTU1LDYgKzU1LDggQEAgYm9vbCBp
b19maWxsX2NxZV9yZXFfYXV4KHN0cnVjdCBpb19raW9jYiAqcmVxLCBib29sIGRlZmVyLCBz
MzIgcmVzLCB1MzIgY2ZsYWdzKTsKIHZvaWQgX19pb19jb21taXRfY3FyaW5nX2ZsdXNoKHN0
cnVjdCBpb19yaW5nX2N0eCAqY3R4KTsKIAogc3RydWN0IHBhZ2UgKippb19waW5fcGFnZXMo
dW5zaWduZWQgbG9uZyB1YnVmLCB1bnNpZ25lZCBsb25nIGxlbiwgaW50ICpucGFnZXMpOwor
aW50IGlvX3VyaW5nX21tYXBfcGFnZXMoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsIHN0cnVj
dCB2bV9hcmVhX3N0cnVjdCAqdm1hLAorCQkJc3RydWN0IHBhZ2UgKipwYWdlcywgaW50IG5w
YWdlcyk7CiAKIHN0cnVjdCBmaWxlICppb19maWxlX2dldF9ub3JtYWwoc3RydWN0IGlvX2tp
b2NiICpyZXEsIGludCBmZCk7CiBzdHJ1Y3QgZmlsZSAqaW9fZmlsZV9nZXRfZml4ZWQoc3Ry
dWN0IGlvX2tpb2NiICpyZXEsIGludCBmZCwKLS0gCjIuNDkuMAoK

--------------XeJ5l7j8vrm0Oo9FqamueXIO--

