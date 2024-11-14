Return-Path: <io-uring+bounces-4707-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B31DE9C93C7
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 22:05:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4249F1F22ED4
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 21:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56B521ADFE0;
	Thu, 14 Nov 2024 21:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="jeZdweQk";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CHDQZMRt"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8822D19CC02;
	Thu, 14 Nov 2024 21:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731618338; cv=none; b=E+eDy0ConAgVLZIhsgeCp9jGqudfGlcZUGiHEkbfHs2r2+B/jPe3PbuzXpQhtLXiX+ybIvYziADGtR11tgNf3Y4iAIleaquRMjKDxgKpAlVc9liHMR2dLDDX27M8DTCkoiOHTlaKxokr9b55QRfeo6DN6zqzgHBnJM2f++ekV/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731618338; c=relaxed/simple;
	bh=hzD3XtFWpFUgE6I4yklgz2p4v7EgvJUPFS0G9GjvU2g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g4M1rOmq5BRZbtCPCSQY4aVioBQY4yvbrRB6geb9zueoSJ0sjwTPU5QUs3c/NN9aUMNpkKhj+o8AEvzh5lGyBVROIpexzZPghYRjS8WGRktilKEuFc0k49e2UrLGwuwx+VHcb7Jr9pOl5DQLnug/sx7LZBjx9qvJt32Kt8qlSek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=jeZdweQk; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CHDQZMRt; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 857621380679;
	Thu, 14 Nov 2024 16:05:33 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Thu, 14 Nov 2024 16:05:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1731618333;
	 x=1731704733; bh=73A9PkjcvG99zWGKq9o2SjQ7C+cThwFZ0q+xR23TE6I=; b=
	jeZdweQk6jkWU4Fnxaa9lQWjDIzdtqRpmNEDm3apcKmWvVVi/Zr3dFJXPo5tzru3
	1AuVP9GoirufjbFiSTh9BxlCL6eygwxDhokYplxUKsF8bkz3C0FYsRkYHOLqJy44
	SO6YQCCDwY1KsiPqQwmQdEFwTZk8TlWN3kZbc3kr2PfiCvyS2KRijo7W256TyR3Z
	TITT61qI5m2hLJYSGFb9uVS8F8Q66zGY8u3PR6Ihrq6S9GLOmMttXJf2RQFsRrIl
	uP2Ao49gtv/sOmJ2VgL/eUY0xEE5BXiq4dyAFuwBw8d1VTwxGZcTeHwOcij7TYr8
	mnNmWzcdv8ZpKgPM9VLynQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1731618333; x=
	1731704733; bh=73A9PkjcvG99zWGKq9o2SjQ7C+cThwFZ0q+xR23TE6I=; b=C
	HDQZMRtfBExboyN394TYFqJKqd54BC2xlkwqaDzXQbyLd/r0sgdWSlvtkvEul/dr
	QQ0eGusnExLerHYP2PDZU8q7aUBKEGtw7QjOJKGnObfTet+jKc8TJzeM630cGM0h
	gg0QtKGfH3xClU9WeAly26P6HCt98qeF+a1Wgf1Mi+RBR4JgL0NFLmb29gabEi24
	/6/vnKXq+T3Tnj0hD1E4OTPwUELkNluZleESVceveiqwUdDSMIVcfVfHaYkUTdoT
	6QXRrBS9MEebbz+2Fm9LWuq7OqqRJqssB7TIpylHmdLW8ByAjgtfDFA/AU7EWcaX
	46D1KRwVZMfSfw3dy0l6Q==
X-ME-Sender: <xms:G2Y2Z8syhMPayVNGtThUHdZ7auEf_bFAC3P-2jp-WBXvGsdspBeCkg>
    <xme:G2Y2Z5ceBipdwl-ivWyH84mIBQKNndiTeXDiXZa2HZv19bedL9HSlL_myGKWsppna
    W4APOnoc85aAHFJ>
X-ME-Received: <xmr:G2Y2Z3wIq4BPUc7bsi3tIjL-gzjYxta4sX0mj5PRstu8ucS_cJZfCBbXF0vfQiTe0D9I6YdPhjxxrSpx6sS9THQGZ7vqeJxP6R2uKsoZ16X-9vyF9M5y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrvddvgddugeefucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:HGY2Z_NwpREidxAMtRuR79ojWaOGXPV7Ybcq_lxTPId48y48GljCVg>
    <xmx:HGY2Z88tMz0WuXdaDzk8BxDTum2HyJGibUq153-IavmXniMsqgI7lA>
    <xmx:HGY2Z3UXrUcrN2KVUXuOfW8BjTy7MWAk8BVl_sw9QdZncxpGGhvbnw>
    <xmx:HGY2Z1esP5DwUgPusL6XTSfqZvlYFxq8YVvv3Z8kTs3DyY9Rv4cTaQ>
    <xmx:HWY2Z3Vwm33xC8msQTG1ee1awwTicRKtja22FJA-QfhxbRSo4IOtIbdQ>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 14 Nov 2024 16:05:30 -0500 (EST)
Message-ID: <cd5c17fd-8127-42f8-bd20-a693ce66bddc@fastmail.fm>
Date: Thu, 14 Nov 2024 22:05:29 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v5 05/16] fuse: make args->in_args[0] to be always the
 header
