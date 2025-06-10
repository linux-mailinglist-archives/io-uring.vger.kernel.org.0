Return-Path: <io-uring+bounces-8291-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D7ABAD397E
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 15:39:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B98A3B98EC
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 13:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A21C17A301;
	Tue, 10 Jun 2025 13:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="z3g0E4xS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68575226533
	for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 13:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749562382; cv=none; b=JBCi9iotV1XUGbN44thfOyfAiPCbASj3Q115Iy/ujS5vxeT1poYsVbqmy+TF4aEXRwzcJseASQDepzKG7y8ZdZn6Foo0N0APoO3qH3YHXFY7Lnsv04ZbkmXVNUqmhcXbmIWtW79z1J7FXR/9iyhxybhFWFM1uysE7O/7b40V81M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749562382; c=relaxed/simple;
	bh=/pLgg1npFygAMWsFiewr6CwgeIShi0kqszzTye9PbCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AGBH4APhH0xxjMhNEX0YIaCEQMHY16Y/NG/4Q3LecmrcN0ux4JIITcGTo1mYVuGSfENeVsc/E3Jpjl05HdR1AQnsACWz2SoWjbgSCX2RxwKCTHLTszMxq8dtY8mkpjfURz3KiMzdz2QbLzhodFt0ylycN0hz31Tv6lrEW7ixMaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=z3g0E4xS; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3dc729471e3so19097025ab.1
        for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 06:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749562377; x=1750167177; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GXoXgu4ibrfxrewiTcgcVrPF4crqwoQl6hLUIDA8hSg=;
        b=z3g0E4xSOVPk5xlZ9IEJHeJCXVLGqljYljOZveeyNEsExemzViX+kXZYrNHSSJ8llx
         QAZzbLko4F0wIJNdBryNpMViabW6dO7NfZvVRvMUFVSxA1g7bHJ6wLqhmV6LbbGudFKe
         SEsBOiaeBKMZc63eXAybebMifv1G4C3RXHCd8sf0OqHQJpP4EOKXA717pK/5YkX7UFFL
         FvfZW3EcGoruZvd7iZALCyHTBDlWTKuIvo/GsYedD5v1r0nAri8/55+USkCBlZGOCb+b
         1CsaF88ou8Bl9FPTZVtOiDaFkBWy0J3VrS8tfFL4mF7aFIvJ6Zl+xavd4ZyDJLmw7YPh
         POmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749562377; x=1750167177;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GXoXgu4ibrfxrewiTcgcVrPF4crqwoQl6hLUIDA8hSg=;
        b=YcT5frkv0CJ3YCwTv6tVJKWFhPFbDU5iSopi0hiffCshUagCNzpjCvsoKgUbddsTiO
         rF58mCAla3+uOo+t+vz/NWohDz9pn7I5Lh3yzYn1DMq406Tbsom1lCAbbV7rFu1zZecq
         OJv3EJSmdp9IRkQPgnvssWTH2nwowyAFHZ5UOWfMoKE58Q/vrKVK7SCoHXBiBS2zyS0H
         MYTF063ZT1HSzLJO6enJt/87cGloIDScpgec9otNFap0Q92S0fhJVqUJ3qhJ17OWsCC7
         VvksCYkmttOvgpS5K5ncSXxmKVNz8NJn8+jA7knspDaHz4KEHksjExbVR4g4VhWQG2tt
         kAbA==
X-Gm-Message-State: AOJu0YwlxHgf/hDRkWqskRY54k5oEJEexmPgmOFdOzatkbo0dc1xohKP
	22CUmdIiYqkj8K7y0oqDQm5PcpYr6jiKp0m0We9sJ1DolAOm9ymQ6O5iQY44I49a3aQ=
