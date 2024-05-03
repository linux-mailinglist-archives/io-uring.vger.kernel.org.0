Return-Path: <io-uring+bounces-1730-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45F738BB65D
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:48:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF98A280CBE
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 21:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9BCF59161;
	Fri,  3 May 2024 21:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="LBITSpJY"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15B958AC4;
	Fri,  3 May 2024 21:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714772742; cv=none; b=Wes5WWDUT25GfLUX5I9hkAeipwq9C0nZBf4Z2886fo+s2T6InXmjXKwU5z7QV85SPZpBa9ofAp1g+gj7HYXyPiAsK+oZpR97btQxuIDiZ0r9HolAF/cOyYABdodKPGTCz7yXdFWF9C8evE3dq6wPKuqTqxzr/jB1Hj+AB05XA+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714772742; c=relaxed/simple;
	bh=lOYEhpsDzSYPAdQ3BrBv0vEy/GPofPZX+8B5tDMr4Qo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PsaOIklf60V4xlXoSOn3/3itSDzse/Mc2dps0S0BPukCzQ9KxLffEguyl34LRb3MTsEBN26t8S62H+pjnapS4hwBGHVE7tDmbFIlPXxD6pEfiuJeGrauS2vm7uS0lFCIlPaHT9lBn9VTftrhu+PjOtk1Sq/q7cc72Mex3BnWQgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=LBITSpJY; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3lCoy8uzoX7QQd8eqESv9U82+gq2FTw7cMvL87kLhkY=; b=LBITSpJYboAcmP2sLMLog8nydW
	mt/eEb1k1RxaC/1rf9axcfr3DpdDFVZWBzSM5oiyiRFUxSmSTNk7S/pL3r/LyK0sUx0B7ulVQ3JNQ
	r6F9ALR0ltwB+yhzi14FlChXAh3y8p88L3KhQBzlGvQE9Qyjmf9GyQKp0ImLKiTti9oHi8k3hRvo3
	wVh2ps6XnwBsfVzZeN71mN1klcTNC+Iw2ovocjktngU/aRLmD9i2C0kfkNl/XDxg43VHY7LcXvmHW
	cP5n8cc1rlrFA4QbwGKtuB0RilMr6TQXDJT8CFkSL/wplslwGYSr1h0+/PUFgSGJlDgXOv0RWp+HJ
	KdWj72Tw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1s30ih-00B9OV-2B;
	Fri, 03 May 2024 21:45:31 +0000
Date: Fri, 3 May 2024 22:45:31 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: keescook@chromium.org, axboe@kernel.dk, brauner@kernel.org,
	christian.koenig@amd.com, dri-devel@lists.freedesktop.org,
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name,
	linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	minhquangbui99@gmail.com, sumit.semwal@linaro.org,
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <20240503214531.GB2118490@ZenIV>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Fri, May 03, 2024 at 02:33:37PM -0700, Linus Torvalds wrote:

> Look at the hack in __ep_remove(): if it is concurrent with
> eventpoll_release_file(), it will hit this code
> 
>         spin_lock(&file->f_lock);
>         if (epi->dying && !force) {
>                 spin_unlock(&file->f_lock);
>                 return false;
>         }
> 
> and not free the epi.

What does that have to do with ep_item_poll()?

eventpoll_release_file() itself calls __ep_remove().  Have that
happen while ep_item_poll() is running in another thread and
you've got a problem.

AFAICS, exclusion is on ep->mtx.  Callers of ep_item_poll() are
* __ep_eventpoll_poll() - grabs ->mtx
* ep_insert() - called under ->mtx
* ep_modify() - calls are under ->mtx
* ep_send_events() - grabs ->mtx

and eventpoll_release_file() grabs ->mtx around __ep_remove().

How do you get through eventpoll_release_file() while someone
has entered ep_item_poll()?

