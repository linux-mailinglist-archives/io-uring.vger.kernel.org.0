Return-Path: <io-uring+bounces-5038-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E27909D89A5
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 16:49:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF09FB2F79F
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 14:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E42311B0F06;
	Mon, 25 Nov 2024 14:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="U/wK7U2m";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MEpTB44T"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ABF1B2182;
	Mon, 25 Nov 2024 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732545968; cv=none; b=n6K9eoFwfBjxnJ3cILsD0EbGJ5MyL0vs/HaMLYDoTpz17hJasad718yOWVu8r31YpUk5n6TBoG1va+v2uz7cquCZZ3pNTPD7AXOmVZRNvVc3OTiYCdGbujXswamfE/XqOSHpZM48bdDLgpLSa9dM0fulFnyquEXkXddytLED52E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732545968; c=relaxed/simple;
	bh=j8WTzaLvOw9whoSAZSxh39tAF7nm/46SdyfK+BgRXFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MmpBHkl1CVxH1oNROdRCqheredNVlLKZWIF+OWyDcqzUyX8ecEriP+kIRAwmnA3PFdnK50/ce/g+xwBDV0w9d60dYRm+Aa2GBiDbREAjD2L9iLna3VG0fWeZPKJgglc6mo+MqhlRUpSD7DDPRwpikhNomDTV8c5EnhhqqMXwrRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=U/wK7U2m; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MEpTB44T; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id ECF541380444;
	Mon, 25 Nov 2024 09:46:02 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 25 Nov 2024 09:46:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1732545962;
	 x=1732632362; bh=ZzO4Ayzt9QRMmjLtmAvo63cJoNPvzQZtsba8yNiNm1s=; b=
	U/wK7U2mVbh/6sigFrWl9Y5x+LjoiiZ8WPeMGJuTgTbUyOATuylqFNdiuQYost3l
	eoXdriAdzSEgc5S1B2ncZDBLadMFcH6/GNMPqcLBlolDZ7AJb/hcclChfnn1jkSH
	0VxeOyxhssMW3gmdK5wQRhh7YxYekPIKPfKO3pZPIVF5qPvVC70pnR8ifeHYWXmu
	y5exwykUHN4/f2vXEvxDJST3czpswWOR+X1FBLr5vq8fUARxc9D39rML2Nmdhulx
	Qnl5tdZiC0YRVK7wgP5LaUCHKh079VcwPd70ZiZ+n7+NGBPaCt2JN6HP+4wvX/fw
	MJNEzGegNYeh5306hdJOQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1732545962; x=
	1732632362; bh=ZzO4Ayzt9QRMmjLtmAvo63cJoNPvzQZtsba8yNiNm1s=; b=M
	EpTB44TsLU82wnnqfRomgNk3SdwFTPKRmBEzhHHYpdwvuuMfLUhrfTgGfF4U8xqM
	vCZCcQUg9ZLLmQWR1X+PptORtTR8N5Fwn7MeX0b+r6engg8iLL0LgaNiGk7vZs+E
	MQ/Nml2YGCp/0VHM2mtS5JzFrRQXhx/JLm7L3m7FqCxmuD/hObNG4I4cfHQRL8VH
	j3+xuhNAuX+cT2+no9x1UOmZekCaw4dvHKxXGZBgVOLltPuPLDrGNjQm2eVqCz4G
	xz817Ig48n40A6bVo6ArQubN6kPXLM0OoP2U3ROr8dMlYI1m2gZXE8KzWPFljZix
	83b/IoF5lzKmrHNqeD4hg==
X-ME-Sender: <xms:qY1EZ9qRqdV2iogJkdI8EwHPvfw2jDydfSnKETDc-Nq-KB04crB9NQ>
    <xme:qY1EZ_oRKxsPFBJIoeUB8Uuz9Hsd757gTnGK2dKiqEngLUMnn9-z1VO8KE_gtHQgV
    0NWDKWYhsSTRzg3>
