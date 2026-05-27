Return-Path: <io-uring+bounces-13532-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KI2OFsEgF2rw5AcAu9opvQ
	(envelope-from <io-uring+bounces-13532-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:50:09 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A83BF5E8033
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:50:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C257F3009514
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 16:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70CA6441021;
	Wed, 27 May 2026 16:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="PGmITyv1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0027E43E9F5
	for <io-uring@vger.kernel.org>; Wed, 27 May 2026 16:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779900324; cv=none; b=WhX6FF02oYOZseaYRiMtypTAkBxWn+9FNoQ6s+zvg2imF9iT/qJ1MuN2J8HZk+et/yRhoVJ+L2DD95XxODSXnt0bekQ148OiRMNs8XfjgtcaMgi+4O8gkjkrJPrJZhHxxu2Bb1P+90DxgXtjWZhd3WX/eK1x576yvCZTtLLKmJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779900324; c=relaxed/simple;
	bh=Px96Koc+KE1Llq24SuFqyCNdFUV476yMaxYMtndJ/UA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=enoSVPGQa0+xGZwUBPtnJOxnQ+G1ZkTXcIfTnX1/824oTyhHw7ootvS5YWeuS5aX5n+NfkWs7eODoTMo95O4gWYiqSfeoFQTIMhV8TE15Kfd66iYsL0oaHNlgd9Qh5kVxTX545eILJAYLzq41wqucwmsdbYEo7U7FXf8lUa7SOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=PGmITyv1; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7de431da8fbso9889443a34.1
        for <io-uring@vger.kernel.org>; Wed, 27 May 2026 09:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779900318; x=1780505118; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dcORsZ+6RO+FQOhB2NjtCmUi3rJoywVrFL/YyMOnoJ8=;
        b=PGmITyv1gFtGOc+BOGJEcFusxaA/c4h6dxbQwwTmpfDOcZBsxTqSevpcLmm6/xYdqB
         NP755Jb4bgoPiLU7FQr956I1q4JJoTIl0YFdFHQUN0igabqpvBU5aOxItBS6yBi80Q+Q
         DU8tpq3GMEMM1QlvywC3ELldx918nVUFJ1TNdWvc54VyLcgiXbb4k4Wm3xSNlWkaHbS/
         16ak2tv9pEvqYtNB61CUod3/Y9xLD8rYqm6FUASZNBjtE1dBVint5GTw/s4f8cFclvO3
         UIFk0ODzBNcdesQHJ/ReEEcTAhK5CWW4QQk9QIZVqBkELkBVGzkKlAdXKEvXw5d3Vs7k
         yhZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779900318; x=1780505118;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dcORsZ+6RO+FQOhB2NjtCmUi3rJoywVrFL/YyMOnoJ8=;
        b=KZuelm4P4jJY7Whx5NcyqdtbzjkLeiGV7hDrr7IakSM2RyeOgNo43eE82p4oYuJuZD
         J5KNq6OPp0c8dwOvhO+KpQVAZwlxCzhQNfVvYJt/o/mvxm31YUP6ajlEjBsgWmydlA7z
         ox7lkjJw9JBWbh8Cbd4zWjaprSaTQ+qhcnI2FCTaTJ+D60P7lx04mF/9QYyDjWcw0XoT
         V3FUawroew5eOavjoIVk3rAb0gx1wt2PuQW8ZSzUgGDBVSpSBxZ83AL/wPAJTFVT+hYC
         6aN/OnWm8Af0cJE+R8Trh2hAR8esZYpGY4wAqYbJ0VQq04PiMlM2aIOVxLFG9b+cYDt+
         WI/A==
X-Forwarded-Encrypted: i=1; AFNElJ9Wu/K2LDD8BceTVj5mOGopcSBTcEYUG695kc1Ka9LCKJNzfUIABmQutqskNWiOydPxLjX+vRR+hw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWuOu4JQpDa0rYT8IlNoId5DwER4VgLZe/sUnVVeneVVy8//A8
	qofvw5B55CV7/YfG6MhEgo6Ha68P5wv0Rv7oDwI9DCi9cI50w5LOgd1bvbUPaKRnLNOZrmv4gS0
	lY1Hze04=
X-Gm-Gg: Acq92OF9jdtCn7fiTK/n4E0HlauRNCilxKV/VQqnVz4BJyl6w7IquOCsYEgHszh+NmJ
	kE3+kP/9hgoappdfMerC0qJnHp3XkwXCShWEB8zMqp21qpHAoctDHQi1VV9vrATmNU2WFwjvGPb
	8+CsS67qBtdZur7QwNs9bN3EklEkRhAEQyUA60twTlrV87wpvlhVOb2gIb31gZbe4ikWsg6VjNn
	Jrvu9ldILh+i2MuRL6VvhywGiRaEp39HD/Pq2HO8s7V14b7cU1HBMlnG9oC8SmmGNAn1bCAw+oC
	q9HQ4yWmiimMddg4nawrYpPup5EZqjI7/IueFGOYChkCwYBw+PjNIGpEPCupiZBygYTDxxjwxFz
	cyeTFIIkbSnl5F2uS+xWQlMe4RacgUyVRo4znkz6yrpUUCh7VsqEgdOufvNa/fM7wxpQ8VsH8Bm
	ge/+d2pyS65tXf0GunbT/UAnlX85z6fNcoHKH7SQkaGyxYGfccNiW4jCvrrOT3ZfLh6Y2dicLGJ
	Gl1Clzpe4q4vmrLbMc=
X-Received: by 2002:a05:6830:270f:b0:7dd:e032:3ce5 with SMTP id 46e09a7af769-7e5feed03cemr14415624a34.17.1779900318314;
        Wed, 27 May 2026 09:45:18 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e606641114sm11987256a34.21.2026.05.27.09.45.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 09:45:17 -0700 (PDT)
Message-ID: <07c25a67-54b3-4ecd-bdf1-7ca0cefc8e38@kernel.dk>
Date: Wed, 27 May 2026 10:45:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: bsg: copy uring_cmd payload to prevent double-fetch
 from shared SQE
To: Caleb Sander Mateos <csander@purestorage.com>,
 Rahul Chandelkar <rc@rexion.ai>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20260527105931.3950913-1-rc@rexion.ai>
 <ee931505-64a2-411d-8607-3db8912b70c4@kernel.dk>
 <20260527161926.4071110-1-rc@rexion.ai>
 <CADUfDZr6LJckoVt2NRfRt3Njs-WAqsg5-QnTDi6xbUDiO950Fw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZr6LJckoVt2NRfRt3Njs-WAqsg5-QnTDi6xbUDiO950Fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13532-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,rexion.ai:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel.dk:mid]
