Return-Path: <io-uring+bounces-13338-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OBanMs3eBWqjcwIAu9opvQ
	(envelope-from <io-uring+bounces-13338-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:40:13 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D37A5434C8
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A07B93192191
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 14:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE69D3B19BF;
	Thu, 14 May 2026 14:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="EDhfi1is"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4003D8909
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778768726; cv=none; b=c7Z4Q4C7Kkagc2AKzZwx9kanudpfRITMr0GVVTmgme7u3AMcMBs43JoioFMdk2G9iFJRQY1iqvEeuV7LiDmFY/GuqOAiWxtrub5ic9JgwxPhZcPkx+4nA9qpGw/XwIvjvpNIyvArYKTmWTwQVz9cb8oBRUWS2HxpKAyLAOr9QnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778768726; c=relaxed/simple;
	bh=y68mjnmGxJ3Z6NOMmD9Cbor5Z+BtT56iPgtH9/I8kk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ATa6zsdl+JOiATggolm8TGGWfhz0DADP9U06jDOW8mpCuBxr8Zbhfb5Ykvf5VN2MoF3s4PLbJYdFzcAb74T5RwnQr5evTEw0lqGnKixIEb9/xPemKij9mBaLig/uZDhH1nKLxUHFKXNBB2uaxwvI8oyCCy9DtP6wzxu35X/yaEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=EDhfi1is; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-40ede943bf0so5923036fac.2
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 07:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778768722; x=1779373522; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CIp2wbRH/ne+gPYqX8DdwemUZTNQt3UJWMYHiaRNs84=;
        b=EDhfi1ispu1viZMChBinhWNqhqrRchhCbmW0rSHTcSBHbb/wYAXIysMsvrErL4xxYH
         NM+9aaeqLk85NoT96qa9d/s3cDMN4Bx7mhTnSihH/Q6Zm+ZheInVypRNTOaIdQyM/Oyp
         C0pf90N/fAOpE5sEPIFRdpjUOOu7MRycNsUdKKV7VsM4A7xYPY4qbuPU7rYd3F8SASSi
         SKOBzW6wmQeH5sDZ3drNRRa/9NuoZFJqCB+SQ5eIPgnBmozxkBta1ttKes1UYJJwR1HY
         ZGz0H6uK5IikiqtiGkdFztZpQn4Q2Gtqrt4gpaSebl4w2eU9V23m1S2obaTFz4VEVQ67
         802g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778768722; x=1779373522;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CIp2wbRH/ne+gPYqX8DdwemUZTNQt3UJWMYHiaRNs84=;
        b=bkTgbhJjncLMybJBNGYi7pdarW/hlckRn+vkDxLW4kJpazrIynJuoxIfmmnL1KEb/H
         cP9yeccv6HOCNiAciNMFrM7CdNbt7szkIgaOUjvczPHIS6E65lqV5DEnI+8haFYBTw+u
         sjDWohH0HGScCqKAziDe+jVKJiBdAkjoOqWVsETQogqVGj4Z7R+x5JsbtBFeAxp1BeRD
         UteMhZ31xc/ochne3NT4Wl7fhqsoSjWuVZ7usXCvJ5qjvQjyD986R6/hkjl38vy/QXbs
         UkyrjjJ1lFh8yqi4/gOSJkGRb1E6rDsO2fdphU0yw6eyMah33hFJaA/VMbC+Lwf+yTkz
         rdfw==
X-Gm-Message-State: AOJu0Yw965bcfpjvlq4wm2PIBCPi0jjrgHqS44CJGqQLeY9Y5AkmYd4t
	sShDYgUZk3o1ONS8aiwMoneq6mRFzwL9T5H+aSRgTwTNauECxHAGyvE6z8noI9c+ZjKgdEdTot1
	sk2L5
X-Gm-Gg: Acq92OEc55vC/Nt/OvzUzfir9qd2QOZW5jQ06As1Ok6RoFgVos9u+MwlDEtO8uOhuOC
	X9f/Dtl7ucEaIMdyLFTpXqC/nRCrLC/YZD/S9cPn3x0VS2jR7uL1RYvfBoW7etu/pitHVmgH4WM
	HbU7a8dKGVa+AgRHr4ko4+gcJ+HSw0ffG3gyLR41q2TbMYt+zpvT41b2hUA68hgGVDdsxVICUaL
	MSA6ak5yCbzDZMPd/rGgqapfuNyONWhyMz6TK64Yl+SKjKYKJ3OnwJx4iccv+9OEpnVhzSsQl6f
	PwpYC+ZMABu+jXd2s4BvkbVLDg3ziUEQnc6PDdqLdDV5kZuDA4f43sbQif8mW+nCy2ptxnvRH+1
	iCCxWX28/P+pe+7ex3zQnbdhOReb7x6YPr8nUQByv5Lqg/abbBp8LijdxDgUX9JojfKqctv2AI8
	XvjmcHv7xKxLESofiTOK2xv1zo/wmeLju8Q50CqJUFfIDBokaN7bPauynWu421isyL43OYoowC0
	mrFQ6WD
X-Received: by 2002:a05:6870:f211:b0:42f:eda7:42f8 with SMTP id 586e51a60fabf-439ce053c9bmr4558486fac.8.1778768722497;
        Thu, 14 May 2026 07:25:22 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-439fc5b693fsm1912835fac.18.2026.05.14.07.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 07:25:22 -0700 (PDT)
Message-ID: <49a10373-f2d8-4813-b9d6-25cd2a0f2fe6@kernel.dk>
Date: Thu, 14 May 2026 08:25:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: parenthesize io_ring_head_to_buf() expansion
To: Caleb Sander Mateos <csander@purestorage.com>, Yi Xie <xieyi@kylinos.cn>
Cc: io-uring@vger.kernel.org
References: <20260514083443.203387-1-xieyi@kylinos.cn>
 <CADUfDZoYZ5hGejvoZrCzhef2LrB04cbDsdoe+jyGnhL6Pnn4FQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZoYZ5hGejvoZrCzhef2LrB04cbDsdoe+jyGnhL6Pnn4FQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1D37A5434C8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13338-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,kylinos.cn:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Action: no action

On 5/14/26 8:22 AM, Caleb Sander Mateos wrote:
> On Thu, May 14, 2026 at 1:35?AM Yi Xie <xieyi@kylinos.cn> wrote:
>>
>> Wrap the io_ring_head_to_buf() macro value in an extra pair of parentheses
>> so it is safe when composed into larger expressions, and to satisfy
>> scripts/checkpatch.pl.
>>
>> Signed-off-by: Yi Xie <xieyi@kylinos.cn>
>> ---
>>  io_uring/kbuf.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>> index 63061aa1cab9..dd54e43e9ddf 100644
>> --- a/io_uring/kbuf.c
>> +++ b/io_uring/kbuf.c
>> @@ -21,7 +21,7 @@
>>  #define MAX_BIDS_PER_BGID (1 << 16)
>>
>>  /* Mapped buffer ring, return io_uring_buf from head */
>> -#define io_ring_head_to_buf(br, head, mask)    &(br)->bufs[(head) & (mask)]
>> +#define io_ring_head_to_buf(br, head, mask)    (&(br)->bufs[(head) & (mask)])
> 
> Is there a reason this can't just be an inline function?

No reason at all. But also don't see a strong reason why it can't just
be a define. And generally I don't like cleanups like this, but this one
at least made sense to me.

-- 
Jens Axboe

