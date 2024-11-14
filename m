Return-Path: <io-uring+bounces-4709-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 764DF9C94FD
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 23:06:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC9FEB236BC
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 22:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF181ADFE0;
	Thu, 14 Nov 2024 22:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="RbLyQJEF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DlOjj9xT"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A6819CC02;
	Thu, 14 Nov 2024 22:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731621985; cv=none; b=QIhy7D31TSKtGWkhijAj2XJ3pfY2NhlDbA0fu7remfw9SI9Li7E3Txv56DIoNhZzQimYJOxlTFRMgLk1C2CQRoACyjnHIgtcydvMD0c7PWpA8eGk90BEAlTNlJF2HEVo1I/cv6fV4k9uqww3DIu2XjE+X0pgUKEhqOfof9eIF5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731621985; c=relaxed/simple;
	bh=dMzuxcpcQP0SXGL/PU1OzogLCyrAVhblRFi0M6FEJQU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N32Hq9BdTIhcV9FJ2WPb+VlMu9CAFyo0ZeT/RAU0j0N7rHaTuFFcDCXJ5Xarir4dO9BAmCSVTKorp5Go3pOE7r27YwzXfZmri7lqOZEZ5pJz8WmelCsOIEKuuWK7Cpy1+GH2bHFbjOj583GFOWpHuE2N7EQOwhRyvFc1VgPUQ1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=RbLyQJEF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DlOjj9xT; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 281D31140156;
	Thu, 14 Nov 2024 17:06:22 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 14 Nov 2024 17:06:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1731621982;
	 x=1731708382; bh=EWQHMFsxUX4AVUvmTtFUUts/cKVt83b9dkyCpPaTjAo=; b=
	RbLyQJEFvpIGR4tYdwaGGVrzvWBVWYvpTmMiuLmnNidDZ5/fCkuVqwHgD2phdPTk
	sLL75olWQDDaxjpBEK0z5sbGziRHt4k/wSsoFrNS1tfeZikUEjklQQq/wTUAEw5X
	fbG0zj03cGrlxebRUAzVXc7pvXAask/dgBcuQbawv3+Rp82furk6Caw4/p/fZHfW
	MfOwsgtgkZVYheZ1ABvNFJ4A+BF+W64jEpbE8EHKrj5NDI1/vS8+LgVt2irwPyJb
	z7ocVV66Plm/wY4ijtwHidZST3i0rdOuLxDk9XmyhyMSO+wrCBoe/S9HtEYtSh70
	I54WMY7YuoGDcfdAXclGbg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1731621982; x=
	1731708382; bh=EWQHMFsxUX4AVUvmTtFUUts/cKVt83b9dkyCpPaTjAo=; b=D
	lOjj9xTDg3mLglmK1qNbPHO1tG4fDPpZUsLxK2jkBtk45zx9Zh10sF7BMvpNF1YS
	QpUBDkV+8D5YWz9UbmGZs9Yjbp1f8ThfyAjnvlQKjc3jfffuktBkkyzdGEGcfb+4
	pn4q3B725ApnJ5KWdve8UmBTiRMFsbeYHVTcaS5B6ySuNRGXYtFbBYRmtVHXEdAj
	ny2N1RAuW15bkchf7bWZYtLNpXq4gnujY0yryQ02e2gHTUzPtByuVAEiNkWdiDcy
	sEv3gzaX2WrF6OlAJMEvXf3Ntj+1j56R9kgOF1xUUdrr55WCr2Db4oFD9dTR5b8M
	z3hLDBDq2jkdUe1JwiY4g==
X-ME-Sender: <xms:XXQ2ZwOYRue7q3bV1c9MFKEDws_xg6-duADs3x2u-BJD4mEgO3pZJg>
    <xme:XXQ2Z2-HW-rRHsltlF-yNDsMb_-YzxiYKtnn5Q4Zq_WxfMfcUj2l99Q0s9X40FbJ3
    xMpMG9npk8GKuvW>
