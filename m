Return-Path: <io-uring+bounces-4813-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 368449D2288
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 10:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9DA0282A2E
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 09:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B7FC1925B3;
	Tue, 19 Nov 2024 09:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="YAo2jUDe";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="E7wN0KEO"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31117139566;
	Tue, 19 Nov 2024 09:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732008760; cv=none; b=qbMO2yF6Qv1el+15UtVYwyxa4xPnP8IMF88DxHuZUcua4QHFfgCzHu2ip+f+RFS44pMCFsptcXv5okHjNciFc2zjGhmbw4dAt8RuGPWNCTyZUT+Sd+StbJMHitOH6kMWRVLm99YZVCoWqTc2Fq0JqtUQLrKo8zORpjkvK8nKhkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732008760; c=relaxed/simple;
	bh=XY5tGIGZZL7e0LghGFR9sTnt+E+3dNNk9PaCmrIMIyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u4y99DlNWK1QFyA/SXWMfg1Gq3f/Y0tS5mE3JyJXc3VJ9VmP7/B2sC8vr0pfsyN1U0ylsUlZInUO9OjASSj26iFW25giwPvWoEw1I9Adk2eOdkgBZA0Hghe/Gm0DW7m+pglyd3J0NOwBMIOSBt+uU9RnxUX4CP1WqvHn5fG06Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=YAo2jUDe; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=E7wN0KEO; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id D8E371140142;
	Tue, 19 Nov 2024 04:32:35 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 19 Nov 2024 04:32:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1732008755;
	 x=1732095155; bh=c9eyezGfILmv/qmj8btmglcoZTp0fykMts6f9eQzwk0=; b=
	YAo2jUDeXh+smPdcvir0t2y73znP17b2Oy+dGpVOUlZlt13JGCzsWCDBzBBzaYmP
	iGRd868TvDF5ByzK17uXlAdNndtww36TUSwU0MGaARvMkwQ+Eqw0x7InCC6rCDm7
	GCxaKAdUuGfHDP9T0EpKOyVDSFckXBXJ75rMI0chmEo51C1+tsxkkz2Oph/LqmwV
	jpiXeRP6SNKFBUc282f30ji+xsO2bPS67V4zwsrelFcm3caQvqs35Z8cudpQpOkI
	plHm7Nk4thl1nqGFV7ThJAYGkX+P4GLt/G6DfYiAu8JccBPjnGM1nYp7IbEd3hDA
	INb+bl6a1+xZ/DQF39XDCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1732008755; x=
	1732095155; bh=c9eyezGfILmv/qmj8btmglcoZTp0fykMts6f9eQzwk0=; b=E
	7wN0KEOYVRgEvz4kH4jBeNVzqbl+3WO84wOnC+NHDunWCKJzwperm035iL0DAlcW
	n7w053bfAxtHb+XRFnXu8JeLurIpcm4v2+J3m6KFqO0W9fhKaWGsO7oLu47TwzwY
	BsObWpEgunxP1K2WNj95cAUjRYbj2ZABmOZZmFOrV30X+yqBoRCL9ZQgnNxcNo1B
	heUnAkc1NXG5+gfLagiZzPrUrte6SYIFf9cSD7RiT2SVyew57WOwvY1+uCRSQHfh
	21daAb7DZSGd4lTYd99uVFmlrJKy28j7lHcb2I4S9EwrPV60oOgDz/FxXGrKRIfn
	A+eRf3hm6EUR7x8Vv67/Q==
X-ME-Sender: <xms:M1s8Z7L7-zwsom5Wg3t_zGtzitBC68ggFDhFCSz-b7xrtLM8ydo28A>
    <xme:M1s8Z_Iyegdq2XNzx_R5nP3-ETSCJqoTygkWyv2Lx8SnNaq4MWiEBdVmlDdskVMXA
    zMR4IVLPFary3y3>
X-ME-Received: <xmr:M1s8Zzt1RcNmpihMBqQNLD6Yj2SBAYrVv_cM0MenV2eGLXtvJaf4AHWp6asReJ8W6cHXIiAZNXqWE06u7P2wJ1z5Y3-fnnEhcA8jK_qEylgYkoVR35DC>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrfedvgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthekredttddvjeen
    ucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusggvrh
    htsehfrghsthhmrghilhdrfhhmqeenucggtffrrghtthgvrhhnpeduleefvdduveduveel
    geelffffkedukeegveelgfekleeuvdehkeehheehkefhfeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgurdhstghhuhgsvghrthes
    fhgrshhtmhgrihhlrdhfmhdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpoh
    huthdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgt
    phhtthhopegsshgthhhusggvrhhtseguughnrdgtohhmpdhrtghpthhtohepmhhikhhloh
    hssehsiigvrhgvughirdhhuhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrughk
    pdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpth
    htoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehjohhsvghfsehtohigihgtphgrnhgurgdrtghomhdprhgtphhtthhopegrmhhirhej
    fehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:M1s8Z0ZYLQ3PWhSoMnS3ZH2JGNG6RxXwuNK9PAEGhGerqvoaUSAhHg>
    <xmx:M1s8ZyY-aarQPpjLd-83wDovPkZSq0wFGCuHwXG5qFTVZZa6my5SCg>
    <xmx:M1s8Z4A2lNwDuIrIjDDgdjfp520Bny4flk-BKoEKyPnn-OMjDaSWQA>
    <xmx:M1s8ZwbGr8TqhJ13UTZq-_Hh2HBGRvXGzknizKbcFUtbhuerPgEJig>
    <xmx:M1s8Z-RTkfGZ08P4XxynVHHSGdL8geodvnqhHXs5uK6ol0PfHZbHpeVM>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Nov 2024 04:32:33 -0500 (EST)
