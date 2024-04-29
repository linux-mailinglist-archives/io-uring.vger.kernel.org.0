Return-Path: <io-uring+bounces-1669-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A208B5DBD
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 17:31:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE8D7B27AEF
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 15:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DFA782C7D;
	Mon, 29 Apr 2024 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WAs7O6n1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0211183A14;
	Mon, 29 Apr 2024 15:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714404283; cv=none; b=RUybFP4D4o8fHZOYfYe6PydcsYln+sF/EsZhBIHk7IQyg1uUeRhx9ubsatiklMqyiW1MVh4baDYBQW/eTIkwSdpuP5KtNxQJR4chy2DEp19bN6qZUp9VdJ0uj0+VZPC/g6WPkJVGKruv+AMgjPlB0hAlbh/3BlNulnYHVoy6ie8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714404283; c=relaxed/simple;
	bh=Pj2cwpnZJNOaiRDHglRyWPI0gH57KB5SIi8FNggw4Rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gwOByfTapc0bTomnfT84ZzdKaXM1e41zWo/fKhFmH+EpRRU84ug0CyfigIEO2s+5V/K3IJEMQMn+2wHauPHT86BRW/ozxScib2h8z7zh2UBAUleuijA0jTJ//lyRdYDIEYwlfAMqNaJWZE+eZnDCmoZWbEclCYyJgpV9pJgCSKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WAs7O6n1; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-41c011bb920so8867405e9.1;
        Mon, 29 Apr 2024 08:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714404280; x=1715009080; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zPLSYoop8c6nPwVtS/cJ+4UmU3dkqJbn52js0JYU+7g=;
        b=WAs7O6n1IcpbnQi7EWutzHO+AFIPrNrjsd5xyj8BYAQL4xqqM2AVjn8OTDU5fhNs82
         Xhq7FtSmoRktZZRqd2l7ftspq7Yn3g3M4iT82rhR+Oq+dGQaqffYg/t42E+uKqEBP8sN
         DjUMv9DmAMoZId2BGilttgK6agVLs86DYtLAfb3mvNWnppjW4sZFrv/zEEwhqQn+Glph
         ZG/xDEDBzAAoxWzZrJmRgMy5Jer7j6qlkvpef48h4JrmDG8yQPThuhR4uVRC3T7reo85
         Mos67QwCodkml+DCHxAXkuv1SsdTQMst/fJR52MN4/Xo9pPtnhqSRXyKlFCd6ex/B6jr
         VvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714404280; x=1715009080;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zPLSYoop8c6nPwVtS/cJ+4UmU3dkqJbn52js0JYU+7g=;
        b=TLzsZKJSUt1EG+93ZCskO+ntb3QJGpcQb08eumW0TZEUxvweu5G/R8fyYY9Ta80WEX
         hyizt62GkTtUztLmRgvEl0NP47yw9tKchbOkqPcFYlMti/mixf5Z7UVo7gHj5bhawj3G
         LaNh/tt7GGlykiNWpx3EfAjVhOjrqRQCdlzBk1Im43gpMHXobsjNDborpbErJbChIXpJ
         qc8AppMn7RJBel55QMtjhCZjX3Hk4PMaPUAAy9Q8VfcTLamSsebyCJ0Hzz6SyRrrWOq6
         qcAkkBrnL4zqMcvYDZIi9p3q4+ZSqNtYqhMQ0hZwwWzDBqI2A6+kKbm8M6nOk1G96ejT
         4j9w==
X-Forwarded-Encrypted: i=1; AJvYcCWdveAP9wcyC1BnKhX1CH1kNGBvn4ZlzSV9+w6eofLl6pVaX9kyM8Q1vX4Pb3Dh4HtlKAp/qWz9xhhgmPpqPuxI+RkbFsff9ej5zcE=
X-Gm-Message-State: AOJu0Ywk0Vl+QHYkL6W81LnF5+ukHI4goPy5RbZ64jg/rJX7N9f1Eqmp
	WIvbKuRw7vkhRGbsohjzilfnGHSF7tUyIZ72MGdKQMvJavaB8vfh1iGfdA==
