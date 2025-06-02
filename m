Return-Path: <io-uring+bounces-8182-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6000EACADAB
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 13:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40F953B4320
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 11:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DB7B1F150A;
	Mon,  2 Jun 2025 11:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lUUtdur7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067A214F70
	for <io-uring@vger.kernel.org>; Mon,  2 Jun 2025 11:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748865317; cv=none; b=RYBIwL0JGpn966gydVi8Hn/stM7UA0SS8A2duC0GRXp0Can3th4ThLvO/plUmiyqipiAx8dHhMyHV/lbyuA2UrNyVnhP99ZgjrAtjmE8m8Ete9uF8kFRziwp/OKdslcj9tV6fFznvb9+yJLNvFmBEiWRTXtJlss4VfZltDT9Ne8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748865317; c=relaxed/simple;
	bh=a68/R4FRXht74S7lJKCigWED7vMuOuk49O5IAGyC2Xo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X2241FTbkEtOmRmmdZgo2W8e37wqqb+32o1NCz34Bc/WKs9CyYY4i8urWcNh7vwSBWPzLRw6c0gGTQghbyM3o9+1ZXPuXI5/4Xg+WsySAp1RQm248qjhRi/l1sLZBT0iGWAb6346QvXMZCoA2XyHKp2cqZl2n4Bd7HRRtote5HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lUUtdur7; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-86efcef9194so41651139f.0
        for <io-uring@vger.kernel.org>; Mon, 02 Jun 2025 04:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748865313; x=1749470113; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3M3/Trjx8G1i4E0SM4Np4umoU2vMAHu4HjJrz/LmkDc=;
        b=lUUtdur7QKkoveN87UpzlpMII653k5vQVO/M9xAhr1nzeQxhYhqdfwM+NLfYLJVASM
         40Hnv5acl2zupQ6quD3G3bF/TIf5CiyrBA9WaYe4wgX+unE/NX+EpJHv+imix1g13tdp
         ZqyMx1SZdIGg5KrzITb2PYGN9Xo5veSB66fx8f9mZ5mK6KVUofKGpjVZmctbwI47gSaq
         yv5xz7uBknLybr5eYKfWW4pqvu9l3D/GGgZ2w5kDYi5rs8sZRtLv7tT7rEJPUBT7oybG
         Php52JoCpS3ZPTZCzwDXljYG4vw+mftaRHUHu9h/t7Fc0Epo1n3sygw+JSr74kgbPtSd
         Z9TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748865313; x=1749470113;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3M3/Trjx8G1i4E0SM4Np4umoU2vMAHu4HjJrz/LmkDc=;
        b=jxg1OoVKUF1eFfqtwCiwxEFiBOWHSYBaazqwCIh5rJP3MkZGE+fa96NAhiVHI5QvXE
         nNicfOLF+FHATGBzVREuTuCUcoqGoeE9Ki/GmYk1Km/CoE0rVnVWOsZWTeL/7i3djDVd
         BPGyHAqLkrs6cxUpQJ8gysjtMACDGoqFymPQD0XFRrtxYU2fzEaekUYsnevRNzcTxqIv
         63hmUofcyB5hQLIVw0qIlqPhC6WwPjeilg4rF/9v/cSkVxpOfWCWdThEPpbS71RhvS+N
         HTYyEuMy9fff7kZ6KlyOepBA6ngrgEngNRghvWtLqe3tAZTCChafXvZvyPGMip5s815H
         nhkg==
X-Forwarded-Encrypted: i=1; AJvYcCVb0KyMl8wRI21sIPe7PnatiVhF4DxEYd+QMidFGLsTjQHOSSnatelo0TVJEPgkFYJaJ5d4ADfWew==@vger.kernel.org
X-Gm-Message-State: AOJu0Yypki8EkLLNXKm+4jy/ykcyqY5TLEZ1nLotSl1qwkLLG8YbgH/e
	+/pebWauMwIgc4qhFP5W7DiYTwf4oxJkyAHeDdtdpLMbkM/2VfChwjPQDSgzT2C6pxo=