X-ME-Received: <xmr:XXQ2Z3S8Whhg7rUR1En68Bo5UlKGh2Du8RUCQBi7O6W96jhXcai1SkQx5SkfrvPQHHCsx4brAd4qEOfdNKU98-yBTYbaAdfLJfapkqhMlnbxP6f5xUzI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrvddvgdduheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepudelfedvudevudev
    leegleffffekudekgeevlefgkeeluedvheekheehheekhfefnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepsghstghhuhgsvghrthesuggunhdrtghomhdprhgtphhtthhopehmihhklh
    hoshesshiivghrvgguihdrhhhupdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgu
    khdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtph
    htthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepjhhoshgvfhesthhogihitghprghnuggrrdgtohhmpdhrtghpthhtoheprghmihhr
    jeefihhlsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:XXQ2Z4vhxXvfEjSfz8WrkEvhaGcmeJqf0ZIy6hIT6OS1bjoxXrNa6A>
    <xmx:XXQ2Z4euSy6QrkUjHArvAf2xWQHJTRygdK0R7e_Qk--UYh5EHXO3Pw>
    <xmx:XXQ2Z801YSxh9jX5Bi4QoP4kbMeqHTm5I0a8MVRh8xD1iwujPBHQZg>
    <xmx:XXQ2Z8-nUw1PQq0lfAwu4sDQRKC-a0tzDgljI-zD5Nphjxy3lzfe6g>
    <xmx:XnQ2Z-05BVq95GbagAtAdh4uPrk5hRHcGY7T6B63NxgB_vUmeScaMbBu>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 14 Nov 2024 17:06:19 -0500 (EST)
Message-ID: <7cb814e8-38ec-468c-9bd8-1cc5d0664686@fastmail.fm>
Date: Thu, 14 Nov 2024 23:06:18 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v5 05/16] fuse: make args->in_args[0] to be always the
 header
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
 <20241107-fuse-uring-for-6-10-rfc4-v5-5-e8660a991499@ddn.com>
 <CAJnrk1ZsW=EFi2Weh66KPPQTT1TkvsZKMkeSd1JekQKGa0_ZNQ@mail.gmail.com>
 <cd5c17fd-8127-42f8-bd20-a693ce66bddc@fastmail.fm>
 <CAJnrk1aBvndZ9o3n9dRbjHxTzJiffWQqYBJRtNgwk=PWO_FW3Q@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1aBvndZ9o3n9dRbjHxTzJiffWQqYBJRtNgwk=PWO_FW3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/14/24 22:29, Joanne Koong wrote:
