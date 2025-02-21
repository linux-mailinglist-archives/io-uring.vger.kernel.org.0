Return-Path: <io-uring+bounces-6613-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF05DA3FD80
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 18:31:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7E077028FA
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 17:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2383F2500C9;
	Fri, 21 Feb 2025 17:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="CyRGG1FM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="deSMK300"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0251C5D76;
	Fri, 21 Feb 2025 17:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740158700; cv=none; b=XiEW2IIgXHEONe4XildoJyLL2aESdINQ26nWcJ4E2QhGYxyljYP6D1t9FboaJFsTGb7U1z6rvfaAHjTG2jX/TGJwqMAtd17U6j35a3l3zzG6RwXyToNfFxQxzxVo0R02ivaqingX5z9P6PkOPNMXFm1hC2ySmdt9HPTjF3rb7xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740158700; c=relaxed/simple;
	bh=rfubqgBuPW8KQbFK87+EDiG0WO+8APWfsNEw6wqzRKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GvtW1U+fqqFNC0d7/uzNG9m0XH1qIcLeWejgxjY7HnHZEYsMC40kM4KviR0e6BsP52s+GV32J6x0UqLE2hmerlpcutg/LgeE8nZChpWTRhUKHfqdannqUJJhJ6WBgkbY9D0fMvlkijZ6U9Ew+44ZU0VR1k+pcbibflQBt3vGId4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=CyRGG1FM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=deSMK300; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id ECF9111400D2;
	Fri, 21 Feb 2025 12:24:56 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Fri, 21 Feb 2025 12:24:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1740158696;
	 x=1740245096; bh=4o+rkkplJeo1rAJGhR37KNClaWXDBzpxHAPyuwIpKbI=; b=
	CyRGG1FM7p0QG2WUKqeLiPmPEhjq9CehRdJqlUvARcEI/htgryirwDLM1101U0zS
	NxzT/uB7r4lIVAYp4jEOTT1vDdm7McclV4sdkk2YTCuLgsn1CAp83e46iYLznOI9
	EKCfEpJyCTa846nB3iBcSetNIQEyasGhPCxrHnJ1pyXmC9Ru2gkCwiKS8uuSSiS1
	r+DjfK4VNx0XceD3xfbYqrVRLE0cFup4YjLhS0jykRjcZD+dHfRGne3HqxCnfaRR
	b9wzyIWqf+4xtAqlKC6cWIOMM3YdIDrUa4ysid8uLtfK2S090FX6SyaF2Io3VMSF
	SMyFHmeDWZCzyaF0ZQ6YeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1740158696; x=
	1740245096; bh=4o+rkkplJeo1rAJGhR37KNClaWXDBzpxHAPyuwIpKbI=; b=d
	eSMK300RoIhqo9WDh4S7TN2sfXyI4GibP3ENkQJ7wLWZkclbMmXlYCroY/LgXIZV
	sbNIytjtyRdWxEncBUC2CjJepZYbTFNAKd6pjddfHWTdKHULJIDYEPRV1oFLI65F
	oqF95hI+ifAFWJBGpEJ1nwJBiQnbHtlRGLuK8z3xCs2tJomJWeexIhzrKXrrSEv0
	COBOigqTQ3+gykALwhjJ2pm3NZIzyTtHkrhkhpsg/oqWKmGw4Ga3g9t6+gkxbU5q
	B+aZLGgB0GasybSp/wMtnj3w5dgdIDq4BD8x2RAu8pgnRxCGhTIhbUkcI78xm5zF
	a9ROPUD1I4gw/NPE4I1xw==
X-ME-Sender: <xms:6La4Z1kEjU_mg0GpA8ouqwzYtw8AMePVAARc_s_6FJz7ZY3R3eDOnQ>
    <xme:6La4Zw3s9Ah6ft0LdhPPFesS4dyktEnc9BmVhpu1bUbTZ1dV_rypYmRj3ATBP8rM3
    3muXuHVnKiqrJIW>
X-ME-Received: <xmr:6La4Z7qHuLVnPniH6QIh8_o2bMngeHbSC3CA51CMckQen4yd1x9PWkjwjzeZNYt1wkTdmmQlefQqCofZMoIT-lKQuEKdTPLEeRChKft-OWkHRcJDQSCm>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdejtdeiudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthekredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugessghssggvrh
    hnugdrtghomheqnecuggftrfgrthhtvghrnhepfeeggeefffekudduleefheelleehgfff
    hedujedvgfetvedvtdefieehfeelgfdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepsggvrhhnugessghssggvrhhnugdrtghomhdpnhgspghr
    tghpthhtohepiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghmihhrjeefih
    hlsehgmhgrihhlrdgtohhmpdhrtghpthhtohepmhhoihhnrghksgdttddusehgmhgrihhl
    rdgtohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtth
    hopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:6La4Z1lS3tmjBX1lSox8EF70A-TSFUaerKx6gebAVlQy9o5T1nON0A>
    <xmx:6La4Zz3K9NXFiiL2DcwXO0hYnyeUddHsG0fFSM_bbuyHd2ck1KQ5Sg>
    <xmx:6La4Z0uGD96VtXxIhgP1qXwyf8oUPmsQnwDhINlr7sLbB3sTFASDeg>
    <xmx:6La4Z3UhBclFbZiEk9onkw2JiDOWAnm5yvyMMjdYuZEebmRM9R16Rg>
    <xmx:6La4Z9oxmFBEq7lhMpoR8-WN1KD9YSLyIa3YbYvSYFyGsHbl-TLQqRLY>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Feb 2025 12:24:55 -0500 (EST)
