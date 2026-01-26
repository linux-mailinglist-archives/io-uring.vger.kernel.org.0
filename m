Return-Path: <io-uring+bounces-11923-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0IKfK5Fhd2n8eQEAu9opvQ
	(envelope-from <io-uring+bounces-11923-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 13:44:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 154CC88694
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 13:44:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9E82230265B5
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 12:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDBA630EF63;
	Mon, 26 Jan 2026 12:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wXxXFoqX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC842FBDE6
	for <io-uring@vger.kernel.org>; Mon, 26 Jan 2026 12:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769430992; cv=none; b=Tk7qjFILaod8pcBbWDxE3WuFK+/cIPd9xfGux5/nQX7RkpTcdcyszQo0dZmRFhqNLpQfQ+geMWpAvsU/yhDHLDCwSvQi2lD9bxnkvUbks0hjR/+QaLLLw5wYPLiCckktoFf5bVsrbpxGy6ZLXm+1aobslP7f8heUh0JD8NQJKvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769430992; c=relaxed/simple;
	bh=zAkMz6oveNazEakokAmG8bLQ/Fx2b7AQ/ahjevW/c5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k6ImFfAK2j8YIabZktP9sIcfjD9xci8oWZXS2nIyYzlRM3ez/3zj5lpNDyyqV65H1IZK/C6IXx/+RpZeR9PvZS4P+75fQ1xOsoBALklpiGsDFqzlUw7SrGE0hHfoQMsiihM619ayr3xMz/37q+4mc+1eMn4PKLFXkChsPWY3PvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wXxXFoqX; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-404263bd58fso3234326fac.1
        for <io-uring@vger.kernel.org>; Mon, 26 Jan 2026 04:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769430989; x=1770035789; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zPB/SYfzf+cP9VaT3HQWyX2iAkItRsWtTDmJ8NpaX+Q=;
        b=wXxXFoqXa88kp9m4rK4puvTohm7Zn/fyEyaFROM65rZyCD7wA8jsOZgq5iB6z/kVXK
         OIIBHDaNoRcg24C8zJW9Eag91eNSCRyIn88wN4D104MXJ4FN0d757RYdhjizWuKLiZQa
         MFUAKmKDTf3V2XMPsT4KKfCfO1e6Ug8bcoN2lTU+8QSIcPK6rmLdAeCk38Etruj9n6FY
         niRCs6h5kTUR/IqWDn/i65xuc5wlhgnhTp9n2Jv0fwERG++gF/941HieqDkVKN2ds7KW
         2BdAgpqZRiKkKv9K/odFIE4VRuyq9P3bZ6FLS6iAT8fReaUYIP+8RhJxwCL+aSsxbRnh
         90lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769430989; x=1770035789;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zPB/SYfzf+cP9VaT3HQWyX2iAkItRsWtTDmJ8NpaX+Q=;
        b=JRX7ieHBs1pzhzncudb2zO7kS+O+3fn3yv6AXzDuqRt1C+5UwYp+oVNDNPByk6B0FW
         r/LAD1j2Y8pmxS04jWKNYasSQHM8vQQdO8Gk1bbTJidvTP6/URul5aeDIqjn+RQiocZM
         Z5XrOBH8arhj727VGuu5sYgebL0cZCErnMA6UBn+4C4K+n2egsHckivh9yswFzmDfnDC
         Z1Od2wkaICTJB+qjbpTMvXLgVFWZKd/B/w9xsYRqy9n1w1PIFjl0X+74z+0iPmqfI9GJ
         5NaU4jvMd4Ua66Vs4ehPGyx69sNruFa2TzHsPCjKb6T15Wi2zd9Ll4XPGeEidJ5efsVn
         LHFQ==
X-Gm-Message-State: AOJu0YzPPbOGzYTBcASSXYn2adJwqBivwVXfqJ3XpmysBawx/Bzs6gl5
	vr27+fuhQ9e/bG0F3EcdjXJh97VDv9SWjwRXU2/mbmtBsePpyaKgsFF+QRzqiicKtoQ=
X-Gm-Gg: AZuq6aLI9og9KR9XafXamF7yU/uaEPPzlzaPqxDGxUehU77zkHLilQlNy2CUM6XDwiW
	R/e8UxlcFLoAuwxReb2bwFTCdTywkAGAz4GWpRGxHXUmfqe9ngtX/PmQJIlV1CKmxoEfoIb/S07
	qUjpT0YMjw5w4kUneV4NzSkdaBCT/wWCmcpwRy2OdHhDeg15q9YyONXbuYW9bVJeqZEBKgTRsha
	kYnlWEOaKvsaQC496fLCewrtZvVUZWEOBOvRN8Q8L31d9UtqUT6BYZYHnMKp4u8TCmhmeDIAQdb
	26OP9dMu23Iqh4AEHsCmsJnej10Nkrz868wTzzHzlAHXA0fX0v7unxKAdpJi6TCMl95UrsYTN1z
	4yScH+qSNyirccRLdCsmk1kEQz9fmz4VHS7gDvULqeYPMY1mFi8euDPJnyhOgA7FnqD2kPI1q+E
	udficS5vErkvhN7DQIx0Jo6GLbWTsQtHHyNaHvM5mbgc+laRhdDWX4sKlYhimzIgDuVV3d2vlD5
	7L05fie
X-Received: by 2002:a05:6820:2d0c:b0:662:e0e5:efef with SMTP id 006d021491bc7-662e0e5f10cmr2256376eaf.11.1769430989076;
        Mon, 26 Jan 2026 04:36:29 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-408af888da1sm7307066fac.6.2026.01.26.04.36.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jan 2026 04:36:28 -0800 (PST)
Message-ID: <79ae8fdf-460d-439a-977b-6876c808bb75@kernel.dk>
Date: Mon, 26 Jan 2026 05:36:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: gate personality per opcode to fix TOCTOU check
 in io_msg_ring_prep
To: clingfei <clf700383@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260125075302.621785-1-1599101385@qq.com>
 <cea5285e-061b-4e5e-8c06-82461e8eeb62@kernel.dk>
 <CADPKJ-4HUKdt8jgsVWoecBc9qOZQ_4wXkSW8kas9mXVyWt9a+w@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADPKJ-4HUKdt8jgsVWoecBc9qOZQ_4wXkSW8kas9mXVyWt9a+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11923-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Queue-Id: 154CC88694
X-Rspamd-Action: no action

On 1/25/26 6:57 PM, clingfei wrote:
> Jens Axboe <axboe@kernel.dk> ?2026?1?25??? 22:16???
>>
>> On 1/25/26 12:53 AM, clingfei wrote:
>>> From: Cheng Lingfei <clf700383@gmail.com>
>>>
>>> Add allow_personality io_issue_def and reject personality use in
>>> io_init_req for opcodes that do not permit it. This fixes a TOCTOU
>>> window in the prior implementation: userspace could race-update
>>> sqe->personality and bypass the __io_msg_ring_prep personality check.
>>
>> Please do detail what the bug is here, this looks like some kind of
>> AI hallucination. The check in msg_ring prep exists just to reject
>> commands with it set, for future expansion. The only thing that
>> matters is the ordering and use in io_init_req(), which is fine.
>>
>> --
>> Jens Axboe
>>
> Sorry, I forgot to reply to all in the previous email.
> 
> The io_init_req checks sqe->personality; if personality is not zero,
> req->creds is initialized based on personality. The msg_ring prep also checks
> sqe->personality and rejects non-zero personality values. However, sqe is
> shared between the kernel and userspace. This means a user can submit a
> msg_ring SQE with a non-zero personality. After passing the check in
> io_init_req, the user process can concurrently modify personality to
> set it to 0,
> thus enabling it to pass the check in msg_ring prep and invalidating
> its rejection
> of non-zero `personality` values.

I'm not disputing you can't change ->personality between io_init_req()
and __io_msg_ring_prep(), that's obviously possible. I'm saying that it
doesn't matter one bit at all, as the check in __io_msg_ring_prep() is
just there for future proofing. If the application knowingly changes the
SQE post submit to defeat an -EINVAL return, then yes it'll defeat the
future proofing. But so what? If you look at other prep handlers, the
-EINVAL checks never made any attempts at protecting against this
scenario, as it's only there for future proofing.

IOW, you could just remove this check in __io_msg_ring_prep() and it'd
be fine. Or just leave it alone, because it really doesn't serve a
purpose.

> This is not an AI hallucination, and it can be demonstrated by a
> userspace PoC.

It does read like one, however... Including this reply.

-- 
Jens Axboe

