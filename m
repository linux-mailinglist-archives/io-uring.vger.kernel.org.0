Return-Path: <io-uring+bounces-13401-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yOW7CXohC2oQDwUAu9opvQ
	(envelope-from <io-uring+bounces-13401-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 16:26:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9F0156EB3A
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 16:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E2BB13024A8C
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 14:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7016A47B40D;
	Mon, 18 May 2026 14:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jFK1UxCj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB52748164F
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 14:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114244; cv=none; b=I2qnKuT7yhy5BGklAHhPsW4LXPCRuafQM9BoBESMcpfRYYRCG3yDKmA04pFYvc6Fh4h1syFsIiwNhpmMmRlfmGuLtQ5tHy3q4RlA+tf1Dr1cAMmHiX7uSapEHUUlhF8xvJTcM4w7Gb47BnAHJb2bLuBJFuMrsTz4SAx0BGO6DIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114244; c=relaxed/simple;
	bh=Ja0DTfaEYIoGmin0aywYwaWpB4UWlA4iW9ZxB9BMNMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mHfQmfgVK2QiHZwO7wsVW8esS0T4lwQhzISP9Z0a+gl8YtFx1eKpvGz9niTYZUv6NX4s8ELbTUSZIdjGwgjGqend8L07fLiSU2muB00MCEyZ0sE8ZKqqrqaKbEhOPcL3ZIebcnZBW/Kkhvjn86j0uWtexA8uX7uSx+nVvP9Mnmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jFK1UxCj; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bd8f9889a8cso8294966b.1
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 07:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779114237; x=1779719037; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m58bYDJ543WmyZ11IWytLuY71YuFJ2Bw6ePCWpryz/I=;
        b=jFK1UxCj/9hu/WpBG5drcZwxOWtR6cGYB4ErAsxcCoLRnUmHgxSqEAMVAolDJJrH9Z
         1hdwdgmStI3zkbuwkOFKLgAduKUp4s7IUV0QrqjtVZyxKN2R7lpp0/keTjJeNXORBfRY
         iKxXU0l5N5r8xvhB9XCY4w6jrNvDuJXLhYZ9wYbjP+gKbOrmICrOApzAhigvnRrrinaL
         Gb3NRTZM32EVOdDbYX5+S47nP2KhGAiP8F7wO2/WZgTZ0Wdf97sbuXSYfnv1T9IEtqU5
         Nv1u3gHY/kqeewKzSvB0u83tg+4FS0uxqPRyB/9oZfAlZtbMwcY0Wlc9g1oZrrMLTZS/
         v+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779114237; x=1779719037;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m58bYDJ543WmyZ11IWytLuY71YuFJ2Bw6ePCWpryz/I=;
        b=B+Qd8/OJj4XCpYM3i6KLsoU3yfSZT4Uwcszzu7GJ/KqefaKL06q1ohiBnERbpKmVJ6
         vnIDc1AkxcY9UEC/c508gBYftDZ3vRJpK1UlvsL8NPyWyR8B9pCLT7YLCSUzVipYLfps
         8eyumltQ84QyI1TYxw6vZHceyn268yeJFgum1XJJAFxjXOHaphtNopoMhKr/PFhwzRr2
         gt0MTxzABS9X2bV6SYBrBmY4TqionvMNgAiVX6CtevRDQQyAJvb845jzFkuVYH0R3i4K
         a4BQzZCUiXfIOpL4EW3unlzLOZHOhGQdDscCuA4f2dipwJOkVjvj6n0po7pTjWvI4VLf
         5Vfg==
X-Forwarded-Encrypted: i=1; AFNElJ8wj1DDYvy5eSmojKgSX6TG/AFxgkNL2LS+hCALWYLRdhCxsgEHxoOjljcuYsIIqZvcsutY3VcotA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh4INLvjpbBzhRYv/aHYhm7CKFESqP91rcJLNZdlygNcD4W9Zy
	F0u9QEnIEAvyzQpLZurwZZwOB4KspGOB5H+GI+/QcGE67wJDUXY1E4Ai
X-Gm-Gg: Acq92OF/majVsSbKG4D/J0cf9UdsH7dpcyUV/pbybwl5y5UocfTUyP0q+MW/P0pErFb
	ubfQT4oKNiqS0/kZSlzMb/EnCSstTxcq1F/Sh5irdC6n4H6AL+YQdQHnL+k9uwij84BV9PhRolH
	0XLWbU0ECCIKCxUvPdnPxEibGlj/kkp0SJBOxozrBvssqYMT2c8te14HOOoE4+bTM7rT4RBOJHi
	eWwKg5Y9zoZVOV6/QGbHix0wBEOR+zRiJLxaxzafZJBxPTrUwJp0zc905wQxkTQ4R/YtAWU52Ja
	9BSD2LyWhtV+6q77r+/j8miYLaC/1XmKzpKScJVyBI0ROiN4mCNLMMIrOSl3R9axL2992lF0a6g
	acSGX/6lwDgENYiIudgviMYs73KGwdRvFmCg56sAZFH0PLCdAlAM690Wq6L28IpgQo83mxLTRub
	mXmBujlALg5AO/D7Mnp1ofbLJ2wPHUQsKcKUE3UQgkFGBGKxpYK8ClR32zFE+j4xKD8rF7tpPxA
	y85IfH/3auAhUqRuS3XR8gow4Sfr97UMi2BT82tOgxZaoRbcDcBhf7RyzRQO2IVatmngFa4UMdW
	aA==
X-Received: by 2002:a17:907:c291:b0:bd5:7a3:a58b with SMTP id a640c23a62f3a-bd517994249mr821357066b.46.1779114237152;
        Mon, 18 May 2026 07:23:57 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68310d58c79sm5325464a12.12.2026.05.18.07.23.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 07:23:56 -0700 (PDT)
Message-ID: <ea47051e-697f-4017-a514-be6ef7c110e9@gmail.com>
Date: Mon, 18 May 2026 15:23:53 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/10] lib: add dmabuf token infrastructure
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <c61e6d928f86f4cb253ae350272e6039faefd3a6.1777475843.git.asml.silence@gmail.com>
 <20260513082431.GA6461@lst.de>
 <ebf41920-5852-428f-b98a-e0f44c8f3315@gmail.com>
 <20260518125326.GA5754@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260518125326.GA5754@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13401-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: B9F0156EB3A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/18/26 13:53, Christoph Hellwig wrote:
