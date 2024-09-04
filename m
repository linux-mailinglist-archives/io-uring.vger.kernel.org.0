Return-Path: <io-uring+bounces-3031-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36FB996C377
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 18:08:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94C75286D25
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 16:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BCA1DC184;
	Wed,  4 Sep 2024 16:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="DWVmQR83";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="iJ97beP1"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh2-smtp.messagingengine.com (fhigh2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48131DB55E;
	Wed,  4 Sep 2024 16:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725466091; cv=none; b=ktIuw8SxmUCoGXR7AOmAJy9JC7Tk+iq8K+Ak2xV8Q9JjQfOtbBhxNSSK+hbKlrRkbbEYJVQhZJZZiU7EJyKJmLFbfo9OJbYmbB9kgLhHLWQVO/Nwrl4o8YJxTTVLhny46T9qA15iio1O4FofWQm8eHhMSeRQR4xCDdwNgDvZMHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725466091; c=relaxed/simple;
	bh=mqU0wF5x4Asb6zGKmK2MBm9ykcSSYEZAfEuMzJa7vmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A+WkI9bDOplEjuTphaDuEwNXutQIn338ybFHH5ES7pQGqWGDfkzLCaYEpWz3WiWOwFHfezxDhSJ+tCbAzCAw1uHQqXJVzXRXB6BlpTIeI49RNeCgvIg6LA+CuT0tug7YX17ynTW/uNCuV1UqorjQBd9f+d6YF6mlpuxidcjyZTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=DWVmQR83; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=iJ97beP1; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-07.internal (phl-compute-07.phl.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E9BB311402C6;
	Wed,  4 Sep 2024 12:08:08 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Wed, 04 Sep 2024 12:08:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1725466088;
	 x=1725552488; bh=n0W37qWyz7MJwPJYHL6XymDwMhVHA7PKKa5tkGUWzrc=; b=
	DWVmQR83zM+D+eICIpxk+85l+cpvS5GgkHd+GNruLBEnEk6VTh2XUsfKVW9k6DLv
	9dsOd/AFc1f+rduhpjCjil3yGxlhRZ49J6CcS3vYWZfEv+6VyUXWqy6QuLc9iSS1
	gd9C03e0sAEg+A6bYyHqzCv1m2rsCkRhYj93dJBvmtdOnIUmOef9AUTzkrsjbGmr
	dwq2ql7RuaKJkcz0L8Zm2dlphNpQIOFH0LsvSWZ7P1EhQUdePnQxACMIWjugmmOc
	wPTUHbj1Y7CmcCeVFgf9jeWFjouTy3HY8MqSNEdonoMZoonL63yzrR5Qhvc971k8
	tVPOwA2gNnMuET5exAJCrA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725466088; x=
	1725552488; bh=n0W37qWyz7MJwPJYHL6XymDwMhVHA7PKKa5tkGUWzrc=; b=i
	J97beP1Fh/wC+JezgCQpiV1DFGriXcUZEVGcvJU2kJ0U2D7IwsnFPrCt3GvSEWI4
	zfWylgcu4+U/RR2XqNMJTVUuDIxssYtbPAhfznTOwtWw+I/JPKCwoKY/MrNQi0No
	8AwNeirt98RaOtn/Q6+Ed+xumoBR7pi8Vf7UHCBJr8E3iR2hXf2qTKSQwDQdGaT2
	oJlZRkHQN7eW0YXI/cg04HupTda8DRrtSg+tj0rvy7Gbhc7/nphcvDbUTdHGgQ0/
	GQTFuKjt5Kp4vymP9RFY6aEuMlsyl7vpf1mSFH9P+fHu0C7PYsjKYVRB0mnKyox9
	W1uNto9OubTukhFPBKfPA==
X-ME-Sender: <xms:6IXYZrFsF6EP0gTyBqEJUfUfWAYAZfixMQySvLsuneyhb223S9q1iA>
    <xme:6IXYZoVpwpvFiVE5_9Y2le8om1k26x5yTtJ5PcsjSp-3j0QE2pGePBcmy1jnM0ZiS
    KRcxtcbiadMMjED>
X-ME-Received: <xmr:6IXYZtLDkJD8aMsQvyVdoWdu6LDTxnS_8Mc9g-ifeWp61xhQ8jLi9Cih3RJJ8_vWnC1RVC0hdjAi4LkchcoxvPGuU2Olg8bL6XZnXBd0HrlQKirxphxn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudehjedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepvefhgfdvledtudfg
    tdfggeelfedvheefieevjeeifeevieetgefggffgueelgfejnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopedutddpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopegs
    shgthhhusggvrhhtseguughnrdgtohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrh
    gvughirdhhuhdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtgho
    mhdprhgtphhtthhopegsvghrnhgusehfrghsthhmrghilhdrfhhmpdhrtghpthhtoheplh
    hinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjoh
    grnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgtphhtthhopehjohhsvghfseht
    ohigihgtphgrnhgurgdrtghomh
X-ME-Proxy: <xmx:6IXYZpF4DYR_R5G28uqokhSr-9fe_qGm1zpNwBCk_im2_ZnOyFY-ng>
    <xmx:6IXYZhVg_nPQrBVjeVpATBzAsnjlxSCF7hVofu9T-DbSFIGHMC6iYA>
    <xmx:6IXYZkNj5DdgoF_14EV4bgAwOraJkiFhaJ7L-h8fqqW63MnmpL5v7g>
    <xmx:6IXYZg0HzgtDXeWBwHb0dnf3wlj5zU2BWEP6l_5DqOcAS0McMjFebA>
    <xmx:6IXYZqMhQWpdoqnTGOsMJb_ip7DyZeTxz2ZbudHF10Lp23oCLWkimgiy>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Sep 2024 12:08:07 -0400 (EDT)
Message-ID: <6c336a8f-4a91-4236-9431-9d0123b38796@fastmail.fm>
Date: Wed, 4 Sep 2024 18:08:06 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 17/17] fuse: {uring} Pin the user buffer
To: Jens Axboe <axboe@kernel.dk>, Bernd Schubert <bschubert@ddn.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Pavel Begunkov <asml.silence@gmail.com>,
 bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
 <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-17-9207f7391444@ddn.com>
 <9a0e31ff-06ad-4065-8218-84b9206fc8a5@kernel.dk>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <9a0e31ff-06ad-4065-8218-84b9206fc8a5@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jens,

thanks for your help.

On 9/4/24 17:47, Jens Axboe wrote:
> On 9/1/24 7:37 AM, Bernd Schubert wrote:
>> This is to allow copying into the buffer from the application
>> without the need to copy in ring context (and with that,
>> the need that the ring task is active in kernel space).
>>
>> Also absolutely needed for now to avoid this teardown issue
> 
> I'm fine using these helpers, but they are absolutely not needed to
> avoid that teardown issue - well they may help because it's already
> mapped, but it's really the fault of your handler from attempting to map
> in user pages from when it's teardown/fallback task_work. If invoked and
> the ring is dying or not in the right task (as per the patch from
> Pavel), then just cleanup and return -ECANCELED.

As I had posted on Friday/Saturday, it didn't work. I had added a 
debug pr_info into Pavels patch, somehow it didn't trigger on PF_EXITING 
and I didn't further debug it yet as I was working on the pin anyway.
And since Monday occupied with other work...

For this series it is needed to avoid kernel crashes. If we can can fix 
patch 15 and 16, the better. Although we will still later on need it as
optimization.



> 
>> +/*
>> + * Copy from memmap.c, should be exported
>> + */
>> +static void io_pages_free(struct page ***pages, int npages)
>> +{
>> +	struct page **page_array = *pages;
>> +
>> +	if (!page_array)
>> +		return;
>> +
>> +	unpin_user_pages(page_array, npages);
>> +	kvfree(page_array);
>> +	*pages = NULL;
>> +}
> 
> I noticed this and the mapping helper being copied before seeing the
> comments - just export them from memmap.c and use those rather than
> copying in the code. Add that as a prep patch.

No issue to do that either. The hard part is then to get it through
different branches. I had removed the big optimization of 
__wake_up_on_current_cpu in this series, because it needs another
export.


> 
>> @@ -417,6 +437,7 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
>>  		goto seterr;
>>  	}
>>  
>> +	/* FIXME copied from dev.c, check what 512 means  */
>>  	if (oh->error <= -512 || oh->error > 0) {
>>  		err = -EINVAL;
>>  		goto seterr;
> 
> -512 is -ERESTARTSYS
> 

Ah thank you! I'm going to add separate patch for dev.c, as I wrote, this was
just a copy-and-paste.

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 592d0d96a106..779b23fa01c2 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2028,7 +2028,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
        }
 
        err = -EINVAL;
-       if (oh.error <= -512 || oh.error > 0)
+       if (oh.error <= -ERESTARTSYS || oh.error > 0)
                goto copy_finish;
 
        spin_lock(&fpq->lock);


Thanks,
Bernd

