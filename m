Return-Path: <io-uring+bounces-2739-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E285E94FC37
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 05:28:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A40562832E0
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 03:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A418E1B285;
	Tue, 13 Aug 2024 03:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Kxots3jS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D123518E29
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 03:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723519721; cv=none; b=abxKamzNhVNdSIjqfAo804AyvCXuy/0XOKqxPLKjKUagKlA0yT0pug8rxCTS8pqr3XIl1zcYh5iztEnZ+kXphvDkqdPbFRUTMFCWGDkDA1TYhe8dooCLwxKXDY5yyw/CDCPAtTgFmjPSN2NZ7OdYuvphW3w4DqPaVTim3+EVrvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723519721; c=relaxed/simple;
	bh=sE17XrNuBDTYI+TZWASpu5cAi9owlxliSZLYckFeWBE=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=Egh1FxkZXi6/K8uqY9ftnQUmv205IQDXSdNaeMXUmtvKXlH57I89qpH/0y1eQPz1H+gNrLtputct0qfxttGOoXApndL8Vt6pU8t7Pr+n/4do7OQv43xp/3G4/KXuu0qixfY4/nWgShJg4JAEFy1oywjfScuV07tNfDBgeX/Eba4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Kxots3jS; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2cd16900ec5so958115a91.3
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 20:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723519718; x=1724124518; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sE17XrNuBDTYI+TZWASpu5cAi9owlxliSZLYckFeWBE=;
        b=Kxots3jSqZCXfajpntfp72EBmvV26OA2AT33vK2vJeAd3tDYNgi4qnl56VsL1dAUE9
         MiXJ/idlPIFZtN1q+8ICKKomNytujI2MJah9SaYlkuiizowcZP8yveXv/0sNpR2tDR2/
         s8UaMRPUvr3zfEPgmqOm1MMtzSKY+ZTzQ/ZYSQWSU9oocJgyRSfaw52Zr5Sb9ffchS6p
         j0TE4WQviATG0Ykb+BSti+fiXZG6McteWw6lgy8PhvJPwg7iSaG9xip5/5uM4TmzGRsY
         DO5cT1HzutZKAbDwNiMOoziKvOggxN/e/1GBWtEjsDk8+SWncr5mbhxNcnr7s7Pmg4Pj
         hzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723519718; x=1724124518;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sE17XrNuBDTYI+TZWASpu5cAi9owlxliSZLYckFeWBE=;
        b=BoYe8lzkQSO8fPqvSFzeibGHg4dTyEloDwE6BiILBLfnLwY97akvg8e+UewoN+uxEX
         Ml4vaRqrPqGnSIAqX5kq+oms+ONeLjcRIW092FActzvaMWtab6Mm3/ym1o4y7Kmv8gM8
         0x44mz6d7kNTijO1xoDLOaToJg+Ncn3t1sKc/4Dxa0u8GWvmB63vjXkYP2laB4GX/+AS
         ZaLVZ6iKnB+queHwThCSBRDBKD4Hzos07UsPqQnqEfpEJReBdvRnU2BL6g5EUaBmZvd9
         NFYjH6xjgW4HVYIP7iKz0wEkg2h3I5YR2/yrUfiniJGy+eFf8n+AxEpZgXTrNBJ5EzSP
         cQfw==
X-Gm-Message-State: AOJu0YyNW0YI7ZzIcDzbjWfnbUKlPfbWpKcqLzLC/AkncBosnFnj9NgN
	I+QXjpvGV5WHIESZ1OnfyBsAgAJzApH391WCnPBFGDcyFqR5RRwvCBHo8DMuPco=
X-Google-Smtp-Source: AGHT+IFvYDeP6Sf+BfoH0RHM1I/43vs/djrVrp/w4NbBjT4efjA90F+GBw0PLtbLAUI9EHdV9S2D1w==
X-Received: by 2002:a17:902:e843:b0:1fb:1ae6:6aa7 with SMTP id d9443c01a7336-201cda7feb6mr6393415ad.3.1723519717752;
        Mon, 12 Aug 2024 20:28:37 -0700 (PDT)
