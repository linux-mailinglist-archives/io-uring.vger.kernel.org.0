Return-Path: <io-uring+bounces-2647-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5991C946608
	for <lists+io-uring@lfdr.de>; Sat,  3 Aug 2024 01:03:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E7CE283324
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 23:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9361ABEB6;
	Fri,  2 Aug 2024 23:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="Cx8wiIiY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jCUllckU"
X-Original-To: io-uring@vger.kernel.org
Received: from fout4-smtp.messagingengine.com (fout4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0B85258;
	Fri,  2 Aug 2024 23:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722639802; cv=none; b=XOnxXc99nMlzkuraJEsx1/V8lkvyjFqF7cQi0IZ/jJMknzwtHbJQ6gbnmO5mk6rEUvCoEtf38swmesgnZTKyZtAB1Rj4KTGYQCtj+PAW2Tsjy/ujHFAmnswxF9HvggAWP8No0OPUWHi4LnhFrs6q6sWU8R9RNZ87Wrh0uhuvqe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722639802; c=relaxed/simple;
	bh=q1FFYpuT7vsH2ocHPrBX2aywJ8oBUFY0YfHE2bVjYBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N8OW5m4lNQKvKArgqec5tR0WyHCzEglmd24zp1vHvnKciWnpulVUWarpxEwizKYAU5mW7o9c3QROVdNvqPNrqAx4JlOa0+7h68Mid24AqWj+XLxJb8tLG7yw3Bbk010Gc+VpJUmqF8t14SQCFZRsZKda4oNYFO4E7rU7cWw598w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=Cx8wiIiY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jCUllckU; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from compute7.internal (compute7.nyi.internal [10.202.2.48])
	by mailfout.nyi.internal (Postfix) with ESMTP id A182A138CD0A;
	Fri,  2 Aug 2024 19:03:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Fri, 02 Aug 2024 19:03:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1722639798;
	 x=1722726198; bh=G1CFRnyHAXhy+dFKRK51ZyDuS5xaKXWg3D6icphUhIE=; b=
	Cx8wiIiY0v1tji9HZi5pa40ef5yek0qmhXxeLruTQ2whmNjnGnTdKDNCMKE2mS7O
	1n4Wed5KiQn9UNQHfqyVUK6GDjXcqmeGw1SI0cpiRSH9A7HH/PtJWICFZzARxa9i
	q8ILT1EyF+RQzGx/C2CFdRv6geYaJTZroFnNUdh2c3ArF5qvIWrOqraaN5k+aqAa
	nj7nyWtzAr5ytmoo9Dt8wNGPbDQZXRaNmpL76L4XeS1DUkysF9yBRau14OPFLnNw
	2TXnXjDCzmSS/1moyb/oB5I0B6qaIF/kGfRYkRg6oy9IcsoEiJNmSe4a9K9Xs440
	eRG7ML3XQpkQO1oAOfK33A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1722639798; x=
	1722726198; bh=G1CFRnyHAXhy+dFKRK51ZyDuS5xaKXWg3D6icphUhIE=; b=j
	CUllckUOtJ1KwXkS7DeWTvcfU3ur4lUnwosJ6U2R4LXxAhvtUIQnu9f9agMa6z9j
	a/h8tBeM/yqUFLZm+ErXHnppyz2h/5iRzW+HPv3Wtt4Kfznso383MEAwn2WmRbdY
	C9kPacYIEWO6t7tfmUzP9scKkclHQJYqCwKzDzF7Gxl/i5w1+EzytnIvo/Zg8d8z
	l0WUrdY9YFp+3cvFA9+1xFg092Umzh7aakAmLTZ7Xia/PqYONjGIRQsQTTgCXobF
	vi/zsWetinM4/5yAdteKGnzlaEmtYpQy7uDqHiR4IFBDNivTZoQ3OHDVfErYvn86
	v9rh4avSqGqZPZHec92VQ==
X-ME-Sender: <xms:tWWtZpJQX3T30aMGrFqud4NJGdcuWyLlujb8J176sII9mCIrK5Y8FQ>
    <xme:tWWtZlKWhln85cIPbY_aY44Xa2ovgv7yYVmZYFXejgnvz72-3g2UJ54oxGQLOdAzZ
    tFrBNwih2sw9HaM>
X-ME-Received: <xmr:tWWtZhsFVLCDiwTebUci4P0pQKrqUQU1oHOoFhR_9fw0Y406x_pWGeU2EYDIZsd-mlKulofRbvrb8HatnIxEe6VRSIk7f84Fezs6VE5Qo-35uHoQLhhX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrkedugddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepuegvrhhn
    ugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusggvrhhtsehfrghsthhmrghilh
    drfhhmqeenucggtffrrghtthgvrhhnpeevhffgvdeltddugfdtgfegleefvdehfeeiveej
    ieefveeiteeggffggfeulefgjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrihhlrdhf
    mhdpnhgspghrtghpthhtoheptd
X-ME-Proxy: <xmx:tmWtZqbaI_R_9MY-82mYHRrpplSJl5ug68dWRv_DASNjg7V9D_jrDQ>
    <xmx:tmWtZgYBAevZuEiiScW5CENTj8ye1xZ1CxcIqxnEgv4uYUlkgwSw9w>
    <xmx:tmWtZuBvx5whnhxk4jdGag-3Ef7AiQ3TOy_insao_sCsRIah9FzwUw>
    <xmx:tmWtZuZzi8S30iV7lzO7uXVDXhvyDZSG4diaJ5sRPn-dhjfcWvrwnw>
    <xmx:tmWtZsQ5NGlZvRevlkJYKDZ17GM79067z4XJzWdgaBRmpczh-ZT314ol>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Aug 2024 19:03:16 -0400 (EDT)
Message-ID: <4c1118d0-b871-44e8-93ca-6b0cf8643144@fastmail.fm>
Date: Sat, 3 Aug 2024 01:03:15 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Josef Bacik <josef@toxicpanda.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
 <CAJfpegsq06UZSPCDB=0Q3OPoH+c3is4A_d2oFven3Ebou8XPOw@mail.gmail.com>
 <0615e79d-9397-48eb-b89e-f0be1d814baf@ddn.com>
 <CAJfpeguMmTXJPzdnxe87hSBPO_Y8s33eCc_H5fEaznZYC-D8HA@mail.gmail.com>
 <3b74f850-c74c-49d0-be63-a806119cbfbd@ddn.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, fr, ru
In-Reply-To: <3b74f850-c74c-49d0-be63-a806119cbfbd@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/12/24 16:56, Bernd Schubert wrote:
> On 6/12/24 16:07, Miklos Szeredi wrote:
>> On Wed, 12 Jun 2024 at 15:33, Bernd Schubert <bschubert@ddn.com> wrote:
>>
>>> I didn't do that yet, as we are going to use the ring buffer for requests,
>>> i.e. the ring buffer immediately gets all the data from network, there is
>>> no copy. Even if the ring buffer would get data from local disk - there
>>> is no need to use a separate application buffer anymore. And with that
>>> there is just no extra copy
>>
>> Let's just tackle this shared request buffer, as it seems to be a
>> central part of your design.
>>
>> You say the shared buffer is used to immediately get the data from the
>> network (or various other sources), which is completely viable.
>>
>> And then the kernel will do the copy from the shared buffer.  Single copy, fine.
>>
>> But if the buffer wasn't shared?  What would be the difference?
>> Single copy also.
>>
>> Why is the shared buffer better?  I mean it may even be worse due to
>> cache aliasing issues on certain architectures.  copy_to_user() /
>> copy_from_user() are pretty darn efficient.
> 
> Right now we have:
> 
> - Application thread writes into the buffer, then calls io_uring_cmd_done
> 
> I can try to do without mmap and set a pointer to the user buffer in the 
> 80B section of the SQE. I'm not sure if the application is allowed to 
> write into that buffer, possibly/probably we will be forced to use 
> io_uring_cmd_complete_in_task() in all cases (without 19/19 we have that 
> anyway). My greatest fear here is that the extra task has performance 
> implications for sync requests.
> 
> 
>>
>> Why is it better to have that buffer managed by kernel?  Being locked
>> in memory (being unswappable) is probably a disadvantage as well.  And
>> if locking is required, it can be done on the user buffer.
> 
> Well, let me try to give the buffer in the 80B section.
> 
>>
>> And there are all the setup and teardown complexities...
> 
> If the buffer in the 80B section works setup becomes easier, mmap and 
> ioctls go away. Teardown, well, we still need the workaround as we need 
> to handle io_uring_cmd_done, but if you could live with that for the 
> instance, I would ask Jens or Pavel or Ming for help if we could solve 
> that in io-uring itself.
> Is the ring workaround in fuse_dev_release() acceptable for you? Or do 
> you have any another idea about it?
> 
>>


Short update, I have this working for some time now with a hack patch
that just adds in a user buffer (without removing mmap, it is just
unused). Initially I thought that is a lot slower, but after removing
all the kernel debug options perf loss is just around 5% and I think I
can get back the remaining by having iov_iter_get_pages2() of the user
buffer in the initialization (with additional code overhead).

I hope to have new patches by mid of next week. I also want to get rid
of the difference of buffer layout between uring and /dev/fuse as that
can be troublesome for other changes like alignment. That might require
an io-uring CQE128, though.


Thanks,
Bernd

