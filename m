Return-Path: <io-uring+bounces-9064-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5398B2C730
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 16:37:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 280561C20989
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 14:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070AD258ED1;
	Tue, 19 Aug 2025 14:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Muf+/2Pv"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56952202C30
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 14:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755614113; cv=none; b=WM0Omt6ZZ3iqn4P/zUzLfHUMy+eFvFz0O1j9JSIAqlzEBIhn+eXfTeoSu/CcAM85usJembpNcXpYdJt9V/o3xNHn4uuEjGrFPj06ZDcGjm+OqnSMPvZ3uMK7tawui48YJGWvABW2Y4u+ys+zacHMBDbsglvnxqpbLqBS24qYwfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755614113; c=relaxed/simple;
	bh=CThR5NvHCdxcO7a2eTEkjeFZ2tfrfu3suYCFRyWpVjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ltn+hzl5X+MEIKcJ1STViiFM20AoswaqGIfPdLD3fz8a3nF0e+y+hdhsb3x3I8tjcpTlLweWc6cNYtppfJLl7PHaQ+TRhtySOUvh908XcX8N1aLpIX78bWmRYlZ23VkJryas2sTY8E5tvCgEMjavU9a2h6p+0ukPnoczQnZDyuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Muf+/2Pv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755614110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CThR5NvHCdxcO7a2eTEkjeFZ2tfrfu3suYCFRyWpVjM=;
	b=Muf+/2Pvp5OZHgtz3CvtnhBOeMvE56x97KQzSa7cb7YQL4jbVGKShrEV8IHAUWwAdNXx+n
	3VhufNPS2wydieCr8JXwiy4vxM/XBF+w6o2/mpMY/lKvEFXvFRO+f39brgGmL1AiPrEQNI
	uEsp7nsMvQ+6cjIvH7vABh8KEsOSq48=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-M2nJ4T-7MRujqT8jVT9tBQ-1; Tue,
 19 Aug 2025 10:35:06 -0400
X-MC-Unique: M2nJ4T-7MRujqT8jVT9tBQ-1
X-Mimecast-MFC-AGG-ID: M2nJ4T-7MRujqT8jVT9tBQ_1755614105
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 313E51977018;
	Tue, 19 Aug 2025 14:35:05 +0000 (UTC)
Received: from fedora (unknown [10.72.116.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C82B1180047F;
	Tue, 19 Aug 2025 14:35:01 +0000 (UTC)
Date: Tue, 19 Aug 2025 22:34:55 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH V2] io_uring: uring_cmd: add multishot support
Message-ID: <aKSLjwcqr1Mq3AES@fedora>
References: <20250819114532.959011-1-ming.lei@redhat.com>
 <9290b8d7-d982-4356-ac7f-e9fd0caea042@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9290b8d7-d982-4356-ac7f-e9fd0caea042@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Aug 19, 2025 at 08:11:23AM -0600, Jens Axboe wrote:
> Added a comment on v1, but outside of that, do where's the ublk patch
> utilizing this? Would be nice to see that, too.

It is one big patchset, which depends on this single io-uring patch only,
so I don't post them out together.

Here is the whole patchset:

https://github.com/ming1/linux/commits/ublk-devel/

Basically any ublk IO request comes from /dev/ublkbN, its tag is filled
to the multishot command's provided buffer, then we can avoid per-IO
uring_cmd. Communication cost is reduced a lot, also helps much for
killing ublk server pthread context binding with driver.


Thanks,
Ming