> On Thu, Nov 14, 2024 at 1:05 PM Bernd Schubert
> <bernd.schubert@fastmail.fm> wrote:
>>
>>
>>
>> On 11/14/24 21:57, Joanne Koong wrote:
>>> On Thu, Nov 7, 2024 at 9:04 AM Bernd Schubert <bschubert@ddn.com> wrote:
>>>>
>>>> This change sets up FUSE operations to have headers in args.in_args[0],
>>>> even for opcodes without an actual header. We do this to prepare for
>>>> cleanly separating payload from headers in the future.
>>>>
>>>> For opcodes without a header, we use a zero-sized struct as a
>>>> placeholder. This approach:
>>>> - Keeps things consistent across all FUSE operations
>>>> - Will help with payload alignment later
>>>> - Avoids future issues when header sizes change
>>>>
>>>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>>>> ---
>>>>  fs/fuse/dax.c    | 13 ++++++++-----
>>>>  fs/fuse/dev.c    | 24 ++++++++++++++++++++----
>>>>  fs/fuse/dir.c    | 41 +++++++++++++++++++++++++++--------------
>>>>  fs/fuse/fuse_i.h |  7 +++++++
>>>>  fs/fuse/xattr.c  |  9 ++++++---
>>>>  5 files changed, 68 insertions(+), 26 deletions(-)
>>>>
>>>> diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
>>>> index 12ef91d170bb3091ac35a33d2b9dc38330b00948..e459b8134ccb089f971bebf8da1f7fc5199c1271 100644
>>>> --- a/fs/fuse/dax.c
>>>> +++ b/fs/fuse/dax.c
>>>> @@ -237,14 +237,17 @@ static int fuse_send_removemapping(struct inode *inode,
>>>>         struct fuse_inode *fi = get_fuse_inode(inode);
>>>>         struct fuse_mount *fm = get_fuse_mount(inode);
>>>>         FUSE_ARGS(args);
>>>> +       struct fuse_zero_in zero_arg;
>>>>
>>>>         args.opcode = FUSE_REMOVEMAPPING;
>>>>         args.nodeid = fi->nodeid;
>>>> -       args.in_numargs = 2;
>>>> -       args.in_args[0].size = sizeof(*inargp);
>>>> -       args.in_args[0].value = inargp;
>>>> -       args.in_args[1].size = inargp->count * sizeof(*remove_one);
>>>> -       args.in_args[1].value = remove_one;
>>>> +       args.in_numargs = 3;
>>>> +       args.in_args[0].size = sizeof(zero_arg);
>>>> +       args.in_args[0].value = &zero_arg;
>>>> +       args.in_args[1].size = sizeof(*inargp);
>>>> +       args.in_args[1].value = inargp;
>>>> +       args.in_args[2].size = inargp->count * sizeof(*remove_one);
>>>> +       args.in_args[2].value = remove_one;
>>>>         return fuse_simple_request(fm, &args);
>>>>  }
>>>>
>>>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>>>> index dbc222f9b0f0e590ce3ef83077e6b4cff03cff65..6effef4073da3dad2f6140761eca98147a41d88d 100644
>>>> --- a/fs/fuse/dev.c
>>>> +++ b/fs/fuse/dev.c
>>>> @@ -1007,6 +1007,19 @@ static int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
>>>>
>>>>         for (i = 0; !err && i < numargs; i++)  {
>>>>                 struct fuse_arg *arg = &args[i];
>>>> +
>>>> +               /* zero headers */
>>>> +               if (arg->size == 0) {
>>>> +                       if (WARN_ON_ONCE(i != 0)) {
>>>> +                               if (cs->req)
>>>> +                                       pr_err_once(
>>>> +                                               "fuse: zero size header in opcode %d\n",
>>>> +                                               cs->req->in.h.opcode);
>>>> +                               return -EINVAL;
>>>> +                       }
>>>> +                       continue;
>>>> +               }
>>>> +
>>>>                 if (i == numargs - 1 && argpages)
>>>>                         err = fuse_copy_pages(cs, arg->size, zeroing);
>>>>                 else
>>>> @@ -1662,6 +1675,7 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
>>>>         size_t args_size = sizeof(*ra);
>>>>         struct fuse_args_pages *ap;
>>>>         struct fuse_args *args;
>>>> +       struct fuse_zero_in zero_arg;
>>>>
>>>>         offset = outarg->offset & ~PAGE_MASK;
>>>>         file_size = i_size_read(inode);
>>>> @@ -1688,7 +1702,7 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
>>>>         args = &ap->args;
>>>>         args->nodeid = outarg->nodeid;
>>>>         args->opcode = FUSE_NOTIFY_REPLY;
>>>> -       args->in_numargs = 2;
>>>> +       args->in_numargs = 3;
>>>>         args->in_pages = true;
>>>>         args->end = fuse_retrieve_end;
>>>>
>>>> @@ -1715,9 +1729,11 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
>>>>         }
>>>>         ra->inarg.offset = outarg->offset;
>>>>         ra->inarg.size = total_len;
>>>> -       args->in_args[0].size = sizeof(ra->inarg);
>>>> -       args->in_args[0].value = &ra->inarg;
>>>> -       args->in_args[1].size = total_len;
>>>> +       args->in_args[0].size = sizeof(zero_arg);
>>>> +       args->in_args[0].value = &zero_arg;
>>>> +       args->in_args[1].size = sizeof(ra->inarg);
>>>> +       args->in_args[1].value = &ra->inarg;
>>>> +       args->in_args[2].size = total_len;
>>>>
>>>>         err = fuse_simple_notify_reply(fm, args, outarg->notify_unique);
>>>>         if (err)
>>>
>>> Do we also need to add a zero arg header for FUSE_READLINK,
>>> FUSE_DESTROY, and FUSE_BATCH_FORGET requests as well?
>>>
>>
>> Thanks for looking at the patch! I should have added to the commit message
>> that I didn't modify these, as they don't have an in argument at all.
>>
> 
> Thanks for clarifying! (and apologies for the late review. I haven't
> been keeping up with these patches since RFC v3 but I'm planning to
> get up to speed and take a deeper look at these tomorrow + next week).

No worries at all... I'm also very late with reviewing your patches. 
I'm close for the next fuse-io-version, just fixing some bg accounting
issues that had been in all rfc versions so far.

> 
> I think the FUSE_BATCH_FORGET request does use in args, depending on
> the number of forget requests.

Ah right, but it does not use fuse_copy_args and args->in_args[idx] - 
is very special. And just looking it up again, the header is in the
right place. Issue would be more for over-io-uring to copy into the
payload. However, current over-io-uring patches don't handle forgets
at all - it goes over /dev/fuse. Unless you disagree, I think we can
do forgets later on over io-uring as optimization.


Thanks,
Bernd



