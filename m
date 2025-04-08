Return-Path: <io-uring+bounces-7432-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 548CAA809F2
	for <lists+io-uring@lfdr.de>; Tue,  8 Apr 2025 14:59:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5298C4C6C57
	for <lists+io-uring@lfdr.de>; Tue,  8 Apr 2025 12:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198AE269AE4;
	Tue,  8 Apr 2025 12:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yourcmc.ru header.i=@yourcmc.ru header.b="fbFPQvGo"
X-Original-To: io-uring@vger.kernel.org
Received: from yourcmc.ru (yourcmc.ru [195.209.40.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A353269823
	for <io-uring@vger.kernel.org>; Tue,  8 Apr 2025 12:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.209.40.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116210; cv=none; b=ZLlGwKU+HQe0bOM7KdhgLjAV4P+PkL4jrsTiTa33Z5LtaaLnYKyXCfgn+kO8NZGhiHmV47XgZKUHW8voPYeSRI3HCA7Oa+ZgkiWUj3cYrXLrT65rYDAXxRUMyHWBhdCF0cT31XxZyWVvHZeuf3IZQHBV3sHUdH8FIKvH9oHtMhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116210; c=relaxed/simple;
	bh=AYeTwKiofssUbed/G9VMxPpLD5FWMzOZlazbpXvmpUQ=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:
	 In-Reply-To:References; b=BSaad42w6G8jxtdlD8sArhNAtn7AUmY2vMREkQ/rWMf08RO9PbeheQOXILMnBvnigflcyh11lHZyhOTaDLut8QAuSbE1l+SUV72PC85zZn6vVB5aCm0bqRAv9qrVInfQX6L04dc5FjpnNxz5IiCf3Q/ZFv7EMdHDqjdoAPpk5e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yourcmc.ru; spf=pass smtp.mailfrom=yourcmc.ru; dkim=pass (2048-bit key) header.d=yourcmc.ru header.i=@yourcmc.ru header.b=fbFPQvGo; arc=none smtp.client-ip=195.209.40.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yourcmc.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yourcmc.ru
Received: from yourcmc.ru (localhost [127.0.0.1])
	by yourcmc.ru (Postfix) with ESMTP id 0B9D9FE0667;
	Tue,  8 Apr 2025 15:43:17 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yourcmc.ru; s=mail;
	t=1744116197; bh=W/JlKwAahGfNP22k5CLM+oWZkeBwc+dqrVtjKgD0dRU=;
	h=Date:From:Subject:To:In-Reply-To:References;
	b=fbFPQvGoOqf1OBbYsohEl0zjhLleUOi/kcPgdxWkU9bguUqkv87m9VEIK/w4/GUEn
	 4qRJIZSARRH2bAD67DR1+ny3dBEzUTRyXH+8k3H7fpm9vxd8ftEijsq0pDXYrNhtUK
	 WaR4jGUJ9pWM94xxxj+6WVwB18LW0ix+9TDcSi/dy2YBHq+t1XROVjasdZtd4uCDvB
	 +fuqc7pmVprGTxpa0wHBi8NqK2A5IdrKO2YtwhThN+K61xwy4lFa65jUYVKB161M0T
	 P8nnadD+hAkMzKWnkyjrrjXGwnThW1eumI457ELpnAwfyrbuCtv3iSllGs91PdRoWy
	 VMUclQFguweBw==
Received: from rainloop.yourcmc.ru (yourcmc.ru [195.209.40.11])
	by yourcmc.ru (Postfix) with ESMTPSA id DABDFFE065F;
	Tue,  8 Apr 2025 15:43:16 +0300 (MSK)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 08 Apr 2025 12:43:16 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: RainLoop/1.14.0
From: vitalif@yourcmc.ru
Message-ID: <61b6b1d6cffae4344254ddaef9be6621@yourcmc.ru>
Subject: Re: io_uring zero-copy send test results
To: "Pavel Begunkov" <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <d7a31a1e-87bd-4a3b-abbb-f1e26b2a03f8@gmail.com>
References: <d7a31a1e-87bd-4a3b-abbb-f1e26b2a03f8@gmail.com>
 <5ce812ab-29a6-4132-a067-27ea27895940@gmail.com>
 <f1600745ba7b328019558611c1ad7684@yourcmc.ru>
 <f7e03e2c113fbbf45a4910538a9528ef@yourcmc.ru>
X-Virus-Scanned: ClamAV using ClamSMTP

> What kernel version you use? I'm specifically interested whether it has=
:=0A> =0A> 6fe4220912d19 ("io_uring/notif: implement notification stackin=
g")=0A> =0A> That would explain why it's slow even with huge pages.=0A=0A=
It was Linux 6.8.12-4-pve (proxmox), so yeah, it didn't include that comm=
it.=0A=0AWe repeated tests with Linux 6.11 also from proxmox:=0A=0AAMD EP=
YC GENOA 9554 MELLANOX CX-5, iommu=3Dpt, Linux 6.11=0A=0A4096 8192 10000 =
12000 16384 65435=0Azc MB/s 2288 2422 2149 2396 2506 2476=0Azc CPU 90% 67=
% 56% 56% 57% 44%=0Asend MB/s 1685 2033 2389 2343 2281 2415=0Asend CPU 95=
% 87% 49% 48% 62% 38%=0A=0AAMD EPYC GENOA 9554 MELLANOX CX-5, iommu=3Dpt,=
 -l1, Linux 6.11=0A=0A4096 8192 10000 12000 16384 65435=0Azc MB/s 2359 25=
09 2351 2508 2384 2424=0Azc CPU 85% 58% 52% 45% 37% 18%=0Asend MB/s 1503 =
1892 2325 2447 2434 2440=0Asend CPU 99% 96% 50% 49% 57% 37%=0A=0ANow it's=
 nice and quick even without huge pages and even with 4k buffers!=0A=0A> =
That doesn't make sense. Do you see anything odd in the profile?=0A=0ADid=
n't have time to repeat tests with perf on those servers yet, but I can c=
heck dmesg logs. In the default iommu mode, /sys/class/iommu is empty and=
 dmesg includes the following lines:=0A=0ADMAR-IR: IOAPIC id 8 under DRHD=
 base  0x9b7fc000 IOMMU 9=0Aiommu: Default domain type: Translated =0Aiom=
mu: DMA domain TLB invalidation policy: lazy mode =0A=0AWith iommu=3Dpt, =
dmesg has:=0A=0ADMAR-IR: IOAPIC id 8 under DRHD base  0x9b7fc000 IOMMU 9=
=0Aiommu: Default domain type: Passthrough (set via kernel command line)