X-Gm-Gg: ASbGncvLqKJ4E5Ql6TOhoDuEdlB/zxGX/MHp0MmsCuZBqKU39BLgREsGjvObz19SoPJ
	Xcdj58jW8BUAjEAFr0AZC8dh6SbMdxpA2DjxsTOgPizEK90MmA2XVPDqFbXIvWd3eEnCmjXoeCw
	hey6t0T4jw1RIRGMrnbSTIw/1ijOr+H47UC3W01CnQaHWwC+EljzjG5MXCUh0dp3Xjnm15JJpvj
	sLAhgPSW5qGxMifyxJpKbt9PjYQ2dpzNGQGHvRPgP+FjozXPRNAgMGbELU1P++VrIA0St7CNe4w
	H4eeGBjG1w4isF4edEdQHJgw5jbEF3tGoZHlFMr0pPqbNP1uKuzJsSRTOoE=
X-Google-Smtp-Source: AGHT+IFy1OvOLo0m83z0h96v8NaA0vfc0EyYR4bGxHBXoE7tXGwoMbo4QFB0uuk9KfmEIHU6f1v/dA==
X-Received: by 2002:a05:6e02:2585:b0:3dd:d189:8a6c with SMTP id e9e14a558f8ab-3ddedd4a608mr27261125ab.4.1749562377192;
        Tue, 10 Jun 2025 06:32:57 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-500fd7de001sm1393844173.115.2025.06.10.06.32.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 06:32:56 -0700 (PDT)
Message-ID: <7d913e1a-f200-4b02-941e-821187c791a9@kernel.dk>
Date: Tue, 10 Jun 2025 07:32:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: add struct io_cold_def->sqe_copy() method
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <20250609173904.62854-1-axboe@kernel.dk>
 <20250609173904.62854-3-axboe@kernel.dk>
 <CADUfDZp=yhbfDcHJxDsP9gbBJ90sE0cxqsM8rRueU5qsYmN=ww@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZp=yhbfDcHJxDsP9gbBJ90sE0cxqsM8rRueU5qsYmN=ww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/9/25 3:54 PM, Caleb Sander Mateos wrote:
> On Mon, Jun 9, 2025 at 10:39?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Will be called by the core of io_uring, if inline issue is not going
>> to be tried for a request. Opcodes can define this handler to defer
>> copying of SQE data that should remain stable.
>>
>> Only called if IO_URING_F_INLINE is set. If it isn't set, then there's a
>> bug in the core handling of this, and -EFAULT will be returned instead
>> to terminate the request. This will trigger a WARN_ON_ONCE(). Don't
>> expect this to ever trigger, and down the line this can be removed.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  include/linux/io_uring_types.h |  3 +++
>>  io_uring/io_uring.c            | 27 +++++++++++++++++++++++++--
>>  io_uring/opdef.h               |  1 +
>>  3 files changed, 29 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 054c43c02c96..a0331ab80b2d 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -504,6 +504,7 @@ enum {
>>         REQ_F_BUF_NODE_BIT,
>>         REQ_F_HAS_METADATA_BIT,
>>         REQ_F_IMPORT_BUFFER_BIT,
>> +       REQ_F_SQE_COPY_BIT,
> 
> naming nit: I would interpret "copy" as "needs copy", which is the
> opposite of what the bit represents. How about changing "COPY" to
> "COPIED"?

That is more descriptive, I'll make that change.

>>  static void io_queue_sqe_fallback(struct io_kiocb *req)
>> @@ -1986,6 +2006,8 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
>>                 req->flags |= REQ_F_LINK;
>>                 io_req_defer_failed(req, req->cqe.res);
>>         } else {
>> +               /* can't fail with IO_URING_F_INLINE */
>> +               io_req_sqe_copy(req, IO_URING_F_INLINE);
> 
> I think this is currently correct. I would mildly prefer for the
> callers to explicitly pass IO_URING_F_INLINE to make it harder for
> non-inline callers to be added in the future. But maybe it's not worth
> the effort to pass issue_flags through multiple layers of function
> calls.

I did ponder that and decided against it, as it'd be a lot of flag
passing just for that. I'll keep it as-is for now.

-- 
Jens Axboe

