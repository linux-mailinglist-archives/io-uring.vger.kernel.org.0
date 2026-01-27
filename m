Return-Path: <io-uring+bounces-11954-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YNSoMRYQeWmHuwEAu9opvQ
	(envelope-from <io-uring+bounces-11954-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 20:20:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 20B7499BDA
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 20:20:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 60F13303AB42
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3AF836C0D7;
	Tue, 27 Jan 2026 19:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b7OGg9bL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5596C322B7B
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 19:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769541651; cv=none; b=s9DPEmPg11YU0LV5vEXqadrfxLTXjVJxGLgncxQMyzp4wn3UTk8sFa6vJ+/9B5A8zlV1DDdXGWeEuBfNRN4+WYp099gnjfiGgrC1+0aYUAtJCDirn75xyPS3Nl4rmjNNBG5gbrv2sHX7dcqWNWOAj1lUbhTZd0dtMUDE22prQOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769541651; c=relaxed/simple;
	bh=WN4/nLcSn14d8v7TmB2eqmEF6NNK9K6jkUkRBsCZoLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J/T8vRB8BDk4Tx3ieE1dtg782GjTf9yk87I2NoaLE4AXsdiwzd3bAXRkFy74s+8o92gIJoQZUKWIqxpTWbc2V1Zp/pkqCUsEWLJhcIrdrZK1FjjM0QDk2grL0FuAZAbN5h2AkZg8DkimS8YCeH6d3LhrrZqfuVYp0YEbgDYMTfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b7OGg9bL; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4801ea9bafdso24970165e9.3
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 11:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769541649; x=1770146449; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RNNELjmA7t4CjhlGrI7qDPRy51rdXa6xjB2ziKOJD6M=;
        b=b7OGg9bLbnNkgSEkbJdeWscFZ2EbVaVMTZONFcvdwgNPN9PvH8xHUZKzGFk2HTchmI
         nM/+KHLjT5a5/DX0noQjy1liHCvbVOs+9vAL0oHXRp3id3ESJyP2+7GXTxCPd2H5VLz1
         tzW1qh2mNX3G1FBYkOU5MCak45ymD3X4FBLPVy/X39I/BjtrQaPBEfkevJKDwhOL24dZ
         H1IzXiGcK2qbPuLWockS7o9C/gLZZtngQW8Nm7M3S99toY5VxK3d0zB8K37NvCvL6axF
         Emk3v6mArQb8OosaQnr+U8eX+NgJ2dOnsIO40BAyjYhwnZ3+SeKFOS75+bt2/6b1G/lp
         uuaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769541649; x=1770146449;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RNNELjmA7t4CjhlGrI7qDPRy51rdXa6xjB2ziKOJD6M=;
        b=W+z74tgwQb6LkYV11JEFPozPBmBr6CdMZ/vMB9X4DOIiY0PPG0YZN1o9kNZX5iejIk
         RYZ26GTZpG+kYsCHDkJ2pMUA7FZVrTxy1x851tVGHMLGO8IElBtC5MDUPW8UG9yviFsg
         CgrePtU1AZtB65Obbm3itQwIBPNsanux/hliw0UsIvk3crsDq75AAi78hNO8sMEoEqGQ
         NLJSWpcvjbUBTuLpGtKZM7moHqCYWWFLTaEsnzuN8aOjS885vIinWnRMazjhNmhX3zuP
         NqHmAf+2hNGGZixXBRG6cCiPaVe8gz6dyO5Hr3hhFFXwwgvGSRsLZFXhTtRgprZh6cyY
         Zg2w==
X-Gm-Message-State: AOJu0YzQd4zMUEVtVSw0wpdNhVbu+rYfL/G2zSFvH2wF/mFex6LogT4p
	TG5v3JpoGHDYHNKxlpo4xguozSEbvKaKxDLWfqvKy5oXmj86if9eAac2
X-Gm-Gg: AZuq6aLrhsC5oWRq5ndVWQLCycygmrtJfduvEWOz/eJZfCBBaCArX2LPoI4tpyJVWC2
	JdcV8vdn2eMivYZqhCVOTDXjcp7Xoq9vPDFazEcu6txHHeOle4NryKyCreEEaXw3QR/6837dzM3
	B/HlQOFIqYP4WlvQET/14zTxeZI6brQEG9NZoK54gppqdTV/+2wsUnsZ0UCXtcpnI113O/alfeY
	YYEmFE8JBvwVZSAuIZ+mwlHJwmG9w/QKIoOdsHPzp/S/kAmCjxDxwplf2DAJs4byBLq+GTKZ4JX
	muGtFSBwReRN+TBaDQ1Q4IdTpKSZI2HA8l60FJAihnIvOH8HeVrRSldVmzMqcYD97pkpLtQwxOx
	kthDeXoAn6LH1T3QB1MDIJkyTKgQxyjvhT41g3rINk37mR30bdQAvwewhOXGFMl2o+3I4mlzm0N
	TejDcBTMu/KE+zgC/F8XYSHoCKkk9cKiVL62OCVP2DPMmH6t9pc8TlI4t1BfqTw+d/+Wm1CrdPO
	96+kREL2rG+JpKufxOCYwpyfAJ0sjiVGBHo6352OJDhiobu8GB4uKSQkkCikC0JxQ==
X-Received: by 2002:a05:600c:3b96:b0:47e:e4ff:e2ac with SMTP id 5b1f17b1804b1-48069c60317mr42538605e9.33.1769541648637;
        Tue, 27 Jan 2026 11:20:48 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48066c37420sm87008175e9.9.2026.01.27.11.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jan 2026 11:20:48 -0800 (PST)
Message-ID: <8b2cee27-e6ac-42fa-bf9a-38a1af39b0dd@gmail.com>
Date: Tue, 27 Jan 2026 19:20:38 +0000
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
 <a61a73b4-01bc-4547-89de-7d70b0c86477@gmail.com>
 <CAADnVQ+w1OEm7gFb04u6V=5LVw6VefNr_V2FuczBjtaOioH=Cw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAADnVQ+w1OEm7gFb04u6V=5LVw6VefNr_V2FuczBjtaOioH=Cw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11954-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: 20B7499BDA
X-Rspamd-Action: no action

On 1/27/26 18:53, Alexei Starovoitov wrote:
> On Tue, Jan 27, 2026 at 10:42 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 1/27/26 17:32, Alexei Starovoitov wrote:
>>> On Tue, Jan 27, 2026 at 2:15 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>
>>>> index 000000000000..7a170cb2f388
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/io_uring/types.bpf.h
>>>> @@ -0,0 +1,131 @@
>>>> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
>>>> +#include <linux/types.h>
>>>> +#include <bpf/bpf_helpers.h>
>>>> +
>>>> +struct io_ring_ctx {
>>>> +};
>>>> +
>>>> +struct io_uring_sqe {
>>>> +       __u8    opcode;         /* type of operation for this sqe */
>>>> +       __u8    flags;          /* IOSQE_ flags */
>>>> +       __u16   ioprio;         /* ioprio for the request */
>>>> +       __s32   fd;             /* file descriptor to do IO on */
>>>
>>> 1.
>>> No need to copy paste. Just include vmlinux.h. It's there.
>>>
>>> 2.
>>> drop KF_TRUSTED_ARGS from kfunc. It's a default now and this flag
>>> was removed.
>>
>> Got it, will change both, thanks
>>
>>> 3.
>>> add a runtime logic to check that the return value is either IOU_LOOP_CONTINUE
>>> or IOU_LOOP_STOP or instruct the verifier do it statically.
>>> Otherwise it will be less convenient to extend to other commands,
>>> since the way I read it IOU_LOOP_CONTINUE == 0 aliases to any value > 1.
>>
>> Is there a struct_ops hook that can help with that? check_return_code()
>> has some hard-coded checks, but I can't find anything customizable for
>> struct_ops.
> 
> yep. check_return_code() is the one and you're correct. It's not
> customizable atm. Much simpler to do a runtime check for now and
> improve through the verifier support later.

Makes sense, thanks!

-- 
Pavel Begunkov


