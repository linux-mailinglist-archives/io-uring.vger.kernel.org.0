Return-Path: <io-uring+bounces-7362-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09EC4A78946
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 09:57:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC54616F825
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 07:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C818F233D8C;
	Wed,  2 Apr 2025 07:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GAbdN4xe"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1915C23373E
	for <io-uring@vger.kernel.org>; Wed,  2 Apr 2025 07:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743580655; cv=none; b=TeSj2UoPGcCbmvPjV4Wmoyr3R1ORubO5JD4UmQn2qiJ1WgK4hT7tVAfX7dJ0VLy3h4MT9ZL/bPFL4mKjevEyRW4QXuLkN+5N9tuWYm64P44dYvtzAzl6u2yo6kG5V+ojDDqyuCracRAxBQkOeHWyQM1mkRLm+AbCsdfk3M1Q8OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743580655; c=relaxed/simple;
	bh=Stxxg4bTLFvfm6LUTBHiRRnpm/X5LFPbNrurlerG2Uw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NCb15072zo9xKaU6Oz1KlTuPnYOMH46LJb/PiPFi5tfF6tMDRaOJZOtnHWv+foPAWO10ErzAJn7tMUOX9pTPbZIr/akDAfzdlksssRDFmy8JYVKozkR8AM/fFfIFZNjQZiaFxgtmB7fVHJMtUogbGtRHZEicdyMeCAu9gMtHN2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GAbdN4xe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743580652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cSasA+WefhQs7bG5kD0iv0HjnCfC2M60m7OuFakfTGM=;
	b=GAbdN4xefnOzmQE8oTU2W0bRS6Kby/RAn4sbfMTz4B2O7813NMFOie4Jx2TbQnwpgk7U22
	j+w/nTCpubDkMHtEX9OZZf2GnHsCzOzlmmk/H8700pF2P0o3tm1kdr7teYfmdY6FNyQ7hr
	+4LvljvMqRQOHKBR0UWbb/WoEMYRh9s=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-388-NUDBmPD0MquvGjPgaBrvnA-1; Wed,
 02 Apr 2025 03:57:28 -0400
X-MC-Unique: NUDBmPD0MquvGjPgaBrvnA-1
X-Mimecast-MFC-AGG-ID: NUDBmPD0MquvGjPgaBrvnA_1743580647
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 406A31956087;
	Wed,  2 Apr 2025 07:57:27 +0000 (UTC)
Received: from fedora (unknown [10.72.120.32])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D2E13001D0E;
	Wed,  2 Apr 2025 07:57:22 +0000 (UTC)
Date: Wed, 2 Apr 2025 15:57:17 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH 0/4] io_uring: support vectored fixed kernel buffer
Message-ID: <Z-zt3YraxRSHVIWv@fedora>
References: <20250325135155.935398-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325135155.935398-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Mar 25, 2025 at 09:51:49PM +0800, Ming Lei wrote:
> Hello Jens,
> 
> This patchset supports vectored fixed buffer for kernel bvec buffer,
> and use it on for ublk/stripe.
> 
> Please review.
> 
> Thanks,
> Ming
> 
> 
> Ming Lei (4):
>   io_uring: add validate_fixed_range() for validate fixed buffer
>   block: add for_each_mp_bvec()
>   io_uring: support vectored kernel fixed buffer
>   selftests: ublk: enable zero copy for stripe target

Hello,

Ping...


Thanks,
Ming


