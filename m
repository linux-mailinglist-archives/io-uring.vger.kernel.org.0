Return-Path: <io-uring+bounces-7383-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81BB9A7B217
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 00:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77C013ADEAD
	for <lists+io-uring@lfdr.de>; Thu,  3 Apr 2025 22:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA071A317E;
	Thu,  3 Apr 2025 22:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="gnm12t4z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f97.google.com (mail-io1-f97.google.com [209.85.166.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E8B161320
	for <io-uring@vger.kernel.org>; Thu,  3 Apr 2025 22:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743720166; cv=none; b=qrgMJmQovE9zeHbvK3vyqu3G8+ORexc4iUFS/oJEzNrDW7VdypeyKiDWaLs3COpb62S9G4rou3hBunLO7i7mgMk7OX70YrvOZNimujXJbn001oViebo0HZb9XVkUo2tcK4UQs6eHZ3WhYZjT0kCDVEEGmtLuiOLheouokXvpR40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743720166; c=relaxed/simple;
	bh=vfs3VHcawB/yC02B4J0KLWaM3f31SfSDKh3KGfOFRyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LNOJmrXXkzwoNXLga+e116tHgGtjvCXUBeyQPMecpacQZaANCGbQbQB6gkkDx/Ix91nf0KpMa4WowgMITauYLXQs5naKxhSjulocOrZnC5mKbFsHZWlHLjin+4jR7dO0ajdPjlUhMGQuPzBNi71OQC2ahX1VFJg1bsha/JPOYeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=gnm12t4z; arc=none smtp.client-ip=209.85.166.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-io1-f97.google.com with SMTP id ca18e2360f4ac-85e1b1f08a5so35719839f.2
        for <io-uring@vger.kernel.org>; Thu, 03 Apr 2025 15:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1743720162; x=1744324962; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FmtFk+6EqC+gt3hg2EoodR+DyksuAw8MFw/rtAVdg2I=;
        b=gnm12t4zbXEomB6VnypRKF73Dh/i5HG8y2TGG8MGvCRoqsz04ALNgXKA3VDxeRlhRl
         JMmKa82m6uEZQQfyTdFmodIkcKylVi7Aav3q3XygmzPJKpAyzWCP4GdQFAXRE96ddT0w
         DN0e51JdocCTo2SsdvvXeWt2O7zJxkPW1Hu22xRZUnTj77hBzBTzV0slSjUJyEOnkYWk
         bPIZyTYkGpM/8IKJiBaDfL+ElXU4XKCXbW7wKfRS93LtzEsSPbdvibdudYjj7KPpQfiJ
         io1Y+baEqc873jSHbt1kAqUHCB/N7Wus7A5YUrt7HxRs+78RyTK+UQI4RU/E8Ie6SFEX
         Cz+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743720162; x=1744324962;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FmtFk+6EqC+gt3hg2EoodR+DyksuAw8MFw/rtAVdg2I=;
        b=QwXQ9fMmSge89Um4B4KRL6lGKDDLyo6/IGMs6eGVo9rbaBIlkChwdKbGBpKJ9XBlDx
         MXzekbQMFLQMwoA51TAUsheNJGqFWWk/Mf7ZDX0dbEOiOF0bMPXIFdIjhr4zaWGVORtC
         dN4Ky+Q2Cbp6FEpnuRzxJdb25z/4Rpi/oLV8wm7pgV5EZipmaWajnk0xOwsft0FJMMY5
         eSqyQICxZB9RjQo3BIItPkxGn8DP6tAaOWmEgXK/dnR5G5P7VwpsxNSK1imN63OPTs+h
         PzFY8p1ypUBRHTl03GWDGstLisemNlzBIuJfk8zmESPvA3XgCPUL2GTtz8kSeFuh2orp
         hTqg==
X-Forwarded-Encrypted: i=1; AJvYcCVeX/9hCw6QGKKjK7x4z1KSEhiI3PQE/GDGQLDWNKvbysnm9i/jkm7kEfYZPGTaC2CKxutQ+nT6Dg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxdK/SgJzixnf4gH6fcPxez0w5FBWPlds/u1Uxc4I7bH9kpF2zK
	n+2Uk4aIKJNjj8qI3u5OUE4NM5Linu5gyhNNsjvdI+Me9KX8C/Lb+dBJadw3xdm9ohQjG+j4nJT
	oCzSeg9dYUpA7zdr02lOhXWYiV4yH90xIs8WLObE8t6YvK4ST
X-Gm-Gg: ASbGncuL8ltorv7sYkf+aQkqLXqSw35rJ929apO6delEI1gXur1y1DqSo2j3bYIz5Pl
	Me9fj67A3TtpYL4pyq/J/uQXHf9uesETwviiDt7foQHqngU/oKvWExlaBs8+x70yyITJmLW+5FF
	RPol7QcDRwNUwZzqnOU65cBNxfbH01d1/yszd+DcqNxc4k2CNlg1fnc1ZdbjHmwdDJcYVnCxZoN
	uYmb3ylzRBT6R0z6iJPfTDoDzDrZWJU/YIiNVhslB6yufnv9tJYtBsV2tafupmyZsE6CfjNRvmK
	3Sp5CAhGQik7sHMiZuMo7r+L+wgI/QgKkNc=
X-Google-Smtp-Source: AGHT+IGzfSzXcqiAGalhEvTBGg0IrSpwEobFJSJEIXog/u4CzdlQNs/iWNb2aMlRI7RB/tAr5gRDWIcched6
X-Received: by 2002:a05:6e02:17c7:b0:3d6:d01e:7314 with SMTP id e9e14a558f8ab-3d6e3f5fa19mr13355885ab.16.1743720162557;
        Thu, 03 Apr 2025 15:42:42 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3d6de79f72esm4197045ab.9.2025.04.03.15.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 15:42:42 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com (dev-ushankar.dev.purestorage.com [10.7.70.36])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id BECF6342115;
	Thu,  3 Apr 2025 16:42:40 -0600 (MDT)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
	id B2677E40EAA; Thu,  3 Apr 2025 16:42:40 -0600 (MDT)
Date: Thu, 3 Apr 2025 16:42:40 -0600
From: Uday Shankar <ushankar@purestorage.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH 4/4] selftests: ublk: enable zero copy for stripe target
Message-ID: <Z+8O4Hro3QeNenjE@dev-ushankar.dev.purestorage.com>
References: <20250325135155.935398-1-ming.lei@redhat.com>
 <20250325135155.935398-5-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325135155.935398-5-ming.lei@redhat.com>

On Tue, Mar 25, 2025 at 09:51:53PM +0800, Ming Lei wrote:
> Use io_uring vectored fixed kernel buffer for handling stripe IO.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  tools/testing/selftests/ublk/Makefile |  1 +
>  tools/testing/selftests/ublk/stripe.c | 69 ++++++++++++++++++++-------
>  2 files changed, 53 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/ublk/Makefile b/tools/testing/selftests/ublk/Makefile
> index d98680d64a2f..c7781efea0f3 100644
> --- a/tools/testing/selftests/ublk/Makefile
> +++ b/tools/testing/selftests/ublk/Makefile
> @@ -17,6 +17,7 @@ TEST_PROGS += test_loop_05.sh
>  TEST_PROGS += test_stripe_01.sh
>  TEST_PROGS += test_stripe_02.sh
>  TEST_PROGS += test_stripe_03.sh
> +TEST_PROGS += test_stripe_04.sh

This patch is missing the new file test_stripe_04.sh, causing ublk
selftests to be broken on block/for-next. Can you fix?


