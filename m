Return-Path: <io-uring+bounces-842-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9FA4873B63
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 16:59:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7AE44B26047
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 15:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2989C60912;
	Wed,  6 Mar 2024 15:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UqvZCObD"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36587130ADD
	for <io-uring@vger.kernel.org>; Wed,  6 Mar 2024 15:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709740774; cv=none; b=oIWed7rNeWjXM0DYvPTJKOtcLBrqmEtFxV8VIXge+kkEu2qLx1CE5/i9qpkeYD71e+KFrP81JkhoFVeNZbp77rAmZSiiDPn8SNXFKwawVb5B0ezzFYk3ly0wTUGxxdauNy1AgPS8UMqNyvNReLKdMMv3A1mAIdTLeZPv/rLV/gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709740774; c=relaxed/simple;
	bh=MmNU8B5WZ1uxg9hzl7F9DTcdKIes0O/zojf1g0ttm/A=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=Y/Hojmr7XrUifIWc7BAl6K2jKqHfGKutvgfikA4OFJIKZq9l8UODL2+EjnUhCnXAsKPqTdEo1a00BQAOcu4V90a9hrKl8P+rvT8jvhQhnslYl4NunM09GzYYPMBG/Nb2Fj1D5eFsFHttzjEU31Gzdd7u6OluFL6Vl8OT52ntZV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UqvZCObD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709740770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bH0P49jS3FWbQfHXDiYtOjvFX14vKajotnvHNPLkcuQ=;
	b=UqvZCObDkrhwhFKstiTnR4W+zmW3qjzEDeA+0bDkGYKppPGWMTu9RpkKY+lrUOvD70cFeL
	ExVilbixKhpTw5f2aUWjuVEP3L0I6vyzMdWQTlTs9PEAuCOCw9BuT1tjHEDUcF9LrdOYf6
	+ly4s3TcgPb39Fcc9lIRT2Qsw3iZ6xI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-BU_t23jiPlCKz1XRGR5__w-1; Wed,
 06 Mar 2024 10:59:27 -0500
X-MC-Unique: BU_t23jiPlCKz1XRGR5__w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 931653C025B6;
	Wed,  6 Mar 2024 15:59:26 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.10.44])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 568951C060D6;
	Wed,  6 Mar 2024 15:59:26 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>,  fstests@vger.kernel.org,
  io-uring@vger.kernel.org
Subject: Re: [PATCH 3/3] common/rc: force enable io_uring in _require_io_uring
References: <20240306091935.4090399-1-zlang@kernel.org>
	<20240306091935.4090399-4-zlang@kernel.org>
	<20240306154324.GZ6188@frogsfrogsfrogs>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 06 Mar 2024 10:59:25 -0500
In-Reply-To: <20240306154324.GZ6188@frogsfrogsfrogs> (Darrick J. Wong's
	message of "Wed, 6 Mar 2024 07:43:24 -0800")
Message-ID: <x495xxzuzaa.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

"Darrick J. Wong" <djwong@kernel.org> writes:

> On Wed, Mar 06, 2024 at 05:19:35PM +0800, Zorro Lang wrote:
>> If kernel supports io_uring, userspace still can/might disable that
>> supporting by set /proc/sys/kernel/io_uring_disabled=2. Let's set
>> it to 0, to always enable io_uring (ignore error if there's not
>> that file).
>> 
>> Signed-off-by: Zorro Lang <zlang@kernel.org>
>> ---
>>  common/rc | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/common/rc b/common/rc
>> index 50dde313..966c92e3 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -2317,6 +2317,9 @@ _require_aiodio()
>>  # this test requires that the kernel supports IO_URING
>>  _require_io_uring()
>>  {
>> +	# Force enable io_uring if kernel supports it
>> +	sysctl -w kernel.io_uring_disabled=0 &> /dev/null
>
> _require_XXX functions are supposed to be predicates that _notrun the
> test if XXX isn't configured or available.  Shouldn't this be:
>
> 	local io_uring_knob="$(sysctl --values kernel.io_uring_disabled)"
> 	test "$io_uring_knob" -ne 0 && _notrun "io_uring disabled by admin"

That sounds like a good option to me.

> Alternately -- if it _is_ ok to turn this knob, then there should be a
> cleanup method to put it back after the test.

I think it would be better not to change the setting, especially if the
admin had disabled it.

Cheers,
Jeff

>
> --D
>
>> +
>>  	$here/src/feature -R
>>  	case $? in
>>  	0)
>> -- 
>> 2.43.0
>> 
>> 


