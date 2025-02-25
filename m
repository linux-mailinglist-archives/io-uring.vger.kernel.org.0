Return-Path: <io-uring+bounces-6732-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E532EA4383D
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 09:53:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C5377A9016
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 08:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 975D226560F;
	Tue, 25 Feb 2025 08:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DYS6oz7j"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C1A262D25
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 08:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740473540; cv=none; b=GcQaeutzU+YDdbSKPRHNdpcfzfCTfXULuROyAMiH5SGyfilAlJLUA1xjKLLW6n6yrdZsZOeC26C1ShhaP2/bv6+mMKi2wwTHy6TwvFSTC4ZvzoL+BmTuWk/T3y1mHj+NAx8GYIwyLP6+tbM18ZS8szgkH9MHEaOkFBNVufFZijA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740473540; c=relaxed/simple;
	bh=6AVs8XJ4mc7ZUXZHOTy1gk0PXYPAPQJ8+VMRBLSisyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nB6IlHxLv0P8GkaVasDQgT72012sO1Riykg03lql6DakhqwxnZ2tQTyG2cCaWnRf5vDpIU0kuGty2TsE++C2u4RiaNQ+HSKFLZcbnTKuEuQMhA4MT8Pflwmn2ET2Q2FOMIOD4hwaXVFkB/rqSgREU5zWP91K0F6441evjEx5r6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DYS6oz7j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740473537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EFoRbSMoXQTA+56zYXSjGU4fdlX3cjng4F4BmGZ4tVU=;
	b=DYS6oz7jjph+P63bSESsWPHK4wsXcCdrprj/CSKw6lJBc9FGoN+Rzvx73q9crGT8CfHmA0
	xq3/DYGPHBQmez+sHcl7bL0r/Qx1JevFQOXAmp5caPW298IdDp7weHmMfgQw3TxgyjWfgN
	9Ray936Cf2pBUTaYQrD5WVeLn+0p7YU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-179-ISLvie4EM0CteLPIqyGCBw-1; Tue,
 25 Feb 2025 03:52:14 -0500
X-MC-Unique: ISLvie4EM0CteLPIqyGCBw-1
X-Mimecast-MFC-AGG-ID: ISLvie4EM0CteLPIqyGCBw_1740473533
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00DB81979057;
	Tue, 25 Feb 2025 08:52:13 +0000 (UTC)
Received: from fedora (unknown [10.72.120.31])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0FCD19560B9;
	Tue, 25 Feb 2025 08:52:06 +0000 (UTC)
Date: Tue, 25 Feb 2025 16:52:00 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	csander@purestorage.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv5 04/11] io_uring/nvme: pass issue_flags to
 io_uring_cmd_import_fixed()
Message-ID: <Z72EsOV5J5sDm8IZ@fedora>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-5-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224213116.3509093-5-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Feb 24, 2025 at 01:31:09PM -0800, Keith Busch wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> io_uring_cmd_import_fixed() will need to know the io_uring execution
> state in following commits, for now just pass issue_flags into it
> without actually using.
> 
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


