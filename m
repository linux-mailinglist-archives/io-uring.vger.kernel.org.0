Return-Path: <io-uring+bounces-6617-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F1B3A3FDBA
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 18:45:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 201A64250A8
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 17:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D034250C14;
	Fri, 21 Feb 2025 17:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="UHdE5zNu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="O2kM1yZf"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895D1250C0F;
	Fri, 21 Feb 2025 17:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740159904; cv=none; b=qwWezy66IMqmE1CnY+uF9lFtGzWEK3QOMEmdZrfnGNXBV4rkvQsxEuBVAmjq/m/w4eRz1o3+5W/kF6aiE1tNHvK4fA84af72zu+GKkxY44R2Spn7NkjhNKqB7ejYWy3ATHfVfNxGwDdEoOfqJUBowoS0vdeAdoK7McorMY4/Kt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740159904; c=relaxed/simple;
	bh=iEIwWJ7R8tQjVBR+pwsP3VpOqRwf0vM7AxlX+GOLxMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qG7xAhLv1UAu+anmyr7mztBqbgDBWSdSXMg2aZQ4lEfk124LznLGqUdi/xZe/e3+mLv1KNGvBsf5/Q7SnxUozk+5yq2vx5t2cO+xDsHOoREd8n5MVW3WOPkA4iA2d8PGxShtfiLe0DDuuEG+IA0KpwhtOAa9YpJmD0/7rn7wT/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=UHdE5zNu; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=O2kM1yZf; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 983FA114017A;
	Fri, 21 Feb 2025 12:45:01 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 21 Feb 2025 12:45:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1740159901;
	 x=1740246301; bh=lFUKScXh8wCWf6Bzhx7QewxcB0vVROQ0Co6DzbNMSWU=; b=
	UHdE5zNuBKKl8kUrMRDOZv1lIYw/EDrrwUl7xdfbgpuGByPpC4U450/KQ2wyjsQ0
	UXwLZSpRxoCeIyov3x9CVTitpaZGSCxJ/pp9qYYZJIEzpOjI+QWOmCs7dYJoMx3O
	sD5kGRxqwzssU+QvH30HsI0so+0TsZH1plX8ktCktq+QnXNYNLCezVQJJ/a6y7FF
	K/DHMYADRygoMcDtZiTjd1ZmANUxXR2Ayu8xEgeYOyfQjybyVIToVhimaCGVdoRG
	3Ok04S/fjd7xpPDeBf/Lxygxs5GH4Pq0xBc6Vicc6TzXCpqGSRqdOeND/Pw4NXD5
	3UsybooT5gpprCK8VXeseQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1740159901; x=
	1740246301; bh=lFUKScXh8wCWf6Bzhx7QewxcB0vVROQ0Co6DzbNMSWU=; b=O
	2kM1yZfKH4UY2XfQqQ7b7IZkuJbSWuvgCpZug2TZ1+H+8HosfypOcBXWRm9GhrCa
	MsnkaH2/C3BxVv5qEoCnmhoz9e+Y1/frAqFWRJmiVVqNRGOEa0FWK1onRJV3Tq7v
	pkkqvscTrFmsP3lwn6x1SaE/xn2SKzPiZTtA1rFeutrZE12Ap0t8xpFL42Ys69E1
	jD2xC90clGIdxdC9dZ31FUK9f8Cv1tT7zWcH4OTlalfSWEbnQ/cuMd9eYnA4Cqa7
	19dJjjgDD4KS1q78b4FnlATO0Png/HZhVmItiNlqaHgzbZsfQIPWtNAg3kT/xtod
	NNAp/7XDOVlXVYEaCJT8w==
X-ME-Sender: <xms:nbu4Zx50qOVLaG0BGZKJ5yMZ-LyHn-s8ZfqbkGeoPyHzq5LWGYuWwg>
    <xme:nbu4Z-6AqniTqGGShYRvhGLVgRsCWObiHIOXFwuQoT2GUcGefPqOFgSiJl_xmTtpD
    mtq5KZ_lwRexHwa>
