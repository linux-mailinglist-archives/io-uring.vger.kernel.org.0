Return-Path: <io-uring+bounces-11414-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AF05CF7D95
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:45:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 73CE63016B8C
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A58063BB48;
	Tue,  6 Jan 2026 10:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="dYgljkc1";
	dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="kLXn86oR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1746754723;
	Tue,  6 Jan 2026 10:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.171.160.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767696330; cv=none; b=MIKD2Rg3MidivVguRNtiDQP3f0Iv2tNxtOGWA/L/82BZqj0LS3rLH4QWq21gTDxDxb6iNO09ef5G1rECkHp+8bCrpFxrt/GW1Wa63O5veAf4plegQeh+Nw8/bgI4RKU3pyr281b4CCzQ76AYWyCCeZdQ81t0tL+8KTU+liRpBoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767696330; c=relaxed/simple;
	bh=e4HdWcwFlu3YdvEgJyuNOSr9VyPNMw6Zr7DjoHT9/oI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LJ0zE9OQLPusohlS6jpW7AEJJRvj/em+dKHUvjXXA9aSC4pEkHxXl3uk7jV6bn7ii1Zh33iRn4nEVazRILvf01Tfl9a9JpcXdWgKqtQbF+yWT4SP26di6b1ZHpfs93RzSK5Cekk0okJCe96Locw7UDJiOrLg4FxzkuH2MoYkMN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp; spf=pass smtp.mailfrom=parknet.co.jp; dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=dYgljkc1; dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=kLXn86oR; arc=none smtp.client-ip=210.171.160.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=parknet.co.jp
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id 0C7032051576;
	Tue,  6 Jan 2026 19:45:20 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1767696320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=boNWa8fyq13gGHop3sc94GN25zz7q2/coNrFcXY2ZJQ=;
	b=dYgljkc1OtXsuk2qUUdexyCd53B+4R9nAqpkZqKl4AVM0xaarHGpQ0REZzvW3xKTWjcEXd
	sHU86e+PsD8pKaMJBpT4oL8kPiFBMvXVnCFlq7JYE1aaYRJt+7hjJ2GHQ1QRv0RFCthkDo
	OhAtqSfbx1e4l0Bb/Bx4ukFpnPWaisuIDsozGEdwBcshFYTzFEz1dcv7CR7bg3OJvThusj
	SnBdnw1MdU9tV+4IPjLWT9F1UKAJGxeyDcH7lPWdG6CWEPHyS/F44P5JrvBLdvRcMpI0Xq
	Dax2N0xe1YoNBXNKXfkbHXPipkRyvtJTVWCDxdgt+oYnWG5hgy6g2RfbNkIhPQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1767696320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=boNWa8fyq13gGHop3sc94GN25zz7q2/coNrFcXY2ZJQ=;
	b=kLXn86oRIzqz2zJFiNQmCOYev0Y8ATK/gSFoEiXhC/hJ0sIIocjUl2KiQPbOQ2iM+Wd5a+
	MPAGNZ8NGriPHyDA==
Received: from devron.myhome.or.jp (foobar@devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (8.18.1/8.18.1/Debian-7) with ESMTPS id 606AjI1r213026
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 6 Jan 2026 19:45:19 +0900
Received: from devron.myhome.or.jp (foobar@localhost [127.0.0.1])
	by devron.myhome.or.jp (8.18.1/8.18.1/Debian-7) with ESMTPS id 606AjI93516127
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 6 Jan 2026 19:45:18 +0900
Received: (from hirofumi@localhost)
	by devron.myhome.or.jp (8.18.1/8.18.1/Submit) id 606AjHxO516126;
	Tue, 6 Jan 2026 19:45:17 +0900
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
In-Reply-To: <20260106075008.1610195-5-hch@lst.de>
References: <20260106075008.1610195-1-hch@lst.de>
	<20260106075008.1610195-5-hch@lst.de>
Date: Tue, 06 Jan 2026 19:45:17 +0900
Message-ID: <87cy3nrpdu.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Christoph Hellwig <hch@lst.de> writes:

> Fat only has a single on-disk timestamp covering ctime and mtime.  Add
> fat-specific flags that indicate which timestamp fat_truncate_time should
> update to make this more clear.  This allows removing no-op
> fat_truncate_time calls with the S_CTIME flag and prepares for removing
> the S_* flags.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This breaks fat_update_time() by calling fat_truncate_time() with old
S_* flags (later patch looks like fixing though). Please add the commit
comment about it, or fix it in this patch.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

