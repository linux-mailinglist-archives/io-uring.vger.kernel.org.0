Return-Path: <io-uring+bounces-280-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C91BF80E371
	for <lists+io-uring@lfdr.de>; Tue, 12 Dec 2023 05:45:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03F811C2031C
	for <lists+io-uring@lfdr.de>; Tue, 12 Dec 2023 04:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FA8D2FF;
	Tue, 12 Dec 2023 04:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nvi2wL0U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FEF9B
	for <io-uring@vger.kernel.org>; Mon, 11 Dec 2023 20:45:51 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6ceccf6d88fso559712b3a.1
        for <io-uring@vger.kernel.org>; Mon, 11 Dec 2023 20:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1702356350; x=1702961150; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YzW6ne78hOyVBwyJBdluG6G3urLMiolMojmNa+NoQdE=;
        b=nvi2wL0UDtdu/2NKSAK/bwR+VvCcNRx1At5zauChmbK+kRz9r7BfRsui0RevWbRXof
         vAkVpvFE5vEY4XrqHHJixGRTXb/wIeL4EAmx33BuL9yEtxkeilV4mAFsUWEThrQMyFgG
         dvIbU6wLaqzdfTjgT5tQvcyG/S7HfYY+sxnzFAyVQvmGhErcgj+WgUnrozW2ILcBflH2
         ONJAtOHewDcP88+AAOfr+/bZ/A9KwKBDvOTQdTxiKouLzgexy0nyHJCS3QE6Daua/dQu
         cPEbioRPi1dTBx7rPxUVoqhxYuRwXDFXDZCUEqf6rgxKF7gqjs05DX+1yAXfrQsXbs92
         cmSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702356350; x=1702961150;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YzW6ne78hOyVBwyJBdluG6G3urLMiolMojmNa+NoQdE=;
        b=XCK08sIEEptu7taoie/b97gAaYnQ1w2JUEWtRRLbT0P4eXsbuCoRm0uS9Yy1qO6Rve
         Hzdf5RPGdcpBkmiIVkytnHkf3QmBI49eqOVSeLuqGOPyVamMgxSTbJSKSTL6BLm4E0SR
         ey2pu7Phk2YccZH3ylMSN1atExq0uDxYj3ePWLaPhsKe6/GO7n/rySY5nziUiwODjCVV
         cIvvyl7axWCnC1X+s6BmGLp82jl+vdFbmcLu0yS+ntNbHCz1O1GntyKNOlWzFPI4dSte
         4CdAJzxj4PQVPObGJTlalTiwrrvMFJIcyTnV+gYhAoZEgI/P5kTSWGUmNN6teNcuxrUX
         iiuQ==
X-Gm-Message-State: AOJu0Yw3bOv/eYIRZ0d7X0GSakDvLkNWgMZx2Bx92u5n7h5Hm9a3/6sk
	qE7wItEu8M7FEDITJZWcCXK3ZA==
X-Google-Smtp-Source: AGHT+IFeVarIjV/fmLCRlJK7v2wGXjcnIKXEDjNmlMbIoWER8XgjJrTP3GxTfPQuISj35Gsn/z0Skw==
X-Received: by 2002:a05:6a00:4b4a:b0:6ce:720e:23e with SMTP id kr10-20020a056a004b4a00b006ce720e023emr11977411pfb.1.1702356350458;
        Mon, 11 Dec 2023 20:45:50 -0800 (PST)
Received: from smtpclient.apple ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id l2-20020a6542c2000000b005c621e0de25sm6176085pgp.71.2023.12.11.20.45.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 20:45:48 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Jens Axboe <axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH RESEND] io_uring/af_unix: disable sending io_uring over sockets
Date: Mon, 11 Dec 2023 21:45:38 -0700
Message-Id: <105F23B4-F0B6-41E3-A795-F1B8E754A160@kernel.dk>
References: <20231211183953.58c80c5c@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 patchwork-bot+netdevbpf@kernel.org, io-uring@vger.kernel.org,
 jannh@google.com, davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 netdev@vger.kernel.org
In-Reply-To: <20231211183953.58c80c5c@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
X-Mailer: iPhone Mail (21B101)

On Dec 11, 2023, at 7:39=E2=80=AFPM, Jakub Kicinski <kuba@kernel.org> wrote:=

>=20
> =EF=BB=BFOn Sun, 10 Dec 2023 01:18:00 +0000 Pavel Begunkov wrote:
>>> Here is the summary with links:
>>>   - [RESEND] io_uring/af_unix: disable sending io_uring over sockets
>>>     https://git.kernel.org/netdev/net/c/69db702c8387 =20
>>=20
>> It has already been taken by Jens into the io_uring tree, and a pr
>> with it was merged by Linus. I think it should be dropped from
>> the net tree?
>=20
> Ugh, I think if I revert it now it can only hurt.
> Git will figure out that the change is identical, and won't complain
> at the merge (unless we change it again on top, IIUC).

Yeah, git will handle it just fine, it=E2=80=99ll just be an empty duplicate=
. Annoying, but not the end of the world.=20

> If I may, however, in the most polite way possible put forward
> the suggestion to send a notification to the list when patch is
> applied, it helps avoid such confusion... I do hate most automated
> emails myself, but an "applied" notification is good.

I did do that, I always do. But looks like b4 replies to the first email rat=
her than the one that had netdev cc=E2=80=99ed, which may be why this happen=
ed in the first place.=20

=E2=80=94=20
Jens Axboe


