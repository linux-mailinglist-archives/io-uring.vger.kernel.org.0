Return-Path: <io-uring+bounces-388-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C88E82A2DC
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 21:52:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6332EB241D4
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 20:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E2C74F1E0;
	Wed, 10 Jan 2024 20:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="bzsIFTLJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ECD4EB42;
	Wed, 10 Jan 2024 20:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1704919816; x=1705524616; i=markus.elfring@web.de;
	bh=pGmRLZXbzB1/VCJ6cMwk/E3wY5qGaj+l7gvleCOR1ao=;
	h=X-UI-Sender-Class:Date:Subject:From:To:Cc:References:
	 In-Reply-To;
	b=bzsIFTLJg3a4gPX16xErwtOIO2wv9E5rTnHinVBCPW10NGqDIeyMhb4AaLYOzMxG
	 8ofIMFBWa35ALiVVFDtxPWxK0FNYjn8/VoIfE1ZzZHnqpUHf14Z9Ucmj+lJsGpz7p
	 WjQqXURD28cthjszehEHFIo3+GvpJWIRjNldYTnEgDK0vBZh7mslJmHLP/KlCy+vs
	 bH1qh1ciSeVIqcmQlhuiuu/FhyrPUgAUW5YRANfmiZM8W/h7K0m7c8ado1FwuWeSS
	 AU5XioEAUIeexZHBRswVpZaucf4ATqQzv/hnF+TSG47OUG1CG9HzDzWN+mR2wFpyU
	 rqJVpWAYfmWSpSwX9w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.86.95]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MBjIE-1rTDRU0WZo-00CbGQ; Wed, 10
 Jan 2024 21:50:16 +0100
Message-ID: <49ecda98-770d-455e-acd7-12d810280fdd@web.de>
Date: Wed, 10 Jan 2024 21:50:15 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2 2/2] io_uring: Improve exception handling in
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
X-Provags-ID: V03:K1:TuPuGGpNWoSodpshiNclXlqKXV6zUP8351xLMItjhIv/nGqTHrD
 gJLyrjtqjfNe6FhIycKYw2lTUQjDQbajnnpQA152WfhBLBFDivvSJboDK2igQCFEJqmPc3w
 a+GdrUqNpYcTolhQe9VtvrwnLJkDu/vXYDw5wMyAOLCdmelvphDukq9ugWp+CTJvqhwHniT
 F4KEjoOz5PnFpCHQI1CpQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:XoI6qzTL9rY=;ywGCQc0fYI+KyH/7lb2JrqTcCZu
 bP9yWcAZkVxDHna/Oac2IV8zPfamLc4ZgA5f8kBa8HeNXRz913onQRuJjHTttKXC+Gkg5qphR
 RHCEr4n7IFP/FyKLGQC2EVGSSMwdu53hIb7NUxDqv9qUBTwrLdRK4naoymyWs2LOjoNlce73q
 m1Xy8mf+ugKgfqypu2vzqX7trcO7JlE5TDkvf8PpnzClOYWKu+CuAFO6vRTTTf68jhQLmAzKr
 53WyidRYULEpuc3dyk58JqsztdPj6cXF0GZgBgrgiPWfGkE/WiKD/hC/uMjZaOa5ZzpcaQ2dT
 ++tGmyO4LYn6my1wKgx0iVSoZfuz2yDCPgP+sVkxohkhlUWdIzRTNtahQYD174rc/glTEyj+k
 S3xER/IfArmhRfvEr99UX5A9gHEd+dZvqTha+NFj5pGFQbWfcN2G9NZuBGYPTQp9jmMn5ljIJ
 WSTxZ5soPj3pXp0hLCW8DZvinDCHZTYqJLJEwtfXat3tnyRW6rjEpy7OIYDYHuG8lskYH94hy
 FxuInmAQbnvaGgtl8RLK5s9OODi5dDfXg3DbYnSXqLUyDSaVf1OcWmKLi0Q3bq9Mp00BPPBGR
 zlyFEmYO288RW4L4r4e/oDwMFc5O4GlVyqJByv9m88QGk3/ULP6Hcloroo2KLYHv/8De/iRW3
 dijTeCay+P2f3CzuIcSi0tc+hYfR86jr/wBmrZKjk3W3omxDLaXqgCJ/tB57cS+NNaGfPYnw5
 V/RPTvAOwdTvNUhIdS+hquLeTYPExVxS5gbsFPSyMxmzFfvqP4TrTO6Tm4eCEerHySCO+5T+8
 XxNYHEdVRocvMz213BbpXzR8PKySLLwUfUB4Pe4BOkqFHiOun24DMtxSIbbPaDvoH3MYy0gep
 MZAedsHonBD3rD5CVB7Ya1VwxbKppxWaXSdR+ayBNK2JBpejVZHsxp4L4tctm3ZNRiSWjH9ku
 80pcJg==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 10 Jan 2024 21:15:48 +0100

The label =E2=80=9Cerr=E2=80=9D was used to jump to a kfree() call despite=
 of
the detail in the implementation of the function =E2=80=9Cio_ring_ctx_allo=
c=E2=80=9D
that it was determined already that a corresponding variable contained
a null pointer because of a failed memory allocation.

1. Thus use more appropriate labels instead.

2. Reorder jump targets at the end.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--

See also:
https://wiki.sei.cmu.edu/confluence/display/c/MEM12-C.+Consider+using+a+go=
to+chain+when+leaving+a+function+on+error+when+using+and+releasing+resourc=
es


 io_uring/io_uring.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c9a63c39cdd0..7727cdd505ae 100644
=2D-- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -295,12 +295,14 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(=
struct io_uring_params *p)
 	hash_bits =3D ilog2(p->cq_entries) - 5;
 	hash_bits =3D clamp(hash_bits, 1, 8);
 	if (io_alloc_hash_table(&ctx->cancel_table, hash_bits))
-		goto err;
+		goto destroy_io_bl_xa;
+
 	if (io_alloc_hash_table(&ctx->cancel_table_locked, hash_bits))
-		goto err;
+		goto free_cancel_table_hbs;
+
 	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
 			    0, GFP_KERNEL))
-		goto err;
+		goto free_cancel_table_locked_hbs;

 	ctx->flags =3D p->flags;
 	init_waitqueue_head(&ctx->sqo_sq_wait);
@@ -341,9 +343,12 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
 	return ctx;
-err:
-	kfree(ctx->cancel_table.hbs);
+
+free_cancel_table_locked_hbs:
 	kfree(ctx->cancel_table_locked.hbs);
+free_cancel_table_hbs:
+	kfree(ctx->cancel_table.hbs);
+destroy_io_bl_xa:
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
 	return NULL;
=2D-
2.43.0


