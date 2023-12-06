Return-Path: <io-uring+bounces-246-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAE6A80642B
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 02:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC1151C20C6E
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 01:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9699210EC;
	Wed,  6 Dec 2023 01:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cr7NgsXz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620B2109
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 17:34:13 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-a1db6816177so3485766b.0
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 17:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701826452; x=1702431252; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+YvrZdyk+nz6LYJZMTSvH+vyWdF8Qpn26102FibhIOM=;
        b=Cr7NgsXzVTrQdssJ+OhrLjgR/+q6n0n0R2LcE7UW3KzKsHTPERe2KgM/AfSPCkWwti
         e8a0ZQk5kkqd3SnHAwiMDmiye1dOUMTqc1oPliSBphzFDos2/hrSNtEBDWCoGhF1M3Dz
         VTlwDIhJEFfqWSwRpWptyYJX2/LdPKIJgYjcAdAFDU9l70j5lL3sPnQB9ArxBuGhBjz9
         NEvItUBAml7oC/gUbT+vV/EAGS4ZNPqzVQkk8Z+5xO2CUfH5f7RijgE+QOetF1+159C9
         Twn2qEpauq66GgIl3/hPGrubjDPeIVCC23BvSRzMXSosyP5TSmicZ/Et7wS6M4jRfO01
         5+aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701826452; x=1702431252;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+YvrZdyk+nz6LYJZMTSvH+vyWdF8Qpn26102FibhIOM=;
        b=h8auEme1+hRWFeVNNNO+lPoS0/jNPqNYLmaq5r50P4A+UARZOYeenogyKByx1EYyGh
         ERYMfVL+F+f92JqiAgzR19FLS0EVgLDrmwN2xnH3QZPcR5qBx/E4fM+8+rw9ixKxppjK
         G8zVZVr4NDJf6eMZkaPznEs0YVJDQBF3dPDoBija/UAZ9uwwykNGq9TaPGK3Wee+nbyU
         OwoZ176Ob3NSZScezm1uhTsM2dpfYbgeYUeGZgfeSH11zItkVeUJjx38oTa/QBg6PeT/
         pmpMaFDMBcqWCzqnH//onykXbhD1BPYODTdOABHEmB/Ip9Xok3lwgfy2GsA/I94CmpX8
         Hw6Q==
X-Gm-Message-State: AOJu0Yxf0BFVtaTQ0UZri9xM8gPA1LDWXCZFFR9ZplvCiX4avDA5quYZ
	apT43kG1A1j+O/FyeXoVG7U=
X-Google-Smtp-Source: AGHT+IECYcEJ9KbWD+aRGA9xWnPugIAI4q5ZX5JS6nanE0IeAkGdl7D+fOBonKzTqYrRn2MFlEntPg==
X-Received: by 2002:a17:907:bb98:b0:a19:a19b:4265 with SMTP id xo24-20020a170907bb9800b00a19a19b4265mr47608ejc.208.1701826451602;
        Tue, 05 Dec 2023 17:34:11 -0800 (PST)
Received: from [192.168.8.100] ([148.252.140.209])
        by smtp.gmail.com with ESMTPSA id m12-20020a17090607cc00b009ff783d892esm7544305ejc.146.2023.12.05.17.34.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 17:34:11 -0800 (PST)
Message-ID: <7233dc1f-f9bc-4ec2-9e03-18ccb0919dbe@gmail.com>
Date: Wed, 6 Dec 2023 01:31:35 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: save repeated issue_flags
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org
References: <20231205215553.2954630-1-kbusch@meta.com>
 <43ff7474-5174-4738-88d9-9c43517ae235@kernel.dk>
 <ZW-sE1hOG4EB3ktS@kbusch-mbp>
 <9aa4aa06-7cc8-4a64-821f-1a00eff9cc9a@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9aa4aa06-7cc8-4a64-821f-1a00eff9cc9a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/23 23:11, Jens Axboe wrote:
> On 12/5/23 4:02 PM, Keith Busch wrote:
>> On Tue, Dec 05, 2023 at 03:00:52PM -0700, Jens Axboe wrote:
>>>>   		if (!file->f_op->uring_cmd_iopoll)
>>>>   			return -EOPNOTSUPP;
>>>> -		issue_flags |= IO_URING_F_IOPOLL;
>>>>   		req->iopoll_completed = 0;
>>>>   	}
>>>>   
>>>> +	issue_flags |= ctx->issue_flags;
>>>>   	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>>>>   	if (ret == -EAGAIN) {
>>>>   		if (!req_has_async_data(req)) {
>>>
>>> I obviously like this idea, but it should be accompanied by getting rid
>>> of ->compat and ->syscall_iopoll in the ctx as well?
>>
>> Yeah, I considered that, and can incorporate it here. Below is a snippet
>> of what I had earlier to make that happen, but felt the purpose for the
>> "issue_flags" was uring_cmd specific and disconnected from everyone
>> else. Maybe I'm overthinking it...
> 
> I'd just do a patch 2 that does compat and syscall_iopoll. And then if

I don't understand why and how you'd get rid of syscall_iopoll,
considering it's not exposed to cmds, and if it is, then we have
a bigger problem. It's a bit sleazily defined and is not just
SETUP_IOPOLL.

> we ever have a new issue flags (as your other series), then it'd become
> natural to add that flag too.
> 
> It's not a hard requirement, but it's somewhat ugly to have the same
> state in two spots. Which is why I'd prefer if we got rid of the actual
> compat/syscall_iopoll members as well, after the conversion is done.

-- 
Pavel Begunkov

