Return-Path: <io-uring+bounces-506-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3839D8445FA
	for <lists+io-uring@lfdr.de>; Wed, 31 Jan 2024 18:22:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 970DB1F2CE68
	for <lists+io-uring@lfdr.de>; Wed, 31 Jan 2024 17:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE3DB12C522;
	Wed, 31 Jan 2024 17:22:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE72B12BF33;
	Wed, 31 Jan 2024 17:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706721745; cv=none; b=k5mc0DysuB8NYjLAeT2HZ0Jw0tVAHX6nCYFRR5GCXqwOYXO4oKSANLEnu6NBZZbZHnY+GNDfP1huoL0xsdiiY7DKlmqiAOk1yXTKr6T3lBIp0OG85B/ZGhN0wgElKjo0nDY/7iEfoHXt+Mmg2R0LWEYRGyHLE6KrqNTRLR0PF24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706721745; c=relaxed/simple;
	bh=AqXzwWxtpW91OYMl9mYz2nM7D1KFNJ/VMZ2r0CPGc3A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E/fWeQ89c5uDBbcsYYubN8i5j0X0TW+5JPmu16j4VD4XCalbY3a8TZPFuG2ZH1Ipn9K0qjtexTWMmT6gp5GfFbtnqt9Ru45ubcHeBXrMC0e2OtR7SdoxTvcZ1Cb1GlF1NjPoqpkLTBPjBWR3Z/JJUuRtX7ZzC02IbqsTj6+hTo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=57076 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1rVEI1-00029Z-0a;
	Wed, 31 Jan 2024 12:22:21 -0500
Message-ID: <45a21ffe4878d77acba01ec43005c80a83f0e31a.camel@trillion01.com>
Subject: Re: [PATCH v15 0/7] io_uring: add napi busy polling support
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Stefan Roesch <shr@devkernel.io>, 
	io-uring@vger.kernel.org, kernel-team@fb.com
Cc: ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org
Date: Wed, 31 Jan 2024 12:22:20 -0500
In-Reply-To: <2b238cec-ab1b-4160-8fb0-ad199e1d0306@kernel.dk>
References: <20230608163839.2891748-1-shr@devkernel.io>
	 <58bde897e724efd7771229734d8ad2fb58b3ca48.camel@trillion01.com>
	 <2b238cec-ab1b-4160-8fb0-ad199e1d0306@kernel.dk>
Autocrypt: addr=olivier@trillion01.com; prefer-encrypt=mutual;
 keydata=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
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On Tue, 2024-01-30 at 15:59 -0700, Jens Axboe wrote:
> On 1/30/24 2:20 PM, Olivier Langlois wrote:
> > Hi,
> >=20
> > I was wondering what did happen to this patch submission...
> >=20
> > It seems like Stefan did put a lot of effort in addressing every
> > reported issue for several weeks/months...
> >=20
> > and then nothing... as if this patch has never been reviewed by
> > anyone...
> >=20
> > has it been decided to not integrate NAPI busy looping in io_uring
> > privately finally?
>=20
> It's really just waiting for testing, I want to ensure it's working
> as
> we want it to before committing. But the production bits I wanted to
> test on have been dragging out, hence I have not made any moves
> towards
> merging this for upstream just yet.
>=20
> FWIW, I have been maintaining the patchset, you can find the current
> series here:
>=20
> https://git.kernel.dk/cgit/linux/log/?h=3Dio_uring-napi
>=20

test setup:
-----------
- kernel 6.7.2 with Jens patchset applied (It did almost work as-is
except for modifs in io_uring/register.c that was in
io_uring/io_uring.c in 6.7.2)
- liburing 2.5 patched with Stefan patch after having carefully make
sure that IORING_REGISTER_NAPI,IORING_UNREGISTER_NAPI values match the
ones found in the kernel. (It was originally 26,27 and it is now 27,28)
- 3 threads each having their own private io_uring ring.

thread 1:
- use SQ_POLL kernel thread
- reads data stream from 15-20 TCP connections
- enable NAPI busy polling by calling io_uring_register_napi()

[2024-01-31 08:59:55] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 3(fd 43), napi_id:31
[2024-01-31 08:59:55] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 8(fd 38), napi_id:30
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 10(fd 36), napi_id:25
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 14(fd 32), napi_id:25
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 12(fd 34), napi_id:28
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 2(fd 44), napi_id:31
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 16(fd 30), napi_id:31
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 9(fd 37), napi_id:31
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 20(fd 26), napi_id:31
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 1(fd 45), napi_id:30
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 6(fd 40), napi_id:28
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 13(fd 33), napi_id:25
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 22(fd 22), napi_id:25
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 7(fd 39), napi_id:30
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 18(fd 28), napi_id:28
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 19(fd 27), napi_id:25
[2024-01-31 08:59:56] INFO WSBASE/client_established 1028
LWS_CALLBACK_CLIENT_ESTABLISHED client 23(fd 21), napi_id:31
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 4(fd 42), napi_id:31
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 5(fd 41), napi_id:25
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 21(fd 24), napi_id:31
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 17(fd 29), napi_id:30
[2024-01-31 08:59:56] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 15(fd 31), napi_id:28
[2024-01-31 08:59:57] INFO WSBASE/client_established 1010
LWS_CALLBACK_CLIENT_ESTABLISHED client 11(fd 35), napi_id:30
[2024-01-31 09:00:14] INFO WSBASE/client_established 1031
LWS_CALLBACK_CLIENT_ESTABLISHED client 24(fd 25), napi_id:30

thread 2:
- No SQ_POLL
- reads data stream from 1 TCP socket
- enable NAPI busy polling by calling io_uring_register_napi()

[2024-01-31 09:01:45] INFO WSBASE/client_established 1031
LWS_CALLBACK_CLIENT_ESTABLISHED client 25(fd 23), napi_id:31

thread 3:
- No SQ_POLL
- No NAPI busy polling
- read data stream from 1 TCP socket

Outcome:
--------

I did not measure latency to make sure that NAPI polling was effective
but I did ensure the stability of running the patchset by letting the
program run for 5+ hours non stop without experiencing any glitches

Tested-by: Olivier Langlois <olivier@trillion01.com>


