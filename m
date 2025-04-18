Return-Path: <io-uring+bounces-7539-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB7A7A934FB
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 10:58:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43EF13B9427
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 08:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C7F7204C0D;
	Fri, 18 Apr 2025 08:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yourcmc.ru header.i=@yourcmc.ru header.b="SfFyU0gS"
X-Original-To: io-uring@vger.kernel.org
Received: from yourcmc.ru (yourcmc.ru [195.209.40.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE14926F471
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 08:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.209.40.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744966703; cv=none; b=dPk4EY3+mxgtlQ5zX32fJa3wwYV6MtKPaJZtV9MkREGydggkoTxbIHooqfFWRNoZYF+uxOBOWWxJ0YH78I/EXm4S/Kdf+lufrwRKnUkLqcT9/4DFdyjZLJgNNtcipwGV23x+cqur1CEKNG6Uv6XOo+JfzuKaYFb3BlhD/GqchJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744966703; c=relaxed/simple;
	bh=vR8ARt3DNC02HZd9OsvVWaHKqpqI2ugl455So3XBcrM=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:
	 In-Reply-To:References; b=Rj1D9v0Z441yQ3Vlu6VQ4KP7BZATuJApEblWi1w3tsP/cLMNB4WKYtxmMWhPMi+7KahjEUMrEbpeCBD0BkTl6jh1fO4pCtRBoukpTzn7pbgzCLTYYbPCwSq8vC1Ctl64HzEEmnXUWW4ZxwgP2giaC9pee9yWvBBAsAolsFDhULM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yourcmc.ru; spf=pass smtp.mailfrom=yourcmc.ru; dkim=pass (2048-bit key) header.d=yourcmc.ru header.i=@yourcmc.ru header.b=SfFyU0gS; arc=none smtp.client-ip=195.209.40.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yourcmc.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yourcmc.ru
Received: from yourcmc.ru (localhost [127.0.0.1])
	by yourcmc.ru (Postfix) with ESMTP id 4EFB1FE0665;
	Fri, 18 Apr 2025 11:50:45 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yourcmc.ru; s=mail;
	t=1744966245; bh=oGKe39iEzoKzfpGq9JGPSO5HrGTsk6Yd0jPUEEteKvk=;
	h=Date:From:Subject:To:In-Reply-To:References;
	b=SfFyU0gSPvkJL62fdj3M4SomAPiOueiyxHETRhvpB9gHJS5kJI8Q6S8goDE1YOH37
	 bElgc/zwainXvCXP4w1i6DGw3mZFdlr7ncXQOEV6LXUw0tf0Eqx5udyMIlxr4jRoB9
	 uSGMstDuokFUlW1IJHhrgK3xUen9Q+4KKjVq8xyUwsDk+g3LH2ylRRjmAmO4CfJ0Or
	 FwpUbbL02lITBbkp/dA+lijtOCOzgUANycf+vviz+bXCSAGPFNfWchAgZvGHKnAObd
	 AahVpjOf/2j9cKQ5/LdB4gVambPtDkxgrQFKNTO5VAzuxd/J2wOCxNsJfPAMyU1lkm
	 B5EWqg224+Lgw==
Received: from rainloop.yourcmc.ru (yourcmc.ru [195.209.40.11])
	by yourcmc.ru (Postfix) with ESMTPSA id 248AAFE065F;
	Fri, 18 Apr 2025 11:50:45 +0300 (MSK)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 18 Apr 2025 08:50:45 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: RainLoop/1.14.0
From: vitalif@yourcmc.ru
Message-ID: <2ca2145ee741969708e399573af269e9@yourcmc.ru>
Subject: Re: io_uring zero-copy send test results
To: "Pavel Begunkov" <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <c20c9c4c-19c4-47fe-b9d7-b4e8dde766bc@gmail.com>
References: <c20c9c4c-19c4-47fe-b9d7-b4e8dde766bc@gmail.com>
 <d7a31a1e-87bd-4a3b-abbb-f1e26b2a03f8@gmail.com>
 <5ce812ab-29a6-4132-a067-27ea27895940@gmail.com>
 <f1600745ba7b328019558611c1ad7684@yourcmc.ru>
 <f7e03e2c113fbbf45a4910538a9528ef@yourcmc.ru>
 <61b6b1d6cffae4344254ddaef9be6621@yourcmc.ru>
X-Virus-Scanned: ClamAV using ClamSMTP

Hi,=0A=0A> Nice! Is ~2400 MB/s a hardware bottleneck? Seems like the t-pu=
t=0A> converges to that, while I'd expect the gap to widen as we increase=
=0A> the size to 64K.=0A=0AI'm not sure, it doesn't seem so, these server=
s are connected with a 2x100G bonded connection. Iperf -P8 (8 threads) sh=
ows 100 Gbit/s...=0A=0A>> Didn't have time to repeat tests with perf on t=
hose servers yet, but I can check dmesg logs. In the=0A>> default iommu m=
ode, /sys/class/iommu is empty and dmesg includes the following lines:=0A=
>> DMAR-IR: IOAPIC id 8 under DRHD base 0x9b7fc000 IOMMU 9=0A>> iommu: De=
fault domain type: Translated=0A>> iommu: DMA domain TLB invalidation pol=
icy: lazy mode=0A>> With iommu=3Dpt, dmesg has:=0A>> DMAR-IR: IOAPIC id 8=
 under DRHD base 0x9b7fc000 IOMMU 9=0A>> iommu: Default domain type: Pass=
through (set via kernel command line)=0A=0AYou're probably right, it was =
just a random mistake, I repeated the test again with iommu=3Dpt and with=
out it and the new results are very close to each other, and iommu=3Dpt r=
esult is even slightly better. So never mind :)=0A=0AXeon Gold 6342 + Mel=
lanox ConnectX-6 Dx + iommu=3Dpt, run 2=0A=0A           4096  8192  10000=
  12000  16384  32768  65435=0Azc MB/s    2681  2947  2927   2935   2949 =
  2947   2945=0Azc CPU     99%   66%   41%    48%    22%    13%    11%=0A=
send MB/s  2950  2951  2950   2950   2949   2950   2949=0Asend CPU   48% =
  35%   31%    34%    28%    29%    25%=0A=0AXeon Gold 6342 + Mellanox Co=
nnectX-6 Dx, run 2=0A=0A           4096  8192  10000  12000  16384  32768=
  65435=0Azc MB/s    2262  2948  2925   2935   2946   2947   2947=0Azc CP=
U     99%   52%   60%    44%    24%    17%    17%=0Asend MB/s  2950  2949=
  2950   2950   2950   2950   2950=0Asend CPU   48%   38%   36%    31%   =
 33%    26%    29%