X-Rspamd-Queue-Id: A83BF5E8033
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/27/26 10:27 AM, Caleb Sander Mateos wrote:
> On Wed, May 27, 2026 at 9:19 AM Rahul Chandelkar <rc@rexion.ai> wrote:
>>
>> On Wed, May 27, 2026 at 10:06:44AM -0600, Jens Axboe wrote:
>>> I don't think this is the right way to fix it, ->sqe should've been
>>> stable upfront if this ends up happening. Can you share your poc with
>>> me? Your trace has been trimmed down way too much to be useful.
>>
>> Agreed that a core-level copy before the inline callback would be the
>> right fix and would eliminate the entire class for every uring_cmd
>> driver. The per-driver copy was meant as a minimal backportable fix
>> for the immediate scsi_bsg path.
>>
>> PoC and full trace below.
>>
>> --- PoC (poc_bsg_toctou.c) ---
>>
>> Build:  gcc -O2 -pthread -static -o poc poc_bsg_toctou.c
>> Usage:  ./poc /dev/bsg/X
>> Needs:  2+ CPUs, io_uring, /dev/bsg/* access
>>
>> The racer thread flips request_len between 16 (passes the <=32 bounds
>> check) and 128 (used by copy_from_user, overflows scmd->cmnd[32]).
>> The overflow payload plants 0xdead000000001000 at the sense_buffer
>> pointer offset (+84 from cmnd[0]). When scsi_queue_rq() does
>> memset(scmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE) it faults on the
>> corrupted pointer.
> 
> Then the fix is to use READ_ONCE() to access the SQE fields, right?
> Copying the entire SQE seems like unnecessary overhead. See
> nvme_uring_cmd_io() for prior art.

That is indeed the correct fix.

-- 
Jens Axboe


