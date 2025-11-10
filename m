Return-Path: <io-uring+bounces-10490-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23C83C44F9C
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 06:18:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D99FB3AF341
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 05:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40542D6E70;
	Mon, 10 Nov 2025 05:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ZNaUDK44"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF2B25392C;
	Mon, 10 Nov 2025 05:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762751874; cv=none; b=JwknjudvJqmrdzSw5Nog124CwPqdAAiNrb86O6FA0l+XM8IforK5Jyvy4/7zsKG5kNGSFFnOKPTGVVN1petDPdLto1jnquUVbakxIZ9C3VSu7F7qVJ/CjNfTRmn3I1dD/gGVGkNbRP8pAfjhYZieDpz1roG7bfcAX0ohA7CcSS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762751874; c=relaxed/simple;
	bh=UZC6ujQTkmKdjDUPGiWjl4RG4BekRvtzRodjS5P5V08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=reYmFVfmIX/Ilse6662NZO3KG3SMzmov97UKRmIhW1BtceYUwbgRQ25Z4qAq67S9zKuavxMCA7UFH0O935LBSSlJ1gWxZDZB4PbKugV7hwLevuy2cwbvDdBOjMuM1Tz/KWmu+p8S7j/0igK9W0uv9IIJ2y2M0q3zhPAg+K+zySw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ZNaUDK44; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KaF8UkWTEEH8lJEZzM/8a50CH2U+JlIvKGBzvuU2CRY=; b=ZNaUDK44O0XAtcJEpWeA/N45y0
	m4IxhDbu7dRX+YPpKOZr8saAa98qlJnM+t+OMMnbkqLWTosiDkLuQkShHBr4gERWfhd3rp5Rts6iG
	2AVZywRf4hhnBY6TMMJUFsGOWD78RBdQa+c20Yi4yMal0efCFNCg+4V7A+lloXfmoZo02GG3+ApK2
	4Xxk6YVLC/QqAXpIM6EhdMsEx1KyEuXuvBLqAsc9TVfB83Sp3y2nQ/4fuf26UENtiYPoQsvLu1bSd
	t6yRuiHrYFW8Em9UbV+0WsC0yqGqjd2tBcncxOHsyDgzx24BOQqCVEhJE3O6EsFg0DKPZp0+bhimU
	kZB8cfCg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIKHk-0000000Gn8L-2Qcs;
	Mon, 10 Nov 2025 05:17:48 +0000
Date: Mon, 10 Nov 2025 05:17:48 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz,
	mjguzik@gmail.com, paul@paul-moore.com, axboe@kernel.dk,
	audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
Message-ID: <20251110051748.GJ2441659@ZenIV>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk>
 <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAHk-=wjA=iXRyu1-ABST43vdT60Md9zpQDJ4Kg14V3f_2Bf+BA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjA=iXRyu1-ABST43vdT60Md9zpQDJ4Kg14V3f_2Bf+BA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sun, Nov 09, 2025 at 02:18:04PM -0800, Linus Torvalds wrote:

> Anyway, slightly updated patch that makes "names_cachep" local to
> fs/namei.c just because there is absolutely _no_ reason for anybody
> else to ever use it. Except for that insane legacy one of __getname(),
> that is now just a kmalloc.
> 
> I also made EMBEDDED_NAME_MAX be 128 as per Mateusz' comment, although
> to avoid double allocations it should probably be even bigger. A
> "small" value is good for testing that the new logic works, though.
> 
> I haven't actually dared trying to boot into this, so it's still
> entirely untested. But I've at least looked through that patch a bit
> more and tried to search for other insane patterns, and so far that
> oddity in ntfs3 was the only related thing I've found.

*snort*
That's more about weird callers of getname(), but...

#ifdef CONFIG_SYSFS_SYSCALL
static int fs_index(const char __user * __name)
{
	struct file_system_type * tmp;
	struct filename *name;
	int err, index;

	name = getname(__name);
	err = PTR_ERR(name);
	if (IS_ERR(name))   
		return err;

	err = -EINVAL;
	read_lock(&file_systems_lock);
	for (tmp=file_systems, index=0 ; tmp ; tmp=tmp->next, index++) {
		if (strcmp(tmp->name, name->name) == 0) {
			err = index;
			break;
		}
	}
	read_unlock(&file_systems_lock);
	putname(name);
	return err;
}

in fs/filesystems.c

Yes, really - echo $((`sed -ne "/.\<$1$/=" </proc/filesystems` - 1))
apparently does deserve a syscall.  Multiplexor, as well (other
subfunctions are about as hard to implement in userland)...

IMO things like "xfs" or "ceph" don't look like pathnames - if
anything, we ought to use copy_mount_string() for consistency with
mount(2)...

