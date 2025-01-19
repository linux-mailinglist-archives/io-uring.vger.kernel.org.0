Return-Path: <io-uring+bounces-6004-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A05E4A1645D
	for <lists+io-uring@lfdr.de>; Sun, 19 Jan 2025 23:48:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3104163D39
	for <lists+io-uring@lfdr.de>; Sun, 19 Jan 2025 22:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE9731DF757;
	Sun, 19 Jan 2025 22:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="OYuyddRs";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cn8sdYHm"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37921DA3D;
	Sun, 19 Jan 2025 22:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737326885; cv=none; b=OUITs/L6wVdI3Ltpvp1p5ScJ6vArgSURGUve4OBnF4e+YVJNxeSRMZrRR0+TplnTdoquL2tS08fwBHkxKQsOIldpQmXHw1XP4WFiHvPw7YKi2Hfrvn1i5TPuivt9ELv2hJpHRKnh4MK0Dsi63YmC/0pW361w5ZDWnicLepHYJFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737326885; c=relaxed/simple;
	bh=44XLgddyGklKb3yVswYOd+knU8casMeibni+ywOjpbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A6+U7rmNfmFabZvZ7IMmw6vIVq8At6tCOQF2H2zGoVe2cjikHdAHiEyRgqKgZ8ALYwDNwtBDi+TeEdxJZViy1ZSu3RCVYXsnqAckUpydYnooW/mOleOeTTRuxaQTEi+e7RUcwh2yM5lMOhPDAIiVIdrVCKc6R7FdBxXfBuS0A/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=OYuyddRs; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cn8sdYHm; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 57F14254012D;
	Sun, 19 Jan 2025 17:48:01 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Sun, 19 Jan 2025 17:48:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1737326881;
	 x=1737413281; bh=NOodp2GsviMLgahSg8J3SxByVXbKJ2CwIxqMmP0C/9Q=; b=
	OYuyddRsmbBE1dbLFatA7C0NmO0ieYTLzc0GFXrdFnq0YezWUgxQZr79nggC/pZ+
	NnsKosVr0P/VrWRvTkcpobrG6Mjh80atYwji60BH/i+fPBbWPSDdcyJBkou7m+Gr
	a2vKYNJBsNkitTNWjsEKx1m2uNQiYBWPMfgxpW+4gc8yHlSUbPowULis3h/ydwo0
	Wa8Ad8cA7ynWYyfqEtWR5AN00bAxZ7Pd3d4KOsHECo7MIGyL4Jn0f+V0IlI1DqxC
	cjABH5sI5VE+irjFq0R4LJEHdzNcfHXtkFHBUhltrFPpVPfbvthOHQYTpivEpoYr
	58PeIrUBLzhZi8ojyvQOIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1737326881; x=
	1737413281; bh=NOodp2GsviMLgahSg8J3SxByVXbKJ2CwIxqMmP0C/9Q=; b=c
	n8sdYHm8rQ9aWBZnaqxvY1JCQCxK6U9O055dhFBz6WdFESi9jVKSTB16Mhz6ifPA
	DUXtg7Ta/Flq5t+B2xypuZpESrUWoZWLLejy1R+mIpN2PT5EAL3DGEIZAmP/vezy
	2ttnhMAOlpE9GJwgVNd/rFE6dl8sg+WK2owwYD72CpsRS8mtIqw4pC4mR1QxnrKf
	Ug6EmJuH8pn3lYX8c0TYIgPa3PIJMAGHGPPQZRJexbVQbefJZqXtg4rb/7ONPlKk
	ihYijBNw3VAO/CwEfatWk+hpmCGVEsQy+5mTmxBNZjQXIrbL93O4HSmP+A5tgO+J
	PxIzdo3mCqiEaFLrf/eFA==
X-ME-Sender: <xms:IIGNZ6ppsWw2o-vJAvunc973Y1EWHDpB1oMGi0PzLqf88VrjKAF_yg>
    <xme:IIGNZ4rVJsnh62go2T20GSmbPxveIINgJy3J_xHqDxl8q15jwuGnpMSppaZ4rI5AD
    7Z2p5R2pIglbrGv>
