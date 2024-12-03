Return-Path: <io-uring+bounces-5193-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43AE69E27B7
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 17:39:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3546DB665E1
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 14:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C02231EF087;
	Tue,  3 Dec 2024 14:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="O4N+koOL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bKz3Rzqk"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5CE1F12FC;
	Tue,  3 Dec 2024 14:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236352; cv=none; b=tYAxZWndVYzFff2GkUWxSuJiFJBZlUSgLj+I3mFAq32i4qYT3F7OB0G66r2Kyfr4G4rxXOOmGMfKOrCeCcBnkdqpYQElpOdx6kkuY2jUomR47rByMvbES4sJgpDgSMzhrq4fCZzlfLNz4iaooX7Q0a1/qHT5rlWXMyiaW0nq4qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236352; c=relaxed/simple;
	bh=qjcjegiCrCJyE0TckIR4VqwsXl2CzR6BLkr1q9tzGRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XaBdYpKDCZ2jZD/hzzQAAleuVMDymNpKUPjtI1CXhJ9g0rWxPHtbSfkLHZGKWIBAe61Bj+jXfd+ZUHQzCUcLA+2fdcxfZuS+EAhglUGfkHAA9zxU7dbOCsrL/LuURVzyTLtjmlUOTB5hRpAzEYmYs3RrpM/oWfRJQlztKzm7tZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=O4N+koOL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bKz3Rzqk; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 6E1CE1140114;
	Tue,  3 Dec 2024 09:32:29 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 03 Dec 2024 09:32:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1733236349;
	 x=1733322749; bh=Y4CnRTDogXXvhGarRROw/9wryFul2e5EkKqSMWzM6iQ=; b=
	O4N+koOLDfSO/xFHsPfr01VMYxUrZdFsNLbatQHAWJdINpSO8wy/i6hZ537XH3Iq
	EiWOL7+xPZUdiU1gNTc+4QpA2KIC09MC8DRYzRyvLXEI7Ch0ZXD68kwwWm38mubB
	U6RU9jAv77N4eFoX4UFS1saJcHQF4zB3fMl9NjxnzSrRIfqr9tfleiMi6hkivwoo
	6lWTHntPVKIYpOiHw584srKsEPwqMo1kusScohVYikVg5jkELGvgpXLJzWBD47wI
	f0Cj1JRc81jlHJkaN6BkO+WVxi5lsFAOwRa+HuenSogNab9N3hlTQJyahaMfgeGn
	zn/Rgx7ZC2Jzz5fNaACwQA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733236349; x=
	1733322749; bh=Y4CnRTDogXXvhGarRROw/9wryFul2e5EkKqSMWzM6iQ=; b=b
	Kz3RzqkQFfWFVkAPaYbiFP0jl93Ev/bY+AEkV/dtfCc1NKHBvfwu/HUvjaxV5jLO
	f0gLZ0M9BK2KpOcVJvd7oUus/ApjvaVhDobMzIukXJxGsZKAMTQfm3jatyXfW+iw
	lA/57U4n7hUvUobSpy9tv+hod4tH3C2mjMNMMYs0DGN5sDlZOGOEoUR85CgXxzzC
	XvJAm7bgPRZqBPZwJljDMvbrCIRturnamnHRkLxNH6/3UTI3Ox3cxZ2GFn/yTiVn
	oawE4S0DUtB3M73kjN5Xw9z+gxkl+cmcJox+EX+rIUJjcDqUtIkbBtAMynYJKHbm
	/RPviEKasWI6ERIRWZrSw==
X-ME-Sender: <xms:fBZPZ3Dc7oW5bLaFjyrXo7YxToEKKCjoA2KfiWqwnhkO9JqEOzvKoQ>
    <xme:fBZPZ9iX9j9jPtQ_eMD1_Hwfohg0a61cBRGze13AZffO9tQ6rTiPKO6m_Tf4s19Rb
    UgIfOiZWUnSbfWE>
X-ME-Received: <xmr:fBZPZykP6wouguJV4Rd4G_eue3pAMb6a1iHsnIWr08dbiowceL8CZLOMVq9aqB-mtT_vznmn1r_a-qz3qMXBtXJUKSGh814ycEGxGvmV7jkbjnE6DqWV>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieefgdefjecutefuodetggdotefrodftvf
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
X-ME-Proxy: <xmx:fBZPZ5y2Y6LOzbb6S0-60G7TCMZFoU55MZaGh1fh53BZDK4ErYug4g>
    <xmx:fBZPZ8SsmJbPHv_VYBsTizANQf4ykYIfLs5SL4jwMZXoF_FHOZSUJA>
    <xmx:fBZPZ8ZD0Af_8f2jEfr1N3wBTVEXP2RAwQH-8mYKRvhJi3sVmwbKbA>
    <xmx:fBZPZ9RQthETPLdGKImnBugMtV9MJ_Y3PjKaWc97F_4zgAgyBHv9wQ>
    <xmx:fRZPZzIuqLI7n4y2v0C6o4WaSTSD1aNf4oJA9kwdCvmfllRo-UE1KfT9>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Dec 2024 09:32:26 -0500 (EST)
Message-ID: <a7b291db-90eb-4b16-a1a4-3bf31d251174@fastmail.fm>
Date: Tue, 3 Dec 2024 15:32:25 +0100
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
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <57546d3d-1f62-4776-ba0c-f6a8271ee612@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/3/24 15:24, Pavel Begunkov wrote:
> On 11/27/24 13:40, Bernd Schubert wrote:
>> [I removed RFC status as the design should be in place now
>> and as xfstests pass. I still reviewing patches myself, though
>> and also repeatings tests with different queue sizes.]
> 
> I left a few comments, but it looks sane. At least on the io_uring
> side nothing weird caught my eye. Cancellations might be a bit
> worrisome as usual, so would be nice to give it a good run with
> sanitizers.

Thanks a lot for your reviews, new series is in preparation, will 
send it out tomorrow to give a test run over night. I'm 
running xfstests on a kernel that has lockdep and ASAN enabled, which
is why it takes around 15 hours (with/without FOPEN_DIRECT_IO).

And definitely, cancellation/teardown is the part that I spent most
time on.


Thanks,
Bernd