> On Mon, May 18, 2026 at 11:14:09AM +0100, Pavel Begunkov wrote:
>>> This is about dma-buf based I/O.  So I'd expect it to be named dma-buf-io
>>> and no io-dmabuf, and live in drivers/dma-buf and not the unrelated lib/.
>>> But I'd like to hear from the dma-buf maintainers about that.
>>
>> Looking at what Ming is saying, it'd make more sense to keep some of the
>> parts like iterator and the file op more flexible and not automatically
>> imply dma-buf even if it's the main and for now the only medium. I.e.
>> ublk/fuse can use a similar interface for mapping buffers to the server
>> even without dma mappings.
>>
>> I don't know how the API should look like, maybe passing memfd, and dma-buf
>> supports mmap, but I think it's better to call the op something like
>> "register_buffer" instead and keep all it in lib/ for the same reasons.
> 
> Let's get the current version landed.  If we come up with some kind of
> non-dma dmabuf in the future we can refactor it and move it around.
> I'm a little skeptic we'll be able to share code as long as dmabuf
> is allergic to physical addresses, though.

To be fair, it's not that dma-buf specific. This lib/ code only
does some resv locking, fence waiting and queuing fences, otherwise
all the attaching is done by the driver behind callbacks. Switching
it to some memfd could be pretty simple. But The main thing it'd
need to share is iterator handling like forwarding in the block
layer, and it should be fine as it's already passed as a completely
opaque object with no knowledge about pages / dma / etc. for the
middle layers.

> lib/ is most certainly the wrong place for something that absolutely
> is not library functionality but directly interacts with a few
> subsystems.

It only interacts with dma-buf, and even for dma-buf attachments
are created by the driver. Block, nvme, io_uring are users, either
using the helpers or implementing callbacks.

Ok. Let's assume for the argument's sake it's not dma-buf
specific, if not lib/, where would you put it? I was also
assuming that dma-buf being under drivers/ is rather a relic
of the past rather than the desired location, hmm?


-- 
Pavel Begunkov


