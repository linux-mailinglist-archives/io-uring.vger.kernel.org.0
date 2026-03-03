Return-Path: <io-uring+bounces-12543-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MH/8MLeipmmvSAAAu9opvQ
	(envelope-from <io-uring+bounces-12543-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 09:58:31 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E4721EB57F
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 09:58:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C409D304001A
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2026 08:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C56388398;
	Tue,  3 Mar 2026 08:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SrcXgZWq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618C237BE9E
	for <io-uring@vger.kernel.org>; Tue,  3 Mar 2026 08:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772528307; cv=none; b=WkRPHK6AkfWs0A0nHf78tIgqu+kSN3e/tMOhepwzVirfRD5b20K6LfcSCTBodjwEzPp3ddbTSPvVZYynfz5/7wdly7QcvF2FXSs/8Muok5/81mI17icrYthYJb3f0FdUTmSEYaAh8HZTlmTQ7pHPl5VPseB232tVeSLGe5r+xRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772528307; c=relaxed/simple;
	bh=1WVbFhutD27rrb03/52SLt7Lb/PY8lkcXPFWCUYrHz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=INJKn3UuV5qWmIX4cww4RGg4LOQ9CyD25TLr4QlZeN509jeSTEkWV+ZMDatEDloYFF2hOM3c18FKmalcRXD9lF9KffR0vIau8XEyJg6z9th93Nf/eRALL9LWcB3F78uuV/jKN/6Zf0+tzfDatuXU07gTfydSzZndpbNNP7RQhIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SrcXgZWq; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4833115090dso55635105e9.3
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2026 00:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772528305; x=1773133105; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wa1rSUI3Fn0xYaTgce3G21N32tpHZUVjSkWm6M/ojnM=;
        b=SrcXgZWq7hfRzNF+ke81E4uqBAPXVQbjdFFgH628AO5NckUP/6yMGdTvtR3rIFKNbQ
         /JYV/PYVaucTHOfVSWCsNd4PWCe1eF4Eu1+y7XagAjDF0hVtOrIdglNlS8QbDcBg1ZEl
         JdAZWcWsp+N++zY5d5GnAU6JoNeHBjZFQuaAcM+goBPGjWesit50L81QgUzgWoKUBisl
         UxDPU6ujSa7Nus8VS/+cwmHTkdNNi02OWhMN+7fIQahF/FEvpPv7zK6WZBc3Fwe6Xh1C
         saYlf0IOKx+39966/YVsx1oJTRQpfmuYs0vtXD1J7XtpDOVSDRmZf8E+PiB4ScBaSZFS
         PDig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772528305; x=1773133105;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wa1rSUI3Fn0xYaTgce3G21N32tpHZUVjSkWm6M/ojnM=;
        b=Q70+lPoRLYY91QPQLlLrI87Rc+C64MbESjft+T3URVQ0OUQ1ReF7rapYJRACi/mj3z
         GuImY8/HQrtBVlntsAoSZWZ0QweoQqfWmrsSSghUmnvpoYaNJj7BAWkN889A/opybVdt
         Lbk67k1Ix4brK3dcFQbXolfIoJc3olPO/bnjVouBXFeaLAIcI0bT2jkCRanT59k+XQHT
         Gee1Lq6tteM92+16e48CjFRvmv3YEja0Ze9TXiIiZRSKLCY5LrDomWbnar+B0TgHJrcX
         v1V2/FcAxtgZ4La9gqaTraWuNsjNXvAZqmZYHI1RbO8sR95l/vr3Wh8E/yN/evWIQt/a
         MRqg==
X-Gm-Message-State: AOJu0YwKbXuPb6zHmf9ZT/7603g0igt+NBy0Ckf2nNp0I3ojVAo8F1ka
	ByuLxdJ0KPTRM5iWG3yrcknWOlvKs+YJT5h+dTZEZgJWt7F2sfaM4Jmk
X-Gm-Gg: ATEYQzzClH0MKekM8Il/gwcFM5i1l6Fu7VapiC9DjPHZzI2KaBmxYJAmPHbEq/Jikgd
	mVKRJP0guJ6LuU6OYE3SisMPjekK6pcL4hBdzi0xymjVkRWNG490ZyX/leNRtvzqOUdS9VYuXmy
	hOWD1IJj2jC6otenPZTvF1lLNgmd2YtbuS5dx1d5+0IyjguQs7VgcdMHYEyArD2Q43BhfgzCqiI
	LpiUAKmXpmdKjZYXgrN92KLyvozRYotbEkixFICa2+i5InNluG7zqN4NLWiF3Etb4DxF5EMZTV+
	9pKPZaqtPAn62noftBzAhG+Zka/pf97UBOghikOlcZhSgcWI9QWU0BPSYgGeEZ8tNIbrC5QjPlq
	yahXcHVnfd6dqcQBMb4+PBEtlEjfBZUxAG51NNrd0Pi/UTxl5sGfmysIqEtHzautKIzNJAkIEuB
	Ubgr6oYwV6ws8EyNTk/7hXG+xYKZ9eJcKvR0/+KAlDpWFxY69segU24al8Ti0fwZIi29HxJVws9
	13Nzj/I1Xhk6K5CmJEYrR3Vw38tYurXlEYmJ50qsJn9/+OM/4xpOgY8rZB3ms70BqMYOiTHvvcd
	jg==
X-Received: by 2002:a05:600c:8b12:b0:483:71f7:2794 with SMTP id 5b1f17b1804b1-483c9bbbe39mr280778065e9.15.1772528304472;
        Tue, 03 Mar 2026 00:58:24 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485135d0676sm13620685e9.29.2026.03.03.00.58.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2026 00:58:23 -0800 (PST)
Message-ID: <83689510-1ca6-4429-968c-656031cd1675@gmail.com>
Date: Tue, 3 Mar 2026 08:58:21 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix post open error handling
To: Greg KH <gregkh@linuxfoundation.org>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, netdev@vger.kernel.org,
 stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
References: <ae4f2296e2c33bb65ef2a1487b120033879e493f.1772489730.git.asml.silence@gmail.com>
 <2026030215-appetite-drastic-5894@gregkh>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2026030215-appetite-drastic-5894@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3E4721EB57F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12543-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/3/26 01:47, Greg KH wrote:
> On Mon, Mar 02, 2026 at 10:15:43PM +0000, Pavel Begunkov wrote:
>> [ upstream commit 5d540e4508950c674d6feef1d95463d039bbf4f5 ]
>>
>> 5d540e4508950 ("io_uring/zcrx: fix post open error handling") fixes some
>> post queue open problems. Instead of picking all dependencies for that
>> patch just move post open error handling out of the way, so once a queue
>> is open we can always report a success.
>>
>> Move copy_to_user earlier before open,  and xa_store() should already
>> never fail as the slot is explicitly pre-allocated.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/zcrx.c | 20 +++++++++-----------
>>   1 file changed, 9 insertions(+), 11 deletions(-)
> 
> What stable kernel(s) is this for?

6.18 please

-- 
Pavel Begunkov


