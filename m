Return-Path: <io-uring+bounces-3304-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A72986046
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 16:19:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56FA9B2673F
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 14:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C64AD183CB1;
	Wed, 25 Sep 2024 12:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OyRWU5t1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1488213DBBC;
	Wed, 25 Sep 2024 12:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727266959; cv=none; b=ZVbiC/b47EKjS1V+dfGDbm/D0VCDZ9nNew1LjfXmVdJbEgLvm5T4/va8fdxWCBDvB0BrMi0xwPGVWbEyK+RdRwuKtwOKgBWT9cgqFSEj46VlKzC3nsmfW7lIHOV0Xbl1pilzdsfwH2ZJ7IL4fe+6sxVFO6Cn55zJnc8+EgkqYmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727266959; c=relaxed/simple;
	bh=2nTLYXHLashP6U5iqb2SNaeRGPOeYJIEzFyRmQOBPvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rRf8LWRfi8e3yw2QyDPuM1GSiC+jp2it6glf7BjF9m+060KuyWQijYzNeJV+sKqwz26lbSXtaV0ogsUWUwpN1c/gd28uFOp1arPiXOcAQuvBD0bL6BRcyoIsUVnr21RO2N3byqwWvkXXkAXTPEtOHY11FL9V9D2zgSIrGn2jO7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OyRWU5t1; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c241feb80dso1680885a12.0;
        Wed, 25 Sep 2024 05:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727266956; x=1727871756; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e1vsdKX31ZQMJQnYW8l7+O8odVCjbHrQhd7IsOPE+00=;
        b=OyRWU5t1nMvpS+40cJm/SneXHoGtZpxT+DWxK9bxhTjfxGTgyhFXzWx26WLOhYy+yJ
         xsDjzi7MRAzy5GXcPBb5tucNxsDDMyPRkV457d9R5cYmxDqF1b67nlwhHbYEiatBxxaF
         DyFTYGiOR8Bx6CfhFwdrlXAA4ZqyLKlt+nMg6jyCMKooG2CkR1xu7LqPJhO+SkbJz0Vz
         wDBYDq2/vtXrJ5mm2x6Gsq0z0txoH1iUs6wsJ9fKtzL4gI4rWf9IBzuCC2SLRpqug1pr
         pNbD8tYMXSWf1jKvwJxMimRBPnKO/8HvU4hKIH0ujOaf0OkTjJS8bKAnhHjLMHvBPRTI
         0EeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727266956; x=1727871756;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e1vsdKX31ZQMJQnYW8l7+O8odVCjbHrQhd7IsOPE+00=;
        b=tkgCoL7V5kX00905qpd8lhnH0A5rgL4/MNDytd1oqOvi3/wHa2RqdflbIsbt/voU2U
         6LNMWijWPL23yQ8vaepDt1edMYG+CWrz1j7EvoXrF3XLDBPtnVkFZflfBeDEBI4RSN0n
         3zTjZen1A7MMS7P70fit6xehf1lkPGci5LHYghIXVCjOCRyWe4TErkH0Nq3aMUNm228g
         6ssoUunxqgFaEdEp4K9QP6GMrIEz6eTth/vzuzn56P+NWvBq0hZmST2IhLlppnyPxEGS
         PtMLNJb8mTujlpilhRSFAzzgA/TKoeD1bJoz7XTGtQmEuncMYua+sWuQtJXpHIVEk/8I
         z0mA==
X-Forwarded-Encrypted: i=1; AJvYcCVyfWxdNIa7W8EayNUtSWSyLzGco/IvhCNuVKWJ1n7lTvxLWrJ13hlEU2OroSH4905U15FWNDSUaYea8RI=@vger.kernel.org, AJvYcCXHhV4N783dh+Tpxc0QDyKdMkZVKQ3FLRsVsRgb5K+2XNllvYdgeyrSg8wD6BVNY1DF0vIvPBGRQtYzelDRMA==@vger.kernel.org, AJvYcCXWxegUowp1CrnTLhnKFyIfwiyLYxvGxRsLlFUQ6bvJq9I0ZLiBFzlMGpQ7tEWNgo7Ql2S0RIk8dw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywop3LqtbjljBtpE18cuxabgLzIHYnetHiR5sfOOdVfjaVcqlkM
	SglYQvUs0bEolMlMswa1iJ4nUstZxKk1OQ2chodqVjIb0cFjzOjX