Message-ID: <8c054c6d-33d5-4f04-bbea-6a38e9f10b24@fastmail.fm>
Date: Tue, 19 Nov 2024 10:32:32 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v5 15/16] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
 <20241107-fuse-uring-for-6-10-rfc4-v5-15-e8660a991499@ddn.com>
 <CAJnrk1YuoiWzq=ykn9wFKG3RZYdFm-AzSiXfoP=Js0S-P7eKZA@mail.gmail.com>
 <19af894d-d5ac-4fcf-8fa1-b387c354c669@fastmail.fm>
 <CAJnrk1a7jOtz_Noyw4mw9p4TqoUCJ-6hR9wJiQFER9w8g5mmzg@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1a7jOtz_Noyw4mw9p4TqoUCJ-6hR9wJiQFER9w8g5mmzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/19/24 03:02, Joanne Koong wrote:
> On Mon, Nov 18, 2024 at 3:47 PM Bernd Schubert
> <bernd.schubert@fastmail.fm> wrote:
>>
>> On 11/19/24 00:30, Joanne Koong wrote:
>>> On Thu, Nov 7, 2024 at 9:04 AM Bernd Schubert <bschubert@ddn.com> wrote:
>>>>
>>>> When the fuse-server terminates while the fuse-client or kernel
>>>> still has queued URING_CMDs, these commands retain references
>>>> to the struct file used by the fuse connection. This prevents
>>>> fuse_dev_release() from being invoked, resulting in a hung mount
>>>> point.
>>>>
>>>> This patch addresses the issue by making queued URING_CMDs
>>>> cancelable, allowing fuse_dev_release() to proceed as expected
>>>> and preventing the mount point from hanging.
>>>>
>>>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>>>> ---
>>>>  fs/fuse/dev_uring.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++-----
>>>>  1 file changed, 70 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>>>> index 6af515458695ccb2e32cc8c62c45471e6710c15f..b465da41c42c47eaf69f09bab1423061bc8fcc68 100644
>>>> --- a/fs/fuse/dev_uring.c
>>>> +++ b/fs/fuse/dev_uring.c
>>>> @@ -23,6 +23,7 @@ MODULE_PARM_DESC(enable_uring,
>>>>
>>>>  struct fuse_uring_cmd_pdu {
>>>>         struct fuse_ring_ent *ring_ent;
>>>> +       struct fuse_ring_queue *queue;
>>>>  };
>>>>
>>>>  /*
>>>> @@ -382,6 +383,61 @@ void fuse_uring_stop_queues(struct fuse_ring *ring)
>>>>         }
>>>>  }
>>>>
>>>> +/*
>>>> + * Handle IO_URING_F_CANCEL, typically should come on daemon termination
>>>> + */
>>>> +static void fuse_uring_cancel(struct io_uring_cmd *cmd,
>>>> +                             unsigned int issue_flags, struct fuse_conn *fc)
>>>> +{
>>>> +       struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu *)cmd->pdu;
>>>> +       struct fuse_ring_queue *queue = pdu->queue;
>>>> +       struct fuse_ring_ent *ent;
>>>> +       bool found = false;
>>>> +       bool need_cmd_done = false;
>>>> +
>>>> +       spin_lock(&queue->lock);
>>>> +
>>>> +       /* XXX: This is cumbersome for large queues. */
>>>> +       list_for_each_entry(ent, &queue->ent_avail_queue, list) {
>>>> +               if (pdu->ring_ent == ent) {
>>>> +                       found = true;
>>>> +                       break;
>>>> +               }
>>>> +       }
>>>
>>> Do we have to check that the entry is on the ent_avail_queue, or can
>>> we assume that if the ent->state is FRRS_WAIT, the only queue it'll be
>>> on is the ent_avail_queue? I see only one case where this isn't true,
>>> for teardown in fuse_uring_stop_list_entries() - if we had a
>>> workaround for this, eg having some teardown state signifying that
>>> io_uring_cmd_done() needs to be called on the cmd and clearing
>>> FRRS_WAIT, then we could get rid of iteration through ent_avail_queue
>>> for every cancelled cmd.
>>
>>
>> I'm scared that we would run into races - I don't want to access memory
>> pointed to by pdu->ring_ent, before I'm not sure it is on the list.
> 
> Oh, I was seeing that we mark the cmd as cancellable (eg in
> fuse_uring_prepare_cancel()) only after the ring_ent is moved to the
> ent_avail_queue (in fuse_uring_ent_avail()) and that this is done in
> the scope of the queue->lock, so we would only call into
> fuse_uring_cancel() when the ring_ent is on the list. Could there
> still be a race condition here?
> 
> Alternatively, inspired by your "bool valid;" idea below, maybe
> another solution would be having a bit in "struct fuse_ring_ent"
> tracking if io_uring_cmd_done() needs to be called on it?

What I mean is that daemon termination might race with normal umount.
Umount does everything cleanly and iterates through lists, but might
free 'struct fuse_ring_ent', see fuse_uring_entry_teardown().
On the other hand, daemon termination with IO_URING_F_CANCEL has 
the pointer to ring_ent - but that pointer might be already freed 
by umount. That also means another bit in "struct fuse_ring_ent" 
won't help.

> 
> This is fairly unimportant though - this part could always be
> optimized in a future patchset if you think it needs to be optimized,
> but was just curious if these would work.
> 

I'm going to change logic a bit and will introduce another list
'freeable_ring_ent'. Entries will be moved to that new list and
only freed in fuse_uring_destruct(). After that IO_URING_F_CANCEL
can check stat of ring_ent directly


Thanks for the discussion!


Bernd