X-ME-Received: <xmr:qY1EZ6ObVZnPOyzw7F9srNPocSM8FPu2EtKtzuxZCFjGmRMLnRzSizsWM6b4AVOd5DKJqzEAE-uuVrpnEqMF7-TNcuB-V-4zHlyC1o89-wNavB02DheG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrgeehgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeen
    ucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusggvrh
    htsehfrghsthhmrghilhdrfhhmqeenucggtffrrghtthgvrhhnpeevhffgvdeltddugfdt
    gfegleefvdehfeeiveejieefveeiteeggffggfeulefgjeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgurdhstghhuhgsvghrthes
    fhgrshhtmhgrihhlrdhfmhdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpoh
    huthdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtohep
    sghstghhuhgsvghrthesuggunhdrtghomhdprhgtphhtthhopegrgigsohgvsehkvghrnh
    gvlhdrughkpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhm
    pdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgtphhtth
    hopehjohhsvghfsehtohigihgtphgrnhgurgdrtghomhdprhgtphhtthhopegrmhhirhej
    fehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:qY1EZ44ib0x57I5hYn4Tfu_isayfoOR4Si9J_-DcvEuMvbSvZp0bhQ>
    <xmx:qY1EZ84OiZ9sCWHHN0U9z6Yyg0KIBm8bMHEYVZOtgjysLaghCkMW3Q>
    <xmx:qY1EZwj-dttGvGG_XENblLd6stloKdvwD_bkBZhN2U_r85rgmFpreg>
    <xmx:qY1EZ-7q4uuhZOW6xkS-ubM-hzCTXdetMlYEoW4TrJDhbhCkZOrE4w>
    <xmx:qo1EZ8yC9wREuqGVyh96Z7e-QgZZG2PH4irt7IEtS3mbQ9fQeZ2SXz_A>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 Nov 2024 09:46:00 -0500 (EST)
Message-ID: <6876e1cf-9bd2-483d-bd49-c52967c88397@fastmail.fm>
Date: Mon, 25 Nov 2024 15:45:59 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v6 05/16] fuse: make args->in_args[0] to be always the
 header
To: Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com
References: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
 <20241122-fuse-uring-for-6-10-rfc4-v6-5-28e6cdd0e914@ddn.com>
 <CAJfpeguPCUajx=LX-M2GFO4hzi6A2uc-8tijHEFVSipK7xFU5A@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJfpeguPCUajx=LX-M2GFO4hzi6A2uc-8tijHEFVSipK7xFU5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/23/24 10:01, Miklos Szeredi wrote:
> On Fri, 22 Nov 2024 at 00:44, Bernd Schubert <bschubert@ddn.com> wrote:
> 
>> diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
>> index 12ef91d170bb3091ac35a33d2b9dc38330b00948..e459b8134ccb089f971bebf8da1f7fc5199c1271 100644
>> --- a/fs/fuse/dax.c
>> +++ b/fs/fuse/dax.c
>> @@ -237,14 +237,17 @@ static int fuse_send_removemapping(struct inode *inode,
>>         struct fuse_inode *fi = get_fuse_inode(inode);
>>         struct fuse_mount *fm = get_fuse_mount(inode);
>>         FUSE_ARGS(args);
>> +       struct fuse_zero_in zero_arg;
> 
> I'd move this to global scope (i.e. just a single instance for all
> uses) and rename to zero_header.
> 
>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>> index fd8898b0c1cca4d117982d5208d78078472b0dfb..6cb45b5332c45f322e9163469ffd114cbc07dc4f 100644
>> --- a/fs/fuse/dev.c
>> +++ b/fs/fuse/dev.c
>> @@ -1053,6 +1053,19 @@ static int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
>>
>>         for (i = 0; !err && i < numargs; i++)  {
>>                 struct fuse_arg *arg = &args[i];
>> +
>> +               /* zero headers */
>> +               if (arg->size == 0) {
>> +                       if (WARN_ON_ONCE(i != 0)) {
>> +                               if (cs->req)
>> +                                       pr_err_once(
>> +                                               "fuse: zero size header in opcode %d\n",
>> +                                               cs->req->in.h.opcode);
>> +                               return -EINVAL;
>> +                       }
> 
> Just keep the WARN_ON_ONCE() and drop everything else, including
> return -EINVAL.  The same thing should happen without the arg->size ==
> 0 check

I have to remove the WARN_ON_ONCE condition altogether, gets triggered by
/dev/fuse read (i.e. with io-uring being disabled), in generic/062, 
op code=39 (FUSE_IOCTL).
Without the pr_err_once() and printing the op code it would have been impossible
to see which op code that is - the trace does not help here.


Thanks,
Bernd

