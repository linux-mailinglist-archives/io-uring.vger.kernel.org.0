Return-Path: <io-uring+bounces-13707-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id mDsBKn9gLGqUQAQAu9opvQ
	(envelope-from <io-uring+bounces-13707-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 21:39:43 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ECE8D67C196
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 21:39:42 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=UszelnFV;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13707-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13707-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 918C632837E0
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 19:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE46A314B95;
	Fri, 12 Jun 2026 19:37:16 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7FC349CDE
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 19:37:14 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781293036; cv=none; b=uLosbcaFTVqyDeq/uo4UhfzuSwDQcv2SEk5bN0AiGzonq8OoijBSywKSUSW0b7bBzbUK0PPnEzUUenHVrVDpwAHG3VI64sk0TS/hUTowWDVqRVBUz0wCQVVKLzAlh6n1nPBFWM9Ntp/pY//OttmrHkIZZf/clVQ6AsTsfAbl6rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781293036; c=relaxed/simple;
	bh=KENE+3pwzxfWTI2Sgys/oGLFv+y0hJ1739OHssxR77U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N5Ju7wcKdfPI4uaJrM6Egzu6Deqkrm1jXKdRglwCXe60S2juWcDHSx6p8PDJDk/QUV3Vt0vqaUqbDbkQrydPnQxErRAVFCfzIKTm/1ZMaWNzCmoXFV0gkP+e8U6Xihczy/Bcn4w9jeqerLFECUOjI01lEJuQZCfvBkW1aDL32+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=UszelnFV; arc=none smtp.client-ip=209.85.210.49
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7e74a827212so691285a34.3
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 12:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781293033; x=1781897833; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XBMYYHlHV1r2B7UJX/tKM9AmTmcx+x3M2UwJ+v5aTmo=;
        b=UszelnFVWrwLIIKbX9kmvgs1l9Qm1FkspDqaUZpMOz6vcLw7Cnp30sm0E+Aj7IIVdh
         6TwRtKdxrsAllgTlj1y9rYDe6WhePwcM3NwhmA5kkq/u8I/dvwcqrO9mxeCHiTEyJomx
         pkw2+7FLJZM82qHaDeKILzX+jXVNNCx0ikGinR/EmwTODhPMTg9oHwl32CD95edQk3Zq
         x5jHEL1mthE7pJIQGAsU0bpYwWvI6Ua5M601YnW0bE9oE3wBj+BrBHp0y/ittx2+e6Hf
         GawPUdcgTH17CLDWJx8dP8WsBXm3IPPoW2Y5WuyL4/RmClS5HVGA4/li6XCzq7gVL8ad
         d27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781293033; x=1781897833;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XBMYYHlHV1r2B7UJX/tKM9AmTmcx+x3M2UwJ+v5aTmo=;
        b=ni/pqF+5BA88brJoidASTz5z/8EznRs0zUpPm2nBIDw26JJxPK/179vIzLbKBYaepk
         pfxX9z2zSUVk1s0KhJsxjGEU6WdlApNzo3XOyjM707BMn6sjo8M32iWezNnp5EluwypA
         v9X4FcReZeFiWDR0eZqjZIZatDt67f6BAl5MJu51DXWGrI9ES62UNqCqQm75BhughV8n
         DZvUIrd6jJS2bumGx7P3W5qgmHJhlqDzzoeguYg/LM1DxDZashaFJbIjruUmciQ01Xvz
         1+b/cfUzpdjD6aTXogKj9aHzjZ/shLDhvJvep1nj87PeXGW8SByg0YQpmCCbCKX7mcIp
         y8Og==
X-Gm-Message-State: AOJu0YxGlzHTOPqUicOXtn+qUUJ3jxdIo8aGjw7WlKC6S2DIoSGN93vI
	BG/srYHQyk+LhnrI8MBS323NE7PfdB51FTkJCGB9OQk+BO3U2YdD7dI/gmOMhRsvVbk=
X-Gm-Gg: Acq92OGz3NNLMbJasp2/mKWkhinGusU4a3lislJHx4P6xp98pWy/0vugnbq5iYcxnJz
	Swm44O8eWN/AY+nVESsr4K3LzpdQ14TzRDrj/tgcJxRqyYoQ5TWKq32mUibkLwPZTAykLWZV+dY
	48F8gMPg8dTND8/19iiwtMj2nqX4LwfZ2pyDhFw1owerFHpwKxgNa5I8yFawgM03I39fmLPkXkT
	hKzucYacPcNfi4DSanT0As9cPMsSEUmdCNHzRJO7qEO59X3WwkSlkphW6jemFbhVORyFVWhRBwC
	nRX7C2kll5Jp+Y16BkPvIwr6hbt/VZFZ+SqHG/zc0qhQIFBOlL4K8AV1jrjKVWVRUMkhNUxoCcI
	U07ffvOwYMY2TQnMRqXwz78R4dnOQILrLJiPVCDMD1vbbwAjQbSA1J76yzFLrpCLckJcV/EkluV
	wffKRqmr15YOK8w5rHEVHyqu4OUi6zgoL5njjJi64TixaSKOlGh4c3MHXtcpgDmF2Xg8lad0Ym+
	eodCnDmS3icRgS04SIn
X-Received: by 2002:a05:6830:2b2a:b0:7e6:ef1d:4aeb with SMTP id 46e09a7af769-7e7847629fbmr2738672a34.15.1781293033361;
        Fri, 12 Jun 2026 12:37:13 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e78148a918sm2596110a34.7.2026.06.12.12.37.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 12:37:12 -0700 (PDT)
Message-ID: <f230eccc-819e-4e64-954e-a25578888c94@kernel.dk>
Date: Fri, 12 Jun 2026 13:37:11 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] io_uring: switch normal task_work to a mpscq
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, dvyukov@google.com, krisman@suse.de
References: <20260612025125.1690253-1-axboe@kernel.dk>
 <20260612025125.1690253-5-axboe@kernel.dk>
 <CADUfDZqrbUyJR9yn8i+eVbVwEuvs7a4mR8kfXF_umnZ9RUAc6g@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZqrbUyJR9yn8i+eVbVwEuvs7a4mR8kfXF_umnZ9RUAc6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13707-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:csander@purestorage.com,m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:krisman@suse.de,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: ECE8D67C196

On 6/12/26 12:59 PM, Caleb Sander Mateos wrote:
>> @@ -236,10 +262,14 @@ void io_req_normal_work_add(struct io_kiocb *req)
>>                 return;
>>         }
>>
>> +       /* task_work must only be added once */
>> +       if (test_and_set_bit(0, &tctx->tw_pending))
>> +               return;
> 
> Is tw_pending necessary? How come the task_work_add() exclusivity
> isn't already provided by the mpscq_push() check above?

It is, because the transition from empty -> not-empty no longer works
for that, as the mpscq emtpies one-by-one rather than with a delete-all
kind of primitive.

I missed that originally and things blew up spectacularly very quickly
:-)

-- 
Jens Axboe

