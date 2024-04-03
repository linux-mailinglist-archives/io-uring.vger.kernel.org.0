Return-Path: <io-uring+bounces-1373-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7F7897163
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 15:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAA7628C987
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 13:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F631487C9;
	Wed,  3 Apr 2024 13:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bzl+IQGw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7729148318
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 13:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712151670; cv=none; b=IfM7LCNQ9sn2+9tY67xl/ldB0wyPBkWd57S9gZR3phhkD6JPP1sa/JpY+zJtloiLx0WX2X6X0FaXJxiT59fF9vChEQ0RrHRXpO559VBMJr0OYMGIh6qGhHhx/tfsXlnaXkhOlbta4XfIEGR3dLkjweBZIQ8OM/8jVEYEuySUizY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712151670; c=relaxed/simple;
	bh=GZFlQX1H6jPbzjug/cz0X/LeufVBoT/JYRIOc+xjhb8=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=Zx5cwpKYMmovqlsjORHpwpn+I3TIkCnJ1y6Dl48NKDUwfygeJZWE9lwmOTsk4v4ja7EFC+Qs9WtznGYn8T281uBc4UImNBha2JYX7fJ1ZMUMrGRV7tW/98tCeVkBMxPQEySJMRuMXdWefwcRlMvgUeaSUW7Sza4RB5Nq+XuZg+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Bzl+IQGw; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7c86e6f649aso22879239f.0
        for <io-uring@vger.kernel.org>; Wed, 03 Apr 2024 06:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712151666; x=1712756466; darn=vger.kernel.org;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zca5g4HSoqemmQFyKLyavYfNMp/ItanPMe92a1O7/GA=;
        b=Bzl+IQGw3c2UjQ9crAd0ju3CxEVlTDn4vZgti/L0at+twIA5SiAdb4de6swcC0DD72
         RjpssEeEavMTfBV1swnrXc3EVHBpsiZzBWLNaXj37Vy5LcxK06TlrbHe4BZ2h3FJePn5
         WSPMEfXfUswcI8quQgs9CMrlCh4RPZBAfLlRghCk71ceI6IMRY9Efbc4myzADRPp+D9O
         osC2aHJmsVsGlub4qpBMpBR1/MOWoleZ/volIKhgZGvLWNodM9PdS7Tl8IL561YyWWWd
         ETdmVwMGUQnM3i/j9PCVFCQMTC1avLrQVpBeHj36QkM1eS7T3ffx+aCaTJjsQYq16g1j
         Kv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712151666; x=1712756466;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zca5g4HSoqemmQFyKLyavYfNMp/ItanPMe92a1O7/GA=;
        b=ksj7tG+cBwisRK+nz6uIo80yejRXzlHlAbaOIAsIKGooIKGVLC1MXqaMbKiwXd9vny
         pjdxcCaxZNFLL/BovosVNqNLSZBSFDjQ6rbpbgDNqatYbOoK1e+IVVFLO7VDQcQFsaOp
         agIi+ux9jzZvQ719aSiQ2UeHebcjVBBlFPldnFh0TcSK0IDIe4xlrJ29SgbImr1s7kIl
         V0w9LWztXa6caAFxIMRMUk6NqhT07aYRYF/mul9LgBfthHVVHcfqJe5MqSdn4krhUVwX
         OpwZ893mRVsWCEvHYgT6GWLsbHdGV+OkjPIatymPrdIf2IgmImwa30ZsH6d3jw/WyU2A
         K8HA==
X-Gm-Message-State: AOJu0Yz7unoJjfm3S/WQ+eKWnTEfMKNJqE4DIPKng01xRLP8ItF9JJOs
	5nC2BN7m3fEFZVENQlaZbrq6bp0NQd4Jh60CQCfi2IJKULqRIoUEoEqzA/zJboVCls1PDzjSVzc
	I
X-Google-Smtp-Source: AGHT+IEq6lIYZTZa9N937KNxNgQIAjgijtI+mp2gJfiVuu5G4Ga5eJLPgepamkGeTZm21btyOYo5EQ==
X-Received: by 2002:a92:cf42:0:b0:368:a917:168f with SMTP id c2-20020a92cf42000000b00368a917168fmr14670559ilr.3.1712151664036;
        Wed, 03 Apr 2024 06:41:04 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c10-20020a92cf4a000000b003689833dae7sm3675015ilr.87.2024.04.03.06.41.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Apr 2024 06:41:03 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------llwNpWWOSZuV7waqr0R98LWR"
