Return-Path: <io-uring+bounces-3385-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 146E798E29C
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 20:35:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC8801F2343C
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 18:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F501D1F44;
	Wed,  2 Oct 2024 18:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QYrxUfhY"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6639A1CF2BA;
	Wed,  2 Oct 2024 18:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727894097; cv=none; b=VXSwEmoArP0GLBHYT6pp7kNGVWZvS3xzdJUa8Lt7VaItIACfBv/j4Jjdg8+cXUNiRSmSSzgcj4DPy1CQvPmqI98LFX1z2am2XSeBiZTwOM/Oi/HhskeZND4d0rU2cIUL251y7Tj6CxbPbSs7n/0qFJuxEpPoUgwCPbND2f/bB5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727894097; c=relaxed/simple;
	bh=kzNe6QUlP1JNy84U5yCP///ViUFTozy1TPgdR21dakY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vg5FkIujZl/LqZFwaFSTVYROJtPEbyHvmTtEuOoRS8yaGkcoTuDGh+L5gV0RrBK7hfg/Ai4M4/GZvZ22RW5SZM1gUhjTx/2Oc09Nv+ZV0MK5Ejtd8KCkOAdWBDhXS8ISWuI8V1oMhck9DnAr+MGxzSTRb/pmgdU8XiiT/enhlMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QYrxUfhY; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJk4b4gdPzlgMWF;
	Wed,  2 Oct 2024 18:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727894090; x=1730486091; bh=kzNe6QUlP1JNy84U5yCP///V
	iUFTozy1TPgdR21dakY=; b=QYrxUfhY2HEnpYiOXgZjyQOj6ij3lmiTPe0EzcWX
	VHNwFsKQ3sLoGdt1vHmVxXRgU+HDUTu5F0MKIaRDFZAgHJRd2F6BvEsvlx1tJ/7e
	rJ0ZF7lcLizXrflaN86AGaGu0ce/JAem0ecIJAgKhxHnrF2IOL1LjeZ0mjDDuWAd
	/JkcmFkcwYqlZNQ3spPeQF1K0n0djZ0eytsPkBS8XHaPoj52NFnmfK1pyABJtG9X
	nqlyKGdHu1TPjN5/nZi4uvXPJ0L0bqwKGL1CPAXx0q/g7sgEVuX4Ekd4X3S2fLHy
	SoCpFqNMeNpgEIPQ1QMw9IKyfVMfgrY6sjwJpCwU6cpSWw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gXBClRYEWh5K; Wed,  2 Oct 2024 18:34:50 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJk4S0XGjzlgMW9;
	Wed,  2 Oct 2024 18:34:47 +0000 (UTC)
Message-ID: <a8b6c57f-88fa-4af0-8a1a-d6a2f2ca8493@acm.org>
Date: Wed, 2 Oct 2024 11:34:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Kanchan Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
 brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
 asml.silence@gmail.com, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, linux-aio@kvack.org, gost.dev@samsung.com,
 vishak.g@samsung.com, javier.gonz@samsung.com
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>
 <20240930181305.17286-1-joshi.k@samsung.com> <20241001092047.GA23730@lst.de>
 <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk>
 <20241002075140.GB20819@lst.de>
 <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
 <20241002151344.GA20364@lst.de>
 <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
 <20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/2/24 8:47 AM, Martin K. Petersen wrote:
> What irks me is defining application interfaces which fundamentally tell
> the kernel that "these blocks are part of the same file".

Isn't FDP about communicating much more than only this information to
the block device, e.g. information about reclaim units? Although I'm
personally not interested in FDP, my colleagues were involved in the
standardization of FDP.

Thanks,

Bart.