X-ME-Received: <xmr:nbu4Z4cRN8diUnHgb-oxRH6RRF206Sf0_PDQibveJ4RYjWy_LG14evDeoU3UPDjFpGHsZ9gI5D3P89BhXxD-uU2AT_XsDvf3Q7SqXniNUDVPtFdC8-Z3>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdejtdeihecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:nbu4Z6IsicuW6VAdeMa73r7EckIeyjW5JR592bGLraJUFA-WDPa8JQ>
    <xmx:nbu4Z1JRHcVbZQaZvz9VvvjXnmAFydEm2YR-oHqlliNC-qhb9C6q8w>
    <xmx:nbu4ZzzoCdlEaFTs3BRBtHH8qPKRR87HRkE5Ah9m-v0m6M6DUOcuhw>
    <xmx:nbu4ZxJby-EEWFXRgIOTTElfLehs5sopai_QZC50Dlo4og4KLr--Cw>
    <xmx:nbu4Z98csym3ku2jYFCS40_ndytUTvLrjBgoHe4zZOFQqiFTlUGQL2nZ>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Feb 2025 12:45:00 -0500 (EST)
Message-ID: <2d9f56ae-7344-4f82-b5da-61522543ef4f@bsbernd.com>
Date: Fri, 21 Feb 2025 18:44:59 +0100
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
 <CAOQ4uxiVvc6i+5bV1PDMcvS8bALFdp86i==+ZQAAfxKY6AjGiQ@mail.gmail.com>
 <a8af0bfc-d739-49aa-ac3f-4f928741fb7a@bsbernd.com>
 <CAOQ4uxiSkLwPL3YLqmYHMqBStGFm7xxVLjD2+NwyyyzFpj3hFQ@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAOQ4uxiSkLwPL3YLqmYHMqBStGFm7xxVLjD2+NwyyyzFpj3hFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2/21/25 18:25, Amir Goldstein wrote:
