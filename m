Return-Path: <io-uring+bounces-8459-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32A91AE5EA2
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 10:04:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CACF4035BC
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 08:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C102D2550D2;
	Tue, 24 Jun 2025 08:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c4JqZ7Td"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0EE1AB6F1
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 08:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750752236; cv=none; b=UK2h3aKFqzChDG6KLOO8MCdcIsKhNAwP2sV9yX6nah4UEhLCNT1geiYtBTIUZ32h+o24VQVa8PP/pn/ExmE4K+qJ4OFhRnhEgdwDA3mCWJUPB3FkWCG/So2eeifoSQa8GRMuiydqqicXso+OYmR634626ekPaV66OSHbkdj8eIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750752236; c=relaxed/simple;
	bh=ZUXY2YGM1ZyiMRvTcci8TrV3AET4pzyhTTVuIyOjZH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2VY08d/mskaeeguLtDSoQVJvm5O3iLNoIq+wWjY9QUqruDo2av0arThgoyaP08kvsAonslf5vaRXSiXoocuudE2H+0pUrcn0eXORIy8h4bjZH0jNIkyCeZotDtFbK9vAdyWf+N5mpNut8nupTBVtCP6CSqjEllKooCPO9r5RCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c4JqZ7Td; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750752233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E1eiWyR4pvANqmCeGgWrAPDFaNKRog5D/Lez74zjrX4=;
	b=c4JqZ7TdkHASVfLAWXcHhMT7rIIIbVuaXwbo4kC+43el5E8Ebga0wHlD7b2acjtxiS/MZK
	AyAXnxkvGDoM8lwPX3FfcL1oYFNi/gxktdZC+kocJBTMQd9XEMXoRZj7rWf4Ko0kOlFicj
	eF9plmfWtCv6t4+5NbUr5UcZmIaLEWM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-1bhA0r3DNPqwEusgEfDSIg-1; Tue,
 24 Jun 2025 04:03:49 -0400
X-MC-Unique: 1bhA0r3DNPqwEusgEfDSIg-1
X-Mimecast-MFC-AGG-ID: 1bhA0r3DNPqwEusgEfDSIg_1750752228
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACBD919560B3;
	Tue, 24 Jun 2025 08:03:48 +0000 (UTC)
Received: from fedora (unknown [10.72.116.86])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE41D195608D;
	Tue, 24 Jun 2025 08:03:45 +0000 (UTC)
Date: Tue, 24 Jun 2025 16:03:40 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Changhui Zhong <czhong@redhat.com>
Cc: Linux Block Devices <linux-block@vger.kernel.org>,
	io-uring@vger.kernel.org
Subject: Re: [bug report] WARNING: CPU: 3 PID: 175811 at
 io_uring/io_uring.c:2921 io_ring_exit_work+0x155/0x288
Message-ID: <aFpb3BjH4T8q8KAY@fedora>
References: <CAGVVp+UFKKb4ydw1+zWX9Bre6vt9TUFt9FY2qOx0LMv+8VaVoA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGVVp+UFKKb4ydw1+zWX9Bre6vt9TUFt9FY2qOx0LMv+8VaVoA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Jun 24, 2025 at 01:37:55PM +0800, Changhui Zhong wrote:
> Hello,
> 
> the following warnning info was triggered by ubdsrv  generic/004 tests,
> please help check and let me know if you need any info/test, thanks.
> 
> repo: https://github.com/torvalds/linux.git
> branch: master
> INFO: HEAD of cloned kernel
> commit 86731a2a651e58953fc949573895f2fa6d456841
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Jun 22 13:30:08 2025 -0700
> 
>     Linux 6.16-rc3
> 
> 
> reproducer:
> # echo 0 > /proc/sys/kernel/io_uring_disabled
> # modprobe ublk_drv
> # for i in {0..30};do make test T=generic; done

Hi Changhui,

Please try the fix for your yesterday's report:

https://lore.kernel.org/linux-block/20250624022049.825370-1-ming.lei@redhat.com/

The same test can survive for hours in my VM with the fix.


Thanks,
Ming


