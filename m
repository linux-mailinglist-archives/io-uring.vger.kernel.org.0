Return-Path: <io-uring+bounces-11294-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C1377CD82F5
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 06:37:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7C2B03010034
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 05:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E296E2F6188;
	Tue, 23 Dec 2025 05:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m1L+FowU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F332F3C2A
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 05:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468242; cv=none; b=AV+/ySMzhaQ2tevvp1pP/0kHJnmE+ScYd+pEekf+CQzzx3Y5eLezhh+DF+uxeBw68n0F/pGZSSjOkHMn0mk5tk61D1+LIoCFaZA57PQ6bWcGhoAiHeQAR9ETuEws/vD6Cc8y7IWkl/RFa9uadNRR2WA53OAb/YXw764T9wxsz+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468242; c=relaxed/simple;
	bh=PhRs88mwlwkazk+ENj6MoiJDiZn71PTbJFD0EWthhgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SofpC52g4DAykYo4BvSTGGNdAtT0gywyfoUPsXFdmiqvjpwyyy5++RrgmbEcsyg00lwPgH4qT1lx6fBvdlbpo7pMB8vNNXiYriOqtdUjnMltWCcRzy+RV2FMUxLOPuLdnILQXw95/k9wL3ZtuDPu4A2RKQmKz7kWhVg1n38E884=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m1L+FowU; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34c363eb612so4596228a91.0
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 21:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468238; x=1767073038; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A82QF1EkZtulULncIKG5BayS1YlCBJFC1tpTXCRjsWA=;
        b=m1L+FowUPIMlYK4jS0rqd66lJOxSEu9UNgALQ5BaPsZY0mYIff/6weYhiZEE+MrrkM
         9aobe9ahzY2NcVvdmuxqVWtMOkmapJ04qlH+b0btXifJRKnEEtPaUiqLsELDhj6jt70w
         EK7sGlcQ5d76EwzvypNKWSgDYHmPE+8BHcUbIBj4EI4NxbY3KKCwI4ZDp1KQgpy98Bs5
         C6GPDqRf9SXQuuaRHvzF4K3LE21rBYkM/shcj4phJZQDM3tLR9Z+daG+i6MPaX8M21Le
         aEgz9SUcfIi+tbtgXj18ewhgT+GqS2CX4Nhkk1K9SsmOF/RYGt1NhIV1GMZhSPb1cXVy
         zIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468238; x=1767073038;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A82QF1EkZtulULncIKG5BayS1YlCBJFC1tpTXCRjsWA=;
        b=bQmi5blRP6nrCAGswnytAMbJP0GhMtX23vWD0F1iKUPPMrzRTIbNYEY2PNOyGvRZ8o
         ZlJejOsoiZrb/XXM6MTP7u4WJ4jJNmtJ/J4PgyfN5ZC8UkDp9zaC5ok61pIifqpjY22a
         JJ+zmzy7GzEQpe+8a7Qq7cebCODpfz4VPoa+o5/2oh/c39gwYm6IiF935mh0+ReMMcsq
         CY/WK52+1223z3WrJZkZql53N5RsP7nObnlL8EeJQ2mxco/Q+Id0KLls9+s7DkM8vOfG
         jTekQ1LZKXpLoncHUuVg6X3pcNaLMSI7Ny1YbesD34ca+Yfz44v8c1l0sLefF5CqXIIJ
         5A2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXpeHI8KWeEzTkvjg+DftDbtY3hBqgn2yMf4Kc2F0ZVntNGyfqOZ2DYKzwduDSstqxNJsISwuj7fQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf1YZ2gZTauXiOP3cdJHCYY54s9qZMozsnW5lJIcVp6OnZQB9B
	FFDXlnTluhVCHs2cVFOFfydZr5CdSEEX335QZ94ethlDHkWSS75pNDqZ
X-Gm-Gg: AY/fxX4VInB73yCFuTcJOKHfDXptGsfLKGc5zYgva9LtNG8OHkk28mVpcTLJpjfxdkS
	gx/yiMJOVqEyTRCbg3XIlWgPYDJ0cHDfx4L4QMrk41GMDibsfpQvyZebLZpJnJjh5Pmn7hm26RL
	XazvWsNE4zC8iGAurdufsonNOWMRBwb472CJAFaCMssVCXgpXR9lHwf03FtrGmaM5FsYr6k6s5J
	ytVL2RBg/fLD2WiONlsOhIh0cMMy1T+qLsPRVMgAwc33C8wsnAH4/UKBoQ/4WSl1+ORUEIuBiL/
	AjgxsxH6ewJAVcX+SAeYVtqGPn8JQBe2yZNu1odwXdLDpk2mZ+0B8dpj+2WAoCTfjQmRUqPifW/
	mJ/bHW6tWa/7WZIZibyAa7cx8Oa0UYrCJFX6+lVRjg+NnRECZ4Rfcva1LhY1B2PdMSqZWt9wCZ/
	J6qVBRUHNFiE5R/UL61zGkOuoKJlFwBEVBQlgT/p35XA2RZV9aqnAmq8d8hPshQjNAPpcqPHIdg
	7E=
X-Google-Smtp-Source: AGHT+IFuAa1bEi9iXQ/fVsFOwY92P7NTqag0Itb/bLEcgCW/+Bj05+w6CIPRTwzaf559s5BnxudUFg==
X-Received: by 2002:a05:7022:1e01:b0:11a:5ee1:fd8a with SMTP id a92af1059eb24-121722ab372mr13830811c88.13.1766468237569;
        Mon, 22 Dec 2025 21:37:17 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724cfd95sm52514131c88.1.2025.12.22.21.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:37:17 -0800 (PST)
Message-ID: <5789c903-d3f6-4c41-b342-8d29387688e5@gmail.com>
Date: Mon, 22 Dec 2025 21:37:16 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/11] fs: add a ->sync_lazytime method
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
 Martin Brandenburg <martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>,
 Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
 io-uring@vger.kernel.org, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20251223003756.409543-1-hch@lst.de>
 <20251223003756.409543-8-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Allow the file system to explicitly implement lazytime syncing instead
> of pigging back on generic inode dirtying.  This allows to simplify
> the XFS implementation and prepares for non-blocking lazytime timestamp
> updates.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Jeff Layton<jlayton@kernel.org>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


