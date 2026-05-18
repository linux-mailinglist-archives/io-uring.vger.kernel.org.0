Return-Path: <io-uring+bounces-13406-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MMv3DJYoC2pAEAUAu9opvQ
	(envelope-from <io-uring+bounces-13406-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 16:56:22 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AD2A756F55C
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 16:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F1AC1304B7F3
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 14:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483C825D527;
	Mon, 18 May 2026 14:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="QcyWdSeV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069571F4C96
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 14:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779115765; cv=none; b=qJoQBWv4QIKGsQ/N6FYp/obw1H3H1olSfJlHnOOI181lv27xFdwiO/AwlsiJgGLCoK3p2ldOanbDDj1tkGuV7N3AZIK9epOlnjScE6/M3pKHxcNhb+lSjf2yUX/7aO/z/Ii8KeIu+L8neOXQGYkuXk1GUmN0ROy4H3Iqw6c2cBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779115765; c=relaxed/simple;
	bh=GvC6n4GXqcIrsvO4GTcT0n13iHKupI99fdlFbiWw8Y8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ip1Tsf+jhWMf2rp3q2ez3RiD+0LwNK4q/+YPNlA4NXHAEgoKJJDBjJxmihMt+spgLCrSZ6/klbH/jgYVmDJqf6Nl+bEYkxsZbJOo26SJUV2wSWuFWb3XmmAaBDA6DSFrGteQ2dxZCiWII1GxfvfTNF0vfXUGZT/R/4qV5TtchDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=QcyWdSeV; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-4043b27ddeaso1359655fac.1
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 07:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779115762; x=1779720562; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UsphNysf4D6v7a++ZwJic8eaCFgGO9xkBELfRy5x8Y8=;
        b=QcyWdSeVOEDfH4rdrn899GjwNqwU5Adk31rH4paY1YwjE/rxmO9SuMSboEBAZca+CE
         VT+vPGGP0kZy/rKIOOgh4uUuKEphX327pk2uBpv0JWtPvTe/wv7BCPjOaLZXkWxMbBwq
         /UIAw/CfV4u82fl8ISbxYRQ6RCTGCot+/Vu/415EZMIUVJndlJtFQPDmD+wrVT7E+4ro
         Qa5j9b8+TdXkOVjiCAOXndnQKhMTVLgdWW0Hx3bqLSx5eaJIiU59iIu02Rkf7POIG/6h
         +RckSb29+W2seRm5ZEFNH8v5ZOT1trG5I2bEQ+Pr02IvUhCt8DbZxw0I89dsQ1fYmQoC
         oBOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779115762; x=1779720562;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UsphNysf4D6v7a++ZwJic8eaCFgGO9xkBELfRy5x8Y8=;
        b=qhXd0M0MkUzdshWI+FmmSfI+zt6e/z13UXv6oR6JsA/54vV2uEoQyAvUXS3fMCEsY6
         L+zreMa1EOPVFG9ed028ddmPLqwt5v8Wh/wra5KOh9rj/v7qmtZJgdBsrHp+MyY3VHj0
         8EngCedrxrrVNieZ2k7PSugdBJu/HbmpFzdY3GrjCnQBzLHgP/UEcovrZn219q82adQ8
         6xPv+hSI+xCLxtC7CP3i+liirXvN0BtMs15F/vPoXJtFMGIEpJ9YIdmFk7wme0t1Yzcr
         wazenJ7nz+ZHLR1Tdjz3TQjX94kfc8MDMg8xcGZaOkXQVcECJtmkGmIojBEbtsgMxv29
         FQLg==
X-Gm-Message-State: AOJu0YxtOk4dJTnWYDpBi5Hi7aG4kj1LsyditaUXFQKn2q0K1ocRuQ26
	554iuM7dO92M9Zwefr3Nr5IQc4XxS4VtclKytuigzud8XlTFjo57UpTE1sKbrRFYVT4=
X-Gm-Gg: Acq92OHHzKhnxVPQaYNYSPvRVxRi4gxH96NWMopEw29ox0cwnxNlzPd8/eNxlJYaijQ
	EnLZZxW2yjeySgB+goeWSWlB0/IWMtMLrdB88n7mHwtKAuUGZyUxM6PX0GBdenQJ/Ml+rbDK4xW
	tA8V7stKWYPNnENzqHcQBov927RfdzusU74SDnRfdmgnsLfGfc5zCFBgKHsrRmBo4yFTtpssF5H
	/9HdfTFNuGuIIcvJcZ+2efC+UffswdTRsbp8E5ugyFKhhxsIOh2plTA+1UYandNvuaY3nnPen6k
	ILOrunFEC4wA70rmb3apwYSsmMbubehqnmWqKYaOZVC2LGfTeGbDFTYtBtdM3+zWCd/p6J9NcJd
	+QXqfzpLAxWOCIFzXHq6bJOV0q2fKpm5Bo41wUua9PluamWlYXgFwVzVi3L5sr/0zfn5RSObFW8
	ZQZk5+/2XQrmZK1A6U0BJDYrsmc+bFpoLL3TcLKmv65HshaCj7ZCzvJmCp/8i2rWXesvknbLfen
	m3BKibCB6cJeac6OnA=
X-Received: by 2002:a05:6870:e2d4:b0:42c:2421:5777 with SMTP id 586e51a60fabf-43a2d9d7a2dmr8780126fac.13.1779115761859;
        Mon, 18 May 2026 07:49:21 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43a94f49e25sm4558817fac.2.2026.05.18.07.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 07:49:21 -0700 (PDT)
Message-ID: <2bcbace8-6038-4253-be39-351f9d2f2a18@kernel.dk>
Date: Mon, 18 May 2026 08:49:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: propagate array_index_nospec opcode into
 req->opcode
To: Caleb Sander Mateos <csander@purestorage.com>,
 Michael Bommarito <michael.bommarito@gmail.com>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org
References: <20260517213010.696135-1-michael.bommarito@gmail.com>
 <CADUfDZqJYvQEuUdWeqxvcBPhfj+zvsezcsnpbK0N9cnBTqr2qA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZqJYvQEuUdWeqxvcBPhfj+zvsezcsnpbK0N9cnBTqr2qA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13406-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[purestorage.com,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: AD2A756F55C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/18/26 8:42 AM, Caleb Sander Mateos wrote:
> On Sun, May 17, 2026 at 2:30?PM Michael Bommarito
> <michael.bommarito@gmail.com> wrote:
>>
>> Commit 1e988c3fe126 ("io_uring: prevent opcode speculation") added
>> array_index_nospec() to io_init_req(), but applied it only to a local
>> opcode variable. req->opcode is initialized from sqe->opcode before the
>> bounds check and remains the raw value.
>>
>> Keep req->opcode as the canonical opcode in io_init_req(): reject
>> out-of-range values architecturally, then write the array_index_nospec()
>> result back to req->opcode before any table lookup. This keeps downstream
>> users of req->opcode from observing the raw user byte on a mispredicted
>> path.
>>
>> No functional change: array_index_nospec() is a no-op for opcodes in
>> [0, IORING_OP_LAST), and out-of-range opcodes are still rejected at the
>> bounds check above the assignment. Boot-tested under UML (x86_64
>> defconfig) by building stock and patched kernels and running a 54-test
>> subset of liburing against each; pass/fail results were identical.
>>
>> Fixes: 1e988c3fe126 ("io_uring: prevent opcode speculation")
>>
>> Assisted-by: Claude:claude-opus-4-7
>> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
>> ---
>> v2:
>> - Fold the clamped value into req->opcode and use req->opcode for
>>   the io_issue_defs[] lookup, rather than keeping a second local
>>   opcode variable. Suggested by Jens.
>> - Keep the hardening-only framing; no functional behavior change.
>>
>>  io_uring/io_uring.c | 9 ++++-----
>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 4ed998d60c09c..84e16c3ad3f47 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1721,10 +1721,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>         const struct io_issue_def *def;
>>         unsigned int sqe_flags;
>>         int personality;
>> -       u8 opcode;
>>
>>         req->ctx = ctx;
>> -       req->opcode = opcode = READ_ONCE(sqe->opcode);
>> +       req->opcode = READ_ONCE(sqe->opcode);
> 
> The local variable should improve performance, I'm not sure removing
> it is a good idea. Due to the intervening stores, the compiler can't
> tell that req->opcode is unchanged between this assignment and the
> later loads, so it will have to reload it from memory. Can you just
> assign to the local variable opcode here and wait to assign to
> req->opcode until after updating opcode with array_index_nospec()?

It generated the same code on my end, using gcc and arm64. If that's not
the case for you, yeah then retaining the local variable would be fine
too, like v1 did.

-- 
Jens Axboe

