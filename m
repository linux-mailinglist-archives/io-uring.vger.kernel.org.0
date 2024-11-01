Return-Path: <io-uring+bounces-4292-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A580E9B8924
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 03:12:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BA0C1F22CAC
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 02:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8BBA136337;
	Fri,  1 Nov 2024 02:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VosGnTF+"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CDC13211F
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 02:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730427166; cv=none; b=CDnWMPhIpKAUNpJ8iUB4zMY5+0PvMGp8n7BwkGk6Vp8Opkt3L03XTB2EGhLzTldctbVatcuOew+3rWv5atJM+/Rwv/cStEgsXup1HlNCJV+FE0/fc+7WbN3ANE3ruY0J2tAEMd/1m9oSWLoZU5+eHhG/ZtaP1vrQO3jLySikUis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730427166; c=relaxed/simple;
	bh=SEzikhvpVLybFDSyEh91uXbjppHicVNrz/pV5kSY2Cc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HV72GLmj8Q5rMAJncLJyq9lF707VRpnoshPWMKVVSogEoTMKlIwBj0LTTn6fSmnhAYpwk0hrjy6+VM1y0l7YH+5WatZdNFzcTeZR2e/yM+h1SJS9YAqrr+zhtbGOZ76TKSEd+SrKjKPYaYlKPDsyPVUyLOrnu5HdWHxMMDh5wgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VosGnTF+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730427159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b4SshjtHK34aqEvxsbbFBPVx4OGnFcMVdOd7pj+dbm4=;
	b=VosGnTF+2U92fHNDaLmpgHmZVNau7QnU0KUEOHmkHwptiqEt3K4ePHrDi29KG3klZavdu5
	anREPFSx/OENNUDWIXLkrmFUMnLWvMlctZcq/oPDclZKZnU8DBl4plg4+wmgDJKg9zMSxj
	D/y1cMOycGmICl27xvXDvC97aKm4zFY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-X46uZTTxNhOl1QfJsYrs5A-1; Thu,
 31 Oct 2024 22:12:35 -0400
X-MC-Unique: X46uZTTxNhOl1QfJsYrs5A-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7AFEE195608A;
	Fri,  1 Nov 2024 02:12:34 +0000 (UTC)
Received: from fedora (unknown [10.72.116.63])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 091BB1956052;
	Fri,  1 Nov 2024 02:12:30 +0000 (UTC)
Date: Fri, 1 Nov 2024 10:12:25 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>, ming.lei@redhat.com
Subject: Re: [PATCH RFC] io_uring: extend io_uring_sqe flags bits
Message-ID: <ZyQ5CcwfLhaASvMz@fedora>
References: <e60a3dd3-3a74-4181-8430-90c106a202f6@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e60a3dd3-3a74-4181-8430-90c106a202f6@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Oct 31, 2024 at 03:22:18PM -0600, Jens Axboe wrote:
> In hindsight everything is clearer, but it probably should've been known
> that 8 bits of ->flags would run out sooner than later. Rather than
> gobble up the last bit for a random use case, add a bit that controls
> whether or not ->personality is used as a flags2 argument. If that is
> the case, then there's a new IOSQE2_PERSONALITY flag that tells io_uring
> which personality field to read.
> 
> While this isn't the prettiest, it does allow extending with 15 extra
> flags, and retains being able to use personality with any kind of
> command. The exception is uring cmd, where personality2 will overlap
> with the space set aside for SQE128. If they really need that, then that

The space is the 1st `short` for uring_cmd, instead of SQE128 only.

Also it is overlapped with ->optval and ->addr3, so just wondering why not
use ->__pad2?

Another ways is to use __pad2 for sqe2_flags for non-uring_cmd, and for
uring_cmd, use its top 16 as sqe2_flags, this way does work, but it is
just a bit ugly to use.


Thanks,
Ming


