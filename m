Return-Path: <io-uring+bounces-11705-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 009ECD1F8E9
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 15:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 02AC7300E7C4
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 14:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 202B03101B1;
	Wed, 14 Jan 2026 14:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JtwL4rGj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A8830EF7F
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 14:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768402504; cv=none; b=NaCRWrwxlhmhFeRG770UQEm+exS4SMs1XCnP8PFaA367gtLlNItZ5A53yqZQWDJMcayrQhihfO1PE25D6txMB0UUMzYrsf1pRTkQsenFB1fd7lOaP+PqwNWFVZa1/m1KKHOv/RZcQ02ivMN6VjB4IRBEK0Y7AMrCKyk8vdG/raA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768402504; c=relaxed/simple;
	bh=h4YJy/CneVD47T3xMYkmJdvIefdtyp1VIstRl/7e6Ac=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Rdz6nIqO7iFy4I+u/Nbrlu81QmxyVXNnR40vjFqcaaKM9XwFcLSbJeRE3elDBOlAEBGh2uAeHL48o8CEX5cWatO2ml2sgQ7xJsYZBZQAALzWJowg0zhmi+FU++rZrgYI0ifJnb/ePeC04MHN51TMJPw/87p1Q7077FMO+aTv2Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JtwL4rGj; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4327778df7fso5502592f8f.3
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 06:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768402500; x=1769007300; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=agy1hHgHoFJQetG4XeQnGSN0SlS/aIGjqLfBNCzpeUw=;
        b=JtwL4rGjif1xI2AxXpE1ycMFjCfVqlFweo89dy+wtjRS48XBEe96tecbe5AdoAz+gZ
         fqeMrCbCMoSVtjORC2JkP6oWlQyxOpZa0CwENubNolsT6+BK7BSLSlamGRabEcsi0PuZ
         Jc6g3MpxwNM9ih6K8refVPHIEROehOS2yC6SKuvceMpqFlU0EZpKKOD3wj7NJI2IZIBD
         kOu56xRH2J2Sh/mqjmL3eBFeEjVfS4HtxGLbKQBaE33ljoZ2gNCn+rSLCgWcA7D09bNO
         AFDchGPL/KLsLCTUOi+NQOqo+BVC8+Y/EGSknxKl11ogsYivZCs0xgJ35nYNyIaGkDAE
         Vg8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768402500; x=1769007300;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=agy1hHgHoFJQetG4XeQnGSN0SlS/aIGjqLfBNCzpeUw=;
        b=Us5Dy1nQxDkd/iTmTkfzRuvzxao/LkPeKOCZctxh27VCLOvmtgsXqTqtpNMXyrK/vd
         rx4NEP8jsAzqfHggaq/ORSjNotTQeFecBDLzjvFUtw5it2dHpEhV/HmWNnVXPiTyXkHW
         b7OTss1xCGTFrpt44R3bwUfrF3A+0AIyHwTG/5m17Fntf7ZcoqnZx9ohx+GdVD1qqKmN
         9nW5Nd4o956TnN2OsyVqyJc8hhQ1wO8FiJ4x3dGVzC8xSjxjCsnyInk0P7eCYNDz5So1
         yXO86rsXM2My1aeoSrAJbsLO3nC28JS+YOhI7dSIkEan6ZP+grWBfKFiiZ30dtJHlIJi
         ICww==
X-Gm-Message-State: AOJu0YyTG4ZJAi7860Tpld3d/XcM8LMTnjqMCYc73fCpGbN/EAIWZ6Ba
	VHp5TNdmX4TFUv6JkRB+gQ3OHxgglZnLJXBpMp+nwn6oyyvAhFEAKeq4CmaCwA==
X-Gm-Gg: AY/fxX6A273jw1spor5Y/YP5wuBeJMlIV2TSjmcAFEZgbvt/ddF6AckcI6vTrQkaDDx
	Mu6SFgJXd69wXzOrwB/JSA4bWkaavgX0OMV/EaUSpEjQrYLT1sVkgv91afMuP83jv/QRTDF++h/
	SNN773hIFASSGFrD2HmddqwPgdmUA8IywVfSeZIFeiKlB3LJU38hXk6xE028j1h87PTRnd3vKbt
	i8SGflpThi8PjPqTYrJv5ge7xPiLpOyWD12593KNzXezTUpkbSwH7MhQYdExXAhStBGGmG3fvKq
	6aymkFf1SJrZbBAwVvFHKYuhvfI0pWJupE8msUQyjehDDm7kBvRDisl/xrM0P6JH+guHGSQezu1
	yzbt0dm7k7kkIgLp+iyMXqdpbeOV22vyeFi0UfEA+61W6Ub6eHjn3680l7Sblos3apxjoLkIW74
	MiosGit9tjKHx8XhVUX6SKqTGfm85qYfjRmsJEerbkcjrfORw9EH88jXbxxHsaIY8WkOPfEwtrM
	rsyxdZuY2Cph4AEb4buwp04EaoxNYJoag9g6vyt3X6Y60A=
X-Received: by 2002:a05:600c:1e0d:b0:47a:7aa0:175a with SMTP id 5b1f17b1804b1-47ee33a1bc9mr35453865e9.26.1768402499638;
        Wed, 14 Jan 2026 06:54:59 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:b3cc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ee563c8bbsm31346735e9.12.2026.01.14.06.54.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 06:54:59 -0800 (PST)
Message-ID: <5f026b78-870f-4cfd-b78b-a805ca48264b@gmail.com>
Date: Wed, 14 Jan 2026 14:54:54 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/1] man: add io_uring_register_region.3
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
 <87ldi12o91.fsf@mailhost.krisman.be>
 <d3a4a02e-0bcc-41fd-994e-1b109f99eeaa@kernel.dk>
 <9f032fbc-f461-4243-9561-2ce7407041f1@gmail.com>
Content-Language: en-US
In-Reply-To: <9f032fbc-f461-4243-9561-2ce7407041f1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/26 14:42, Pavel Begunkov wrote:
> On 1/13/26 22:37, Jens Axboe wrote:
>> On 1/13/26 2:31 PM, Gabriel Krisman Bertazi wrote:
>>> Pavel Begunkov <asml.silence@gmail.com> writes:
>>>
>>>> Describe the region API. As it was created for a bunch of ideas in mind,
>>>> it doesn't go into details about wait argument passing, which I assume
>>>> will be a separate page the region description can refer to.
>>>>
>>>
>>> Hey, Pavel.
>>
>> I did a bunch of spelling and phrasing fixups when applying, can you
>> take a look at the repo and send a patch for the others? Thanks!
> 
> "Upon successful completion, the memory region may then be used, for
> example, to pass waiting parameters to the io_uring_enter(2) system
> call in a more efficient manner as it avoids copying wait related data
> for each wait event."
> 
> Doesn't matter much, but this change is somewhat misleading. Both copy
> args same number of times (i.e. unsafe_get_user() instead of
> copy_from_user()), which is why I was a bit vague with that
> "in an efficient manner".

Hmm, actually the normal / non-registered way does make an extra
copy, even though it doesn't have to.

-- 
Pavel Begunkov


