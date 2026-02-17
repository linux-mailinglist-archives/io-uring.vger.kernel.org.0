Return-Path: <io-uring+bounces-12295-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id b7YfBkyDlGlBFQIAu9opvQ
	(envelope-from <io-uring+bounces-12295-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 16:03:40 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B59F14D5CC
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 16:03:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 69DDC300D15E
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 15:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14A65322B8F;
	Tue, 17 Feb 2026 15:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mmwc5sf8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ED5212FB9
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 15:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771340616; cv=none; b=hVwCW9aRpWAJn4/TLbc4xPaFuf3dnFHEKyZ42LC2WlXetspJFYW6dAIxfqXUM6nrMwM+KhcsfW5o5zNEMvqf1f1HINaIiDwCfO5s+usA1OPBh7lwgwuQuPYPISfbbv30qUfvFpKCicA9KnAHa5ogT9VYfyK+6qJ9jF3yvx44Roc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771340616; c=relaxed/simple;
	bh=HJt4uT8mnHdCoUepQgPMGhxV0Eim9bBLIViEmzvxJJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t53Nzfhgg3EEM7SlRC4TxM4Iyv2U2BorPDeKxHw5THnwg7HxpN0hCLqLSF47s5KvtoPVqOVOqMoVLzpKplf2Sk0FZ47HXTprOy7Or0nPUv6js4fyC6bWhgrXIJnO2YxFqZggw8mYIOFBmnpwNzSVqvMCLjq1bliowwawKGZuT0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mmwc5sf8; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-482f454be5bso59486355e9.0
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 07:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771340613; x=1771945413; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CoKrUnw/hm9fZDbLUXlK9dLLM9tNxZDuYMfQGYbF43Y=;
        b=Mmwc5sf8tVjBB/92aZggviqJ3MEfWM6fAzJlhfFZcGlTC5wl6Mp1bMPvcsorgNuVqu
         Ohfmhy8x/KTO0Ky1N0G81je0hMjhJT2Vvhr6Y5iNPgGgtwQatgAkbei9jMyVionQ1P7W
         P3X2Nj+rewMqAOCZ8wDJkE2DqlRAejrYimi5LcGJOzfo/HkA/+MUtFGm3pRG+QeGFfwE
         XFaV/3Fk0EKCk4yXTSA+snqMS35K3HW48FA1myB8Nm5WpNGa1gMsdXZ5Hx2wBmcT7Jb/
         0TEalXNj6jBZFVOcpefjoFqPkQ3zOMCJuvV0RZRO8cn1HS1g1nrJ9z9FfU345RJXARDO
         O/uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771340613; x=1771945413;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CoKrUnw/hm9fZDbLUXlK9dLLM9tNxZDuYMfQGYbF43Y=;
        b=ImXaBt5KDwgrOm4M91cRcCE2KgQvtQlst/ZbkRrm5O7JlBekad7jLOFLldX2+z0Zj5
         mfLaYiax3SwktKcm2rUwr2++TuYIW9OAFRzGphbxftiUORzU4fzNfqwB7K6DuJpPW2r+
         kdPWbZ8nL89PsJ6sVDMqmB3CMDGL3qSrXSERfwkrfhXdtGq9IKCxMRtE6QeRnnNK/bJP
         fowi/JHcLHLX9XvC2nmLxkRyXKBJbbeIj19ytoIXw1jljzbdF/MTMGuuy6lsbbzCB8/k
         AgJTUJdV2k1EQGrqoSoesre0wa8Mrthg8cwY26kG3cURzK/3XTQhwwRfaXAgETmPiPeX
         PjSA==
X-Forwarded-Encrypted: i=1; AJvYcCXKSytG/K44BTOt9z6jeXfnDE75YYPMu4U0BdDTiWjpsxF/pQDxC7D/WHFM89CF67qCNKCsVwZ+pw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHFV9mPCxiyKUojYU+A0rsCx6iVot0PWtqmPbl6L/6vd+uSPeB
	3LurAf6evJtOrQO0+4YzXz/UB4xNcvP9ByAApRXChUURfm4UnRwfJrKa
X-Gm-Gg: AZuq6aIiFovQVnJpMOhas2Dz1zMKJIktVwI1vf209t4byHAe2HF7tk/ZhqKMGRjFX92
	owTjdZHrTl7JFvvcCPeFnyQ/pMgNL8xroCkPwobeObJwunPX23Tr92y5YcePMl+I0jwJ8o7balI
	sGLHf1qz9mExqZ5g1oEZI8CWjhsyjumnIZ8Oc1CejORHA379yWJodStbQ5iusYyrt3NHVousuQR
	FeuGd8oVFs4sOjm/sqXlYFbX9Zenzwpn238m8TTidsIFpOcUGA/WPDwuEpbqV7Uyg2WP6ekn7Bu
	E3M338/mjR09Q0GBJ5exYnC3UzJS47WJggWS26O4WjXu1lkD7hlnDrdg6uqlDeS+mMIGfaOAnRb
	9b8882XmbMwMadR2giHQgMdCo2l3DruYpr68doKHoEix5j+0yoOy2gzTMoN4a96mt00crQjkXPx
	gLlaPvjgJv7wonolm2AQ7vrWXxTE5tmdovfSCfhjCVM3zhA1V1TSsNr9SDQ29KlKrZu/D5mzx/b
	nwhGDdn6GMjd4NZTX8yKuh5x7/vpJZn1VhRgi++tAgbWbx51ODJvoOhdZeLGftazBkTCk1BzOKM
	OxWrRQ==
X-Received: by 2002:a05:600c:19d3:b0:481:a662:b3f3 with SMTP id 5b1f17b1804b1-48378d6bc48mr204178805e9.7.1771340612589;
        Tue, 17 Feb 2026 07:03:32 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48370a5f4fbsm112622685e9.8.2026.02.17.07.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 07:03:31 -0800 (PST)
Message-ID: <5eeb233d-74e4-453c-ad18-f30382dc44e7@gmail.com>
Date: Tue, 17 Feb 2026 15:03:28 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/zctx: separate notification user_data
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Dylan Yudaken <dyudaken@gmail.com>
References: <d099d8d0d7526e4eb59f5ffd0e890888a46b21f7.1771242479.git.asml.silence@gmail.com>
 <025de231-a6d2-4fa8-91e5-f4ab81d16e7f@kernel.dk>
 <5fa237b6-420d-413a-b7b5-9f85d9f1e8ba@gmail.com>
 <64ab6b3e-3746-4076-9c0b-b2edc2de92d1@kernel.dk>
 <69a2d3ce-5c77-44f9-99be-1b558cf4c4ca@gmail.com>
 <fc217246-2397-4ae4-8354-7ed0c498d23c@kernel.dk>
 <e59d8887-d908-463b-ad31-3bf10d977de4@gmail.com>
 <133c27e8-7b5f-4754-9f8a-17d96e736621@kernel.dk>
 <3888d916-259b-4d1f-96c2-157c289d867e@gmail.com>
 <fd6ac244-40ee-48e1-b41b-d4d78839fe72@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fd6ac244-40ee-48e1-b41b-d4d78839fe72@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12295-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: 7B59F14D5CC
X-Rspamd-Action: no action

On 2/17/26 13:12, Jens Axboe wrote:
> On 2/17/26 4:15 AM, Pavel Begunkov wrote:
>> On 2/16/26 17:27, Jens Axboe wrote:
>> ...
>>>> There are already 6, it'll be 7th. I also have one or two more in mind,
>>>> that's already over the half. The same was probably thought about
>>>> sqe->flags, and even though it's twice as many bits for net, those
>>>> are taken faster as potential cost of redesign is lower.
>>>>
>>>> Fwiw, the code is nastier as well, more branchy and away from
>>>> other notification init because of dependency on reading the
>>>> flags.
>>>>
>>>> @@ -1331,7 +1333,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>          zc->done_io = 0;
>>>>    -    if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
>>>> +    if (unlikely(READ_ONCE(sqe->__pad2[0])))
>>>>            return -EINVAL;
>>>>        /* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
>>>>        if (req->flags & REQ_F_CQE_SKIP)
>>>> @@ -1358,6 +1360,13 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>            }
>>>>        }
>>>>    +    if (zc->flags & IORING_SEND_ZC_NOTIF_USER_DATA) {
>>>> +        notif->cqe.user_data = READ_ONCE(sqe->addr3);
>>>> +    } else {
>>>> +        if (READ_ONCE(sqe->addr3))
>>>> +            return -EINVAL;
>>>> +    }
>>>> +
>>>
>>> I think just remove the else part here - addr3 is valid now that
>>> IORING_SEND_ZC_NOTIF_USER_DATA is supported, and if you mess it up in
>>> your applications, you'll find this via development anyway. Since addr3
>>> == 0 is a valid value, it doesn't make much sense to check for it being
>>> non-zero.
>>
>> Gating it on a separate flag but not checking when not set makes
>> it only more confusing in terms of why would you do a flag in
>> the first place.
>>
>> It's not like a flags field where any value set would be an
>>> -EINVAL case. Doesn't even exclude having another flag for using addr3
>>> for something else anyway.
>>
>> You can override the behaviour with another flag in either case,
>> but realistically it's better to avoid as it's always messy,
>> unless the features are clearly exclusive.
>>
>> I know there is no way to convince you, but v2 already degraded
>> the uapi as per requested, can we have that one? The "else" branch
>> doesn't make the api worse, on the opposite.
> 
> The else ties into all of it though, as it perpetuates the "user_data is
> zero is not valid" part. The reason we have the addr3 check in the first

How come? If the flag is not set, it shouldn't be user_data and
the kernel shouldn't care whether the user assumes otherwise. It's
a general unused value check, and it is unused exactly because the
field doesn't have any meaning put into it when the flag is not
set. Same way nobody argues that sqe->__pad2[0] shouldn't be zero
checked because a user might mess up the ABI by accident and put
some user_data there. It'd be nice to be able to check if it's
"set", but the best I can do is the typical "0 == not set".

> place is to have a way of saying "this field isn't used for this opcode,
> may be used in the future". Now it is used/supported, and I don't think

addr3 is not used nor supported in the else branch. You'd allow
users to set addr3 without the flag, but what behaviour does it
supposed to achieve? Just ignoring doing nothing?

> we should be checking it. If we end up with future flags that also need
> addr3 and 0 is valid, then it'll end up with more checking for that,
> based on which flags are set and which are not.

Or it can be used without any new flags when the user_data flag
is not set, assuming it can tolerate the default 0.

> The patch should just be removing that addr3 -EINVAL case, and adding
> the two lines that check IORING_SEND_ZC_NOTIF_USER_DATA, and if set, assign
> notif->cqe.user_data from addr3.
> 
> But I object to saying this is a "degraded" uapi, to me it's very much a
> better one as it allows all values of user_data, rather than have some
> magic 0 value that's not valid for no other reason than force policy.

Well, we clearly disagree on that one.

-- 
Pavel Begunkov


