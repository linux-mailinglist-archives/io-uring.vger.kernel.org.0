Return-Path: <io-uring+bounces-6888-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EDF2A4A7FF
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:22:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 457E8189CF12
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86D71E49F;
	Sat,  1 Mar 2025 02:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="R1WOGBfF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2A123C9
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 02:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795745; cv=none; b=btH/dPpQ8mIROW2TC1GoNfgw90OknlrgMSQNxrmnlH96S83Kp0XofjzcRbxwk8vt4onccsZ+MEw/fHNc+sZwU0Z8/h8/LPAjrnxPaasCBO0iDwe2upa/Aoh7Wg8RvsgLID5jcqhnb8c6GH5AA9K2CbilIuUVWdqpxVfTYW5owpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795745; c=relaxed/simple;
	bh=2wTqxOXtafVmEkthQzwVuwSao99tForzQfDyN7jLsyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EQiXFe4DfzZj71OiuC45SWkd2sg+nQIE4ZR0JU03Kk5QV2VRnzb+mXr5uqepRHqPpZgsF0uIBPvdsngDYYBlka3mZl6aNIeY16TOviQiIWbjYtIx5otONuVAlWL1Hp1Hry5h7AEif/Q0hztFT3kB2yRpB1EdGwIvKwAycYtKSPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=R1WOGBfF; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e60c4e83cd3so421060276.0
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 18:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740795743; x=1741400543; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Im0HMDK2H1242B1xgpvNQP5Lm6a65yD85HN7f6w03Y=;
        b=R1WOGBfFFc6G/H0jwjIn+UY5DuLCMM4K/jlKR4xN7wICvFP1v8SVOb5+Qf+T/0vn8m
         vPPk13ZiT7ejC/jOfD8+5iofUTemqNpMmemhOpDFEiwgrvvDpOiXoXjsqK6R6fgz3/8q
         IcR3OocTl/CWx8EjdPLmJCkp0npKW07HOuK4Eb+xiQ2i311egxiixaJRQ5tGRJkM8jsI
         NyuomHk7TCTEV0unIGq/GZUd3Et6f/ws3ACNtStZAEwJoQCdVGgYTDbrjDdu3R2Sqvgr
         5O/w40x42GkxsJpLW5OTpQ85nQICT5Hnz9rdepYJzGse3YwoE6yNi3NPrUS1ayKrbQv7
         TEXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795743; x=1741400543;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Im0HMDK2H1242B1xgpvNQP5Lm6a65yD85HN7f6w03Y=;
        b=epL0OLZnEYcKFpdBGpDCmCigd96BUq7wvoIgsVeUcAYpIg3rzJoCOZfC3KXDqX92nc
         ch06VOo2fdGJw2SVxF/m1epn4uDO87p7BbWNoVwTvL4oil28rQKh5/VfwieOHTyP9j2c
         CbnKcpb8tPeA2NGyi57rnn4hCMJ2hHXSEBKV/3noEGRFuzkIu5e1qEh4V7sXEAG62JvJ
         FzWzVhFLHH9OxhRIjmZSUfanuQI5adcZ1krdt0eVOHoZIHWCOAPCJwLRr6BjenPPiQ2i
         5C/6i0xXgwfuSU8p6NM4+3T5DYdHPFsWIviTyeywPegH/XoAeoyhodYlNRxsXF2mYj1b
         G5Xw==
X-Gm-Message-State: AOJu0YwWQWDkJXAuhuH+cmh93Epga0ssBBCT3uB4Ed1WgY3uE8hHckDb
	HkCr+1beC9Uyu/LlkgAUUImomIYZQ7UVCyU5dvwlQ2Wndt1uX3PUYnXTudPOcyI=
X-Gm-Gg: ASbGncu88c70/A+4mGuw/Q0CP3MwNQcAPrGiuUWK38PVQ1xXzZy7tWhmMtIMm0aLMM6
	E/VgiX/26WkCNem0dOKyrUeHY7f9VQcvoE+aO06ls61kJmGalmb/BZ6RjQ8M/XKGdzjJjmc7nbC
	f89csRKxGtzC6SiAL5GTfYaUfKZryGJaOcXeYxB7yNDAf0SPK8hbanpHsLn+Kw8S59pz0IpaQeN
	apcaSWHfooObEdOzS/4KGvWNb/JAiAz5NcfzkF0aEqtGLuA/ZoJW8iEXCrYixgMNNG2DH+4VE3W
	dDwpIWwnLDxByIJ+FY8VtNWWYaPEBo8FdK9PkpLGVTWq
X-Google-Smtp-Source: AGHT+IF2+WLZ5LJ+vXsSgmDSjOUgyyxMU8EfMTjGqndYoP4XYbvHhyH+4d96gcwBTsElp6mLxtVU6g==
X-Received: by 2002:a05:6902:2209:b0:e5b:45ec:b841 with SMTP id 3f1490d57ef6-e60b2eaa326mr7252333276.12.1740795743226;
        Fri, 28 Feb 2025 18:22:23 -0800 (PST)
Received: from [192.168.21.25] ([207.222.175.10])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e60a3aafebcsm1408282276.51.2025.02.28.18.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 18:22:22 -0800 (PST)
Message-ID: <76a9617b-b1c8-44b0-8355-948758f6e70a@kernel.dk>
Date: Fri, 28 Feb 2025 19:22:22 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/rsrc: declare io_find_buf_node() in header
 file
To: Caleb Sander Mateos <csander@purestorage.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250301001610.678223-1-csander@purestorage.com>
 <86d5f210-d70f-4854-8ecf-eb771f26685a@gmail.com>
 <CADUfDZrOoSgT5n51N5=UFSum96mj2MAytQbJNbBVC1BJrmNVtA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZrOoSgT5n51N5=UFSum96mj2MAytQbJNbBVC1BJrmNVtA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/28/25 7:04 PM, Caleb Sander Mateos wrote:
> On Fri, Feb 28, 2025 at 5:45 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 3/1/25 00:16, Caleb Sander Mateos wrote:
>>> Declare io_find_buf_node() in io_uring/rsrc.h so it can be called from
>>> other files.
>>>
>>> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
>>> ---
>>>   io_uring/rsrc.c | 4 ++--
>>>   io_uring/rsrc.h | 2 ++
>>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>> index 45bfb37bca1e..4c4f57cd77f9 100644
>>> --- a/io_uring/rsrc.c
>>> +++ b/io_uring/rsrc.c
>>> @@ -1066,12 +1066,12 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>       }
>>>
>>>       return 0;
>>>   }
>>>
>>> -static inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
>>> -                                                 unsigned issue_flags)
>>
>> That's a hot path, an extra function call wouldn't be great,
>> and it's an internal detail as well. Let's better see what we
>> can do with the nop situation.
> 
> I can add back inline. With that, there shouldn't be any difference to
> the generated instructions for io_import_reg_buf().

Yeah, in general I don't like manual inlines, unless it's been proven
that the compiler messes it up for some reason. If it's short enough
it'll be inlined.

>> btw, don't forget cover letters for series.
> 
> Okay, I didn't have much else to add to the brief commit messages. But
> sure, I'll add a cover letter in the future.

Indeed, cover letters are always great to have.

-- 
Jens Axboe


