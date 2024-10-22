Return-Path: <io-uring+bounces-3898-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E99979AA266
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 14:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DC9C1F23380
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 12:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E21B19D06B;
	Tue, 22 Oct 2024 12:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="RLIkb1XD";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FpnGC/Ht"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9C21E885;
	Tue, 22 Oct 2024 12:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729601172; cv=none; b=UI7UvocKrJnl0X6qVOsMr22n9QXa2FBmR2NkqjkDyCtOoh6CL7g5r/bJ9EuBAhzclRNRfmqIO/bfDs6wwg+lYC6gPem9MXVS1DayqbtnwgoBNrxIdefTgyop8WuqnKI/esdUEJaxvKhoCS55j2O3ad+2YLQuXzrKToVLTmUXtJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729601172; c=relaxed/simple;
	bh=z+pvMjjOUwH7WU5a6AveuVhfgFRMmSeCwyIeDS1Wkhk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ucOwjbG5p94jQcZkEL4Z/cSbDfzDq4lKN3SJNOuD0EHLZYjxoA7t2TNgNObe9EK1SLd8WCd4wnJmoo8jcZK4Nos2kzNYSds1p8B/3nNSzBz13KqS01reGbwb72Qb8YB79eiDSZb3MjDR83ctwp6/XyBY0qvqGGmSL4d0rr4FnBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=RLIkb1XD; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=FpnGC/Ht; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id BD062138038D;
	Tue, 22 Oct 2024 08:46:08 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 22 Oct 2024 08:46:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1729601168;
	 x=1729687568; bh=LidsP518KaG5JxXR99pfsDms8BznKyLR4+RTGS4MVts=; b=
	RLIkb1XDvqYJPbcId6lF+3Bp+fvynPIDZyE5vcERAWCd3yKUJd9cr1jxXTIfGyFv
	YFkjgrFXQQspBFPJUFHfpe2lN4eFMQUmnGVdnffQF4aZwy+o2iVy6NLnlfb8VZ0Y
	/KIToDPGhXd0hNqrSg2zP/oIZKbTizNse6I0cAk4JesLFfrdoZBFkESGB35UtYgv
	p2g9t7hMM740MH7s/SU2TSltJ6RICHwrTaCxV2WVwokxS+2SszhfBo7tR0RDu4pb
	J47BzSScDU8zb5ojbS47PjUg0vfhDQuVwbf11bSL36DxuNI72YtE3QWGDOpp9bNy
	MIGoPr9fgxozaq2ALo2WDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1729601168; x=
	1729687568; bh=LidsP518KaG5JxXR99pfsDms8BznKyLR4+RTGS4MVts=; b=F
	pnGC/HtVghpIdujMRKOJzc62i93Q9voiX4AVAWW+jhaeukGt/9HW9IVV7ervud57
	+K0ZekRFyE/zSjZS+b0iYiYz//1IazIYyXWZVwwa6JtxhupIuZJ61POkYzc1TKcb
	dlq8XaFfR09K5o1FaE62/AVsFTMfoEoES2UcEEMyfvgk396EBAPTB4XmKWqC13xD
	8l68xjjY77NmQgvmecjkh8FbtMLl20lYS+PE/0bc2WnwEZbDIqvDxcREVgxyaCmV
	ozWmfaNTKTDCCxAQ4maL9URLuOiTUTa7rT/vnS3Vfkleob3s02FWJlUVPp/3ArJz
	R7Bj2BhIVEOjZB4g5Brow==
X-ME-Sender: <xms:kJ4XZywfJ4iWcuUrf9qvXt_f5gQPqie4ndlPpLf9pN24Mh8oAl0gIQ>
    <xme:kJ4XZ-TpL0sRPCPgZL0iGvB2m9n1GorN3XNfGrnwSDCjHG21YLertrzuC-cDAYW1Q
    yoXccAaAjoEvlJ3>
