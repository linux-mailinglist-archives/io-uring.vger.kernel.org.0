Return-Path: <io-uring+bounces-6612-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 52C4BA3FD3C
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 18:18:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16D1E7A652C
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 17:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF6924CED3;
	Fri, 21 Feb 2025 17:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="XBkGXS4n";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="4X3evge6"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1BC24CEC7;
	Fri, 21 Feb 2025 17:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740158021; cv=none; b=b4JjrXWT7l5ZvoXfjyhOjYmiluv7qcQ+GEW1VfK1Chv3ot1NDegCmjx364SkCoKBEwNNC2lIR1tL/alWvxwaFTceeqYK37Ns6v1hsXTSGCbs/hwK8OR4BihV0f37mDp+pPmF3fECM9+ePHhp7EqTwGyRKze/5T+h6RHB2ZZEYuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740158021; c=relaxed/simple;
	bh=1F5mlHXQZZrYDrp6UqAGIJwR2JDZK61FTp0FQeeIozc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V8yILJvP8tfAhzPy/3XokurMKafiANUPDf/qDNliyTop0cVjOxvZz9qOSsUsKCMQ/TzxDChpDrSwE+B2WsHgr7hMe/hRn44+7OGLLe4xNQu65vHI6ASq61L64ghq9nf/axSqNWpe7NrPGZFpt4w8tASLKZAzgip6h1bJ1NEIJuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=XBkGXS4n; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=4X3evge6; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id AB73C1380240;
	Fri, 21 Feb 2025 12:13:37 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 21 Feb 2025 12:13:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1740158017;
	 x=1740244417; bh=Hj8yvRUdCkKlgpdB4aDV4tAoK6YrJiQ71szFV7Fsgjo=; b=
	XBkGXS4nZOlHKuwChjETUIl0kyADZweV4HP4jHduzQvJUqCy2r0zss01QoYhBQ0F
	L1cPkywuFJzq6ACdhbliRAutm2Ve4fD0SfMDAGW3ClISrTabAojLGt/zifbL6Cf2
	YaQjzXZESSQq4svmay+jzxUGTStBdE6cqnpA3xKPkgz5CSylQMGsQWMVIuNiW963
	Mdi3DCYsTWlk2oJPBequJFMexYuSvBcKBoevhMra1PqH6uGX0gJlj+fVzzu1euo1
	DxvuuFMHrJJQphFBd0Zg5VbFhycD7TMOFt/B54xTHYXZSdf1y0Xj5or7cQ9Vz7y6
	LWUb/ydnvEB1x/jj0s1Qhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1740158017; x=
	1740244417; bh=Hj8yvRUdCkKlgpdB4aDV4tAoK6YrJiQ71szFV7Fsgjo=; b=4
	X3evge6FVDFndolWM2H7XZJNyFBeuzjha3eoEx5zG6DkQr3aQwwgtpAsbNK656kN
	8WRH1UqQkJYxrwMj0RRDgnyVQ5vw4K9Af+HO/YbbcAM/yxAcokzLivCcxrm0jrb4
	T0QtHBcNuOsmuOqaSCprw9bi0DKooL+XYLhTA78Mo3tJ8pI+stkDwofVJObfebmg
	mLoUI6+FReQy56T4Ug9R65blB3migyqsiPsfl5KiwWxv1qKb1H2cGq5MUDhXa6SK
	nBGvkDLdIzsau5jTc7iXv5f3LF++duUV5tx/xdhUpC1W81JC+T/SsoBd9C4BW3wN
	vTvy4Hrw3mOfV7z6aBF5A==
X-ME-Sender: <xms:QbS4Z30_l_L-7g8PdzgUb-8CONaSe4imbt8tc1o2CvdS7R1HGlLVMw>
    <xme:QbS4Z2FyomIQVVPRJDOawZxJ2XLoU00oyz7mGXPrNSCnR4z7VD4O-GNewxi_n_xMp
    8zJAmwKyOEG2MSb>
X-ME-Received: <xmr:QbS4Z34xunhABdy0Mtsie2dPhDiGBpV5Zs9A9DYCfmIKnM7lfCxx_RKFHGrLN-gS4FajsXZ_voDtk7HKjXP4f3fxJiSLnN6gNan-MWgfIELs1RUKO7Qp>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdejtdehlecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:QbS4Z82yydjdBaKgwRUjVYbJwUc2aifHCriXysdNL4t_m5J8lW_zyA>
    <xmx:QbS4Z6ETxVsppf77fYrAkViS2dB6SkO7JKDBbzmI9kyN9L68wnJnSQ>
    <xmx:QbS4Z9-d3lmuNFY8RELDCyPtKGN2V0cJMNz4fx5jCvZmvkU45LIGpg>
    <xmx:QbS4Z3kj0aNTq-JFdzT0h1HZMxQned1qQxQNf_DUt6XuOGPblWEWhg>
    <xmx:QbS4Z_599xajn7iMqBS-f1KzxeLckzKwqe3eo7g7WTlnsrb-sCpL9vyF>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Feb 2025 12:13:36 -0500 (EST)
Message-ID: <a8af0bfc-d739-49aa-ac3f-4f928741fb7a@bsbernd.com>
Date: Fri, 21 Feb 2025 18:13:35 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Amir Goldstein <amir73il@gmail.com>,
 Moinak Bhattacharyya <moinakb001@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com>
 <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <CAOQ4uxiVvc6i+5bV1PDMcvS8bALFdp86i==+ZQAAfxKY6AjGiQ@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAOQ4uxiVvc6i+5bV1PDMcvS8bALFdp86i==+ZQAAfxKY6AjGiQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2/21/25 17:24, Amir Goldstein wrote:
