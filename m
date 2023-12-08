Return-Path: <io-uring+bounces-263-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3AE680A8E7
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 17:28:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F93F28175A
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 16:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2FE9374EC;
	Fri,  8 Dec 2023 16:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="T0GGvJxw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7228C1985
	for <io-uring@vger.kernel.org>; Fri,  8 Dec 2023 08:28:38 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-35d7341be5cso1752095ab.1
        for <io-uring@vger.kernel.org>; Fri, 08 Dec 2023 08:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1702052918; x=1702657718; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7ZyDrMa1mTHRL9xfoC41aa1ZC2a8IMfn9xZ45YYU/6Q=;
        b=T0GGvJxwRMDcvk0awDdYOF/Tn5xrmSfmgoy1KUz0mCDTawKUeU3nThzdRY1d6DkZCV
         1TtVd44WDEZiIsqlsVKpovydxnn1GpgWqAQayvRoVfYUtEKMdD5xmoprvI6VuH5ei54k
         MKJ5VYXMWCnDMGHF6NY1h1qkzhHgnzO2N7yfTAayxiosHjXw2uBTsyHmhGqAjzqRitTE
         NkkPhGO1BGZy6QNa3givY5pvm9trC/dZ621ZHrzHfTRTqe5e0/zgtHEHcc98QYo3nNZg
         laaKiTePLXBFDgXyEvXtY6/Nx6VWFwBP2x70t5JiKiVR3QuBx7cuVh6/OI8CckA6TZfH
         IkaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702052918; x=1702657718;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZyDrMa1mTHRL9xfoC41aa1ZC2a8IMfn9xZ45YYU/6Q=;
        b=Gam0aO/knq3ys9Y7K+ZU0sARwIYZFw/3PgQrOznZHq7UK/3dL5hg8o9BekYO8jP5qQ
         gme3+lEIFAKeQqkXE1pF8FLqpS3zkuQ9+lAdbYtYqf4fM1r1OpJbYEguwHPLRN4zYr9Y
         KOZpoErjvJTTxGTAn9rQkS//mThd35A0eub/Sxued005PeoiIO95l/MESiuwgvcJTaDx
         /ZYw6gwGK50VuEsHWGSnw9BzEIwkbnRNRALaFkT2QudUNUuXw0gC2IBZvKnkKDVxDieL
         lZkDdn3/AIPQwrBVwwNy7DGLpF5UlfHYeVunT34lrtzzEZeU5bYg9ENkStq0uwUwE7w1
         2aiQ==
X-Gm-Message-State: AOJu0YyOBz53Qphs80LloDjNvuZsBhrihA6VUNv6mHUqFgXcAEORdNQ3
	RxrmTZBB+a8NuhAQYD3PbFH0jA==
X-Google-Smtp-Source: AGHT+IHr39s8cNU0+dyJfw01uW9wQKobv3psa/VxKrUsf8KSnMUOHxnlWabudC048QMUP1ut7Cj+QQ==
X-Received: by 2002:a05:6602:257c:b0:7b4:2bdf:5a27 with SMTP id dj28-20020a056602257c00b007b42bdf5a27mr826323iob.0.1702052917738;
        Fri, 08 Dec 2023 08:28:37 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p22-20020a02b396000000b004665c938c62sm520754jan.120.2023.12.08.08.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Dec 2023 08:28:36 -0800 (PST)
Message-ID: <6d2d5231-4729-4783-bcc8-0d11396e30fb@kernel.dk>
Date: Fri, 8 Dec 2023 09:28:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/af_unix: disable sending io_uring over
 sockets
Content-Language: en-US
To: Jeff Moyer <jmoyer@redhat.com>, Jann Horn <jannh@google.com>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
References: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
 <170198118655.1944107.5078206606631700639.b4-ty@kernel.dk>
 <x49sf4c91ub.fsf@segfault.usersys.redhat.com>
 <CAG48ez2R0AWjsWMh+cHepvpbYWB5te_n1PFtgCaSFQuX51m0Aw@mail.gmail.com>
 <x49lea48yqm.fsf@segfault.usersys.redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <x49lea48yqm.fsf@segfault.usersys.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/8/23 9:06 AM, Jeff Moyer wrote:
>>> So, this will break existing users, right?
>>
>> Do you know of anyone actually sending io_uring FDs over unix domain
>> sockets?
> 
> I do not.  However, it's tough to prove no software is doing this.

This is obviously true, however I think it's very low risk here as it's
mostly a legacy/historic use case and that really should not what's
using io_uring. On top of that, the most efficient ways of using
io_uring will exclude passing and using a ring from a different task
anyway.

>> That seems to me like a fairly weird thing to do.
> 
> I am often surprised by what developers choose to do.  I attribute that
> to my lack of imagination.

I think you stated that very professionally, in my experience the
reasonings are rather different :-)

>> Thinking again about who might possibly do such a thing, the only
>> usecase I can think of is CRIU; and from what I can tell, CRIU doesn't
>> yet support io_uring anyway.
> 
> I'm not lobbying against turning this off, and I'm sure Pavel had
> already considered the potential impact before posting.  It would be
> good to include that information in the commit message, in my opinion.

It's too late for that now, but I can mention it in the pull request at
least.

-- 
Jens Axboe