X-ME-Received: <xmr:kJ4XZ0XGGV0TlviGlaa6mQTiLL8F7YcTDHc8XAZYFaSohf1teucwyqFw-8JlX4NOsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdeihedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffhvfevfhgjtgfgsehtjeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepieekfedvleetgfff
    vdevfeelvdefffeghfetgeegffduudehieeuteevuedukeejnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopedutddpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtohepugifsegurghvihgufigvihdruhhkpdhrtghpthhtohepmhhi
    khhlohhssehsiigvrhgvughirdhhuhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlh
    drughkpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgtphhtthhope
    grmhhirhejfehilhesghhmrghilhdrtghomhdprhgtphhtthhopehtohhmrdhlvghimhhi
    nhhgsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:kJ4XZ4jVmq5nl8nST9lswOqKLVmzG5UG4SwK4Jd4bpCaDFybnETM2Q>
    <xmx:kJ4XZ0DfaHmTntG1CYnNp0ARf6lk3yQqkREf-LCGlixCnxdBuJTgOg>
    <xmx:kJ4XZ5IqIbpn6PRKMkxjWYUTynflWZf2czUP63rKShjYNtZfgOahMQ>
    <xmx:kJ4XZ7Ddk1lHe3J6DtQUhyELNPdhbrcBSSCZ42sMk9WqWnQN-4V0dA>
    <xmx:kJ4XZ47BxV442EJTJI14y4UtNexdAex6mS_6xPfFfdkG_IQpdo5GeI5I>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Oct 2024 08:46:07 -0400 (EDT)
Message-ID: <a95ec1f4-ca49-495d-9284-eb8828de870a@fastmail.fm>
Date: Tue, 22 Oct 2024 14:46:05 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 00/15] fuse: fuse-over-io-uring
From: Bernd Schubert <bernd.schubert@fastmail.fm>
To: David Wei <dw@davidwei.uk>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <38c76d27-1657-4f8c-9875-43839c8bbe80@davidwei.uk>
 <ed03c267-92c1-4431-85b2-d58fd45807be@fastmail.fm>
 <11032431-e58b-4f75-a8b5-cf978ffbfa50@davidwei.uk>
 <baf09fb5-60a6-4aa9-9a6f-0d94ccce6ba4@fastmail.fm>
Content-Language: en-US
In-Reply-To: <baf09fb5-60a6-4aa9-9a6f-0d94ccce6ba4@fastmail.fm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/22/24 12:24, Bernd Schubert wrote:
> On 10/21/24 22:57, David Wei wrote:
>> If I am already in dest when I do the mount using passthrough_hp and
>> then e.g. ls, it hangs indefinitely even if I kill passthrough_hp.
> 
> I'm going to check in a bit. I hope it is not a recursion issue.
> 

Hmm, I cannot reproduce this

bernd@squeeze1 dest>pwd
/scratch/dest

bernd@squeeze1 dest>/home/bernd/src/libfuse/github//build-debian/example/passthrough_hp -o allow_other --nopassthrough --uring --uring-per-core-queue --uring-fg-depth=1 --uring-bg-depth=1 /scratch/source /scratch/dest

bernd@squeeze1 dest>ll
total 6.4G
drwxr-xr-x 2 fusetests fusetests 4.0K Jul 30 17:59 scratch_mnt
drwxr-xr-x 2 fusetests fusetests 4.0K Jul 30 17:59 test_dir
-rw-r--r-- 1 bernd     bernd      50G Sep 12 14:20 testfile
-rwxr-xr-x 1 bernd     bernd     6.3G Sep 12 14:39 testfile1


Same when running in foreground and doing operations from another console


cqe unique: 4, opcode: GETATTR (3), nodeid: 1, insize: 16, pid: 732
     unique: 4, result=104
cqe unique: 6, opcode: STATFS (17), nodeid: 1, insize: 0, pid: 732
     unique: 6, result=80


In order to check it is not a recursion issue I also switched my VM to
one core - still no issue. What is your setup?
Also, I'm still on 6.10, I want to send out v5 with separated headers
later this week and next week v6 (and maybe without RFC) for 6.12 next
week.


Thanks,
Bernd