X-ME-Received: <xmr:IIGNZ_M_-wejw210TGUcaFs9c_LJC9ITHR4Hb_Jtiv5GvOltUvMJXE48Dd4l6R9iJjemna_HWcXhjOBdw4rg1qxCK1xeq7YRANRe3ZTWHby4fiPPbYA7>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudeikedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnh
    gurdgtohhmqeenucggtffrrghtthgvrhhnpeefgeegfeffkeduudelfeehleelhefgffeh
    udejvdfgteevvddtfeeiheeflefgvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgt
    phhtthhopeduuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghsmhhlrdhsih
    hlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepsghstghhuhgsvghrthesuggu
    nhdrtghomhdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpth
    htoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopehlihhnuhigqdhfshgu
    vghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihhoqdhurhhinh
    hgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhorghnnhgvlhhkohho
    nhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepjhhoshgvfhesthhogihitghprghnug
    grrdgtohhmpdhrtghpthhtoheprghmihhrjeefihhlsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:IIGNZ574VRRteX5Km3vhp4WwuIgYHoqMpP_FQV4xgOTo4IHhHpsEjA>
    <xmx:IIGNZ56T5FefJ_CrVy-BDn8Oj2WUxzCQM25uzJUdrbMJjJOl1S1UMw>
    <xmx:IIGNZ5hqgWPyep9X8z4COjtd9KB0udSyeingaJ16Bb6_Wys2zi9piA>
    <xmx:IIGNZz6EnCpOaF6R5TOu8XCFVqnT8vSFEywoVGwnmFELYRhfWZgJDQ>
    <xmx:IYGNZ1hTJ9KxJlvzLaqcVk7z-ey_DuC4WQ2wV8sl9P8NuSId3vjVyPSO>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 19 Jan 2025 17:47:58 -0500 (EST)
Message-ID: <42388479-bf5c-4836-b40f-d3967f5dfd1d@bsbernd.com>
Date: Sun, 19 Jan 2025 23:47:58 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/17] fuse: {io-uring} Handle SQEs - register commands
To: Pavel Begunkov <asml.silence@gmail.com>,
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-6-9c786f9a7a9d@ddn.com>
 <a57cc911-9df2-40a9-9ccd-247388d20462@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <a57cc911-9df2-40a9-9ccd-247388d20462@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/17/25 12:06, Pavel Begunkov wrote:
> On 1/7/25 00:25, Bernd Schubert wrote:
>> This adds basic support for ring SQEs (with opcode=IORING_OP_URING_CMD).
>> For now only FUSE_IO_URING_CMD_REGISTER is handled to register queue
>> entries.
>>
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>> ---
> ...
> 
> Apart from mentioned by others and the comment below lgtm
> 
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> 
>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>> new file mode 100644
>> index
>> 0000000000000000000000000000000000000000..b44ba4033615e01041313c040035b6da6af0ee17
>> --- /dev/null
>> +++ b/fs/fuse/dev_uring.c
>> @@ -0,0 +1,333 @@
> ...> +/* Register header and payload buffer with the kernel and fetch a
> request */
>> +static int fuse_uring_register(struct io_uring_cmd *cmd,
>> +                   unsigned int issue_flags, struct fuse_conn *fc)
>> +{
>> +    const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd-
>> >sqe);
>> +    struct fuse_ring *ring = fc->ring;
>> +    struct fuse_ring_queue *queue;
>> +    struct fuse_ring_ent *ring_ent;
>> +    int err;
>> +    struct iovec iov[FUSE_URING_IOV_SEGS];
>> +    unsigned int qid = READ_ONCE(cmd_req->qid);
>> +
>> +    err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
> 
> Looks like leftovers? Not used, and it's repeated in
> fuse_uring_create_ring_ent().

Yep, thank you fixed. I hope there is nothing like that left
anymore. I run static analyzers today - nothing found.


Thanks,
Bernd

