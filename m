Return-Path: <io-uring+bounces-7419-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C24A4A7CBE7
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 23:46:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 742E63B1E4D
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 21:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B6E165EFC;
	Sat,  5 Apr 2025 21:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yourcmc.ru header.i=@yourcmc.ru header.b="btvNi4ZY"
X-Original-To: io-uring@vger.kernel.org
Received: from yourcmc.ru (yourcmc.ru [195.209.40.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F656145FE8
	for <io-uring@vger.kernel.org>; Sat,  5 Apr 2025 21:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.209.40.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743889582; cv=none; b=iIUrSFQ7YUE6Qsvxb9q+mqpdALj7xu/9bzULN7VlB8N1HfzkibjCzCSTdlw/4aYxT/TMBf8E4MoqOV+5KT/s9KyaiNKV5RpZtN0UAq91lQ5apRSfF2MMaq+mXPOaarjdsnAKkTcqV6aeym4MIEH6JoMs5jzj3IVntpeGfIwbzBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743889582; c=relaxed/simple;
	bh=LE8rV3dNCIuxXJJzBwhqyvRxSHArYtKB2mP4OB+rzDc=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:
	 In-Reply-To:References; b=WLzkNI30qJxTPT+VTqepVeRdlKu82hQblLnjpTedlVeF2oaoz35iHnr1aWtXE/3gRVBFHlpA72CGie5aw2zwpU9tyH+Ce5IgkQVHcVFnclzMQH1dBskk2rFCcrE7zv6tpg1QgjSr1EcO9J6obzy0cCUowddkOIjEX9h/V7oirg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yourcmc.ru; spf=pass smtp.mailfrom=yourcmc.ru; dkim=pass (2048-bit key) header.d=yourcmc.ru header.i=@yourcmc.ru header.b=btvNi4ZY; arc=none smtp.client-ip=195.209.40.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yourcmc.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yourcmc.ru
Received: from yourcmc.ru (localhost [127.0.0.1])
	by yourcmc.ru (Postfix) with ESMTP id 933ACFE0665;
	Sun,  6 Apr 2025 00:46:13 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yourcmc.ru; s=mail;
	t=1743889573; bh=LE8rV3dNCIuxXJJzBwhqyvRxSHArYtKB2mP4OB+rzDc=;
	h=Date:From:Subject:To:In-Reply-To:References;
	b=btvNi4ZY2gGSwYawcPQj9u9fqk2Cw9jPG5NqtjlbTs+w2k/wvHooaCLhl3OT1Pjdn
	 fXTQ8Ui1nRTfHSw/gL8oCumCTHKKT2QIIscaCU0MFItzEKkP6ErPaDnDNH5UIbjGXT
	 troLZdYEcMZBizn7MiH/5U8XHpxNmkR+hWQXVCbgjHvQ8RUUvSWu916ROuQQ2ubCKC
	 FRbjmvfeebREH6zDJzXuE4oUfn4V0uVKiHPspzCdEhyTauzH5okdIPznXe+LbrJ+EV
	 tVkGSkSeQEkJ8A8jEjmrSartK2XoMeGu/US/LVWJAmNGvX5GafUME+wnRSqEUy9mYn
	 xEhB6yH67P8dQ==
Received: from rainloop.yourcmc.ru (yourcmc.ru [195.209.40.11])
	by yourcmc.ru (Postfix) with ESMTPSA id 69687FE065F;
	Sun,  6 Apr 2025 00:46:13 +0300 (MSK)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 05 Apr 2025 21:46:13 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: RainLoop/1.14.0
From: vitalif@yourcmc.ru
Message-ID: <37b5fd439fc2af5b3d8ffb0bd0c8277d@yourcmc.ru>
Subject: Re: io_uring zero-copy send test results
To: "Pavel Begunkov" <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <5ce812ab-29a6-4132-a067-27ea27895940@gmail.com>
References: <5ce812ab-29a6-4132-a067-27ea27895940@gmail.com>
 <f1600745ba7b328019558611c1ad7684@yourcmc.ru>
X-Virus-Scanned: ClamAV using ClamSMTP

> fwiw, -z1 -b1 is the default, i.e. zc and fixed buffers=0A=0AYes, I kno=
w. :-) that's why I re-ran tests with -b 0 the second time.=0A=0A> Sounds=
 like another case of iommu being painfully slow. The difference=0A> is t=
hat while copying normal sends coalesce data into nice big contig=0A> buf=
fers, but zerocopy has to deal with whatever pages it's given. That's=0A>=
 32KB vs 4KB, and the worst case scenario you get 8x more frags (and skbs=
)=0A> and 8x iommu mappings for zerocopy.=0A=0AProblem is that on EPYC it=
's slow even with 64k buffers. Being slow is rather expectable with 4k bu=
ffers, but 64k...=0A=0A> Try huge pages and see if it helps, it's -l1 in =
the benchmark. I can=0A> also take a look at adding pre-mapped buffers ag=
ain.=0A> =0A> Perf profiles would also be useful to have if you can grab =
and post=0A> them.=0A=0AI.e. flamegraphs?

