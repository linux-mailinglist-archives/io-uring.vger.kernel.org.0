Return-Path: <io-uring+bounces-3041-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFAFA96CA8D
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 00:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E42141C20859
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 22:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327E81547D8;
	Wed,  4 Sep 2024 22:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="uSmW0HUf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hLeSLy0r"
X-Original-To: io-uring@vger.kernel.org
Received: from fout2-smtp.messagingengine.com (fout2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400F9146D7F;
	Wed,  4 Sep 2024 22:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725489495; cv=none; b=V41tGX7bm9yL3EfxSBXUbi/fBFHK4mLPQfZcT62q+0OXmov3F1UxaEAj/SkTA6aBpVHPQl5HOs0uO5GhlcgThiSr0pNRw+iMSstoQ5yoM40rYRyGZSgmLE2NL20Fs8H1CIiajxc/Nu3MQAksYTe4Isggz8eEPrUkmMNBP6dxvlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725489495; c=relaxed/simple;
	bh=zOrzkwkrL2FiQb39I6v00dC6/o8CoGeJCNXH8tHo1jY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ihA3nFbqQ+zNUzvVr4vGMu1ORHRRMffTNaIZJ7/LOGaEdBJnl4E/3OXzww1K3Cmjv1qJicUcdmJVOecTqg0Q3srTDY4GUlJE3ffEOkt5cfUKdlx2PyjTi39zg1dBWh/oMTjMe23Hfsiup1sTFceSyVl0vqGxa4oWAyIer9Nutdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=uSmW0HUf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hLeSLy0r; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 4E1AC1380292;
	Wed,  4 Sep 2024 18:38:12 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 04 Sep 2024 18:38:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1725489492;
	 x=1725575892; bh=xHegw4sYSlFGD8akLyekuaei9/GMNn7KZdfZY+GAzE0=; b=
	uSmW0HUfadoNfChB/vcYBaAf0miIqWFIand6kzxkOo2dzopDLrdUAhuxlQuuUch2
	FMQtt2H28NWrmMIcfzzJUUl3WuBMH5fzOrPlfZSlaCbzeoBDwSOUCS/oFpzBAmQO
	T0dXmxcbpMsRxEGBpjkhk9RVeR5H0dqOA950uLUGheJQb5awVUGF0Yj5XMFibRc7
	08E9GqrlqtDTQTeOWDXzACIcztirpqGbz2SlNmAwxhwfNVTErp6/kizJmoDfG2bE
	7Y/7GWrXFDPt++4Nf8duDUX5m7vZheYuXwwwWlVwSubLkHRmhCevjpvF0sKdyXHA
	MNZg3i8izN0xEkYaTM32yQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725489492; x=
	1725575892; bh=xHegw4sYSlFGD8akLyekuaei9/GMNn7KZdfZY+GAzE0=; b=h
	LeSLy0reeDKnwaLr1gsNkWMxmbald0FwDMy3PHfkiz/JMSuu9UY3o87Md3yaBfGu
	qfKK0F4LWuqIyP5zlKS82mSnPeT8ybUBbz+JHkSBqcvjzkKVk/zPO8yv5BDw3eN1
	6mfqSd2sobC2Jwv5pOycWKsswr9Tteah75EIBZvlTV/5Ln7aWVZgAoS6+PhA31/s
	C6Ok3Z2G+AQBn5Jqwkb4A2M7oE+H2kl6/AZHkl4F85eX0K9rfV+RurltcYg+Fjm6
	O5kQANy/QXihpZKKDqd+q7XkIvIQSNIBuobFF3j7rLpXtZwyRrMfvIP7ho2bxI84
	5hBuzoBsk/+7CbnhPL4NQ==
X-ME-Sender: <xms:VOHYZrblTvP4FhZhsP8zwrEByeXt6wnPtVvZ_3_vDpBW0ITN6LFVag>
    <xme:VOHYZqZut1qLc609I0QX8y4bsAEOuISEBjjOpMErwokQ3zp1QZgW2_1pkm3jF6tSf
    mRer8wDK2HwqHyI>
X-ME-Received: <xmr:VOHYZt-Y61n88Dp6Q7l_P1a3JwhDJRYh0LiXLXt2gwoKNf9boTYAGo7VomWP_Y77e7_PYjmZv95zgctMDe-aHDM_exfpldxeDe8Yv_oTZCsOQuF3KH8X>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudehkedguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepudelfedvudevudev
    leegleffffekudekgeevlefgkeeluedvheekheehheekhfefnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopedutddpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepsghstghhuhgsvghrthesuggunhdrtghomhdprhgtphhtthhopehmihhklh
    hoshesshiivghrvgguihdrhhhupdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgu
    khdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtph
    htthhopegsvghrnhgusehfrghsthhmrghilhdrfhhmpdhrtghpthhtoheplhhinhhugidq
    fhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehiohdquh
    hrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjohhsvghfseht
    ohigihgtphgrnhgurgdrtghomh
X-ME-Proxy: <xmx:VOHYZhrdH4nHrLWKAYk-aRXQA_O20FjNwD4B027a1sPOoLho0GRBXg>
    <xmx:VOHYZmpEcp9jTZR2mS7drznlLxWrqAjdxsS2PpOZBvQCjI5XeQGE4A>
    <xmx:VOHYZnT5vAtiLK6gpPOIBm8fSibhsyqBlP_dCS40qCRSoJrZa0PjxQ>
    <xmx:VOHYZur_IcnwRLpiz93XfmhjNKi0IuVZQbAWnl4v-TTzBaqe18_czA>
    <xmx:VOHYZjjF-rCxBBWoiZtJujL-K6q3rL6UWNT8qj4x9HO9Y1_0eRJlptMw>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Sep 2024 18:38:10 -0400 (EDT)
Message-ID: <b1e2d60b-477a-4320-acea-df83eec21b77@fastmail.fm>
Date: Thu, 5 Sep 2024 00:38:10 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 06/17] fuse: Add the queue configuration ioctl
To: Joanne Koong <joannelkoong@gmail.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
 <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-6-9207f7391444@ddn.com>
 <CAJnrk1aFcDyJJ5rP1LFkpyUPHkzDv_bcOMPW2m28ZBS8T+WmUA@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1aFcDyJJ5rP1LFkpyUPHkzDv_bcOMPW2m28ZBS8T+WmUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/5/24 00:23, Joanne Koong wrote:
