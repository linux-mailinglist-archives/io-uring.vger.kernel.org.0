Return-Path: <io-uring+bounces-387-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A665882A2D6
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 21:51:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B1A81F2230D
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 20:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC9651C5B;
	Wed, 10 Jan 2024 20:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="sIf9EmCN"
X-Original-To: io-uring@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1561D51028;
	Wed, 10 Jan 2024 20:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1704919718; x=1705524518; i=markus.elfring@web.de;
	bh=mjRumUd/MQiEBX/hnG0E6F4D3lIQxntbIeEL/wnSQDQ=;
	h=X-UI-Sender-Class:Date:Subject:From:To:Cc:References:
	 In-Reply-To;
	b=sIf9EmCNdVoXDZb/cGz6fkXGBepk8yuZpzid1qfkbZm8REX52C5JFSeC8D6Ita0M
	 E7FH7LX+CqCPfI/l/XlNfpFyBRxGcAnWcIPJ1n7DyskHpaPNAuPWK4kC/YM93laxo
	 XXFxRgV7cz/KYo0ZiAsokd6glAzuyZrdWKp09zUNQyhZsc0FJfsG8NtHv5XysU7VM
	 /m1r92mhvFijB8Y6M4On6yLb+krgsIVzFltDYyIMavak70bCNxQZCYd5a7wlpLQJB
	 sN2XBdhlb9JGEV64BfiDLauOh92ujMqyxUP9B72fuBdz3W0HCPV8NBlaQSHeIa66Q
	 xKo8DXqB+8sEJ6Z5/w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.86.95]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M8T7K-1rJHmw2Zu4-004vkg; Wed, 10
 Jan 2024 21:48:38 +0100
Message-ID: <edeafe29-2ab1-4e87-853c-912b4da06ad5@web.de>
Date: Wed, 10 Jan 2024 21:48:37 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2 1/2] io_uring: Delete a redundant kfree() call in
 io_ring_ctx_alloc()
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
To: io-uring@vger.kernel.org, kernel-janitors@vger.kernel.org,
 Gabriel Krisman Bertazi <krisman@suse.de>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <6cbcf640-55e5-2f11-4a09-716fe681c0d2@web.de>
 <aa867594-e79d-6d08-a08e-8c9e952b4724@web.de>
 <878r4xnn52.fsf@mailhost.krisman.be>
 <b9c9ba9f-459e-40b5-ae4b-703dcc03871d@web.de>
In-Reply-To: <b9c9ba9f-459e-40b5-ae4b-703dcc03871d@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tptgrZvV5PfMbUHwW6P4eDBBUBiG1tmbpEQj6/acmNCuSqQx27g
 K+ga9sH7CSPTmn6XL19Wc9V+Z0s5fwVNUXYa6xwM5qpweC9uLfXSFer0olwGLBV7fQxGXAQ
 hERce4VbaG0G4j+XcVesEU/syab3gkyaLCUsgUF1hmAOOdKYf00Lt8bIpIRVmFRy84POqSl
 O598LlZB6lQCQZLr7Fgpw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:YmH1HGl/x+c=;RX8z9bvCEUZpdLFXHMwnVfQ41/8
 Hgi5MWw62zwwMVmDQc8hAf3iwJYWmtftnrXnytC6L77ndrsVebKAT6ESKVZIfjC5nFq/DFP2B
 bSCyn2hJrTYzW0SfP2Pw1s2xuVV10mDjdZrEf07HQDKeoavdizFGNfSmAOWx/08wxq60YYrmq
 pq4C6voELMEb1zJ0+HrCgsRlHyjtmaBIh28doYqAg4/obeM+XVVSRcRr6uoSKl8/gB0QefgC7
 XCmi6Y/lSKQPOL/Fbc7IuMkw0KW6dU/LlhRFevoJsVvQiqduaNr59UkHuQYyaLGUwHDCeD1t8
 fFbFygIJRnbafDZRgqXM2I4JTWkWyfWjxZVCjY8UKdindOgUA98TVq2oTsu5Jiq7GZQtDv71g
 mXU1ys2Q7Q7OJc9gtbPR1AcFe4Y4/SQFRzoX4qPWLFWKiktNkeVAW0QII06a5CjprPE1s6oaK
 kaYDpIXvKAdMO4snSKF5VA+u3ZGjw8GtrPr4nMGOGMeUy1Gw+FQOeK8yx7MEHOiPQyRfp8kq1
 QiaZ6Yg+cdZ4TM4aiD9rB4UTskM/UB2eORu2/DAS2qRQHcF/mH7rdqb2mLz/YZXqkHgeDLINN
 NY6s4M3GUz8us5KH8gCLuWLfjnPMlJOBMOTM7CpSYeDcqUhiQSl+CliJB4/QoggyTifL44PzR
 0mkuCfn7dBd7qA5Dz5JYvXYSX8A+toWnoCasG/AXp52jrSEW+0DwWrCAxRtyQc88F9ToFndRF
 Oyqlk7zaEbdSZ9M5Q81N2bx+GFShmdMSq9rQbsj3VylQNC6Yi8ILwco9+OmGT47uHlhfqwFpI
 8Clo9xA6O7l/diBLcX5K2UbNtdk9qM3IdP2FkpqK5IXYbrSoFtb1j/cOf7KMvpo6Yq9/E4X87
 x7kBzqwHmalAvmTinIbXzI7IMCwNHg9jhqeh8FthnJnC3B0uneDu9cJFyhrovBIIgqvcCVjK6
 EFsHLA==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 10 Jan 2024 20:54:43 +0100

Another useful pointer was not reassigned to the data structure member
=E2=80=9Cio_bl=E2=80=9D by this function implementation.
Thus omit a redundant call of the function =E2=80=9Ckfree=E2=80=9D at the =
end.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--

v2:
A change request by Gabriel Krisman Bertazi was applied here.


 io_uring/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 86761ec623f9..c9a63c39cdd0 100644
=2D-- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -344,7 +344,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(st=
ruct io_uring_params *p)
 err:
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
-	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
 	return NULL;
=2D-
2.43.0


