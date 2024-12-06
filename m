Return-Path: <io-uring+bounces-5267-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B3A59E6D77
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 12:36:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 916781884595
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 11:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69B441FC11F;
	Fri,  6 Dec 2024 11:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="DQsGfhK0";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="enWew1AT"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E05217E4;
	Fri,  6 Dec 2024 11:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733484986; cv=none; b=EIDDfgx59a0Nri+CZahCEI1NiJImsEzRc/Y1cHLKCAk2PdRErRZJbHKEkGD0UUwNw1kz+/vlClkbYxR7Zy1Q7LgvU23wF9oZl58WO/GTUhuUOieC0bwRoxvqcxQkjAvlAmqe8kIQ38x02BN/MoGIWW2WFyRMq3dV61zogNh5XXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733484986; c=relaxed/simple;
	bh=NGfrCPaC9Jl2RnXNtgjXIHb4CtjJRorjKlYtUg+8SsU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R1pr2+dhjvh0eDm7m4hvzRac4l2R3d2Fr+Evu8PV5wvvDqRui/BCFDPcfHBvV/mItcZWkKQQuUmI8vHnXDKsGdwhgxCXdi8yw85YYPxrcVG++bOt+9kGwCth29pUlN3TA1DXjFwfZSjOYExmsS6WPwMSkYGsMGOJ9ZjaLx7xGPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=DQsGfhK0; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=enWew1AT; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 60F6411400CA;
	Fri,  6 Dec 2024 06:36:22 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 06 Dec 2024 06:36:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1733484982;
	 x=1733571382; bh=KHGl+PMlY7Mdi8VDO8QB3BgfcXM9VYqd5RWD4B9OyYA=; b=
	DQsGfhK0LRBRlygLI/uwhoTi9BbNQ10d7l+rNH6Y3rfxbIhGvPHjyVLEn7an/Dvl
	xqpKCTLwRucu+IuEO4Rdt8jAsNXjScCVRgP7pGpfdbPHXjbLSUApG9atq4X/mXwA
	CBiehubr7LRrCUX9rtj2uwYqht+l5iSJo3uSysM4fnWWtM7E25IWEkf/lVrV0Sno
	x3LS3Ha+d6HEb6NSsXGHIY1lGz7qp38lwAZQbEkcisN/NNkn5b3nd9E5kMEzjdaj
	6HAXX4DS9o0pe0Nx8Zrcuzi8nGpxhk5VvFtNTBRH8oUAfHtD4c26r+ZtAnwkfpCv
	zTIqVdipQ3gK5zW1VcqYAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733484982; x=
	1733571382; bh=KHGl+PMlY7Mdi8VDO8QB3BgfcXM9VYqd5RWD4B9OyYA=; b=e
	nWew1ATB6qLDCEvgf528+iQPD7JVHxsYmV/ejIqj7LmqXCyeOmHxfcLN5UEixrJH
	JNwmOO/WWI1mQ5K32Z/zQRentHDRFAyndhxfvpn37kqCuECVpohHVvZfwj/nuT7K
	UZN9vWkk41jrwdjOj7NFrWTWGbrZyruchTJKVeSjH4GmDD+t2qNFGWVCIEERgtme
	nmFOxQhon2FmvOmU0ob+edXPjzCtXty47c3mDYtlFig8OFBH1SIQn4OC6mSVPCAt
	DR6A8qgT0klDMZP22qSLiFtwCQF6rOhCqHO8jOaJEB1SjsMS5OKIZ1AagPHcR2Ik
	Ox9xcX7Q7RsHyyR6Go1Uw==
X-ME-Sender: <xms:teFSZ4fftWHGVGzJKeny7wKNhdPv1xk7AwrmQ5xCWpRELnooeObqMA>
    <xme:teFSZ6OSrWsmo1bmn5i5dRHZsAav5Q4M77J9iKxq_tHcZR99FQWMp0BBXKArr_9Jp
    fzHfSShaXdzQqYF>
