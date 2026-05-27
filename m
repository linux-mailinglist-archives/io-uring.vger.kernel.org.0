Return-Path: <io-uring+bounces-13533-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eEADEnQgF2rw5AcAu9opvQ
	(envelope-from <io-uring+bounces-13533-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:48:52 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B096E5E7FCB
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:48:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 10CF8300FB5B
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 16:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 760323C584A;
	Wed, 27 May 2026 16:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="kAPtv0ez"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D043BFAD4
	for <io-uring@vger.kernel.org>; Wed, 27 May 2026 16:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779900527; cv=none; b=WQbusJyTQJhY2EfJCC4OeMTWmqFUgwBo8vntzcjUWWg+fv27t7dsGvIv7O86xasqFCx6gtA+jTjGXkjp9KeKuPKJY4AGIPVVmtERyA3IeTs2eInOTFMCAsZ+oEBQRmWbMtWTvZYNMIKdcAWSwICn0gmWrvAcw605mL3WYM6fgsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779900527; c=relaxed/simple;
	bh=FmxYLZ9T7HBDAy6wBD57To1ee/XxE4n60OIHR8rubDE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ll9ZJkbXWYh2Wg1fRjGBZ0oft1zXTNKtibNP5aD7N3451TxwK8IqQSX6CLlfKwpZn73tLrYExaV4YOTkVK4R6+Zb9PUNTsiTxN5xuN0MTYuJpQyLIcuFGCd67cRvxoFJrot9wNj4MsvksRO+en585pUrH9mM6+S+Mw/0aP/qpZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=kAPtv0ez; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-479fc1fc048so8669549b6e.1
        for <io-uring@vger.kernel.org>; Wed, 27 May 2026 09:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779900524; x=1780505324; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CZP1fzAKg6xSaEJ8PTmlIuF0/KF0E0yGfcRKbvHI5OI=;
        b=kAPtv0ezeTDePp5PrnKl6jSFG1izpSbAGOk5p7rRKsNwTWHfBBLpPhyMYBWw/l9Ov6
         OpGi5cj8J1lbcNXv2Jh9kUGKiyl/vBkyQoxemCTaW1lnLvh5NiEpWk/uTIOlrqRDcd1+
         P5+YGXwDMNMNoCyTYIeiSoZFZb3bDVqeGBt2S1rIrgyYMK9qWQzjMHIbFac/ahQsPohe
         U1TXwy3vHyHli/jhEbpKrV+1pT052oBUBlUy+4eb5eB0Ep5QcWcGCt7Sz9Wn9l1UtJvb
         4753a9s9I1TXAbxdpUGD2rPbxxyh/D0DBULN6PacGUXycaCPgQKkw17LCItK2AL4lchR
         oWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779900524; x=1780505324;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CZP1fzAKg6xSaEJ8PTmlIuF0/KF0E0yGfcRKbvHI5OI=;
        b=dwr7uF1G4vA39q8iw+10Qd1JJwAgiFQV+VIxMQajOjBZCTK5Gk/axzokeiO6mQtWWq
         ZjzwGlZiFsqmvKzrewvUuStAsBRdHIcXxSuOJDhA3gXWHFm3sHRd++DRbP5HYbYXw6PQ
         cak49FL/W9yJ0KOSJ8GUSINNqbQq3xsPu/GqgqsNAsMhNfeLMZzjAwPSE59/6ukVFz71
         dY01+gR3vtZvBg93TGISsdW6BFnVBgu4hU3Ek+dZQP8hyNXp6QyzQEBLqk6hCSh89qzd
         i6nkz9/clmbIIjv2htxdw0eFGS0dQpkUeMHEbFGGb1rj/1hR8Kve4PhHMstJ8QB0f7ks
         6OSQ==
X-Forwarded-Encrypted: i=1; AFNElJ/tG40o9HmVTEM+vs33gTCrMGeE24SFqAGPyPVUsMcOb7+Oo6ufLF1fTih1B98+JYimX2DqJn/8JA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx//I9bsW4Z9OpquZdua/HDpGl3kLnqgkxG9ltlc4oFbkJRlQR/
	KK5r96dlhR+YELK8+TwPFHVbLdNtbOEfEuQcI+k/kKPfpi9QjgtEns5NZNscgtiKdV8=
X-Gm-Gg: Acq92OElrp4Y/u4DAFOC7FCR00QoRkA5Qyvyud1OtUo6qK7wSct3XZ1+LXvOPbiXv4c
	9J/ayOND5c6nVhA7PFtk6DYM0y3aZrwfw9YSVRBPifDpXTWj4zX3klwE4KC8bL3Ob/IV/VSysMV
	26gh3gb+5A43xvaowlgGPNgKozETvdNRAe+1U4R2CwXqHKPQpNZhBcSUJwW6M2ltCLLaY9qY0Gt
	HINLM+fGpt5aCB50d2pJ0OF5F/UGD6GI2pF/ouEiVjLYPHiVFSlPR+kNkb+WBc8w8pB1l4TNfud
	uNrVpwxbYwFI+LXVUaPq6tJUprcQdSN1EzoutAe7oYYtsExfftfl/4E0JilghRJDw21ZpZXMZNO
	PzPUCDY5gqj+OEBttgbUvO5+1HJvwkd8ANWWEvyaLDsz0AZMRMgho0Le88BIBUSnbxZ9XXQDoIh
	WD0SJaXMM3w20C9lD3noXZLF6LUWORUu7PH57NxtO+6C82BpkYbcMDngc6KrZEgsRrsmtZsQa7I
	fFOx8Y9
X-Received: by 2002:a05:6808:1492:b0:485:b864:4ff7 with SMTP id 5614622812f47-485b86450aemr3139766b6e.22.1779900524609;
        Wed, 27 May 2026 09:48:44 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b6350ad6bsm17352084fac.4.2026.05.27.09.48.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 09:48:44 -0700 (PDT)
Message-ID: <8947eb1f-9b49-4452-9c9d-f95dacab65c1@kernel.dk>
Date: Wed, 27 May 2026 10:48:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: bsg: copy uring_cmd payload to prevent double-fetch
 from shared SQE
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>,
 Rahul Chandelkar <rc@rexion.ai>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20260527105931.3950913-1-rc@rexion.ai>
 <ee931505-64a2-411d-8607-3db8912b70c4@kernel.dk>
 <20260527161926.4071110-1-rc@rexion.ai>
 <CADUfDZr6LJckoVt2NRfRt3Njs-WAqsg5-QnTDi6xbUDiO950Fw@mail.gmail.com>
 <07c25a67-54b3-4ecd-bdf1-7ca0cefc8e38@kernel.dk>
Content-Language: en-US
In-Reply-To: <07c25a67-54b3-4ecd-bdf1-7ca0cefc8e38@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13533-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,rexion.ai:email,kernel.dk:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: B096E5E7FCB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/27/26 10:45 AM, Jens Axboe wrote:
> On 5/27/26 10:27 AM, Caleb Sander Mateos wrote:
>> On Wed, May 27, 2026 at 9:19?AM Rahul Chandelkar <rc@rexion.ai> wrote:
>>>
>>> On Wed, May 27, 2026 at 10:06:44AM -0600, Jens Axboe wrote:
>>>> I don't think this is the right way to fix it, ->sqe should've been
>>>> stable upfront if this ends up happening. Can you share your poc with
>>>> me? Your trace has been trimmed down way too much to be useful.
>>>
>>> Agreed that a core-level copy before the inline callback would be the
>>> right fix and would eliminate the entire class for every uring_cmd
>>> driver. The per-driver copy was meant as a minimal backportable fix
>>> for the immediate scsi_bsg path.
>>>
>>> PoC and full trace below.
>>>
>>> --- PoC (poc_bsg_toctou.c) ---
>>>
>>> Build:  gcc -O2 -pthread -static -o poc poc_bsg_toctou.c
>>> Usage:  ./poc /dev/bsg/X
>>> Needs:  2+ CPUs, io_uring, /dev/bsg/* access
>>>
>>> The racer thread flips request_len between 16 (passes the <=32 bounds
>>> check) and 128 (used by copy_from_user, overflows scmd->cmnd[32]).
>>> The overflow payload plants 0xdead000000001000 at the sense_buffer
>>> pointer offset (+84 from cmnd[0]). When scsi_queue_rq() does
>>> memset(scmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE) it faults on the
>>> corrupted pointer.
>>
>> Then the fix is to use READ_ONCE() to access the SQE fields, right?
>> Copying the entire SQE seems like unnecessary overhead. See
>> nvme_uring_cmd_io() for prior art.
> 
> That is indeed the correct fix.

To be a bit more clear for the original reporter, in the hopes that they
will send a v2. Doing things like:

	if (cmd->addr)
		validate_addr(cmd->addr);

	[...]

	Use cmd->addr, we already validated it.

Is not safe, as ->addr can change in between. All of the sqe related
bits which cmd is should follow the pattern of:

	addr = READ_ONCE(cmd->addr);
	if (addr)
		validate_addr(addr);

	[...]

	Use addr, we already validated it, and it cannot have changed.

Copying 128b in both places is a big hammer, the code just needs to use
the proper access mechanism.

-- 
Jens Axboe

