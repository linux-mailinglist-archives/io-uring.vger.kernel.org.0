Return-Path: <io-uring+bounces-386-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A490682A2CA
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 21:50:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B2F81F27D7E
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 20:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1724F8A3;
	Wed, 10 Jan 2024 20:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Ev9PNgg7"
X-Original-To: io-uring@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA5B4A9B7;
	Wed, 10 Jan 2024 20:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1704919546; x=1705524346; i=markus.elfring@web.de;
	bh=67WEwzv+/9tUhnVAYMobcuh+1b1uiqYL9AGknTMPv1A=;
	h=X-UI-Sender-Class:Date:Subject:To:References:Cc:From:
	 In-Reply-To;
	b=Ev9PNgg7hVDL0F9Oa3DaRBUPbf5jji5UsoqQsmCIxDAoWLKV+buo10XZENviw+Rz
	 2Z1mHQ82fDVhW5JzkkRmIV/XC+O9oaCzPEY2yblfNVUaC87XRmSDEMd4qLsTgNy/l
	 OtfwwLY9tVOtdwBp+xe/8ZR/zkZWzutJbGQRP61y9EUhsJSMzcCb1QWfheX1JzwQ4
	 apSbxelcr+VH+bitCSYncBOXxn7HLyC0InD63/cI52UdUaxhg3I7ymdP9Gaj+vMjB
	 HK5W02EMgHPbRfIRHfUHk5oSBFML6oKhh+n3s48a6ShjcWXmgLsyu3bXU+Jb/18zy
	 ymRJ4kyBuLL4eZt+KA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.86.95]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Mv3Yg-1r6H3y0ULo-00quwH; Wed, 10
 Jan 2024 21:45:46 +0100
Message-ID: <b9c9ba9f-459e-40b5-ae4b-703dcc03871d@web.de>
Date: Wed, 10 Jan 2024 21:45:43 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2 0/2] io_uring: Adjustments for io_ring_ctx_alloc()
Content-Language: en-GB
To: io-uring@vger.kernel.org, kernel-janitors@vger.kernel.org,
 Gabriel Krisman Bertazi <krisman@suse.de>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>
References: <6cbcf640-55e5-2f11-4a09-716fe681c0d2@web.de>
 <aa867594-e79d-6d08-a08e-8c9e952b4724@web.de>
 <878r4xnn52.fsf@mailhost.krisman.be>
Cc: LKML <linux-kernel@vger.kernel.org>
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <878r4xnn52.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:w8zbiVzV4QX6nYncQcpShWT/W2voPMe5P7Wq/18FEP1aLfUlsa5
 1W+heqqaOSv74iqsgtIBdLhT/DdXeZAxqKoOD0X3a2c5E497HBDVFPW0RVFrBuuzf/ZsnD0
 8Fs9cY/Mj3+3u+5tqUHp+VCvEJNavPjNeH0V9KlXDBm/uH8wBkgVLQHUdCCnLnDE7CL8Irn
 wkImzt5GMc7bRj95dOH7A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:nV+jhf8rftA=;6GXpVx/Fu86nZGOIj5tOyFTGS4O
 6u0lKWKNN/hmEpEIjnQig+hiRmFkUTCqLY79NJlOHWMfLbo8ZnOoZ8TWH8l+13tjwbCTzw+fI
 BKYwWbpjmDYrf/DjA33PfSJn4Ig1T/kCLuDNncgK6L06Enc4jQOw+yNhOEAU35V7x04AYYvZ1
 ui13KNAId8kHEwDXYVxIqMcIXwC6WUMQPadKx61koFyFhndx7mFKk6931MrtSW8vg4kEjY43Q
 J6INj7BwMYt5E8ZNqN5qDid/Lz0LkPqgLdNEhT1DB8UBM10XrvWXwAu0FW3SebAT0vZk4Lz94
 ThuYLg//OKYTCspUGlbIgDN/OVIGgm8FD+bi6YLvIcD8iB6vcWjK/ToWSLcBRaOK26CrdnKaa
 p2kHjtXtmofvvUqMFPS/q1RQlTobH/UD6aKOLoqdAU4JTEkJxHagzBu7eyJV3d6RUkcK0hohO
 hL7fzO3yXIkX44uURC5aOMOJgQb7/T4DSc1T8yaqTgGyNw1nC/8c90Yp1g/HsPfjJ0zEmfR4x
 kiEjppZ1POBDGx231TI9ta4id5RXrCeWDZT3u4Iyj1TxxmuX8us1tUMoRZ+aVAhHMp0YF9T45
 33NtrjCh+/702vsJQjlG03iL+mAftr4N3q8oudAEMMYQ0XcAghHJSoPOz9iQzI1q9D1SqGu6r
 J4MxxV8BLNRMKm3Wxelbr96X2zmLLlYGr/WknS40Ll6blupo8rU9IqWimSe4A8ufudbiSdWfd
 ZmHhOxV/OlU077ewx6RwgT0f8z/0+ahHTyZ7qscUvEX2OxcsdzuFArcRu0woXRoBIsGGJFWnj
 brGKGOmVk4iRD0QMu9muE9IvZEV9iSwEEa7kvE5GhAW/mU5aEbqi169Za703zn7aCIs0OihNy
 zftqUsulIBu2L8xGqSaf2Zld/mJSMlwewGqiHG1r7kY5MYkQ5lLHoxjSc2tluVSDW2J8xcXip
 bdgxbrk5oLPd157aUxmWo5M93es=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 10 Jan 2024 21:38:12 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete a redundant kfree() call
  Improve exception handling

 io_uring/io_uring.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

=2D-
2.43.0


