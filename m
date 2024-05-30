Return-Path: <io-uring+bounces-2013-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0DC28D4FC1
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 18:21:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C347A1C232F4
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 16:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2D5210F8;
	Thu, 30 May 2024 16:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0ImOQ6Fw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6831CF94
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 16:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717086085; cv=none; b=OV0ttj2ubq1cCPuG31hpfwRjh0+O871Sj4YFO/za08HTYX5gnHwqJY41clnQSqr9i3C5Bjyy5chRXqQOWAbTISuW/kFrj0oEghbIKfDHpafPgRMVn7X7rw0c8aN/OCjzyWVlujr37bGMSCmiRZ1e3kbeql2ViNr79rgxSQktXMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717086085; c=relaxed/simple;
	bh=jLCnzk1FgN12Kwp/oacBiVBLmsM1zx3ZPo3OjeUZ3l8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G+AMHnTlwyQWdocHwT1014/Ru+H6u6qhygn/Lsmnfg6E1tj4HjHRzfC1/P6Q0t8nCs96sC1kuBR4t8Hua9EgQmA/bKsv+ol6VV/J/it2kY57oeuVQKGs2RrpjOyTN3EQl7Enr6SdfyRccZIRZHtSoMaSRpsZ/fV/vODbX98kZgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0ImOQ6Fw; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3d1a094b2b0so63052b6e.3
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 09:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717086082; x=1717690882; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OieraxBcsvRTdK3OcSRojD9cGTahPveJy8SszB1ZOBE=;
        b=0ImOQ6Fwqm4HfrIZLyzqtIce4FVtiiUMiu9RN6JyRMEgDOLPAnu1LJzbxvJ/V9TTSg
         xC2iAJvQiKdOi3QlDJyfZEY/OI7APZEGdMdpOaZQH54BHCIv9wRMs9quZm2A3fgMlDTx
         KwQWWFiLUGF3hHlvyBnxEUH/aSzw+G6wX/1TfeINUL/kd3FjXnb7aZuW2kk/wcUaLhuk
         uio8s5Ok512O4j+dSjboF9ZaLajyj4Oe/dlGA5gPuM5xIfrlrUuSxPYi+d1Gea9Z2o8x
         v6PwVC4EaYi/0XLH//+6SA/IWW1HYs8f2MFNO3RsAEKTABZ/DS07dVcHSkNauIr7EaNk
         ukbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717086082; x=1717690882;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OieraxBcsvRTdK3OcSRojD9cGTahPveJy8SszB1ZOBE=;
        b=vfJoo7qp7xU+aVcrKGaseSRj9ZTI4rrSWHBYTkJrbkwPgIFOVFyZk03TdYmgP+WFnp
         2pYbVjDVcxtGeud6m3DjikCvUMdPncg0PKN7ek2XsahdHeHp2TJvegBgIEqamJiR/mWE
         g9lhS1EqN7+fmN04pJpzZ1GsfIumqZgqGaXMi31d4FBNPpx3OQH9vnKmh6pvr6h3vAof
         czYSEOcAwyPDzjRgAmWYE3o2JDTkPvIVAvmSRr1FuBd6D05tspi4zPQwJDPYToojOJiN
         Cn8U5p8+FhQXRT+2yAFYl4/p75Mj+JZR8B/OvQUcNsU+O7C2tOt8DdlxC/0Hdf4YTqLL
         98cw==
X-Forwarded-Encrypted: i=1; AJvYcCWvWs5dMr+/gUOHYDvb93zvdbHtwGk2FmnVtc5+3TufdTg2vipHpi8g74nNjBHLJIX5bkDLQXjWvePMOn6BPk3r+gYpWssDEto=
X-Gm-Message-State: AOJu0Yz59EPw6i16d9QynfVURQgVmgJHZ4M3BgI4Yt/3+zRFR1IQ93hG
	CM60bcYSQoMEHny2ShOwCKjDZOQsK/rWujYpRD/mMfLarSgVE0LwKD9n/Rwn7bUi54YlOCzAaOK
	U
X-Google-Smtp-Source: AGHT+IGaxrcFOIbphwZTYIv0ek+RxPvRrF6ZGN6TagnzapF/2qunE37ScKDQuQWCgn/L7gsn4PPBgw==
X-Received: by 2002:a05:6830:7203:b0:6f0:6420:35d6 with SMTP id 46e09a7af769-6f90af7702cmr2780805a34.3.1717086081998;
        Thu, 30 May 2024 09:21:21 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f91059cc0bsm12129a34.57.2024.05.30.09.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 09:21:20 -0700 (PDT)
Message-ID: <9db5fc0c-cce5-4d01-af60-f28f55c3aa99@kernel.dk>
Date: Thu, 30 May 2024 10:21:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Bernd Schubert <bernd.schubert@fastmail.fm>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>,
 io-uring@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
 Pavel Begunkov <asml.silence@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <5mimjjxul2sc2g7x6pttnit46pbw3astwj2giqfr4xayp63el2@fb5bgtiavwgv>
 <8c3548a9-3b15-49c4-9e38-68d81433144a@fastmail.fm>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8c3548a9-3b15-49c4-9e38-68d81433144a@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/24 10:02 AM, Bernd Schubert wrote:
> 
> 
> On 5/30/24 17:36, Kent Overstreet wrote:
>> On Wed, May 29, 2024 at 08:00:35PM +0200, Bernd Schubert wrote:
>>> From: Bernd Schubert <bschubert@ddn.com>
>>>
>>> This adds support for uring communication between kernel and
>>> userspace daemon using opcode the IORING_OP_URING_CMD. The basic
>>> appraoch was taken from ublk.  The patches are in RFC state,
>>> some major changes are still to be expected.
>>>
>>> Motivation for these patches is all to increase fuse performance.
>>> In fuse-over-io-uring requests avoid core switching (application
>>> on core X, processing of fuse server on random core Y) and use
>>> shared memory between kernel and userspace to transfer data.
>>> Similar approaches have been taken by ZUFS and FUSE2, though
>>> not over io-uring, but through ioctl IOs
>>
>> What specifically is it about io-uring that's helpful here? Besides the
>> ringbuffer?
>>
>> So the original mess was that because we didn't have a generic
>> ringbuffer, we had aio, tracing, and god knows what else all
>> implementing their own special purpose ringbuffers (all with weird
>> quirks of debatable or no usefulness).
>>
>> It seems to me that what fuse (and a lot of other things want) is just a
>> clean simple easy to use generic ringbuffer for sending what-have-you
>> back and forth between the kernel and userspace - in this case RPCs from
>> the kernel to userspace.
>>
>> But instead, the solution seems to be just toss everything into a new
>> giant subsystem?
> 
> 
> Hmm, initially I had thought about writing my own ring buffer, but then 
> io-uring got IORING_OP_URING_CMD, which seems to have exactly what we
> need? From interface point of view, io-uring seems easy to use here, 
> has everything we need and kind of the same thing is used for ublk - 
> what speaks against io-uring? And what other suggestion do you have?
> 
> I guess the same concern would also apply to ublk_drv. 
> 
> Well, decoupling from io-uring might help to get for zero-copy, as there
> doesn't seem to be an agreement with Mings approaches (sorry I'm only
> silently following for now).

If you have an interest in the zero copy, do chime in, it would
certainly help get some closure on that feature. I don't think anyone
disagrees it's a useful and needed feature, but there are different view
points on how it's best solved.

> From our side, a customer has pointed out security concerns for io-uring. 

That's just bs and fud these days.

-- 
Jens Axboe


