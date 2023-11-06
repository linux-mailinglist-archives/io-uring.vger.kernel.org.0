Return-Path: <io-uring+bounces-38-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 771A47E28C0
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 16:33:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7BC51C20B74
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 15:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 069B128E09;
	Mon,  6 Nov 2023 15:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cmIxEP94"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661EC28E0F
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 15:33:39 +0000 (UTC)
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C603100
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 07:33:37 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2c6b30acacdso62130531fa.2
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 07:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699284815; x=1699889615; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vip4+29YBJ3wnAM/wZHqu0XgEcaXNwusvkLTSKMtmmE=;
        b=cmIxEP94qvJ7583OWXKi5/8Wya7oLh6r77WEyMK66zofbcxTk+x24HJ909JO1xFbcH
         PqaLQaVO4whQrGIkKDYGKBGlPRHVm1+7cBzU6/5yeJAFFlnJBVwdeegKaAC6C6DxTVOY
         ykbml42vk6Y+89wKkb0kJEQ5JiQ4bVH4dY+C7afFQbhi6O2lPr+wk6jBcM9rrrv0PVaW
         nIXbRaWQ66FW7E1nWmVuWY7PrN0twoBRqzGDurhshWLp2n/PczoD28reo2l4b/L2VObu
         7CBUSfenTsHQLg5T73hnIETeA27vU8PvnHCDaMP3Al5KPPUjlr0HBTU4syMMgnnLfex1
         WPnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699284815; x=1699889615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vip4+29YBJ3wnAM/wZHqu0XgEcaXNwusvkLTSKMtmmE=;
        b=gbrnKAww7AaD6gn+vhm/OmeqqzYx9hFpTVIOjKZr0eqnM04O0IY4y9GLWcbBYDtHql
         WxGysVqUBjU06TVs4rzPgXyeG1+D+IDdT4NApZL135zT3Rm6jropSA/GZi/+WZvotRl5
         Y45caGmNuWIh8GtoebdJK4jNBJl3gTEdCgBZ3+LnJd/Eem/AlkzXmJSnAiGYFWBLaNv8
         kxhxzLIvh5a/rhv0m33Nvt0rMFUXW+EMWEJ6CrJH4Dsv65KeLLDNipUCaraK9WsJnXts
         hmGDg8wZ6gxum4kLIRLc9DKkC8zNUEu2hPPXfqq5h3XZOD6t7vNpG7vRqymxRr67GwS/
         B1Zw==
X-Gm-Message-State: AOJu0Yz1M3x/uGhjMncvy8K5sXts49lmvi2r1J3LfIdn/b8ahS0beVlT
	PrGtDm9owPILMIRTN1rKglc8GxcN3xWxQd/ptSK/s3wzMvc=
X-Google-Smtp-Source: AGHT+IEILz3FylqGvQQXXc50Nr9M+FAOye/9uoPBRES7YKZLcpEqVL66/EtadtJDz2YPW/1G2FIrkSBazTqu788TbOM=
X-Received: by 2002:a2e:a791:0:b0:2c1:375a:b37c with SMTP id
 c17-20020a2ea791000000b002c1375ab37cmr26533582ljf.40.1699284815349; Mon, 06
 Nov 2023 07:33:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231105223008.125563-1-dyudaken@gmail.com> <20231105223008.125563-3-dyudaken@gmail.com>
 <b6db6eeb-3940-43ab-8cae-fb81ff109e41@kernel.dk>
In-Reply-To: <b6db6eeb-3940-43ab-8cae-fb81ff109e41@kernel.dk>
From: Dylan Yudaken <dyudaken@gmail.com>
Date: Mon, 6 Nov 2023 15:33:24 +0000
Message-ID: <CAO_Yeogr9D+MH2m4GGq40mKHfyvVgUscdPsjh2STi0Y2TZGNBQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] io_uring: do not clamp read length for multishot read
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 2:46=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/5/23 3:30 PM, Dylan Yudaken wrote:
> > When doing a multishot read, the code path reuses the old read
> > paths. However this breaks an assumption built into those paths,
> > namely that struct io_rw::len is available for reuse by __io_import_iov=
ec.
> >
> > For multishot this results in len being set for the first receive
> > call, and then subsequent calls are clamped to that buffer length incor=
rectly.
>
> Should we just reset this to 0 always in io_read_mshot()? And preferably
> with a comment added as well as to why that is necessary to avoid
> repeated clamping.

Unfortunately I don't think (without testing) that will work.
Sometimes the request
comes into io_read_mshot with the buffer already selected, and the
length cannot
be touched in that case.

We could check if the buffer is set, and if not clear the length I guess.
I'm a bit unsure which is better - both seem equally ugly to be honest.