> On Fri, Feb 21, 2025 at 6:13 PM Bernd Schubert <bernd@bsbernd.com> wrote:
>>
>>
>>
>> On 2/21/25 17:24, Amir Goldstein wrote:
>>> On Fri, Feb 21, 2025 at 4:36 PM Moinak Bhattacharyya
>>> <moinakb001@gmail.com> wrote:
>>>>
>>>> Sorry about that. Correctly-formatted patch follows. Should I send out a
>>>> V2 instead?
>>>>
>>>> Add support for opening and closing backing files in the fuse_uring_cmd
>>>> callback. Store backing_map (for open) and backing_id (for close) in the
>>>> uring_cmd data.
>>>> ---
>>>>   fs/fuse/dev_uring.c       | 50 +++++++++++++++++++++++++++++++++++++++
>>>>   include/uapi/linux/fuse.h |  6 +++++
>>>>   2 files changed, 56 insertions(+)
>>>>
>>>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>>>> index ebd2931b4f2a..df73d9d7e686 100644
>>>> --- a/fs/fuse/dev_uring.c
>>>> +++ b/fs/fuse/dev_uring.c
>>>> @@ -1033,6 +1033,40 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
>>>>       return ent;
>>>>   }
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
>>>> +
>>>
>>> I am not that familiar with io_uring, so I need to ask -
>>> fuse_backing_open() does
>>> fb->cred = prepare_creds();
>>> to record server credentials
>>> what are the credentials that will be recorded in the context of this
>>> io_uring command?
>>
>> This is run from the io_uring_enter() syscall - it should not make
>> a difference to an ioctl, AFAIK. Someone from @io-uring please
>> correct me if I'm wrong.
>>
>>>
>>>
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
>>>> +
>>>> +    io_uring_cmd_done(cmd, ret, 0, issue_flags);
>>>> +    return 0;
>>>> +}
>>>> +
>>>>   /*
>>>>    * Register header and payload buffer with the kernel and puts the
>>>>    * entry as "ready to get fuse requests" on the queue
>>>> @@ -1144,6 +1178,22 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd,
>>>> unsigned int issue_flags)
>>>>               return err;
>>>>           }
>>>>           break;
>>>> +    case FUSE_IO_URING_CMD_BACKING_OPEN:
>>>> +        err = fuse_uring_backing_open(cmd, issue_flags, fc);
>>>> +        if (err) {
>>>> +            pr_info_once("FUSE_IO_URING_CMD_BACKING_OPEN failed err=%d\n",
>>>> +                    err);
>>>> +            return err;
>>>> +        }
>>>> +        break;
>>>> +    case FUSE_IO_URING_CMD_BACKING_CLOSE:
>>>> +        err = fuse_uring_backing_close(cmd, issue_flags, fc);
>>>> +        if (err) {
>>>> +            pr_info_once("FUSE_IO_URING_CMD_BACKING_CLOSE failed err=%d\n",
>>>> +                    err);
>>>> +            return err;
>>>> +        }
>>>> +        break;
>>>>       default:
>>>>           return -EINVAL;
>>>>       }
>>>> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
>>>> index 5e0eb41d967e..634265da1328 100644
>>>> --- a/include/uapi/linux/fuse.h
>>>> +++ b/include/uapi/linux/fuse.h
>>>> @@ -1264,6 +1264,12 @@ enum fuse_uring_cmd {
>>>>
>>>>       /* commit fuse request result and fetch next request */
>>>>       FUSE_IO_URING_CMD_COMMIT_AND_FETCH = 2,
>>>> +
>>>> +    /* add new backing file for passthrough */
>>>> +    FUSE_IO_URING_CMD_BACKING_OPEN = 3,
>>>> +
>>>> +    /* remove passthrough file by backing_id */
>>>> +    FUSE_IO_URING_CMD_BACKING_CLOSE = 4,
>>>>   };
>>>>
>>>
>>> An anecdote:
>>> Why are we using FUSE_DEV_IOC_BACKING_OPEN
>>> and not passing the backing fd directly in OPEN response?
>>>
>>> The reason for that was security related - there was a concern that
>>> an adversary would be able to trick some process into writing some fd
>>> to /dev/fuse, whereas tricking some proces into doing an ioctl is not
>>> so realistic.
>>>
>>> AFAICT this concern does not exist when OPEN response is via
>>> io_uring(?), so the backing_id indirection is not strictly needed,
>>> but for the sake of uniformity with standard fuse protocol,
>>> I guess we should maintain those commands in io_uring as well.
>>
>> Yeah, the way it is done is not ideal
>>
>> fi->backing_id = do_passthrough_open(); /* blocking */
>> fuse_reply_create()
>>     fill_open()
>>       arg->backing_id = f->backing_id; /* f is fi */
>>
>>
>> I.e. there are still two operations that depend on each other.
>> Maybe we could find a way to link the SQEs.
> 
> If we can utilize io_uring infrastructure to link the two
> commands it would be best IMO, to keep protocol uniform.
> 
>> Or maybe easier, if the security concern is gone with IO-URING,
>> just set FOPEN_PASSTHROUGH for requests over io-uring and then
>> let the client/kernel side do the passthrough open internally?
> 
> It is possible, for example set FOPEN_PASSTHROUGH_FD to
> interpret backing_id as backing_fd, but note that in the current
> implementation of passthrough_hp, not every open does
> fuse_passthrough_open().
> The non-first open of an inode uses a backing_id stashed in inode,
> from the first open so we'd need different server logic depending on
> the commands channel, which is not nice.

Probably, but I especially added fuse_req_is_uring() to the API
to be able to do that. For example to avoid another memcpy when passing
buffers to another thread.


Thanks,
Bernd