Received: from smtpclient.apple ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1e285bsm3799035ad.303.2024.08.12.20.28.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 20:28:37 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Jens Axboe <axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 0/4] clodkid and abs mode CQ wait timeouts
Date: Mon, 12 Aug 2024 21:28:26 -0600
Message-Id: <FB852B98-82B1-414B-BEF2-7DD9BEB6147C@kernel.dk>
References: <bb0ea79a-008f-46d5-8141-dcc8448404e4@gmail.com>
Cc: io-uring@vger.kernel.org, Lewis Baker <lewissbaker@gmail.com>
In-Reply-To: <bb0ea79a-008f-46d5-8141-dcc8448404e4@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
X-Mailer: iPhone Mail (21F90)

On Aug 12, 2024, at 8:38=E2=80=AFPM, Pavel Begunkov <asml.silence@gmail.com>=
 wrote:
>=20
> =EF=BB=BFOn 8/13/24 03:09, Jens Axboe wrote:
>>> On 8/12/24 7:32 PM, Pavel Begunkov wrote:
>>> On 8/13/24 01:59, Jens Axboe wrote:
>>>> On 8/12/24 6:50 PM, Pavel Begunkov wrote:
>>>>> On 8/12/24 19:30, Jens Axboe wrote:
>>>>>> On 8/12/24 12:13 PM, Jens Axboe wrote:
>>>>>>> On 8/7/24 8:18 AM, Pavel Begunkov wrote:
>>>>>>>> Patch 3 allows the user to pass IORING_ENTER_ABS_TIMER while waitin=
g
>>>>>>>> for completions, which makes the kernel to interpret the passed tim=
espec
>>>>>>>> not as a relative time to wait but rather an absolute timeout.
>>>>>>>>=20
>>>>>>>> Patch 4 adds a way to set a clock id to use for CQ waiting.
>>>>>>>>=20
>>>>>>>> Tests: https://github.com/isilence/liburing.git abs-timeout
>>>>>>>=20
>>>>>>> Looks good to me - was going to ask about tests, but I see you have t=
hose
>>>>>>> already! Thanks.
>>>>>>=20
>>>>>> Took a look at the test, also looks good to me. But we need the man
>>>>>> pages updated, or nobody will ever know this thing exists.
>>>>>=20
>>>>> If we go into that topic, people not so often read manuals
>>>>> to learn new features, a semi formal tutorial would be much
>>>>> more useful, I believe.
>>>>>=20
>>>>> Regardless, I can update mans before sending the tests, I was
>>>>> waiting if anyone have feedback / opinions on the api.
>>>>=20
>>>> I regularly get people sending corrections or questions after having
>>>> read man pages, so I'd have to disagree. In any case, if there's one
>>>=20
>>> That doesn't necessarily mean they've learned about the feature from
>>> the man page. In my experience, people google a problem, find some
>>> clue like a name of the feature they need and then go to a manual
>>> (or other source) to learn more.
>>>=20
>>> Which is why I'm not saying that man pages don't have a purpose, on
>>> the contrary, but there are often more convenient ways of discovering
>>> in the long run.
>> In my experience, you google if you have very little clue what you're
>> doing, to hopefully learn. And you use a man page, if whatever API you're=

>> using has good man pages, if you're just curius about a specific
>> function. There's definitely a place for both.
>> None of that changes the fact that the liburing man pages should
>> _always_ document all of the API.
>=20
> Nobody said the opposite, but I don't buy that man pages or lack
> of thereof somehow mean "nobody will ever know this thing exists".

I don=E2=80=99t know why we=E2=80=99re still arguing about this, when the po=
int is that any addition to liburing should come with a man page update. Tha=
t part isn=E2=80=99t up for debate, and honestly the only thing that matters=
 here. Would be it great to have additional documentation like a tutorial? C=
ertainly. But for a flag that adds absolute timing for waiting rather than r=
elative, just documenting is probably all that=E2=80=99s needed. It=E2=80=99=
s not like it needs a ton of how to or documentation.=20

If it only exists in a header somewhere, it=E2=80=99s. It going to be easy t=
o discover.=20

=E2=80=94=20
Jens Axboe