> On Sun, Sep 1, 2024 at 6:37 AM Bernd Schubert <bschubert@ddn.com> wrote:
>>
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>> ---
>>  fs/fuse/dev.c             | 30 ++++++++++++++++++++++++++++++
>>  fs/fuse/dev_uring.c       |  2 ++
>>  fs/fuse/dev_uring_i.h     | 13 +++++++++++++
>>  fs/fuse/fuse_i.h          |  4 ++++
>>  include/uapi/linux/fuse.h | 39 +++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 88 insertions(+)
>>
>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>> index 6489179e7260..06ea4dc5ffe1 100644
>> --- a/fs/fuse/dev.c
>> +++ b/fs/fuse/dev.c
>> @@ -2379,6 +2379,33 @@ static long fuse_dev_ioctl_backing_close(struct file *file, __u32 __user *argp)
>>         return fuse_backing_close(fud->fc, backing_id);
>>  }
>>
>> +#ifdef CONFIG_FUSE_IO_URING
>> +static long fuse_uring_queue_ioc(struct file *file, __u32 __user *argp)
>> +{
>> +       int res = 0;
>> +       struct fuse_dev *fud;
>> +       struct fuse_conn *fc;
>> +       struct fuse_ring_queue_config qcfg;
>> +
>> +       res = copy_from_user(&qcfg, (void *)argp, sizeof(qcfg));
>> +       if (res != 0)
>> +               return -EFAULT;
>> +
>> +       res = _fuse_dev_ioctl_clone(file, qcfg.control_fd);
> 
> I'm confused how this works for > 1 queues. If I'm understanding this
> correctly, if a system has multiple cores and the server would like
> multi-queues, then the server needs to call the ioctl
> FUSE_DEV_IOC_URING_QUEUE_CFG multiple times (each with a different
> qid).
> 
> In this handler, when we get to _fuse_dev_ioctl_clone() ->
> fuse_device_clone(), it allocates and installs a new fud and then sets
> file->private_data to fud, but isn't this underlying file the same for
> all of the queues since they are using the same fd for the ioctl
> calls? It seems like every queue after the 1st would fail with -EINVAL
> from the "if (new->private_data)" check in fuse_device_clone()?

Each queue is using it's own fd - this works exactly the same as
a existing FUSE_DEV_IOC_CLONE - each clone has to open /dev/fuse on its
own. A bit a pity that dup() isn't sufficient. Only difference to 
FUSE_DEV_IOC_CLONE is the additional qid.

> 
> Not sure if I'm missing something or if this intentionally doesn't
> support multi-queue yet. If the latter, then I'm curious how you're
> planning to get the fud for a specific queue given that
> file->private_data and fuse_get_dev() only can support the single
> queue case.


Strictly in the current patch set, the clone is only needed in the 
next patch  
"07/17] fuse: {uring} Add a dev_release exception for fuse-over-io-uring"
Though, since we have the fud anyway and link to the ring-queue, it makes
use of it in 
08/17] fuse: {uring} Handle SQEs - register commands

in fuse_uring_cmd(). 


I hope I understood your question right.


Thanks,
Bernd