Message-ID: <154fff04-a00a-4039-990f-af94b3562776@bsbernd.com>
Date: Fri, 21 Feb 2025 18:24:55 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Amir Goldstein <amir73il@gmail.com>
Cc: Moinak Bhattacharyya <moinakb001@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com>
 <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <9a930d23-25e5-4d36-9233-bf34eb377f9b@bsbernd.com>
 <216baa7e-2a97-4f12-b30a-4e21b4696ddd@bsbernd.com>
 <CAOQ4uxgNyKL9-PqDPjZsXum-1+YNwOcj=jhGCYmhrhr2JcCjNw@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAOQ4uxgNyKL9-PqDPjZsXum-1+YNwOcj=jhGCYmhrhr2JcCjNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2/21/25 17:35, Amir Goldstein wrote:
> On Fri, Feb 21, 2025 at 5:17 PM Bernd Schubert <bernd@bsbernd.com> wrote:
>>
>>
>>
>> On 2/21/25 17:14, Bernd Schubert wrote:
>>>
>>>
>>> On 2/21/25 16:36, Moinak Bhattacharyya wrote:
>>>> Sorry about that. Correctly-formatted patch follows. Should I send out a
>>>> V2 instead?
>>>>
>>>> Add support for opening and closing backing files in the fuse_uring_cmd
>>>> callback. Store backing_map (for open) and backing_id (for close) in the
>>>> uring_cmd data.
>>>> ---
>>>>  fs/fuse/dev_uring.c       | 50 +++++++++++++++++++++++++++++++++++++++
>>>>  include/uapi/linux/fuse.h |  6 +++++
>>>>  2 files changed, 56 insertions(+)
>>>>
>>>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>>>> index ebd2931b4f2a..df73d9d7e686 100644
>>>> --- a/fs/fuse/dev_uring.c
>>>> +++ b/fs/fuse/dev_uring.c
>>>> @@ -1033,6 +1033,40 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
>>>>      return ent;
>>>>  }
>>>>
>>>> +/*
>>>> + * Register new backing file for passthrough, getting backing map from
>>>> URING_CMD data
>>>> + */
>>>> +static int fuse_uring_backing_open(struct io_uring_cmd *cmd,
>>>> +    unsigned int issue_flags, struct fuse_conn *fc)
>>>> +{
>>>> +    const struct fuse_backing_map *map = io_uring_sqe_cmd(cmd->sqe);
>>>> +    int ret = fuse_backing_open(fc, map);
>>>
>>> Do you have the libfuse part somewhere? I need to hurry up to split and
>>> clean up my uring branch. Not promised, but maybe this weekend.
>>> What we need to be careful here about is that in my current 'uring'
>>> libfuse always expects to get a CQE - here you introduce a 2nd user
>>> for CQEs - it needs credit management.
>>>
>>>
>>>> +
>>>> +    if (ret < 0) {
>>>> +        return ret;
>>>> +    }
>>>> +
>>>> +    io_uring_cmd_done(cmd, ret, 0, issue_flags);
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Remove file from passthrough tracking, getting backing_id from
>>>> URING_CMD data
>>>> + */
>>>> +static int fuse_uring_backing_close(struct io_uring_cmd *cmd,
>>>> +    unsigned int issue_flags, struct fuse_conn *fc)
>>>> +{
>>>> +    const int *backing_id = io_uring_sqe_cmd(cmd->sqe);
>>>> +    int ret = fuse_backing_close(fc, *backing_id);
>>>> +
>>>> +    if (ret < 0) {
>>>> +        return ret;
>>>> +    }
>>>
>>>
>>> Both functions don't have the check for
>>>
>>>       if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
>>>               return -EOPNOTSUPP;
>>>
>>> but their ioctl counter parts have that.
>>>
>>
>> In order to avoid code dup, maybe that check could be moved
>> into fuse_backing_open() / fuse_backing_close() as preparation
>> patch? Amir?
> 
> Without CONFIG_FUSE_PASSTHROUGH, fuse/passthrough.c
> is compiled out, so the check cannot be moved into fuse_backing_*
> we'd need inline helpers that return -EOPNOTSUPP when
> CONFIG_FUSE_PASSTHROUGH is not defined.
> I don't mind, but I am not sure this is justified (yet).
> 

Ah right, then let's duplicate the check.