X-ME-Received: <xmr:teFSZ5g5Skr0kyEiIjpV9OtueSHCeXy8ORE1EnIs3J3hPVW_gJ7kSi93vp2oMtmfleB7cRJkVeTOBSTx4qXobO8_Z2a_YukQRLrZ9CYDqt-yjjRYSyZx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieelgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeen
    ucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusggvrh
    htsehfrghsthhmrghilhdrfhhmqeenucggtffrrghtthgvrhhnpeevhffgvdeltddugfdt
    gfegleefvdehfeeiveejieefveeiteeggffggfeulefgjeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgurdhstghhuhgsvghrthes
    fhgrshhtmhgrihhlrdhfmhdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpoh
    huthdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgt
    phhtthhopegsshgthhhusggvrhhtseguughnrdgtohhmpdhrtghpthhtohepmhhikhhloh
    hssehsiigvrhgvughirdhhuhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrughk
    pdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgtphhtth
    hopehjohhsvghfsehtohigihgtphgrnhgurgdrtghomhdprhgtphhtthhopegrmhhirhej
    fehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:teFSZ9-BXH5OL4T_fAfXcJbCVHqsekCRdxJOZrzfR_N6DooK3IUzXg>
    <xmx:teFSZ0tq6UHmaWDIJ5ZdwA8hBtq0p_vfgpdczJCh_tsVHp9WqUYC_w>
    <xmx:teFSZ0FA7E3I3TuMPQ94zroggknOZQ1MqWKKp8GbhbLzPuBSeXDNEA>
    <xmx:teFSZzNT23vDhfR1toyGkvGHQxuiJIl4jJ0hETVAAvFV0YacLAd9OA>
    <xmx:tuFSZ1GGHqPg31D2VQpZaNe1ff8ODUrPyQqwPOzreQmaT3n2IVZ79cDc>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Dec 2024 06:36:19 -0500 (EST)
Message-ID: <eadccc5d-79f8-4c26-a60c-2b5bf9061734@fastmail.fm>
Date: Fri, 6 Dec 2024 12:36:18 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 00/16] fuse: fuse-over-io-uring
To: Pavel Begunkov <asml.silence@gmail.com>,
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <57546d3d-1f62-4776-ba0c-f6a8271ee612@gmail.com>
 <a7b291db-90eb-4b16-a1a4-3bf31d251174@fastmail.fm>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <a7b291db-90eb-4b16-a1a4-3bf31d251174@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/3/24 15:32, Bernd Schubert wrote:
> 
> 
> On 12/3/24 15:24, Pavel Begunkov wrote:
>> On 11/27/24 13:40, Bernd Schubert wrote:
>>> [I removed RFC status as the design should be in place now
>>> and as xfstests pass. I still reviewing patches myself, though
>>> and also repeatings tests with different queue sizes.]
>>
>> I left a few comments, but it looks sane. At least on the io_uring
>> side nothing weird caught my eye. Cancellations might be a bit
>> worrisome as usual, so would be nice to give it a good run with
>> sanitizers.
> 
> Thanks a lot for your reviews, new series is in preparation, will 
> send it out tomorrow to give a test run over night. I'm 
> running xfstests on a kernel that has lockdep and ASAN enabled, which
> is why it takes around 15 hours (with/without FOPEN_DIRECT_IO).

I found a few issues myself and somehow xfstests take more 
than twice as long right with 6.13 *and a slightly different kernel 
config. Still waiting for test completion.


I have a question actually regarding patch 15 that handles
IO_URING_F_CANCEL. I think there there is a race in v7 and before,
as the fuse entry state FRRS_WAIT might not have been reached _yet_ 
and then io_uring_cmd_done() would not be called.
Can I do it like this in fuse_uring_cancel()


if (need_cmd_done) {
	io_uring_cmd_done(cmd, -ENOTCONN, 0, issue_flags);
} else {
	/*
	 * We don't check for the actual state, but let io-uring
	 * layer handle if re-sending the IO_URING_F_CANCEL SQE is still
	 * needed.
	 */
	ret = -EAGAIN;
}

I.e. lets assume umount races with IO_URING_F_CANCEL (for example umount
triggers a daemon crash). The umount process/task could now already do
or start to do io_uring_cmd_done and just around the same time and
IO_URING_F_CANCEL comes in.

My question is if io-uring knows that re-sending the
IO_URING_F_CANCEL is still needed or will it avoid re-sending if
io_uring_cmd_done() was already done?
I could also add state checking in the fuse_uring_cancel function.


Thanks,
Bernd





