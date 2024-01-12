Return-Path: <io-uring+bounces-397-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1DE82C257
	for <lists+io-uring@lfdr.de>; Fri, 12 Jan 2024 16:00:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B9FC1F2131B
	for <lists+io-uring@lfdr.de>; Fri, 12 Jan 2024 15:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02DE66E2B4;
	Fri, 12 Jan 2024 15:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="ocbJzJk3"
X-Original-To: io-uring@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACCE6DD09;
	Fri, 12 Jan 2024 15:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1705071632; x=1705676432; i=markus.elfring@web.de;
	bh=mZfbtSP2eLg7KULWpeXHehpSY+IdUn5/j3kjnvUcs2I=;
	h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:
	 In-Reply-To;
	b=ocbJzJk3E7Vjj0p1kohA3nFwk/dy8MbzNeqmc5vT8VkFWdJGEJa5IQXTJk6e2l5a
	 PWXo8n7ApYh9dgzwcK6XAu4VXSbXjt55zJbXkIZHudLUM1meXRGdRN5pkZlO2072O
	 /5UQ5uykB0Q8ApIKL9L9H1YWNBlAj44lR9tuZ+oYS0X6LeBQMH7z75+Lx1Dfw+Stm
	 ur3acoNoyc3bQGi1XOBCOE9Qbe3bksHoX9sTrRQGXMzy93WQyHwMpFfYz/bYIp5R6
	 Uepa2vyPvbJT46e1lxpHjlKZ7VdmIcKl9VUVA5MPW1UXkIWOqFsLfLhJ4uXdI+vVP
	 p+qH3iFmSGoHCKr4ZQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.91.95]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N7gXO-1r2wjF43rm-01558N; Fri, 12
 Jan 2024 16:00:32 +0100
Message-ID: <96e1e30a-ae2f-4dfb-9a1c-edaf6b8e1231@web.de>
Date: Fri, 12 Jan 2024 16:00:21 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 2/2] io_uring: Improve exception handling in
 io_ring_ctx_alloc()
To: Gabriel Krisman Bertazi <krisman@suse.de>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
References: <6cbcf640-55e5-2f11-4a09-716fe681c0d2@web.de>
 <aa867594-e79d-6d08-a08e-8c9e952b4724@web.de>
 <878r4xnn52.fsf@mailhost.krisman.be>
 <b9c9ba9f-459e-40b5-ae4b-703dcc03871d@web.de>
 <49ecda98-770d-455e-acd7-12d810280fdd@web.de>
 <87frz2k4jm.fsf@mailhost.krisman.be>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <87frz2k4jm.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3fcZXN079uvfIcjs2xVAhdFEtF5OObN5kLwIPmxpQDsZhhkZULL
 NZ7w4yaCeziYpmKoLQui1CfJKn80IgEQMLQg861wIvzSC7Nb5ZxgYkMYvR6P0D8y9AYyfAB
 kGOfFcJUP/YIIJtJS41hkuL0XRporYyhOx6l8KXpcEYxkoCy/hixa0pqdeNBJeZr4xpl5sV
 pQWGmRAd61sq1upCB9ArQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:CX07fjvmKG8=;djUVypSqjkR9zW5MJaSHacMcJBr
 hzFLPkxRRXiuFx0Jo4+UmKQ59SuzUOobiT8AqAiyEQ9kigZaA9Mb7c1AfdenkzU/Z4KDutFQr
 xPhZ1PUYg2BbFsm6Oz5Ebx8b4CWy+2w2ltSaZYVujiap0WFNQA7LkF/CeGU8+Yqvbri5whvau
 4HrACfbd5ynnK0kXbfgQMwIPLdO4yQo2vOHvAlHtmNeN1thRI8EBVFVHaWDlrA4XEWEZwrbdq
 iTN/PbvVVG5m7la4MatvMjfNS2hJAtl+h3xxX4qgzZxq9zUYLcZPvw5DICEo1CXA8xaAKNDKj
 yHu86QsdJFMBChktzct3RaZ2o5o0j0U3AdaicyuQQbjQR0ILF67qBT6LXvT20DqhBYmJtaJgo
 HkF0z/40yQ3pJSNR2Qx4KwIC65sOzuZtxbtfrvPpuoFKeE3teQjgl3CskUzB8AfJspLD0C8dw
 j1KDydvXZVgSEGI333xrEogt+wUt5iG11BtPbgOwUUSjrj8M/7RAy1OsPAOId6adwi/bVt1B9
 uHc98O42hIGLLFusWrmJZ7lvfFFSbaKFlrX4mtiCnb0zZbP41wQq9FGFBJnMCPK8WYE7rFM51
 +6fvvQVuEfCgBxQ6Z4PA89OPBIWR/KMWLXvQ/yEEXY7csaR913ASvA3x2YB2MT1xMlPt05M44
 Mo2K2NkuUfiPSK07ecKcVf3FoptwHVUzc5lib4WK7q3O+kL+QAy2Fnk23rvp7wsLrzBbbhjHL
 KS66N+JCKoZERCAPNx+jELvkYthb7wk37HufF3CqlvhDuYK7wGCDV6TgMEhuoc2uLiyMSPkIR
 CdWw4UDY+SuAc8lF8GPLKJygTvqDPtV1GfhPY4eMf719J/HzMyMlimhoeOP8BcpP03V3EkY2N
 MGs6OHuy21uj0sN4SuWIBcRUYGFQy6DrTlHBCpSXZOTY6fvoxkyf3uKUzWL8BvY8rnZNOyK4W
 bqBhTQ==

>> The label =E2=80=9Cerr=E2=80=9D was used to jump to a kfree() call desp=
ite of
>> the detail in the implementation of the function =E2=80=9Cio_ring_ctx_a=
lloc=E2=80=9D
>> that it was determined already that a corresponding variable contained
>> a null pointer because of a failed memory allocation.
>>
>> 1. Thus use more appropriate labels instead.
>>
>> 2. Reorder jump targets at the end.
>>
>
> As I mentioned on v1, this doesn't do us any good,

I dare to present other development views.


> as kfree can handle NULL pointers just fine,

Yes, this is the case.

Would you dare to categorise such a special function calls as redundant?

May it be skipped in more cases?


> and changes like this becomes churn later when backporting or modifying =
the code.

There are usual opportunities to consider for further collateral evolution=
.

Regards,
Markus