> On Fri, Feb 21, 2025 at 4:36 PM Moinak Bhattacharyya
> <moinakb001@gmail.com> wrote:
>>
>> Sorry about that. Correctly-formatted patch follows. Should I send out a
>> V2 instead?
>>
>> Add support for opening and closing backing files in the fuse_uring_cmd
>> callback. Store backing_map (for open) and backing_id (for close) in the
>> uring_cmd data.
>> ---
>>   fs/fuse/dev_uring.c       | 50 +++++++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/fuse.h |  6 +++++
>>   2 files changed, 56 insertions(+)
>>
>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>> index ebd2931b4f2a..df73d9d7e686 100644
>> --- a/fs/fuse/dev_uring.c
>> +++ b/fs/fuse/dev_uring.c
>> @@ -1033,6 +1033,40 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
>>       return ent;
>>   }
>>
>> +/*
>> + * Register new backing file for passthrough, getting backing map from
>> URING_CMD data
>> + */
>> +static int fuse_uring_backing_open(struct io_uring_cmd *cmd,
>> +    unsigned int issue_flags, struct fuse_conn *fc)
>> +{
>> +    const struct fuse_backing_map *map = io_uring_sqe_cmd(cmd->sqe);
>> +    int ret = fuse_backing_open(fc, map);
>> +
> 
> I am not that familiar with io_uring, so I need to ask -
> fuse_backing_open() does
> fb->cred = prepare_creds();
> to record server credentials
> what are the credentials that will be recorded in the context of this
> io_uring command?

This is run from the io_uring_enter() syscall - it should not make
a difference to an ioctl, AFAIK. Someone from @io-uring please
correct me if I'm wrong.

> 
> 
>> +    if (ret < 0) {
>> +        return ret;
>> +    }
>> +
>> +    io_uring_cmd_done(cmd, ret, 0, issue_flags);
>> +    return 0;
>> +}
>> +
>> +/*
>> + * Remove file from passthrough tracking, getting backing_id from
>> URING_CMD data
>> + */
>> +static int fuse_uring_backing_close(struct io_uring_cmd *cmd,
>> +    unsigned int issue_flags, struct fuse_conn *fc)
>> +{
>> +    const int *backing_id = io_uring_sqe_cmd(cmd->sqe);
>> +    int ret = fuse_backing_close(fc, *backing_id);
>> +
>> +    if (ret < 0) {
>> +        return ret;
>> +    }
>> +
>> +    io_uring_cmd_done(cmd, ret, 0, issue_flags);
>> +    return 0;
>> +}
>> +
>>   /*
>>    * Register header and payload buffer with the kernel and puts the
>>    * entry as "ready to get fuse requests" on the queue
>> @@ -1144,6 +1178,22 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd,
>> unsigned int issue_flags)
>>               return err;
>>           }
>>           break;
>> +    case FUSE_IO_URING_CMD_BACKING_OPEN:
>> +        err = fuse_uring_backing_open(cmd, issue_flags, fc);
>> +        if (err) {
>> +            pr_info_once("FUSE_IO_URING_CMD_BACKING_OPEN failed err=%d\n",
>> +                    err);
>> +            return err;
>> +        }
>> +        break;
>> +    case FUSE_IO_URING_CMD_BACKING_CLOSE:
>> +        err = fuse_uring_backing_close(cmd, issue_flags, fc);
>> +        if (err) {
>> +            pr_info_once("FUSE_IO_URING_CMD_BACKING_CLOSE failed err=%d\n",
>> +                    err);
>> +            return err;
>> +        }
>> +        break;
>>       default:
>>           return -EINVAL;
>>       }
>> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
>> index 5e0eb41d967e..634265da1328 100644
>> --- a/include/uapi/linux/fuse.h
>> +++ b/include/uapi/linux/fuse.h
>> @@ -1264,6 +1264,12 @@ enum fuse_uring_cmd {
>>
>>       /* commit fuse request result and fetch next request */
>>       FUSE_IO_URING_CMD_COMMIT_AND_FETCH = 2,
>> +
>> +    /* add new backing file for passthrough */
>> +    FUSE_IO_URING_CMD_BACKING_OPEN = 3,
>> +
>> +    /* remove passthrough file by backing_id */
>> +    FUSE_IO_URING_CMD_BACKING_CLOSE = 4,
>>   };
>>
> 
> An anecdote:
> Why are we using FUSE_DEV_IOC_BACKING_OPEN
> and not passing the backing fd directly in OPEN response?
> 
> The reason for that was security related - there was a concern that
> an adversary would be able to trick some process into writing some fd
> to /dev/fuse, whereas tricking some proces into doing an ioctl is not
> so realistic.
> 
> AFAICT this concern does not exist when OPEN response is via
> io_uring(?), so the backing_id indirection is not strictly needed,
> but for the sake of uniformity with standard fuse protocol,
> I guess we should maintain those commands in io_uring as well.

Yeah, the way it is done is not ideal

fi->backing_id = do_passthrough_open(); /* blocking */
fuse_reply_create()
    fill_open()
      arg->backing_id = f->backing_id; /* f is fi */


I.e. there are still two operations that depend on each other.
Maybe we could find a way to link the SQEs.
Or maybe easier, if the security concern is gone with IO-URING,
just set FOPEN_PASSTHROUGH for requests over io-uring and then
let the client/kernel side do the passthrough open internally?


Thanks,
Bernd







