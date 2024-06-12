Return-Path: <io-uring+bounces-2195-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4856D905913
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 18:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A86E11F22A9B
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 16:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF54181B91;
	Wed, 12 Jun 2024 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="4XUItZ5a";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Z4wh9ljO"
X-Original-To: io-uring@vger.kernel.org
Received: from fout2-smtp.messagingengine.com (fout2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8A716C878;
	Wed, 12 Jun 2024 16:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718210698; cv=none; b=eOKhlXeVeUtwPtqlEku1JIhOfP/ggt6ODC7Bb24id6xOeQ7BzIbYspZ/weQVtyX7p8VUA4d7yuzazToi2wIKtBUZRJzt8TzHTngwnnJFVFkiR0+yD8PGekIkAfpzgTtLsfK5HdkC71OU+eEBx0d7eBaX4HBGbP6wnyobWlXZNjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718210698; c=relaxed/simple;
	bh=W370/b3sRJA8rRIniDdp4JJ0ZMfMcdXK67Tg2C071Tc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lu2c8HFdhY1B8oN4hi+MnMBd3DkOiSbfDkR7bW3zATDu9rpybIzqSJJrfJRT6a1x8Hk3lEbXobjpatmcA8QWZuksem9eZov5vrMn8KCaULi5mlnJUVJuc8TB4cZDTbxZK0z9EBZ0JexRHwcCG1uFXm98mtgAwH+YlEy9VBe/qtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=4XUItZ5a; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Z4wh9ljO; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailfout.nyi.internal (Postfix) with ESMTP id 0AA6913801BA;
	Wed, 12 Jun 2024 12:44:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 12 Jun 2024 12:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1718210696;
	 x=1718297096; bh=D55YX+W40OzYpbYOsRCkEGZUBWknjhYT4/HuwuDHGQs=; b=
	4XUItZ5a/XsoqAwUARxsDySMX+lfsq5z0LNZG7EclcpqTfvBVlzbAAAy9PvyWfko
	cvwB7JnBAmY68BtFqW9GvPBR/XduzufPjmEjY518+X/4IzXRnP6YoTB+kf2yuJNF
	0RT6egN2+p8bxZkEw7bByzHC1/0Camxx332Nk2HKSzvRpIc7C9p/4p3rj9WZ69YY
	mZWoseye8r6ziyyZiR+5GfeIVjAYh51c2S1ATVsZBR1b5JrqiqG6Cob7bUCq+Xli
	cbYoTLRHJ77GaAShHipR7VTHpZTruyG9GilsBAL6nAQ6IY8MTk/+vxAQnM2umi2Q
	lW2mAHpepqtbajtggnG3mw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1718210696; x=
	1718297096; bh=D55YX+W40OzYpbYOsRCkEGZUBWknjhYT4/HuwuDHGQs=; b=Z
	4wh9ljOGLsoXz0/LQXg/4U/RG5W/7yAI5aL5GeWHWkFOIRgOpeImN+o7Q6wSwNNs
	ViH52oIZhIHb8JM7gFeuIjLS5cqKl1EGpovg3nBexcwxKuRkmJlnKp6/RNKG7xx5
	WWGZNr75BZW4X6OkuSpnzxwtmt3WKh7z4vRh5sDVtWa8u/ON2EzwhslWqsYFrw2B
	9K+Vc5QJSkYLcfcHM4wdOCSkQy9aYAw20bSxMXS57+g2tf0+6PQlskiX60NsjU2n
	0U527baPDmrPUGg+GisbGeggfeRaangXKsO+yO1oDrXtznSqtHyJHc8aF63r0TdS
	qYCqY01BXJNL2WYVFIPeA==
X-ME-Sender: <xms:h9BpZoPL4WnoO2OTrCiH_T-V6wwgtNMdboPNYz3S-w_0SKChp-dPMQ>
    <xme:h9BpZu90tXDgYicc3sBtEQkMQeHvKe1wrzkG2AYRhsB1oMWpXHOgmiwzfIpMvTvev
    HKFDBcGu-jbM8Np>
X-ME-Received: <xmr:h9BpZvTbBQprntHl-kQ2LFAzTnYNQpsVoipafYfEVqftwBrwvxgCuZi99uexE9LahQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrfedugedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepuegv
    rhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusggvrhhtsehfrghsthhmrg
    hilhdrfhhmqeenucggtffrrghtthgvrhhnpeetteejudevudefffdutefgledvvdfgtdel
    ueeifeegudehkeelkeeffedvieehkeenucffohhmrghinhepghhnuhifvggvsgdrohhrgh
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghr
    nhgurdhstghhuhgsvghrthesfhgrshhtmhgrihhlrdhfmh
X-ME-Proxy: <xmx:h9BpZgtL7ymPOnbnQcSxtgXfCpi6a0wKAdutgajGQpJZbkxYaOCQ9g>
    <xmx:h9BpZgeatsxt_nyTcj6HNrilQgr7dbrdtBOkz-Cd1mAhD3BgQaaC7A>
    <xmx:h9BpZk17fMkVKJsW844Kz8n_6lDNJYVqSXtigkUfBIGN_QuqzHOJgg>
    <xmx:h9BpZk8_YYQX93LMDyHaknlvkWLQi2rauBz76H-qM4Zuf2Pb13TKkw>
    <xmx:iNBpZk37Cx_Pc0EuY8ZOJyxbXet_l6ClNWbsuO7KcBH7hq4Jkub87JCH>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Jun 2024 12:44:54 -0400 (EDT)
Message-ID: <8d270a22-edf4-4e38-8b62-6504c4101c6a@fastmail.fm>
Date: Wed, 12 Jun 2024 18:44:53 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Amir Goldstein <amir73il@gmail.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
 <im6hqczm7qpr3oxndwupyydnclzne6nmpidln6wee4cer7i6up@hmpv4juppgii>
 <a5ab3ea8-f730-4087-a9ea-b3ac4c8e7919@fastmail.fm>
 <olaitdmh662osparvdobr267qgjitygkl7lt7zdiyyi6ee6jlc@xaashssdxwxm>
 <4e5a84ab-4aa5-4d8b-aa12-625082d92073@ddn.com>
 <hhkehi7qlcjulhyvtd5j25cl3xw764cjk7tbsakf3ueerdhp3j@6d2nka5oalzn>
 <d5f61930-beb5-495b-9227-4531de98dae8@fastmail.fm>
 <3bh7pncpg3qpeia5m7kgtolbvxwe2u46uwfixjhb5dcgni5k4m@kqode5qrywls>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US
In-Reply-To: <3bh7pncpg3qpeia5m7kgtolbvxwe2u46uwfixjhb5dcgni5k4m@kqode5qrywls>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/12/24 18:24, Kent Overstreet wrote:
> On Wed, Jun 12, 2024 at 06:15:57PM GMT, Bernd Schubert wrote:
>>
>>
>> On 6/12/24 17:55, Kent Overstreet wrote:
>>> On Wed, Jun 12, 2024 at 03:40:14PM GMT, Bernd Schubert wrote:
>>>> On 6/12/24 16:19, Kent Overstreet wrote:
>>>>> On Wed, Jun 12, 2024 at 03:53:42PM GMT, Bernd Schubert wrote:
>>>>>> I will definitely look at it this week. Although I don't like the idea
>>>>>> to have a new kthread. We already have an application thread and have
>>>>>> the fuse server thread, why do we need another one?
>>>>>
>>>>> Ok, I hadn't found the fuse server thread - that should be fine.
>>>>>
>>>>>>>
>>>>>>> The next thing I was going to look at is how you guys are using splice,
>>>>>>> we want to get away from that too.
>>>>>>
>>>>>> Well, Ming Lei is working on that for ublk_drv and I guess that new approach
>>>>>> could be adapted as well onto the current way of io-uring.
>>>>>> It _probably_ wouldn't work with IORING_OP_READV/IORING_OP_WRITEV.
>>>>>>
>>>>>> https://lore.gnuweeb.org/io-uring/20240511001214.173711-6-ming.lei@redhat.com/T/
>>>>>>
>>>>>>>
>>>>>>> Brian was also saying the fuse virtio_fs code may be worth
>>>>>>> investigating, maybe that could be adapted?
>>>>>>
>>>>>> I need to check, but really, the majority of the new additions
>>>>>> is just to set up things, shutdown and to have sanity checks.
>>>>>> Request sending/completing to/from the ring is not that much new lines.
>>>>>
>>>>> What I'm wondering is how read/write requests are handled. Are the data
>>>>> payloads going in the same ringbuffer as the commands? That could work,
>>>>> if the ringbuffer is appropriately sized, but alignment is a an issue.
>>>>
>>>> That is exactly the big discussion Miklos and I have. Basically in my
>>>> series another buffer is vmalloced, mmaped and then assigned to ring entries.
>>>> Fuse meta headers and application payload goes into that buffer.
>>>> In both kernel/userspace directions. io-uring only allows 80B, so only a
>>>> really small request would fit into it.
>>>
>>> Well, the generic ringbuffer would lift that restriction.
>>
>> Yeah, kind of. Instead allocating the buffer in fuse, it would be now allocated
>> in that code. At least all that setup code would be moved out of fuse. I will
>> eventually come to your patches today.
>> Now we only need to convince Miklos that your ring is better ;)
>>
>>>
>>>> Legacy /dev/fuse has an alignment issue as payload follows directly as the fuse
>>>> header - intrinsically fixed in the ring patches.
>>>
>>> *nod*
>>>
>>> That's the big question, put the data inline (with potential alignment
>>> hassles) or manage (and map) a separate data structure.
>>>
>>> Maybe padding could be inserted to solve alignment?
>>
>> Right now I have this struct:
>>
>> struct fuse_ring_req {
>> 	union {
>> 		/* The first 4K are command data */
>> 		char ring_header[FUSE_RING_HEADER_BUF_SIZE];
>>
>> 		struct {
>> 			uint64_t flags;
>>
>> 			/* enum fuse_ring_buf_cmd */
>> 			uint32_t in_out_arg_len;
>> 			uint32_t padding;
>>
>> 			/* kernel fills in, reads out */
>> 			union {
>> 				struct fuse_in_header in;
>> 				struct fuse_out_header out;
>> 			};
>> 		};
>> 	};
>>
>> 	char in_out_arg[];
>> };
>>
>>
>> Data go into in_out_arg, i.e. headers are padded by the union.
>> I actually wonder if FUSE_RING_HEADER_BUF_SIZE should be page size
>> and not a fixed 4K.
> 
> I would make the commands variable sized, so that commands with no data
> buffers don't need padding, and then when you do have a data command you
> only pad out that specific command so that the data buffer starts on a
> page boundary.


The same buffer is used for kernel to userspace and the other way around 
- it is attached to the ring entry. Either direction will always have
data, where would a dynamic sizing then be useful?

Well, some "data" like the node id don't need to be aligned - we could 
save memory for that. I still would like to have some padding so that
headers could be grown without any kind of compat issues. Though almost 
4K is probably too much for that.

Thanks for pointing it out, will improve it!

Cheers,
Bernd

