Return-Path: <io-uring+bounces-11952-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2AnoIScHeWlrugEAu9opvQ
	(envelope-from <io-uring+bounces-11952-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:42:47 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E2A8999496
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:42:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D1A3F302306A
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 18:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477B8328B72;
	Tue, 27 Jan 2026 18:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HXeshiST"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43822328B58
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 18:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769539362; cv=none; b=qfUKhxkUJzXdL2t4Smc0cxU4/KrrXYEi1enVdqnyOURIv3A0aFIr+0neck4ZLQFsI/y5576Gw8TgMW2T/siSAEQ8MUMZPN4ol2Gi2JGvt2oYI3eI686IgfqTviyR17fbkq2sWr3GQmcJ+0PLhFYggAw4BINm78NbvuyDy4Q7ncw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769539362; c=relaxed/simple;
	bh=wFzLu3MBEJzskcbgdlN7e4gWlGRm5+p4qZvnJBX8CNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l0SichMPY8IoIwWkbrLnnpf+Pwmknigrrxj4UANcU977vciYSWPDE/eAjV28xdLoLR7rQ1OEmJ9eroLcTOC9fK/I3+UOHeI/z+hjujHYDeyXq9zuEvYW91xrFGCNtyPODVxuryjMphmTbojKuEHNfmjpYDWOhLiSr/qCfYDpDqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HXeshiST; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4801ea9bafdso24850535e9.3
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769539358; x=1770144158; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o9ZuXtZ9PMapguvR1sUXaXbSM3pScxlllWbzjAEYBR8=;
        b=HXeshiSTyP/Jf99KtVOEkIMPhC/NIrXMQM9w58TRTt1rJv3kR2JWCdJX4ABx2pwOxB
         3DE8MM/gn6ARUMWg+i6kgHGJ6EJ3AYTW6ypNpXen3gdxkIsQKsuVoHKJm6ulRg1y/lR3
         6o6ItC7Uc/yJz9bYXzp9G1SSl6ajcWMK5ghTyuUBd/KlKVsZUb87tRr00WwND4HBejtQ
         O83vYkvJAQ3C2P8bTg49qAXCi0qcsT2MSae8kMy7gUVyjTD95OFL92Jg00SAXL25q9QV
         vfJDBHnPhdUl5fvDSO226tEMjtnDrgro7/nSX1JCyU3Xty8gaNBNBvO9VGY+XHox58rT
         OdBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769539358; x=1770144158;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o9ZuXtZ9PMapguvR1sUXaXbSM3pScxlllWbzjAEYBR8=;
        b=h/dXbm8eVQ73OnOentoJbtTStdU3juv4EWB4wOfxR+TEwuFE9idWHtGbFA0xuIQlhs
         0oSHpD13XIDvZ9zQAYpGW91MWwesEhetD0GhqX6xhP6kUatvXPL87njeEjCvem54y1LQ
         sUgiNhbBcYFe/uKkUyEGSpH0VGd9x+ogO9utQWE/dtig6QF46mJUdxDFebHe2UYoRAPL
         0nmftqME62Cpc8xK8+xJhVKS1TVlHl2s5/f5jmZLA1ienKYX2QWmWGpeCPIE3yvVZW05
         LQBNbhAYvzz5DNv+ZHI3hK+vuH/x39DePqzsane00g1hul2z/1zTUkaKI3/bL7sck1SS
         SdbQ==
X-Gm-Message-State: AOJu0YxuvyXX98JCEZEA5qBqa12VkeJu7syBk7eJk9Emv1QonmI6rrSc
	0cm2J2i62pf6FyE1He1N5hJU2wJhEt56VLZseQxrTna7ACYDp3EaSK5l
X-Gm-Gg: AZuq6aKVzpG6eW8z2innNnQsE5xZ6hYww1+nsSXFjcmOEa7SmT47oqC8eQh0dl+sHwn
	P5e/P4yfeeYayzHPECYhg43+XzKIPvbPx3+EBKYYWDfccLnnov4OLTrJiGw78qBJDIeE2BTMEfI
	3sxPulEnhj5kQqrF1DJ1HzvwuBJzxvae/3uQnJmIRPty1rceEtNCx5wP6ja5pBakHX22Y4ox7vZ
	74VDDz4sktrKZYIwpSVTH6vt4DkMuV5zjhye4xzbgv0uG4UKAh/apnzh8QODP+m1kYKRaC0+a+a
	40QBBNMp88IzsE4fR+eWoHhYDRq8zYOEolUARDm4HXM1IXUVZAx1I3s2SLUPu7cjM64rEpUKPJH
	k6NjFWRq43aF9QGWf17XlLoKcNOPXZLw0gGR1gXGQBR2/tqWj10sZtOE8DCTIUpIuIm/uXCSrJR
	3AY7PMJwidmnLwirck2tMI4xsA5xcHoLVw9MObrqYHw5AYprveNBs36LU8Hvir7ymURelIfliFD
	lD6/giF1fUZIGRstRUbelGH6O92t+a75MmCLpJdp+BN0p4Y1UtZ6AdUvNOCty2Bpw==
X-Received: by 2002:a05:600c:3b19:b0:480:6852:8d94 with SMTP id 5b1f17b1804b1-48069c54d4dmr27946635e9.27.1769539357798;
        Tue, 27 Jan 2026 10:42:37 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48066bee7d0sm80440745e9.4.2026.01.27.10.42.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jan 2026 10:42:37 -0800 (PST)
Message-ID: <a61a73b4-01bc-4547-89de-7d70b0c86477@gmail.com>
Date: Tue, 27 Jan 2026 18:42:28 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] selftests/io_uring: add a bpf io_uring selftest
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <cover.1769470552.git.asml.silence@gmail.com>
 <b766b428ec90862d69c9ab843dc89b6d0a017628.1769470552.git.asml.silence@gmail.com>
 <CAADnVQJcoyJ1hmU_oUcjj=8ewPAPTOZ8eccTutSJWHFy2Xza=w@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAADnVQJcoyJ1hmU_oUcjj=8ewPAPTOZ8eccTutSJWHFy2Xza=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11952-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E2A8999496
X-Rspamd-Action: no action

On 1/27/26 17:32, Alexei Starovoitov wrote:
> On Tue, Jan 27, 2026 at 2:15 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> index 000000000000..7a170cb2f388
>> --- /dev/null
>> +++ b/tools/testing/selftests/io_uring/types.bpf.h
>> @@ -0,0 +1,131 @@
>> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
>> +#include <linux/types.h>
>> +#include <bpf/bpf_helpers.h>
>> +
>> +struct io_ring_ctx {
>> +};
>> +
>> +struct io_uring_sqe {
>> +       __u8    opcode;         /* type of operation for this sqe */
>> +       __u8    flags;          /* IOSQE_ flags */
>> +       __u16   ioprio;         /* ioprio for the request */
>> +       __s32   fd;             /* file descriptor to do IO on */
> 
> 1.
> No need to copy paste. Just include vmlinux.h. It's there.
> 
> 2.
> drop KF_TRUSTED_ARGS from kfunc. It's a default now and this flag
> was removed.

Got it, will change both, thanks

> 3.
> add a runtime logic to check that the return value is either IOU_LOOP_CONTINUE
> or IOU_LOOP_STOP or instruct the verifier do it statically.
> Otherwise it will be less convenient to extend to other commands,
> since the way I read it IOU_LOOP_CONTINUE == 0 aliases to any value > 1.

Is there a struct_ops hook that can help with that? check_return_code()
has some hard-coded checks, but I can't find anything customizable for
struct_ops.

-- 
Pavel Begunkov