X-Google-Smtp-Source: AGHT+IHy8FnDpRRZ0xuHx941u/L73CdgNsgVKXSABy4Wq1uMlQmuwdBzBKZV8xBOb4xFnl0sRAAXbg==
X-Received: by 2002:a05:6402:13d2:b0:5c4:1c0c:cc6d with SMTP id 4fb4d7f45d1cf-5c5cdf051d2mr7695812a12.0.1727266955977;
        Wed, 25 Sep 2024 05:22:35 -0700 (PDT)
Received: from [192.168.92.221] ([85.255.235.163])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c5cf49dbbdsm1802486a12.57.2024.09.25.05.22.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2024 05:22:35 -0700 (PDT)
Message-ID: <cb3302c0-56dd-4173-9866-c8e40659becb@gmail.com>
Date: Wed, 25 Sep 2024 13:23:14 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] io_uring: enable per-io hinting capability
To: Kanchan Joshi <joshi.k@samsung.com>, Hannes Reinecke <hare@suse.de>,
 axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
 martin.petersen@oracle.com, brauner@kernel.org, viro@zeniv.linux.org.uk,
 jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
 bvanassche@acm.org
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
 gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com,
 Nitesh Shetty <nj.shetty@samsung.com>
References: <20240924092457.7846-1-joshi.k@samsung.com>
 <CGME20240924093257epcas5p174955ae79ae2d08a886eeb45a6976d53@epcas5p1.samsung.com>
 <20240924092457.7846-4-joshi.k@samsung.com>
 <28419703-681c-4d8c-9450-bdc2aff19d56@suse.de>
 <678921a8-584c-f95e-49c8-4d9ce9db94ab@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <678921a8-584c-f95e-49c8-4d9ce9db94ab@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/25/24 12:09, Kanchan Joshi wrote:
> On 9/25/2024 11:27 AM, Hannes Reinecke wrote:
...
> As it stands the new struct will introduce
>> a hole of 24 bytes after 'hint_type'.
> 
> This gets implicitly padded at this point [1][2], and overall size is
> still capped by largest struct (which is of 16 bytes, placed just above
> this).

For me it's about having hardly usable in the future by anyone else
7 bytes of space or how much that will be. Try to add another field
using those bytes and endianess will start messing with you. And 7
bytes is not that convenient.

I have same problem with how commands were merged while I was not
looking. There was no explicit padding, and it split u64 into u32
and implicit padding, so no apps can use the space to put a pointer
anymore while there was a much better option of using one of existing
4B fields.


> [1] On 64bit
> »       union {
> »       »       struct {
> »       »       »       __u64      addr3;                /*    48     8 */
> »       »       »       __u64      __pad2[1];            /*    56     8 */
> »       »       };                                       /*    48    16 */
> »       »       struct {
> »       »       »       __u64      hint_val;             /*    48     8 */
> »       »       »       __u8       hint_type;            /*    56     1 */
> »       »       };                                       /*    48    16 */
> »       »       __u64              optval;               /*    48     8 */
> »       »       __u8               cmd[0];               /*    48     0 */
> »       };                                               /*    48    16 */
> 
> »       /* size: 64, cachelines: 1, members: 13 */
> 
> [2] On 32bit
> 
> »       union {
> »       »       struct {
> »       »       »       __u64      addr3;                /*    48     8 */
> »       »       »       __u64      __pad2[1];            /*    56     8 */
> »       »       };                                       /*    48    16 */
> »       »       struct {
> »       »       »       __u64      hint_val;             /*    48     8 */
> »       »       »       __u8       hint_type;            /*    56     1 */
> »       »       };                                       /*    48    12 */
> »       »       __u64              optval;               /*    48     8 */
> »       »       __u8               cmd[0];               /*    48     0 */
> »       };                                               /*    48    16 */
> 
> »       /* size: 64, cachelines: 1, members: 13 */
> };

-- 
Pavel Begunkov

