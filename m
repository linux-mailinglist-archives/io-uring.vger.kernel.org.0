Return-Path: <io-uring+bounces-6605-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E99EA3FB1B
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 17:26:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07D847A23E3
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 16:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB2E91FF5EB;
	Fri, 21 Feb 2025 16:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="FnuSgRCg";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="N/YyxUFv"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8E61DC07D;
	Fri, 21 Feb 2025 16:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740154659; cv=none; b=tMyIPrayeaQg5DZSvnVwX15ySKDsxEZtd9K/TUaUcio8c7Z4uSzUH86xK042qwmdV1SBBL+qDDC6lQHcy7xU2qTQX3f8WYdJDGYpIPz8MOiNOKdG7764TGfy/8r8uh5J01gOqhL1JQnZv0DWitot5zd4sMJYGIhiCmbycbDVMKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740154659; c=relaxed/simple;
	bh=UmsexPj0uS5upDkIMkslL7wlhLAmn8I+VAHDRTFfrPA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=rGOR7WxdMNlLee7b6wngPrrmDuI2RGTuKm2fZAil6ekPIQIzfBdT5AI5spOU/3KRI3GxWCOHgbQRdMBON+tBacf36RZsHNIjKo0w79Gsg43DLig+gLe3dKIGW4NtzjzW+Ce8fzwmAkgYwK9tfep8PCtoZ59AvoC4k+AL9IY+onY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=FnuSgRCg; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=N/YyxUFv; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 7AA3B13809B6;
	Fri, 21 Feb 2025 11:17:36 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 21 Feb 2025 11:17:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1740154656;
	 x=1740241056; bh=As4LYdoKt6G2SPn7LmN2IRqDn3P8jSGUvgLzO6fsoqA=; b=
	FnuSgRCg3Nnh1Rjvoy5o8LakHnarhkeAborw18YS8Z5rZn90lGYxMg7Gx4y4QeUm
	MCezLfOjYZQ4m+wNy1+ZnkhlOnHiO35W25EHCwgHKNBDafJqH8DvgmT205w07/fb
	WlBQlicYUxX4JU1Zmk39y9S0qf3bfc2X1/cWmw+WYduXJDWiNxBVKBKak65yqWZL
	B+H3/OiRpFeZis3W9cz8/KIQD78Ffyk8IieM4iO2HNQkqMH9HZDRsT9iXeEgxQ1D
	IGmHM4mz4/TFAoovraPa60cdaGs4ITCjz1RXab9/OCaSXxhM10nQ/dWwa32AWOL4
	qrxfatA0HZDtlxXKoAwG2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1740154656; x=1740241056; bh=A
	s4LYdoKt6G2SPn7LmN2IRqDn3P8jSGUvgLzO6fsoqA=; b=N/YyxUFvtH0G8b7C3
	dMAJ4RShZbqb7DW5ORpUymhfkLi17C0UUPgFZgRvDx8G//t+l5jGfDgpEwrQqnK4
	6cvf845HAU2TeIMd3zhVdwMLGElPBgoCr82P8r/EcnCMzjaWsZMAf9NVrEeHI0TE
	yZbgBAdeN8wZLNt0kG/ILZoHlTadcvA5vAlI4B8B//l31I5a757kuzOB9TxMuP6z
	OqM/RT0RzyH/IXwHiKAa8wSBC9RoV7Twd/PXd87uhx+1sq8Io6M0W/g3NfF3iy61
	acDoiAS0aVtmX6SUkvHYkp76KuTRjyipFjUdgFjs+HzlLKH4p+t0hvITX1TwdoWO
	CuJ8Q==
X-ME-Sender: <xms:IKe4Z42i3ts8lTp1KbBjOuBXh8CVvM7SeiKf_O2FXGai13k1WiCBtQ>
    <xme:IKe4ZzEAyAspYxG33v46w-zX5eOAuv0nRmduZot1391Pjy-napJT2uCf2ZEG912op
    EUDpx1vYVMGo7aT>