To: Joanne Koong <joannelkoong@gmail.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
 <20241107-fuse-uring-for-6-10-rfc4-v5-5-e8660a991499@ddn.com>
 <CAJnrk1ZsW=EFi2Weh66KPPQTT1TkvsZKMkeSd1JekQKGa0_ZNQ@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1ZsW=EFi2Weh66KPPQTT1TkvsZKMkeSd1JekQKGa0_ZNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/14/24 21:57, Joanne Koong wrote:
> On Thu, Nov 7, 2024 at 9:04 AM Bernd Schubert <bschubert@ddn.com> wrote:
>>
>> This change sets up FUSE operations to have headers in args.in_args[0],
>> even for opcodes without an actual header. We do this to prepare for
>> cleanly separating payload from headers in the future.
>>
>> For opcodes without a header, we use a zero-sized struct as a
>> placeholder. This approach:
>> - Keeps things consistent across all FUSE operations
>> - Will help with payload alignment later
>> - Avoids future issues when header sizes change
>>
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>> ---
>>  fs/fuse/dax.c    | 13 ++++++++-----
>>  fs/fuse/dev.c    | 24 ++++++++++++++++++++----
>>  fs/fuse/dir.c    | 41 +++++++++++++++++++++++++++--------------
>>  fs/fuse/fuse_i.h |  7 +++++++
>>  fs/fuse/xattr.c  |  9 ++++++---
>>  5 files changed, 68 insertions(+), 26 deletions(-)
>>
>> diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
>> index 12ef91d170bb3091ac35a33d2b9dc38330b00948..e459b8134ccb089f971bebf8da1f7fc5199c1271 100644
>> --- a/fs/fuse/dax.c
>> +++ b/fs/fuse/dax.c
>> @@ -237,14 +237,17 @@ static int fuse_send_removemapping(struct inode *inode,
>>         struct fuse_inode *fi = get_fuse_inode(inode);
>>         struct fuse_mount *fm = get_fuse_mount(inode);
>>         FUSE_ARGS(args);
>> +       struct fuse_zero_in zero_arg;
>>
>>         args.opcode = FUSE_REMOVEMAPPING;
>>         args.nodeid = fi->nodeid;
>> -       args.in_numargs = 2;
>> -       args.in_args[0].size = sizeof(*inargp);
>> -       args.in_args[0].value = inargp;
>> -       args.in_args[1].size = inargp->count * sizeof(*remove_one);
>> -       args.in_args[1].value = remove_one;
>> +       args.in_numargs = 3;
>> +       args.in_args[0].size = sizeof(zero_arg);
>> +       args.in_args[0].value = &zero_arg;
>> +       args.in_args[1].size = sizeof(*inargp);
>> +       args.in_args[1].value = inargp;
>> +       args.in_args[2].size = inargp->count * sizeof(*remove_one);
>> +       args.in_args[2].value = remove_one;
>>         return fuse_simple_request(fm, &args);
>>  }
>>
>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>> index dbc222f9b0f0e590ce3ef83077e6b4cff03cff65..6effef4073da3dad2f6140761eca98147a41d88d 100644
>> --- a/fs/fuse/dev.c
>> +++ b/fs/fuse/dev.c
>> @@ -1007,6 +1007,19 @@ static int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
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
>> +                       continue;
>> +               }
>> +
>>                 if (i == numargs - 1 && argpages)
>>                         err = fuse_copy_pages(cs, arg->size, zeroing);
>>                 else
>> @@ -1662,6 +1675,7 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
>>         size_t args_size = sizeof(*ra);
>>         struct fuse_args_pages *ap;
>>         struct fuse_args *args;
>> +       struct fuse_zero_in zero_arg;
>>
>>         offset = outarg->offset & ~PAGE_MASK;
>>         file_size = i_size_read(inode);
>> @@ -1688,7 +1702,7 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
>>         args = &ap->args;
>>         args->nodeid = outarg->nodeid;
>>         args->opcode = FUSE_NOTIFY_REPLY;
>> -       args->in_numargs = 2;
>> +       args->in_numargs = 3;
>>         args->in_pages = true;
>>         args->end = fuse_retrieve_end;
>>
>> @@ -1715,9 +1729,11 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
>>         }
>>         ra->inarg.offset = outarg->offset;
>>         ra->inarg.size = total_len;
>> -       args->in_args[0].size = sizeof(ra->inarg);
>> -       args->in_args[0].value = &ra->inarg;
>> -       args->in_args[1].size = total_len;
>> +       args->in_args[0].size = sizeof(zero_arg);
>> +       args->in_args[0].value = &zero_arg;
>> +       args->in_args[1].size = sizeof(ra->inarg);
>> +       args->in_args[1].value = &ra->inarg;
>> +       args->in_args[2].size = total_len;
>>
>>         err = fuse_simple_notify_reply(fm, args, outarg->notify_unique);
>>         if (err)
> 
> Do we also need to add a zero arg header for FUSE_READLINK,
> FUSE_DESTROY, and FUSE_BATCH_FORGET requests as well?
> 

Thanks for looking at the patch! I should have added to the commit message
that I didn't modify these, as they don't have an in argument at all.


Thanks,
Bernd