X-Google-Smtp-Source: AGHT+IHnNKwlepaORGq+A1W0g1h8aBUd05TlPcGBYP+FwQpA/Crid1bLmY+CJ5oU/F6QPNA7kTVxrg==
X-Received: by 2002:adf:ffc2:0:b0:34c:e0d6:bea6 with SMTP id x2-20020adfffc2000000b0034ce0d6bea6mr3697488wrs.29.1714404280157;
        Mon, 29 Apr 2024 08:24:40 -0700 (PDT)
Received: from [192.168.42.252] (82-132-212-208.dab.02.net. [82.132.212.208])
        by smtp.gmail.com with ESMTPSA id p8-20020a5d48c8000000b0034af40b2efdsm21643907wrs.108.2024.04.29.08.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Apr 2024 08:24:39 -0700 (PDT)
Message-ID: <e0d52e3f-f599-42c8-b9f0-8242961291d0@gmail.com>
Date: Mon, 29 Apr 2024 16:24:54 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] io_uring: support user sqe ext flags
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Kevin Wolf <kwolf@redhat.com>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-3-ming.lei@redhat.com>
 <89dac454-6521-4bd8-b8aa-ad329b887396@kernel.dk> <Zie+RlbtckZJVE2J@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zie+RlbtckZJVE2J@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/24 14:57, Ming Lei wrote:
> On Mon, Apr 22, 2024 at 12:16:12PM -0600, Jens Axboe wrote:
>> On 4/7/24 7:03 PM, Ming Lei wrote:
>>> sqe->flags is u8, and now we have used 7 bits, so take the last one for
>>> extending purpose.
>>>
>>> If bit7(IOSQE_HAS_EXT_FLAGS_BIT) is 1, it means this sqe carries ext flags
>>> from the last byte(.ext_flags), or bit23~bit16 of sqe->uring_cmd_flags for
>>> IORING_OP_URING_CMD.
>>>
>>> io_slot_flags() return value is converted to `ULL` because the affected bits
>>> are beyond 32bit now.
>>
>> If we're extending flags, which is something we arguably need to do at
>> some point, I think we should have them be generic and not spread out.
> 
> Sorry, maybe I don't get your idea, and the ext_flag itself is always
> initialized in io_init_req(), like normal sqe->flags, same with its
> usage.
> 
>> If uring_cmd needs specific flags and don't have them, then we should
>> add it just for that.
> 
> The only difference is that bit23~bit16 of sqe->uring_cmd_flags is
> borrowed for uring_cmd's ext flags, because sqe byte0~47 have been taken,
> and can't be reused for generic flag. If we want to use byte48~63, it has
> to be overlapped with uring_cmd's payload, and it is one generic sqe
> flag, which is applied on uring_cmd too.

Which is exactly the mess nobody would want to see. And I'd also
argue 8 extra bits is not enough anyway, otherwise the history will
repeat itself pretty soon

> That is the only way I thought of, or any other suggestion for extending sqe
> flags generically?

idea 1: just use the last bit. When we need another one it'd be time
to think about a long overdue SQE layout v2, this way we can try
to make flags u32 and clean up other problems.

idea 2: the group assembling flag can move into cmds. Very roughly:

io_cmd_init() {
	ublk_cmd_init();
}

ublk_cmd_init() {
	io_uring_start_grouping(ctx, cmd);
}

io_uring_start_grouping(ctx, cmd) {
	ctx->grouping = true;
	ctx->group_head = cmd->req;
}

submit_sqe() {
	if (ctx->grouping) {
		link_to_group(req, ctx->group_head);
		if (!(req->flags & REQ_F_LINK))
			ctx->grouping = false;
	}
}

-- 
Pavel Begunkov