X-ME-Received: <xmr:IKe4Zw5z4FbU8hEqla1HJYlKtGP2UtvSEU1b88XyPBE1nxz_2p0ae1nKpLAVM_RwNjf1M15gI3iS2-rh4AtNR7TFki34jo4n4-BsgxZC94JyU9XEvAhV>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdejtdegjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuhffvfhgjtgfgsehtkeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnh
    gurdgtohhmqeenucggtffrrghtthgvrhhnpefgtdegtdegfedtuddvffffgeeliefgkeef
    teejgeehvdevleefgeeuvdduhfeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgt
    phhtthhopeeipdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmohhinhgrkhgstd
    dtudesghhmrghilhdrtghomhdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdr
    hhhupdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:IKe4Zx39uh5JLcJ9oIIoYItSTB0-4twDeCtFJFK4YToBzgyFxXBN1g>
    <xmx:IKe4Z7GXBc60r55Kws1UNO566-1u4vaX5aG9gk_2TVLomgaV7BXSTg>
    <xmx:IKe4Z684vZSfJkggHPC7trhwxpJTvI8C00mUBaCPvCfW4Nr42XWzTw>
    <xmx:IKe4Zwnub8u1v5xQQo7HiaBF-OXN9jKyxGMMWzn__tKHrKYhcsi6bQ>
    <xmx:IKe4Zw7FHcSpuFzI2_ngBPqQhzXJhBBcAnB1ed_SJoCIivLNeHSZQ3b6>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Feb 2025 11:17:35 -0500 (EST)
Message-ID: <216baa7e-2a97-4f12-b30a-4e21b4696ddd@bsbernd.com>
Date: Fri, 21 Feb 2025 17:17:34 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
From: Bernd Schubert <bernd@bsbernd.com>
To: Moinak Bhattacharyya <moinakb001@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 Amir Goldstein <amir73il@gmail.com>
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com>
 <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <9a930d23-25e5-4d36-9233-bf34eb377f9b@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <9a930d23-25e5-4d36-9233-bf34eb377f9b@bsbernd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2/21/25 17:14, Bernd Schubert wrote:
> 
> 
> On 2/21/25 16:36, Moinak Bhattacharyya wrote:
>> Sorry about that. Correctly-formatted patch follows. Should I send out a
>> V2 instead?
>>
>> Add support for opening and closing backing files in the fuse_uring_cmd
>> callback. Store backing_map (for open) and backing_id (for close) in the
>> uring_cmd data.
>> ---
>>  fs/fuse/dev_uring.c       | 50 +++++++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/fuse.h |  6 +++++
>>  2 files changed, 56 insertions(+)
>>
>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>> index ebd2931b4f2a..df73d9d7e686 100644
>> --- a/fs/fuse/dev_uring.c
>> +++ b/fs/fuse/dev_uring.c
>> @@ -1033,6 +1033,40 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
>>      return ent;
>>  }
>>
>> +/*
>> + * Register new backing file for passthrough, getting backing map from
>> URING_CMD data
>> + */
>> +static int fuse_uring_backing_open(struct io_uring_cmd *cmd,
>> +    unsigned int issue_flags, struct fuse_conn *fc)
>> +{
>> +    const struct fuse_backing_map *map = io_uring_sqe_cmd(cmd->sqe);
>> +    int ret = fuse_backing_open(fc, map);
> 
> Do you have the libfuse part somewhere? I need to hurry up to split and
> clean up my uring branch. Not promised, but maybe this weekend. 
> What we need to be careful here about is that in my current 'uring'
> libfuse always expects to get a CQE - here you introduce a 2nd user
> for CQEs - it needs credit management.
> 
> 
>> +
>> +    if (ret < 0) {
>> +        return ret;
>> +    }
>> +
>> +    io_uring_cmd_done(cmd, ret, 0, issue_flags);
>> +    return 0;
>> +}
>> +
>> +/*
>> + * Remove file from passthrough tracking, getting backing_id from
>> URING_CMD data
>> + */
>> +static int fuse_uring_backing_close(struct io_uring_cmd *cmd,
>> +    unsigned int issue_flags, struct fuse_conn *fc)
>> +{
>> +    const int *backing_id = io_uring_sqe_cmd(cmd->sqe);
>> +    int ret = fuse_backing_close(fc, *backing_id);
>> +
>> +    if (ret < 0) {
>> +        return ret;
>> +    }
> 
> 
> Both functions don't have the check for 
> 
> 	if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> 		return -EOPNOTSUPP;
> 
> but their ioctl counter parts have that.
> 

In order to avoid code dup, maybe that check could be moved
into fuse_backing_open() / fuse_backing_close() as preparation
patch? Amir?

Thanks,
Bernd

