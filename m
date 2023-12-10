Return-Path: <io-uring+bounces-278-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD2C80B851
	for <lists+io-uring@lfdr.de>; Sun, 10 Dec 2023 02:25:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0B20280E45
	for <lists+io-uring@lfdr.de>; Sun, 10 Dec 2023 01:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3BBE7FF;
	Sun, 10 Dec 2023 01:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WudCiSM+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6290C2
	for <io-uring@vger.kernel.org>; Sat,  9 Dec 2023 17:25:09 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-3332f1512e8so3122672f8f.2
        for <io-uring@vger.kernel.org>; Sat, 09 Dec 2023 17:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702171508; x=1702776308; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B0ZXBZcbKWVJShJJNJry/RY3hT7v7tGy8RzPiU51omc=;
        b=WudCiSM+HonyQ5tXia3tbNCz+TfbMhABqLb/atMRcHdE+Ywlu90OaSkQC1L3dpU4jm
         U2fE/OF+MG5A45CBnTlCXQpmpDwX0gQMnVq6srwKkixEZYfA3ksSrrZF4uHdt2ObCHh6
         w9db0DUhnzoyaS84Aid5ggefCtOKw0mKO7bFfH32l9JfOYU8Zkv13AynCjBIHGwc5/89
         JPocPfk0XjohIipbA6Y5yMcx6wNjv9K5x4ihzvqouNL4UcXBPiEjCE2lAXNkjuuWwPtf
         Vk76cryaNj5oMojtmFzPw2vkxyLQPsNZ7cgK63n8hNzhl2RimpyWiV425Ft2TJcZiGta
         wvSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702171508; x=1702776308;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B0ZXBZcbKWVJShJJNJry/RY3hT7v7tGy8RzPiU51omc=;
        b=YKGy4mzyTGUNdY92ayrx8jz1I1wiWyC9uVAsrtcU4SEzug5GAOUVED5GrCWw+F81vC
         Jh/WipnilsBsOAwUufAhXv/Yp/ATPJvVRZzvCM76op/eaQJytJ9jyfmaGkck+qL8hD8P
         xI3P00SarQU5z5zR/UlN4iahTwMP228cIEtDpPii5u02P2G5hNzuuefcseGckbn+0Vfe
         C2Bpd/uJcQNYn8w1zvDG7WEwQL5WJd6iTHO6c5ZrPFosdwcoCTLWYdVQAtest4xw7HBe
         70+NplAI9e9u3zInwIeAwxIykafAR6AZj+aF0nDbYO3dlazBykJO4l9o8yqeN2I+UcmK
         flVA==
X-Gm-Message-State: AOJu0YxiweBx1lyytpo+INpNJk52BvzcqLM8QIGSeW5gyoCXLlwrPRuG
	pY2RHNRxo7j/y0HuzW9yDGQ=
X-Google-Smtp-Source: AGHT+IE9/3ZldhSi3xii7RM9oCh52ykC9c4qo0YUQ/FraWVt+evzCAGfpqmifrnsvY1J1JJajVuf5Q==
X-Received: by 2002:a5d:4b50:0:b0:333:1fc1:443b with SMTP id w16-20020a5d4b50000000b003331fc1443bmr1283536wrs.4.1702171508006;
        Sat, 09 Dec 2023 17:25:08 -0800 (PST)
Received: from [192.168.8.100] ([85.255.236.102])
        by smtp.gmail.com with ESMTPSA id k18-20020a5d5192000000b0033339027c89sm5312800wrv.108.2023.12.09.17.25.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Dec 2023 17:25:07 -0800 (PST)
Message-ID: <cff02e9f-e4b0-422b-9e9c-ac83a37ad82b@gmail.com>
Date: Sun, 10 Dec 2023 01:23:47 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/af_unix: disable sending io_uring over
 sockets
To: Jeff Moyer <jmoyer@redhat.com>, Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
 <170198118655.1944107.5078206606631700639.b4-ty@kernel.dk>
 <x49sf4c91ub.fsf@segfault.usersys.redhat.com>
 <CAG48ez2R0AWjsWMh+cHepvpbYWB5te_n1PFtgCaSFQuX51m0Aw@mail.gmail.com>
 <x49lea48yqm.fsf@segfault.usersys.redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <x49lea48yqm.fsf@segfault.usersys.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/8/23 16:06, Jeff Moyer wrote:
> Jann Horn <jannh@google.com> writes:
> 
>> On Fri, Dec 8, 2023 at 4:00 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>
>>>> On Wed, 06 Dec 2023 13:26:47 +0000, Pavel Begunkov wrote:
>>>>> File reference cycles have caused lots of problems for io_uring
>>>>> in the past, and it still doesn't work exactly right and races with
>>>>> unix_stream_read_generic(). The safest fix would be to completely
>>>>> disallow sending io_uring files via sockets via SCM_RIGHT, so there
>>>>> are no possible cycles invloving registered files and thus rendering
>>>>> SCM accounting on the io_uring side unnecessary.
>>>>>
>>>>> [...]
>>>>
>>>> Applied, thanks!
>>>
>>> So, this will break existing users, right?
>>
>> Do you know of anyone actually sending io_uring FDs over unix domain
>> sockets?
> 
> I do not.  However, it's tough to prove no software is doing this.
> 
>> That seems to me like a fairly weird thing to do.
> 
> I am often surprised by what developers choose to do.  I attribute that
> to my lack of imagination.
> 
>> Thinking again about who might possibly do such a thing, the only
>> usecase I can think of is CRIU; and from what I can tell, CRIU doesn't
>> yet support io_uring anyway.
> 
> I'm not lobbying against turning this off, and I'm sure Pavel had
> already considered the potential impact before posting.  It would be

Jens already replied, but I wanted to add that it was discussed and
decided to go forward with, because there are no too obvious / known
users, and the benefits including safety outweigh it.

> good to include that information in the commit message, in my opinion.

Yeah, agree with that

-- 
Pavel Begunkov