Message-ID: <7a264064-8542-4b3c-931d-82b0af002bd1@kernel.dk>
Date: Wed, 3 Apr 2024 07:41:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: registering files returns -EBADF in 5.10.214
Content-Language: en-US
To: Kornilios Kourtis <kkourt@kkourt.io>
Cc: io-uring@vger.kernel.org
References: <Zg1aVQVgBO3Rw0_4@tinh.kkourt.io>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Zg1aVQVgBO3Rw0_4@tinh.kkourt.io>

This is a multi-part message in MIME format.
--------------llwNpWWOSZuV7waqr0R98LWR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/3/24 7:32 AM, Kornilios Kourtis wrote:
> Hi,
> 
> In 5.10.214, registering files seems to return -EBADF
> 
> Running the file-register test from (latest) liburing:
> 
>  liburing/test# uname -r
>  5.10.214
>  liburing/test# ./file-register.t
>  test_basic: register -9
>  test_basic failed
> 
> The test seems to work in 5.10.211:
> 
>  liburing/test# uname -r
>  5.10.211
>  liburing/test# ./file-register.t
>  file alloc ranges are not supported, skip

I sent in patches for this for stable, it was (unfortunately)
an error introduced by a backport. FWIW, here's the 5.10-stable
patch that I sent in.

-- 
Jens Axboe


--------------llwNpWWOSZuV7waqr0R98LWR
Content-Type: text/x-patch; charset=UTF-8;
 name="5.10-0001-io_uring-ensure-0-is-returned-on-file-registration-s.patch"
Content-Disposition: attachment;
 filename*0="5.10-0001-io_uring-ensure-0-is-returned-on-file-registration";
 filename*1="-s.patch"
Content-Transfer-Encoding: base64

RnJvbSBhOGMyMjkyMWEwOGE4ZDUwYjEwZmM4MzZjZmY0MzQ4ZDVkZGUxN2UyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFR1ZSwgMiBBcHIgMjAyNCAwODoyODowNCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIGlv
X3VyaW5nOiBlbnN1cmUgJzAnIGlzIHJldHVybmVkIG9uIGZpbGUgcmVnaXN0cmF0aW9uIHN1
Y2Nlc3MKCkEgcHJldmlvdXMgYmFja3BvcnQgbWlzdGFrZW5seSByZW1vdmVkIGNvZGUgdGhh
dCBjbGVhcmVkICdyZXQnIHRvIHplcm8sCmFzIHRoZSBTQ00gbG9nZ2luZyB3YXMgcGVyZm9y
bWVkLiBGaXggdXAgdGhlIHJldHVybiB2YWx1ZSBzbyB3ZSBkb24ndApyZXR1cm4gYW4gZXJy
YW50IGVycm9yIG9uIGZpeGVkIGZpbGUgcmVnaXN0cmF0aW9uLgoKRml4ZXM6IGE2NzcxZjM0
M2FmOSAoImlvX3VyaW5nOiBkcm9wIGFueSBjb2RlIHJlbGF0ZWQgdG8gU0NNX1JJR0hUUyIp
ClNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0tCiBpb191
cmluZy9pb191cmluZy5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvaW9fdXJpbmcuYyBiL2lv
X3VyaW5nL2lvX3VyaW5nLmMKaW5kZXggZmM2MDM5NmM5MDM5Li45M2Y5ZWNlZGM1OWYgMTAw
NjQ0Ci0tLSBhL2lvX3VyaW5nL2lvX3VyaW5nLmMKKysrIGIvaW9fdXJpbmcvaW9fdXJpbmcu
YwpAQCAtODI0Nyw3ICs4MjQ3LDcgQEAgc3RhdGljIGludCBpb19zcWVfZmlsZXNfcmVnaXN0
ZXIoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsIHZvaWQgX191c2VyICphcmcsCiAJfQogCiAJ
aW9fcnNyY19ub2RlX3N3aXRjaChjdHgsIE5VTEwpOwotCXJldHVybiByZXQ7CisJcmV0dXJu
IDA7CiBvdXRfZnB1dDoKIAlmb3IgKGkgPSAwOyBpIDwgY3R4LT5ucl91c2VyX2ZpbGVzOyBp
KyspIHsKIAkJZmlsZSA9IGlvX2ZpbGVfZnJvbV9pbmRleChjdHgsIGkpOwotLSAKMi40My4w
Cgo=

--------------llwNpWWOSZuV7waqr0R98LWR--