X-Gm-Gg: ASbGncuPonazDct204aZKG+iNvcaGlUbdemHdUks7cwSRAAwVuUmdjityLTzbFLSLIl
	ZE1QvuE9jtFAdNAmRoMabN2dGV73NQR+XF9w1vnlY5xtTjrRE/bXZtutpXCcI3mhGNgJPjrpHBn
	7ikt0dMcoyrzDkTE2nRLheX3uu3fWwSOPwqn9vvjlcmZe6gpIRLww8JA0AzGmt4jML+HAVVnxGF
	+VkNJcEI1HLUde6+1h/RXHbnAFggIvH6t2sTWRw5ESZo2M2ZcOxlTp8Gc7D72vMelqAlNZ2EQAz
	9e7QyCzOhj5scFGmOmu4cS/51MWKs+TBJ2QoA8+y1bZI+LOl1AYZb5+q6gg=
X-Google-Smtp-Source: AGHT+IGXVirstTyzSCqTNU8TfY1KQuNTu4arKqQExEMzIJOeUgyS3TrVwWhQ+pAuNYar78nuPiJiVw==
X-Received: by 2002:a05:6602:2b96:b0:86c:f2c1:70d1 with SMTP id ca18e2360f4ac-86d05094616mr936679739f.1.1748865312752;
        Mon, 02 Jun 2025 04:55:12 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86cf5e79acfsm182621139f.19.2025.06.02.04.55.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 04:55:12 -0700 (PDT)
Message-ID: <546c11ec-25af-4f98-b805-1cb9e672c80b@kernel.dk>
Date: Mon, 2 Jun 2025 05:55:11 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/uring_cmd: be smarter about SQE copying
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <5d03de61-1419-443f-b3a4-e1f2ac2fe137@kernel.dk>
 <6659c8b0-dff2-4b5c-b4bd-00a8110e8358@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6659c8b0-dff2-4b5c-b4bd-00a8110e8358@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/2/25 4:24 AM, Pavel Begunkov wrote:
> On 5/31/25 21:52, Jens Axboe wrote:
>> uring_cmd currently copies the SQE unconditionally, which was introduced
> ...>       /*
>> -     * Unconditionally cache the SQE for now - this is only needed for
>> -     * requests that go async, but prep handlers must ensure that any
>> -     * sqe data is stable beyond prep. Since uring_cmd is special in
>> -     * that it doesn't read in per-op data, play it safe and ensure that
>> -     * any SQE data is stable beyond prep. This can later get relaxed.
>> +     * Copy SQE now, if we know we're going async. Drain will set
>> +     * FORCE_ASYNC, and assume links may cause it to go async. If not,
>> +     * copy is deferred until issue time, if the request doesn't issue
>> +     * or queue inline.
>>        */
>> -    memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
>> -    ioucmd->sqe = ac->sqes;
>> +    ioucmd->sqe = sqe;
>> +    if (req->flags & (REQ_F_FORCE_ASYNC| REQ_F_LINK | REQ_F_HARDLINK) ||
>> +        ctx->submit_state.link.head)
>> +        io_uring_sqe_copy(req, ioucmd);
>> +
> 
> It'd be great if we can't crash the kernel (or do sth more nefarious with
> that), and I'm 95% sure it's possible. The culprit is violation of
> layering by poking into io_uring core bits that opcodes should not know
> about, the flimsiness of attempts to infer the core io_uring behaviour
> from opcode handlers, and leaving a potentially stale ->sqe pointer.

Sure, it's not a pretty solution. At all. Might be worth just having a
handler for this so that the core can call it, rather than have
uring_cmd attempt to cover all the cases here. That's the most offensive
part to me, the ->sqe pointer I'm not too worried about, in terms of
anything nefarious. If that's a problem, the the uring_cmd prep side is
borken anyway and needs fixing. Getting it wrong could obviously
reintroduce potential issues with data getting lost, however.

It's somewhat annoying to need to copy this upfront for the fairly rare
case of needing it.

-- 
Jens Axboe

