Return-Path: <io-uring+bounces-11423-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CD89CCFA444
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 19:47:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 03F9234090F0
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 18:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BCD236A015;
	Tue,  6 Jan 2026 17:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="DMDcHKE8";
	dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="dngp0wuD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0309136A016;
	Tue,  6 Jan 2026 17:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.171.160.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722114; cv=none; b=lSuQDNp3K7k46fBEbP8bobZJK6X0O7bKjcWOu4k5IaMeze7VXqLgajn68bLxINUT6dkFY8BEC/FkfuaDM3dy4THDj+onYN7bgvxEAb5VjRmYufk3IlFMBLhpobRBy9KB6iEF2x8XvRXKNjmC738NnZrKR9pUBoRenK8PxhjzcEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722114; c=relaxed/simple;
	bh=/RKmnJVAgf9DEnLf0VDPfSnHGuDA98Ne/+QXtIcqxPg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Zilk+VIuuJ9dXOKVpQfLHkxnUte/aTaMej3y9hqciw5fqdRkfqqofL961DHxGRKY+izXZFfWnmz+6eKSglEU0PVW042gZcxzUBxlHvcnCvygKUHG0eZnLF2+XbShEaVoJQjRfrdTNkEdGFdh82zdZ8CwuXtaulOfv/837f2LveM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp; spf=pass smtp.mailfrom=parknet.co.jp; dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=DMDcHKE8; dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=dngp0wuD; arc=none smtp.client-ip=210.171.160.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=parknet.co.jp
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id C17DB209655A;
	Wed,  7 Jan 2026 02:55:08 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1767722109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XLoEpn8SbUq3M2bDjtG0l+ipy2NNHSDPPhecVpaZDKI=;
	b=DMDcHKE8vaT2nF69Dzn4q+ho0MObOvhdMIutxH4dRXqQs6X87wOOdePiyxIeGejkYbMQW1
	agTnNi+nGCJqANPlGmcyL4Y83s7mCcIe2QfhTiADX2/XrHwMssPp2gWrF/WkEcks48ltAl
	Nd746sbKtao8pfysbRLLut8tmEcN9HEo2Kot7rslLBqgtCaUIT4DaEjqXk4tynEH7tL4Vq
	7eJH9x/Zbr9gBFZ3Cm7BKNg1bMki91oudMaw+DblGX7Qn2GFrNEdkZ8Og0gQNTa8q0yW57
	CPQJzMRQqVls91Pawc8VvRVlwgfL3kYre0P2qPk5KBJWys+tnBTEPovCNZqtnA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1767722109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XLoEpn8SbUq3M2bDjtG0l+ipy2NNHSDPPhecVpaZDKI=;
	b=dngp0wuDXWPBjKoTj+/Ya8vAvMGFu8eZAaXjdaBi/UhOklp9rQ98ohqhfi3hRRmWaQyEzW
	Wl3vPwJbxIX/wfAA==
Received: from devron.myhome.or.jp (foobar@devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (8.18.1/8.18.1/Debian-7) with ESMTPS id 606Ht7F5232027
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Jan 2026 02:55:08 +0900
Received: from devron.myhome.or.jp (foobar@localhost [127.0.0.1])
	by devron.myhome.or.jp (8.18.1/8.18.1/Debian-7) with ESMTPS id 606Ht7Mw551463
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Jan 2026 02:55:07 +0900
Received: (from hirofumi@localhost)
	by devron.myhome.or.jp (8.18.1/8.18.1/Submit) id 606Ht6aI551461;
	Wed, 7 Jan 2026 02:55:06 +0900
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Al Viro
 <viro@zeniv.linux.org.uk>,
        David Sterba <dsterba@suse.com>, Jan Kara
 <jack@suse.cz>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg
 <martin@omnibond.com>,
        Carlos Maiolino <cem@kernel.org>, Stefan Roesch
 <shr@fb.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust
 <trondmy@kernel.org>,
        Anna Schumaker <anna@kernel.org>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        gfs2@lists.linux.dev, io-uring@vger.kernel.org,
        devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH 04/11] fat: cleanup the flags for fat_truncate_time
In-Reply-To: <87cy3nrpdu.fsf@mail.parknet.co.jp>
References: <20260106075008.1610195-1-hch@lst.de>
	<20260106075008.1610195-5-hch@lst.de>
	<87cy3nrpdu.fsf@mail.parknet.co.jp>
Date: Wed, 07 Jan 2026 02:55:06 +0900
Message-ID: <878qeask1x.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> Christoph Hellwig <hch@lst.de> writes:
>
>> Fat only has a single on-disk timestamp covering ctime and mtime.  Add
>> fat-specific flags that indicate which timestamp fat_truncate_time should
>> update to make this more clear.  This allows removing no-op
>> fat_truncate_time calls with the S_CTIME flag and prepares for removing
>> the S_* flags.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> This breaks fat_update_time() by calling fat_truncate_time() with old
> S_* flags (later patch looks like fixing though). Please add the commit
> comment about it, or fix it in this patch.
>
> Thanks.

Ah, I was overlooking that new value is using same value with S_*.
So

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

