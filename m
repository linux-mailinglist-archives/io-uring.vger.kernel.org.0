Return-Path: <io-uring+bounces-6104-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9F2CA1AAD1
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 21:05:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D0A13AB83B
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 20:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC011494DC;
	Thu, 23 Jan 2025 20:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="Xl8HQEZV"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC74132122;
	Thu, 23 Jan 2025 20:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737662740; cv=none; b=LueZiHLc9eSWOOhGXeeF5OswxmBIUhcSBXpj947d/1+l9s4Mt1SMzBt3DUNu4Yzjgfwgep9Rkbmy6JEFICDt48zcCLGCTq632w2qDJWJdNzBw+pMPBCHjoqZYYTfixZ3AyBu7cw2LArx8vcZV7lTzHIKlXVfQYz5RQUv9rugKrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737662740; c=relaxed/simple;
	bh=p26s3vKvC0PnOyjWWB4cziIsfDtxRvkgQWJK+ovfVbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uhp3qPk9COiENcS4As4oY2lHYrDuZ75cHG0tYSLOgT9i/cnqCuW0yRiqkubPNDBK3fxK/ayFrSRA8FuU9qE8np6/+nu9CrsD04wAKyT/lkJ9Jcsc+uadcHhEw9D273lPRrQN/byUPTwBBKQZKx9OTHVavZ7IJtF8dupzBZNSMuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=Xl8HQEZV; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5uUxfDo3v9KMf9WLdwtrD4mVxBJkd6ewHZBgklQR7ac=; b=Xl8HQEZV9561cgHV9FJhNdKKND
	19mtGpyNYwnHouvmcYaxiqJZZRNGboaESMOukEBrT5m+17u/ItNtjn1F2dvcbn1ZSdOYBPgMLXpVI
	vObPNsmGUQiAL6iH7+YBzljtErkmopvk0ngkWxl8Ii9KtLXueJOJGvn6h9p+ydpNUDJdzAbGq1ACo
	WDrwuFIcoTZ+pfmmcwpFMfZ7RUns9kkwB+CvsIrkvbFPCDXMbYM2Wo/AD1bAWVlGFuJCxh4SlSByQ
	YacyGVxikdwgEAm41Q22ytDGRp7GyrKkgCUSgRtl5XENs+Re0Sc5kN6m1D+KNH2tmSx+D6ahhQaiT
	KYw7XUwQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <carnil@debian.org>)
	id 1tb3SH-008lMW-4a; Thu, 23 Jan 2025 20:05:34 +0000
Received: by eldamar.lan (Postfix, from userid 1000)
	id 07A7CBE2EE7; Thu, 23 Jan 2025 21:05:32 +0100 (CET)
Date: Thu, 23 Jan 2025 21:05:32 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: 1093243@bugs.debian.org, Bernhard Schmidt <berni@debian.org>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
Message-ID: <Z5KhDG86fvwzQ3VM@eldamar.lan>
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <a2194f09-aea4-4f07-b23c-a64b3dbdce42@dfn.de>
 <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <Z4_wKuDhmbktlbF-@fliwatuet.svr02.mucip.net>
 <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <Z5FLufDg65O1ZDiA@eldamar.lan>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5FLufDg65O1ZDiA@eldamar.lan>
X-Debian-User: carnil

Hi all,

On Wed, Jan 22, 2025 at 08:49:13PM +0100, Salvatore Bonaccorso wrote:
> Control: forwarded -1 https://jira.mariadb.org/projects/MDEV/issues/MDEV-35886
> Hi,
> 
> On Tue, Jan 21, 2025 at 08:06:18PM +0100, Bernhard Schmidt wrote:
> > Control: affects -1 src:mariadb
> > Control: tags -1 + confirmed
> > Control: severity -1 critical
> > 
> > Seeing this too. We have two standalone systems running the stock
> > bookworm MariaDB and the opensource network management system LibreNMS,
> > which is quite write-heavy. After some time (sometimes a couple of
> > hours, sometimes 1-2 days) all connection slots to the database are
> > full.
> > 
> > When you kill one client process you can connect and issue "show
> > processlist", you see all slots busy with easy update/select queries
> > that have been running for hours. You need to SIGKILL mariadbd to
> > recover.
> > 
> > The last two days our colleagues running a Galera cluster (unsure about
> > the version, inquiring) have been affected by this as well. They found
> > an mariadb bug report about this.
> > 
> > https://jira.mariadb.org/projects/MDEV/issues/MDEV-35886?filter=allopenissues
> > 
> > Since there have been reports about data loss I think it warrants
> > increasing the severity to critical.
> > 
> > I'm not 100% sure about -30 though, we have been downgrading the
> > production system to -28 and upgraded the test system to -30, and both
> > are working fine. The test system has less load though, and I trust the
> > reports here that -30 is still broken.
> 
> I would be interested to know if someone is able to reproduce the
> issue more in under lab conditions, which would enable us to bisect
> the issue.
> 
> As a start I set the above issue as a forward, to have the issues
> linked (and we later on can update it to the linux upstream report).

I suspect this might be introduced by one of the io_uring related
changes between 6.1.119 and 6.1.123. 

But we need to be able to trigger the issue in an environment not in
production, and then bisect those upstream changes. I'm still looping
in already Jens Axboe if this rings some bell.

Jens, for context, we have reports in Debian about MariaDB hangs after
updating from 6.1.119 based kernel to 6.1.123 (and 6.1.144) as
reported in https://bugs.debian.org/1093243

Regards,
Salvatore

