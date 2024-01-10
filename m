Return-Path: <io-uring+bounces-377-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 917858298F1
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 12:25:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D306B2713F
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 11:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9AB481DE;
	Wed, 10 Jan 2024 11:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="PUG4aQDL"
X-Original-To: io-uring@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204C9481BA;
	Wed, 10 Jan 2024 11:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1704885827; x=1705490627; i=markus.elfring@web.de;
	bh=S9pBQCz+Xugl78ZljO9c3MQi/tYY/iaK3svNXapNfd8=;
	h=X-UI-Sender-Class:Date:Subject:From:To:Cc:References:
	 In-Reply-To;
	b=PUG4aQDLrkNgnWq5WB7Z5IZ5JZu8vJA4mXsuHI13M4/iFgMXMKNd70iwraeIuU64
	 Nb5jFlUGo4A5YzWYP2nh3K+yTkSIRHb5PljEnH4+Azg+hOtX+laFKk0uraA5tCq+K
	 7It6jHMcuVATNjYYCavXENWUCACKthMOEA2EcUl4euZfr0cgrey6FTAq2fV2nByyY
	 P+BbUk+Fw4j95TfkdUGPjmByRopzvCHtfSW7IyNt5A9GUUI80Dg1OrtUB5DqGPwHU
	 0ONz7nAkXc0LAbcWBAQ6FIXM15fxHknlIPv1BrFaUKIRWtgyKx8Mvfuj9ViTgTqPk
	 w2w7Qo+HVjuxi3w6CA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.86.95]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MFs1t-1rOHmf3hyZ-00HFqo; Wed, 10
 Jan 2024 12:23:46 +0100
Message-ID: <45033ab0-0391-4422-895b-edba845ad226@web.de>
Date: Wed, 10 Jan 2024 12:23:45 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring: Fix exception handling in io_ring_ctx_alloc()
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
To: kernel-janitors@vger.kernel.org, io-uring@vger.kernel.org,
 Hao Xu <howeyxu@tencent.com>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: cocci@inria.fr, LKML <linux-kernel@vger.kernel.org>
References: <6cbcf640-55e5-2f11-4a09-716fe681c0d2@web.de>
 <aa867594-e79d-6d08-a08e-8c9e952b4724@web.de>
In-Reply-To: <aa867594-e79d-6d08-a08e-8c9e952b4724@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5ELaC2EsXYBGmOLrTxwH3QEjU90DDHnUBkMdV1hwkkFSfmCovax
 wGdC8a44VVf2h1Pc6oxjF8q05Rmbg3RQjzKtimYjwbpYfDVxRKDPpdltEjMrodEr1V4gM5i
 THh1OhyVai1699aYIwTgTqZdVjiPrCWGBPsMwigd/cdk4QRjk1PbWGiuBe1HuEvS4ouybZt
 q40lAsmU7F55RKDHRbisg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:SCzyDB61MAM=;whxBAaoTIRjG0CSRcDWjKoz3IfS
 HpnmuUrCLQsi6JVACl+mhx6Zo+R6JFxlhhHaY5+WfgUIKulRCTM/+mbTCHOS3hGuxEBmOiECs
 AE2ds7UFK8W+zjkYaezrJmc7jiOrbaNSuhE4cepUG5Zxyqfv5vizfbp/pV78N7jXqIbSmRegG
 wi9LAuN9yGUon1g56JMlkFRfbp24ojvkOfsjlanbPOLwGvxrVikTyVhtxon8Sxp9M/R893nNU
 8AMThUt6QhTzQjDLyQs/pGkm/JiST9HR39/i3gQ0cRdMo1Q3nkNpfXsUM0/20YTuuMwe5TnLn
 qvUYS68GOBQkf5ixnvRCULtPyTce9Ed3fvaz69JWn/5EToJdgGdZXmjpeAZDoQ9t3TOi8VM8h
 CMz4QAzU9z1glBREilVSHfT+fJsQXkvlXUihJG5Or/ZN7Fqw12Xn47NDyHw1QWDiz4cJXxGuG
 QOxubeGB3derH+fKhcFAVjOAXLLNXkfyTYr6tR8g8hFTgAW4qujlAL5WUIR+V/UlhA9t8WTWv
 CgmGXJjgLxr7NRAFNA9nBA0z+Qzwz3CcnV6t9SjyNeOl/LniawzIIgMx3Nkk8b+tznZxU380z
 DEBu2VAxUFq36vI0O+Vxym+ADMnArxNd8DFapHr4USATe64T0dDsEjkPVITPT6YqGQ2bzXi06
 8PPcZW/hizAQW754/5Oa2AsRDIPEGIV9+7WqOsPDotuQzEG6MQLanWhvXU0jbumWZ2cjL/aJ0
 qtGLVAXT5wuRuAnl0JxgBt/Ci+Kz7hlLo2RzdaLqrw4XkgxkA5kNDBMnaO66AUP8WJBtZEhie
 XHvCxtg7BMEdJYIjZnB21RSGgwxEwXcOjnL8i7nO1JroVQIzTJAE6SapBmAkFYhK2faiENGij
 F2hj5dIx5ayIlW6zwDYYPldnwUy2e+y301oaNTZeVOV4LvSfGZBLfbOSgBGMthr8oMhM6AEqz
 dndrXszsSCxQR4HYYIxA8rESMJQ=

> The label =E2=80=9Cerr=E2=80=9D was used to jump to a kfree() call despi=
te of
> the detail in the implementation of the function =E2=80=9Cio_ring_ctx_al=
loc=E2=80=9D
> that it was determined already that a corresponding variable contained
> a null pointer because of a failed memory allocation.
>
> 1. Thus use more appropriate labels instead.
>
> 2. Reorder jump targets at the end.
>
> 3. Omit the statement =E2=80=9Ckfree(ctx->io_bl);=E2=80=9D.

Is this patch still in review queues?

See also:
https://lore.kernel.org/cocci/aa867594-e79d-6d08-a08e-8c9e952b4724@web.de/
https://sympa.inria.fr/sympa/arc/cocci/2023-03/msg00114.html

Regards,
Markus

