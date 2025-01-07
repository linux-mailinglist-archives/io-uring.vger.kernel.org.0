Return-Path: <io-uring+bounces-5723-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3991A03E98
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 13:08:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DB1C3A3885
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 12:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8221DF725;
	Tue,  7 Jan 2025 12:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="sgvlAhz0";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="L+g/YvLL"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7154C9D;
	Tue,  7 Jan 2025 12:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736251682; cv=none; b=GOaHvy53q9Xs+wlfqPF7bukzt8uO1DXWO9Qqhua7Joev7iWxzMSLR0voFp7LROOpS2YokHZmKl5SMF3QdV6Cnx6NikjlPguSBTULflddkFflpYn8ybSGXUmEek6J/15nfzvwS7zLJdVRBwNmZqL2E9eoPu3z3Bw5x/E5YeFRAqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736251682; c=relaxed/simple;
	bh=op5HImHqYb+4AvhRX02Y74mHm2ek0TjZyK3aMBK+28c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NvhcaAKt/Gm1kaZS9EhmHrwZ3A6IIKapK20KxBNg7opnprDYppWXt0kL0O6lFuo0u6kqwBfCY/jlwoIpTFWQxKqVGOqaOfZz8J9W/+NCxkunv7DksUJk4E6OFbG6hpXuzCXf7BsqtvF8OoCstH08R4RDsLRnKCqnlryHAtOok0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=sgvlAhz0; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=L+g/YvLL; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 972831140149;
	Tue,  7 Jan 2025 07:07:58 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 07 Jan 2025 07:07:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1736251678;
	 x=1736338078; bh=S54aJw5a+El555L0/D6uSM+XLBPUOhMQlUNmqm58VSc=; b=
	sgvlAhz0ppppk1N6S/begQEed5lNnGov0Pbk2ayaMUx7J1ooNtgti7zvIp8pyQxr
	m/3z33Vrh72jQZfFpa8TP96113abqPr3P6k5v/Z6IcRNNoLOlUreq7GzXnJfO3i0
	/oivdFz6ODagfi3Dxmjf8wXV7WV4f/lZ8ayti95G+6pMgkuhDND1fiIuDXGvVgWi
	P7najFFWxfyA4+4N8dcGZ+RL0ZG2f4/FX37eKOV7vhfx8m4hZTZGrD3OpSOse8yX
	E0NIznlft2wHZxayrOKRAFAne4m395gzXn8ou8h9Y28fRx8S3Bp61oajuZpzUOEm
	KIFxvaLNcVSYR3usiNcwxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1736251678; x=
	1736338078; bh=S54aJw5a+El555L0/D6uSM+XLBPUOhMQlUNmqm58VSc=; b=L
	+g/YvLLMJTofZM0SJA700u7+hI/vEWFO6C+Z6/RY9Bdxjgpbk/AEZrbNvUqDNUvD
	OR/aQKl25Fq4CjXjC3CXahlx+q5CQud8J7qlK4d/8C4ixARx7nFfUDNp3QmIiWMo
	3nr+hxBNXU2w+1kBhitNqpL/iEFqua9j3DSPiG3chlyVdY0ITujiQb9kXB1XoFyK
	ITyEn0VGi8oYs4hNfHQtwf/Rl7I5ZTUrt65DxgTZK+ltDXWCjClFwcDU76ZEiS37
	+9FqfUYZU62Z2YSRbDNbwB/X9gEWVHlASdtV+xZD99tnrsfgTCAmay7yatzYa6f6
	iDgqqqkbNJFGOMkFkBn+w==
X-ME-Sender: <xms:HBl9Z9_mNLSFlpyl_RIobqklScn5AiVYeLXXdYQxIHFJsy3VF2S9mA>
    <xme:HBl9ZxvDfMGHejtJq_iI-HyVZmLSfuYLv9hJMujlkz5hGVOq-IP4iExeHrhpSV3AA
    ON3nOrIA9YbajX7>
X-ME-Received: <xmr:HBl9Z7Csrbch6bO3pXCHvwTWugjVWWP4iOy0TjwIrhp_hJHZ-YkRY7c0E3_KhT5bBw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudegvddgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepvefhgfdvledtudfg
    tdfggeelfedvheefieevjeeifeevieetgefggffgueelgfejnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopedufedpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtoheplhhuihhssehighgrlhhirgdrtghomhdprhgtphhtthhopegs
    shgthhhusggvrhhtseguughnrdgtohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrh
    gvughirdhhuhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthht
    oheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinh
    hugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehi
    ohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjohgrnh
    hnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgtphhtthhopehjohhsvghfsehtohig
    ihgtphgrnhgurgdrtghomh
X-ME-Proxy: <xmx:HRl9ZxcTPFV8mLpDHZBoqrjG6YtsCxABewVaYwuYRRvFA0hVA3dRxw>
    <xmx:HRl9ZyOPMgt_THRxnsCsaThE_zPmKxgKuRpVxP6W5vj_hgc_ksWDVQ>
    <xmx:HRl9ZzkASwAyo6sKoMyxUrk4I91tSQP2fB_V_fo2iXkk8K7Gji4g_g>
    <xmx:HRl9Z8vfS5eTPNzLYigNAMyAA_w9qC7AFLMoPY42IyAe3xTXDUkzvQ>
    <xmx:Hhl9Z8t8aujjx_YlwlOKpsUKzS8oJF-GbZvAmI1EPVTMGK81fFioBuYs>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Jan 2025 07:07:55 -0500 (EST)
Message-ID: <215c477e-0cb2-475d-85d3-f15baf7b208a@fastmail.fm>
Date: Tue, 7 Jan 2025 13:07:54 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/17] fuse: {io-uring} Handle SQEs - register commands
To: Luis Henriques <luis@igalia.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-6-9c786f9a7a9d@ddn.com>
 <87zfk32bh6.fsf@igalia.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US
In-Reply-To: <87zfk32bh6.fsf@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/7/25 10:56, Luis Henriques wrote:
> Hi Bernd,
> 
> On Tue, Jan 07 2025, Bernd Schubert wrote:
> 
>> This adds basic support for ring SQEs (with opcode=IORING_OP_URING_CMD).
>> For now only FUSE_IO_URING_CMD_REGISTER is handled to register queue
>> entries.
> 
> Please find below two (minor) comments I had already for v8.  Hopefully
> this time I'll finish reviewing rev v9!


Thank you very much, both fixed in v10 branch, I will wait a bit for
further reviews before sending out v10.
I think the leak of ring_ent in error cases is actually new v9 - I think
I wanted to move up error checking (before the allocation) and then forgot
about that :/ Done now, no need to allocate at all if the IOV is not correct.


Thanks,
Bernd

