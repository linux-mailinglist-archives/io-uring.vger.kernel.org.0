Return-Path: <io-uring+bounces-400-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9310E82C50C
	for <lists+io-uring@lfdr.de>; Fri, 12 Jan 2024 18:51:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB8F61C222A8
	for <lists+io-uring@lfdr.de>; Fri, 12 Jan 2024 17:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B5817C9C;
	Fri, 12 Jan 2024 17:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="YAvDRzxI"
X-Original-To: io-uring@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCAB17C99;
	Fri, 12 Jan 2024 17:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1705081858; x=1705686658; i=markus.elfring@web.de;
	bh=ZjEmEmsPZxrAp12IMXsv5k05OktOyFPUP9WKYnFtK/s=;
	h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:
	 In-Reply-To;
	b=YAvDRzxIlyJw9yRpUcTBDG0iKWbbWOjsU74vxTdZXt013M17g7jvhf7qcxRufKha
	 13/uL3VproPWkXVAFnBmr1313FTvWLWP+q0ll6yU0+UAuOX9Bb3zaUF8BUxWP1yiA
	 j8S1bEUjhyE5v+S5z7BNwjTPkbn+cuZdUPeONiR1eMCkr3JQPy7pfDJMGVMfvle17
	 V0PHbM+ZkgK74E9ifiYmHo8+9kYojsdv2OUS4vKzYls61Hzn16vFVVENoc9byBsOM
	 LhpdggBYpVzSHCn7G7+cWg/zKPUsk9vXJh93t2dJIYBoE1srvPzxf7p3LXVObbsdd
	 llHT8lKneql8YolW/w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.91.95]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MKuKH-1ritNH0TzJ-00LHIB; Fri, 12
 Jan 2024 18:50:58 +0100
Message-ID: <e758768c-cc34-410a-8d50-f97d778f3da5@web.de>
Date: Fri, 12 Jan 2024 18:50:57 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 1/2] io_uring: Delete a redundant kfree() call in
 io_ring_ctx_alloc()
Content-Language: en-GB
To: Gabriel Krisman Bertazi <krisman@suse.de>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
References: <6cbcf640-55e5-2f11-4a09-716fe681c0d2@web.de>
 <aa867594-e79d-6d08-a08e-8c9e952b4724@web.de>
 <878r4xnn52.fsf@mailhost.krisman.be>
 <b9c9ba9f-459e-40b5-ae4b-703dcc03871d@web.de>
 <edeafe29-2ab1-4e87-853c-912b4da06ad5@web.de>
 <87jzoek4r7.fsf@mailhost.krisman.be>
 <c17648db-469c-4d3c-8c2e-774b88e79f07@kernel.dk>
 <87bk9qjwvw.fsf@mailhost.krisman.be>
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <87bk9qjwvw.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:3v1MaII0cqKyD/JWyeLGO6xs6ULypvEtYPfLSCKlrBO6cSZ7ZUx
 wl5xm4s+hoeHXM8IjKkesVTU6TqUwlKtSY3oLOz2c0yT0LCapj4fdlLambtp+ezDtk/QGWn
 7Tp0jWlSgyQWI5WvSU2M9vV2Vl3PM6JNMc3CfcY06einDIwsczFkj5unSm6yygkpusYGFcL
 NzDTea8X9LhnLQdTI2f2A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:L3N3YXw2A/U=;clyOfieu4fdDy/vqK0tIbDwZjI9
 derjOvEws0zheIoC1MwvNs4UPv/SGrLwJG+Q7B1bNR5KrAWnkJ/E7GPOW2nBI+rJi0AHu80IM
 2rvYJDyDB8VrUxj3pDJwhFrEAo1vMrg9llNESfmI9/NA7cJ4yJC1FHasjN6TBI77JeS6RrOhG
 H/Ybpfz4/9RXR/dJwjCvjTBNCkHuyI/I2vi5z4HZ5C1vI2X/6h7Oe6oqDfuN6tlCumTSDonG7
 d8fRWzd05oWyV36IOBYRCoDelw0w3dZ0vZMLumf7mOORe42+nZ0CRb360ESkoQH7GOKnSRSwE
 /Whe1J2Ml/mKhrjK1PwQmMNOTPPySc4mHMf5V87+Gckk8v4pwm7EGke12CHVWOi3sFT99NTGb
 LDuouNZ6UrsOF9gxNK3yNpWFIAbb201kNbu+TxNe5rTKeakr3y1OwqX05oDsd4p6wvQza1xt4
 zWxkxCTNfTg85jNQGy0maypj1L7w0h/nWQMr5XjpUnI3RS8JuHQH386iF69Ze3b61k3JydFrZ
 BI90sgPYsh+G5Nfs7BKAf3lGL8FCczMa+O9iA/jC6kA5ZXf9Gjf50ZhB7jFzFWtUqGNJY+uhE
 nQeVdAEsPwpNKQiny+Jl+DqnfPRwb9O9vnn7lciogeE75U1+blOdvl51sgUcLRNbNVnhscpF3
 D1ipZqtWH5j1W1pDPv+TnqVzNH/fN1e2k+kT/11kTF9uhaedi+wbdhKPN5Mg73Y0nlnc6URqg
 V+hsBIJQy1rHr+xEjDyNe2oLB6P4ayDcT378wDm+F5nLXV4Lu88CGVxPbTutFtUvaQ7UMFXrD
 uciRw9Pm07yFrGr+bIFz+TNJQ+9iCPU2CUW/73in34ykyuUTf2kgkdNZBHMV0VyD/CnMfDh1E
 xZt/4C0KNEYn9G9S1USuhf8FQkQDYHGaYOGFS487SXeUY/HVhIiD/2+BHJxG4cKoywIhcj8Pv
 uSHv5A==

> patch 2 is just garbage.

Such a view can eventually be reconsidered if the support would ever grow
also for the application of additional labels.
https://wiki.sei.cmu.edu/confluence/display/c/MEM12-C.+Consider+using+a+goto+chain+when+leaving+a+function+on+error+when+using+and+releasing+resources


> Clearly there is background with this author that I wasn't aware, and
> just based on his responses, I can see your point. So I apologize for
> giving him space to continue the spamming.

The change reluctance can be adapted according to the spectrum of
presented source code adjustment possibilities, can't it?

Regards,
Markus

